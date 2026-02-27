!include "LogicLib.nsh"

!ifndef INSTALLNAME
  !warning `No INSTALLNAME defined, using the generic name "_installer" instead.`
  !define INSTALLNAME "_installer"
!endif

# ──NSIS settings ──────────────────────────────────────────────────────────────

Name "${INSTALLNAME}"
OutFile "${INSTALLNAME}.exe"
ShowInstDetails show
RequestExecutionLevel admin
Unicode true

# ── Detect NSIS directory ─────────────────────────────────────────────────────

!define NSIS_REG "Software\NSIS"

Function .onInit
  ReadRegStr $INSTDIR HKLM "${NSIS_REG}" ""

  ${If} $INSTDIR == ""
    ReadRegStr $INSTDIR HKCU "${NSIS_REG}" ""
  ${EndIf}

  ${If} $INSTDIR == ""
    MessageBox MB_OK|MB_ICONSTOP "Could not find NSIS installation directory."
    Abort
  ${EndIf}
FunctionEnd

# ── Install section ───────────────────────────────────────────────────────────

Section "install"
  !macro _InstallIfExists SrcDir DestSubDir
    !if /FileExists "${SrcDir}\*.*"
      SetOutPath "$INSTDIR\${DestSubDir}"
      File /r "${SrcDir}\*.*"
    !endif
  !macroend

  !insertmacro _InstallIfExists "Include" "Include"
  !insertmacro _InstallIfExists "Examples" "Examples"
  !insertmacro _InstallIfExists "Contrib"  "Contrib"
  !insertmacro _InstallIfExists "Docs"     "Docs"
  !insertmacro _InstallIfExists "Plugins"  "Plugins"
SectionEnd
