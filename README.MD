<!-- % % betterscripts(7) BetterScripts | BetterScripts POSIX Suite.         -->
<!-- % % BetterScripts (better.scripts@proton.me)                            -->
<!-- ^^^^^^^^^^^^^^^^^^^^^^^^^^ `pandoc` metadata ^^^^^^^^^^^^^^^^^^^^^^^^^^ -->
<!-- SPDX-License-Identifier: MPL-2.0 -->
<!-- ############################### LICENSE ############################### -->
<!--                                                                         -->
<!-- BetterScripts 'README.MD': Information common to the entire             -->
<!--                            BetterScripts POSIX Suite.                   -->
<!--                                                                         -->
<!-- Copyright (c) 2022 BetterScripts ( better.scripts@proton.me,            -->
<!--                                    https://github.com/BetterScripts )   -->
<!--                                                                         -->
<!-- This file is part of the BetterScripts POSIX Suite.                     -->
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
<!-- https://github.com/BetterScripts/posix/LICENSE.MD.                      -->
<!--                                                                         -->
<!-- NOTE:                                                                   -->
<!--                                                                         -->
<!-- The Mozilla Public License v2.0 is compatible with the GNU General      -->
<!-- Public License v2.0.                                                    -->
<!--                                                                         -->
<!-- ----------------------------------------------------------------------- -->
<!-- cSpell:Ignore libarray libgetargs getargs getarg                        -->
<!-- ####################################################################### -->

# BETTERSCRIPTS POSIX SUITE

An ever growing suite of libraries which aim to make portable scripting easier,
safer, and more efficient written for scripts written for "command
interpretation services and common utility programs" as defined in the
["Shell and Utilities"][posix_shell_utils] volume of the
[_POSIX.1-2008_][posix] standard.

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

### LIBRARIES

------------------------------------------------------------

[`libarray.sh`](./libarray.md)

- Emulated arrays for any shell.

------------------------------------------------------------

[`libgetargs.sh`](./libgetargs.md)

- Argument processing made easy - like `getopt` or `getopts`
  but much more powerful, while requiring less work.

------------------------------------------------------------

[`getarg`](./getarg.md)

- Wrapper for `libgetargs.sh` which allows invoking without
  needing to be sourced.

------------------------------------------------------------

## ENVIRONMENT

Several variables affect the libraries, some of these should be set to specific
values for the suite to work as intended[^setting_variables], while others
determine suite settings.

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

### SHELL CONFIGURATION

All libraries assume the _POSIX.1_ defined default environment is in effect.

**Much of the _POSIX.1_ standard is _only_ defined for this environment.**

#### `LC_ALL`

- Should be set to `C` or the equivalent `POSIX`. (Other
  values _may_ work, but are _not_ supported.)
- Standards compliant shells and utilities will give
  `LC_ALL` precedence over other locale setting variables,
  however these additional locale variables may be
  (incorrectly) used in some cases and so may also need set.
  The standard also defines `LANG`, `LC_COLLATE`,
  `LC_CTYPE`, `LC_MESSAGES`, `LC_MONETARY`, `LC_NUMERIC`,
  and `LC_TIME`, with some platforms extending this further
  still.
- Note that setting the locale to `C` or `POSIX` does _not_
  preclude using not in the locale, but _may_  affect how
  those characters are interpreted.

------------------------------------------------------------

#### `IFS`

- Should be the standard defined default of
  ` \t\n` (`<space><tab><newline>`).
- A number of shell operations are defined with reference
  to the value contained in `IFS`, making it a powerful
  tool, but also a source of many frustrations. While the
  libraries in _the Suite_ attempt to avoid any dependence
  on the value of `IFS`, it is near impossible to ensure
  this is actually the case as the effects of `IFS` are
  often somewhat hidden and can be easy to miss.
- Although much better supported in modern environments,
  traditionally the use of `IFS` was highly implementation
  dependent. Less mainstream environments may still retain
  quirks that make it difficult to use `IFS` portably.

------------------------------------------------------------

#### `POSIXLY_CORRECT`

- Should be set if any GNU tools are to be used.
- A non-standard environment variable used primarily by
  [GNU provided tools][gnu_non_gnu_stds], but may have been
  adopted by others. Tells these commands to more closely
  match the standard than they otherwise would.
- Many GNU tools significantly deviate from the standard
  unless this is set (regardless of the current locale).
  (Exactly which tools deviate and if it is actually an
  issue is hard to determine in advance.)

------------------------------------------------------------

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
  special and forces the use of automatic detection. _A flag that is unset_
  **or** _set but null (i.e. empty) will use an appropriate default value._

Configuration variables are never modified by a library.

Many configuration variables can be set for all libraries with a single, suite
wide variable. Where such a suite wide variable is available a library specific
variable is always available in addition and has precedence. (Not all libraries
use all suite wide settings.)

Suite wide variables include:

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[<IDENTIFIER>]: ERROR: <MESSAGE>`.
- _ON_: library error messages will be suppressed.
- Each library also stores the most recent error message in
  a library specific variable, which is unaffected by this
  flag.
- Unless otherwise stated, both the library versions of
  this option and the suite version can be modified between
  command invocations and should affect the next command.
- Does not affect errors from non-library commands, which
  _may_ still produce output.

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_FATAL_ERRORS`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Enable/\[Disable] causing library errors to terminate
  the current (sub-)shell.
- _OFF_: errors stop any further processing, and cause a
  non-zero exit status, but do not cause an exception.
- _ON_: any library error will cause an "unset variable"
  shell exception using the
  [`${parameter:?[word]}`][posix_param_expansion]
  parameter expansion, where `word` is set to an error
  message that _should_ be displayed by the shell (this
  message is NOT suppressed by
  [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](#better_scripts_config_quiet_errors)).
- Unless otherwise stated, both the library versions of
  this option and the suite version can be modified between
  command invocations and should affect the next command.

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_NO_MULTIDIGIT_PARAMETER`

- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using only single digit shell
  parameters, i.e. `$0` to `$9`.
- _OFF_: Use multi-digit shell parameters.
- _ON_: Use only single-digit shell parameters.
- Multi-digit parameters are faster but may not be
  supported by all implementations.

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_NO_SHIFT_N`

- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using only `shift` and not `shift N`
  for multiple parameters.
- _OFF_: Use `shift N`.
- _ON_: Use only `shift`.
- Multi-parameter `shift` is faster but may not be
  supported by all implementations

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_NO_DEV_NULL`

- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using alternatives to `/dev/null` as
  a redirection source/target (e.g. for output
  suppression).
- _OFF_: Use `/dev/null`.
- _ON_: Use an alternative to `/dev/null`.
- Using `/dev/null` as a redirection target is a
  common idiom, but not always possible (e.g.
  restricted shells generally forbid this), the
  alternative is to capture output (and ignore it)
  but this is much slower as it involves a subshell.

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_NO_EXPR_BRE_MATCH`

- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using alternatives to `expr` for
  matching a
  ["Basic Regular Expression (_BRE_)"][posix_bre].
- _OFF_: Use `expr`.
- _ON_: Use an alternative command (i.e. `sed`).
- `expr` is much faster if it works correctly, but
  some implementations make that difficult, while
  `sed` is more robust for this use case.

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_NO_EXPR_EXIT_STATUS`

- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable ignoring `expr` exit status to
  indicate a match was made.
- _OFF_: Use `expr` exit status to determine if a match
  was made.
- _ON_: Use a workaround to determine if a match was
  made. (This requires a sub-shell and is therefore far
  slower.)
- Some versions of `expr` do not always properly set the
  exit status, making it impossible to determine if a
  match was actually made.

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_NO_EXPR_NESTED_CAPTURES`

- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- Disable/\[Enable] using `expr` for any
  ["Basic Regular Expression" (_BRE_)][posix_bre] that
  includes nested captures.
- When set, any _BRE_ that uses nested captures will not
  be used with `expr`, but will use a case specific
  work-around.
- Some versions of `expr` do not work well with or do not
  support nested captures.

------------------------------------------------------------

#### `BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`

- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
  _POSIX.1_ like behavior.
- _OFF_: Use `setopt` to set the appropriate options.
- _ON_: Don't use `setopt`, even in _Z Shell_.
- Automatically enabled if _Z Shell_ is detected.
- Any use of `setopt` is scoped as tightly as possible
  and should not affect other commands.
- If _Z Shell_ is used and the current environment has
  already been set to be _POSIX.1_ compliant, forcing this
  _ON_ may improve performance.
- _Z Shell_ has some defaults that cause non-standard
  behavior, however also provides `setopt` which can be
  tightly scoped to set options when required without
  impacting other platforms.[^z-shell-support]

[^z-shell-support]: Technically since the default
  configuration of _Z Shell_ is non-standard it is not
  supported by the suite, however this work-around is
  provided since it can be easily scoped, and does not
  notably affect performance, and causes no issues with
  other environments. Similar work-arounds for other
  environments are not always possible (e.g. the GNU
  specific [`POSIXLY_CORRECT`][gnu_non_gnu_stds] environment
  variable can not so easily be dealt with).

------------------------------------------------------------

### LIBRARY INFORMATION

Each library provides a number of variables that are set by the library to
convey information outside of command invocation.

These variables must not be set by external commands except if this is
_explicitly_ permitted. Variables may use the `readonly` command to enforce
this.

Along with any library only information variables, every library also
provides a version of some standard variables:

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

- Stores the error message of the _most recent_ library
  error.
- ONLY valid immediately following a command from the
  appropriate library for which the exit status is not
  a success code.
- Valid even when error output is suppressed.

------------------------------------------------------------

#### `BS_<LIBRARY>_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to
  determine if a specific library has been sourced.
- Also serves as a guard to avoid errors caused by sourcing
  a library multiple times.

------------------------------------------------------------

### ADDITIONAL VARIABLES

#### `BETTER_SCRIPTS_PATH`

- Should be set to the location _the Suite_ is installed.
- Multiple paths may be specified - formatted like the
  standard variable `PATH`.
- Useful for users if libraries are not installed in a
  location that is available in `PATH`.
- _Currently unused by libraries._

------------------------------------------------------------

## STANDARDS

- [_POSIX.1-2008_][posix]
  - Also known as:
    - _The Open Group Base Specifications Issue 7_
    - _IEEE Std 1003.1-2008_
    - _The Single UNIX Specification Version 4 (SUSv4)_
  - The more recent [_POSIX.1-2017_][posix_2017] is functionally
    identical to _POSIX.1-2008_, but incorporates some errata.
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

## NOTES

### INSTALLATION

The suite provided [Makefile](./Makefile) has targets that allow for
installation of both libraries and documentation in configurable locations (by
default libraries are installed in `/usr/local/bin`, `Markdown` documentation
in `/usr/local/share/doc` and `man` page documentation in the appropriate
`/usr/local/share/man` directory for the documentation category - note that
these are not _POSIX.1_ specified).

Most of the suite libraries are intended to be sourced by other scripts using
the [`.` (aka dot) command][posix_dot], for which the standard says:

> If file does not contain a \<slash>, the shell shall use the search path
> specified by PATH to find the directory containing file. Unlike normal
> command search, however, the file searched for by the dot utility need
> not be executable.

As such libraries are installed as non-executable unless direct invocation is
supported for a specific library.

More information about installation is available by invoking the `help` target
from the [Makefile](./Makefile), i.e. `make help`.

### DOCUMENTATION

Up-to-date versions of documentation for each library is always present in
the main [_BetterScripts POSIX suite_ repository][betterscripts_git] in both
[`Markdown`][markdown] and [`man` page][man_page] formats.

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

### COMMAND DOCUMENTATION

Library commands document arguments with a tag indicating argument usage:

- _in_: provides data **TO** the command.
- _out_: receives data **FROM** the command.
- _in/out_: provides data **TO** **AND** receives data
  **FROM** the command.
- _ref_: an additional tag indicating the argument is
  passed by **NAME** instead of **VALUE**.
  - For a typical _POSIX.1_ variable this means omitting the
    `$` from the name when passing it to the command, i.e.
    instead of passing `$Variable` (or `${Variable}`)
    use `Variable`.
  - Only _POSIX.1_ compliant names are permitted. Due to the
    security considerations of using `eval` with arbitrary
    text _POSIX.1_ names are enforced for all variable
    names; providing a non-standard name will cause an error
    (even if the name is supported by the current shell).
  - Variables passed by name are GLOBAL variables.
    The use of `local` variables (as supported by many
    shells) will **not** work as expected. (_POSIX.1_ has
    no concept of `local` variables.)

### COMPATIBILITY

The _Better Scripts POSIX Suite_ is supported in any environment that is
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
workarounds implemented are unnecessary._[^legacy_systems]

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
                   can continue to support very old software. Where practicable,
                   _the Suite_ is intended to support all such systems.

Additionally:

- The _POSIX.1_ standard has remained relative consistent between versions (as
  relates to functionality required by _the Suite_), although the
  [_POSIX.1-2008_][posix] version of the standard is the reference version used
  for creating _the Suite_ it is likely that earlier versions will also be
  supported.
- Non-compliant shells and utilities may be supported by specific libraries, or
  specific commands within those libraries.
- A shell and/or utilities which are _not_ supported _may_ still be able to make
  use of _the Suite_ - any such tool is termed _compatible_. The difference
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
  are run. These are not intended to determine platform support, but are
  primarily for regression testing. Additionally, the test harness, while
  _POSIX.1_ compliant, may require a more capable platform than that of
  individual libraries. Still, if tests run successfully for a specific
  platform it is likely the platform will be fully supported.

### PERFORMANCE

- Libraries have been written to maximize performance without sacrificing
  configurability, safety or utility - with a general philosophy of "you don't
  pay for what you don't use".
- For _most_ use cases library performance should not be an issue and will
  likely be far outweighed by other factors.[^lite-mode]
- Where library performance _is_ an issue, configuration of each library can
  have a significant affect on performance. Where configuration is known to
  affect performance, this is noted.
- The most significant factor in the performance of any library is the specific
  external commands used by the library:
  - The shell used is the single most significant factor, for example, `bash` is
    highly user friendly and provides many advanced tools beyond those required
    by the standard, however the much less well specified `dash` performs
    significantly better for all suite libraries.
  - Utilities like `sed`, `grep`, `awk`, etc. are available in multiple
    implementations, each of which has it's own performance characteristics.

[^lite-mode]: Initially there was an alternative version of each library
              which excluded as much of the main version as possible, while
              leaving most functionality intact, with the intention being that
              these versions would give the absolute best performance possible.
              This plan was ultimately abandoned as the resulting gains were
              surprisingly small despite the significant reduction in file
              sizes and customization - most of the expensive computation is
              unavoidable.

## CAVEATS

The tools and libraries in _the Suite_ are subject to the limitations imposed by
the particular environment in which they are invoked. Each implementation of the
required utilities and command execution environment will have specific
limitations that may be different to those in another implementation and may
change between versions of the same utilities.[^standard_limits]

[^standard_limits]: Many of these limitations are specified in the standard,
                    with specific constraints, though generally the actual value
                    is "implementation defined".

For most use cases it is deemed unlikely that these limitations will be an
issue, however, there will be cases where some limitations may cause problems.

### COMMAND LINE LENGTH LIMIT

It is impossible to determine all the possible limitations that may exist or may
be of issue (even when considering only those specified in the standard).
However, of the known limitations, perhaps the most likely to be encountered
across multiple libraries from _the Suite_ is the command line length limit,
which can be encountered in a number of scenarios, and in unexpected ways.

The standard specifies this as [`{ARG_MAX}`][posix_exec] and defines it as:

> The number of bytes available for \[a] new process' combined argument and
> environment lists... It is implementation-defined whether null
> terminators, pointers, and/or any alignment bytes are included in this
> total.

The value for any particular environment can be queried using the command
`getconf ARG_MAX`, though this value can only be used as a guide since it is
impossible to know how many bytes any command will require in advance. For a
modern system this value can be several million bytes, while older systems it
can be significantly less.

It _is_ possible to increase the available command line length for commands,
by, for example, by:

- reducing the number (and size) of exported variables;
- avoiding characters that use more than a single byte.

Importantly, any variable which is exported and also has it's _contents_ used as
an argument to a command will count **TWICE** towards this limit.

It is recommended that variables containing library data are _not_ exported.

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
<!-- % getarg(1), libgetargs(7), libarray(7)                                 -->
<!-- %                                                                       -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- ----------------------------------------------------------------------- -->
<!-- REFERENCES -->
<!-- ----------------------------------------------------------------------- -->

[betterscripts_git]:          <https://github.com/BetterScripts/posix>                                                              "BetterScripts POSIX Suite \[github.com\]"

[posix]:                      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                        "POSIX.1-2008 \[pubs.opengroup.org\]"
[posix_2017]:                 <https://pubs.opengroup.org/onlinepubs/9699919799>                                                    "POSIX.1-2017 \[pubs.opengroup.org\]"
[posix_dot]:                  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#dot>           "POSIX: dot \[pubs.opengroup.org\]"
[posix_bre]:                  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>      "POSIX: Basic Regular Expression \[pubs.opengroup.org\]"
[posix_ere]:                  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>      "POSIX: Extended Regular Expression \[pubs.opengroup.org\]"
[posix_re_bracket_exp]:       <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03_05>   "POSIX: RE Bracket Expression \[pubs.opengroup.org\]"
[posix_param_expansion]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02>  "POSIX: Parameter Expansion \[pubs.opengroup.org\]"
[posix_getopts]:              <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html>                 "POSIX: getopts \[pubs.opengroup.org\]"
[posix_utility_conventions]:  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap12.html>                "POSIX: Utility Conventions \[pubs.opengroup.org\]"
[posix_variable]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_230>     "Definitions: Name \[pubs.opengroup.org\]"
[posix_shell_utils]:          <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/idx/xcu.html>                           "POSIX: Shell & Utilities \[pubs.opengroup.org\]"
[posix_exec]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/functions/execl.html>                   "POSIX: exec \[pubs.opengroup.org\]"

[markdown]:                   <https://daringfireball.net/projects/markdown/syntax>                                                 "Markdown: Syntax \[daringfireball.net\]"
[commonmark]:                 <https://commonmark.org/>                                                                             "CommonMark \[spec.commonmark.org\]"
[commonmark_spec]:            <https://spec.commonmark.org/current/>                                                                "CommonMark Spec (current) \[spec.commonmark.org\]"

[sysexits]:                   <https://www.freebsd.org/cgi/man.cgi?sysexits(3)>                                                     "FreeBSD SYSEXITS(3) \[freebsd.org\]"
[semver]:                     <https://semver.org/>                                                                                 "Semantic Versioning \[semver.org\]"

[inclusivenaming]:            <https://inclusivenaming.org/>                                                                        "Inclusive Naming Initiative \[inclusivenaming.org\]"

[util_linux]:                 <https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/about/>                               "util-linux (about) \[git.kernel.org\]"

[pandoc]:                     <https://pandoc.org/>                                                                                 "Pandoc \[pandoc.org\]"

[man_page]:                   <https://wikipedia.org/wiki/Man_page>                                                                 "man page \[wikipedia.org\]"

[gnu_non_gnu_stds]:           <https://www.gnu.org/prep/standards/html_node/Non_002dGNU-Standards.html>                             "Non-GNU Standards \[gnu.org\]"
[autoconf_portable]:          <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>            "autoconf: Portable Shell Programming \[gnu.org\]"

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
