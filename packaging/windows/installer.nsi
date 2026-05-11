!include "MUI2.nsh"

!ifndef APP_VERSION
  !define APP_VERSION "0.0.0"
!endif

!ifndef APP_EXE
  !define APP_EXE "dist\atcmder.exe"
!endif

!ifndef OUTPUT_FILE
  !define OUTPUT_FILE "release\atcmder-windows-setup.exe"
!endif

Name "AT Commander ${APP_VERSION}"
OutFile "${OUTPUT_FILE}"
InstallDir "$PROGRAMFILES64\ATCMDer"
InstallDirRegKey HKCU "Software\ATCMDer" ""
RequestExecutionLevel Admin

!define MUI_ABORTWARNING
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "Install"
  SetOutPath "$INSTDIR"
  File "${APP_EXE}"
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  CreateDirectory "$SMPROGRAMS\ATCMDer"
  CreateShortcut "$SMPROGRAMS\ATCMDer\ATCMDer.lnk" "$INSTDIR\atcmder.exe"
  CreateShortcut "$SMPROGRAMS\ATCMDer\Uninstall ATCMDer.lnk" "$INSTDIR\Uninstall.exe"
  CreateShortcut "$DESKTOP\ATCMDer.lnk" "$INSTDIR\atcmder.exe"

  WriteRegStr HKCU "Software\ATCMDer" "" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ATCMDer" "DisplayName" "ATCMDer"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ATCMDer" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ATCMDer" "Publisher" "AT Commander"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ATCMDer" "UninstallString" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
  Delete "$INSTDIR\atcmder.exe"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$DESKTOP\ATCMDer.lnk"
  Delete "$SMPROGRAMS\ATCMDer\ATCMDer.lnk"
  Delete "$SMPROGRAMS\ATCMDer\Uninstall ATCMDer.lnk"
  RMDir "$SMPROGRAMS\ATCMDer"
  RMDir "$INSTDIR"
  DeleteRegKey HKCU "Software\ATCMDer"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ATCMDer"
SectionEnd
