<!-- #################################################################### -->
<!-- ############# THIS FILE WAS GENERATED FROM 'libmap.sh' ############# -->
<!-- #################################################################### -->
<!-- ########################### DO NOT EDIT! ########################### -->
<!-- #################################################################### -->

# `libmap.sh`

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## SYNOPSIS

_Full synopsis, description, arguments, examples and other information is_
_documented with each individual command._

[`map_new <MAP> --key|-k <KEY> --value|-v <VALUE>...`](#map_new)

[`map_add <MAP> --key|-k <KEY> --value|-v <VALUE>...`](#map_add)

[`map_set <MAP> --key|-k <KEY> --value|-v <VALUE>...`](#map_set)

[`map_get <MAP> <KEY> [<OUTPUT>]`](#map_get)

[`map_contains <MAP> <KEY>`](#map_contains)

[`map_delete <MAP> <KEY>...`](#map_delete)

[`map_size <MAP> [<OUTPUT>]`](#map_size)

[`map_foreach <MAP> <COMMAND> [<ARGUMENT>...]`](#map_foreach)

[`map_keys <MAP> [<OUTPUT>]`](#map_keys)

[`map_values <MAP> [<OUTPUT>]`](#map_values)

[`map_is_map <MAP>`](#map_is_map)

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

Provides commands to allow any _POSIX.1_ compliant shell to use emulated
associative arrays (aka a _map_, _hash_, _dictionary_, or _symbol table_).

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

#### `BS_LIBMAP_CONFIG_NO_Z_SHELL_SETOPT`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`](./README.MD#better_scripts_config_no_z_shell_setopt)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic>
- \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
  _POSIX.1_ like behavior.
- Automatically enabled if _Z Shell_ is detected.
- Any use of `setopt` is scoped as tightly as possible
  and SHOULD not affect other commands.

<!-- ------------------------------------------------ -->

### INFORMATIONAL

Variables that convey library information.

---------------------------------------------------------

#### `BS_LIBMAP_VERSION_MAJOR`

- Integer >= 1.
- Incremented when there are significant changes, or
  any changes break compatibility with previous
  versions.

---------------------------------------------------------

#### `BS_LIBMAP_VERSION_MINOR`

- Integer >= 0.
- Incremented for significant changes that do not
  break compatibility with previous versions.
- Reset to 0 when
  [`BS_LIBMAP_VERSION_MAJOR`](#bs_libmap_version_major)
  changes.

---------------------------------------------------------

#### `BS_LIBMAP_VERSION_PATCH`

- Integer >= 0.
- Incremented for minor revisions or bugfixes.
- Reset to 0 when
  [`BS_LIBMAP_VERSION_MINOR`](#bs_libmap_version_minor)
  changes.

---------------------------------------------------------

#### `BS_LIBMAP_VERSION_RELEASE`

- A string indicating a pre-release version, always
  null for full-release versions.
- Possible values include 'alpha', 'beta', 'rc',
  etc, (a numerical suffix may also be appended).

---------------------------------------------------------

#### `BS_LIBMAP_VERSION_FULL`

- Full version combining
  [`BS_LIBMAP_VERSION_MAJOR`](#bs_libmap_version_major),
  [`BS_LIBMAP_VERSION_MINOR`](#bs_libmap_version_minor),
  and [`BS_LIBMAP_VERSION_PATCH`](#bs_libmap_version_patch)
  as a single integer.
- Can be used in numerical comparisons
- Format: `MNNNPPP` where, `M` is the `MAJOR` version,
  `NNN` is the `MINOR` version (3 digit, zero padded),
  and `PPP` is the `PATCH` version (3 digit, zero padded).

---------------------------------------------------------

#### `BS_LIBMAP_VERSION`

- Full version combining
  [`BS_LIBMAP_VERSION_MAJOR`](#bs_libmap_version_major),
  [`BS_LIBMAP_VERSION_MINOR`](#bs_libmap_version_minor),
  [`BS_LIBMAP_VERSION_PATCH`](#bs_libmap_version_patch),
  and
  [`BS_LIBMAP_VERSION_RELEASE`](#bs_libmap_version_release)
  as a formatted string.
- Format: `BetterScripts 'libmap' vMAJOR.MINOR.PATCH[-RELEASE]`
- Derived tools MUST include unique identifying
  information in this value that differentiates them
  from the BetterScripts versions. (This information
  should precede the version number.)

---------------------------------------------------------

#### `BS_LIBMAP_MAP_FORMAT_VERSION`

- Version of the internal data format for a map.
- Integer >= 1.
- Incremented when there are significant changes, or
  any changes break compatibility with previous
  versions.
- Only a map with this version is supported for any
  command.

---------------------------------------------------------

#### `BS_LIBMAP_LAST_ERROR`

- Stores the error message of the most recent error.
- ONLY valid immediately following a command for which
  the exit status is not `0` (`<zero>`).
- Available even when error output is suppressed.

---------------------------------------------------------

#### `BS_LIBMAP_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to
  determine if this file has been sourced.

<!-- ------------------------------------------------ -->

### USER PREFERENCE

---------------------------------------------------------

#### `BS_LIBMAP_CONFIG_QUIET_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
- Type:     _FLAG_
- Class:    _VARIABLE_
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[libmap::<COMMAND>]: ERROR: <MESSAGE>`.
- _ON_: library error messages will be suppressed.
- The most recent error message is always available in
  [`BS_LIBMAP_LAST_ERROR`](#bs_libmap_last_error)
  even when error output is suppressed.
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.
- Does NOT affect errors from non-library commands, which
  _may_ still produce output.

---------------------------------------------------------

#### `BS_LIBMAP_CONFIG_FATAL_ERRORS`

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
  [`BS_LIBMAP_CONFIG_QUIET_ERRORS`](#bs_libmap_config_quiet_errors)).
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## COMMANDS

---------------------------------------------------------

### `map_new`

Create a new map from the given arguments _or_ a map written to `STDOUT`
with values from `STDIN`.

_SYNOPSIS_
<!-- - -->

    ... | map_new

    map_new <MAP> --key|-k <KEY> --value|-v <VALUE>...

    map_new <MAP> <KEY> <VALUE>...

    map_new <MAP> <KEY>=<VALUE>...

_ARGUMENTS_
<!-- -- -->

`MAP` \[out:ref]

- Variable that will contain the new map.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name.
- If specified as `-` (`<hyphen>`) map
  is written to `STDOUT`.

`KEY` \[in]

- Can contain any arbitrary text excluding
  any embedded `\0` (`<NUL>`) characters.
- MUST be followed by a `VALUE`.
- MUST NOT be null.
- Can be specified multiple times.

`VALUE` \[in]

- Can contain any arbitrary text excluding
  any embedded `\0` (`<NUL>`) characters.
- MUST be preceded by a `KEY`.
- Can be null.
- Can be specified multiple times.

_EXAMPLES_
<!-- - -->

    Map=$(my_command | map_new)
    map_new 'Map' 'Key1=Value One' 'Key2=Value Two'

_CAVEATS_
<!-- - -->

- Argument forms can be mixed, but a `KEY` and a `VALUE` MUST be paired.
- The use of `--key|-k` is _required_ if `KEY` contains an `=` (`<equals>`)
  character, otherwise all forms are equivalent.
- When given no arguments, will read map values from `STDIN`; if this is
  erroneously used without `STDIN` directed into the command this will block
  indefinitely.
- Input via `STDIN` requires a single entry per line in the form
  `<KEY>=<VALUE>`.

_NOTES_
<!-- -->

- An `ENTRY` specified as `"'Key1'='Value One'"` will have quotes included in
  the values stored, i.e. `KEY` will be `'Key1'` while `VALUE` will be
  `'Value One'`.
- Although it is possible to store any value in a map, large values (e.g.
  file contents) may cause issues with performance or may be impossible due
  to [limitations](#caveats) of the current environment.
- When used with arguments, is identical to [`map_add`](#map_add), but
  discards any existing values in `MAP`.
- `map_new`, [`map_add`](#map_add), and [`map_set`](#map_set) can all be
  used interchangeably in some circumstances. Where performance is concerned
  `map_new > map_add > map_set`, but the difference is unlikely to be of
  concern for most use cases (and may very well not even be measurable).

---------------------------------------------------------

### `map_add`

Add one or more values to a map. Equivalent to [`map_new`](#map_new)
_except_ any existing map values are retained.

_SYNOPSIS_
<!-- - -->

    map_add <MAP> --key|-k <KEY> --value|-v <VALUE>...

    map_add <MAP> <KEY> <VALUE>...

    map_add <MAP> <KEY>=<VALUE>...

_ARGUMENTS_
<!-- -- -->

As for [`map_new`](#map_new), with the exception that values can NOT be
specified via `STDIN`, _and_ any existing map values are retained.

_EXAMPLES_
<!-- - -->

    Map=$(map_add - 'A key for a map' 'A value associated with the key')
    map_add 'Map' --key="$FilePath" -v "$(cat $FilePath)"

_CAVEATS_
<!-- - -->

- Using this command for entries that already exist will hide the existing
  entries such that they can never be retrieved (or removed!) from the map.
- As for [`map_new`](#map_new).

_NOTES_
<!-- -->

- As for [`map_new`](#map_new).

---------------------------------------------------------

### `map_set`

Update the value associated with an existing map entry, adding it if it does
not exist.

If the entry does not exist, this is equivalent to [`map_add`](#map_add).

_SYNOPSIS_
<!-- - -->

    map_set <MAP> --key|-k <KEY> --value|-v <VALUE>...

    map_set <MAP> <KEY> <VALUE>...

    map_set <MAP> <KEY>=<VALUE>...

_ARGUMENTS_
<!-- -- -->

As for [`map_add`](#map_add), except `MAP` can not be `-` (`<hyphen>`).

_EXAMPLES_
<!-- - -->

    Map=$(map_set - 'A key for a map' 'A value associated with the key')
    map_set 'Map' --key="$FilePath" -v "$(cat $FilePath)"

_CAVEATS_
<!-- - -->

- As for [`map_add`](#map_add).

_NOTES_
<!-- -->

- `MAP` can not be specified as `-` (`<hyphen>`), i.e. input can not be taken
  from `STDIN`, and output can not be sent to `STDOUT`.
- As for [`map_add`](#map_add).

---------------------------------------------------------

### `map_get`

Lookup a map value.

_SYNOPSIS_
<!-- - -->

    map_get <MAP> <KEY> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`MAP` \[in:ref]

- Variable containing a map.
- MUST be a valid _POSIX.1_ name.

`KEY` \[in]

- Can contain any arbitrary text excluding
  any embedded `\0` (`<NUL>`) characters.
- Must NOT be null.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    if map_get 'Map' 'A map key' 'ValueVar'; then ... fi
    ValueVar=$(map_get 'Map' 'A map key')
    ValueVar=$(map_get 'Map' 'A map key' -)

_NOTES_
<!-- -->

- On success the exit code will be `0` (`<zero>`) if the `KEY` exists and
  `1` (`<one>`) if it does not.
- `OUTPUT` is only modified if `KEY` is found.
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).
- If `OUTPUT` is not required, [`map_contains`](#map_contains) is faster for
  checking if a `KEY` exists, though the difference is likely to be
  relatively small.

---------------------------------------------------------

### `map_contains`

Check if a map contains a key.

_SYNOPSIS_
<!-- - -->

    map_contains <MAP> <KEY>

_ARGUMENTS_
<!-- -- -->

`MAP` \[in:ref]

- Variable containing a map.
- MUST be a valid _POSIX.1_ name.

`KEY` \[in]

- Can contain any arbitrary text excluding
  any embedded `\0` (`<NUL>`) characters.
- Must NOT be null.

_EXAMPLES_
<!-- - -->

    if map_contains 'Map' 'A map key'; then ... fi

_NOTES_
<!-- -->

- `map_contains` is faster than [`map_get`](#map_get) when testing if `KEY`
  exists (when the value is not required), but the difference is likely to
  be relatively small.

---------------------------------------------------------

### `map_delete`

Remove a map entry.

_SYNOPSIS_
<!-- - -->

    map_delete <MAP> <KEY>...

_ARGUMENTS_
<!-- -- -->

`MAP` \[out:ref]

- Variable containing a map.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name.

`KEY` \[in]

- Can contain any arbitrary text excluding
  any embedded `\0` (`<NUL>`) characters.
- Must NOT be null.
- Can be specified multiple times.

_EXAMPLES_
<!-- - -->

    map_delete 'Map' 'A map key'

_NOTES_
<!-- -->

- Any `KEY` which is not in `MAP` is skipped. This is not considered an
  error.

---------------------------------------------------------

### `map_size`

Get the number of entries in a map.

_SYNOPSIS_
<!-- - -->

    map_size <MAP> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`MAP` \[in:ref]

- Variable containing a map.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty map or `unset` variable.

`OUTPUT` \[out:ref]

- Variable that will contain the map size.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  size is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    Size=$(map_size 'Map')
    Size=$(map_size 'Map' -)
    map_size 'Map' 'Size'

---------------------------------------------------------

### `map_foreach`

Invoke a given command for each map entry.

_SYNOPSIS_
<!-- - -->

    map_foreach <MAP> <COMMAND> [<ARGUMENTS>...]

_ARGUMENTS_
<!-- -- -->

`MAP` \[in:ref]

- Variable that contains a map.
- MUST be a valid _POSIX.1_ name.

`COMMAND` \[in]

- Command to invoke for each map entry.

`ARGUMENTS` \[in]

- Arguments passed to `COMMAND`.

_EXAMPLES_
<!-- - -->

    map_foreach MAP printf 'Key: %s; Value: %s\n'

_CAVEATS_
<!-- - -->

- `COMMAND` may invoke other map commands, but changes to `MAP` will NOT
  affect `map_foreach` (e.g. an entry added to `MAP` via `COMMAND` will
  NOT be iterated by `map_foreach` - similarly for deleted or edited
  entries).
- If `COMMAND` invokes `map_foreach` it **MUST** be inside a subshell local
  to `COMMAND`.

_NOTES_
<!-- -->

- `COMMAND` is invoked with the the map key and value as the final two
  arguments.
- Iteration is stopped if `COMMAND` results in a non-zero exit code. This
  code will be used as the exit code for `map_foreach`.
- The order entries are iterated in is deterministic _but_ may not match the
  order they were added.

---------------------------------------------------------

### `map_keys`

Get an array of all keys in a map.

_SYNOPSIS_
<!-- - -->

    map_keys <MAP> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`MAP` \[in:ref]

- Variable that contains a map.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the keys.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  the keys are written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    map_keys Map Keys
    eval "set -- $Keys"
    for Key; do print '%s\n' "$Key"; done

_NOTES_
<!-- -->

- The order of values is deterministic but may not match the order they were
  added.
- The resulting array can be manipulated using the `libarray.sh` library
  (also part of the `shtoolkit`).

---------------------------------------------------------

### `map_values`

Get an array of all values in a map.

_SYNOPSIS_
<!-- - -->

    map_values <MAP> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`MAP` \[in:ref]

- Variable containing a map.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the keys.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  the keys are written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    map_values Map Values
    eval "set -- $Values"
    for Val; do print '%s\n' "$Val"; done

_NOTES_
<!-- -->

- The order of values is deterministic but may not match the order they were
  added.
- The resulting array can be manipulated using the `libarray.sh` library
  (also part of the `shtoolkit`).

---------------------------------------------------------

### `map_is_map`

Determine if a variable looks like it contains map like data.

_SYNOPSIS_
<!-- - -->

    map_is_map <MAP>

_ARGUMENTS_
<!-- -- -->

`MAP` \[in:ref]

- Variable that may contain a map.
- MUST be a valid _POSIX.1_ name.

_EXAMPLES_
<!-- - -->

    if map_is_map 'Var'; then ...; fi

_NOTES_
<!-- -->

- An empty or unset `MAP` is _not_ a valid map.
- Exit status will be `0` (`<zero>`) if `MAP` appears to be a valid map,
  while the exit status will be `1` (`<one>`) in all other (non-error) cases.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## STANDARDS

- [_POSIX.1-2008_][posix].
- [FreeBSD SYSEXITS(3)][sysexits].
- [Semantic Versioning v2.0.0][semver].
- [Inclusive Naming Initiative][inclusivenaming].

_For more details see the `shtoolkit` general [documentation](./README.MD#standards)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## NOTES

- Modification of a map outside of the library is not supported.
- Argument validation occurs where possible and (relatively) performant for
  all arguments to all commands.
- Maps can be serialized (e.g. saved to, or loaded from, a file). The
  [`BS_LIBMAP_MAP_FORMAT_VERSION`](#bs_libmap_map_format_version) value
  determines if a library is able to process a given map and _may_ change
  between library versions.

<!-- ------------------------------------------------ -->

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## CAVEATS

- The library attempts to account for differences between implementations
  (where known), however, it is not possible to do this for every case.
- The maximum size of any map is limited by the environment in which it is
  used. Of particular note is that exceeding the command line length limit
  will cause maps to be unusable in many (platform dependent)
  circumstances, though other limitations will also exist. Note that
  exporting a variable containing an map will cause that variable to be
  counted against the command line length limit **TWICE** if the map is
  also used with a command.
- The internal structure of a map is subject to change without notice and
  should not be relied upon.

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

