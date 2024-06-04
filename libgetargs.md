<!-- #################################################################### -->
<!-- ########### THIS FILE WAS GENERATED FROM 'libgetargs.sh' ########### -->
<!-- #################################################################### -->
<!-- ########################### DO NOT EDIT! ########################### -->
<!-- #################################################################### -->

# LIBGETARGS

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## SYNOPSIS

    . libgetargs.sh
    ...
    getargs <SPECIFICATION>... [--] <ARGUMENT>...

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

Command argument processing for scripts and script functions.

Parses all ARGUMENTs according to the configuration specified with
SPECIFICATION.

While generally similar in functionality to the _POSIX.1_ specified utility
[`getopts`][posix_getopts] or the `getopt` utility from
[`util-linux`][util_linux], `getargs` provides greater functionality while
also requiring less code and being compatible with any _POSIX.1_ compliant
environment.

Discussion of anything to do with command arguments is challenging as the
different people understand the same terms differently with some terms
used interchangeably depending on the situation, or with different meanings
in other contexts. Terminology used here is based on the
[_POSIX.1_ "Utility Conventions"][posix_utility_conventions], with
appropriate extensions where necessary. A brief summary of key terms can be
found in [NOTES](#notes).

The utility [`getarg`](./getarg.md)[^getarg_name] is a wrapper for
`libgetargs.sh` which provides the functionality of the library as a directly
invocable command (i.e. one that does not require the library be imported
prior to use).

[^getarg_name]: The choice of `getarg` for the name used by standalone
                version of the library is to avoid ambiguity. Originally it
                was also named `getargs`, but it quickly became clear that
                this was _not_ a good name as the documentation became very
                difficult to follow and the use of `getargs` in a script was
                ambiguous (did it mean an imported command or the wrapper
                binary) - this was particularly problematic since the usage
                needs to be different in each case.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## OPTIONS

_MAIN OPTIONS_
<!-- ----- -->

`-o <CONFIG>`, `--options <CONFIG>`

- **Required.**
- `<CONFIG>` describes how OPTIONs are processed.
- MAY be specified multiple times.
- For more details see [OPTION-CONFIG](#option-config).

`-p <CONFIG>`, `--positional <CONFIG>`, `--operands <CONFIG>`

- `<CONFIG>` describes how OPERANDs are processed.
- MAY be specified multiple times.
- For more details see [OPERAND-CONFIG](#operand-config).

_MODE OPTIONS_
<!-- ----- -->

`--auto-help[=<VARIABLE>]`

- Automatically process a `--help` or `-h` `<ARGUMENT>`.
- If `--help` or `-h` is encountered, help text is generated from
  `<SPECIFICATION>` and either stored in `<VARIABLE>` (if it was provided) or
  written to `STDOUT` (if it was not), processing then stops and an exit
  status of `1` (`<one>`) is set.
- For more details see [AUTO-HELP](#auto-help).

`--script[=<VARIABLE>]`

- Generate a script suitable for use with `eval` which will set the variables
  from  `<SPECIFICATION>` as would be set by `getargs` when given the same
  input, the resulting script is either stored in `<VARIABLE>` (if it was
  provided) or written to `STDOUT` (if it was not).
- For more details see [SCRIPT](#script).

`--validate[=<VALIDATOR>]`,   `-v[[=]<VALIDATOR>]`

- Use `<VALIDATOR>` as a command to validate all OPTION-ARGUMENTs and
  OPERANDs.
- An error occurs if `<VALIDATOR>` has a non-zero exit status.
- If `<VALIDATOR>` is not specified uses
  [`getargs_validate_option_value`](#getargs_validate_option_value).
- For more details see [VALIDATOR](#validator).

_OTHER OPTIONS_
<!-- ------ -->

`--name <ID>`, `-n[=]<ID>`, `--id <ID>`, `-i[=]<ID>`

- Set an `<ID>` to use for error messages and with [auto-help](#auto-help),
  if not specified a default of `getargs` or `<command>` is used
  respectively.
- Does not effect if the value stored in
  [`BS_LIBGETARGS_LAST_ERROR`](#bs_libgetargs_last_error).

`--version`,  `-V`

- Write the library version number to `STDOUT` and exit.

`--help`,  `-h`

- Display help text and exit.
- **Only available with `getarg`.**

_PREFERENCE OPTIONS_
<!-- ----------- -->

Preferences can be set by OPTION or by [environment variables](#environment),
(OPTIONs take precedence). Defaults for each option are highlighted, and the
associated variable is noted - more detailed information for each preference
can be found with these variables.

`--[no-]abbreviations`

- \[Enable]/Disable allowing LONG-OPTIONs to be abbreviated.
- Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_ABBREVIATIONS`](#bs_libgetargs_config_allow_abbreviations).

`--[no-]ambiguous`

- \[Enable]/Disable detection of ambiguous OPTIONs.
- Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_AMBIGUOUS`](#bs_libgetargs_config_allow_ambiguous)

`--[no-]check-config`

- Enable/\[Disable] performing basic checks on OPTION-CONFIG and
  OPERAND-CONFIG before processing.
- Overrides [`BS_LIBGETARGS_CONFIG_CHECK_CONFIG`](#bs_libgetargs_config_check_config)

`--[no-]fatal[-errors]`

- Enable/\[Disable] causing library errors to terminate the current
  (sub-)shell.
- Overrides [`BS_LIBGETARGS_CONFIG_FATAL_ERRORS`](#bs_libgetargs_config_fatal_errors)

`--[no-]interleaved`, `--[no-]mixed`

- Enable/\[Disable] matching OPTIONs after the first OPERAND is matched.
- Overrides [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands).
- Can not be used with `--strict`.

`--[no-]posix-long`

- Enable/\[Disable] matching LONG-OPTIONs with a single preceding `-`
  (`<hyphen>`) character instead of the normally required two.
- Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_POSIX_LONG`](#bs_libgetargs_config_allow_posix_long)

`--[no-]quiet[-error]`

- \[Enable]/Disable error message output.
- Overrides [`BS_LIBGETARGS_CONFIG_QUIET_ERRORS`](#bs_libgetargs_config_quiet_errors)

`--[no-]strict`, `--[no-]separated`

- Enable/\[Disable] requiring the use of `--` (`<hyphen><hyphen>`) to separate
  OPTIONs from OPERANDs.
- Overrides [`BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`](#bs_libgetargs_config_strict_operands).
- Can not be used with `--interleaved` or `--unmatched`.

`--[no-]unsafe`

- \[Enable]/Disable escaping OPTIONs to avoid any erroneous results when
  matching with regular expressions.
- Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_UNSAFE_OPTIONS`](#bs_libgetargs_config_allow_unsafe_options)

`--[no-]unset`

- Enable/\[Disable] automatic unsetting of all variables named in
  OPTION-CONFIG and OPERAND-CONFIG.
- Overrides [`BS_LIBGETARGS_CONFIG_AUTO_UNSET`](#bs_libgetargs_config_auto_unset)

`--[no-]unmatched`

- Enable/\[Disable] matching an unrecognized OPTION as an OPERAND.
- Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`](#bs_libgetargs_config_allow_unmatched).
- Implies `--interleaved`.
- Can not be used with `--strict`.

_NOTES_
<!-- -->

Functionality can be invoked either by importing `libgetargs.sh` _or_ via
the standalone wrapper script `getarg`. When invoked as `getarg`:

- `--script` is implied (and can not be specified again).
- `--[no-]fatal[-errors]` is permitted, but is not useful.
- `--auto-help` works as intended, but the output can not be stored in a
   variable[^getarg-auto-help].

[^getarg-auto-help]: Technically this is incorrect, the output from
                     `--auto-help` _can_ be stored in a variable, however
                     this value will be lost when the sub-shell where
                     `getarg` was invoked exits.

### OPTION-CONFIG

    <ALPHA>          = ? characters from the LC_CTYPE 'alpha' class ? ;
    <ALNUM>          = ? characters from the LC_CTYPE 'alnum' class ? ;
    <GRAPH>          = ? characters from the LC_CTYPE 'graph' class ? ;
    <NEWLINE>        = "\n"
    <WHITESPACE>     = " " | "\t"

    <NAME>           = <ALNUM>, { <ALNUM> | "_" | "-" } ;
    <TYPE>           = "-" | "~" | "?" | ":" | ";" | "+" ;
    <VARIABLE>       = <ALPHA>, { <ALNUM> | "_" } ;
    <OPTIONS>        = <NAME> { "|" <NAME> } "[" <TYPE> "]" <VARIABLE>,
                       { "," <OPTIONS> } ;

    <HELP>           = ( <GRAPH> | <WHITESPACE> ), { <HELP> }
    <HELP-TEXT>      = { "#" <HELP> }
                       { <NEWLINE>, { <WHITESPACE> }, "#" <HELP> } ;

    <OPERAND-CONFIG> = <OPTIONS>, [ <HELP-TEXT> ] ;

OPTION-CONFIG as specified with the the OPTION `--options`, or `-o`, uses the
above syntax. The following rules then apply:

- if multiple OPTION-CONFIGs are specified, they are concatenated into a
  single OPTION-CONFIG
- each `<NAME>` defines an OPTION-NAME
- each `<VARIABLE>` specifies a shell variable
- each **unique** `<VARIABLE>` defines a _single_ OPTION
- every `<NAME>` associated with a `<VARIABLE>` defines an OPTION-ALIAS
  - a `<VARIABLE>` specified in multiple OPTION-CONFIGs implies a _single_
    OPTION that matches _all_ the specified OPTION-ALIASes
- an OPTION-ALIAS that is a single character defines a SHORT-OPTION-ALIAS
- an OPTION-ALIAS that is two or more characters defines a LONG-OPTION-ALIAS
- the `<TYPE>` describes how an OPTION is processed:
  - **`[-]`**
    - OPTION:
      - _incrementing SWITCH-OPTION_
      - _MAY be specified multiple times_
    - OPTION-ARGUMENT:
      - _prohibited_
    - OPTION-TAG:
      - _a positive whole number_
    - `<VARIABLE>`:
      - receives the value of any OPTION-TAG, otherwise
        is incremented every time `OPTION` is specified
      - when no OPTION-TAG is used, `<VARIABLE>` holds a value
        indicating how many times the OPTION was specified
  - **`[~]`**
    - OPTION:
      - _negatable SWITCH-OPTION_
      - _MAY be specified multiple times_
    - OPTION-ARGUMENT:
      - _prohibited_
    - OPTION-TAG:
      - _value of_
        _[`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)_
        _or_
        _[`BS_LIBGETARGS_CONFIG_FALSE_VALUE`](#bs_libgetargs_config_false_value)_
    - `<VARIABLE>`:
      - receives the value of any OPTION-TAG, otherwise the value of
        [`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)
  - **`[?]`**
    - OPTION:
      - _MUST be specified at most once_
    - OPTION-ARGUMENT:
      - _optional_
      - _MUST be an AGGREGATE-OPTION-ARGUMENT_
    - OPTION-TAG:
      - _prohibited_
    - `<VARIABLE>`:
      - receives the value of any OPTION-ARGUMENT, or the value of
        [`BS_LIBGETARGS_CONFIG_OPTIONAL_VALUE`](#bs_libgetargs_config_optional_value)
        if no OPTION-ARGUMENT was specified
  - **`[:]`**
    - OPTION:
      - _MUST be specified at most once_
    - OPTION-ARGUMENT:
      - _required_
    - OPTION-TAG:
      - _prohibited_
    - `<VARIABLE>`:
      - receives the value of the OPTION-ARGUMENT
  - **`[;]`**
    - OPTION:
      - _MAY be specified multiple times_
    - OPTION-ARGUMENT:
      - _required_
    - OPTION-TAG:
      - _prohibited_
    - `<VARIABLE>`:
      - receives the value of the _last_ OPTION-ARGUMENT specified
      - any previously specified OPTION-ARGUMENTs are discarded
  - **`[+]`**
    - OPTION:
      - _MAY be specified multiple times_
    - OPTION-ARGUMENT:
      - _required_
    - OPTION-TAG:
      - _one of the values `array`, `passthrough`, `passthru`, or `forward`_
    - `<VARIABLE>`:
      - receives the value of the all OPTION-ARGUMENT as an emulated array
      - if one of the permitted OPTION-TAGs is specified, OPTION-ARGUMENT
        is an emulated array the _contents_ of which are appended
- `<HELP-TEXT>` can follow any OPTION-CONFIG:
  - any text here is used to annotate options for auto-help, if enabled, or
    as comments otherwise
  - `<HELP-TEXT>` is always associated with a _single_ `<VARIABLE>`
  - for more details see [auto-help](#auto-help)

_NOTES_
<!-- -->

- OPTION-TAGs are designed to facilitate commands where OPTIONs are used
  to invoke other commands without further processing, allowing them to be
  "forwarded" safely and efficiently
- Any number of OPTION-ALIASes can be specified for a single OPTION
  - only a LONG-OPTION-ALIAS can:
    - be abbreviated (to a minimum of 2 characters)
  - only a SHORT-OPTION-ALIAS can:
    - be part of a COMPOUND-OPTION
    - use an AGGREGATE-ARGUMENT without a delimiter
- Every OPTION processed MUST match an OPTION-ALIAS
- Ambiguous OPTIONs are either an error, or _always_ use
  the first matched OPTION-CONFIG from SPECIFICATION
- A `<VARIABLE>` can be set prior to invoking `getargs`, any such value is
  ignored and does not affect the process of any `<TYPE>` (this allows
  a default value to be specified)

_EXAMPLES_
<!-- - -->

Example OPTION-CONFIGs and _some_ of the OPTION formats supported:

- `"d|debug[~]DebugEnabled,q|quite|s|silent[-]QuiteMode"`
  - `-d`, `--debug`, `--deb`, or `-d:true` set `DebugEnabled` to `true`
  - `-d:false` sets `DebugEnabled` to `false`
  - `-q`, `-quite`, `-s`, or `-silent:1` set `QuiteMode` to `1`
  - `-q -q`, or `-s:2` set `QuiteMode` to `2`
- `"i|input-file|file|source|uri[+]InputFiles,o|output-file|target[;]OutputFile"`
  - `-iFILE`, `-i=FILE`, `-i FILE`, or `--file=FILE` set `InputFiles` to an
    emulated array with a single element: `FILE`
  - `--uri FIRST --URI SECOND` sets `InputFiles` to an emulated array with
    two elements: `FIRST`, `SECOND`
  - `-oFILE`, or `-o FILE` set `OutputFile` to `FILE`
  - `-oFILE1 -o FILE2` set `OutputFile` to `FILE2`
- `"i|input-file[:]InputFile#The file to be processed. Must exist!"`
  - Output from [auto-help](#auto-help) includes the text
    `The file to be processed. Must exist!`.

### OPERAND-CONFIG

    <ALPHA>          = ? characters from the LC_CTYPE 'alpha' class ? ;
    <ALNUM>          = ? characters from the LC_CTYPE 'alnum' class ? ;
    <GRAPH>          = ? characters from the LC_CTYPE 'graph' class ? ;
    <NEWLINE>        = "\n"
    <WHITESPACE>     = " " | "\t"

    <TYPE>           = ":" | ";" | "^" ;
    <VARIABLE>       = <ALPHA>, { <ALNUM> | "_" } ;
    <OPERANDS>       = "[" <TYPE> "]" <VARIABLE>, { "," <OPERANDS> } ;

    <HELP>           = ( <GRAPH> | <WHITESPACE> ), { <HELP> }
    <HELP-TEXT>      = { "#" <HELP> }
                       { <NEWLINE>, { <WHITESPACE> }, "#" <HELP> } ;

    <OPERAND-CONFIG> = <OPERANDS>,
                       [ "[+]" <VARIABLE> ],
                       [ <HELP-TEXT> ] ;

OPERAND-CONFIG as specified with the the OPTION `--operands`, `--positional`
or `-p`, uses the above syntax. The following rules then apply:

- if multiple OPERAND-CONFIGs are specified, they are concatenated into a
  single OPERAND-CONFIG
- each `<VARIABLE>` specifies a shell variable
- each single OPERAND-CONFIG consumes zero or one OPERANDs, EXCEPT the
  final OPERAND-CONFIG which MAY consume any number of OPERANDs
- the `<TYPE>` describes how an OPERAND is processed:
  - **`[:]`**
    - OPERAND:
      - ALWAYS consumes a single OPERAND
    - `<VARIABLE>`:
      - receives the value of the current OPERAND
      - MUST not have been set by any earlier OPTION/OPERAND
  - **`[;]`**
    - OPERAND:
      - ALWAYS consumes a single OPERAND
    - `<VARIABLE>`:
      - receives the value of the current OPERAND
      - any existing value is overwritten
  - **`[^]`**
    - OPERAND:
      - MAY consume a single OPERAND
    - `<VARIABLE>`:
      - if `<VARIABLE>` was set by a previous OPTION/OPERAND:
        - no modification is made to `<VARIABLE>`
        - this OPERAND-CONFIG is skipped
        - current OPERAND is retained for next OPERAND-CONFIG
      - if `<VARIABLE>` has not been set by a previous
        OPTION/OPERAND, behaves exactly like `[:]`
  - **`[+]`**
    - OPERAND:
      - ALWAYS consumes all remaining OPERANDs
    - `<VARIABLE>`:
      - has all remaining OPERANDs appended to any
        existing value as an emulated array
- `<HELP-TEXT>` can follow any OPERAND-CONFIG:
  - any text here is used to annotate options for auto-help, if enabled, or
    as comments otherwise
  - `<HELP-TEXT>` is always associated with a _single_ `<VARIABLE>`
  - for more details see [auto-help](#auto-help)

_NOTES_
<!-- -->

- A `<TYPE>` of `[:]`, `[;]`, or `[^]` is identical UNLESS `<VARIABLE>` was
  set by a previous OPTION/OPERAND
- If specified, a `<TYPE>` of `[+]` MUST be the last `<OPERAND-CONFIG>`
- A `<TYPE>` of `[^]` can be used to accept an ARGUMENT using an OPTION _or_
  an OPERAND by using the same `<VARIABLE>` for both an OPTION-CONFIG and
  the OPERAND-CONFIG
- OPERANDs are only permitted if there is an OPERAND-CONFIG,
  otherwise they are an error
- A `<VARIABLE>` can be set prior to invoking `getargs`, any such value is
  ignored and does not affect the process of any `<TYPE>` (this allows
  a default value to be specified)

### MODES

"MODES" change the processing of `getargs` in a significant way.

#### AUTO-HELP

    --auto-help[=<VARIABLE>]

Causes `getargs` to automatically process a `--help` or `-h` `<ARGUMENT>`.

Help text is generated based on OPTION-CONFIG and OPERAND-CONFIG, with
information on how to specify values for ARGUMENTs based on their type.

The generated text is stored in `<VARIABLE>`, if it was provided, otherwise
it is written to `STDOUT`. In either case, processing stops after the
text has been generated.

An exit status of `1` indicates help text was generated - it should be
assumed that no ARGUMENTs have been processed.

When enabled, the OPTIONs `--help` or `-h` will be matched by `getargs` and
will never match OPTION-CONFIG (although they may be present).

There is no performance impact for enabling this option.

_COMMAND NAME_
<!-- ----- -->

If an `<ID>` has been specified (i.e. using `--name` option or aliases), it
will be used as the name of the command in the resulting text.

`<HELP-TEXT>`
<!-- --- -->

Additional information can be provided for any of the ARGUMENTs in the
resulting text via `<HELP-TEXT>`, which is arbitrary text that can be
specified along with OPTION-CONFIG or OPERAND-CONFIG.

`<HELP-TEXT>` is specified using a single `#` (`<number-sign>`) following the
OPTION or OPERAND for which the text applies and can contain any text.
Multiple lines of `<HELP-TEXT>` may be specified by inserting a `\n`
(`<newline>`) character followed by any number of whitespace characters,
then a `#` (`<number-sign>`) and the continued `<HELP-TEXT>`. Note that only
continuation lines may contain whitespace prior to the `#` (`<number-sign>`),
the first `#` (`<number-sign>`) of any `<HELP-TEXT>` must be immediately
follow the VARIABLE to which the text applies.

Formatting for `<HELP-TEXT>` will _not_ be retained:

 - whitespace _after_ the `#` (`<number-sign>`) will be removed
 - after a `\n` (`<newline>`) any whitespace _before_ the `#`
   (`<number-sign>`) will be removed
 - additional whitespace may be removed to facilitate text wrapping

_CONFIGURATION_
<!-- ------- -->

Several [environment variables](#environment) can alter the format of the
generated text, though the general format is fixed and is different to that
of common tools due to the difficulties with automatically formatting text.

#### SCRIPT

    --script[=<SCRIPT>]

Causes `getargs` to generate a dynamic script suitable for use with `eval`
which recreates the externally visible side-effects of running `getargs`.

The script generated in this mode sets the variables in OPTION-CONFIG and
OPERAND-CONFIG appropriately for the ARGUMENTs specified. Primarily this is
intended to allow `getargs` to be invoked in a sub-shell while allowing the
setting of variables to occur _outside_ the sub-shell.

Generating the script _may_ have a performance impact, and occurs _after_
all other operations, and _only_ if there were no errors. If `<SCRIPT>` is
provided, the script is stored in that variable, otherwise it is written to
`STDOUT`.

This mode is used to enable the functionality of the standalone tool
`getarg` which may be installed alongside the library and can be invoked
without requiring importing the library. For scripts that only use `getargs`
once it may make sense to use the standalone tool rather than import the
library, however, for scripts that use `getargs` more than once using the
library will be faster.

#### VALIDATOR

    --validate[=<VALIDATOR>]

Validate values given as ARGUMENTs.

This mode causes `<VALIDATOR>` to be invoked for all OPTION-ARGUMENTs and
OPERANDs, if the subsequent exit status is _not_ `0` (`<zero>`) then an error
is generated and processing stops.

Although only a single VALIDATOR is available for any invocation of
`getargs`, when it is invoked, a VALIDATOR receives multiple pieces of
information, including the name of the variable in which the value is to be
stored - this should allow values to be validated based on the expected type.

A VALIDATOR is most useful when a value is of a type that can easily be
tested for and is used repeatedly, for example ensuring filesystem paths are
valid, or that a value is numeric. More specific validation is better handled
elsewhere.

A VALIDATOR can do any processing required to determine if the value it is
given is valid, however it can _not_ change the value.

If `<VALIDATOR>` is not specified, [`getargs_validate_option_value`](#getargs_validate_option_value)
is used, this is provided more as an example VALIDATOR than as one of any
great use, documentation for it includes details of the arguments a VALIDATOR
receives.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## EXIT STATUS

- The exit status will be `0` (`<zero>`) if, and only if, all ARGUMENTs were
  processed correctly.
- The exit status will be `1` (`<one>`) if [AUTO-HELP](#auto-help) is enabled
  _AND_ an ARGUMENT specified that was either `--help` or `-h`. This is to
  signal to the caller that auto-help was triggered and, in general, should
  _not_ be propagated any further (i.e. normally `--help` is a successful
  operation).
- An unexpected exit status from an external command will be propagated to
  the caller. (This is unlikely to occur, and would normally indicate a
  command that is not _POSIX.1_ compliant.)
- Otherwise the exit status is one of values taken from
  [FreeBSD `SYSEXITS(3)`][sysexits]:
  - `EX_USAGE` for invalid SPECIFICATION usage
    (e.g. a missing OPTION-ARGUMENT)
  - `EX_CONFIG` for an invalid SPECIFICATION configuration
    (e.g. an invalid character in OPTION-CONFIG)
  - `EX_DATAERR` for invalid user ARGUMENTs (e.g. an OPTION that is meant to
    be should be set once - i.e. of type `[:]` - is set twice), this is the
    only error exit status normally generated for user ARGUMENT errors.

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

#### `BS_LIBGETARGS_CONFIG_NO_Z_SHELL_SETOPT`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`](./README.MD#better_scripts_config_no_z_shell_setopt)
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
- _Z Shell_ has some defaults that cause non-standard
  behavior, however also provides `setopt` which can be
  tightly scoped to set options when required without
  impacting other platforms.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_NO_EXPR_EXIT_STATUS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_EXPR_EXIT_STATUS`](./README.MD#better_scripts_config_no_expr_exit_status)
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

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_NO_EXPR_NESTED_CAPTURES`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_EXPR_NESTED_CAPTURES`](./README.MD#better_scripts_config_no_expr_nested_captures)
- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- Disable/\[Enable] using `expr` for any
  ["Basic Regular Expression" (_BRE_)][posix_bre] that
  includes nested captures.
- _OFF_: Use `expr` for a _BRE_ that includes nested
  captures.
- _ON_: Any _BRE_ that uses nested captures will not
  be used with `expr`, but will use a case specific
  work-around.
- Some versions of `expr` do not work well with or do not
  support nested captures.

<!-- ------------------------------------------------ -->

### USER PREFERENCE (OVERRIDABLE)

Configuration that CAN be overridden by OPTIONs.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_ALLOW_ABBREVIATIONS`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _ON_
- Override: `--[no-]abbreviations`
- \[Enable]/Disable LONG-OPTION abbreviations.
- _ON_: any LONG-OPTION matches if the name is a
  prefix of an OPTION-CONFIG name (e.g. `--debug` and
  `--deb` will both match `debug`).
- _OFF_: abbreviations are disabled and long options
  must match exactly.
- MAY cause unexpected results if combined with
  [`BS_LIBGETARGS_CONFIG_ALLOW_AMBIGUOUS`](#bs_libgetargs_config_allow_ambiguous).

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_ALLOW_AMBIGUOUS`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]ambiguous`
- \[Enable]/Disable detection of ambiguous user OPTIONs.
- _OFF_: any ambiguous OPTION is an error.
- _ON_: all OPTIONs use the first match found - this WILL
  mask some OPTION-CONFIG errors.
- OPTIONs are ambiguous when multiple OPTIONs have the
  same name or, if abbreviations are enabled, when
  an abbreviation matches multiple OPTIONs.
- If abbreviations are also enabled (see
  [`BS_LIBGETARGS_CONFIG_ALLOW_ABBREVIATIONS`](#bs_libgetargs_config_allow_abbreviations))
  there is a high chance of incorrectly matching OPTIONs.
- _Has a measurable impact on performance._
  Prefer **_ON_** for performance.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_CHECK_CONFIG`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]check-config`
- Enable/\[Disable] performing basic checks on
  OPTION-CONFIG and OPERAND-CONFIG before processing.
- _OFF_: don't do any additional checks.
- _ON_: preform extra checks to ensure that OPTION-CONFIG
  and OPERAND-CONFIG match the required specification.
- The currently available checks are relatively basic but
  will catch errors that MAY otherwise be missed, however
  some of these may be benign.
- _MAY have a performance impact._
  Prefer **_OFF_** for performance.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_FATAL_ERRORS`

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
  [`BS_LIBGETARGS_CONFIG_QUIET_ERRORS`](#bs_libgetargs_config_quiet_errors)).
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]interleaved`, `--[no-]mixed`
- Enable/\[Disable] allowing matching OPTIONs _after_ an
  OPERAND is matched.
- _OFF_: all OPTIONs (and associated OPTION-ARGUMENTs)
  MUST appear before the first OPERAND; i.e., the first
  ARGUMENT that does NOT start with `-` (`<hyphen>`)
  and is NOT an OPTION-ARGUMENT causes ALL remaining
  OPTIONs to be assumed to be OPERANDs _even if they
  start with `-` (`<hyphen>`)_.
- _ON_: an ARGUMENT that does NOT start with `-`
  (`<hyphen>`) and is NOT an OPTION-ARGUMENT is assumed
  to be an OPERAND, but following ARGUMENTs continue to
  be checked for OPTIONs.
- In either mode the special ARGUMENT `--` stops OPTION
  processing and any remaining ARGUMENTs are treated as
  OPERANDs
- Implied by
  [`BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`](#bs_libgetargs_config_allow_unmatched)
- Mutually exclusive with
  [`BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`](#bs_libgetargs_config_strict_operands)

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_ALLOW_POSIX_LONG`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]posix-long`
- Enable/\[Disable] matching LONG-OPTIONs with a single
  preceding `-` (`<hyphen>`) character instead of the
  normally required two.
- _OFF_: LONG-OPTIONs require the prefix `--`
- _ON_: any multi-character OPTION following a single
  `-` (`<hyphen>`) is checked to see if it matches
  a LONG-OPTION before checking if it is a
  COMPOUND-OPTION, meaning matching COMPOUND-OPTIONs is
  slower.
- _Has a measurable impact on performance._
  Prefer **_OFF_** for performance.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_QUIET_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[<ID>]: ERROR: <MESSAGE>` (where `<ID>` is
  set using the `--id` OPTION).
- _ON_: library error messages will be suppressed.
- The most recent error message is always available in
  [`BS_LIBGETARGS_LAST_ERROR`](#bs_libgetargs_last_error)
  even when error output is suppressed.
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.
- Does NOT affect errors from non-library commands, which
  _may_ still produce output.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]strict`, `--[no-]separated`
- Enable/\[Disable] requiring the use of `--` to separate
  OPTIONs from OPERANDs.
- _OFF_: the first ARGUMENT that is not and OPTION or an
  OPTION-ARGUMENT is an OPERAND and causes all further
  ARGUMENTs to be OPERANDs.
- _ON_: an ARGUMENT that is exactly `--` must be present
  after _all_ OPTIONs and before _any_ OPERANDs.
- If this is enabled (_ON_), then optional
  OPTION-ARGUMENTS can be specified using the ARGUMENT
  _following_ the OPTION (in addition to the normal
  formats).
- Can help detect some usage errors.
- Mutually exclusive with
  [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands).

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_ALLOW_UNSAFE_OPTIONS`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]unsafe`
- \[Enable]/Disable escaping OPTION characters
  to avoid any erroneous results when matching with
  regular expressions. Characters in the supported set
  for OPTION-NAMEs `[[:alnum:]_-]` do not need this
  processing, while characters outside this range
  MAY (e.g. `.` (`<period>`) is problematic).
- _OFF_: OPTION-NAMEs have all characters made safe for
  use in a regular expression.
- _ON_: OPTION-NAMEs are used as is and may match
  incorrectly if they contain specific characters.
- This affects the OPTIONs being processed and NOT those
  in the OPTION-CONFIG.
- MAY have a performance impact.
  Prefer **_ON_** for performance.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_AUTO_UNSET`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]unset`
- Enable/\[Disable] automatic unsetting of all
  VARIABLES named in OPTION-CONFIG and OPERAND-CONFIG.
- _ON_: every variable specified in OPTION-CONFIG and
  OPERAND-CONFIG is automatically unset before ARGUMENTs
  are processed.
- _OFF_: variables need to be set to a known value or it
  will not be possible to correctly determine what
  OPTIONs have been matched.
- Normally desirable to have enabled, but using it MAY
  have performance issues, and it can not be used
  alongside default values for variables (i.e. values set
  before `getargs` is invoked).
- MAY have a performance impact.
  Prefer **_OFF_** for performance.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`

- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Override: `--[no-]unmatched`
- Enable/\[Disable] matching an unrecognized OPTION as an
  OPERAND.
- _OFF_: any unrecognized OPTION is an error.
- _ON_: any unrecognized OPTION is treated as an OPERAND.
- Useful for commands where most arguments are not used,
  but instead forwarded to another command, where having
  this enabled significantly reduces code and isolates
  the command from changes in the arguments accepted by
  the target command.
- In either mode the special ARGUMENT `--` stops OPTION
  processing and any remaining ARGUMENTs are treated as
  OPERANDs.
- Although still permitted, there is no practical way to
  support the normal OPERAND processing when this is
  enabled; the only OPERAND-CONFIG that is useful will
  be one containing a single `[+]` type. If other
  OPERANDs are required, these must be manually extracted
  from the resulting array.
- If using a VALIDATOR, any unmatched values will be
  sent to the VALIDATOR as OPERANDs.
- Implies
  [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands).
- Mutually exclusive with
  [`BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`](#bs_libgetargs_config_strict_operands).

<!-- ------------------------------------------------ -->

### USER PREFERENCE

Configuration that can NOT be overridden by OPTIONs.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_TRUE_VALUE`

- Type:     TEXT
- Class:    VARIABLE
- Default:  `true`
- Value used as `true` for options with the type
  negatable SWITCH-OPTION (i.e. `[~]`).
- The value given to a negatable SWITCH-OPTION variable
  when the ARGUMENT was specified without an OPTION-TAG.
- Also one of the values accepted as an OPTION-TAG for
  negatable SWITCH-OPTIONs.
- Can be null.
- SHOULD differ from
  [`BS_LIBGETARGS_CONFIG_FALSE_VALUE`](#bs_libgetargs_config_false_value)
  however this is NOT enforced.
- A negatable SWITCH-OPTION _only_ accepts the value here
  or the value from
  [`BS_LIBGETARGS_CONFIG_FALSE_VALUE`](#bs_libgetargs_config_false_value)
  as an OPTION-TAG.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_FALSE_VALUE`

- Type:     TEXT
- Class:    VARIABLE
- Default:  `false`
- Value used as `false` for options with the type
  negatable SWITCH-OPTION (i.e. `[~]`).
- This value can be specified as an OPTION-TAG for the
  OPTION in which case the OPTION variable will receive
  this value.
- Can be null.
- SHOULD differ from
  [`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)
  however this is NOT enforced.
- A negatable SWITCH-OPTION _only_ accepts the value here
  or the value from
  [`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)
  as an OPTION-TAG.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_OPTIONAL_VALUE`

- Type:     TEXT
- Class:    VARIABLE
- Default:  \<unset>
- The value an OPTION variable receives if it takes an
  optional OPTION-ARGUMENT and no OPTION-ARGUMENT was
  specified.
- It is not possible to set a value here that could not
  have also been set as the OPTION-ARGUMENT for the
  OPTION, e.g., the default of \<unset> is the same value
  as would occur if the OPTION-ARGUMENT was an empty
  string.
- It is highly recommended that this be set to a more
  useful value if optional OPTION-ARGUMENTs are used.

<!-- ------------------------------------------------ -->

### AUTO-HELP CONFIGURATION

Configuration related only to [AUTO-HELP](#auto-help)
mode.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_HELP_WRAP_COLUMNS`

- Type:     TEXT
- Class:    VARIABLE
- Default:  Value from the `COLUMNS` environment variable
            or `80` if that variable is not set.
- Specifies the maximum width of the generated help text,
  any lines longer than this will be wrapped.
- May be set to any numeric value greater than `8`,
  although small values will lead to illegible output.
- If set to the empty string (aka null), wrapping is
  disabled.
- If set to an invalid value, the default value is used.
- Help text uses an indent of `8` characters which counts
  towards the length of lines for the purposes of
  wrapping.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_HELP_MULTI_OPTION`

- Type:     TEXT
- Class:    VARIABLE
- Default:  `May be specified multiple times.`
- A string added to help for OPTIONs of the `[+]` type.
- Used to indicate the OPTION can be specified more than
  once.
- If set to the empty string (aka null), no text is
  added.
- WILL cause errors if it contains any `\n` (`<newline>`)
  characters.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_HELP_MULTI_OPERAND`

- Type:     TEXT
- Class:    VARIABLE
- Default:  `May be specified multiple times.`
- A string added to help for OPERANDs of the `[+]` type.
- Used to indicate the OPERAND can be specified more than
  once.
- If set to the empty string (aka null), no text is
  added.
- WILL cause errors if it contains any `\n` (`<newline>`)
  characters.

---------------------------------------------------------

#### `BS_LIBGETARGS_CONFIG_HELP_ALTERNATIVE_OPERAND`

- Type:     TEXT
- Class:    VARIABLE
- Default:  `Alternative to <OPTION>.`
- A string added to help for an OPERAND if there is an
  OPTION that provides the same purpose. (i.e. only
  OPERANDs of the type `[^]` or `[+]`).
- The literal string `<OPTION>` is replaced with one of
  the OPTION-NAMEs for the OPTION that can alternatively
  be used.
- If set to the empty string (aka null), no text is
  added.
- WILL cause errors if it contains any `\n` (`<newline>`)
  characters.

<!-- ------------------------------------------------ -->

### INFORMATIONAL

Variables that convey library information.

---------------------------------------------------------

#### `BS_LIBGETARGS_VERSION_MAJOR`

- Integer >= 1.
- Incremented when there are significant changes, or
  any changes break compatibility with previous
  versions.

---------------------------------------------------------

#### `BS_LIBGETARGS_VERSION_MINOR`

- Integer >= 0.
- Incremented for significant changes that do not
  break compatibility with previous versions.
- Reset to 0 when
  [`BS_LIBGETARGS_VERSION_MAJOR`](#bs_libgetargs_version_major)
  changes.

---------------------------------------------------------

#### `BS_LIBGETARGS_VERSION_PATCH`

- Integer >= 0.
- Incremented for minor revisions or bugfixes.
- Reset to 0 when
  [`BS_LIBGETARGS_VERSION_MINOR`](#bs_libgetargs_version_minor)
  changes.

---------------------------------------------------------

#### `BS_LIBGETARGS_VERSION_RELEASE`

- A string indicating a pre-release version, always
  null for full-release versions.
- Possible values include 'alpha', 'beta', 'rc',
  etc, (a numerical suffix may also be appended).

---------------------------------------------------------

#### `BS_LIBGETARGS_VERSION_FULL`

- Full version combining
  [`BS_LIBGETARGS_VERSION_MAJOR`](#bs_libgetargs_version_major),
  [`BS_LIBGETARGS_VERSION_MINOR`](#bs_libgetargs_version_minor),
  and [`BS_LIBGETARGS_VERSION_PATCH`](#bs_libgetargs_version_patch)
  as a single integer.
- Can be used in numerical comparisons.
- Format: `MNNNPPP` where, `M` is the `MAJOR` version,
  `NNN` is the `MINOR` version (3 digit, zero padded),
  and `PPP` is the `PATCH` version (3 digit, zero padded).

---------------------------------------------------------

#### `BS_LIBGETARGS_VERSION`

- Full version combining
  [`BS_LIBGETARGS_VERSION_MAJOR`](#bs_libgetargs_version_major),
  [`BS_LIBGETARGS_VERSION_MINOR`](#bs_libgetargs_version_minor),
  [`BS_LIBARRAY_VERSION_PATCH`](#bs_libgetargs_version_patch),
  and
  [`BS_LIBGETARGS_VERSION_RELEASE`](#bs_libgetargs_version_release)
  as a formatted string.
- Format: `BetterScripts 'libgetargs' vMAJOR.MINOR.PATCH[-RELEASE]`.
- Derived tools MUST include unique identifying
  information in this value that differentiates them
  from the BetterScripts versions. (This information
  should precede the version number.)
- This value is output when the `--version` OPTION is
  used.

---------------------------------------------------------

#### `BS_LIBGETARGS_TYPE_OPT_ARG`

- Value passed to the validation command to indicate
  the type of ARGUMENT being validated.
- Indicates the OPTION parameter is a known OPTION and
  the VALUE parameter is the following ARGUMENT
  (e.g. `--OPTION VALUE`, `-O VALUE`, etc.).
- Implies the VALUE parameter MUST be a valid
  OPTION-ARGUMENT for the specified OPTION.
- See [`getargs_validate_option_value`](#getargs_validate_option_value),

---------------------------------------------------------

#### `BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE`

- Value passed to the validation command to indicate
  the type of ARGUMENT being validated.
- Indicates the OPTION parameter a known OPTION and
  the VALUE parameter was specified as part of the same
  ARGUMENT without any delimiter (e.g. `-OVALUE`).
- Implies the VALUE parameter MUST be a valid
  OPTION-ARGUMENT for the specified OPTION.
- See [`getargs_validate_option_value`](#getargs_validate_option_value),

---------------------------------------------------------

#### `BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED`

- Value passed to the validation command to indicate
  the type of ARGUMENT being validated.
- Indicates the OPTION parameter a known OPTION and
  the VALUE parameter was specified as part of the same
  ARGUMENT delimited by `=` (`<equals>`)
  (e.g. `--OPTION=VALUE`, `-O=VALUE`, etc.).
- Implies the VALUE parameter MUST be a valid
  OPTION-ARGUMENT for the specified OPTION.
- See [`getargs_validate_option_value`](#getargs_validate_option_value),

---------------------------------------------------------

#### `BS_LIBGETARGS_TYPE_OPERAND`

- Value passed to the validation command to indicate
  the type of ARGUMENT being validated.
- Indicates the VALUE parameter is an ARGUMENT that was
  matched as an OPERAND.
- Implies the VALUE parameter MUST be a valid OPERAND.
- See [`getargs_validate_option_value`](#getargs_validate_option_value),

---------------------------------------------------------

#### `BS_LIBGETARGS_LAST_ERROR`

- Stores the error message of the most recent error.
- ONLY valid immediately following a command for which
  the exit status is not `0` (`<zero>`).
- Available even when error output is suppressed.

---------------------------------------------------------

#### `BS_LIBGETARGS_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to
  determine if this file has been sourced.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## ADDITIONAL COMMANDS

---------------------------------------------------------

### `getargs_validate_option_value`

Simple VALIDATOR that writes a warning to `STDERR` if an OPTION-ARGUMENT or
OPERAND starts with a `-` (`<hyphen>`). No other action is taken; processing
continues as normal after the warning is generated.

If validation is enabled without a VALIDATOR being specified, this VALIDATOR
is used.

_SYNOPSIS_
<!-- - -->

    getargs_validate_option_value <TARGET> <OPTION> <TYPE> <VALUE>

_ARGUMENTS_
<!-- -- -->

`TARGET` \[in]

- The **name** of the target variable specified in the
  OPTION-CONFIG or OPERAND-CONFIG for the OPTION.

`OPTION` \[in]

- The OPTION as it was matched.
- For an OPERAND this is either null (an empty string),
  `-` or `--`.

`TYPE` \[in]

- The type of `VALUE`.
- One of the `BS_LIBGETARGS_TYPE_*` constants:
  [`BS_LIBGETARGS_TYPE_OPT_ARG`](#bs_libgetargs_type_opt_arg),
  [`BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED`](#bs_libgetargs_type_opt_arg_delimited),
  [`BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE`](#bs_libgetargs_type_opt_arg_aggregate),
  or [`BS_LIBGETARGS_TYPE_OPERAND`](#bs_libgetargs_type_operand).

`VALUE` \[in]

- The value to check.
- MAY be null (i.e. the empty string).

_NOTES_
<!-- -->

- When `TYPE` is [`BS_LIBGETARGS_TYPE_OPERAND`](#bs_libgetargs_type_operand),
  `OPTION` is used to indicate how the OPERAND was matched:
  - `--`: the OPERAND was preceded by the `--` argument (so is an
    explicit OPERAND)
  - null/empty: an interleaved/mixed OPERAND (see
    [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands))
  - `-`: an unmatched OPTION (see
    [`BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`](#bs_libgetargs_config_allow_unmatched)),
    in this case, `VALUE` _may_ be an OPTION.
- Provided as an example VALIDATOR, not likely to be generally useful,
  although it can detect some potential errors where an OPTION-ARGUMENT
  has been omitted.
- When validation is enabled, this is invoked for all OPTIONs that have an
  OPTION-ARGUMENT and for all OPERANDs.
- A VALIDATOR can NOT change the value, although it is possible to edit the
  contents of `TARGET` this is NOT supported and in most cases any changes
  will be lost.
- Any output written by a VALIDATOR to `STDOUT` is redirected to `STDERR`
  and is NOT affected by configuration that affects other `getargs` errors.
- An "invalid value" error will be generated by `getargs` for any value that
  fails validation, this will appear _after_ any output generated by the
  VALIDATOR.
- For this VALIDATOR the warning generated can NOT be suppressed (i.e. output
  is always generated if an issue is found).

---------------------------------------------------------

### `getargs_operands_to_options`

Helper to convert OPERANDs in OPTIONs with a given option name.

Intended for use when OPERANDs need to be used with a command that does
not support OPERANDs. Each OPERAND becomes an OPTION-ARGUMENT for the
given OPTION (this requires the command allows specifying a specific OPTION
multiple times).

_SYNOPSIS_
<!-- - -->

    getargs_operands_to_options <VALUES> <OPTION>

_ARGUMENTS_
<!-- -- -->

`VALUES` \[in/out:ref]

- An emulated array containing the values to be converted.
- Receives generated OPTIONs as an emulated array.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty array.

`OPTION` \[in]

- The OPTION-NAME to use for each element in `VALUES`.
- Each element in `VALUES` will become and
  OPTION-ARGUMENT for `OPTION`.
- A trailing `=` (`<equals>`) will cause the
  OPTION-ARGUMENT to be made an AGGREGATE-OPTION-ARGUMENT.

_NOTES_
<!-- -->

- A command that accepts OPERANDs often uses these to invoke additional
  commands. However, it's not always easy/possible/desirable to pass OPERANDs
  directly to the invoked commands - where this is the case, passing OPERANDs
  as multiple OPTIONs with OPTION-ARGUMENTs may be required.
- Although intended for OPERANDs, can be used for any values; simple turns
  all elements in `VALUES` into OPTION-ARGUMENTs for the given `OPTION`.
- For AGGREGATE-OPTION-ARGUMENTs the number of elements in the output will
  be the same as the input, otherwise there will be twice the number of
  output elements.
- Since the same OPTION is used for **all** parameters, this must be
  supported by the command for which the output is intended. In `getargs`
  terminology, this means the OPTION needs to have the type `[+]` (i.e. be a
  _multi_ OPTION-ARGUMENT) OPTION.
- For commands that support `getargs` this is not required as an array of
  values can be used directly with `[+]` type OPTIONs by using an
  OPTION-TAG.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## STANDARDS

- [_POSIX.1-2008_][posix].
- [FreeBSD SYSEXITS(3)][sysexits].
- [Semantic Versioning v2.0.0][semver].
- [Inclusive Naming Initiative][inclusivenaming].

_For more details see the common suite [documentation](./README.MD#standards)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## NOTES

<!-- ------------------------------------------------ -->

### TERMINOLOGY

Terminology used for `getargs` is based on the
[_POSIX.1_ "Utility Conventions"][posix_utility_conventions].

_POSIX.1 Terms_
<!-- ------ -->

- `ARGUMENT`
  - a value passed to a command when invoked
  - assigned to shell positional parameters
  - every `ARGUMENT` is either an `OPTION`, an `OPTION-ARGUMENT`
    or an `OPERAND`
- `OPTION`
  - an `ARGUMENT` starts with `-` (`<hyphen>`) character
  - any `OPTION` may be associated with an `OPTION-ARGUMENT`
- `OPTION-ARGUMENT`
  - a value given to a specific `OPTION`
  - specified either as the subsequent `ARGUMENT`, or as part of the same
    `ARGUMENT` as the associated `OPTION`
  - an optional `OPTION-ARGUMENT` can only be specified as part of the same
    string as the `OPTION`
- `OPERAND`[^positional_argument]
  - an `ARGUMENT` that is not an `OPTION` or an `OPTION-ARGUMENT`

[^positional_argument]: An `OPERAND` is the `ARGUMENT` type most frequently
                        referred to with

_Additional Terms_
<!-- --------- -->

- `OPTION-NAME` _or_ `NAME`
  - the characters excluding the `-` (`<hyphen>`) prefix
  - _uniquely_ defines an `OPTION` for a given command
  - if multiple `OPTION-NAME`s are provided for a single `OPTION`, each is
    an `OPTION-ALIAS` (_or_ `ALIAS`) for that `OPTION`
- `SHORT-OPTION` _or_ `SHORT`
  - an `OPTION` where the `OPTION-NAME` is a single character
  - always specified with a single leading `-` (`<hyphen>`)
- `COMPOUND-OPTION` _or_ `COMPOUND`
  - multiple `SHORT-OPTION`s specified as a single `OPTION` following a
    single leading `-` (`<hyphen>`)
  - only the last `SHORT-OPTION` in `COMPOUND-OPTION` can have an
    `OPTION-ARGUMENT`
- `LONG-OPTION` _or_ `LONG`
  - an `OPTION` where the `OPTION-NAME` is a two or more characters
  - may be specified using the prefix `-` (`<hyphen>`) or
    `--` (`<hyphen><hyphen>`)
- `POSIX-LONG-OPTION` _or_ `POSIX-LONG`
  - a `LONG-OPTION` with the prefix `-` (`<hyphen>`)
- `GNU-LONG-OPTION` _or_ `GNU-LONG`
  - a `LONG-OPTION` with the prefix `--` (`<hyphen><hyphen>`)
- `ABBREVIATED-LONG-OPTION` _or_ `ABBREVIATED-OPTION`
  - a `LONG-OPTION` that only matches as a prefix of a `OPTION-NAME`
  - has a minimum length of 2 characters
- `SWITCH-OPTION` _or_ `SWITCH`
  - an `OPTION` which has no `OPTION-ARGUMENT`
- `OPTION-TAG` _or_ `TAG`
  - a suffix appended to an `OPTION` following a `:` (`<colon>`) character
  - modifies how the `OPTION` is processed
- `AGGREGATE-OPTION-ARGUMENT` _or_ `AGGREGATE-ARGUMENT`
  - an `OPTION-ARGUMENT` specified as part of the same `ARGUMENT` as the
    `OPTION` itself
  - delimited from an `OPTION` using `=` (`<equals>`) (optional for
    `SHORT-OPTION`s and `COMPOUND-OPTION`s)

For each `OPTION` an `OPTION-ARGUMENT` is either:

- _prohibited_
  - the `OPTION` is a `SWITCH-OPTION`
- _optional_
  - an `OPTION-ARGUMENT` MAY be specified
  - `OPTION-ARGUMENT` MUST be specified in the same `ARGUMENT` as the
    `OPTION` (a `LONG-OPTION` with an `OPTION-ARGUMENT` MUST delimit the
    `OPTION` from the `OPTION-ARGUMENT` using an `=` (`<equals>`) character)
- _required_
  - an `OPTION-ARGUMENT` is REQUIRED
  - it is an error to specify the `OPTION` more than once
- _resettable_
  - an `OPTION-ARGUMENT` is REQUIRED
  - The `OPTION` can be specified multiple times
  - only the last specified `OPTION-ARGUMENT` is used
- _multi_
  - an `OPTION-ARGUMENT` is REQUIRED
  - the `OPTION` can be specified multiple times, and _all_
    `OPTION-ARGUMENT`s are used

A `SWITCH-OPTION` is either:

- _simple_
  - MUST be specified at most once
- _incrementing_
  - MAY be specified multiple times
  - each occurrence increments the currently stored value for the `OPTION`
  - MAY be specified with a _numerical_ `OPTION-TAG` which sets the
    currently stored value for the `OPTION`
- _negatable_
  - MAY be specified multiple times
  - is either `<unset>`, `true`, or `false`
  - MAY be specified with a `OPTION-TAG` of either `true` or `false` which
    sets the currently stored value for the `OPTION`
  - if no `OPTION-TAG` is specified, value is set to `true`

_Notes_
<!-- -->

- As the `GNU-LONG-OPTION` format is that which is most widely used it is
  sometimes referred to as simply `LONG-OPTION`, while a `POSIX-LONG-OPTION`
  is always explicitly named as such (when such a distinction matters).
- A _simple_ `SWITCH-OPTION` is _NOT_ directly supported by `getargs` but
  can be emulated using the other types of `SWITCH-OPTION`.
- An `OPERAND` is the `ARGUMENT` type most frequently referred to with an
  alternate name with the terms `POSITIONAL-ARGUMENT` or `PARAMETER`
  frequently used (among others). The term `POSITIONAL-ARGUMENT` or simply
  `POSITIONAL` is used occasionally in this documentation (and related code),
  for example, the `--positional` OPTION (alias for `--operands`). In all
  cases this is synonymous with `OPERAND`.

_Example Arguments_
<!-- ---------- -->

     command [-a] [-b] [-c value] [-debug] [--verbose|-v] [-user|-u[value]] [value...]

     command -deb:false --verbose:1 -abc FIRST -uSECOND --password=THIRD FOURTH

- `-a`,`-b`,`-c`,`-v`, and `-u` are `SHORT-OPTION`s
- `-debug` is a `POSIX-LONG-OPTION`
- `--verbose` is a `GNU-LONG-OPTION`
- `FIRST`, `SECOND`, and `THIRD` are `OPTION-ARGUMENT`s
- `FOURTH` is an `OPERAND`
- `-a`,`-b`,`-debug`,`--verbose|-v`, and `-u` are `SWITCH-OPTION`s
- `-abc` is a `COMPOUND-OPTION`
- `SECOND` and `THIRD` are `AGGREGATE-OPTION-ARGUMENT`s
- `SECOND` is an _optional_ `OPTION-ARGUMENT`
- `-deb` is an `ABBREVIATED-LONG-OPTION`
- `false` and `1` are `OPTION-TAG`s
- `-deb:false` is a _negatable_ `SWITCH-OPTION`
- `--verbose:1` is an _incrementing_ `SWITCH-OPTION`
- `--verbose:1` is equivalent to `--verbose` and `-deb:true` is equivalent to
  `-deb`

<!-- ------------------------------------------------ -->

### GENERAL

- The first ARGUMENT with the value `--` is a special ARGUMENT that acts as
  a delimiter marking the end of OPTIONs; any following ARGUMENTs are
  considered OPERANDs. It is highly recommended that this is used where
  possible - albeit rare, omitting this can lead to difficult to diagnose
  errors in some use cases.
- Much of this library is only supported in certain circumstances, for
  example when the `POSIX` locale is used; note that "unsupported" does not
  imply that such usage will not work, however unexpected behavior may occur
  and any bugs encountered are unlikely to be addressed.
- `getargs` supports all the functionality of `getopts` and `getopt`
- The [`util-linux`][util_linux] specified `getopt` is one of a number of
  commands with the same name and similar usage, however other versions seem
  much less capable (many of which are implementations of the precursor to
  standard specified `getopts`).

<!-- ------------------------------------------------ -->

### PERFORMANCE

Performance of `getargs` is always likely to be lower than that of `getopt`
or `getopts` as these utilities provide less functionality and are invoked
as binaries. However, when used to process arguments for an entire script,
performance is unlikely to be an issue.

When using `getargs` for individual script functions it is possible that
performance MAY become an issue through accumulated costs (although it is
still likely to be far outweighed by other costs).

In cases where performance of `getargs` becomes an issue it is possible to
improve performance with careful usage. The largest gains can be made by
changing the shell being used: for example, while `bash` is a highly
competent shell with a many useful extensions, the less well equipped `dash`
is significantly faster for use with `getargs`. Similarly the specific
implementation of utilities like `sed`, or `grep` used can have a measurable
impact.

The configuration of `getargs` can also make a difference. The biggest single
change is to allow ambiguous options, which will use `expr` (or rarely `sed`)
rather than `grep`, resulting in improved performance. Disabling other
options where they are noted to have a performance impact will also help
(though to a lesser extent). Additionally, setting config using the provided
[environment variables](#environment) rather than passing as options to
`getargs` options, can make minor improvements.

_For more details see the common suite [documentation](./README.MD#performance)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## CAVEATS

The environment in which the library is invoked will dictate limitations
for the library that can not be avoided. In particular, the command line
length limit will impose restrictions on the length of a single invocation
of `getargs`, though other limitations may also be problematic.

Importantly, the command line length limit imposes a limit on the combined
length of _both_ the SPECIFICATION _and_ the ARGUMENTs to process, and may
be a particular issue where [AUTO-HELP](#auto-help) is used.

_For more details see the common suite [documentation](./README.MD#caveats)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## EXAMPLE

Additional examples can be found in the test files for the library.

---------------------------------------------------------

A `chmod` like utility providing additional options:

    #!/bin/sh

    . libgetargs.sh

    getargs --unset              --auto-help                                            \
            -i "${0}"                                                                   \
            -o 'm|mode[:]opt_Mode#The mode to set for all paths.'                       \
            -o 'p|path[+]opt_aPaths#One or more paths to edit.'                         \
            -o 'R|recursive[-]opt_Recurse#Recurse into any directories.'                \
            -o 'L|traverse-links[-]opt_TraverseLinks#Evaluate any links encountered'    \
            -o 'single-device[-]opt_SingleDevice#Process only paths on a single device' \
            -o '1|one-device|xdev[-]opt_SingleDevice'                                   \
            -p '[^]opt_Mode,[+]opt_aPaths'                                              \
            -- "$@" || exit

    eval "set -- ${opt_aPaths+${opt_aPaths}}"

    case ${opt_Recurse:+R} in
    R) find ${opt_TraverseLinks+-L}       \
            "$@"                          \
            ${opt_SingleDevice+-xdev}     \
            -exec                         \
              'chmod'                     \
                ${opt_Mode+"${opt_Mode}"} \
                '{}' '+'
       ;;

    *) 'chmod' ${opt_Mode+"${opt_Mode}"} "$@" ;;
    esac

### COMPARISON

The following example is adapted from
[the Wikipedia page for `getopts`](<https://wikipedia.org/wiki/Getopts#Examples>)
and is implemented for `getopts`, `getopt` and `getargs`
to provide a comparison between the available tools.

---------------------------------------------------------

**`getopts`**
<!-- ---- -->

    #!/bin/bash
    VERBOSE=0
    ARTICLE=''
    LANG=en

    while getopts ':a:l:v' opt; do
        case $opt in
          (v)   ((VERBOSE++));;
          (a)   ARTICLE=$OPTARG;;
          (l)   LANG=$OPTARG;;
          (:)   # "optional arguments" (missing option-argument handling)
                case $OPTARG in
                  (a) exit 1;; # error, according to our syntax
                  (l) :;;      # acceptable but does nothing
                esac;;
        esac
    done

    shift "$OPTIND"
    # remaining is "$@"

    if ((VERBOSE > 2)); then
      printf '%s\n' 'Non-option arguments:'
      printf '%q ' "${remaining[@]]}"
    fi

    if ((VERBOSE > 1)); then
      printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
    fi

    if [[ ! $ARTICLE ]]; then
      printf '%s\n' "No articles!">&2
      exit 1
    fi

    save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"

---------------------------------------------------------

**`getopt`**
<!-- --- -->

    #!/bin/bash
    VERBOSE=0
    ARTICLE=''
    LANG=en

    ARGS=$(getopt -o 'a:l::v' --long 'article:,language::,lang::,verbose' -- "$@") || exit
    eval "set -- $ARGS"

    while true; do
        case $1 in
          (-v|--verbose)
                ((VERBOSE++)); shift;;
          (-a|--article)
                ARTICLE=$2; shift 2;;
          (-l|--lang|--language)
                # handle optional: getopt normalizes it into an empty string
                if [ -n "$2" ]; then
                  LANG=$2
                fi
                shift 2;;
          (--)  shift; break;;
          (*)   exit 1;;           # error
        esac
    done
    remaining=("$@")

    if ((VERBOSE > 2)); then
      printf '%s\n' 'Non-option arguments:'
      printf '%q ' "${remaining[@]]}"
    fi

    if ((VERBOSE > 1)); then
      printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
    fi

    if [[ ! $ARTICLE ]]; then
      printf '%s\n' "No articles!">&2
      exit 1
    fi

    save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"
    </pre>

---------------------------------------------------------

**`getargs`**
<!-- ---- -->

    #!/bin/sh

    . libgetargs.sh

    getargs --unset                     \
            -o 'verbose|v[:]VERBOSE'    \
            -o 'article|a[:]ARTICLE'    \
            -o 'language|lang|l[?]LANG' \
            -p '[+]REMAINING'           \
            -- "$@"                     || exit
    eval "set -- ${REMAINING+${REMAINING}}"
    - "${VERBOSE:=0}"
    - "${LANG:=en}"

    if ((VERBOSE > 2)); then
       printf '%s\n' 'Non-option arguments:'
       printf '%q ' "$@"
    fi

    if ((VERBOSE > 1)); then
       printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
    fi

    if [[ ! $ARTICLE ]]; then
       printf '%s\n' "No articles!" \>&2
       exit 1
    fi

    save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"

---------------------------------------------------------

**`getarg`**
<!-- --- -->

    #!/bin/sh

    MyArgs="$(
       getarg --unset                   \
            -o 'verbose|v[:]VERBOSE'    \
            -o 'article|a[:]ARTICLE'    \
            -o 'language|lang|l[?]LANG' \
            -p '[+]REMAINING'           \
            -- "$@"
    )" || exit
    eval "${MyArgs}"
    eval "set -- ${REMAINING+${REMAINING}}"
    - "${VERBOSE:=0}"
    - "${LANG:=en}"

    if ((VERBOSE > 2)); then
       printf '%s\n' 'Non-option arguments:'
       printf '%q ' "$@"
    fi

    if ((VERBOSE > 1)); then
       printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
    fi

    if [[ ! $ARTICLE ]]; then
       printf '%s\n' "No articles!" \>&2
       exit 1
    fi

    save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"

<!-- -------------------------------------------------------------------- -->
<!-- REFERENCES -->
<!-- -------------------------------------------------------------------- -->

[markdown]:                  <https://daringfireball.net/projects/markdown/syntax>                                                "Markdown: Syntax [daringfireball.net]"
[commonmark]:                <https://commonmark.org/>                                                                            "CommonMark [spec.commonmark.org]"
[commonmark_spec]:           <https://spec.commonmark.org/current/>                                                               "CommonMark Spec (current) [spec.commonmark.org]"

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

