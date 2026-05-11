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

QSpinBox,
QDoubleSpinBox {
    padding-right: 22px;
}

QSpinBox::up-button,
QDoubleSpinBox::up-button,
QSpinBox::down-button,
QDoubleSpinBox::down-button {
    subcontrol-origin: border;
    width: 18px;
    border: none;
    background-color: transparent;
    border-left: 1px solid rgba(148, 163, 184, 0.35);
}

QSpinBox::up-button,
QDoubleSpinBox::up-button {
    subcontrol-position: top right;
}

QSpinBox::down-button,
QDoubleSpinBox::down-button {
    subcontrol-position: bottom right;
}

QSpinBox::up-arrow,
QDoubleSpinBox::up-arrow {
    image: url(resources/spin_up_light.svg);
    width: 10px;
    height: 10px;
}

QSpinBox::down-arrow,
QDoubleSpinBox::down-arrow {
    image: url(resources/spin_down_light.svg);
    width: 10px;
    height: 10px;
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

    for resource_name in ("down_arrow.png", "up_arrow.png", "spin_up_light.svg", "spin_down_light.svg", "checkbox.png", "collapse-divider.svg", "checkmark.svg"):
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
