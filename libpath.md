<!-- #################################################################### -->
<!-- ############# THIS FILE WAS GENERATED FROM 'libpath.sh' ############ -->
<!-- #################################################################### -->
<!-- ########################### DO NOT EDIT! ########################### -->
<!-- #################################################################### -->

# `libpath.sh`

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## SYNOPSIS

_Full synopsis, description, arguments, examples and other information is_
_documented with each individual command._

[`path_basename <VARIABLE> [--] <PATH> [<SUFFIX>]`](#path_basename)

[`path_dirname <VARIABLE> [--] <PATH>`](#path_dirname)

[`path_pwd <VARIABLE> [<OPTIONS>...]`](#path_pwd)

[`path_serial [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>`](#path_serial)

[`path_size [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>`](#path_size)

[`path_owner [-L|--dereference|--follow-links] [-n|--name] [--] [<VARIABLE>] <PATH>`](#path_owner)

[`path_mode [-L|--dereference|--follow-links] [-c|--chmod] [--] [<VARIABLE>] <PATH>`](#path_mode)

[`path_mktemp [<OPTIONS>...] [--] [<TEMPLATE>]`](#path_mktemp)

[`path_mktmp [<OPTIONS>...] [--] [<TEMPLATE>]`](#path_mktmp)

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

Provides commands to allow any _POSIX.1_ compliant shell to process paths
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

#### `BS_LIBPATH_CONFIG_NO_Z_SHELL_SETOPT`

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

#### `BS_LIBPATH_CONFIG_EXTENDED_FILE_MODE_FORMAT`

- Type:     _TEXT_
- Class:    _CONSTANT_
- Default:  `posix`
- Used by [`path_mode`](#path_mode) to determine how to
  convert modes into `chmod` format.
- Some implementations extend the standard with
  additional file modes, this determines if those
  extensions are handled or if they result in an error.
- MUST be either `posix` (default) or `solaris`.
- _`posix`_: use only the standard defined file modes,
  anything else will cause an error for certain
  operations.
- `solaris`: allow the "mandatory file locking" mode
  extension.
- The default is to use `solaris` only when `uname -s` is
  `SunOS`, and `posix` in all other cases.

---------------------------------------------------------

#### `BS_LIBPATH_CONFIG_NO_LS_Q`

- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  \<automatic>
- Indicates if `-q` is an accepted option for `ls`.
- Although `-q` is required by the standard, some
  implementations do not support it (e.g. `busybox`).
- While `-q` is never absolutely necessary, it is helpful
  to use to ensure output does not cause unexpected
  problems. (Generally `ls` output is parsed only for
  information **not** related to the filename output.)

<!-- ------------------------------------------------ -->

### INFORMATIONAL

Variables that convey library information.

---------------------------------------------------------

#### `BS_LIBPATH_VERSION_MAJOR`

- Integer >= 1.
- Incremented when there are significant changes, or
  any changes break compatibility with previous
  versions.

---------------------------------------------------------

#### `BS_LIBPATH_VERSION_MINOR`

- Integer >= 0.
- Incremented for significant changes that do not
  break compatibility with previous versions.
- Reset to 0 when
  [`BS_LIBPATH_VERSION_MAJOR`](#bs_libpath_version_major)
  changes.

---------------------------------------------------------

#### `BS_LIBPATH_VERSION_PATCH`

- Integer >= 0.
- Incremented for minor revisions or bugfixes.
- Reset to 0 when
  [`BS_LIBPATH_VERSION_MINOR`](#bs_libpath_version_minor)
  changes.

---------------------------------------------------------

#### `BS_LIBPATH_VERSION_RELEASE`

- A string indicating a pre-release version, always
  null for full-release versions.
- Possible values include 'alpha', 'beta', 'rc',
  etc, (a numerical suffix may also be appended).

---------------------------------------------------------

#### `BS_LIBPATH_VERSION_FULL`

- Full version combining
  [`BS_LIBPATH_VERSION_MAJOR`](#bs_libpath_version_major),
  [`BS_LIBPATH_VERSION_MINOR`](#bs_libpath_version_minor),
  and [`BS_LIBPATH_VERSION_PATCH`](#bs_libpath_version_patch)
  as a single integer.
- Can be used in numerical comparisons
- Format: `MNNNPPP` where, `M` is the `MAJOR` version,
  `NNN` is the `MINOR` version (3 digit, zero padded),
  and `PPP` is the `PATCH` version (3 digit, zero padded).

---------------------------------------------------------

#### `BS_LIBPATH_VERSION`

- Full version combining
  [`BS_LIBPATH_VERSION_MAJOR`](#bs_libpath_version_major),
  [`BS_LIBPATH_VERSION_MINOR`](#bs_libpath_version_minor),
  [`BS_LIBPATH_VERSION_PATCH`](#bs_libpath_version_patch),
  and
  [`BS_LIBPATH_VERSION_RELEASE`](#bs_libpath_version_release)
  as a formatted string.
- Format: `BetterScripts 'libpath' vMAJOR.MINOR.PATCH[-RELEASE]`
- Derived tools MUST include unique identifying
  information in this value that differentiates them
  from the BetterScripts versions. (This information
  should precede the version number.)

---------------------------------------------------------

#### `BS_LIBPATH_LAST_ERROR`

- Stores the error message of the most recent error.
- ONLY valid immediately following a command for which
  the exit status is not `0` (`<zero>`).
- Available even when error output is suppressed.

---------------------------------------------------------

#### `BS_LIBPATH_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to
  determine if this file has been sourced.

<!-- ------------------------------------------------ -->

### USER PREFERENCE

---------------------------------------------------------

#### `BS_LIBPATH_CONFIG_QUIET_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
- Type:     _FLAG_
- Class:    _VARIABLE_
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[libpath::<COMMAND>]: ERROR: <MESSAGE>`.
- _ON_: library error messages will be suppressed.
- The most recent error message is always available in
  [`BS_LIBPATH_LAST_ERROR`](#bs_libpath_last_error)
  even when error output is suppressed.
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.
- Does NOT affect errors from non-library commands, which
  _may_ still produce output.

---------------------------------------------------------

#### `BS_LIBPATH_CONFIG_FATAL_ERRORS`

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
  [`BS_LIBPATH_CONFIG_QUIET_ERRORS`](#bs_libpath_config_quiet_errors)).
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.

---------------------------------------------------------

#### `BS_LIBPATH_CONFIG_PREFER_HEXDUMP`

- Suite:    [`BETTER_SCRIPTS_CONFIG_PREFER_HEXDUMP`](./README.MD#better_scripts_config_prefer_hexdump)
- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  _OFF_
- Enable/\[Disable] using `hexdump` in preference to `od`.
- _OFF_: use `od` whenever possible.
- _ON_:  use `hexdump` even if `od` is available.
- Only affects [`path_mktemp`](#path_mktemp).
- Has no effect unless both `od` and `hexdump` are
  available.
- Some systems lack `od`, but provide `hexdump` for the
  same purpose, while many provide both. This flag allows
  the use of either `od` or `hexdump` to be preferred.
- The default is to use `od` if available and `hexdump`
  otherwise. If neither command is available different
  (situation dependent) methods for generating data are
  used.
- See also:
  [`BS_LIBPATH_CONFIG_RANDOM_SOURCE`](#bs_libpath_config_random_source),
  and
  [`BS_LIBPATH_CONFIG_NO_MKTEMP`](#bs_libpath_config_no_mktemp).

---------------------------------------------------------

#### `BS_LIBPATH_CONFIG_RANDOM_SOURCE`

- Suite:    [`BETTER_SCRIPTS_CONFIG_RANDOM_SOURCE`](./README.MD#better_scripts_config_random_source)
- Type:     _TEXT_
- Class:    _CONSTANT_
- Default:  `/dev/urandom`
- Specify a source for random data.
- Only affects [`path_mktemp`](#path_mktemp).
- MUST be either the special value `awk` or a path to
  use as a source for random data.
- If specified as a path, the path MUST be readable,
  and MUST behave like `/dev/urandom`.
- If specified as `awk`, random data is generated by
  `awk` - **this is insecure** as the data generated is
  of poor quality and likely to be easy to guess.
- Has no effect if neither `od` nor `hexdump` is
  available.
- WARNING: `/dev/urandom` **can** block in some
  circumstances - when this may occur varies by system.
- See also:
  [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump),
  and
  [`BS_LIBPATH_CONFIG_NO_MKTEMP`](#bs_libpath_config_no_mktemp).

---------------------------------------------------------

#### `BS_LIBPATH_CONFIG_NO_MKTEMP`

- Type:     _FLAG_
- Class:    _CONSTANT_
- Default:  _OFF_
- \[Enable]/Disable allowing the use of `mktemp`.
- _OFF_: allow `mktemp` to be used when possible.
- _ON_:  force `mktemp` to never be used, even if it
  is available.
- Only affects [`path_mktemp`](#path_mktemp).
- Has no effect if `mktemp` is not available.
- Functionality of `mktemp` implementations varies, and
  even when available it may not be possible to use
  `mktemp` in all cases. For example,
  [GNU `mktemp`][gnu_mktemp] provides more
  functionality than implementations such as
  [BSD][freebsd_mktemp] [variants][openbsd_mktemp].
- See also:
  [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump),
  and
  [`BS_LIBPATH_CONFIG_RANDOM_SOURCE`](#bs_libpath_config_random_source).

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## COMMANDS

---------------------------------------------------------

### `path_basename`

Set a variable to the value from `basename` for a specified path, without
potentially losing data if the path ends `<newline>` characters.

_SYNOPSIS_
<!-- - -->

    path_basename <VARIABLE> [--] <PATH> [<SUFFIX>]

_ARGUMENTS_
<!-- -- -->

`VARIABLE` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.

`PATH` \[in]

- Path to process.

`SUFFIX` \[in]

- Suffix to remove.

_EXAMPLES_
<!-- - -->

    path_basename File -- "$0" ".sh"

_NOTES_
<!-- -->

- All arguments except the first are passed directly to `basename` -
  supported arguments and values are determined by the implementation of
  that utility; any non-standard options may be used.

---------------------------------------------------------

### `path_dirname`

Set a variable to the value from `dirname` for a specified path, without
potentially losing data if the path ends `<newline>` characters.

_SYNOPSIS_
<!-- - -->

    path_dirname <VARIABLE> [--] <PATH>

_ARGUMENTS_
<!-- -- -->

`VARIABLE` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.

`PATH` \[in]

- Path to process.

_EXAMPLES_
<!-- - -->

    path_dirname Dir -- "$0"

_NOTES_
<!-- -->

- All arguments except the first are passed directly to `dirname` -
  supported arguments and values are determined by the implementation of
  that utility; any non-standard options may be used.

---------------------------------------------------------

### `path_pwd`

Set a variable to the value from `pwd`, without potentially losing data if
the path ends `<newline>` characters.

_SYNOPSIS_
<!-- - -->

    path_pwd <VARIABLE> [<OPTIONS>...]

_ARGUMENTS_
<!-- -- -->

`VARIABLE` \[out:ref]

- Variable that will contain the output.
- MUST be a valid _POSIX.1_ name.
- Any current contents will be lost.

_EXAMPLES_
<!-- - -->

    path_pwd CurrentDir

_CAVEATS_
<!--  -->

- The output from `pwd` is defined in the standard in terms of the
  environment variable `PWD` (i.e. `pwd` is supposed to return the value
  stored in `PWD`). However, the value contained in `PWD` can be modified
  directly by scripts and so _may_ not actually contain the current path.
  (What occurs when assigning to `PWD` is implementation defined.) If  `PWD`
  is not the current directory, the output of `pwd` is _not_ specified by
  the standard, however, most implementations seem to do something sensible.

_NOTES_
<!-- -->

- Any arguments after the first are passed directly to `pwd` -
  supported arguments and values are determined by the implementation of
  that utility; any non-standard options may be used.
- Standard `pwd` supports `-L` and `-P` options, with no option being
  equivalent to `-L`.

---------------------------------------------------------

### `path_serial`

Get the serial for the given path.

_SYNOPSIS_
<!-- - -->

    path_serial [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>

_ARGUMENTS_
<!-- -- -->

`-L`, `--dereference`, `--follow-links` \[in]

- If `PATH` is a symbolic link, get the information for
  the link target.
- If not specified, the information will be for the
  symbolic link itself.
- If the symbolic link is broken or inaccessible, using
  this option will result in an error.
- Must be specified before any other arguments.

`VARIABLE` \[out:ref]

- Variable that will contain the serial.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  serial is written to `STDOUT`.

`PATH` \[in]

- `PATH` to get a serial for.

_EXAMPLES_
<!-- - -->

    Serial=$(path_serial "$File")
    path_serial 'Serial' "$File"

_CAVEATS_
<!--  -->

- A ["File Serial Number"][posix_file_serial_num] is defined as: _"A per-file
  system unique identifier for a file."_ and can **not** uniquely identify a
  file for an entire system.

_NOTES_
<!-- -->

- The serial will be an unsigned integer, but has an "implementation defined"
  size.
- The value reported here is the only value guaranteed to be available in a
  _POSIX.1_ shell. The commonly available `stat` command is able to provide
  much more useful (and accurate) information, but is not standard, and
  varies in usage between implementations.

---------------------------------------------------------

### `path_size`

Get the size of given file.

_SYNOPSIS_
<!-- - -->

    path_size [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>

_ARGUMENTS_
<!-- -- -->

`-L`, `--dereference`, `--follow-links` \[in]

- If `PATH` is a symbolic link, get the information for
  the link target.
- If not specified, the information will be for the
  symbolic link itself.
- If the symbolic link is broken or inaccessible, using
  this option will result in an error.
- Must be specified before any other arguments.

`VARIABLE` \[out:ref]

- Variable that will contain the size.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  size is written to `STDOUT`.

`PATH` \[in]

- `PATH` to get a size for.

_EXAMPLES_
<!-- - -->

    Size=$(path_size -L "$File")
    path_size 'Size' "$File"

_CAVEATS_
<!--  -->

- If `PATH` is not an ordinary file (e.g. a character special or block
  special file), the results are "implementation defined" and so
  non-portable.
- Size is reported as **the number of 1024 byte blocks consumed by the file**
  i.e. the file size will be rounded up to the nearest 1024 bytes.
- For some file systems or implementations, the number of blocks consumed may
  not match the true file size (e.g. a file system that utilizes compression
  may report a value significantly smaller than the size of the uncompressed
  data).
- Files of size zero bytes _may_ give non-zero output depending on both the
  implementation of `ls` _and_ the underlying file system.

_NOTES_
<!-- -->

- The value reported here is the only value guaranteed to be available in a
  _POSIX.1_ shell. The commonly available `stat` command is able to provide
  much more useful (and accurate) information, but is not standard, and
  varies in usage between implementations.

---------------------------------------------------------

### `path_owner`

Get the owner of a given path in the form `<OWNER>:<GROUP>`.

_SYNOPSIS_
<!-- - -->

    path_owner [-L|--dereference|--follow-links] [-n|--name] [--] [<VARIABLE>] <PATH>

_ARGUMENTS_
<!-- -- -->

`-L`, `--dereference`, `--follow-links` \[in]

- If `PATH` is a symbolic link, get the information for
  the link target.
- If not specified, the information will be for the
  symbolic link itself.
- If the symbolic link is broken or inaccessible, using
  this option will result in an error.
- Must be specified before non-option arguments.

`-n`, `--name` \[in]

- Report the owner and group in name format rather than
  numeric format.
- Must be specified before non-option arguments.

`VARIABLE` \[out:ref]

- Variable that will contain the owner.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  owner is written to `STDOUT`.

`PATH` \[in]

- `PATH` to get the owner for.

_EXAMPLES_
<!-- - -->

    Owner=$(path_owner -Ln "$File")
    path_owner 'Owner' "$File"

_CAVEATS_
<!--  -->

- The owner is reported as `<UID>:<GID>` where both IDs are numeric unless
  the name is explicitly requested, and a name for the given numeric ID can
  be obtained.

---------------------------------------------------------

### `path_mode`

Get the "mode" (i.e. the permissions) of a path (in _symbolic_ format).

_SYNOPSIS_
<!-- - -->

    path_mode [-L|--dereference|--follow-links] [-c|--chmod] [--] [<VARIABLE>] <PATH>

_ARGUMENTS_
<!-- -- -->

`-L`, `--dereference`, `--follow-links` \[in]

- If `PATH` is a symbolic link, get the information for
  the link target.
- If not specified, the information will be for the
  symbolic link itself.
- If the symbolic link is broken or inaccessible, using
  this option will result in an error.
- Must be specified before non-option arguments.

`-c`, `--chmod` \[in]

- Convert the mode to the format:
  `u=<user mode>,g=<group mode>,o=<other mode>[,+t]`
  which is suitable for use with `chmod`.
- The resulting mode will be of variable length, without
  this option the mode is always exactly **9** characters.
- May fail with an error if non-standard mode characters
  are set for `PATH`.
- Must be specified before non-option arguments.

`VARIABLE` \[out:ref]

- Variable that will contain the mode.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- Any current contents will be lost.
- If not specified, or specified as `-` (`<hyphen>`)
  mode is written to `STDOUT`.

`PATH` \[in]

- A path to get the mode for.

_EXAMPLES_
<!-- - -->

    chmod "$(path_mode -Lc "$Reference")" "$Target"
    path_mode 'Mode' "$File"

_CAVEATS_
<!--  -->

- How the mode is converted to `chmod` format is dependent on
  [`BS_LIBPATH_CONFIG_EXTENDED_FILE_MODE_FORMAT`](#bs_libpath_config_extended_file_mode_format),
  which will determine if non-standard mode characters result in errors.

_NOTES_
<!-- -->

- The resulting mode is _always_ in symbolic format as this is the only
  format that can be determined with standard defined tools. Converting this
  to octal format is relatively easy if required.
- Normally the mode output will be exactly **9** characters, while in `chmod`
  format it will be of variable length with a minimum of **8** characters,
  and a maximum of **22** characters when only using standard defined modes.
- Although variable in length, `chmod` format is often easier to test for
  specific mode values, for example, checking for the `x` mode in the
  default output requires checking for either `x` _or_ `s` for "user" and
  "group", and `x` _or_ `t` for "other", while in `chmod` format the test is
  just for `x` in any of the three groups.
- The value reported here is the only value guaranteed to be available in a
  _POSIX.1_ shell. The commonly available `stat` command is able to provide
  much more useful (and accurate) information, but is not standard, and
  varies in usage between implementations.

---------------------------------------------------------

### `path_mktemp`

Create a temporary path.

A drop in replacement for the `mktemp` command found on many systems, but
available even when `mktemp` is not and with system independent
functionality.

_SYNOPSIS_
<!-- - -->

    path_mktemp
       [--target <VARIABLE>|--output <VARIABLE>]
       [-q|--quiet] [-d|--directory] [-u|--dry-run]
       [-p <DIRECTORY>|--tmpdir[=<DIRECTORY>]] [-t]
       [--suffix <SUFFIX>]
       [--]
       [<TEMPLATE>]

_ARGUMENTS_
<!-- -- -->

`--target <VARIABLE>`, `--output <VARIABLE>` \[out:ref]

- Variable that will receive the generated path.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.
- Current contents will be lost.

`-q`, `--quiet` \[in]

- Suppress any output while creating paths (even on error.)

`-d`, `--directory` \[in]

- Make a directory, not a file.

`-u`, `--dry-run` \[in]

- Do not create the path, just generate it.
- This is potentially unsafe.

`-p <DIRECTORY>`, `--tmpdir[=<DIRECTORY>]` \[in]

- The location to create the temporary item.
- If not specified `DIRECTORY` is set to `TMPDIR` if
  it is set, or `/tmp` otherwise.
- If specified `TEMPLATE` can _not_ be an absolute path
  (i.e. can not begin with `/` (`<slash>`)).

`-t` \[in]

- `TEMPLATE` is the final portion of a path _only_.
- If specified it is an error if `TEMPLATE` contains
  _any_ directory separators.
- Implies `--tmpdir`.

`--suffix <SUFFIX>` \[in]

- Append `SUFFIX` to the final temporary path.
- Can not contain any `/` (`<slash>`) characters.
- Note: Usage may mean `mktemp` can not be used to
  generate the final path.

`TEMPLATE` \[in]

- Template used to generate the temporary path.
- If not specified defaults to `tmp.XXXXXXXXXX` and
  `--tmpdir` is implied.
- Must contain a sequence of `X` characters of length 3
  or more in the _final_ path segment.
- Can contain directory separators.
- Valid values are modified by other arguments.
- Note: If the template does _not_ end in `XXX` may mean
 `mktemp` can not be used to generate the final path.

_EXAMPLES_
<!-- - -->

    path_mktemp -dup ~
    path_mktemp --tmpdir a.tmp.file.XXXXXXXX

_CAVEATS_
<!--  -->

- Invokes `umask 077` before any path is created. (This is in line with many
  `mktemp` implementations.)
- `path_mktemp` is subject to the same safety considerations as any
  implementation of `mktemp`.
- _Safe use of `path_mktemp` may not be possible for some use cases._ (This
  is also true of `mktemp`.)
- `path_mktemp` is implemented using either `mktemp`, `od`, `hexdump`, or
  `awk` depending on configuration and availability. (For `od` and `hexdump`
  `/dev/urandom` must also be present and readable.)
- When `/dev/urandom` is used for random data `path_mktemp` **may block**.
  Whether or not this happens is implementation and situation dependent -
  some implementations never block, others only early in the boot process,
  others will block whenever available entropy is too low (even though the
  point of `/dev/urandom` is meant to be to avoid this).
- When `awk` is used for random data `path_mktemp` **this not secure**.
  The random data generated is of poor quality, making the final path
  potentially guessable.
- Even if a `mktemp` command is present on a system, it may not support the
  options required to implement `path_mktemp` for specific option
  combinations and values. _In such cases `mktemp` will **not** be used_
  even if it is used in other cases.[^mktemp_limited]

 [^mktemp_limited]: The BSD implementation of `mktemp`, for example, lacks
                    a `--suffix` option, it also behaves differently if
                    `<TEMPLATE>` does not end with `XXX` in that it uses
                    `<TEMPLATE>` _as is_ without injecting any random
                    characters.

_NOTES_
<!-- -->

- The configuration variables
  [`BS_LIBPATH_CONFIG_NO_MKTEMP`](#bs_libpath_config_no_mktemp),
  [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump),
  and [`BS_LIBPATH_CONFIG_RANDOM_SOURCE`](#bs_libpath_config_random_source)
  help determine how `path_mktemp` operates.
- Although the `mktemp` command can be found on many systems, it is
  non-standard and varies in operation between implementations, `path_mktemp`
  provides identical functionality regardless of the system _even when_
  _`mktemp` is used to generate the final path_.
- Functionality is largely a match for [GNU `mktemp`][gnu_mktemp], however
  there are some cases where option values considered an error for
  `path_mktemp` are permitted by [GNU `mktemp`][gnu_mktemp] - this is a
  deliberate choice: while accepting these values would be feasible it would
  add complexity to an already complicated command and the GNU `mktemp`
  behavior seems somewhat odd, of questionable use, and does not seem
  consistent with other behavior.[^mktemp_suffix]
- To avoid an infinite loop, a hardcoded maximum number of attempts to
  generate a path is used (when `mktemp` is not used). (The maximum is
  `62^3`, i.e. `238328` - which represents the minimum number of available
  paths when using the minimum of 3 template characters represented in
  base-62.)

 [^mktemp_suffix]: Of note, [GNU `mktemp`][gnu_mktemp] permits a trailing
                   `/` (`<slash>`) to appear in `--suffix` in some conditions
                   where `path_mktemp` does not.

---------------------------------------------------------

### `path_mktmp`

An alias for [`path_mktemp`](#path_mktemp).

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## STANDARDS

- [_POSIX.1-2008_][posix].
- [FreeBSD SYSEXITS(3)][sysexits].
- [Semantic Versioning v2.0.0][semver].
- [Inclusive Naming Initiative][inclusivenaming].

_For more details see the `shtoolkit` general [documentation](./README.MD#standards)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## CAVEATS

- The library attempts to account for differences between implementations
  (where known), however, it is not possible to do this for every case.

_For more details see the `shtoolkit` general [documentation](./README.MD#caveats)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- REFERENCES -->
<!-- cSpell:Ignore coreutils -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

[markdown]:                  <https://daringfireball.net/projects/markdown/syntax>                                                "Markdown: Syntax \[daringfireball.net\]"
[commonmark]:                <https://commonmark.org/>                                                                            "CommonMark \[spec.commonmark.org\]"
[commonmark_spec]:           <https://spec.commonmark.org/current/>                                                               "CommonMark Spec (current) \[spec.commonmark.org\]"

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

<!-- ---------------------------- -->

[posix_rand]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/functions/rand.html>                   "POSIX: rand \[pubs.opengroup.org\]"
[posix_basename]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/basename.html>               "POSIX: basename \[pubs.opengroup.org\]"
[posix_dirname]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/dirname.html>                "POSIX: dirname \[pubs.opengroup.org\]"
[posix_file_serial_num]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_175>    "POSIX: File Serial Number \[pubs.opengroup.org\]"

[gnu_coreutils]:             <https://www.gnu.org/software/coreutils/>                                                            "Coreutils \[gnu.org\]"

[gnu_mktemp]:                <https://www.gnu.org/software/coreutils/manual/html_node/mktemp-invocation.html>                     "mktemp \[gnu.org\]"

[freebsd_mktemp]:            <https://man.freebsd.org/cgi/man.cgi?mktemp(1)>                                                      "mktemp \[man.freebsd.org\]"
[openbsd_mktemp]:            <https://man.openbsd.org/mktemp.1>                                                                   "mktemp \[man.openbsd.org\]"

