<!-- #################################################################### -->
<!-- ############ THIS FILE WAS GENERATED FROM 'libarray.sh' ############ -->
<!-- #################################################################### -->
<!-- ########################### DO NOT EDIT! ########################### -->
<!-- #################################################################### -->

# LIBARRAY

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## SYNOPSIS

[`array_value <VALUE>`](#array_value)

[`array_new [--reverse|--reversed|-r] <ARRAY> [<VALUE>...]`](#array_new)

[`array_size <ARRAY> [<OUTPUT>]`](#array_size)

[`array_get <ARRAY> <INDEX> [<OUTPUT>]`](#array_get)

[`array_set <ARRAY> <INDEX> <VALUE>`](#array_set)

[`array_insert <ARRAY> <INDEX> <VALUE>...`](#array_insert)

[`array_remove <ARRAY> [<PRIMARY>] <EXPRESSION>`](#array_remove)

[`array_push <ARRAY> [<VALUE>...]`](#array_push)

[`array_pop <ARRAY> <OUTPUT>`](#array_pop)

[`array_unshift <ARRAY> [<VALUE>...]`](#array_unshift)

[`array_shift <ARRAY> <OUTPUT>`](#array_shift)

[`array_reverse <ARRAY> [<OUTPUT>]`](#array_reverse)

[`array_slice <ARRAY> <RANGE> [<OUTPUT>]`](#array_slice)

[`array_sort <ARRAY> [<OUTPUT>] [--] [<ARGUMENT>...]`](#array_sort)

[`array_search <ARRAY> [<INDEX>] [<PRIMARY>] <EXPRESSION>`](#array_search)

[`array_contains <ARRAY> [<PRIMARY>] <EXPRESSION>`](#array_contains)

[`array_join <ARRAY> <DELIM> [<OUTPUT>]`](#array_join)

[`array_split [<ARRAY>] <TEXT> <SEPARATOR>`](#array_split)

[`array_printf <ARRAY> <FORMAT>`](#array_printf)

[`array_from_path [--all|-a] [<ARRAY>] <DIRECTORY>`](#array_from_path)

[`array_from_find [<ARRAY>] [--] [<ARGUMENT>...]`](#array_from_find)

[`array_from_find_allow_print <ARRAY> [<DESC>] [--] [<ARGUMENT>...]`](#array_from_find_allow_print)

_Full synopsis, description, arguments, examples and other information is_
_documented with each individual command._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

Provides commands to allow any _POSIX.1_ compliant shell to use emulated
arrays with all common array operations supported.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## EXIT STATUS

- For all commands the exit status will be `0` (`<zero>`) if, and only if,
  the command was completed successfully.
- For any command which is intended to perform a test, an exit status of
  `1` (`<one>`) indicates "false", while `0` (`<zero>`) indicates "true".
- An exit status that is NOT `0` (`<zero>`) from an external command will
  be propagated to the caller where relevant (and possible).
- For any usage error (e.g. an unsupported variable name), the `EX_USAGE`
  error code from [FreeBSD `SYSEXITS(3)`][sysexits] is used.
- Configuration SHOULD NOT change the value of any exit status.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## ENVIRONMENT

A number of environment variables affect the library, these are split into
variables that instruct the library to work-around specific platform issues,
and variables that convey user preferences. Variables that enable platform
specific work-arounds will be automatically set if needed, but can also be
set manually to force specific configurations.

In additional to these, there are a number of variables that are set by the
library to convey information outside of command invocation.

If unset, some variables will take an initial value from a _BetterScripts_
_POSIX Suite_ wide variable, these allow the same configuration to be used by
all libraries in the suite.

After the library has been sourced, external commands must not set library
environment variables that are classified as CONSTANT. Variables may use
the `readonly` command to enforce this.

**_If not otherwise specified, an `<unset>` variable is equivalent to the_**
**_default value._**

_For more details see the common suite [documentation](./README.MD#environment)._

<!-- ------------------------------------------------ -->

### PLATFORM CONFIGURATION

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_NO_Z_SHELL_SETOPT`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`](./README.MD#better_scripts_config_no_z_shell_setopt)
- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
  _POSIX.1_ like behavior.
- Automatically enabled if _Z Shell_ is detected.
- Any use of `setopt` is scoped as tightly as possible
  and SHOULD not affect other commands.

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_NO_MULTIDIGIT_PARAMETER`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_MULTIDIGIT_PARAMETER`](./README.MD#better_scripts_config_no_multidigit_parameter)
- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using only single digit shell
  parameters, i.e. `$0` to `$9`.
- _OFF_: Use multi-digit shell parameters.
- _ON_: Use only single-digit shell parameters.
- Multi-digit parameters are faster but may not be
  supported by all implementations.

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_NO_SHIFT_N`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_SHIFT_N`](./README.MD#better_scripts_config_no_shift_n)
- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using only `shift` and not `shift N`
  for multiple parameters.
- _OFF_: Use `shift N`.
- _ON_: Use only `shift`.
- Multi-parameter `shift` is faster but may not be
  supported by all implementations

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_NO_EXPR_BRE_MATCH`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_EXPR_BRE_MATCH`](./README.MD#better_scripts_config_no_expr_bre_match)
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

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_NO_DEV_NULL`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_DEV_NULL`](./README.MD#better_scripts_config_no_dev_null)
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

<!-- ------------------------------------------------ -->

### USER PREFERENCE

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_QUIET_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[libarray::<COMMAND>]: ERROR: <MESSAGE>`.
- _ON_: library error messages will be suppressed.
- The most recent error message is always available in
  [`BS_LIBARRAY_LAST_ERROR`](#bs_libarray_last_error)
  even when error output is suppressed.
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.
- Does NOT affect errors from non-library commands, which
  _may_ still produce output.

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_FATAL_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_FATAL_ERRORS`](./README.MD#better_scripts_config_fatal_errors)
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
  [`BS_LIBARRAY_CONFIG_QUIET_ERRORS`](#bs_libarray_config_quiet_errors)).
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_START_INDEX_ONE`

- Type:     FLAG
- Class:    CONSTANT
- Default:  _OFF_
- Enable/\[Disable] one-based indexing.
- _OFF_: use `0` (`<zero>`)  based array indexes (i.e.
  in the range `[0, size)`).
- _ON_:  use `1` (`<one>`) based array indexes (i.e.
  in the range `[1, size]`).
- Only affects commands that use indexes, i.e.
  [`array_get`](#array_get),
  [`array_set`](#array_set),
  [`array_remove`](#array_remove),
  [`array_insert`](#array_insert),
  and [`array_slice`](#array_slice)
- Negative indexes are **not** affected `-1` is
  **always** the last element in the array.

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`

- Type:     TEXT
- Class:    CONSTANT
- Default:  3
- Used by
  [`array_from_find_allow_print`](#array_from_find_allow_print)
  as the first of two file descriptors to use to redirect
  output.
- MUST be a single digit integer in the range \[3,9]
  (the standard allows for multiple digit file
  descriptors, but only _requires_ (and most
  implementations only support) single digits)
- When the given descriptor is used if it is already
  in use with a previous (non-library) command this
  _will_ cause errors.
- MUST be different to
  [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`](#bs_libarray_config_find_redirect_fd_2)
- An invalid value will cause a fatal error while
  **sourcing**.

---------------------------------------------------------

#### `BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`

- Type:     TEXT
- Class:    CONSTANT
- Default:  4
- Used by
  [`array_from_find_allow_print`](#array_from_find_allow_print)
  as the second of two file descriptors to use to
  redirect output.
- MUST be a single digit integer in the range \[3,9]
  (the standard allows for multiple digit file
  descriptors, but only _requires_ (and most
  implementations only support) single digits)
- When the given descriptor is used if it is already
  in use with a previous (non-library) command this
  _will_ cause errors.
- MUST be different to
  [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`](#bs_libarray_config_find_redirect_fd_1)
- An invalid value will cause a fatal error while
  **sourcing**.

<!-- ------------------------------------------------ -->

### INFORMATIONAL

Variables that convey library information.

---------------------------------------------------------

#### `BS_LIBARRAY_VERSION_MAJOR`

- Integer >= 1.
- Incremented when there are significant changes, or
  any changes break compatibility with previous
  versions.

---------------------------------------------------------

#### `BS_LIBARRAY_VERSION_MINOR`

- Integer >= 0.
- Incremented for significant changes that do not
  break compatibility with previous versions.
- Reset to 0 when
  [`BS_LIBARRAY_VERSION_MAJOR`](#bs_libarray_version_major)
  changes.

---------------------------------------------------------

#### `BS_LIBARRAY_VERSION_PATCH`

- Integer >= 0.
- Incremented for minor revisions or bugfixes.
- Reset to 0 when
  [`BS_LIBARRAY_VERSION_MINOR`](#bs_libarray_version_minor)
  changes.

---------------------------------------------------------

#### `BS_LIBARRAY_VERSION_RELEASE`

- A string indicating a pre-release version, always
  null for full-release versions.
- Possible values include 'alpha', 'beta', 'rc',
  etc, (a numerical suffix may also be appended).

---------------------------------------------------------

#### `BS_LIBARRAY_VERSION_FULL`

- Full version combining
  [`BS_LIBARRAY_VERSION_MAJOR`](#bs_libarray_version_major),
  [`BS_LIBARRAY_VERSION_MINOR`](#bs_libarray_version_minor),
  and [`BS_LIBARRAY_VERSION_PATCH`](#bs_libarray_version_patch)
  as a single integer.
- Can be used in numerical comparisons
- Format: `MNNNPPP` where, `M` is the `MAJOR` version,
  `NNN` is the `MINOR` version (3 digit, zero padded),
  and `PPP` is the `PATCH` version (3 digit, zero padded).

---------------------------------------------------------

#### `BS_LIBARRAY_VERSION`

- Full version combining
  [`BS_LIBARRAY_VERSION_MAJOR`](#bs_libarray_version_major),
  [`BS_LIBARRAY_VERSION_MINOR`](#bs_libarray_version_minor),
  [`BS_LIBARRAY_VERSION_PATCH`](#bs_libarray_version_patch),
  and
  [`BS_LIBARRAY_VERSION_RELEASE`](#bs_libarray_version_release)
  as a formatted string.
- Format: `BetterScripts 'libarray' vMAJOR.MINOR.PATCH[-RELEASE]`
- Derived tools MUST include unique identifying
  information in this value that differentiates them
  from the BetterScripts versions. (This information
  should precede the version number.)

---------------------------------------------------------

#### `BS_LIBARRAY_SH_TO_ARRAY`

- Contains a shell script which can be used with
  `sh -c` (or any compliant shell) to create an
  array from the arguments passed to the shell.
- Primarily designed to be used with `find -exec`
  to output an array:

      find "${PWD}" -exec sh -c \
        "${BS_LIBARRAY_SH_TO_ARRAY}" \
        BS_LIBARRAY_SH_TO_ARRAY -- '{}' '+'
      echo ' ' #< This is required

- The array MUST have whitespace appended once it is
  generated or it will fail to work as expected.
- _POSIX.1_ specifies that the first argument following
  the script is interpreted as the "command name" (and
  is used for `$0` inside the script).
- Used internally by
  [`array_from_find`](#array_from_find) and
  [`array_from_find_allow_print`](#array_from_find_allow_print).

---------------------------------------------------------

#### `BS_LIBARRAY_LAST_ERROR`

- Stores the error message of the most recent error.
- ONLY valid immediately following a command for which
  the exit status is not `0` (`<zero>`).
- Available even when error output is suppressed.

---------------------------------------------------------

#### `BS_LIBARRAY_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to
  determine if this file has been sourced.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## COMMANDS

---------------------------------------------------------

### `array_value`

Create a single array element from a given value.

Primarily for internal use, but may be of use should the normal array
creation commands not be suitable in a given situation.

Should **not** be used for values then passed to other commands for adding
to arrays.

_SYNOPSIS_
<!-- - -->

    array_value <VALUE>

_ARGUMENTS_
<!-- -- -->

`VALUE` \[in]

- Value to convert into an array value.
- Can be null.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- MUST be a single value.

_EXAMPLES_
<!-- - -->

    ArrayValue="$(array_value 'Value')"
    Array="$(
      for ArrayValue in "$@"
      do
        array_value "$ArrayValue"
      done
      echo ' '
    )"

---------------------------------------------------------

### `array_new`

Create a new named array from the given arguments _or_ an array written to
`STDOUT` with values from `STDIN`.

_SYNOPSIS_
<!-- - -->

    ... | array_new

    array_new [--reverse|--reversed|-r] <ARRAY> [<VALUE>...]

_ARGUMENTS_
<!-- -- -->

`--reverse`, `--reversed`, `-r` \[in]

- Create the array in reverse order, first `VALUE`
  will be the last array element, etc.
- Can _not_ be used for arrays created from `STDIN`.

`ARRAY` \[out:ref]

- Variable that will contain the new array.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If specified as `-` (`<hyphen>`) array is written to
  `STDOUT`.
- REQUIRED if _any_ other argument is specified.

`VALUE` \[in]

- Can be specified multiple times.
- Can be null.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- Each value specified will become an array
  element.

If `ARRAY` is specified but _no_ `VALUE`s are
specified an empty array is created.

If no arguments are provided input is from `STDIN`
and array is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    Array="$(grep -e 'ERROR' /var/log/syslog | array_new)"
    Array="$(array_new - "$Value1" ... "$ValueN")"
    array_new 'Array' "$Value1" ... "$ValueN"
    array_new --reverse 'Array' "$@"

    array_new 'Array' "$@"
    ...
    eval "set -- ${Array}"
    for Value in "$@"; do ...; done

_NOTES_
<!-- -->

- When given no arguments, will read array values from `STDIN`; if
  this is erroneously used without `STDIN` directed into the
  command this will block indefinitely.
- An array created from `STDIN` will have one element per line of input;
  if values need to contain embedded `<newline>` characters the array
  must be created with arguments.
- An empty array created when _only_ `ARRAY` is specified will result in
  `ARRAY` being set to null.
- An empty array created when _no_ arguments are specified (i.e. an
  empty array from a pipe/`STDIN`) will **ALWAYS** contain at least
  whitespace, i.e. any variable set to the captured output will **NOT** be
  null even if the array is empty. To test for an empty array in this case
  use [`array_size`](#array_size).
- Creating a reverse array is slower than a normal array, though the
  difference is unlikely to be measurable in most cases.

---------------------------------------------------------

### `array_size`

Get the size of the given array.

_SYNOPSIS_
<!-- - -->

    array_size <ARRAY> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable.

`OUTPUT` \[out:ref]

- Variable that will contain the array size.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  size is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    Size="$(array_size 'Array')"
    Size="$(array_size 'Array' -)"
    array_size 'Array' 'Size'

---------------------------------------------------------

### `array_get`

Look up an array value by index.

_SYNOPSIS_
<!-- - -->

    array_get <ARRAY> <INDEX> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- MUST be an existing array of size > `INDEX`.

`INDEX` \[in]

- Array index.
- MUST be numeric.
- MUST be within array bounds.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    array_get 'Array' 4 'ValueVar'
    ValueVar="$(array_get 'Array' 4)"
    ValueVar="$(array_get 'Array' 4 -)"

_NOTES_
<!-- -->

- Supports zero-based, one-based, or negative indexing
  (see
  [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
- If value is output to `STDOUT` data _may_ be lost if the array value ends
  with a `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be
  removed from the end of output generated by commands).

---------------------------------------------------------

### `array_set`

Set an array value by index.

_SYNOPSIS_
<!-- - -->

    array_set <ARRAY> <INDEX> <VALUE>

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- MUST be an existing array of size > `INDEX`.

`INDEX` \[in]

- Array index.
- MUST be numeric.
- MUST be within array bounds.

`VALUE` \[in]

- Can be null.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- MUST be a single value.

_EXAMPLES_
<!-- - -->

    array_set 'Array' 4 'New Value'

_NOTES_
<!-- -->

- Supports zero-based, one-based, or negative indexing
  (see
  [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).

---------------------------------------------------------

### `array_insert`

Insert one or more values into an existing array.

_SYNOPSIS_
<!-- - -->

    array_insert <ARRAY> <INDEX> <VALUE>...

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable
  (a new array will be created).

`INDEX` \[in]

- Array index of first inserted element.
- MUST be numeric.
- MUST be within array bounds.

`VALUE` \[in]

- Can be specified multiple times.
- Can be null.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    array_insert 'Array' 4 'Inserted Value' 'Another Inserted Value'

_NOTES_
<!-- -->

- Supports zero-based, one-based, or negative indexing
  (see
  [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).

---------------------------------------------------------

### `array_remove`

Remove one or more values from an existing array, by index, range, or
matching an expression.

_SYNOPSIS_
<!-- - -->

    array_remove <ARRAY> <INDEX>

    array_remove <ARRAY> <RANGE>

    array_remove <ARRAY> <PRIMARY> <EXPRESSION>

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- MUST be an existing array of size >= 1.

`INDEX` \[in]

- Array index.
- MUST be numeric.
- MUST be within array bounds.

`RANGE` \[in]

- A range within the array specified as either:
    `[START]:[END]`
  or
    `[START]#[LENGTH]`
  where START and END are array indexes in the
  range \[START, END), and LENGTH is the count
  of elements in the range.
- If LENGTH is negative or START is greater
  than END the range is a reverse range.
- If START is omitted, the range will begin with
  the first element of the array.
- If END or LENGTH are omitted, the range will
  end at the last element of the array.
- All elements MUST be within array bounds.
- MUST contain at least the character `:` (`<colon>`) or
  `#` (`<number-sign>`).
- MUST result in a range of size >= 1.

`PRIMARY` \[in]

- A test operator used with EXPRESSION.
- MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
  `-lt`, `-le`, `-like`, or `-notlike`.
- The primaries `-gt`, `-ge`, `-lt`, and `-le` are
  identical to the `test` primaries of the same
  names, while `=`, `!=`, `-eq`, and `-ne` are
  functionally similar, but do not distinguish
  between numerical and string values.
- The `-like` primary performs a `case` pattern
  match and supports the glob characters as
  supported by `case`, the `-notlike` primary is
  identical, but with inverted meaning.
- `-like` and `-notlike` support the normal `case`
  pattern matching characters, and can consist of
  multiple patterns delimited by the `|` character.

`EXPRESSION` \[in]

- Value to use with `PRIMARY`.
- Can be null.
- _EXPECTS_
  - a _string_ when `PRIMARY` is `=` or `!=`
  - a _number_ when `PRIMARY` is `-eq`, `-ne`,
    `-gt`, `-ge`, `-lt`, or `-le`
  - a `case` pattern when `PRIMARY` is `-like`
    or `-notlike`.
- _ALLOWS_
  - a _number_ when `PRIMARY` is `=` or `!=`
  - a _string_ when `PRIMARY` is `-eq` or `-ne`.
- `case` pattern allows the normal `case` pattern
  matching characters: `*` (`<asterisk>`)
  `?` (`<question-mark>`), and
  `[` (`<left-square-bracket>`) with the same
  meanings as with a standard `case` match;
  also supported is the pattern delimiter `|`
  (`<vertical-line>`) which can be used to separate
  multiple patterns in a single `EXPRESSION`.

_EXAMPLES_
<!-- - -->

    array_remove 'Array' 2
    array_remove 'Array' '4:7'
    array_remove 'Array' -like '*an error*|*a warning*'
    array_remove 'Array' -notlike '*an error*|*a warning*'

---------------------------------------------------------

### `array_push`

Add one or more values to the end of an array.

_SYNOPSIS_
<!-- - -->

    array_push <ARRAY> [<VALUE>...]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable
  (a new array will be created).

`VALUE` \[in]

- Can be specified multiple times.
- Can be null.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    array_push 'Array' 'Pushed Value 1' ... 'Pushed Value N'
    array_push 'Array' "$@"

_NOTES_
<!-- -->

- If no VALUEs are specified, no modification is made to `ARRAY`.
- Performance of [`array_push`](#array_push),
  [`array_unshift`](#array_unshift), and [`array_new`](#array_new)
  are not measurably different given the same input.

---------------------------------------------------------

### `array_pop`

Remove a single value from the back of an array and save it to a variable.

_SYNOPSIS_
<!-- - -->

    array_pop <ARRAY> <OUTPUT>

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- MUST be an existing array of size >= 1.

`OUTPUT` \[out:ref]

- Variable that will contain the popped value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name.

_EXAMPLES_
<!-- - -->

    array_pop 'Array' 'ValueVar'

_NOTES_
<!-- -->

- If popping results in an empty array the array variable will be set to
  null.

---------------------------------------------------------

### `array_unshift`

Add one or more values to the front of an array.

_SYNOPSIS_
<!-- - -->

    array_unshift <ARRAY> [<VALUE>...]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable
  (a new array will be created).

`VALUE` \[in]

- Can be specified multiple times.
- Can be null.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

_EXAMPLES_
<!-- - -->

    array_unshift 'Array' 'Value 1' ... 'Value N'
    array_unshift 'Array' "$@"

_NOTES_
<!-- -->

- If no VALUEs are specified, no modification is made to `ARRAY`.
- Performance of [`array_push`](#array_push),
  [`array_unshift`](#array_unshift), and [`array_new`](#array_new)
  are not measurably different given the same input.

---------------------------------------------------------

### `array_shift`

Remove a single value from the front of an array and save it to a variable.

_SYNOPSIS_
<!-- - -->

    array_shift <ARRAY> <OUTPUT>

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- MUST be an existing array of size >= 1.

`OUTPUT` \[out:ref]

- Variable that will contain the shifted value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name.

_EXAMPLES_
<!-- - -->

    array_shift 'Array' 'ValueVar'

_NOTES_
<!-- -->

- If shifting results in an empty array the array variable will be set to
  null

---------------------------------------------------------

### `array_reverse`

Reverse the elements of an array.

_SYNOPSIS_
<!-- - -->

    array_reverse <ARRAY> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable.

`OUTPUT` \[out:ref]

- Variable that will contain the reversed array.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If specified as `-` (`<hyphen>`) reversed array is
  written to `STDOUT`.
- If not specified the array is reversed in-place
  (i.e. the input array is also the output array).

_EXAMPLES_
<!-- - -->

    array_reverse 'Array'
    array_reverse 'Array' 'ReversedArrayVar'
    ReversedArrayVar="$(array_reverse 'Array' -)"

---------------------------------------------------------

### `array_slice`

Get a slice of an existing array.

_SYNOPSIS_
<!-- - -->

    array_slice <ARRAY> <RANGE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- MUST be an existing array of size >= 1.

`RANGE` \[in]

- A range within the array specified as either:
    `[START]:[END]`
  or
    `[START]#[LENGTH]`
  where START and END are array indexes in the
  range \[START, END), and LENGTH is the count
  of elements in the range.
- If LENGTH is negative or START is greater
  than END the range is a reverse range.
- If START is omitted, the range will begin with
  the first element of the array.
- If END or LENGTH are omitted, the range will
  end at the last element of the array.
- All elements MUST be within array bounds.
- MUST contain at least the character `:` (`<colon>`) or
  `#` (`<number-sign>`).
- MUST result in a range of size >= 1.

`OUTPUT` \[out:ref]

- Variable that will contain the array slice.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  array slice is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    array_slice 'Array' '2:4'  'SlicedArrayVar'
    array_slice 'Array' ':2'   'SlicedArrayVar'
    array_slice 'Array' '2#2'  'SlicedArrayVar'
    array_slice 'Array' '4:2'  'SlicedArrayVar'
    array_slice 'Array' '4#-2' 'SlicedArrayVar'

NOTES:

- Supports zero-based, one-based, or negative indexing
  (see
  [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).

---------------------------------------------------------

### `array_sort`

Sort an array.

_SYNOPSIS_
<!-- - -->

    array_sort <ARRAY> [<OUTPUT>] [--] [<ARGUMENT>...]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in/out:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable.

`OUTPUT` \[out:ref]

- Variable that will contain the sorted array.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If specified as `-` (`<hyphen>`) sorted array is
  written to `STDOUT`.
- If not specified array is sorted "in-place".

`--` \[in]

- Causes all remaining arguments to be interpreted
  as arguments for `sort`.
- REQUIRED if `OUTPUT` is _not_ specified and the
  first argument to `sort` does _not_ being with a
  `<hyphen>`.

`ARGUMENT` \[in]

- Can be specified multiple times.
- All values passed directly to `sort`.

_EXAMPLES_
<!-- - -->

    array_sort 'Array' -r
    array_sort 'Array' -- -r
    array_sort 'Array' 'SortedArrayVar' -r
    SortedArrayVar="$(array_sort 'Array' - -r)"

_NOTES_
<!-- -->

- Because `sort` works on lines, values containing `<newline>` characters
  have to be modified to be a single line. This _will_ affect sort order in
  some cases (i.e. the output may _not_ be strictly lexicographically
  correct with regards to any embedded `<newline>` characters), however the
  sort order of these values _will_ be stable.

---------------------------------------------------------

### `array_search`

Search an array for an element and get the index of that element.

Exit status will be zero _only_ if a match was found, otherwise it will be
non-zero.

_SYNOPSIS_
<!-- - -->

    array_search <ARRAY> [<INDEX>] [<PRIMARY>] <EXPRESSION>

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable.

`INDEX` \[in/out:ref]

- Variable which will contain the index of the
  found element, or will be set to null otherwise.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  index is written to `STDOUT`.
- If the variable specified is _not_ null, the
  value is used as an offset from which the
  search should begin.

`PRIMARY` \[in]

- A test operator used with EXPRESSION.
- MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
  `-lt`, `-le`, `-like`, or `-notlike`.
- The primaries `-gt`, `-ge`, `-lt`, and `-le` are
  identical to the `test` primaries of the same
  names, while `=`, `!=`, `-eq`, and `-ne` are
  functionally similar, but do not distinguish
  between numerical and string values.
- The `-like` primary performs a `case` pattern
  match and supports the glob characters as
  supported by `case`, the `-notlike` primary is
  identical, but with inverted meaning.
- `-like` and `-notlike` support the normal `case`
  pattern matching characters, and can consist of
  multiple patterns delimited by the `|` character.
- If not specified the primary `=` is used.

`EXPRESSION` \[in]

- Value to use with PRIMARY.
- Can be null.
- _EXPECTS_
  - a _string_ when PRIMARY is `=` or `!=`
  - a _number_ when PRIMARY is `-eq`, `-ne`,
    `-gt`, `-ge`, `-lt`, or `-le`
  - a `case` pattern when PRIMARY is `-like`
    or `-notlike`.
- _ALLOWS_
  - a _number_ when PRIMARY is `=` or `!=`
  - a _string_ when PRIMARY is `-eq` or `-ne`.
- `case` pattern allows the normal `case` pattern
  matching characters: `*` (`<asterisk>`)
  `?` (`<question-mark>`), and
  `[` (`<left-square-bracket>`) with the same
  meanings as with a standard `case` match;
  also supported is the pattern delimiter `|`
  (`<vertical-line>`) which can be used to separate
  multiple patterns in a single `EXPRESSION`.

_EXAMPLES_
<!-- - -->

    while array_search 'Array' 'Location' -like '*an error*|*a warning*'
    do
      ...
    done

_NOTES_
<!-- -->

- See [`array_contains`](#array_contains) for an alternative when INDEX is
  not required.

---------------------------------------------------------

### `array_contains`

Identical to [`array_search`](#array_search) except the index is not returned
(allowing this to be much faster when `PRIMARY` is
 `=`, `!=`, `-eq`, or `-ne`).

See [`array_search`](#array_search) for more information.

_SYNOPSIS_
<!-- - -->

    array_contains <ARRAY> [<PRIMARY>] <EXPRESSION>

_ARGUMENTS_
<!-- -- -->

As for [`array_search`](#array_search), with the exception of
`INDEX` (which is not supported).

_EXAMPLES_
<!-- - -->

    if array_contains 'Array' -like '*an error*|*a warning*'
    then
      ...
    fi

---------------------------------------------------------

### `array_join`

Join all array values into a single string.

_SYNOPSIS_
<!-- - -->

    array_join <ARRAY> <DELIM> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array or `unset` variable.

`DELIM` \[in]

- Value used to delimit joined values.
- Can be null.
- Can contain any escape sequences that
  `printf` understands, however `%` (`<percent-sign>`)
  characters will be output literally.

`OUTPUT` \[out:ref]

- Variable that will contain the joined string.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  joined string is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    array_join 'Array' ',' 'JoinedTextVar'
    JoinedTextVar="$(array_join 'Array' ',')"
    JoinedTextVar="$(array_join 'Array' ',' -)"

_NOTES_
<!-- -->

- If joined text is output to `STDOUT` data _may_ be lost if if the _last_
  array value ends with a `\n` (`<newline>`) (_POSIX.1_ rules state that
  newlines should be removed from the end of output generated by commands).

---------------------------------------------------------

### `array_split`

Create an array by splitting text.

_SYNOPSIS_
<!-- - -->

    array_split [<ARRAY>] <TEXT> <SEPARATOR>

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[out:ref]

- Variable that will contain the new array.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  joined string is written to `STDOUT`.

`TEXT` \[in]

- Text to split into array elements.
- Can be null.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.

`SEPARATOR` \[in]

- Expression used to split `TEXT`.
- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- Is interpreted as a _POSIX.1_
  ["Extended Regular Expression"][posix_ere] _unless_
  exactly _one_ character when it is interpreted
  literally.
- Is used with the `awk` command `split`.

_EXAMPLES_
<!-- - -->

    array_split 'Array' "$PATH" ':'
    Array="$(array_split "$PATH" ':')"
    Array="$(array_split - "$PATH" ':')"

_NOTES_
<!-- -->

- The `awk` command `split` is used to split text, so both `TEXT` and
  `SEPARATOR` are subject to the general `awk` requirements and any
  specific `split` requirements. Whether or not "empty" elements are
  created, may also be dependent on how `split` operates.
- If the separator text is intended to be a simple string longer than a
  single character, any regular expression commands MUST be escaped.
  Importantly, this includes `.` (`<period>`)) which will match **any**
  character if not escaped.
- Requires `awk` supports the `ENVIRON` array which was added in 1989, but
  is not part of the traditional `awk` specification and may be omitted in
  some implementations. (This is due to how strings are processed when passed
  to `awk` as arguments: not only do these have to be escaped in ways
  that are hard to do correctly, but they may not contain embedded newline
  characters. The `ENVIRON` array has neither restriction.)

---------------------------------------------------------

### `array_printf`

Print each element of the array with the given format.

_SYNOPSIS_
<!-- - -->

    array_printf <ARRAY> <FORMAT>

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[in:ref]

- Variable containing an array.
- MUST be a valid _POSIX.1_ name.
- MAY reference an empty array or `unset` variable.

`FORMAT` \[in]

- Passed directly to `printf`.
- Applied for each array element in turn.
- SHOULD include a `%` (`<percent-sign>`) format code.

_EXAMPLES_
<!-- - -->

    array_printf 'Array' 'Array Value: "%s"\n'

_NOTES_
<!-- -->

- If `FORMAT` contains no format code, the literal string it contains will
  be output once per element in `ARRAY`.

---------------------------------------------------------

### `array_from_path`

Populate an array with the paths contained in the given path.

_SYNOPSIS_
<!-- - -->

    array_from_path [--all|-a] [<ARRAY>] <PATH>

_ARGUMENTS_
<!-- -- -->

`--all`, `-a` \[in]

- Include "dot files" (aka "hidden files").
- Ignored if `PATH` is _not_ a directory.

`ARRAY` \[out:ref]

- Variable that will contain the new array.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  array is written to `STDOUT`.

`PATH` \[in]

- A valid path for the current platform.
- Path MUST be suitable for appending a glob pattern.
- Partial paths are permitted.
- Interpreted literally (i.e. glob characters will not be
  used as glob characters).

_EXAMPLES_
<!-- - -->

    #< find /usr/local/share, /usr/local/sbin, etc
    array_from_path 'Array' /usr/local/s

    #< find all paths in /usr/bin/
    array_from_path --all 'Array' /usr/bin

_NOTES_
<!-- -->

- It is relatively straightforward to create an array from a shell
  glob expression, however, there are a number of cases that can elicit
  unexpected results and require special care (e.g. paths containing special
  characters, globs for non-existing paths, etc). Additionally, there are
  potential issues with specific platforms that make it harder to write a
  truly portable solution than it seems.

---------------------------------------------------------

### `array_from_find`

Create an array from the results of the `find` command.

In contrast to [`array_from_find_allow_print`](#array_from_find_allow_print),
this command builds the array by capturing `STDOUT`; any output from `find`
that is sent to `STDOUT` _will_ result in broken array (the `-print` primary
is explicitly checked for and triggers an error if detected).

_SYNOPSIS_
<!-- - -->

    array_from_find [<ARRAY>] [--] [<ARGUMENT>...]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[out:ref]

- Variable that will contain the new array.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  array is written to `STDOUT`.

`--` \[in]

- Causes all remaining arguments to be interpreted as
  arguments for `find`.
- REQUIRED if ARRAY is _not_ specified and the
  first argument to `find` does _not_ being with a
  `<hyphen>`.

`ARGUMENT` \[in]

- Can be specified multiple times.
- All values passed directly to `find`.
- Can include any values accepted by `find`, including
  options (e.g. `-H`), paths, and **most** `find`
  primaries.
- MUST **not** include any `find` primaries that
  write to `STDOUT` (e.g. `-print`).
- Expression created by using `find` primaries and
  operators _may_ need grouped into a `find`
  sub-expression (even when this would not normally
  be required).

_EXAMPLES_
<!-- - -->

    array_from_find 'Array' -- -L "$PWD" '(' -type f -o -type d ')'
    Array="$(array_from_find - -L "$PWD" -type f)"

_NOTES_
<!-- -->

- Implemented using [`BS_LIBARRAY_SH_TO_ARRAY`](#bs_libarray_sh_to_array)
- Requires `sh` is an available command that can execute a simple shell
  script with the `-c` option, as specified in the _POSIX.1_ standard.
- The array is built by appending an `-exec` primary to any passed primaries,
  i.e. the array is built as a result of an implicit `-a` where the left hand
  side being is whatever expression was last in the list of primaries passed
  to the command. This can result in unintended output when using the `-o`
  primary, where properly grouping primaries (using `(`
  (`<left-parenthesis>`), and `)` (`<right-parenthesis>`)) is essential.
- Some implementations of `find` allow it to be invoked without any
  arguments, or with arguments but without any paths. This is supported
  by this command if supported by the current platform.
- [`array_from_find_allow_print`](#array_from_find_allow_print) is provided
  if `find` primaries that generate output are required.

---------------------------------------------------------

### `array_from_find_allow_print`

Create an array from the results of the `find` command.

Similar to [`array_from_find`](#array_from_find) but builds the array using
output redirection instead of simply capturing `STDOUT` so any `find` primary
that emits data to `STDOUT` (e.g. `-print`) can be used _in addition_ to
building the array.

_SYNOPSIS_
<!-- - -->

    array_from_find_allow_print <ARRAY> [<FD>] [--] [<ARGUMENT>...]

_ARGUMENTS_
<!-- -- -->

`ARRAY` \[out:ref]

- Variable that will contain the new array.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name.

`FD` \[in]

- A pair of file descriptors in the form `<FD>,<FD>`
  where each `FD` is a _different_ single digit
  from the set `[3456789]`.
- If omitted values are taken from the configuration
  values
  [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`](#bs_libarray_config_find_redirect_fd_1)
  and
  [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`](#bs_libarray_config_find_redirect_fd_2).

`--` \[in]

- Causes all remaining arguments to be interpreted
  as arguments for `find`.
- REQUIRED if `FD` is _not_ specified and the
  first argument to `find` looks like `FD`.

`ARGUMENT` \[in]

- Can be specified multiple times.
- All values passed directly to `find`.
- Can include any values accepted by `find`, including
  options (e.g. `-H`), paths, and `find` primaries.
- Expression created by using `find` primaries and
  operators _may_ need grouped into a `find`
  sub-expression (even when this would not normally
  be required).

_EXAMPLES_
<!-- - -->

    # Find all broken links in the current directory tree
    # and both store in an array AND print to STDOUT
    array_from_find_allow_print 'Array' 5,7 -- -L "$PWD" -type l -print

_NOTES_
<!-- -->

- Implemented using [`BS_LIBARRAY_SH_TO_ARRAY`](#bs_libarray_sh_to_array)
- Requires `sh` is an available command that can execute a simple shell
  script with the `-c` option, as specified in the _POSIX.1_ standard.
- The array is built by appending an `-exec` primary to any passed primaries,
  i.e. the array is built as a result of an implicit `-a` where the left hand
  side being is whatever expression was last in the list of primaries passed
  to the command. This can result in unintended output when using the `-o`
  primary, where properly grouping primaries (using `(`
  (`<left-parenthesis>`), and `)` (`<right-parenthesis>`)) is essential.
- This is likely to be of limited use; capturing the output from the
  `find` primaries would require a subshell meaning that the generated
  array would **only** be available _within_ that subshell.
- To support output from `find` primaries and also generate an array it
  is necessary to redirect output. If the file descriptors used are
  already in use this **will** cause errors.
- The _POSIX.1_ standard _allows_ for multi-digit file descriptors, however
  only _requires_ support for single-digit descriptors and at least some
  common implementations do not support multi-digit file descriptors, so
  they are not permitted for use here.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## STANDARDS

- [_POSIX.1-2008_][posix]
  - also known as:
    - _The Open Group Base Specifications Issue 7_
    - _IEEE Std 1003.1-2008_
    - _The Single UNIX Specification Version 4 (SUSv4)_
  - the more recent
    [_POSIX.1-2017_][posix_2017]
    is functionally identical to _POSIX.1-2008_, but incorporates some errata
- [FreeBSD SYSEXITS(3)][sysexits]
  - while not truly standard, these are used by many projects
- [Semantic Versioning v2.0.0][semver]

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## NOTES

<!-- ------------------------------------------------ -->

### TERMINOLOGY

- An _array_ contains zero or more _elements_.
- Each _element_ is any _value_ that can be stored in a
  standard shell variable, however:
  - the `\0` (`<NUL>`) character is not supported
  - support for any characters not appearing in the
    _POSIX_ locale is entirely dependent on the shell
    and utilities used
- A _value_ may be _null_, which is equivalent to the
  empty string.
  - a _null_ _value_ is different from a `<NUL>` character
- Each _array_ is stored in a single shell variable.
- An _array_ is passed to a command by _reference_, i.e.
  the **name** of the _array_ shell variable is passed
  to commands, **not** the contents:

      array_new  'Fibonacci' 0 1 1 2 3 5 #< New array stored in $Fibonacci
      array_size 'Fibonacci'             #< Outputs 6

- _Array_ _elements_ can be manipulated using the
  commands in this library, or can be accessed using
  shell positional parameters (i.e. `$@`, `$1`, `$2`,
  ...) by _unpacking_ the _array_ using:

      array_new 'Fibonacci' 0 1 1 2 3 5  #< New array stored in $Fibonacci
      eval "set -- $Fibonacci"
      print '%d\n' "$4"                  #< Outputs 2

<!-- ------------------------------------------------ -->

### GENERAL

- General modification of an array outside of the library
  is not supported, however arrays can be concatenated by
  appending the contents of the array variables:

      ArrayCat="${ArrayOne}${ArrayTwo}"

- Argument validation occurs where possible and
  (relatively) performant for all arguments to
  all commands.

<!-- ------------------------------------------------ -->

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- REFERENCES -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

[posix]:                     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                       "POSIX.1-2008 \[pubs.opengroup.org\]"
[posix_2017]:                <https://pubs.opengroup.org/onlinepubs/9699919799>                                                   "POSIX.1-2017 \[pubs.opengroup.org\]"
[posix_bre]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>     "Basic Regular Expression \[pubs.opengroup.org\]"
[posix_ere]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>     "Extended Regular Expression \[pubs.opengroup.org\]"
[posix_re_bracket_exp]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03_05>  "RE Bracket Expression \[pubs.opengroup.org\]"
[posix_param_expansion]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02> "Parameter Expansion \[pubs.opengroup.org\]"
[posix_getopts]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html>                "getopts \[pubs.opengroup.org\]"
[posix_utility_conventions]: <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap12.html>               "POSIX: Utility Conventions \[pubs.opengroup.org\]"
[posix_variable]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_230>    "Definitions: Name \[pubs.opengroup.org\]"

[sysexits]:                  <https://www.freebsd.org/cgi/man.cgi?sysexits(3)>                                                    "FreeBSD SYSEXITS(3) \[freebsd.org\]"
[semver]:                    <https://semver.org/>                                                                                "Semantic Versioning \[semver.org\]"

[util_linux]:                <https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/about/>                              "util-linux (about) \[git.kernel.org\]"

[pandoc]:                    <https://pandoc.org/>                                                                                "Pandoc \[pandoc.org\]"

[man_page]:                  <https://wikipedia.org/wiki/Man_page>                                                                "man page \[wikipedia.org\]"

[autoconf_portable]:         <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>           "autoconf: Portable Shell Programming \[gnu.org\]"

