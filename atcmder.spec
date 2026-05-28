# -*- mode: python ; coding: utf-8 -*-
import os
import sys

app_name = 'atcmder'
target_arch = os.environ.get('PYINSTALLER_TARGET_ARCH') or None

def collect_resources():
    data_files = []
    resource_dir = 'resources'
    excluded = {'.DS_Store'}
    if sys.platform == "darwin":
        excluded.add('app_icon.ico')
    elif sys.platform == "win32":
        excluded.add('app_icon.icns')
    else:
        excluded.update({'app_icon.ico', 'app_icon.icns'})

    if os.path.exists(resource_dir):
        for fname in os.listdir(resource_dir):
            if fname in excluded:
                continue
            full_path = os.path.join(resource_dir, fname)
            if os.path.isfile(full_path):
                data_files.append((full_path, resource_dir))
    return data_files

def get_resources(resource_file):
    if hasattr(sys, '_MEIPASS'):
        path = os.path.join(sys._MEIPASS, "resources", resource_file)
    else:
        path = os.path.join("resources", resource_file)
    return path

if sys.platform == "win32":
    icon_file = "resources/app_icon.ico"
elif sys.platform == "darwin":
    icon_file = "resources/app_icon.icns"
else:
    icon_file = "resources/app_icon.png"


binaries = []
hiddenimports = [
    'serial_terminal',
    'utils',
    'serial',
    'serial.tools.list_ports',
    'serial.tools.list_ports_osx',
]

excluded_modules = [
    'PySide6.Qt3DAnimation',
    'PySide6.Qt3DCore',
    'PySide6.Qt3DExtras',
    'PySide6.Qt3DInput',
    'PySide6.Qt3DLogic',
    'PySide6.Qt3DRender',
    'PySide6.QtBluetooth',
    'PySide6.QtCharts',
    'PySide6.QtDataVisualization',
    'PySide6.QtDesigner',
    'PySide6.QtHelp',
    'PySide6.QtLocation',
    'PySide6.QtMultimedia',
    'PySide6.QtMultimediaWidgets',
    'PySide6.QtNetwork',
    'PySide6.QtNfc',
    'PySide6.QtPdf',
    'PySide6.QtPdfWidgets',
    'PySide6.QtPositioning',
    'PySide6.QtQml',
    'PySide6.QtQuick',
    'PySide6.QtQuick3D',
    'PySide6.QtQuickControls2',
    'PySide6.QtQuickWidgets',
    'PySide6.QtRemoteObjects',
    'PySide6.QtScxml',
    'PySide6.QtSensors',
    'PySide6.QtSerialPort',
    'PySide6.QtSql',
    'PySide6.QtTest',
    'PySide6.QtUiTools',
    'PySide6.QtWebChannel',
    'PySide6.QtWebEngineCore',
    'PySide6.QtWebEngineQuick',
    'PySide6.QtWebEngineWidgets',
    'PyQt5',
    'PyQt6',
    'matplotlib',
    'numpy',
    'pandas',
    'scipy',
    'yaml._yaml',
]

a = Analysis(
    ['atcmder.py'],
    pathex=['.'],
    binaries=binaries,
    datas=collect_resources(),
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=excluded_modules,
    noarchive=False,
    optimize=2,
)
pyz = PYZ(a.pure)


if sys.platform.startswith('darwin'):
    app = BUNDLE(
        EXE(
            pyz,
            a.scripts,
            a.binaries,
            a.datas,
            [],
            name=app_name,
            debug=False,
            bootloader_ignore_signals=False,
            strip=True,
            upx=True,
            upx_exclude=[],
            runtime_tmpdir=None,
            console=False,
            windowed=True,
            icon=icon_file,
            disable_windowed_traceback=False,
            argv_emulation=False,
            target_arch=target_arch,
            codesign_identity=None,
            entitlements_file=None,
        ),
        name='atcmder.app',
        icon=icon_file,
        bundle_identifier=None
    )
else:
    exe = EXE(
        pyz,
        a.scripts,
        a.binaries,
        a.zipfiles,
        a.datas,
        [],
        name=app_name,
        debug=False,
        bootloader_ignore_signals=False,
        strip=False,
        upx=True,
        console=False,
        windowed=True,
        icon=icon_file,
        disable_windowed_traceback=False,
        argv_emulation=False,
        target_arch=target_arch,
        codesign_identity=None,
        entitlements_file=None,
    )
