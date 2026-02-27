; ---------------------
;       Assert.nsh
; ---------------------
;
; Runtime assertion library for NSIS, built on top of LogicLib.
;
; Usage:
;
;   Binary assertions (works with all LogicLib operators):
;
;     ${Assert} $R0 == "expected"             "values match"
;     ${Assert} $R0 != ""                     "not empty"
;     ${Assert} $R0 ${StartsWith} "Hello"     "starts with Hello"
;     ${Assert} $R0 ${Contains} "world"       "contains world"
;
;   Negated assertions:
;
;     ${AssertNot} $R0 == "bad"               "must not be bad"
;     ${AssertNot} $R0 ${Contains} "error"    "no errors"
;
;   Unary assertions (prefix-style LogicLib operators):
;
;     ${Assert}    ${FileExists} "$INSTDIR\app.exe"   "app installed"
;     ${AssertNot} ${FileExists} "$TEMP\leftover"     "no leftovers"
;
;   Summary (prints totals, sets ErrorLevel 1 on failure):
;
;     ${AssertSummary}
;
;   Compile-time assertions:
;
;     ${AssertDefined}   MY_VERSION
;     ${AssertUndefined} DEPRECATED_FLAG
;
; Verbosity:
;   Define __ASSERT_VERBOSITY__ before including Assert.nsh.
;   0 = silent, 1 = errors only, 2 = all results (default)
;
;     !define __ASSERT_VERBOSITY__ 1
;     !include "Assert.nsh"
;
; Fail-fast:
;   Define __ASSERT_FAILFAST__ to abort the installer on the first
;   failure.  Sets ErrorLevel 1 before calling Abort.
;
;     !define __ASSERT_FAILFAST__
;     !include "Assert.nsh"

!include LogicLib.nsh

!ifndef ASSERT_INCLUDED
  !define ASSERT_INCLUDED

  !ifndef __ASSERT_VERBOSITY__
    !define __ASSERT_VERBOSITY__ 2
  !endif

  ; --- Counter variables (declared on first use) ---

  !macro _ASSERT_VARS
    !ifndef _ASSERT_VARS_DEFINED
      !define _ASSERT_VARS_DEFINED
      Var /GLOBAL _Assert_Passed
      Var /GLOBAL _Assert_Failed
    !endif
  !macroend

  ; ============================================================
  ;  ${Assert} — runtime assertion (binary and unary)
  ; ============================================================

  !macro Assert _a _op _b _msg
    !insertmacro _ASSERT_VARS
    !insertmacro _IncreaseCounter
    !define _Assert_Ctx ${LOGICLIB_COUNTER}

    !insertmacro _${_op} `${_a}` `${_b}` \
      _Assert_Pass_${_Assert_Ctx} _Assert_Fail_${_Assert_Ctx}

    _Assert_Fail_${_Assert_Ctx}:
      IntOp $_Assert_Failed $_Assert_Failed + 1
      !if ${__ASSERT_VERBOSITY__} >= 1
        DetailPrint 'FAIL [${__FILE__}:${__LINE__}] ${_msg}'
      !endif
      !ifdef __ASSERT_FAILFAST__
        SetErrorLevel 1
        Abort 'Assertion failed [${__FILE__}:${__LINE__}]: ${_msg}'
      !endif
      Goto _Assert_Done_${_Assert_Ctx}

    _Assert_Pass_${_Assert_Ctx}:
      IntOp $_Assert_Passed $_Assert_Passed + 1
      !if ${__ASSERT_VERBOSITY__} >= 2
        DetailPrint 'PASS [${__FILE__}:${__LINE__}] ${_msg}'
      !endif

    _Assert_Done_${_Assert_Ctx}:
    !undef _Assert_Ctx
  !macroend
  !define Assert `!insertmacro Assert`

  ; ============================================================
  ;  ${AssertNot} — negated assertion
  ; ============================================================

  !macro AssertNot _a _op _b _msg
    !insertmacro _ASSERT_VARS
    !insertmacro _IncreaseCounter
    !define _Assert_Ctx ${LOGICLIB_COUNTER}

    ; Swap true/false branches to negate the condition
    !insertmacro _${_op} `${_a}` `${_b}` \
      _Assert_Fail_${_Assert_Ctx} _Assert_Pass_${_Assert_Ctx}

    _Assert_Fail_${_Assert_Ctx}:
      IntOp $_Assert_Failed $_Assert_Failed + 1
      !if ${__ASSERT_VERBOSITY__} >= 1
        DetailPrint 'FAIL [${__FILE__}:${__LINE__}] ${_msg}'
      !endif
      !ifdef __ASSERT_FAILFAST__
        SetErrorLevel 1
        Abort 'Assertion failed [${__FILE__}:${__LINE__}]: ${_msg}'
      !endif
      Goto _Assert_Done_${_Assert_Ctx}

    _Assert_Pass_${_Assert_Ctx}:
      IntOp $_Assert_Passed $_Assert_Passed + 1
      !if ${__ASSERT_VERBOSITY__} >= 2
        DetailPrint 'PASS [${__FILE__}:${__LINE__}] ${_msg}'
      !endif

    _Assert_Done_${_Assert_Ctx}:
    !undef _Assert_Ctx
  !macroend
  !define AssertNot `!insertmacro AssertNot`

  ; ============================================================
  ;  ${AssertSummary} — print totals and set error level
  ; ============================================================

  !macro AssertSummary
    !insertmacro _ASSERT_VARS
    ; Normalize empty to "0" in case no assertions ran
    StrCmp $_Assert_Passed "" 0 +2
      StrCpy $_Assert_Passed 0
    StrCmp $_Assert_Failed "" 0 +2
      StrCpy $_Assert_Failed 0
    DetailPrint "$_Assert_Passed passed, $_Assert_Failed failed"
    ${If} $_Assert_Failed > 0
      SetErrorLevel 1
    ${EndIf}
  !macroend
  !define AssertSummary `!insertmacro AssertSummary`

  ; ============================================================
  ;  Compile-time assertions
  ; ============================================================

  !macro AssertDefined _sym
    !ifndef ${_sym}
      !error "Assertion failed: ${_sym} is not defined"
    !endif
  !macroend
  !define AssertDefined `!insertmacro AssertDefined`

  !macro AssertUndefined _sym
    !ifdef ${_sym}
      !error "Assertion failed: ${_sym} should not be defined"
    !endif
  !macroend
  !define AssertUndefined `!insertmacro AssertUndefined`

!endif ; ASSERT_INCLUDED
