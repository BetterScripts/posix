<!-- SPDX-License-Identifier: MPL-2.0 -->
<!-- ############################### LICENSE ############################### -->
<!--                                                                         -->
<!-- BetterScripts 'CHANGES.MD': Change log for `shtoolkit` libraries.       -->
<!--                                                                         -->
<!-- Copyright (c) 2026 BetterScripts ( better.scripts@proton.me,            -->
<!--                                    https://github.com/BetterScripts )   -->
<!--                                                                         -->
<!-- This file is part of the BetterScripts `shtoolkit` (aka _the suite_).   -->
<!--                                                                         -->
<!-- This Source Code Form is subject to the terms of the Mozilla Public     -->
<!-- License, v. 2.0. If a copy of the MPL was not distributed with this     -->
<!-- file, You can obtain one at https://mozilla.org/MPL/2.0/.               -->
<!--                                                                         -->
<!-- ----------------------------------------------------------------------- -->
<!--                                                                         -->
<!-- ADDENDUM:                                                               -->
<!--                                                                         -->
<!-- In addition to the Mozilla Public License a copy of LICENSE.MD should   -->
<!-- have been be provided alongside this file; LICENSE.MD clarifies how the -->
<!-- Mozilla Public License v2.0 applies to this file and MAY confer         -->
<!-- additional rights.                                                      -->
<!--                                                                         -->
<!-- Should there be any apparent ambiguity (implied or otherwise) the terms -->
<!-- and conditions from the Mozilla Public License v2.0 shall apply.        -->
<!--                                                                         -->
<!-- If a copy of LICENSE.MD was not provided it can be obtained from        -->
<!-- https://github.com/BetterScripts/shtoolkit/LICENSE.MD.                  -->
<!--                                                                         -->
<!-- NOTE:                                                                   -->
<!--                                                                         -->
<!-- The Mozilla Public License v2.0 is compatible with the GNU General      -->
<!-- Public License v2.0.                                                    -->
<!--                                                                         -->
<!-- ----------------------------------------------------------------------- -->
<!-- cSpell:Ignore shtoolkit                                                 -->
<!-- cSpell:Ignore libarray                                                  -->
<!-- cSpell:Ignore libdeque                                                  -->
<!-- cSpell:Ignore libgetargs getargs getarg                                 -->
<!-- cSpell:Ignore libmap                                                    -->
<!-- cSpell:Ignore libpath mktmp                                             -->
<!-- cSpell:Ignore libstring                                                 -->
<!-- ####################################################################### -->

# CHANGE LOG

Change log for _BetterScripts `shtoolkit`_ (previously known as
_The BetterScripts POSIX Suite_).

Note that full change logs for each library file are included at the end of the
file itself. Information here may only contain a subset of total changes made or
a generalization of many changes.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## GENERAL

<!-- ................................................... -->

### v26.1

> [!IMPORTANT]
> **BREAKING CHANGES**

- \[CHANGE] Configuration variables that previously accepted the value `A` for
  _Automatic Configuration_, now also accept `D` for _Delayed Automatic_
  _Configuration_. Where this is possible (and desirable), this new mode allows
  for configuration to be postponed till the value is required instead of being
  determined at library sourcing time.[^postponed_config] Unless otherwise
  stated, `D` is the default for all variables that support delayed
  configuration. `D` is a synonym for `A` in cases where delayed configuration
  is not available. In some cases delayed configuration is required and can
  not be disabled.

[^postponed_config]: Most automatic configuration is possible to do at sourcing
                     and is cheap to perform, however, in some cases this is not
                     the case (e.g. tests related to locale can be a particular
                     issue). Having to option to delay automatic configuration
                     till required is necessary in some cases, but is also
                     useful in many others where the configuration might never
                     be needed (and so delaying provides a performance gain).
                     At this time `D` is mostly synonymous with `A`, however,
                     this is expected to change with most configuration
                     eventually being delayed.

_Additional breaking changes are **also** present in some libraries._

------------------------------------------------------------

- \[CHANGE] New name _the BetterScripts POSIX Suite_ is now
  _BetterScripts `shtoolkit`_ or simply _`shtoolkit`_. This makes no difference
  to any of the libraries.[^name_change]
- \[CHANGE] New repository: <https://github.com/BetterScripts/posix> is replaced
  by <https://github.com/BetterScripts/shtoolkit>. All links should
  automatically re-direct.
- \[CHANGE] New global versioning format `YYYY-MM-DD` is now `YY.N` where `N` is
  an incrementing integer `>=1` (`N` resets when `YY` changes).[^version_change]
- \[NEW] `busybox` can now be omitted from tests with the flag
  `--no-busybox` which is useful for certain versions of busybox where `awk`
  seems significantly problematic such that it causes segmentation faults for
  scripts of even moderate complexity.[^busybox_awk_segv]
- \[NEW] The test harness now supports the option `--locale [<LOCALE>]` which
  runs tests under the locale specified. If no locale is specified the harness
  uses the first `UTF-8` locale available on the system. Under this option
  additional test files may be used that explicitly test multi-byte characters
  for specific libraries.

[^name_change]: The _only_ differences in terms of distributions of `shtoolkit`
                are the change in repository link and the renaming of the
                common `man` file from `betterscripts` to `shtoolkit`.

[^version_change]: This value is only used for releases and does
                   not appear in any libraries.

[^busybox_awk_segv]: This affects at least version `v1.36.x`. Several fixes have
                     been made to later versions of `busybox` which address a
                     number of segmentation fault issues with `awk`, but it's
                     not clear if this addresses everything relevant and it has
                     not yet been possible to test this.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## `libarray.sh`

<!-- ................................................... -->

### `libarray.sh` v2.0.0

> [!IMPORTANT]
> **BREAKING CHANGES**

- \[CHANGE] Pattern matching rewritten - new code fixes several issues, but
  changes how some matches are made. Affects `array_remove`, `array_search`,
  `array_contains`, and `array_split`. **_Some previously working matches_**
  **_will no longer match._**[^broken_patterns]
- \[CHANGE] Command options now _MUST_ precede any non-option arguments. This
  better matches the standard and other suite libraries. Affects
  `array_from_path`.
- \[CHANGE] `array_printf` no longer writes anything for empty arrays
  (previously a single `<newline>` would be written).

[^broken_patterns]: Unfortunately, broken pattern matching will often fail
                    silently. This is unavoidable - the change was required as
                    the old code was unsafe, unreliable, and impossible to use
                    correctly (or at all) in many instances, but it is difficult
                    or impossible to automatically detect patterns that would
                    previously have worked and no longer will (or vice-versa).

------------------------------------------------------------

- \[NEW] Added simple debugging output (disabled by default), controlled by
  `BS_LIBARRAY_DEBUG`, `BS_LIBARRAY_CONFIG_DEBUG`, and
  `BS_LIBARRAY_DEBUG_FD`.[^debug_documentation]
- \[CHANGE] Large rewrite of much of the library: fixing issues, improving
  security, removing unnecessary code, homogenizing command interfaces, and
  more. (In some cases this has _changed_ or even _reduced_ functionality.)
- \[CHANGE] _(PORTABILITY)_ Removed some portability branches and replaced with
  alternative code that works in all versions. (Most notably related to `sed`.)
  The previously available `BS_LIBARRAY_CONFIG_NO_SED_SLASH_N_NEWLINE` is now
  ignored.
- \[CHANGE] Commands that support pattern matching now support all forms.
  (Previously some commands supported only a subset.)
- \[CHANGE] Modified `awk` scripts to remove unnecessary function usage,
  increase security and robustness. (Especially relevant to the `array_split`
  function which is much changed in this regard.)
- \[CHANGE] Removed checks for `-print` options to `find` for `array_from_find`
  as it was brittle and unlikely to be much help.
- \[CHANGE] _(PERFORMANCE)_ Added code path to use `ARGV` in `awk` if possible -
  this can drastically improve performance in cases when it can be used. Added a
  new configuration variable `BS_LIBARRAY_CONFIG_NO_AWK_ARGV` to disable it if
  required.
- \[CHANGE] _(PERFORMANCE)_ Inlined some code where the common case would likely
  much slower otherwise.
- \[CHANGE] Other clean-ups and refactoring.
- \[CHANGE] Documentation updates/fixes.
- \[FIX] _(PORTABILITY)_ Changed parameter expansion of the form
  `${parameter:?[word]}` to always use a fixed string, or a workaround for `zsh`
  which fails to expand parameters used in `word`.
- \[FIX] _(PORTABILITY)_ changed some parameter expansions to ensure that
  meta-characters are safe (e.g. `#` to `[#]`).
- \[FIX] _(PORTABILITY)_ Replaced all usage of `expr`. Although `expr` is often
  significantly faster, it also has many more portability issues - many of which
  are impossible to detect when using user supplied expressions. The previously
  available `BS_LIBARRAY_CONFIG_NO_EXPR_BRE_MATCH` is now ignored.
- \[FIX] Changed `array_from_path` to avoid erroneous output in edge cases. Also
  now enables globbing as, if it is disabled via shell options nothing would be
  generated (enabling is scoped appropriately). Additional fix to avoid an error
  when `ls` does not support `-q`.

[^debug_documentation]: Note that debug variables are currently only documented
                        in the main `shtoolkit` documentation and _not_ in the
                        individual library documentation.

<!-- ................................................... -->

### `libarray.sh` v1.2.0

- \[NEW] Added `array_is_array`.
- \[NEW] `array_split` now has multiple ways of splitting text.
- \[FIX] _(PORTABILITY)_ Added trailing `\n` to `printf` - without it some
  implementations will effectively discard the last line of data.
- \[FIX] _(PORTABILITY)_ Rewrote `awk` scripts to better match platform
  capabilities. (All `awk` usage has changed considerably.)
- \[FIX] _(PORTABILITY)_ Added workarounds for `sed` where `\n` in a replacement
  expression does not result in a `<newline>`. (New configuration variable:
  `BS_LIBARRAY_CONFIG_NO_SED_SLASH_N_NEWLINE`)
- \[FIX] _(PORTABILITY)_ Changed `sed` scripts to avoid long label names and
  remove grouping with `{` when not required.
- \[FIX] _(PORTABILITY)_ Minor changes to some `case` statements which should
  now be more portable, though never showed any issues (e.g. add `;;` to some
  statements where it was missing even though this was permitted.)
- \[FIX] _(PORTABILITY)_ Use null string instead of no arguments for `echo` when
  intent is only to output a `<newline>`.
- \[FIX] _(PORTABILITY)_ Minor changes to parameter expansion to avoid issues
  with `ksh88`.

<!-- ................................................... -->

### `libarray.sh` v1.0.1

- \[FIX] Fixed error with `shift` in `fn_bs_libarray_error` that would cause
  parameters to appear incorrectly in the error message (only affected calls
  with multiple parameters).

<!-- ................................................... -->

### `libarray.sh` v1.0.0

- First Release.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## `libdeque.sh`

<!-- ................................................... -->

### `libdeque.sh` v1.1.1

- \[NEW] Added simple debugging output (disabled by default), controlled by
  `BS_LIBDEQUE_DEBUG`, `BS_LIBDEQUE_CONFIG_DEBUG`, and
  `BS_LIBDEQUE_DEBUG_FD`.[^debug_documentation]
- \[CHANGE] Minor clean-ups and refactoring.
- \[FIX] _(PORTABILITY)_ Changed parameter expansion of the form
  `${parameter:?[word]}` to use a fixed string, or a workaround for `zsh` which
  fails to expand parameters used in `word`.
- \[FIX] _(PORTABILITY)_ changed quoting for some parameter expansion from
  `"${parameter:#[word]}"` to `${parameter:#"[word]"}` as it's slightly safer
  (it avoids issues with special characters in `"[word]"`).
- \[FIX] _(SAFETY)_ deprecated `BS_LIBDEQUE_CONFIG_USE_SAFER_DEQUE` in favor of
  `BS_LIBDEQUE_CONFIG_ALLOW_UNSAFE_DATA_FORMAT` which is safer and should have
  been used in the first place.
- \[FIX] _(DOCUMENTATION)_ removed documentation accidentally left over from a
  previous implementation of some code that was no longer correct nor relevant
  to current code. (This included re-enabling shellcheck checks that had
  erroneously been left disabled.)

<!-- ................................................... -->

### `libdeque.sh` v1.1.0

- \[FIX] _(PORTABILITY)_ Added workarounds for `grep` where '-F' is not
  available. (Assumes `fgrep` _is_ available in this case - this may change.)
  (New configuration variable: `BS_LIBDEQUE_CONFIG_NO_GREP_F`)
- \[FIX] _(PORTABILITY)_ Removed `-` when used to indicate input is from
  `STDIN`.
- \[FIX] _(PORTABILITY)_ Minor changes to parameter expansion to avoid issues
  with ksh88 and posh.

<!-- ................................................... -->

### `libdeque.sh` v1.0.0

- First Release.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## `libgetargs.sh`

<!-- ................................................... -->

### `libgetargs.sh` v1.3.1

- \[NEW] Added simple debugging output (disabled by default), controlled by
  `BS_LIBGETARGS_DEBUG`, `BS_LIBGETARGS_CONFIG_DEBUG`, and
  `BS_LIBGETARGS_DEBUG_FD`.[^debug_documentation]
- \[CHANGE] Minor documentation updates/fixes.
- \[CHANGE] Minor clean-ups and refactoring.
- \[FIX] _(PORTABILITY)_ Changed parameter expansion of the form
  `${parameter:?[word]}` to use a fixed string, or a workaround for `zsh` which
  fails to expand parameters used in `word`.
- \[FIX] _(PORTABILITY)_ changed some quoting in cases where it could be
  problematic for some shells, and an alternative was available.
- \[FIX] _(PORTABILITY)_ changed some parameter expansions to ensure that
  meta-characters are safe (e.g. `#` to `[#]`).
- \[FIX] _(PORTABILITY)_ switched from `printf '%.17s'` to using `awk` for
  string truncation to avoid the potential for error if the string contains any
  multi-byte characters.
- \[FIX] _(PORTABILITY)_ Rewrote _OPTION_/_OPERAND_ _CONFIG_ validation -
  previously this used `grep` (and before than `expr`) and was the only
  remaining usage of this, but it too hit errors in some situations which have
  been resolved with a new `sed` implementation. Both `expr` and `grep` are now
  completely removed.

<!-- ................................................... -->

### `libgetargs.sh` v1.3.0

- \[FIX] Fixed an issue that would cause a failure under `set -u` when an unset
  user variable was used. (Although the failure _may_ be useful, it breaks the
  principle that behavior is the same under `set -u` and `set +u`.)
- \[FIX] _(PORTABILITY)_ Added trailing '\n' to `printf` - without it some
  implementations will effectively discard the last line of data.
- \[FIX] _(PORTABILITY)_ Rewrote OPTION matching to be simpler and more
  portable: `sed` is now used in place of `expr` and `grep` for all matching;
  `tr` is required where previously use was based on config. (NOTES: Previously
  rejected OPTION-CONFIG may now be accepted; performance characteristics may
  have changed, however overall performance was not measurably altered.)
- \[FIX] _(PORTABILITY)_ Minor changes to some `case` statements which should
  now be more portable, though never showed any issues (e.g. add `;;` to some
  statements where it was missing even though this was permitted.)

<!-- ................................................... -->

### `libgetargs.sh` v1.2.0

- \[NEW] Added ability to specify a variable name with `--unmatched`, which will
  receive all unmatched OPTIONS and OPTION-ARGUMENTs allowing OPERANDs to be
  available (this automatically enables `BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`.)
- \[CHANGE] Removed some config checks that were not useful.
- \[FIX] Fixed an issue that caused auto-help generation to fail in all cases
  (line continuation in `awk` was not dealt with correctly).

<!-- ................................................... -->

### `libgetargs.sh` v1.1.0

- \[NEW] Optional OPTION-ARGUMENTs can now be separated from the OPTION if
  `BS_LIBGETARGS_CONFIG_STRICT_OPERANDS` is enabled.

<!-- ................................................... -->

### `libgetargs.sh` v1.0.0

- First Release

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## `libmap.sh`

<!-- ................................................... -->

### `libmap.sh` v1.0.0

- First Release.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## `libpath.sh`

<!-- ................................................... -->

### `libpath.sh` v1.0.0

- First Release.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## `libstring.sh`

<!-- ................................................... -->

### `libstring.sh` v1.0.0

- First Release.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- REFERENCES -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- END OF FILE -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
