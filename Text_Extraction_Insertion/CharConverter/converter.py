#!/usr/bin/env python3

import sys
from pathlib import Path

from PyQt5.QtCore import Qt
from PyQt5.QtGui import QFont, QPixmap
from PyQt5.QtWidgets import (
    QApplication,
    QFrame,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QMainWindow,
    QPushButton,
    QVBoxLayout,
    QWidget,
)


# ============================================================
# TBL FILE HANDLING
# ============================================================

def load_tbl(path):
    """
    Load a .tbl file.

    Expected format:

        10=A
        11=B
        12=C
        ...
        FF=<SP>
    """

    table = {}

    with open(path, "r", encoding="utf-8-sig") as file:
        for line in file:
            line = line.strip()

            if not line or "=" not in line:
                continue

            hex_code, character = line.split("=", 1)

            hex_code = hex_code.strip().upper()
            character = character.strip()

            if hex_code:
                table[hex_code] = character

    return table


def make_character_lookup(table):
    """
    Convert:

        10=A
        11=B
        12=C

    into:

        A -> 10
        B -> 11
        C -> 12
    """

    lookup = {}

    for hex_code, character in table.items():

        if len(character) == 1:
            lookup[character] = hex_code

    return lookup


def convert_string(text, source_table, target_table):
    """
    Convert an entire string character by character.

    Character
        ↓
    Source table
        ↓
    Hexadecimal code
        ↓
    Target table
        ↓
    Converted character
    """

    source_lookup = make_character_lookup(
        source_table
    )

    result = []

    missing_source = []
    missing_target = []

    for character in text:

        # ----------------------------------------------------
        # Spaces
        # ----------------------------------------------------

        if character == " ":

            hex_code = "FF"

        else:

            hex_code = source_lookup.get(
                character
            )

        # ----------------------------------------------------
        # Character not found in source table
        # ----------------------------------------------------

        if hex_code is None:

            result.append(character)

            if character not in missing_source:
                missing_source.append(character)

            continue

        # ----------------------------------------------------
        # Look up the same HEX code in the target table
        # ----------------------------------------------------

        converted = target_table.get(
            hex_code
        )

        if converted is None:

            result.append(character)

            item = "{} [code {}]".format(
                repr(character),
                hex_code,
            )

            if item not in missing_target:
                missing_target.append(item)

            continue

        # ----------------------------------------------------
        # Normalize special spaces
        # ----------------------------------------------------

        if converted == "<SP>":
            converted = " "

        elif converted == "　":
            converted = " "

        result.append(
            converted
        )

    return (
        "".join(result),
        missing_source,
        missing_target,
    )


# ============================================================
# IMAGE PANEL
# ============================================================

class ImagePanel(QFrame):

    def __init__(
        self,
        title,
        image_path=None,
        parent=None,
    ):

        super().__init__(parent)

        self.setFrameShape(
            QFrame.StyledPanel
        )

        self.title = QLabel(
            title
        )

        self.title.setAlignment(
            Qt.AlignCenter
        )

        self.title.setStyleSheet(
            "font-weight: bold;"
            "font-size: 15px;"
        )

        self.image_label = QLabel()

        self.image_label.setAlignment(
            Qt.AlignCenter
        )

        self.image_label.setStyleSheet(
            "background-color: #202020;"
            "color: #aaaaaa;"
            "padding: 10px;"
        )

        layout = QVBoxLayout(
            self
        )

        layout.addWidget(
            self.title
        )

        layout.addWidget(
            self.image_label
        )

        self.set_image(
            image_path
        )

    def set_image(self, image_path):

        self.image_path = image_path

        if not image_path:

            self.image_label.setText(
                "No image configured"
            )

            return

        pixmap = QPixmap(
            str(image_path)
        )

        if pixmap.isNull():

            self.image_label.setText(
                "Could not load image"
            )

            return

        self.original_pixmap = pixmap

        # Keep the image at its original PNG size.
        self.image_label.setFixedSize(
            pixmap.width(),
            pixmap.height(),
        )

        self.image_label.setPixmap(
            self.original_pixmap
        )


# ============================================================
# MAIN WINDOW
# ============================================================

class ConverterWindow(QMainWindow):

    def __init__(
        self,
        source_table,
        target_table,
    ):

        super().__init__()

        self.source_table = source_table
        self.target_table = target_table

        # ----------------------------------------------------
        # Window
        # ----------------------------------------------------

        self.setWindowTitle(
            "Font Table Converter"
        )

        central = QWidget()

        self.setCentralWidget(
            central
        )

        root = QVBoxLayout(
            central
        )

        # ====================================================
        # Direction
        # ====================================================

        controls = QHBoxLayout()

        controls.addStretch()

        self.direction_button = QPushButton(
            "Source → Target"
        )

        self.direction_button.clicked.connect(
            self.toggle_direction
        )

        controls.addWidget(
            self.direction_button
        )

        controls.addStretch()

        root.addLayout(
            controls
        )

        # ====================================================
        # Input
        # ====================================================

        root.addWidget(
            QLabel("Input string:")
        )

        self.input_edit = QLineEdit()

        self.input_edit.setPlaceholderText(
            "Enter a string, for example: Hello World"
        )

        self.input_edit.setFont(
            QFont(
                "Sans",
                18,
            )
        )

        self.input_edit.textChanged.connect(
            self.convert
        )

        root.addWidget(
            self.input_edit
        )

        # ====================================================
        # Output
        # ====================================================

        root.addWidget(
            QLabel("Converted string:")
        )

        self.output_edit = QLineEdit()

        self.output_edit.setReadOnly(
            True
        )

        self.output_edit.setFont(
            QFont(
                "Sans",
                18,
            )
        )

        root.addWidget(
            self.output_edit
        )

        # ====================================================
        # Information
        # ====================================================

        self.info_label = QLabel()

        self.info_label.setWordWrap(
            True
        )

        self.info_label.setStyleSheet(
            "color: #666666;"
            "padding: 6px;"
        )

        root.addWidget(
            self.info_label
        )

        # ====================================================
        # Images
        # ====================================================

        images = QHBoxLayout()

        self.source_image_panel = ImagePanel(
            "SOURCE FONT",
            SOURCE_IMAGE,
        )

        self.target_image_panel = ImagePanel(
            "TARGET FONT",
            TARGET_IMAGE,
        )

        images.addWidget(
            self.source_image_panel
        )

        images.addWidget(
            self.target_image_panel
        )

        root.addLayout(
            images
        )

        # ====================================================
        # Status bar
        # ====================================================

        self.statusBar().showMessage(
            "{}: {} entries | {}: {} entries".format(
                Path(SOURCE_TBL).name,
                len(self.source_table),
                Path(TARGET_TBL).name,
                len(self.target_table),
            )
        )

        self.adjustSize()

    # ========================================================
    # Direction
    # ========================================================

    def toggle_direction(self):

        if (
            self.direction_button.text()
            == "Source → Target"
        ):

            self.direction_button.setText(
                "Target → Source"
            )

        else:

            self.direction_button.setText(
                "Source → Target"
            )

        self.convert()

    # ========================================================
    # Conversion
    # ========================================================

    def convert(self):

        text = self.input_edit.text()

        if not text:

            self.output_edit.clear()
            self.info_label.clear()

            return

        if (
            self.direction_button.text()
            == "Source → Target"
        ):

            source_table = self.source_table
            target_table = self.target_table

            source_name = Path(
                SOURCE_TBL
            ).name

            target_name = Path(
                TARGET_TBL
            ).name

        else:

            source_table = self.target_table
            target_table = self.source_table

            source_name = Path(
                TARGET_TBL
            ).name

            target_name = Path(
                SOURCE_TBL
            ).name

        converted, missing_source, missing_target = (
            convert_string(
                text,
                source_table,
                target_table,
            )
        )

        self.output_edit.setText(
            converted
        )

        # ----------------------------------------------------
        # Information
        # ----------------------------------------------------

        message = (
            "{} characters checked: {} → {}"
            .format(
                len(text),
                source_name,
                target_name,
            )
        )

        if missing_source:

            message += (
                "\nNot found in source table: "
                + ", ".join(
                    repr(x)
                    for x in missing_source
                )
            )

        if missing_target:

            message += (
                "\nNo matching target code: "
                + ", ".join(
                    missing_target
                )
            )

        self.info_label.setText(
            message
        )


# ============================================================
# MAIN
# ============================================================

def main():

    # ========================================================
    # CONFIGURATION
    #
    # Change the paths here when using different files.
    # ========================================================

    global SOURCE_TBL
    global TARGET_TBL
    global SOURCE_IMAGE
    global TARGET_IMAGE

    SOURCE_TBL = "FontTable_SPA.tbl"

    TARGET_TBL = "FontTable_JPN.tbl"

    SOURCE_IMAGE = "FontTable_SPA.png"

    TARGET_IMAGE = "FontTable_JPN.png"

    # ========================================================

    base = Path(
        __file__
    ).resolve().parent

    SOURCE_TBL = str(
        base / SOURCE_TBL
    )

    TARGET_TBL = str(
        base / TARGET_TBL
    )

    SOURCE_IMAGE = str(
        base / SOURCE_IMAGE
    )

    TARGET_IMAGE = str(
        base / TARGET_IMAGE
    )

    # --------------------------------------------------------
    # Check required table files.
    # --------------------------------------------------------

    missing = []

    if not Path(SOURCE_TBL).is_file():

        missing.append(
            SOURCE_TBL
        )

    if not Path(TARGET_TBL).is_file():

        missing.append(
            TARGET_TBL
        )

    if missing:

        print(
            "Missing required file(s):"
        )

        for path in missing:

            print(
                "  {}".format(path)
            )

        print()

        print(
            "Put the files next to this script "
            "or change the paths in main()."
        )

        sys.exit(1)

    # --------------------------------------------------------
    # Load tables.
    # --------------------------------------------------------

    source_table = load_tbl(
        SOURCE_TBL
    )

    target_table = load_tbl(
        TARGET_TBL
    )

    # --------------------------------------------------------
    # Start Qt.
    # --------------------------------------------------------

    app = QApplication(
        sys.argv
    )

    window = ConverterWindow(
        source_table,
        target_table,
    )

    window.show()

    sys.exit(
        app.exec_()
    )


if __name__ == "__main__":

    main()