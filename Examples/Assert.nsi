; Optional: control verbosity (0 = silent, 1 = errors only, 2 = all results)
; !define __ASSERT_VERBOSITY__ 1

; Optional: abort on first failure (sets ErrorLevel 1)
; !define __ASSERT_FAILFAST__

Name "Assert.nsh Examples"
OutFile "Assert.exe"
ShowInstDetails show
RequestExecutionLevel user
Unicode true

!include "Assert.nsh"

; --- Compile-time assertions ---
!define MY_VERSION "1.0.0"
${AssertDefined}   MY_VERSION
${AssertUndefined} NONEXISTENT_SYMBOL

Section "Binary assertions"
  ; String equality
  ${Assert} "hello" == "hello" \
    "string equality"
  ${Assert} "hello" != "world" \
    "string inequality"
  ${Assert} "" == "" \
    "empty string equality"

  ; Case-sensitive string equality
  ${Assert} "Hello" S== "Hello" \
    "case-sensitive match"
  ${Assert} "Hello" S!= "hello" \
      "case-sensitive mismatch"

  ; Integer comparisons
  ${Assert} 42 == 42 \
    "integer equality"

  ${Assert} 1 < 10 \
    "integer less than"
  ${Assert} 10 > 1 \
    "integer greater than"
  ${Assert} 5 >= 5 \
    "integer greater or equal"
  ${Assert} 5 <= 5 \
    "integer less or equal"

  ; Variable-based assertions
  StrCpy $R0 "Hello World"
  ${Assert} $R0 == "Hello World" \
    "variable equality"
  ${Assert} $R0 != "" \
    "variable not empty"
SectionEnd

Section "Negated assertions"
  ${AssertNot} "hello" == "world" \
    "hello is not world"
  ${AssertNot} "" != "" \
    "empty equals empty"
  ${AssertNot} 5 > 10 \
    "5 is not greater than 10"

  StrCpy $R0 "success"
  ${AssertNot} $R0 == "failure" \
    "result is not failure"
SectionEnd

Section "Unary operators"
  ; FileExists on the NSIS output file (always present during install)
  ${Assert}    ${FileExists} "$EXEPATH" \
  "installer exe exists"
  ${AssertNot} ${FileExists} "$TEMP\__nsis_assert_nonexistent__" \
    "nonexistent file"
SectionEnd

Section "Deliberate failures"
  ${Assert} "hello" == "world" \
    "hello equals world"
  ${AssertNot} "hello" == "hello" \
    "hello differs from hello"
SectionEnd

Section "Summary"
  ${AssertSummary}
SectionEnd
