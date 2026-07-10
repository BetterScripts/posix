<!-- % % shtoolkit(7) BetterScripts | BetterScripts `shtoolkit` common docs. -->
<!-- % % BetterScripts (better.scripts@proton.me)                            -->
<!-- % % July 2026                                                           -->
<!-- ^^^^^^^^^^^^^^^^^^^^^^^^^^ `pandoc` metadata ^^^^^^^^^^^^^^^^^^^^^^^^^^ -->
<!-- SPDX-License-Identifier: MPL-2.0 -->
<!-- ############################### LICENSE ############################### -->
<!--                                                                         -->
<!-- BetterScripts 'README.MD': Information common to all `shtoolkit`        -->
<!--                            libraries.                                   -->
<!--                                                                         -->
<!-- Copyright (c) 2022-2026 BetterScripts (better.scripts@proton.me,        -->
<!--                         https://github.com/BetterScripts )              -->
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
<!-- cSpell:Ignore libarray                                                  -->
<!-- cSpell:Ignore libdeque                                                  -->
<!-- cSpell:Ignore libgetargs getargs getarg                                 -->
<!-- cSpell:Ignore libmap                                                    -->
<!-- cSpell:Ignore libpath mktmp                                             -->
<!-- cSpell:Ignore libstring                                                 -->
<!-- ####################################################################### -->

# `shtoolkit`

> Previously known as _BetterScripts POSIX Suite_.

An ever growing suite of libraries which aim to make portable scripting easier,
safer, and more efficient written for scripts written for "command
interpretation services and common utility programs" as defined in the
["Shell and Utilities"][posix_shell_utils] volume of the
[_POSIX.1-2008_][posix] standard.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

The suite libraries provide commands that enable commonly undertaken tasks to be
accomplished more easily, while maintaining maximum portability, by providing
more advanced features on top of the _POSIX.1_ standard, and providing
workarounds for environments or utilities which can cause problems.

To the extent possible, every library in the suite is self-contained and has no
dependencies outside the library except for a compatible _POSIX.1_ environment.

While some libraries may provide for being directly executed (i.e. as
indistinguishable from a binary command), most libraries are intended to be
["sourced"][posix_dot] into any script where the library commands will then
be available.

<!-- ................................................... -->

### LIBRARIES

------------------------------------------------------------

[`libarray.sh`](./libarray.md)

- Emulated arrays for any shell.

------------------------------------------------------------

[`libdeque.sh`](./libdeque.md)

- Emulated double ended queues, queues, and stacks for any shell.
- The use of these is recommended ahead of other data types (e.g. emulated
  arrays) wherever possible as they are much faster.
- Both queues and stacks are specializations of double ended queues and so are
  provided in the same library.

------------------------------------------------------------

[`libgetargs.sh`](./libgetargs.md)

- Argument processing made easy - like `getopt` or `getopts` but much more
  powerful, while requiring less work.

------------------------------------------------------------

[`getarg`](./getarg.md)

- Wrapper for `libgetargs.sh` which allows invoking without needing to be
  sourced.

------------------------------------------------------------

[`libmap.sh`](./libmap.md)

- Emulated associative arrays for any shell.

------------------------------------------------------------

[`libpath.sh`](./libpath.md)

- Commands to assist with path processing.
- Includes commands to retrieve path information like size, owner, etc.
- Provides a portable `mktemp` alternative.

------------------------------------------------------------

[`mktmp`](./mktmp.md)

- Wrapper for `libpath.sh` which allows invoking the `path_mktemp` without
  sourcing the library.

------------------------------------------------------------

[`libstring.sh`](./libstring.md)

- Commands assist with string processing.
- Includes commands to safely and easily trim, truncate, substitute values, and
  more.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## ENVIRONMENT

Several variables affect the libraries, some of these should be set to specific
values for the libraries to work as intended[^setting_variables], while others
determine library configuration.

[^setting_variables]: While it would be possible to set some environment
                      variables to the required values when needed by a
                      specific library (e.g. setting the `POSIX` locale), this
                      is not always easy to do while avoiding changing the state
                      for the invoker _and_ maintaining performance. Setting all
                      variables as part of a command might be possible in many
                      cases, but would require huge lines of code for each
                      command, and setting variables may not even be possible
                      (e.g. standard variables may be `readonly` in a restricted
                      shell, while utilities like `env` can not be used for
                      shell builtins). Finally, setting these variables to the
                      expected value assumes that other values do not work,
                      which may not be true and may make some uses of the
                      libraries impossible without any real need.

<!-- ................................................... -->

### SHELL CONFIGURATION

<!-- --------------------------------------------------- -->

#### LOCALE

TL;DR:
<!-- -->

- The expression `${LC_ALL:-${LC_CTYPE:-${LANG:-POSIX}}}` _SHOULD_ evaluate to
  `POSIX` or `C`; other values _MAY_ work, but are _NOT_ generally supported;
- The locale of the currently active shell can **not** be changed - the locale
  in effect for a shell is **always** the locale in effect when the shell was
  invoked;
- Using the correct locale for the data being processed is essential - multi-
  byte characters can **not** be processed correctly with many operations
  _unless_ a suitable locale is currently in effect.
- Some libraries (e.g. `libstring.sh`) make significant attempts to be correct
  using _any_ locale, but this relies on the underlying tools supporting the
  specific locale - such support varies by platform and is impossible to test
  for portably.

Details:
<!-- -->

All libraries assume the _POSIX.1_ defined default environment is in effect.

**Much of the _POSIX.1_ standard is _only_ defined for this environment.**

- All libraries are locale agnostic to the extent possible, however much of the
  standard is _only_ defined when the locale is the _POSIX_ locale -
  implementations can (and do) provide different behavior with other locales.
- In most cases any locale should work, and in cases where there are known
  issues with implementation behavior outside the _POSIX_ locale, libraries may
  be able to set the locale directly to avoid issues (though this is not always
  possible).
- There are several standard defined locale variables, namely: `LANG`,
  `LC_COLLATE`, `LC_CTYPE`, `LC_MESSAGES`, `LC_MONETARY`, `LC_NUMERIC`,
  `LC_TIME`, and `LC_ALL`. The variable `LANG` provides a default for any unset
  variables, while `LC_ALL` overrides all other variables. Typically `LC_CTYPE`
  is the variable that controls if utilities behave according to the standard,
  while other variables ensure processing is in accordance with locale settings
  (e.g. `LC_MESSAGES` may change the language used for error
  messages).[^gnu_locale]
- Although the _POSIX_ locale does not recognize multi-byte characters the
  standard requires text in the _POSIX_ locale is processed as bytes so
  multi-byte characters can be processed correctly in many cases, however
  some operations _will_ behave in unexpected ways.
- Many systems now provide UTF-8 versions of `POSIX` and `C` - note that these
  are _NOT_ the _POSIX_ locale, although tools may behave as if they
  are.[^utf8_locale]
- The locale in use affects which tools are used for some
  operations.[^automatic_locale]

[^gnu_locale]: Some shells and utilities (most notably those provided by _GNU_)
               add additional locale variables to those specified by the
               standard. These are mostly similar to `LC_MESSAGES`, and do not
               affect general behavior of utilities, however the variable
               `LANGUAGE` _may_ cause issues in some circumstances.

[^utf8_locale]: There are numerous subtle differences between the UTF-8 versions
                and the other versions, for example, character classes will
                contain many more characters in the UTF-8 version. Standard
                conforming tools need not provide standard conforming behavior
                for these locales.

[^automatic_locale]: It is not possible to have literal multi-byte characters in
                     a script file as not all shells can process these (leading
                     to errors on sourcing). The only real way to get a multi-
                     byte character is to use `awk` which supports octal
                     escapes, however, code points are not unique in locales,
                     leading to problems as it is not possible to determine
                     what character a specific octal escape sequence represents.
                     For a significant time now, UTF-8 seems to be the defacto
                     standard for character encodings, with UTF-8 locales
                     available for most modern systems. Given all this, any
                     tests for multi-byte support assume UTF-8 code points. In
                     the case where the locale is _NOT_ UTF-8 this will likely
                     fail and manual configuration will be required. Note that
                     failure to chose the correct tool will often _only_ result
                     in less optimal performance and is, in most cases, unlikely
                     to result in errors - the main exception to this is for
                     systems that have inconsistent support for multi-byte
                     characters (particularly for `awk`).

------------------------------------------------------------

#### `IFS`

TL;DR:
<!-- -->

- _SHOULD_ be the standard defined default of `<space><tab><newline>`; other
  values _MAY_ work, but are _NOT_ supported.

Details:
<!-- -->

- All libraries are agnostic to the value of `IFS` the extent possible, however
  `IFS` plays a role in a significant number of fundamental shell operations,
  and, as such, can cause bugs that may be difficult to understand.
- Historically, shell support of `IFS` has been somewhat inconsistent, although
  more recently the situation has improved. Sadly, there remain edge cases
  where behavior of operations that rely on `IFS` is different between shells.
- No library sets the value of `IFS`.

------------------------------------------------------------

#### `POSIXLY_CORRECT`

TL;DR:
<!-- -->

- _SHOULD_ be the set.

Details:
<!-- -->

- In addition to the current locale, [_GNU_ tools][gnu_non_gnu_stds] may also
  check if this variable is set - if so they will try to match the standard more
  closely than otherwise would be the case.
- _GNU_ tools are near omnipresent - available for almost any conceivable
  platform and often installed by default. Given this, and that other
  implementations may also use this variable, it is prudent to set this.

<!-- ................................................... -->

### LIBRARY CONFIGURATION

A number of environment variables affect the functionality of each of the
libraries. These include both variables that instruct the library to work-around
specific platform issues, and variables that convey user preferences. (See also
the information on [compatibility](#compatibility).)

Where it is possible, platform specific issues are detected automatically, with
the associated variables providing a way to force enabling or disabling specific
work-arounds if necessary. _Automatic detection should always be preferred_ -
this detects use cases that are actually problematic and not more general
issues.

### LIBRARY CONFIGURATION: VARIABLE CATEGORIES

Each configuration variable belongs to a specific _CLASS_:

- _CONSTANT_ - a configuration option that is read _only once_ when the library
  is first sourced and must not be set after this point (the `readonly` command
  may be used to enforce this).
- _VARIABLE_ - a configuration option that can be modified at any point and
  _may_ affect the next command.

Additionally, each configuration variable has to a specific _TYPE_:

- _TEXT_ - has a value that is arbitrary text with constraints defined by each
  specific variable.
- _FLAG_ - enables or disables specific functionality. The value `0` (`<zero>`)
  turns a flag _OFF_, while **_any_** other text will turn a flag _ON_, EXCEPT
  for flags where automatic detection is applicable where the value `A` is
  special and forces the use of automatic detection. In some cases automatic
  detection can be delayed until specific functionality is required, in these
  cases the value `D` can be used to forced delayed automatic detection - if
  delayed detection is not supported for a flag, `D` and `A` are
  equivalent.[^delayed_detection] _A flag that is unset **or** _set but null_
  _(i.e. empty) will use an appropriate default value._

[^delayed_detection]: Delayed detection is helpful in some cases, particularly
                      when locale is important - without delayed detection the
                      best code path may not be chosen (as the locale may not
                      be set appropriately). Note that delayed detection only
                      ever allows a better code path to be chosen - it should
                      **not** cause errors if skipped.

Configuration variables are never modified by a library.

Many configuration variables can be set for all libraries with a single, suite
wide variable. Where such a suite wide variable is available a library specific
variable is always available in addition and has precedence. (Not all libraries
use all suite wide settings.)

Suite wide variables are listed in the following sections (with defaults
highlighted).

<!-- ................................................... -->

#### LIBRARY CONFIGURATION: USER PREFERENCE

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`

- Type:     _FLAG_
- Class:     _VARIABLE_
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[<IDENTIFIER>]: ERROR: <MESSAGE>`.
- _ON_: library error messages will be suppressed.
- Each library also stores the most recent error message in a library specific
  variable, which is unaffected by this flag.
- Unless otherwise stated, both the library versions of this option and the
  suite version can be modified between command invocations and should affect
  the next command.
- Does not affect errors from non-library commands, which _may_ still produce
  output.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_FATAL_ERRORS`

- Type:     _FLAG_
- Class:     _VARIABLE_
- Default:  _OFF_
- Enable/\[Disable] causing library errors to terminate the current (sub-)shell.
- _OFF_: errors stop any further processing, and cause a non-zero exit status,
  but do not cause an exception.
- _ON_: any library error will cause an "unset variable" shell exception using
  the [`${parameter:?[word]}`][posix_param_expansion] parameter expansion, where
  `word` is set to an error message that _should_ be displayed by the shell
  (this message is NOT suppressed by
  [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](#better_scripts_config_quiet_errors)).
- Unless otherwise stated, both the library versions of this option and the
  suite version can be modified between command invocations and should affect
  the next command.

------------------------------------------------------------

<!-- ................................................... -->

#### LIBRARY CONFIGURATION: PORTABILITY

**Where possible these are automatically detected - unless there is a problem**
**it is _HIGHLY_ recommended these are not set manually.**[^manually_set]

[^manually_set]: In some cases it is not possible to detect issues with 100%
                 accuracy, while some tests may cause measurable delays for
                 short scripts - in these cases setting the appropriate variable
                 correctly is recommended.

_Incorrectly setting these variables **will** cause errors in many cases_
_(including possible data corruption), while in other cases may result_
_in lost performance._

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using `setopt` in _Z Shell_ to ensure _POSIX.1_ like
  behavior.
- _OFF_: Use `setopt` to set the appropriate options.
- _ON_: Don't use `setopt`, even in _Z Shell_.
- Automatically enabled if _Z Shell_ is detected.
- Any use of `setopt` is scoped as tightly as possible and should not affect
  other commands.
- If _Z Shell_ is used and the current environment has already been set to be
  _POSIX.1_ compliant, forcing this _ON_ may improve performance.
- _Z Shell_ has some defaults that cause non-standard behavior, however also
  provides `setopt` which can be tightly scoped to set options when required
  without impacting other platforms.[^z-shell-support]
- **WARNING:** setting this variable incorrectly _will_ cause errors.

[^z-shell-support]: Technically since the default configuration of _Z Shell_ is
                    non-standard it is not supported, however this work-around
                    is provided since it can be easily scoped, and does not
                    notably affect performance, and causes no issues with
                    other environments. Similar work-arounds for other
                    environments are not always possible (e.g. the GNU
                    specific [`POSIXLY_CORRECT`][gnu_non_gnu_stds] environment
                    variable can not so easily be dealt with).

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_MULTIDIGIT_PARAMETER`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using only single digit shell parameters, i.e. `$0` to `$9`.
- _OFF_: Use multi-digit shell parameters.
- _ON_: Use only single-digit shell parameters.
- Multi-digit parameters are faster but may not be supported by all
  implementations.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_SHIFT_N`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using only `shift` and not `shift N` for multiple
  parameters.
- _OFF_: Use `shift N`.
- _ON_: Use only `shift`.
- Multi-parameter `shift` is faster but may not be supported by all
  implementations.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] support for multi-byte character processing within the shell
  itself (e.g. via [wildcards](#pattern-matching-wildcards)).
- _OFF_: use fallback code for operations affected.
- _ON_:  use internal shell operations.
- _The locale a shell uses is set at invocation and can **not** be changed for_
  _a running shell._
- Default is to run tests for the current shell when a library is sourced to
  determine if such support is present.
- To support multi-byte characters, requires a shell is invoked using a locale
  that defines such characters (i.e. **not** the _POSIX_ locale) **and** the
  shell must support them.
- Support for shell string processing of multi-byte characters is far from
  universal, outside the _POSIX_ locale implementations often continue to use
  byte processing rather than character processing - in some cases
  implementations provide partial support, which can be confusing.
- Often lack of support for multi-byte characters is not an issue, however in
  certain circumstances it can cause problems, including corrupting data.
- Note that some operations are **always** processed as bytes (not characters)
  regardless of locale - workarounds for these operations are used based solely
  on the current locale and are not affected by this flag.
- The costs of running tests are small, but may be measurable for short scripts,
  setting this variable avoids these costs.
- **NOTE:** no implementation supports multi-byte characters if invoked in the
  _POSIX_ locale.
- **WARNING:** setting this variable incorrectly _may_ lead to errors and data
  corruption.
- **WARNING:** fallback implementations may be significantly slower.
- **WARNING:** set the current locale _before_ sourcing a library **will** break
  automatic testing.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] [glob/wildcard](#pattern-matching-wildcards) pattern
  matching even if the pattern contains known problematic characters.
- _OFF_: use fallback code for patterns that contain problem characters.
- _ON_:  use shell pattern matching.
- Default is to run tests for the current shell when a library is sourced to
  determine if the current shell supports these as expected or not.
- Some implementations do not treat all characters in patterns in the way that
  is expected - e.g. `\` (`<backslash>`) is an escape character for _most_
  implementations, but always literal for others.
- The costs of running tests are small, but may be measurable for short scripts,
  setting this variable avoids these costs.
- **WARNING:** setting this variable incorrectly _may_ lead to errors and data
  corruption.
- **WARNING:** fallback implementations may be significantly slower.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] using character classes of the form `[:alpha:]` in
  ["Parameter Expansion"][posix_param_expansion].
- _OFF_: use fallback code for operations affected.
- _ON_:  use character classes.
- Using character classes allows some operations to be completed within the
  shell itself, rather than requiring external commands, but these classes are
  not always supported for this.
- **WARNING:** fallback implementations may be significantly slower.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_CASE_CHAR_CLASS`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] using character classes of the form `[:alpha:]` in
  `case` pattern matching expression.
- _OFF_: use fallback code for operations affected.
- _ON_:  use character classes.
- Using character classes allows some operations to be completed within the
  shell itself, rather than requiring external commands, but these classes are
  not always supported for this.
- **WARNING:** fallback implementations may be significantly slower.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_DEV_NULL`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using alternatives to `/dev/null` as a redirection
  source/target (e.g. for output suppression).
- _OFF_: Use `/dev/null`.
- _ON_: Use an alternative to `/dev/null`.
- Using `/dev/null` as a redirection target is a common idiom, but not always
  possible (e.g. restricted shells generally forbid this).

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_GREP_E`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using the non-standard `egrep` instead of `grep -E`.
- _OFF_: Use `grep -E`.
- _ON_: Use `egrep`.
- While `grep -E` is standard, it is not always supported - implementations that
  do not support it often provide the non-standard `egrep` instead.
- **WARNING:** no check is made that `egrep` exists: if `grep -E` is not
  available `egrep` is assumed to be present.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_GREP_F`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using the non-standard `fgrep` instead of `grep -F`.
- _OFF_: Use `grep -F`.
- _ON_: Use `fgrep`.
- While `grep -F` is standard, it is not always supported - implementations that
  do not support it usually provide the non-standard `fgrep` instead.
- **WARNING:** no check is made that `fgrep` exists: if `grep -F` is not
  available `fgrep` is assumed to be present.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_TR_SUPPORTS_MBC`

- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic> (delayed)
- Disable/\[Enable] support for multi-byte character processing with `tr`.
- _OFF_: use fallback code for operations affected.
- _ON_:  use `tr`.
- Default is to run tests when `tr` is needed to determine if such support
  is present.
- Some common implementations of `tr` lack multi-byte character support,
  regardless of the locale in use. This includes _GNU_ `tr`. Although such
  implementations should not corrupt data, they will also not process multi-
  byte characters correctly. (e.g. the common `tr '[:upper:]' '[:lower:]'`
  fails to work as expected).
- The costs of running tests are small, but may be measurable for short scripts,
  setting this variable avoids these costs.
- **WARNING:** fallback implementations may be significantly slower.
- **WARNING:** setting this when not required may cause issues if fallback
  utilities do not support multi-byte character processing themselves.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_TR_CASE_CLASS`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] using character classes of the form `[:alpha:]` with `tr`.
- _OFF_: use fallback code for operations affected.
- _ON_:  use character classes.
- `tr` is one of the fastest commands available for certain tasks, but if it
  does not support character classes, alternatives may be required.
- **WARNING:** fallback implementations may be significantly slower.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_PREFER_HEXDUMP`

- Type:     _FLAG_
- Class:     _CONSTANT_
- Default:  \<automatic>
- Enable/\[Disable] using `hexdump` in preference to `od`.
- _OFF_: use `od` whenever possible.
- _ON_:  use `hexdump` even if `od` is available.
- Has no effect unless both `od` and `hexdump` are available.
- Some systems lack `od`, but provide `hexdump` for the same purpose, while many
  provide both. This flag allows the use of either `od` or `hexdump` to be
  preferred.
- The default is to use `od` if available and `hexdump` otherwise. If neither
  command is available different (situation dependent) methods for generating
  data are used.
- _Provided for cases where `hexdump` is more capable than `od`_

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_RANDOM_SOURCE`

- Type:     _TEXT_
- Class:     _CONSTANT_
- Default:  `/dev/urandom`
- Specify a source for random data.
- _MUST_ be either the special value `awk` or a path to use as a source for
  random data.
- If specified as a path, the path _MUST_ be readable, and _MUST_ behave like
  `/dev/urandom`.
- If specified as `awk`, random data is generated by `awk` -
  **this is insecure** as the data generated is of poor quality and likely to be
  easy to guess.
- Has no effect if neither `od` nor `hexdump` is available.
- **NOTE:** The commonly present `/dev/random` and `/dev/urandom` are not
  standard, while they can be used similarly they do not behave the same way in
  all circumstances in all implementations. Care should be taken to ensure they
  work as expected on any platform they will be used.
- **WARNING:** _both_ `/dev/random` **and** `/dev/urandom` **can** block - when
  this may occur varies by system, but care must be taken when using these to
  avoid stalls.

------------------------------------------------------------

##### `BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV`

- Type:     _FLAG_
- Class:    _VARIABLE_
- Default:  _OFF_
- Disable/\[Enable] using `ARGV` within `awk` - enabling gives significantly
  better performance, but is subject to some limitations.
- _OFF_: Use `ARGV` within `awk`.
- _ON_: Avoid `ARGV` within `awk`.
- When _OFF_ `ARGV` will be used whenever appropriate, if this fails (likely due
  one of the limitations), the code for the _OFF_ condition will be used to get
  the required results. This comes with a small cost as the `ARGV` code must
  first be run and fail (although this should be relatively fast, it does have
  an impact).
- This is **not** autodetected as the point is _not_ to test if `ARGV` is
  available (it is assumed to be), but if it should be used for performance
  reasons. There is no real way to test this it will be system and data
  specific.

------------------------------------------------------------

<!-- ................................................... -->

### LIBRARY INFORMATION

Each library provides a number of variables that are set by the library to
convey information outside of command invocation.

These variables must not be set by external commands except if this is
_explicitly_ permitted. Variables may use the `readonly` command to enforce
this.

Along with any library only information variables, every library also
provides a version of some standard variables:

------------------------------------------------------------

#### `BS_<LIBRARY>_VERSION_MAJOR`

- A whole number >= 1.
- Incremented when there are significant changes, or any
  changes break compatibility with previous library versions.
- Follows [Semantic Versioning v2.0.0][semver].

------------------------------------------------------------

#### `BS_<LIBRARY>_VERSION_MINOR`

- A whole number >= 0.
- Incremented for significant changes that do not
  break compatibility with previous versions.
- Reset to 0 when
  [`BS_<LIBRARY>_VERSION_MAJOR`](#bs_library_version_major)
  changes.
- Follows [Semantic Versioning v2.0.0][semver].

------------------------------------------------------------

#### `BS_<LIBRARY>_VERSION_PATCH`

- A whole number >= 0.
- Incremented for minor revisions or bugfixes.
- Reset to 0 when
  [`BS_<LIBRARY>_VERSION_MINOR`](#bs_library_version_minor)
  changes.
- Follows [Semantic Versioning v2.0.0][semver].

------------------------------------------------------------

#### `BS_<LIBRARY>_VERSION_RELEASE`

- A string indicating a pre-release version.
- Always null for full-release versions.
- Possible values include `alpha`, `beta`, `rc`,
  etc, (a numerical suffix may also be appended).
- Follows [Semantic Versioning v2.0.0][semver].

------------------------------------------------------------

#### `BS_<LIBRARY>_VERSION_FULL`

- Full (numerical) version combining
  [`BS_<LIBRARY>_VERSION_MAJOR`](#bs_library_version_major),
  [`BS_<LIBRARY>_VERSION_MINOR`](#bs_library_version_minor),
  and [`BS_<LIBRARY>_VERSION_PATCH`](#bs_library_version_patch)
  as a single value.
- Can be used in numerical comparisons.
- Format is `MNNNPPP` where, `M` is the `MAJOR` version,
  `NNN` is the `MINOR` version (3 digit, zero padded),
  and `PPP` is the `PATCH` version (3 digit, zero padded).

------------------------------------------------------------

#### `BS_<LIBRARY>_VERSION`

- Full version combining
  [`BS_<LIBRARY>_VERSION_MAJOR`](#bs_library_version_major),
  [`BS_<LIBRARY>_VERSION_MINOR`](#bs_library_version_minor),
  [`BS_<LIBRARY>_VERSION_PATCH`](#bs_library_version_patch),
  and
  [`BS_<LIBRARY>_VERSION_RELEASE`](#bs_library_version_release)
  as a formatted string.
- Format is
  `BetterScripts '<library>' vMAJOR.MINOR.PATCH[-RELEASE]`.

------------------------------------------------------------

#### `BS_<LIBRARY>_LAST_ERROR`

- Stores the error message of the _most recent_ library error.
- ONLY valid immediately following a command from the appropriate library for
  which the exit status is not a success code.
- Valid even when error output is suppressed.

------------------------------------------------------------

#### `BS_<LIBRARY>_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to determine if a specific
  library has been sourced.
- Also serves as a guard to avoid errors caused by sourcing a library multiple
  times.

------------------------------------------------------------

<!-- ................................................... -->

### DEBUG VARIABLES

Each library supports limited debug information that can be controlled using
environment variables. Library specific variables take precedence. The widely
used `DEBUG` environment variable provides a default if all other variables
are unset.

In particular, debug output helps determine which code path is used for those
commands that vary implementation depending on the capabilities of the current
platform. (In some cases these paths are determined dynamically.)

------------------------------------------------------------

#### `BS_DEBUG` and `BS_<LIBRARY>_DEBUG`

- Type:     _FLAG_
- Class:    _VARIABLE_
- Default:  _OFF_
- Enable/\[Disable] library debug message output.
- _OFF_: no debug messages will be displayed.
- _ON_: debug messages will be displayed.
- `BS_<LIBRARY>_DEBUG` defaults to the expression `${BS_DEBUG:-${DEBUG:-0}}`.
- Also enables `BS_<LIBRARY>_CONFIG_DEBUG`.

------------------------------------------------------------

#### `BS_CONFIG_DEBUG` and `BS_<LIBRARY>_CONFIG_DEBUG`

- Type:     _FLAG_
- Class:    _VARIABLE_
- Default:  _OFF_
- Enable/\[Disable] library debug message output for
  configuration only.
- _OFF_: no debug messages will be displayed.
- _ON_: debug messages will be displayed.
- `BS_<LIBRARY>_CONFIG_DEBUG` defaults to the expression
  `${BS_CONFIG_DEBUG:-${BS_<LIBRARY>_DEBUG:-0}}`.
- Configuration debug is only displayed on sourcing.

------------------------------------------------------------

#### `BS_DEBUG_FD` and `BS_<LIBRARY>_DEBUG_FD`

- Type:     _TEXT_
- Class:    _VARIABLE_
- Default:  `2`
- Set a target for debug messages.
- If the target is a single digit _or_ is preceded by an `&` (`<ampersand>`)
  output is redirected using `>&` (i.e. it is treated as a file descriptor);
  if the target is _not_ a single digit _or_ is preceded by a
  `>` (`<greater-than-sign>`) output is redirected using `>>` (i.e. it is
  treated as a file). Any `&` (`<ampersand>`) or `>` (`<greater-than-sign>`)
  prefix is removed before use.
- In some cases `STDERR` is suppressed by commands - unless another target is
  specified this may lead to some debug messages also being suppressed.
- If specified as a file descriptor other than `1` or `2` the descriptor MUST be
  opened before it is used. This can be accomplished in multiple ways, the
  simplest of which is to use something similar to `{ ...; } N>&1` where `N` is
  the relevant file descriptor and any code that uses the descriptor is enclosed
  within the braces. Alternatively the `exec` command can be used to similar
  effect.

------------------------------------------------------------

<!-- ................................................... -->

### ADDITIONAL VARIABLES

<!-- --------------------------------------------------- -->

#### `BETTER_SCRIPTS_PATH`

- _SHOULD_ be set to the location of the `shtoolkit` files.
- Multiple paths may be specified - formatted like the standard variable `PATH`.
- Useful for users if libraries are not installed in a location that is
  available in `PATH`.
- Currently used only by test helper scripts.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## VERSIONS

As each `shtoolkit` library is designed to be independent, versioning is on a
per-library basis.

Each release of `shtoolkit` as a whole is given a version of the form `vYY.N`
where `YY` is the year of the release and `N` is an integer `>=1` and is
incremented for each release within a given year.

The `shtoolkit` release version is for reference only and is not present in code
and can not be quired. Version checks should be made against individual
library versions.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## STANDARDS

- [_POSIX.1-2008_][posix]
  - Also known as:
    - _The Open Group Base Specifications Issue 7_
    - _IEEE Std 1003.1-2008_
    - _The Single UNIX Specification Version 4 (SUSv4)_
  - There are several more recent versions of the standard: [2013][posix_2013],
    [2016][posix_2016], [2018][posix_2018], and [2024][posix_2024] - while these
    alter the standard, most of the _2008_ version still applies.
- [FreeBSD SYSEXITS(3)][sysexits]
  - Although not a standard, the values specified by _SYSEXITS_ are
    widely used and are the only common exit codes generally available.
  - Libraries use these values wherever possible, however
    other exit codes may occur:
    - Values returned by external commands are propagated where possible
      and appropriate.
    - As per _POSIX.1_ the value `1` if used for `false` for commands that
      require reporting a non-success, non-error exit status.
- [Semantic Versioning v2.0.0][semver]
  - Each library has its own version number, each of which
    complies with Semantic Versioning v2.0.0.
  - Some libraries may provide version numbers for
    additional purposes, these also follow Semantic
    Versioning v2.0.0, but may not include all elements.
- [Inclusive Naming Initiative][inclusivenaming].

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## NOTES

<!-- ................................................... -->

### INSTALLATION

The provided [Makefile](./Makefile) has targets that allow for installation
of both libraries and documentation in configurable locations (by default
libraries are installed in `/usr/local/bin`, `Markdown` documentation in
`/usr/local/share/doc` and `man` page documentation in the appropriate
`/usr/local/share/man` directory for the documentation category - note that
these are not _POSIX.1_ specified).

Most of the libraries are intended to be sourced by other scripts using the
[`.` (aka dot) command][posix_dot], for which the standard says:

> If file does not contain a \<slash>, the shell shall use the search path
> specified by PATH to find the directory containing file. Unlike normal
> command search, however, the file searched for by the dot utility need
> not be executable.

As such libraries are installed as non-executable unless direct invocation is
supported for a specific library.

More information about installation is available by invoking the `help` target
from the [Makefile](./Makefile), i.e. `make help`.

<!-- ................................................... -->

### DOCUMENTATION

Up-to-date versions of documentation for each library is always present in
the [main repository][shtoolkit_repo] in both [`Markdown`][markdown] and
[`man` page][man_page] formats.

Much of this documentation is generated from other files within the suite, with
`Markdown` documentation for libraries being generated from comments in the
libraries themselves, while `man` page documentation is generated from
`Markdown` documentation for both common and library documentation.

All `Markdown` documentation aims to be compatible with the original
[`Markdown`][markdown] specification, with reference to
[`CommonMark`][commonmark] to resolve any ambiguities. Although an extension to
the original standard, footnotes are used throughout the `Markdown`
documentation as they are highly useful, widely supported, and acceptably
rendered by `Markdown` flavors that do not support them.

Documentation can be regenerated using the suite provided [Makefile](./Makefile).

<!-- ................................................... -->

### COMMAND ARGUMENTS

Library commands document arguments with a tag indicating argument usage:

- _in_: provides data **TO** the command.
- _out_: receives data **FROM** the command.
- _in/out_: provides data **TO** _AND_ receives data **FROM** the command.
- _ref_: an additional tag indicating the argument is passed by **NAME** instead
  of **VALUE**.
  - For a typical _POSIX.1_ variable this means omitting the `$` from the name
    when passing it to the command, i.e. instead of passing `$Variable` (or
    `${Variable}`) use `Variable`.
  - Only _POSIX.1_ compliant names are permitted. Due to the security
    considerations of using `eval` with arbitrary text _POSIX.1_ names are
    enforced for all variable names; providing a non-standard name will cause an
    error (even if the name is supported by the current shell).
  - Variables passed by name are _GLOBAL_ variables. The use of `local`
    variables (as supported by many shells) will **not** work as expected.
    (_POSIX.1_ has no concept of `local` variables.)[^local_vars]

[^local_vars]: The `local` keyword is widely supported but as it is non-
               standard how it behaves varies between implementations. Many
               implementations of `local` _may_ work for these cases, however
               some implementations will not.

Command options, where available, can be specified as _POSIX.1_ style single
character options following a single `-` (`<hyphen>`) character, and as _GNU_
style long options following a two `-` (`<hyphen>`) characters.

Unless otherwise specified:

- _POSIX.1_ style single character options can be combined into a single multi-
  character option;
- option arguments can be specified as immediately following the corresponding
  option, as a suffix to a single character option, or appended to a multi-
  character option using an `=` (`<equals>`) character.

Options _MUST_ precede operands.

The special argument `--` (`<hyphen><hyphen>`) can be used to disable option
processing and treat all subsequent arguments as operands.

<!-- ................................................... -->
<!-- cSpell:Ignore modernish                             -->
<!-- ................................................... -->

### COMPATIBILITY

All of `shtoolkit` is designed to be supported in any environment that is
compatible with the "command interpretation services and common utility
programs" as defined in the ["Shell and Utilities"][posix_shell_utils] volume
of the [_POSIX.1-2008_][posix] standard.

_The number of environments that are at least partially POSIX.1 compliant is
enormous - even if it were possible to test all of them, access to many is
difficult as they are tied to proprietary/specialist systems. Therefore, much
of the compatibility work for the Suite is based on resources such as
["autoconf: Portable Shell Programming"][autoconf_portable]). While such
resources are incredibly useful, they often omit details such as the specific
platforms for which problems occur, or even dates for when the problem was
discovered or last seen. The result is that it is highly likely some of the
workarounds implemented are unnecessary, and other necessary workarounds
have been omitted._[^legacy_systems]

[^legacy_systems]: Legacy systems and software can often be found in older
                   organizations, especially where the organizations (and hence
                   the associated systems) are somewhat specialized. While many
                   of these systems are no longer actively maintained by the
                   original manufactures, they continue to be used. Even those
                   systems that are still maintained may contain long obsolete
                   software. For example, _Oracle Solaris 11.4_ shipped in
                   September 2023, yet contains a version of `ksh88` (i.e. the
                   1988 version of KornShell) - although this shell is largely
                   similar to more modern shells it does deviate somewhat, here
                   it simply serves as an example of how even maintained systems
                   can continue to support very old software. **Where**
                   **practicable**, _the Suite_ is intended to support all such
                   systems. (`pdksh` is also worth mentioning - it continues to
                   be supported on some systems despite not having being
                   meaningfully updated since last century.)

It is likely that any _POSIX.1_ like environment that supports
["Parameter Expansion"][posix_param_expansion], modern style
["Command Substitution"][posix_cmd_subs] (i.e. `$(command)`) and
["Arithmetic Expansion"][posix_arith_expansion] will at least partially support
`shtoolkit`[^unsupported].

[^unsupported]: Legacy ["Command Substitution"][posix_cmd_subs] (i.e.
                `` `command` ``) and arithmetic via `expr` may be possible to
                support if there is significant interest in this, however,
                ["Parameter Expansion"][posix_param_expansion] is likely to
                always be required as there are no real alternatives that do not
                also have significant drawbacks.

Additionally:

- The _POSIX.1_ standard has remained relative consistent between versions (as
  relates to functionality required by `shtoolkit`), although the
  [_POSIX.1-2008_][posix] version of the standard is the reference version used
  for creating `shtoolkit` it is likely that earlier versions will also be
  supported.
- Non-compliant shells and utilities may be supported by specific libraries, or
  specific commands within those libraries.
- A shell and/or utilities which are _not_ supported _may_ still be able to make
  use of `shtoolkit` - any such tool is termed _compatible_. The difference
  between shells and utilities which are _supported_ and those which are
  _compatible_ is that any erroneous behavior specific to the latter is not
  technically a bug and unlikely to be addressed.
- Commands are designed to be _functionally equivalent_ regardless of the
  value of any of the standard specified shell options (e.g. `errexit`,
  `nounset`, etc).
- Where a shell or utility is known to deviate from the functionality required
  by a library a work-around may be provided _if_ it is relatively simple,
  performant, and can be scoped to only affect library commands.
- Some common, but non-standard functionality is supported, for example,
  "restricted" shells.
- Tests for suite libraries are provided along with a test harness in which they
  are run. These are not primarily intended to determine platform support, but
  are designed more for regression testing. Additionally, the test harness,
  while _POSIX.1_ compliant, it currently require sa more capable platform than
  that of individual libraries. That said, if tests run successfully for a
  specific platform it is likely the platform will be fully supported.

> All libraries have been tested in multiple operating systems including
> _Ubuntu_, _Oracle Solaris_, _FreeBSD_, _OpenBSD_, and
> _Windows Subsystem for Linux_.
>
> Multiple implementations of "Shells and Utilities" have also been tested
> including: `sh`[^native_sh], `bash`, `bosh`, `busybox`, `dash`, `ksh88`,
> `ksh93`, `mksh`, `modernish`, `osh`, `oksh`, `pdksh`, `posh`, `yash`, and
> `zsh` (including "restricted" versions of these shells where known to exist) -
> all shells are tested in "default" mode along with any _POSIX.1_ compatibility
> mode.
>
> Various implementations of utilities have also been tested.

[^native_sh]: While `sh` is often simply a link to another shell, this is not
              always true - for some platforms it is a unique shell.

_Note that the presence of a shell in the list of those tested does **not**
 imply a shell is supported for all libraries and in all use cases._

<!-- --------------------------------------------------- -->
<!-- cSpell:Ignore defconfig                             -->
<!-- --------------------------------------------------- -->

#### COMPATIBILITY: SHELLS

There are a significant number of implementations of _POSIX.1_ compliant shells,
and each of these has it's own quirks, bugs, and interpretation of the standard.

While most shells are possible to coax into working as expected (even when they
do not do so by default), there are some shells which are problematic in one
way or another (or have versions known to be). Those included in this section
are those that benefit from some remarks - this is in no way a comment on these
particular implementations.

Work to better accommodate problematic shells and shells not yet tested remains
ongoing.

Legacy shells that do not support things like modern command substitution
syntax, arithmetic expansion, and parameter expansion remain unsupported.

##### `busybox`

`busybox` is widely available and fully supported, however, not all
distributions of `busybox` are created equal and some commonly available
versions are significantly less capable than others.

By design `busybox` is enormously customizable at build time and it is not
uncommon for binary distributions to omit a lot of the optional code.
Unfortunately there appears to be no way to determine what configuration was
used to build a specific version and so it is not easy to use any potential
workarounds that might help, and so some things may fail with some versions of
`busybox` and not others.

_Tests on builds using `defconfig` work as expected (in line with other shells)._

Additionally **`v1.36`** of `busybox` is known to have numerous issues related
to `awk` which result in segmentation faults in a number of cases. These issues
are fixed as of `v1.37`.

For these reasons the test harness has an option `--no-busybox` which removes
`busybox` from the list of known shells when running tests - if tests fail
_only_ in `busybox` these are likely false positives and can often safely be
ignored.

##### `ksh93`

`ksh93` version `Version AJM 93u+` has issues with the test harness that cause
a number of false negatives. These seem to be related to problems capturing
`STDERR` via command substitution in certain circumstances. A number of tests
are therefore skipped with this version of this shell as they do not work.

_These failures are with the test harness only._ They do not affect the
usability of this version of this shell with the libraries themselves.

##### `nsh`

Currently the only known shell **not** to be automatically used by the test
harness and, currently, can not be tested as it does not correctly process
command line arguments with `-c`.

<!-- --------------------------------------------------- -->

#### COMPATIBILITY: BINARIES

A number of "binaries" are provided as alternative methods of accessing specific
functionality from the libraries. Each of these is simply a wrapper script that
sources the relevant library and invokes a single function within the library
with the given arguments.

_These scripts provide **no** additional functionality beyond that available in_
_the libraries themselves._

Importantly, though, these scripts will execute using `sh` for the current
system - on systems where `sh` is a unique shell that is less capable than
required, these commands **will fail**.[^binary_workarounds]

[^binary_workarounds]: Working around this issue is trivial: simply edit the
                       scripts to target a different shell; ensure
                       `/usr/bin/env sh` invokes a suitably capable shell;
                       or only use the library versions of commands. In the
                       future install time detection and correction of these
                       issues may be added.

<!-- --------------------------------------------------- -->

#### COMPATIBILITY: EXTERNAL COMMANDS

Every library provided relies on many of the standard specified utilities
for functionality beyond that provided by the shell itself - such as `sed`, and
`awk`. In some systems the default versions of these utilities are not
sufficiently _POSIX.1_ compliant - i.e. they do not provide the functionality
required by the libraries. For many such systems, more capable versions of these
utilities _are_ available, only they are not the default tool found via `PATH`.

While it would be possible to provide configuration points for each such utility
used, this quickly becomes unwieldy and can somewhat obfuscate the
implementation details.

Instead, workarounds are provided for some of the known issues for
utilities - often by way of using a different utility. These are automatically
enabled when required, but can also be forced if automatic detection fails. This
works well in many cases, but it requires a reasonable workaround be available,
which is not always true.

For any system that has a default utility that is not sufficiently capable but
that has an alternative version available that _is_ it is relatively trivial to
ensure the libraries use the more capable tool _without_ requiring specific
configuration options:

- Set `PATH`:
  - the most obvious method to accomplish this is to alter the `PATH` variable
    to ensure the more capable tool is located before the alternative
  - this can be changed at system level, or just at script level
- Use an alias:
  - For example: `alias awk=/usr/local/bin/nawk`
  - defining an alias that has the same name as the utility will cause the alias
    to be invoked _instead_ of the utility
  - note than some shells disable alias expansion in non-interactive shells by
    default (e.g. `bash`)
- Use a function:
  - For example: `awk() { echo 'Using nawk' >&2; /usr/local/bin/nawk "$@"; }`
  - mostly equivalent to an alias, but aliases are limited in functionality

In all cases, provided these configurations are in place when the given utility
is **invoked** they alternative will be used instead.[^invoked_not_parsed]

[^invoked_not_parsed]: These configurations options do **not** have any affect
                       when a library is _parsed_, only when the code is
                       actually _invoked_. However, libraries _may_ invoke
                       utilities during sourcing in order to determine which
                       workarounds to use. It is advisable to ensure these are
                       configured _prior_ to sourcing to avoid any unexpected
                       issues.

<!-- ................................................... -->
<!-- cSpell:Ignore matchex matchbre matchere             -->
<!-- ................................................... -->

### PATTERN MATCHING

TL;DR:
<!-- -->

- Pattern matching using [wildcards](#pattern-matching-wildcards), or
  [Regular Expressions](#pattern-matching-regular-expressions) is supported for
  some commands in libraries;
- Support for specific expressions is implementation dependent;
- In particular, [Wildcard](#pattern-matching-wildcards) patterns will use a
  fallback implementation in certain circumstances - this is significantly
  slower, but required to provide portable behavior;
- The locale in effect changes what an expression will match - it is **not**
  possible to alter the locale for a currently running shell.

Details:
<!-- -->

Some commands support pattern matching in various situations. Such commands
support either [wildcards](#pattern-matching-wildcards), or
[regular expressions](#pattern-matching-regular-expressions), or more often
both.

The type of pattern matching used is specified the same way in all libraries,
via either a `grep` like option:

- `-E`, `--ere`, or `--extended-regexp`, for
  ["Extended Regular Expressions"][posix_ere]
- `-G`, `--bre`, or `--basic-regexp`, for
  ["Basic Regular Expressions"][posix_bre]
- `-W`, `--glob`, or `--wildcard`,
  for ["Pattern Matching Notation"][posix_glob]

or a `test` like primary:

- `-[not]ere`, `-[not]matchex`, `-[not]matchere`, `=~`, or `!~` for
  ["Extended Regular Expressions"][posix_ere]
- `-[not]bre`, `-[not]match` and `-[not]matchbre`, for
  ["Basic Regular Expressions"][posix_bre]
- `-[not]like` for ["Pattern Matching Notation"][posix_glob]

In some cases the test like primaries also support flags that affect how the
comparison is performed, these flags are specified as a suffix to the primary,
following a single `:` (`<colon>`) character:

- `s` (as in `-bre:s`) specifies _Single Line Mode_;
- `m` (as in `-ere:m`) specifies _Multi-line Mode_.

In _Single Line Mode_ some operations can be made significantly faster, however
it is not possible to match `<newline>` characters (or match across line
breaks), while _Multi-line Mode_ has no such restrictions. If no suffix is
specified, `m` is implied.[^single_line_mode]

[^single_line_mode]: The difference is effectively the difference between `grep`
                     and `awk` or `sed` - the latter can match patterns across
                     multiple lines, while the former can not.

_Note that using `s` _may_ **decrease** performance if values contain_
_`<newline>` characters, although this usage is supported._

_PORTABILITY_
<!-- ---- -->

- From testing it seems that in many cases
  ["Basic Regular Expressions"][posix_bre] tend to be the most consistently well
  supported across implementations, in addition they also are often faster than
  ["Extended Regular Expressions"][posix_ere] and the fallback implementations
  for wildcards. As such, for maximum portability with the best performance in
  all cases it is advisable to use ["Basic Regular Expressions"][posix_bre]
  when possible, however, it remains important to test specific expressions on
  any platform they may be used.

<!-- --------------------------------------------------- -->

#### PATTERN MATCHING: WILDCARDS

TL;DR:
<!-- -->

- Wildcard patterns are implemented using the shell whenever possible - the
  locale the shell was invoked with determines what can be matched;
- Support for specific expressions is implementation dependent;
- Fallback implementations are provided for shell implementations that do not
  handle wildcard patterns as expected - this is significantly slower;
- Expressions either match an _entire value_ or do not match (i.e. exactly
  like `case`).

Details:
<!-- -->

_Wildcard_ pattern matching, also known as _globbing_, is defined in the
standard as ["Pattern Matching Notation"][posix_glob], and is implemented in the
shell itself.[^wildcard_name]

[^wildcard_name]: It is unfortunate that the standard uses the term
                  _Pattern Matching_ to refer specifically to this form of
                  pattern matching. Except where referring directly to the
                  standard, variations on the terms _wildcard_ or _glob_ are
                  preferred across the suite, with the term _pattern matching_
                  used as an umbrella term that also includes regular
                  expressions. (Historically, "glob" was used only for file
                  matching, however, it is more widely applied now.)

Where library commands provide _wildcard_ support:

- patterns _only_ match if they match an _entire_ value (i.e. the pattern
  is "anchored" to both the start and end of a value);
- only the characters `*` (`<asterisk>`), `?` (`<question mark>`), and
  `[` (`<left-square-bracket>`) are special - all other characters are
  literal;[^special_characters]
- patterns can match `<newline>` characters, either explicitly or with the use
  of `*` (`<asterisk>`) or `?` (`<question mark>`).

[^special_characters]: Note that `]` (`<right-square-bracket>`) is  _only_
                       special if preceded by a `[` (`<left-square-bracket>`),
                       while `|` (`<vertical-line>`) is only special when used
                       with `case` (and is _not_ special for library commands).

As a relatively simple form of matching being provided by the shell itself,
_wildcard_ matching is often the best performing of the pattern matching
options.

_PORTABILITY_
<!-- ---- -->

- **Some characters are problematic for some implementations:**
  - the characters `\` (`<backslash>`), `(` (`<left-parenthesis>`), and
    `)` (`<right-parenthesis>`) are all known to be handled differently in
    different implementations, making portable usage difficult;
  - if a pattern uses one of these characters _and_ the current implementation
    does not process it as expected, _wildcard_ matching will be handled using
    the fallback implementation (see below).
- _Using a `]` (`<right-square-bracket>`) **inside** a bracket expression (i.e._
  _`[...]...]`) is difficult (or impossible) to do portably._
- Escaping characters can be achieved using `[*]`, `[?]`, or `[[]`. (This avoids
  the noted issues with `\` (`<backslash>`).)
- Some implementations provide additional pattern matching operators using
  specific sequences (commonly `*(...)`, `+(...)`, `?(...)`, `@(...)`,
  `!(...)`, though others are possible). These can generally be
  disabled/enabled using implementation specific options settings and are
  often disabled by default. These extensions _may_ or _may not_ affect the
  commands in this library[^glob_extensions], to avoid any potential issues
  it is advisable to write any such sequences as `[*](...)`, etc.
- The locale in effect for patten matching is **always** the locale in effect
  when the shell was first invoked. _It is **not** possible to alter the_
  _locale of a currently running shell._

[^glob_extensions]: Although pattern matching is used in several different
                    places in the shell (e.g. `case` matches, file expansion,
                    etc.) - each has very slightly different rules (e.g.
                    `case` supports `|` while file expansion does not).
                    Whether or not any extensions will affect specific
                    pattern matching is implementation defined, and not
                    always clearly indicated.

**In various situations _wildcard_ matching does not work as might be expected**
**- in these cases fallback code is used that is markedly slower, but more**
**predictable.**

Fallback implementation(s) are written using `awk` and are required:

- for _wildcards_ containing `\` (`<backslash>`), `(` (`<left-parenthesis>`), or
  `)` (`<right-parenthesis>`) **if** the current shell does not handle these as
  expected;
- if the current shell does not support multi-byte characters correctly with
  _wildcards_ and the current locale is _not_ the _POSIX_ locale;
- the shell was invoked in the _POSIX_ locale but the current locale is
  different.

Tests are performed when a library is sourced to determine if any of these
apply. (See
[BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB](#better_scripts_config_shell_supports_portable_glob)
and [BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC](#better_scripts_config_shell_supports_mbc).)

<!-- --------------------------------------------------- -->

#### PATTERN MATCHING: REGULAR EXPRESSIONS

TL;DR:
<!-- -->

- Regular Expression patterns are implemented using `awk`, `sed`, or `grep`
  depending on the use case and configuration;
- Support for specific expressions is implementation dependent;
- Different utilities _can and do_ support different expressions;
- In contrast to Wildcard patterns, the locale in use _can_ be modified.

Details:
<!-- -->

Both ["Basic Regular Expressions"][posix_bre] (_BRE_) and
["Extended Regular Expressions"][posix_ere] (_ERE_) are supported.

Patterns are **not** anchored by default and will match if **any** part of
the value matches the regular expression (e.g. the expression `.` will always
match any value containing one or more characters).

In _Multi-line Mode_, _BRE_ are implemented using `sed`, while _ERE_ use
`awk`.[^expr_usage]

[^expr_usage]: Although `expr` is faster than `sed` for _BRE_ matching, it is
               hard to use portably and has many limitations that do not affect
               `sed` - as such it is not used for pattern matching as it can
               not be guaranteed to function as expected.

In  _Single Line Mode_, both _BRE_ and _ERE_ use `grep`.

Note that as different tools are utilized in each mode it is possible that
support for specific expressions may differ (e.g. on Solaris the default `awk`
does not support _ERE_ that the default `grep` supports).

Note that in multi-line mode anchors will match the start (`^`) and end (`$`)
of the _entire_ value (i.e. not the start and end of a line).[^anchors]

[^anchors]: Although this seems widely supported for the utilities described
            by the standard, more generally this is an area where regular
            expression implementations often diverge, which often leads to
            subtle and difficult to diagnose bugs. Use with care.

_PORTABILITY_
<!-- ---- -->

- Different modes are implemented using different tools, as such behavior
  _may_ be different between modes (e.g. supported expressions may differ).
- Although literal `<newline>` characters are permitted in both _BRE_ and
  _ERE_ (for supported commands), it is highly advisable to use `\n` (i.e.
  `<slash>n`) instead.
- Both _BRE_ and _ERE_ are subject to a great many portability issues,
  with some implementations being significantly less capable than the
  standard requires. The [`autoconf` docs][autoconf_portable] contains
  possibly the most extensive list of issues: see [`awk`][autoconf_awk],
  [`grep`][autoconf_grep], and [`sed`][autoconf_sed].
- _BRE_ seem to be more consistently well supported than _ERE_.
- The complexity of an expression can change how portable it is - of
  particular note are optional (or null) matches, which can trip up less
  capable engines. _These seldom produce errors_, instead only incorrect
  matches are produced.

<!-- ................................................... -->

### PERFORMANCE

TL;DR:
<!-- -->

- All libraries try to balance performance, portability, and configurability;
- Certain configuration options can alter performance;
- The largest single factor affecting performance is the implementation(s) of
  the utilities used.

Details:
<!-- -->

- Libraries have been written to maximize performance without sacrificing
  configurability, safety or utility - with a general philosophy of "you don't
  pay for what you don't use".
- For _most_ use cases library performance should not be an issue and will
  likely be far outweighed by other factors.
- Where library performance _is_ an issue, configuration of each library can
  have a significant affect on performance. Where configuration is known to
  affect performance, this is noted.
- The most significant factor in the performance of any library is the specific
  external commands used by a library:
  - The shell used is the single most significant factor, for example, `bash` is
    highly user friendly and provides many advanced tools beyond those required
    by the standard, however the much less well specified `dash` performs
    significantly better for all suite libraries.
  - Utilities like `sed`, `grep`, `awk`, etc. are available in multiple
    implementations, each of which has it's own performance characteristics.
- Many libraries provide emulated versions of data structures that are not
  normally available. These are stored in in a standard shell variable which is
  manipulated using standard utilities or the shell command language.
  **Performance of these data structures is highly dependent on the**
  **size of the data stored.** Although implementation dependent, shells tend to
  be optimized for processing _short_ strings, with strings that may be
  hundreds or thousands of characters long performance can rapidly decrease.

<!-- ................................................... -->

### IMPLEMENTATION

There are many choices made in the implementation of the tools that may seem
unusual, however, largely these choices have been made for good reason.

Of particular note are the extensive use of `case` where `test` might be
expected and the use of quotes where they may not be required.

The extensive use of `case` in place of `test` is for reasons of performance:
replacing `test` with `case` has a measurable impact on the performance of the
tools, sometimes dramatically so.

<!-- ................................................... -->
<!-- cSpell:Ignore libsh shlib shelllib                  -->
<!-- cSpell:Ignore shboost shellboost                    -->
<!-- ................................................... -->

### PRIOR ART (OR WHY YET ANOTHER SHELL LIBRARY?)

There are literally hundreds, perhaps thousands, of libraries for shell
programming. A search for any of `libsh`, `shlib`, `libshell`, `shelllib`,
`shboost`, or `shellboost`, for example will return dozens upon dozens of
libraries - most of which are designed for shell programming. However, the
quality, scope, and usefulness of these varies greatly, with common issues
including: targeting a limited number of shells; limited scope; poor
documentation; poor portability.[^library_list]

[^library_list]: It would be impossible to list even a fraction of those that
                 are available, however the
                 ["Awesome Shell" list][awesome_shell_git] provides a curated
                 list of some of the better libraries.

While many of these libraries are undoubtedly useful, even the best available
were found to be, in one way or another, unsuitable for the purposes that
`shtoolkit` now exists to fulfill.

<!-- ................................................... -->

### AI

**_No library code was originated by AI._**

AI has been used in the following ways:

- _Auditing:_ all code and documentation (including this file) has been
  audited by AI for correctness, including but not limited to checking for
  bugs and security issues, verifying that comments accurately reflect the
  code they document, and confirming that documentation is written clearly
  and unambiguously.
- _Fixes:_ where an audit identifies an issue, AI will issue a fix. Every change
  is fully reviewed before being accepted (and not every fix _is_ accepted);
  nothing is committed unreviewed.
- _Tests:_ most tests are hand-written; some have been added by AI, typically
  simple additions extending existing coverage where it was previously
  missing.

All libraries are written first by hand, to a fully functional level - only
once a library is felt to be near release ready is AI involved (in the ways
noted above).

Note that while there is significant disagreement over the use of AI in
general, and it is, understandably, anathema for many, its use has permitted
`shtoolkit` to be maintained and updated to an extent that would otherwise not
have been possible (due to a number of factors).

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## CAVEATS

The tools and libraries in `shtoolkit` are subject to the limitations imposed
by the particular environment in which they are invoked. Each implementation of
the required utilities and command execution environment will have specific
limitations that may be different to those in another implementation and may
change between versions of the same utilities.[^standard_limits]

[^standard_limits]: Many of these limitations are specified in the standard,
                    with specific constraints, though generally the actual value
                    is "implementation defined".

For most use cases it is deemed unlikely that these limitations will be an
issue, however, there will be cases where some limitations may cause problems.

<!-- ................................................... -->

### COMMAND LINE LENGTH LIMIT

It is impossible to determine all the possible limitations that may exist or may
be of issue (even when considering only those specified in the standard).
However, of the known limitations, perhaps the most likely to be encountered
across multiple libraries is the command line length limit, which can be
encountered in a number of scenarios, and in unexpected ways.

The standard specifies this as [`{ARG_MAX}`][posix_exec] and defines it as:

> The number of bytes available for \[a] new process' combined argument and
> environment lists... It is implementation-defined whether null
> terminators, pointers, and/or any alignment bytes are included in this
> total.

The value for any particular environment can be queried using the command
`getconf ARG_MAX`, though this value can only be used as a guide since it is
impossible to know how many bytes any command will require in advance - indeed
the command line length limit does _not_ apply to all commands: this limit does
not apply to any shell builtin commands.[^builtin_arg_max]

[^builtin_arg_max]: Given that each shell implementation has a different set
                    of commands that are builtin this means that when and
                    where this limit may be hit is very difficult to determine.
                    Additionally some commands are available as both builtin and
                    standalone commands - it is possible to invoke either but
                    only the standalone command is subject to the command line
                    length limitation. For a shell like `busybox` _everything_
                    can be a builtin command and the command line length limits
                    may not apply.

For a modern system the value of the command line length limit can be several
million bytes, while older systems it can be significantly less, though it _is_
possible to increase the available command line length for commands, by, for
example:

- reducing the number (and size) of exported variables;
- avoiding characters that use more than a single byte;
- changing system settings to increase the size of `ARG_MAX`.[^arg_max_size]

[^arg_max_size]: On at least some systems, the size of `ARG_MAX` is tied to
                 other system settings and can be increased by modifying those
                 configurables. This must be done with care, however, as these
                 values affect how many different systems interact and may cause
                 issues that are not immediately obvious.

Importantly, any variable which is exported and also has it's _contents_ used as
an argument to a command will count **TWICE** towards this limit.

It is recommended that variables containing library data are _not_ exported.

<!-- --------------------------------------------------- -->

#### LINUX `MAX_ARG_STRLEN`

While the Linux kernel uses `ARG_MAX` as defined in the standard, it adds an
additional restriction which is **not** standard - each argument passed to a
command is subject to a maximum length as defined by `MAX_ARG_STRLEN`. Sadly,
this value can not be directly queried in the shell, but appears to be hardcoded
in the kernel as `PAGE_SIZE * 32` which on many (all?) systems appears to equate
to `131072`.

_Any single argument larger than this can never be passed to a command in Linux._

<!-- ................................................... -->

### INTERNAL COMMANDS & VARIABLES

All libraries require a number of internal commands and variables to provide
the provided functionality, these are distinguishable from other values by a
prefix: commands these are prefixed with `fn_bs_`; while variables are prefixed
with `g_BS_`, `c_BS_`, or `i_BS`.

These are **strictly** for internal usage and **must not** be invoked or
referenced outside the library to which they belong.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- %                                                                       -->
<!-- % ## SEE ALSO                                                           -->
<!-- %                                                                       -->
<!-- % getarg(1), libgetargs(7), libarray(7), libdeque(7), libpath(7)        -->
<!-- %                                                                       -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- REFERENCES -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

[shtoolkit_repo]:             <https://github.com/BetterScripts/shtoolkit>                                                          "BetterScripts shtoolkit \[github.com\]"
[awesome_shell_git]:          <https://github.com/alebcay/awesome-shell>                                                            "Awesome Shell \[github.com\]"

[posix]:                     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                       "POSIX.1-2008 \[pubs.opengroup.org\]"
[posix_2013]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2013edition>                                       "POSIX.1-2013 \[pubs.opengroup.org\]"
[posix_2016]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2016edition>                                       "POSIX.1-2016 \[pubs.opengroup.org\]"
[posix_2018]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2018edition>                                       "POSIX.1-2018 \[pubs.opengroup.org\]"
[posix_2024]:                <https://pubs.opengroup.org/onlinepubs/9799919799.2024edition>                                       "POSIX.1-2024 \[pubs.opengroup.org\]"

[posix_bre]:                  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>      "Basic Regular Expression \[pubs.opengroup.org\]"
[posix_ere]:                  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>      "Extended Regular Expression \[pubs.opengroup.org\]"
[posix_dot]:                  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#dot>           "POSIX: dot \[pubs.opengroup.org\]"
[posix_param_expansion]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02>  "POSIX: Parameter Expansion \[pubs.opengroup.org\]"
[posix_cmd_subs]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_03>  "POSIX: Command Substitution \[pubs.opengroup.org\]"
[posix_arith_expansion]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_04>  "POSIX: Arithmetic Expansion \[pubs.opengroup.org\]"
[posix_shell_utils]:          <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/idx/xcu.html>                           "POSIX: Shell & Utilities \[pubs.opengroup.org\]"
[posix_exec]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/functions/execl.html>                   "POSIX: exec \[pubs.opengroup.org\]"
[posix_glob]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_13>     "Pattern Matching Notation \[pubs.opengroup.org\]"

[markdown]:                   <https://daringfireball.net/projects/markdown/syntax>                                                 "Markdown: Syntax \[daringfireball.net\]"
[commonmark]:                 <https://commonmark.org/>                                                                             "CommonMark \[spec.commonmark.org\]"

[sysexits]:                   <https://www.freebsd.org/cgi/man.cgi?sysexits(3)>                                                     "FreeBSD SYSEXITS(3) \[freebsd.org\]"
[semver]:                     <https://semver.org/>                                                                                 "Semantic Versioning \[semver.org\]"

[inclusivenaming]:            <https://inclusivenaming.org/>                                                                        "Inclusive Naming Initiative \[inclusivenaming.org\]"

[man_page]:                   <https://wikipedia.org/wiki/Man_page>                                                                 "man page \[wikipedia.org\]"

[gnu_non_gnu_stds]:           <https://www.gnu.org/prep/standards/html_node/Non_002dGNU-Standards.html>                                   "Non-GNU Standards \[gnu.org\]"

[autoconf_portable]:          <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>                  "autoconf: Portable Shell Programming \[gnu.org\]"
[autoconf_awk]:               <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#awk>  "autoconf: Limitations of Usual Tools \[gnu.org\]"
[autoconf_sed]:               <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#sed>  "autoconf: Limitations of Usual Tools \[gnu.org\]"
[autoconf_grep]:              <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#grep> "autoconf: Limitations of Usual Tools \[gnu.org\]"

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- END OF FILE -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
