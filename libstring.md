<!-- #################################################################### -->
<!-- ############ THIS FILE WAS GENERATED FROM 'libstring.sh' ########### -->
<!-- #################################################################### -->
<!-- ########################### DO NOT EDIT! ########################### -->
<!-- #################################################################### -->

# LIBSTRING

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## SYNOPSIS

_Full synopsis, description, arguments, examples and other information is_
_documented with each individual command._

[`string_length [<OUTPUT>] <STRING>`](#string_length)

[`string_quote [<OUTPUT>] <STRING>`](#string_quote)

[`string_join [<OUTPUT>] <STRING>...`](#string_join)

[`string_toupper [<OUTPUT>] <STRING>`](#string_toupper)

[`string_tolower [<OUTPUT>] <STRING>`](#string_tolower)

[`string_trim [<OUTPUT>] <STRING> <LENGTH>`](#string_trim)

[`string_index [<OPTION>] [--] [<OUTPUT>] <STRING> <STRING>`](#string_index)

[`string_match [<OPTION>] [--] <STRING> <STRING>`](#string_match)

[`string_substr <OUTPUT> <STRING> <OFFSET> [<LENGTH>]`](#string_substr)

[`string_truncate [<OUTPUT>] <STRING> <LENGTH>`](#string_truncate)

[`string_sub [<OPTION>] [--] [<OUTPUT>] <STRING> <LENGTH>`](#string_sub)

[`string_gsub [<OPTION>] [--] [<OUTPUT>] <STRING> <LENGTH>`](#string_gsub)

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

Provides commands for _POSIX.1_ compliant shell to assist processing text
safely and robustly.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## EXIT STATUS

- For all commands the exit status will be `0` (`<zero>`) if, and only if,
  the command was completed successfully.
- For any command which is intended to perform a test, an exit status of
  `1` (`<one>`) indicates "false", while `0` (`<zero>`) indicates "true".
- An exit status that is _NOT_ `0` (`<zero>`) from an external command will
  be propagated to the caller where relevant (and possible).
- Exit status' not covered by any of the above use values as described in
  [FreeBSD `SYSEXITS(3)`][sysexits] - including the `EX_USAGE` which is used
  for all usage errors.
- Exit status is configuration agnostic.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## ENVIRONMENT

A number of environment variables affect the library, these are split into
variables that instruct the library to work-around specific platform issues,
and variables that convey user preferences. Variables that enable platform
specific work-arounds will be automatically set if needed, but can also be
set manually to force specific configurations.

In additional to these, there are a number of variables that are set by the
library to convey information outside of command invocation.

If unset, some variables will take an initial value from a common `shtoolkit`
variable applicable to all libraries, these allow the same configuration to
be used across libraries more easily.

After the library has been sourced, external commands must not set library
environment variables that are classified as _CONSTANT_. Variables may use
the `readonly` command to enforce this.

**_If not otherwise specified, an `<unset>` variable is equivalent to the_**
**_default value._**

_For more details see the `shtoolkit` general [documentation](./README.MD#environment)._

<!-- ------------------------------------------------ -->

### PLATFORM CONFIGURATION

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_NO_Z_SHELL_SETOPT`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`](./README.MD#better_scripts_config_no_z_shell_setopt)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
  _POSIX.1_ like behavior.
- Automatically enabled if _Z Shell_ is detected.
- Any use of `setopt` is scoped as tightly as possible
  and SHOULD not affect other commands.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_NO_DEV_NULL`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_DEV_NULL`](./README.MD#better_scripts_config_no_dev_null)
- Type:     _FLAG_
- Class:    _CONSTANT_
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

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_MBC`

- Suite:    [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC`](./README.MD#better_scripts_config_shell_supports_mbc)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] support for multi-byte character
  processing within the shell itself.
- _OFF_: use fallback code for operations affected.
- _ON_:  use internal shell operations.
- Default is to run tests for the current shell when a
  library is sourced to determine if such support is
  present.
- **WARNING:** Automatic tests assume the locale has not
  been set since the current shell was invoked - if this
  is not the case configuration will be incorrect.
- See
  [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC`](./README.MD#better_scripts_config_shell_supports_mbc)
  for details.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`

- Suite:    [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](./README.MD#better_scripts_config_shell_supports_portable_glob)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] glob/wildcard pattern matching even
  if the pattern contains known problematic characters.
- _OFF_: use fallback code for patterns that contain
  problem characters.
- _ON_:  use shell pattern matching.
- Default is to run tests for the current shell when a
  library is sourced to determine if the current shell
  supports these as expected or not.
- See
  [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](./README.MD#better_scripts_config_shell_supports_portable_glob)
  for details.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS`](./README.MD#better_scripts_config_no_param_expansion_char_class)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] using `[:...:]` character classes in
  parameter expansions.
- _OFF_: use fallback code.
- _ON_:  use character classes.
- Default is to use character classes if possible.
- Modern shell implementations generally support using
  character classes in parameter expansions, which
  results in much better performance than the
  alternatives.
- See
  [`BETTER_SCRIPTS_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS`](./README.MD#better_scripts_config_no_param_expansion_char_class)
  for details.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_NO_CASE_CHAR_CLASS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_CASE_CHAR_CLASS`](./README.MD#better_scripts_config_no_case_char_class)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic>
- Disable/\[Enable] using `[:...:]` character classes in
  `case` matches.
- _OFF_: use fallback code.
- _ON_:  use character classes.
- Default is to use character classes if possible.
- Modern shell implementations generally support using
  character classes in `case` matches, which results
  in much better performance than the alternatives.
- See
  [`BETTER_SCRIPTS_CONFIG_NO_CASE_CHAR_CLASS`](./README.MD#better_scripts_config_no_case_char_class)
  for details.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_TR_SUPPORTS_MBC`

- Suite:    [`BETTER_SCRIPTS_CONFIG_TR_SUPPORTS_MBC`](./README.MD#better_scripts_config_tr_supports_mbc)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic> (delayed)
- Disable/\[Enable] the use of `tr` outside the _POSIX_
  locale.
- _OFF_: do not use `tr` outside the _POSIX_ locale.
- _ON_: use `tr` for all locales.
- Some implementations of `tr` support _ONLY_ single-
  byte characters. Since it is difficult to determine if
  a string contains only supported characters, it is
  assumed that if the locale is not the _POSIX_ locale
  that _ALL_ strings contain multi-byte characters and so
  can not be correctly used with these versions of `tr`.
- See
  [`BETTER_SCRIPTS_CONFIG_TR_SUPPORTS_MBC`](./README.MD#better_scripts_config_tr_supports_mbc)
  for details.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_ALLOW_EXPR`

- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  _OFF_
- \[Disable]/Enable] the use of `expr` in some cases.
- _OFF_: do not use `expr`.
- _ON_: use `expr` by preference, fallback if it fails.
- For _Basic Regular Expressions_ `expr` is often the
  best performing utility available, however, it is also
  subject to significant portability issues that make it
  hard to use in the general case, therefore code that
  uses `expr` also needs fallback code to handle cases
  where it fails.
- When this variable is _OFF_, `expr` is not used and
  fallback code is used in all cases - this is safer, but
  loses some performance.
- When this variable is _ON_, fallback code is only used
  if `expr` fails - this is faster in general, but slower
  if `expr` always fails.
- Note that currently the use of `expr` is limited and
  will often be avoided entirely.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_NO_AWK_ARGV`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV`](./README.MD#better_scripts_config_no_awk_argv)
- Type:     _FLAG_
- Class:    _VARIABLE_
- Default:  `0` (Use `awk` `ARGV`)
- Disable/\[Enable] using `ARGV` within `awk` - enabling
  gives significantly better performance, but is subject
  to some limitations.
- _OFF_: Use `ARGV` within `awk`.
- _ON_: Avoid `ARGV` within `awk`.
- When _ON_ `ARGV` will be used whenever appropriate, if
  this fails (likely due one of the limitations), the
  code for the _OFF_ condition will be used to get the
  required results. This comes with a small cost as the
  `ARGV` code must first be run and fail (although this
  should be relatively fast, it does have an impact).
- This is _not_ autodetected as the point is not to test
  if `ARGV` is available (it is assumed to be), but
  if it should be used for performance reasons. There is
  no real way to test this it will be system and data
  specific.
- Note that since failure is highly input dependent this
  is a _VARIABLE_ value and can be changed between
  commands. This allows maximum performance in all cases
  if used appropriately.

<!-- ------------------------------------------------ -->

### INFORMATIONAL

Variables that convey library information.

---------------------------------------------------------

#### `BS_LIBSTRING_VERSION_MAJOR`

- Integer >= 1.
- Incremented when there are significant changes, or
  any changes break compatibility with previous
  versions.

---------------------------------------------------------

#### `BS_LIBSTRING_VERSION_MINOR`

- Integer >= 0.
- Incremented for significant changes that do not
  break compatibility with previous versions.
- Reset to 0 when
  [`BS_LIBSTRING_VERSION_MAJOR`](#bs_libstring_version_major)
  changes.

---------------------------------------------------------

#### `BS_LIBSTRING_VERSION_PATCH`

- Integer >= 0.
- Incremented for minor revisions or bugfixes.
- Reset to 0 when
  [`BS_LIBSTRING_VERSION_MINOR`](#bs_libstring_version_minor)
  changes.

---------------------------------------------------------

#### `BS_LIBSTRING_VERSION_RELEASE`

- A string indicating a pre-release version, always
  null for full-release versions.
- Possible values include 'alpha', 'beta', 'rc',
  etc, (a numerical suffix may also be appended).

---------------------------------------------------------

#### `BS_LIBSTRING_VERSION_FULL`

- Full version combining
  [`BS_LIBSTRING_VERSION_MAJOR`](#bs_libstring_version_major),
  [`BS_LIBSTRING_VERSION_MINOR`](#bs_libstring_version_minor),
  and [`BS_LIBSTRING_VERSION_PATCH`](#bs_libstring_version_patch)
  as a single integer.
- Can be used in numerical comparisons
- Format: `MNNNPPP` where, `M` is the `MAJOR` version,
  `NNN` is the `MINOR` version (3 digit, zero padded),
  and `PPP` is the `PATCH` version (3 digit, zero padded).

---------------------------------------------------------

#### `BS_LIBSTRING_VERSION`

- Full version combining
  [`BS_LIBSTRING_VERSION_MAJOR`](#bs_libstring_version_major),
  [`BS_LIBSTRING_VERSION_MINOR`](#bs_libstring_version_minor),
  [`BS_LIBSTRING_VERSION_PATCH`](#bs_libstring_version_patch),
  and
  [`BS_LIBSTRING_VERSION_RELEASE`](#bs_libstring_version_release)
  as a formatted string.
- Format: `BetterScripts 'libstring' vMAJOR.MINOR.PATCH[-RELEASE]`
- Derived tools MUST include unique identifying
  information in this value that differentiates them
  from the BetterScripts versions. (This information
  should precede the version number.)

---------------------------------------------------------

#### `BS_LIBSTRING_LAST_ERROR`

- Stores the error message of the most recent error.
- ONLY valid immediately following a command for which
  the exit status is not `0` (`<zero>`).
- Available even when error output is suppressed.

---------------------------------------------------------

#### `BS_LIBSTRING_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to
  determine if this file has been sourced.

<!-- ------------------------------------------------ -->

### USER PREFERENCE

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_QUIET_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
- Type:     _FLAG_
- Class:    _VARIABLE_
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[libstring::<COMMAND>]: ERROR: <MESSAGE>`.
- _ON_: library error messages will be suppressed.
- The most recent error message is always available in
  [`BS_LIBSTRING_LAST_ERROR`](#bs_libstring_last_error)
  even when error output is suppressed.
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.
- Does NOT affect errors from non-library commands, which
  _may_ still produce output.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_FATAL_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_FATAL_ERRORS`](./README.MD#better_scripts_config_fatal_errors)
- Type:     _FLAG_
- Class:    _VARIABLE_
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
  [`BS_LIBSTRING_CONFIG_QUIET_ERRORS`](#bs_libstring_config_quiet_errors)).
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.

---------------------------------------------------------

#### `BS_LIBSTRING_CONFIG_INDEX_ONE_BASED`

- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  _OFF_
- Enable/\[Disable] one-based indexing.
- _OFF_: use `0` (`<zero>`) based string indexes (i.e.
  in the range `[0, size)`).
- _ON_:  use `1` (`<one>`) based string indexes (i.e.
  in the range `[1, size]`).
- Only affects commands that use indexes, i.e.
  [`string_index`](#string_index),
  [`string_substr`](#string_substr),
  and [`string_truncate`](#string_truncate)

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## COMMANDS

---------------------------------------------------------

### `string_length`

Get the length of text.

_SYNOPSIS_
<!-- - -->

    string_length [<OUTPUT>] <STRING>

_ARGUMENTS_
<!-- -- -->

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be measured.

_EXAMPLES_
<!-- - -->

    string_length Length "a string"
    Length=$(string_length "a string")

_CAVEATS_
<!-- - -->

- Requires the current locale is set appropriately for `STRING`.
- If the current locale is the _POSIX_ locale the result is always a count of
  **bytes** - setting the appropriate locale causes the result to be in
  **characters**.

_NOTES_
<!-- -->

- Although the shell provides `${#PARAMETER}` to determine the length of
  a value stored in a parameter, outside the _POSIX_ locale this often does
  not work as expected, instead returning the number of **bytes** rather than
  the number of **characters** - this command avoids this issue.

---------------------------------------------------------

### `string_quote`

Quote text such that it can safely passed to, for example, `eval`.

Similar to `%Q` format specifier available for some implementations of
`printf`.

_SYNOPSIS_
<!-- - -->

    string_quote [<OUTPUT>] <STRING>

_ARGUMENTS_
<!-- -- -->

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be quoted.

_EXAMPLES_
<!-- - -->

    string_quote Quoted "a 'string'"
    Quoted=$(string_quote "a 'string'")

_NOTES_
<!-- -->

- Correct quoting is both essential in shell scripting, and also tricky to
  do correctly (it is easy to miss some edge case). In most cases it is
  enough to quote parameters as the shell expands them (i.e. "${parameter}"),
  but when using parameters in a situation where a parameter will be
  evaluated multiple times it becomes necessary to quote more carefully. Most
  obviously this may occur when using `eval`, or when writing values via a
  pipe. In cases where a value needs quoted, this command not ensures
  safe quoting.
- The command is optimized for the common case, which should as fast as (or
  even faster) than `printf '%Q'` (where available).

---------------------------------------------------------

### `string_join`

Join multiple strings into a single string, using a single ` ` (`<space>`)
as a separator.

_SYNOPSIS_
<!-- - -->

    string_join [<OUTPUT>] [--] <STRING>...

_ARGUMENTS_
<!-- -- -->

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be joined.
- May be specified multiple times.

_EXAMPLES_
<!-- - -->

    string_join Joined "a string" " in " "bits"
    Joined=$(string_join "a string" " in " "bits")

_NOTES_
<!-- -->

- This is equivalent to `$*` **if, and only if** the first character of `IFS`
  is ` ` (`<space>`).
- `$*` uses the first character of `IFS` to join arguments - this allows the
  use of different characters to join a string, but when using `$*` it means
  care is needed to check or set `IFS` or errors may occur. Unfortunately,
  the value of `IFS` affects how a great many things happen in the shell and
  setting it prior to use of `$*` means care needs taken to reset it after
  it's been used - if an error or signal occurs before the value is reset
  later code may behave unexpectedly. This can be worked around in a number
  of ways, but these often have unobvious edge cases which can trip up the
  unwary, while alternative solutions that are robust can have performance
  implications (e.g. using subshell(s)). This command joins the arguments
  using ` ` (`<space>`) as efficiently as possible, while avoiding common
  pitfalls, and  not altering `IFS`.
- If `OUTPUT` is omitted, `--` is _required_. The same effect can be
  achieved by specifying `OUTPUT` as `-` (`<hyphen>`).

---------------------------------------------------------

### `string_toupper`

Convert a string to upper case.

_SYNOPSIS_
<!-- - -->

    string_toupper [<OUTPUT>] <STRING>

_ARGUMENTS_
<!-- -- -->

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be converted to upper case.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    string_toupper Upper "all lower case"
    Upper=$(string_toupper "all lower case")

_CAVEATS_
<!--  -->

- Requires the current locale is set appropriately for `STRING`.
- If the locale is set to the _POSIX_ locale, conversion is byte-wise and
  may not handle multi-byte characters correctly.

_NOTES_
<!-- -->

- Uses the fastest available method for case conversion, preferring `tr`
  with character classes if supported, otherwise falling back to `awk`.
- Note that some common versions of `tr` do **not** support multi-byte
  characters regardless of locale.

---------------------------------------------------------

### `string_tolower`

Convert a string to lower case.

_SYNOPSIS_
<!-- - -->

    string_tolower [<OUTPUT>] <STRING>

_ARGUMENTS_
<!-- -- -->

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be converted to lower case.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    string_tolower Upper "ALL UPPER CASE"
    Upper=$(string_tolower "ALL UPPER CASE")

_CAVEATS_
<!--  -->

- Requires the current locale is set appropriately for `STRING`.
- If the locale is set to the _POSIX_ locale, conversion is byte-wise and
  may not handle multi-byte characters correctly.

_NOTES_
<!-- -->

- Uses the fastest available method for case conversion, preferring `tr`
  with character classes if supported, otherwise falling back to `awk`.
- Note that some common versions of `tr` do **not** support multi-byte
  characters regardless of locale.

---------------------------------------------------------

### `string_trim`

Trim whitespace from a string.

_SYNOPSIS_
<!-- - -->

    string_trim [-l|--left] [-r|--right] [--] [<OUTPUT>] <STRING>

    string_trim [-a|--all] [--] [<OUTPUT>] <STRING>

_ARGUMENTS_
<!-- -- -->

`-l`, `--left` \[in]

- Trim the _left_ (i.e. start) of `STRING`.

`-r`, `--right` \[in]

- Trim the _right_ (i.e. end) of `STRING`.

`-a`, `--all` \[in]

- Trim both ends of `STRING`.
- This is the default.

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be trimmed.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    string_trim --all Trimmed "   a string   "
    Trimmed=$(string_trim -l "   a string   ")

_NOTES_
<!-- -->

- The characters removed are those belonging to the `:space:` character class
  which contains characters appropriate to the current locale.
- The use of the _POSIX_ locale should be safe all cases, but will not remove
  multi-byte white space characters (e.g. non-breaking space).

---------------------------------------------------------

### `string_index`

Find the location of one string within another. On success the values
`BS_LIBSTRING_MATCH_START` and `BS_LIBSTRING_MATCH_LENGTH` contain the
location of the sub-string.

_SYNOPSIS_
<!-- - -->

    string_index [-E|--ere|--extended-regexp] [--] [<OUTPUT>] <STRING> <EXPRESSION>

    string_index -F|--text|--fixed-strings [--] [<OUTPUT>] <STRING> <EXPRESSION>

    string_index -G|--bre|--basic-regexp [--] [<OUTPUT>] <STRING> <EXPRESSION>

    string_index -W|--glob|--wildcard [--] [<OUTPUT>] <STRING> <EXPRESSION>

_ARGUMENTS_
<!-- -- -->

`-E`, `--ere`, `--extended-regexp` \[in]

- Interpret `EXPRESSION` as an
  ["Extended Regular Expression"][posix_ere].
- This is the default.

`-F`, `--text`, `--fixed-strings` \[in]

- Interpret `EXPRESSION` as a fixed string.

`-G`, `--bre`, `--basic-regexp` \[in]

- Interpret `EXPRESSION` as a
  ["Basic Regular Expression"][posix_bre].

`-W`, `--glob`, `--wildcard` \[in]

- Interpret `EXPRESSION` as
  ["Pattern Matching Notation"][posix_glob].

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- On success, any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be searched.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

`EXPRESSION` \[in]

- Text to search for.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    string_index 'Index' "the quick brown fox" ':'
    Index=$(string_index -E "the quick brown fox" '[fs]ox')
    Index=$(string_index -W "the quick brown fox" '?rown')

_CAVEATS_
<!--  -->

- `BS_LIBSTRING_MATCH_START` and `BS_LIBSTRING_MATCH_LENGTH` are valid
  **only** immediately following this command.
- Requires the current locale is set appropriately for `STRING`.
- If the locale is set to the _POSIX_ locale, the results are in **bytes**,
  not characters.
- Not all wildcard patterns, _BRE_, or _ERE_ can be used portably.
- For _wildcard patterns_ the locale in effect is that of the shell as
  invoked - _it is **not** possible to change the locale of a running shell_.
- In some cases wildcard pattern matches will be implemented using fallback
  code - this is unavoidable as not all implementations provide the expected
  behavior for all expressions. See
  ["PATTERN MATCHING"](./README.MD#pattern-matching),
  [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_MBC`](#bs_libstring_config_shell_supports_mbc),
  and [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libstring_config_shell_supports_portable_glob).
- **Single character _ERE_ will be interpreted as fixed strings.** (This is
  due to limitations in `awk`.)

_NOTES_
<!-- -->

- Exit code will be `0` (`<zero>`) if the string was located, `1` (`<one>`)
  if it was _not_ located, and an error code otherwise.
- Resulting index is one-based if
  [`BS_LIBSTRING_CONFIG_INDEX_ONE_BASED`](#bs_libstring_config_index_one_based)
  is set, or zero-based otherwise.
- Following this command, `BS_LIBSTRING_MATCH_START` and
  `BS_LIBSTRING_MATCH_LENGTH` can be passed to
  [`string_substr`](#string_substr) to extract the located sub-string.

---------------------------------------------------------

### `string_match`

Find the location of one string within another. Equivalent to
[`string_index`](#string_index) with output of the index suppressed.

As with [`string_index`](#string_index) on a successful match
`BS_LIBSTRING_MATCH_START` and `BS_LIBSTRING_MATCH_LENGTH` are set.

_SYNOPSIS_
<!-- - -->

    string_match [-E|--ere|--extended-regexp] [--] <STRING> <EXPRESSION>

    string_match -F|--text|--fixed-strings [--] <STRING> <EXPRESSION>

    string_match -G|--bre|--basic-regexp [--] <STRING> <EXPRESSION>

    string_match -W|--glob|--wildcard [--] <STRING> <EXPRESSION>

_ARGUMENTS_
<!-- -- -->

`-E`, `--ere`, `--extended-regexp` \[in]

- Interpret `EXPRESSION` as an
  ["Extended Regular Expression"][posix_ere].
- This is the default.

`-F`, `--text`, `--fixed-strings` \[in]

- Interpret `EXPRESSION` as a fixed string.

`-G`, `--bre`, `--basic-regexp` \[in]

- Interpret `EXPRESSION` as a
  ["Basic Regular Expression"][posix_bre].

`-W`, `--glob`, `--wildcard` \[in]

- Interpret `EXPRESSION` as
  ["Pattern Matching Notation"][posix_glob].

`STRING` \[in]

- Text to be searched.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

`EXPRESSION` \[in]

- Text to search for.
- _EXPECTS_:
  - an _ERE_ with `-E`, `--ere`, or`--extended-regexp`.
  - a _string_ with `-F`, `--text`, `--fixed-strings`.
  - a _BRE_ with `-G`, `--bre`, or `--basic-regexp`.
  - a _wildcard pattern_ with `-W`, `--glob`, or
    `--wildcard`.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    if string_match "the quick brown fox" ':'; then ...
    if string_match -E "the quick brown fox" '[fs]ox'; then ...
    if string_match -W "the quick brown fox" '?rown'; then ...

_CAVEATS_
<!--  -->

- As for [`string_index`](#string_index).

_NOTES_
<!-- -->

- As for [`string_index`](#string_index).

---------------------------------------------------------

### `string_substr`

Get a substring from a string, index, and length.

_SYNOPSIS_
<!-- - -->

    string_substr <OUTPUT> <STRING> <OFFSET> [<LENGTH>]

_ARGUMENTS_
<!-- -- -->

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to extract a substring from.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

`OFFSET` \[in]

- Position at which the substring starts.

`LENGTH` \[in]

- Length of the substring in characters.

_CAVEATS_
<!--  -->

- Requires the current locale is set appropriately for `STRING`.
- If the locale is set to the _POSIX_ locale, `OFFSET` and `LENGTH` are in
  **bytes**, _not_ characters.
- If `LENGTH` is omitted, the sub-string will contain all characters from
  `STRING`, starting at `OFFSET`.

_NOTES_
<!-- -->

- `OFFSET` is one-based if
  [`BS_LIBSTRING_CONFIG_INDEX_ONE_BASED`](#bs_libstring_config_index_one_based)
  is set, or zero-based otherwise.
- If `LENGTH` is omitted, this command provides a complimentary command to
  [`string_truncate`](#string_truncate) - both behave similarly but on
  different ends of the input string.

---------------------------------------------------------

### `string_truncate`

Truncate a given string to a specific length.

Equivalent to [`string_substr`](#string_substr) with no offset.

_SYNOPSIS_
<!-- - -->

    string_truncate [<OUTPUT>] <STRING> <LENGTH>

_ARGUMENTS_
<!-- -- -->

`OUTPUT` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to be truncated.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

`LENGTH` \[in]

- Length of the truncated string.

_CAVEATS_
<!--  -->

- Requires the current locale is set appropriately for `STRING`.
- If the locale is set to the _POSIX_ locale, `LENGTH` is a count of
  **bytes**, otherwise it is a count of **characters**.

_NOTES_
<!-- -->

- If `STRING` is shorter than `LENGTH` no changes will be made.

---------------------------------------------------------

### `string_sub`

Replace the _first_ occurrence of an expression with a given value. (Similar
to the `awk` function `sub`.)

See [`string_gsub`](#string_gsub) for replacing _all_ occurrences.

_SYNOPSIS_
<!-- - -->

    string_sub [-E|--ere|--extended-regexp] [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

    string_sub -F|--text|--fixed-strings [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

    string_sub -G|--bre|--basic-regexp [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

    string_sub -W|--glob|--wildcard [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

_ARGUMENTS_
<!-- -- -->

`-E`, `--ere`, `--extended-regexp` \[in]

- Interpret `EXPRESSION` as an
  ["Extended Regular Expression"][posix_ere].
- This is the default.

`-F`, `--text`, `--fixed-strings` \[in]

- Interpret `EXPRESSION` as a fixed string.

`-G`, `--bre`, `--basic-regexp` \[in]

- Interpret `EXPRESSION` as a
  ["Basic Regular Expression"][posix_bre].

`-W`, `--glob`, `--wildcard` \[in]

- Interpret `EXPRESSION` as
  ["Pattern Matching Notation"][posix_glob].

`OUTPUT` \[out:ref]

- Variable that will contain the new string.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  output is written to `STDOUT`.

`STRING` \[in]

- Text to search.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

`EXPRESSION` \[in]

- Text to search for.
- _EXPECTS_:
  - an _ERE_ with `-E`, `--ere`, or`--extended-regexp`.
  - a _string_ with `-F`, `--text`, `--fixed-strings`.
  - a _BRE_ with `-G`, `--bre`, or `--basic-regexp`.
  - a _wildcard pattern_ with `-W`, `--glob`, or
    `--wildcard`.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

`REPLACEMENT` \[in]

- Text to be inserted.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    NewString=$(string_sub -F "the quick brown fox" 'fox' 'dog')
    NewString=$(string_sub -E "the quick brown fox" '[fs]ox' 'dog')
    NewString=$(string_sub -W "the quick brown fox" '?rown' 'red')
    string_sub -W -- NewString "the quick brown fox" '?rown' 'red'

_CAVEATS_
<!--  -->

- Requires the current locale is set appropriately for `STRING`.
- For _wildcard patterns_ the locale in effect is that of the shell as
  invoked - _it is **not** possible to change the locale of a running shell_.
- Not all wildcard patterns, _BRE_, or _ERE_ can be used portably.
- In some cases wildcard pattern matches will be implemented using fallback
  code - this is unavoidable as not all implementations provide the expected
  behavior for all expressions. See
  ["PATTERN MATCHING"](./README.MD#pattern-matching),
  [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_MBC`](#bs_libstring_config_shell_supports_mbc),
  and [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libstring_config_shell_supports_portable_glob).
- **Single character _ERE_ will be interpreted as fixed strings.** (This is
  due to limitations in `awk`.)

_NOTES_
<!-- -->

- The `-F`/`--fixed-strings` mode can safely be used in the _POSIX_ locale
  with multi-byte characters.

---------------------------------------------------------

### `string_gsub`

Identical to [`string_sub`](#string_sub) except _all_ occurrences of the
expression are replaced. (Similar to the `awk` function `gsub`.)

See [`string_sub`](#string_sub) for more information.

_SYNOPSIS_
<!-- - -->

    string_gsub [-E|--ere|--extended-regexp] [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

    string_gsub -F|--text|--fixed-strings [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

    string_gsub -G|--bre|--basic-regexp [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

    string_gsub -W|--glob|--wildcard [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>

_ARGUMENTS_
<!-- -- -->

As for [`string_sub`](#string_sub).

_EXAMPLES_
<!-- - -->

    NewString=$(string_gsub -F "the quick brown fox" 'fox' 'dog')
    NewString=$(string_gsub -E "the quick brown fox" '[fs]ox' 'dog')
    NewString=$(string_gsub -W "the quick brown fox" '?rown' 'red')
    string_gsub -W -- NewString "the quick brown fox" '?rown' 'red'

_CAVEATS_
<!-- - -->

- As for [`string_sub`](#string_sub).

_NOTES_
<!-- -->

- As for [`string_sub`](#string_sub).

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## STANDARDS

- [_POSIX.1-2008_][posix].
- [FreeBSD SYSEXITS(3)][sysexits].
- [Semantic Versioning v2.0.0][semver].
- [Inclusive Naming Initiative][inclusivenaming].

_For more details see the `shtoolkit` general [documentation](./README.MD#standards)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## NOTES

- The names and design of the command interfaces in this library is heavily
  based on that of `awk`.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## CAVEATS

- This library is design to support any locale that the underlying tools
  support. It is not, however, possible to robustly, portably test for
  that support - the library does "best effort" testing to choose appropriate
  tools to provide functionality, but this should not be relied upon. **In
  particular, the library does NOT have any way to determine if a locale is
  entirely unsupported.**[^openbsd_locale]
- Some commands have fallback implementations which are needed for certain
  argument/environment combinations. While these provide the functionality
  required they may have very different performance characteristics to the
  normal version. In some cases better performance will be possible by using
  alternative options, for example, pattern matching using _ERE_ **may**
  prove to have more consistent performance across platforms then, say,
  wildcards (which use fallback implementations in some cases).
- For **ALL** string commands, the locale of any string arguments MUST match
  the current locale _OR_ the current locale MUST be the _POSIX_ locale. Any
  other combination of locales is likely to lead to errors.[^string_locale]
- There exist locales which may be largely compatible with other locales
  (especially those that are Unicode locales) - however this compatibility is
  _NOT_ universal and differences will exist.[^non_compatible_locale]
- _It is **not** possible to alter the locale of the currently active shell._
  (The locale the shell was invoked with remains in effect for the duration
   of the shell process - locale variables affect **external** commands
   only.)
- The library attempts to account for differences between implementations
  (where known), however, it is not possible to do this for every case.

[^openbsd_locale]: For example, the default tools available in OpenBSD make
                   it impossible to support multi-byte characters properly,
                   but also impossible to determine that this is an issue.

[^string_locale]: While variables/parameters have no explicit locale the
                  value of the bytes they store will have been written in
                  a specific locale (with the expectation that these bytes
                  are interpreted according to that locale) - this is the
                  locale of the data. Processing this data is only possible
                  in the same locale, or the _POSIX_ locale.

[^non_compatible_locale]: The easiest example of this is the various English
                          UTF-8 locales. While they will match, for example,
                          character code-points, sort order, etc. they will
                          also differ in monetary symbol, date format, etc.
                          (which are _also_ governed by the locale). In most
                          cases these differences will not be an issue for
                          users of this library, but there exist potential
                          edge cases where they may be problematic.

_For more details see the `shtoolkit` general [documentation](./README.MD#caveats)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- REFERENCES -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

[markdown]:                  <https://daringfireball.net/projects/markdown/syntax>                                                "Markdown: Syntax [daringfireball.net]"
[commonmark]:                <https://commonmark.org/>                                                                            "CommonMark [spec.commonmark.org]"
[commonmark_spec]:           <https://spec.commonmark.org/current/>                                                               "CommonMark Spec (current) [spec.commonmark.org]"

[posix]:                     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                       "POSIX.1-2008 \[pubs.opengroup.org\]"
[posix_2013]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2013edition>                                       "POSIX.1-2013 \[pubs.opengroup.org\]"
[posix_2016]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2016edition>                                       "POSIX.1-2016 \[pubs.opengroup.org\]"
[posix_2018]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2018edition>                                       "POSIX.1-2018 \[pubs.opengroup.org\]"
[posix_2024]:                <https://pubs.opengroup.org/onlinepubs/9799919799.2024edition>                                       "POSIX.1-2024 \[pubs.opengroup.org\]"

[posix_bre]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>     "Basic Regular Expression \[pubs.opengroup.org\]"
[posix_ere]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>     "Extended Regular Expression \[pubs.opengroup.org\]"
[posix_re_bracket_exp]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03_05>  "RE Bracket Expression \[pubs.opengroup.org\]"
[posix_param_expansion]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02> "Parameter Expansion \[pubs.opengroup.org\]"
[posix_getopts]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html>                "getopts \[pubs.opengroup.org\]"
[posix_utility_conventions]: <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap12.html>               "POSIX: Utility Conventions \[pubs.opengroup.org\]"
[posix_variable]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_230>    "Definitions: Name \[pubs.opengroup.org\]"
[posix_execl]:               <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/functions/execl.html>                  "execl \[pubs.opengroup.org\]"
[posix_chars]:               <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap06.html#tag_06_01>     "Portable Character Set \[pubs.opengroup.org\]"
[posix_glob]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_13>    "Pattern Matching Notation \[pubs.opengroup.org\]"

[sysexits]:                  <https://www.freebsd.org/cgi/man.cgi?sysexits(3)>                                                    "FreeBSD SYSEXITS(3) \[freebsd.org\]"

[semver]:                    <https://semver.org/>                                                                                "Semantic Versioning \[semver.org\]"

[util_linux]:                <https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/about/>                              "util-linux (about) \[git.kernel.org\]"

[pandoc]:                    <https://pandoc.org/>                                                                                "Pandoc \[pandoc.org\]"

[man_page]:                  <https://wikipedia.org/wiki/Man_page>                                                                "man page \[wikipedia.org\]"

[autoconf_portable]:         <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>                  "autoconf: Portable Shell Programming \[gnu.org\]"
[autoconf_awk]:              <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#awk>  "autoconf: Limitations of Usual Tools \[gnu.org\]"
[autoconf_sed]:              <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#sed>  "autoconf: Limitations of Usual Tools \[gnu.org\]"
[autoconf_grep]:             <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#grep> "autoconf: Limitations of Usual Tools \[gnu.org\]"

[inclusivenaming]:           <https://inclusivenaming.org/>                                                                       "Inclusive Naming Initiative \[inclusivenaming.org\]"

