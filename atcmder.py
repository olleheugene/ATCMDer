import sys
from PySide6.QtWidgets import QApplication
from serial_terminal import SerialTerminal
import utils

COMMON_THEME_QSS = """
QWidget#collapseRail,
QWidget#collapseButtonShell,
QWidget#sidePanel {
    border: none;
}

QCheckBox::indicator:checked {
    image: url(resources/checkmark.svg);
}

QCheckBox::indicator {
    width: 14px;
    height: 14px;
}

QSplitter::handle {
    background-color: transparent;
    border: none;
}

QSplitter::handle:horizontal {
    width: 1px;
}

QSplitter::handle:vertical {
    height: 1px;
}
"""

WEB_DIVIDER_QSS = """

QFrame#collapseButtonDivider {
    background-color: transparent;
    image: url(resources/collapse-divider.svg);
    border: none;
}
"""


def load_stylesheet(theme_name):
    theme_path = utils.get_resources(f"{theme_name}.css")
    try:
        with open(theme_path, "r", encoding="utf-8") as f:
            style = f.read()
    except OSError:
        style = ""

    style += "\n" + COMMON_THEME_QSS
    style += "\n" + WEB_DIVIDER_QSS

    for resource_name in ("down_arrow.png", "checkbox.png", "collapse-divider.svg", "checkmark.svg"):
        resource_path = utils.get_resources(resource_name).replace("\\", "/")
        style = style.replace(f"url(resources/{resource_name})", f"url({resource_path})")
    return style


def main():
    app = QApplication(sys.argv)
    app.setStyleSheet(load_stylesheet("web_dark"))

    window = SerialTerminal()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
