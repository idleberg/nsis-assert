
Name "Assert.nsh Examples"
OutFile "Assert.exe"
ShowInstDetails show
RequestExecutionLevel user
Unicode true

!include "Assert.nsh"

; =====================================================================
;  Compile-time assertions
; =====================================================================

!define APP_VERSION "2.0.0"

; Verify a symbol is defined at compile time
${AssertDefined} APP_VERSION

; Verify a symbol is not defined at compile time
${AssertUndefined} NONEXISTENT_SYMBOL

; =====================================================================
;  Runtime assertions
; =====================================================================

Section "Assert"
  ; String comparison
  ${Assert} "hello" == "hello" \
    "strings are equal"

  ; Integer comparison
  ${Assert} 10 > 5 \
    "10 is greater than 5"

  ; Variable comparison
  StrCpy $R0 "expected"
  ${Assert} $R0 == "expected" \
    "variable holds expected value"

  ; Unary operator (FileExists)
  ${Assert} ${FileExists} "$EXEPATH" \
    "installer exe exists"
SectionEnd

Section "AssertNot"
  ; Negated string comparison
  ${AssertNot} "hello" == "world" \
    "hello is not world"

  ; Negated integer comparison
  ${AssertNot} 5 > 10 \
    "5 is not greater than 10"

  ; Negated unary operator
  ${AssertNot} ${FileExists} "$TEMP\__nonexistent__" \
    "nonexistent file does not exist"
SectionEnd

Section "AssertSummary"
  ; Print the final tally and set ErrorLevel on failure
  ${AssertSummary}
SectionEnd
