# Assert

A runtime assertion library for [NSIS](https://nsis.sourceforge.io/), built on top of LogicLib.

## Installation

```powershell
makensis -DINSTALLNAME=Assert installme.nsi
```

Alternatively, copy the contents of `Include\` to `${NSISDIR}\Include\`:

```
NSIS\Include\Assert.nsh
```

## Usage

```nsis
!include "Assert.nsh"
```

## Macros

### Runtime assertions

`${Assert}` and `${AssertNot}` work with all LogicLib operators (binary and unary).

```nsis
; Binary assertions
${Assert}    $R0 == "expected"                  "values match"
${Assert}    $R0 != ""                          "not empty"
${Assert}    1 < 10                             "less than"

; Negated assertions
${AssertNot} $R0 == "bad"                       "must not be bad"

; Unary assertions
${Assert}    ${FileExists} "$INSTDIR\app.exe"   "app installed"
${AssertNot} ${FileExists} "$TEMP\leftover"     "no leftovers"
```

### Summary

`${AssertSummary}` prints totals and sets `ErrorLevel` to 1 if any assertion failed.

```nsis
${AssertSummary}
; => "12 passed, 0 failed"
```

### Compile-time assertions

| Macro                | Description                              |
| -------------------- | ---------------------------------------- |
| `${AssertDefined}`   | Fails the build if a symbol is undefined |
| `${AssertUndefined}` | Fails the build if a symbol is defined   |

```nsis
${AssertDefined}   MY_VERSION
${AssertUndefined} DEPRECATED_FLAG
```

## Options

Define these before including Assert.nsh to customize behavior.

### Verbosity

`__ASSERT_VERBOSITY__` controls what gets printed to the details panel.

| Value | Behavior                                         |
| ----- | ------------------------------------------------ |
| `2`   | Log `PASS` and `FAIL` lines (default)            |
| `1`   | Log `FAIL` lines only                            |
| `0`   | Silent — count passes/failures without logging   |

```nsis
!define __ASSERT_VERBOSITY__ 1
!include "Assert.nsh"
```

### Fail-fast

Define `__ASSERT_FAILFAST__` to abort the installer on the first failure. Sets `ErrorLevel` to 1 before calling `Abort`.

```nsis
!define __ASSERT_FAILFAST__
!include "Assert.nsh"
```

The two options are independent — for example, full output until the first failure:

```nsis
!define __ASSERT_VERBOSITY__ 2
!define __ASSERT_FAILFAST__
!include "Assert.nsh"
```

See [examples](Examples/) for details.

## License

[The MIT License](LICENSE) - Feel free to use, modify, and distribute this code.
