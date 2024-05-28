#!/usr/bin/env false
# SPDX-License-Identifier: MPL-2.0
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libgetargs': Advanced argument processing for POSIX.1       *#
#*                             compliant shells.                              *#
#*                                                                            *#
#* Copyright (c) 2022 BetterScripts ( better.scripts@proton.me,               *#
#*                                    https://github.com/BetterScripts )      *#
#*                                                                            *#
#* This file is part of the BetterScripts POSIX Suite.                        *#
#*                                                                            *#
#* This Source Code Form is subject to the terms of the Mozilla Public        *#
#* License, v. 2.0. If a copy of the MPL was not distributed with this        *#
#* file, You can obtain one at https://mozilla.org/MPL/2.0/.                  *#
#*                                                                            *#
#* -------------------------------------------------------------------------- *#
#*                                                                            *#
#* ADDENDUM:                                                                  *#
#*                                                                            *#
#* In addition to the Mozilla Public License a copy of LICENSE.MD should have *#
#* been be provided alongside this file; LICENSE.MD clarifies how the Mozilla *#
#* Public License v2.0 applies to this file and MAY confer additional rights. *#
#*                                                                            *#
#* Should there be any apparent ambiguity (implied or otherwise) the terms    *#
#* and conditions from the Mozilla Public License v2.0 shall apply.           *#
#*                                                                            *#
#* If a copy of LICENSE.MD was not provided it can be obtained from           *#
#* https://github.com/BetterScripts/posix/LICENSE.MD.                         *#
#*                                                                            *#
#* NOTE:                                                                      *#
#*                                                                            *#
#* The Mozilla Public License v2.0 is compatible with the GNU General Public  *#
#* License v2.0.                                                              *#
#*                                                                            *#
#******************************************************************************#
################################################################################

################################# LIBGETARGS ###################################
#
# Documentation is written inline formatted as [`Markdown`][markdown], this is
# in addition to the suite wide documentation which includes details common to
# multiple suite libraries that may not be detailed here.
#
# The included `Makefile` can be used to generate standalone documentation in
# various formats with various verbosity settings. The `Makefile` can also be
# used to install scripts and documentation in appropriate locations.
#
# As far as possible, terminology and conventions follow those of the
# [_POSIX.1-2008_ Standard][posix_2008].
#
#===============================================================================
## cSpell:Ignore libgetargs getargs getarg
################################ DOCUMENTATION #################################
#
#% % libgetargs(7) BetterScripts | Argument processing for POSIX.1 shell scripts.
#% % BetterScripts (better.scripts@proton.me)
#
#: <!-- #################################################################### -->
#: <!-- ########### THIS FILE WAS GENERATED FROM 'libgetargs.sh' ########### -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # LIBGETARGS
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## SYNOPSIS
#:
#:     . libgetargs.sh
#:     ...
#:     getargs <SPECIFICATION>... [--] <ARGUMENT>...
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## DESCRIPTION
#:
#: Command argument processing for scripts and script functions.
#:
#: Parses all ARGUMENTs according to the configuration specified with
#: SPECIFICATION.
#:
#: While generally similar in functionality to the _POSIX.1_ specified utility
#: [`getopts`][posix_getopts] or the `getopt` utility from
#: [`util-linux`][util_linux], `getargs` provides greater functionality while
#: also requiring less code and being compatible with any _POSIX.1_ compliant
#: environment.
#:
#: Discussion of anything to do with command arguments is challenging as the
#: different people understand the same terms differently with some terms
#: used interchangeably depending on the situation, or with different meanings
#: in other contexts. Terminology used here is based on the
#: [_POSIX.1_ "Utility Conventions"][posix_utility_conventions], with
#: appropriate extensions where necessary. A brief summary of key terms can be
#: found in [NOTES](#notes).
#:
#: The utility [`getarg`](./getarg.md) is a wrapper for `libgetargs.sh` which
#: provides the functionality of the library as a directly invocable command
#: (i.e. one that does not require the library be imported prior to use).
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## OPTIONS
#:
#: _MAIN OPTIONS_
#: <!-- ----- -->
#:
#: `-o <CONFIG>`, `--options <CONFIG>`
#:
#: : **Required.**
#: : `<CONFIG>` describes how OPTIONs are processed.
#: : MAY be specified multiple times.
#: : For more details see [OPTION-CONFIG](#option-config).
#:
#: `-p <CONFIG>`, `--positional <CONFIG>`, `--operands <CONFIG>`
#:
#: : `<CONFIG>` describes how OPERANDs are processed.
#: : MAY be specified multiple times.
#: : For more details see [OPERAND-CONFIG](#operand-config).
#:
#: _MODE OPTIONS_
#: <!-- ----- -->
#:
#: `--auto-help[=<VARIABLE>]`
#:
#: : Automatically process a `--help` or `-h` `<ARGUMENT>`.
#: : If `--help` or `-h` is encountered, help text is generated from
#:   `<SPECIFICATION>` and either stored in `<VARIABLE>` (if it was provided) or
#:   written to `STDOUT` (if it was not), processing then stops and an exit
#:   status of `1` (`<one>`) is set.
#: : For more details see [AUTO-HELP](#auto-help).
#:
#: `--script[=<VARIABLE>]`
#:
#: : Generate a script suitable for use with `eval` which will set the variables
#:   from  `<SPECIFICATION>` as would be set by `getargs` when given the same
#:   input, the resulting script is either stored in `<VARIABLE>` (if it was
#:   provided) or written to `STDOUT` (if it was not).
#: : For more details see [SCRIPT](#script).
#:
#: `--validate[=<VALIDATOR>]`,   `-v[[=]<VALIDATOR>]`
#:
#: : Use `<VALIDATOR>` as a command to validate all OPTION-ARGUMENTs and
#:   OPERANDs.
#: : An error occurs if `<VALIDATOR>` has a non-zero exit status.
#: : If `<VALIDATOR>` is not specified uses
#:   [`getargs_validate_option_value`](#getargs_validate_option_value).
#: : For more details see [VALIDATOR](#validator).
#:
#: _OTHER OPTIONS_
#: <!-- ------ -->
#:
#: `--name <ID>`, `-n[=]<ID>`, `--id <ID>`, `-i[=]<ID>`
#:
#: : Set an `<ID>` to use for error messages and with [auto-help](#auto-help),
#:   if not specified a default of `getargs` or `<command>` is used
#:   respectively.
#: : Does not effect if the value stored in
#:   [`BS_LIBGETARGS_LAST_ERROR`](#bs_libgetargs_last_error).
#:
#: `--version`,  `-V`
#:
#: : Write the library version number to `STDOUT` and exit.
#:
#: `--help`,  `-h`
#:
#: : Display help text and exit.
#: : **Only available with `getarg`.**
#:
#: _PREFERENCE OPTIONS_
#: <!-- ----------- -->
#:
#: Preferences can be set by OPTION or by [environment variables](#environment),
#: (OPTIONs take precedence). Defaults for each option are highlighted, and the
#: associated variable is noted - more detailed information for each preference
#: can be found with these variables.
#:
#: `--[no-]abbreviations`
#:
#: : \[Enable]/Disable allowing LONG-OPTIONs to be abbreviated.
#: : Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_ABBREVIATIONS`](#bs_libgetargs_config_allow_abbreviations).
#:
#: `--[no-]ambiguous`
#:
#: : \[Enable]/Disable detection of ambiguous OPTIONs.
#: : Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_AMBIGUOUS`](#bs_libgetargs_config_allow_ambiguous)
#:
#: `--[no-]check-config`
#:
#: : Enable/\[Disable] performing basic checks on OPTION-CONFIG and
#:   OPERAND-CONFIG before processing.
#: : Overrides [`BS_LIBGETARGS_CONFIG_CHECK_CONFIG`](#bs_libgetargs_config_check_config)
#:
#: `--[no-]fatal[-errors]`
#:
#: : Enable/\[Disable] causing library errors to terminate the current
#:   (sub-)shell.
#: : Overrides [`BS_LIBGETARGS_CONFIG_FATAL_ERRORS`](#bs_libgetargs_config_fatal_errors)
#:
#: `--[no-]interleaved`, `--[no-]mixed`
#:
#: : Enable/\[Disable] matching OPTIONs after the first OPERAND is matched.
#: : Overrides [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands).
#: : Can not be used with `--strict`.
#:
#: `--[no-]posix-long`
#:
#: : Enable/\[Disable] matching LONG-OPTIONs with a single preceding `-`
#:   (`<hyphen>`) character instead of the normally required two.
#: : Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_POSIX_LONG`](#bs_libgetargs_config_allow_posix_long)
#:
#: `--[no-]quiet[-error]`
#:
#: : \[Enable]/Disable error message output.
#: : Overrides [`BS_LIBGETARGS_CONFIG_QUIET_ERRORS`](#bs_libgetargs_config_quiet_errors)
#:
#: `--[no-]strict`
#:
#: : Enable/\[Disable] requiring the use of `--` (`<hyphen><hyphen>`) to separate
#:   OPTIONs from OPERANDs.
#: : Overrides [`BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`](#bs_libgetargs_config_strict_operands).
#: : Can not be used with `--interleaved` or `--unmatched`
#:
#: `--[no-]unsafe`
#:
#: : \[Enable]/Disable escaping OPTIONs to avoid any erroneous results when
#:   matching with regular expressions.
#: : Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_UNSAFE_OPTIONS`](#bs_libgetargs_config_allow_unsafe_options)
#:
#: `--[no-]unset`
#:
#: : Enable/\[Disable] automatic unsetting of all variables named in
#:   OPTION-CONFIG and OPERAND-CONFIG.
#: : Overrides [`BS_LIBGETARGS_CONFIG_AUTO_UNSET`](#bs_libgetargs_config_auto_unset)
#:
#: `--[no-]unmatched`
#:
#: : Enable/\[Disable] matching an unrecognized OPTION as an OPERAND.
#: : Overrides [`BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`](#bs_libgetargs_config_allow_unmatched).
#: : Implies `--interleaved`.
#: : Can not be used with `--strict`.
#:
#: _NOTES_
#: <!-- -->
#:
#: Functionality can be invoked either by importing the `libgetargs` _or_ via
#: the standalone wrapper script `getarg`. When invoked as `getarg`:
#:
#: - `--script` is implied (and can not be specified again).
#: - `--[no-]fatal[-errors]` is permitted, but is not useful.
#: - `--auto-help` works as intended, but the output can not be stored in a
#:    variable[^getarg-auto-help].
#:
#: [^getarg-auto-help]: Technically this is incorrect, the output from
#:                      `--auto-help` _can_ be stored in a variable, however
#:                      this value will be lost when the sub-shell where
#:                      `getarg` was invoked exits.
#:
#: ### OPTION-CONFIG
#:
#:     <ALPHA>          = ? characters from the LC_CTYPE 'alpha' class ? ;
#:     <ALNUM>          = ? characters from the LC_CTYPE 'alnum' class ? ;
#:     <GRAPH>          = ? characters from the LC_CTYPE 'graph' class ? ;
#:     <NEWLINE>        = "\n"
#:     <WHITESPACE>     = " " | "\t"
#:
#:     <NAME>           = <ALNUM>, { <ALNUM> | "_" | "-" } ;
#:     <TYPE>           = "-" | "~" | "?" | ":" | ";" | "+" ;
#:     <VARIABLE>       = <ALPHA>, { <ALNUM> | "_" } ;
#:     <OPTIONS>        = <NAME> { "|" <NAME> } "[" <TYPE> "]" <VARIABLE>,
#:                        { "," <OPTIONS> } ;
#:
#:     <HELP>           = ( <GRAPH> | <WHITESPACE> ), { <HELP> }
#:     <HELP-TEXT>      = { "#" <HELP> }
#:                        { <NEWLINE>, { <WHITESPACE> }, "#" <HELP> } ;
#:
#:     <OPERAND-CONFIG> = <OPTIONS>, [ <HELP-TEXT> ] ;
#:
#: OPTION-CONFIG as specified with the the OPTION `--options`, or `-o`, uses the
#: above syntax. The following rules then apply:
#:
#: - if multiple OPTION-CONFIGs are specified, they are concatenated into a
#:   single OPTION-CONFIG
#: - each `<NAME>` defines an OPTION-NAME
#: - each `<VARIABLE>` specifies a shell variable
#: - each **unique** `<VARIABLE>` defines a _single_ OPTION
#: - every `<NAME>` associated with a `<VARIABLE>` defines an OPTION-ALIAS
#:   - a `<VARIABLE>` specified in multiple OPTION-CONFIGs implies a _single_
#:     OPTION that matches _all_ the specified OPTION-ALIASes
#: - an OPTION-ALIAS that is a single character defines a SHORT-OPTION-ALIAS
#: - an OPTION-ALIAS that is two or more characters defines a LONG-OPTION-ALIAS
#: - the `<TYPE>` describes how an OPTION is processed:
#:   - **`[-]`**
#:     - OPTION:
#:       - _incrementing SWITCH-OPTION_
#:       - _MAY be specified multiple times_
#:     - OPTION-ARGUMENT:
#:       - _prohibited_
#:     - OPTION-TAG:
#:       - _a positive whole number_
#:     - `<VARIABLE>`:
#:       - receives the value of any OPTION-TAG, otherwise
#:         is incremented every time `OPTION` is specified
#:       - when no OPTION-TAG is used, `<VARIABLE>` holds a value
#:         indicating how many times the OPTION was specified
#:   - **`[~]`**
#:     - OPTION:
#:       - _negatable SWITCH-OPTION_
#:       - _MAY be specified multiple times_
#:     - OPTION-ARGUMENT:
#:       - _prohibited_
#:     - OPTION-TAG:
#:       - _value of_
#:         _[`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)_
#:         _or_
#:         _[`BS_LIBGETARGS_CONFIG_FALSE_VALUE`](#bs_libgetargs_config_false_value)_
#:     - `<VARIABLE>`:
#:       - receives the value of any OPTION-TAG, otherwise the value of
#:         [`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)
#:   - **`[?]`**
#:     - OPTION:
#:       - _MUST be specified at most once_
#:     - OPTION-ARGUMENT:
#:       - _optional_
#:       - _MUST be an AGGREGATE-OPTION-ARGUMENT_
#:     - OPTION-TAG:
#:       - _prohibited_
#:     - `<VARIABLE>`:
#:       - receives the value of any OPTION-ARGUMENT, or the value of
#:         [`BS_LIBGETARGS_CONFIG_OPTIONAL_VALUE`](#bs_libgetargs_config_optional_value)
#:         if no OPTION-ARGUMENT was specified
#:   - **`[:]`**
#:     - OPTION:
#:       - _MUST be specified at most once_
#:     - OPTION-ARGUMENT:
#:       - _required_
#:     - OPTION-TAG:
#:       - _prohibited_
#:     - `<VARIABLE>`:
#:       - receives the value of the OPTION-ARGUMENT
#:   - **`[;]`**
#:     - OPTION:
#:       - _MAY be specified multiple times_
#:     - OPTION-ARGUMENT:
#:       - _required_
#:     - OPTION-TAG:
#:       - _prohibited_
#:     - `<VARIABLE>`:
#:       - receives the value of the _last_ OPTION-ARGUMENT specified
#:       - any previously specified OPTION-ARGUMENTs are discarded
#:   - **`[+]`**
#:     - OPTION:
#:       - _MAY be specified multiple times_
#:     - OPTION-ARGUMENT:
#:       - _required_
#:     - OPTION-TAG:
#:       - _one of the values `array`, `passthrough`, `passthru`, or `forward`_
#:     - `<VARIABLE>`:
#:       - receives the value of the all OPTION-ARGUMENT as an emulated array
#:       - if one of the permitted OPTION-TAGs is specified, OPTION-ARGUMENT
#:         is an emulated array the _contents_ of which are appended
#: - `<HELP-TEXT>` can follow any OPTION-CONFIG:
#:   - any text here is used to annotate options for auto-help, if enabled, or
#:     as comments otherwise
#:   - `<HELP-TEXT>` is always associated with a _single_ `<VARIABLE>`
#:   - for more details see [auto-help](#auto-help)
#:
#: _NOTES_
#: <!-- -->
#:
#: - OPTION-TAGs are designed to facilitate commands where OPTIONs are used
#:   to invoke other commands without further processing, allowing them to be
#:   "forwarded" safely and efficiently
#: - Any number of OPTION-ALIASes can be specified for a single OPTION
#:   - only a LONG-OPTION-ALIAS can:
#:     - be abbreviated (to a minimum of 2 characters)
#:   - only a SHORT-OPTION-ALIAS can:
#:     - be part of a COMPOUND-OPTION
#:     - use an AGGREGATE-ARGUMENT without a delimiter
#: - Every OPTION processed MUST match an OPTION-ALIAS
#: - Ambiguous OPTIONs are either an error, or _always_ use
#:   the first matched OPTION-CONFIG from SPECIFICATION
#: - A `<VARIABLE>` can be set prior to invoking `getargs`, any such value is
#:   ignored and does not affect the process of any `<TYPE>` (this allows
#:   a default value to be specified)
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#: Example OPTION-CONFIGs and _some_ of the OPTION formats supported:
#:
#: - `"d|debug[~]DebugEnabled,q|quite|s|silent[-]QuiteMode"`
#:   - `-d`, `--debug`, `--deb`, or `-d:true` set `DebugEnabled` to `true`
#:   - `-d:false` sets `DebugEnabled` to `false`
#:   - `-q`, `-quite`, `-s`, or `-silent:1` set `QuiteMode` to `1`
#:   - `-q -q`, or `-s:2` set `QuiteMode` to `2`
#: - `"i|input-file|file|source|uri[+]InputFiles,o|output-file|target[;]OutputFile"`
#:   - `-iFILE`, `-i=FILE`, `-i FILE`, or `--file=FILE` set `InputFiles` to an
#:     emulated array with a single element: `FILE`
#:   - `--uri FIRST --URI SECOND` sets `InputFiles` to an emulated array with
#:     two elements: `FIRST`, `SECOND`
#:   - `-oFILE`, or `-o FILE` set `OutputFile` to `FILE`
#:   - `-oFILE1 -o FILE2` set `OutputFile` to `FILE2`
#: - `"i|input-file[:]InputFile#The file to be processed. Must exist!"`
#:   - Output from [auto-help](#auto-help) includes the text
#:     `The file to be processed. Must exist!`.
#:
#: ### OPERAND-CONFIG
#:
#:     <ALPHA>          = ? characters from the LC_CTYPE 'alpha' class ? ;
#:     <ALNUM>          = ? characters from the LC_CTYPE 'alnum' class ? ;
#:     <GRAPH>          = ? characters from the LC_CTYPE 'graph' class ? ;
#:     <NEWLINE>        = "\n"
#:     <WHITESPACE>     = " " | "\t"
#:
#:     <TYPE>           = ":" | ";" | "^" ;
#:     <VARIABLE>       = <ALPHA>, { <ALNUM> | "_" } ;
#:     <OPERANDS>       = "[" <TYPE> "]" <VARIABLE>, { "," <OPERANDS> } ;
#:
#:     <HELP>           = ( <GRAPH> | <WHITESPACE> ), { <HELP> }
#:     <HELP-TEXT>      = { "#" <HELP> }
#:                        { <NEWLINE>, { <WHITESPACE> }, "#" <HELP> } ;
#:
#:     <OPERAND-CONFIG> = <OPERANDS>,
#:                        [ "[+]" <VARIABLE> ],
#:                        [ <HELP-TEXT> ] ;
#:
#: OPERAND-CONFIG as specified with the the OPTION `--operands`, `--positional`
#: or `-p`, uses the above syntax. The following rules then apply:
#:
#: - if multiple OPERAND-CONFIGs are specified, they are concatenated into a
#:   single OPERAND-CONFIG
#: - each `<VARIABLE>` specifies a shell variable
#: - each single OPERAND-CONFIG consumes zero or one OPERANDs, EXCEPT the
#:   final OPERAND-CONFIG which MAY consume any number of OPERANDs
#: - the `<TYPE>` describes how an OPERAND is processed:
#:   - **`[:]`**
#:     - OPERAND:
#:       - ALWAYS consumes a single OPERAND
#:     - `<VARIABLE>`:
#:       - receives the value of the current OPERAND
#:       - MUST not have been set by any earlier OPTION/OPERAND
#:   - **`[;]`**
#:     - OPERAND:
#:       - ALWAYS consumes a single OPERAND
#:     - `<VARIABLE>`:
#:       - receives the value of the current OPERAND
#:       - any existing value is overwritten
#:   - **`[^]`**
#:     - OPERAND:
#:       - MAY consume a single OPERAND
#:     - `<VARIABLE>`:
#:       - if `<VARIABLE>` was set by a previous OPTION/OPERAND:
#:         - no modification is made to `<VARIABLE>`
#:         - this OPERAND-CONFIG is skipped
#:         - current OPERAND is retained for next OPERAND-CONFIG
#:       - if `<VARIABLE>` has not been set by a previous
#:         OPTION/OPERAND, behaves exactly like `[:]`
#:   - **`[+]`**
#:     - OPERAND:
#:       - ALWAYS consumes all remaining OPERANDs
#:     - `<VARIABLE>`:
#:       - has all remaining OPERANDs appended to any
#:         existing value as an emulated array
#: - `<HELP-TEXT>` can follow any OPERAND-CONFIG:
#:   - any text here is used to annotate options for auto-help, if enabled, or
#:     as comments otherwise
#:   - `<HELP-TEXT>` is always associated with a _single_ `<VARIABLE>`
#:   - for more details see [auto-help](#auto-help)
#:
#: _NOTES_
#: <!-- -->
#:
#: - A `<TYPE>` of `[:]`, `[;]`, or `[^]` is identical UNLESS `<VARIABLE>` was
#:   set by a previous OPTION/OPERAND
#: - If specified, a `<TYPE>` of `[+]` MUST be the last `<OPERAND-CONFIG>`
#: - A `<TYPE>` of `[^]` can be used to accept an ARGUMENT using an OPTION _or_
#:   an OPERAND by using the same `<VARIABLE>` for both an OPTION-CONFIG and
#:   the OPERAND-CONFIG
#: - OPERANDs are only permitted if there is an OPERAND-CONFIG,
#:   otherwise they are an error
#: - A `<VARIABLE>` can be set prior to invoking `getargs`, any such value is
#:   ignored and does not affect the process of any `<TYPE>` (this allows
#:   a default value to be specified)
#:
#: ### MODES
#:
#: "MODES" change the processing of `getargs` in a significant way.
#:
#: #### AUTO-HELP
#:
#:     --auto-help[=<VARIABLE>]
#:
#: Causes `getargs` to automatically process a `--help` or `-h` `<ARGUMENT>`.
#:
#: Help text is generated based on OPTION-CONFIG and OPERAND-CONFIG, with
#: information on how to specify values for ARGUMENTs based on their type.
#:
#: The generated text is stored in `<VARIABLE>`, if it was provided, otherwise
#: it is written to `STDOUT`. In either case, processing stops after the
#: text has been generated.
#:
#: An exit status of `1` indicates help text was generated - it should be
#: assumed that no ARGUMENTs have been processed.
#:
#: When enabled, the OPTIONs `--help` or `-h` will be matched by `getargs` and
#: will never match OPTION-CONFIG (although they may be present).
#:
#: There is no performance impact for enabling this option.
#:
#: _COMMAND NAME_
#: <!-- ----- -->
#:
#: If an `<ID>` has been specified (i.e. using `--name` option or aliases), it
#: will be used as the name of the command in the resulting text.
#:
#: `<HELP-TEXT>`
#: <!-- --- -->
#:
#: Additional information can be provided for any of the ARGUMENTs in the
#: resulting text via `<HELP-TEXT>`, which is arbitrary text that can be 
#: specified along with OPTION-CONFIG or OPERAND-CONFIG.
#:
#: `<HELP-TEXT>` is specified using a single `#` (`<number-sign>`) following the
#: OPTION or OPERAND for which the text applies and can contain any text.
#: Multiple lines of `<HELP-TEXT>` may be specified by inserting a `\n` 
#: (`<newline>`) character followed by any number of whitespace characters,
#: then a `#` (`<number-sign>`) and the continued `<HELP-TEXT>`. Note that only
#: continuation lines may contain whitespace prior to the `#` (`<number-sign>`),
#: the first `#` (`<number-sign>`) of any `<HELP-TEXT>` must be immediately
#: follow the VARIABLE to which the text applies.
#:
#: Formatting for `<HELP-TEXT>` will _not_ be retained:
#:
#:  - whitespace _after_ the `#` (`<number-sign>`) will be removed
#:  - after a `\n` (`<newline>`) any whitespace _before_ the `#` 
#:    (`<number-sign>`) will be removed
#:  - additional whitespace may be removed to facilitate text wrapping
#:
#: _CONFIGURATION_
#: <!-- ------- -->
#:
#: Several [environment variables](#environment) can alter the format of the
#: generated text, though the general format is fixed and is different to that
#: of common tools due to the difficulties with automatically formatting text.
#:
#: #### SCRIPT
#:
#:     --script[=<SCRIPT>]
#:
#: Causes `getargs` to generate a dynamic script suitable for use with `eval`
#: which recreates the externally visible side-effects of running `getargs`.
#:
#: The script generated in this mode sets the variables in OPTION-CONFIG and
#: OPERAND-CONFIG appropriately for the ARGUMENTs specified. Primarily this is
#: intended to allow `getargs` to be invoked in a sub-shell while allowing the
#: setting of variables to occur _outside_ the sub-shell.
#:
#: Generating the script _may_ have a performance impact, and occurs _after_
#: all other operations, and _only_ if there were no errors. If `<SCRIPT>` is
#: provided, the script is stored in that variable, otherwise it is written to
#: `STDOUT`.
#:
#: This mode is used to enable the functionality of the standalone tool
#: `getarg` which may be installed alongside the library and can be invoked
#: without requiring importing the library. For scripts that only use `getargs`
#: once it may make sense to use the standalone tool rather than import the
#: library, however, for scripts that use `getargs` more than once using the
#: library will be faster.
#:
#: #### VALIDATOR
#:
#:     --validate[=<VALIDATOR>]
#:
#: Validate values given as ARGUMENTs.
#:
#: This mode causes `<VALIDATOR>` to be invoked for all OPTION-ARGUMENTs and
#: OPERANDs, if the subsequent exit status is _not_ `0` (`<zero>`) then an error
#: is generated and processing stops.
#:
#: Although only a single VALIDATOR is available for any invocation of
#: `getargs`, when it is invoked, a VALIDATOR receives multiple pieces of
#: information, including the name of the variable in which the value is to be
#: stored - this should allow values to be validated based on the expected type.
#:
#: A VALIDATOR is most useful when a value is of a type that can easily be
#: tested for and is used repeatedly, for example ensuring filesystem paths are
#: valid, or that a value is numeric. More specific validation is better handled
#: elsewhere.
#:
#: A VALIDATOR can do any processing required to determine if the value it is
#: given is valid, however it can _not_ change the value.
#:
#: If `<VALIDATOR>` is not specified, [`getargs_validate_option_value`](#getargs_validate_option_value)
#: is used, this is provided more as an example VALIDATOR than as one of any
#: great use, documentation for it includes details of the arguments a VALIDATOR
#: receives.
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## EXIT STATUS
#:
#: - The exit status will be `0` (`<zero>`) if, and only if, all ARGUMENTs were
#:   processed correctly.
#: - The exit status will be `1` (`<one>`) if [AUTO-HELP](#auto-help) is enabled
#:   _AND_ an ARGUMENT specified that was either `--help` or `-h`. This is to
#:   signal to the caller that auto-help was triggered and, in general, should
#:   _not_ be propagated any further (i.e. normally `--help` is a successful
#:   operation).
#: - An unexpected exit status from an external command will be propagated to
#:   the caller. (This is unlikely to occur, and would normally indicate a
#:   command that is not _POSIX.1_ compliant.)
#: - Otherwise the exit status is one of values taken from
#:   [FreeBSD `SYSEXITS(3)`][sysexits]:
#:   - `EX_USAGE` for invalid SPECIFICATION usage
#:     (e.g. a missing OPTION-ARGUMENT)
#:   - `EX_CONFIG` for an invalid SPECIFICATION configuration
#:     (e.g. an invalid character in OPTION-CONFIG)
#:   - `EX_DATAERR` for invalid user ARGUMENTs (e.g. an OPTION that is meant to
#:     be should be set once - i.e. of type `[:]` - is set twice), this is the
#:     only error exit status normally generated for user ARGUMENT errors.
#:
################################################################################

################################################################################
#              DOCUMENTATION CONTINUES INLINE AND AT END OF FILE               #
################################################################################

############################## SHELLCHECK: GLOBAL ##############################
# shellcheck shell=sh                                                          #
#                                                                              #
# Enable some optional checks:                                                 #
#                                                                              #
# shellcheck enable=avoid-nullary-conditions                                   #
# shellcheck enable=check-extra-masked-returns                                 #
# shellcheck enable=deprecate-which                                            #
# shellcheck enable=require-variable-braces                                    #
#                                                                              #
# Globally disable some `shellcheck` checks:                                   #
#                                                                              #
# SC2034: foo appears unused. Verify it or export it.                          #
# EXCEPT: Caused by variables used dynamically (via `eval`) in addition to     #
#+        variables intended for use by scripts that source this library.      #
#+        Using `export` is _not_ a solution as these values should only be    #
#+        present in the current shell environment and _not_ inherited.        #
# shellcheck disable=SC2034                                                    #
#                                                                              #
################################################################################

#===============================================================================
# SOURCE GUARD
case ${BS_LIBGETARGS_SOURCED:+1} in 1) return ;; esac
#===============================================================================

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## INTERNAL CONSTANT HELPER
#.
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_lga_readonly`
#.
#. Wrapper round `readonly`.
#.
#. Required because in its default configuration Z Shell's `readonly` causes
#. problems (due to variable scoping).
#.
#. See [`BS_LIBGETARGS_CONFIG_NO_Z_SHELL_SETOPT`](#bs_libgetargs_config_no_z_shell_setopt)
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_lga_readonly <VAR>...
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `VAR` \[in]
#.
#. : Can be any value accepted by `readonly`.
#. : Can be specified multiple times.
#.
#_______________________________________________________________________________
fn_bs_lga_readonly() { ## cSpell:Ignore BS_LA_readonly_
  case ${c_BS_LGA_CFG_USE__zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'POSIX_BUILTINS' ;;
  esac
  readonly "$@" || true
}

#===============================================================================
#===============================================================================
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## ENVIRONMENT
#:
#: A number of environment variables affect the library, these are split into
#: variables that instruct the library to work-around specific platform issues,
#: and variables that convey user preferences. Variables that enable platform
#: specific work-arounds will be automatically set if needed, but can also be
#: set manually to force specific configurations.
#:
#: In additional to these, there are a number of variables that are set by the
#: library to convey information outside of command invocation.
#:
#: If unset, some variables will take an initial value from a _BetterScripts_
#: _POSIX Suite_ wide variable, these allow the same configuration to be used by
#: all libraries in the suite.
#:
#: After the library has been sourced, external commands must not set library
#: environment variables that are classified as CONSTANT. Variables may use
#: the `readonly` command to enforce this.
#:
#: **_If not otherwise specified, an `<unset>` variable is equivalent to the_**
#: **_default value._**
#:
#: _For more details see the common suite [documentation](./README.MD#environment)._
#:
#===============================================================================
#===============================================================================

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### PLATFORM CONFIGURATION
#:
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_NO_Z_SHELL_SETOPT`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`](./README.MD#better_scripts_config_no_z_shell_setopt)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
#:   _POSIX.1_ like behavior.
#: - _OFF_: Use `setopt` to set the appropriate options.
#: - _ON_: Don't use `setopt`, even in _Z Shell_.
#: - Automatically enabled if _Z Shell_ is detected.
#: - Any use of `setopt` is scoped as tightly as possible
#:   and should not affect other commands.
#: - _Z Shell_ has some defaults that cause non-standard
#:   behavior, however also provides `setopt` which can be
#:   tightly scoped to set options when required without
#:   impacting other platforms.
#. - See [`fn_bs_lga_readonly`](#fn_bs_lga_readonly).
#:
case ${BS_LIBGETARGS_CONFIG_NO_Z_SHELL_SETOPT:-${BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT:-A}} in
A)  case ${ZSH_VERSION:+1} in
    1) c_BS_LGA_CFG_USE__zsh_setopt=1 ;;
    *) c_BS_LGA_CFG_USE__zsh_setopt=0 ;;
    esac ;;
0) c_BS_LGA_CFG_USE__zsh_setopt=0 ;;
*) c_BS_LGA_CFG_USE__zsh_setopt=1 ;;
esac

fn_bs_lga_readonly 'c_BS_LGA_CFG_USE__zsh_setopt'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_NO_EXPR_EXIT_STATUS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_EXPR_EXIT_STATUS`](./README.MD#better_scripts_config_no_expr_exit_status)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - \[Disable]/Enable ignoring `expr` exit status to
#:   indicate a match was made.
#: - _OFF_: Use `expr` exit status to determine if a match
#:   was made.
#: - _ON_: Use a workaround to determine if a match was
#:   made. (This requires a sub-shell and is therefore far
#:   slower.)
#: - Some versions of `expr` do not always properly set the
#:   exit status, making it impossible to determine if a
#:   match was actually made.
#:
case ${BS_LIBGETARGS_CONFIG_NO_EXPR_EXIT_STATUS:-${BETTER_SCRIPTS_CONFIG_NO_EXPR_EXIT_STATUS:-A}} in
A)  case $(
            {
              i_BS_LGA_expr_match="$(expr 'Test Value' : '\(Test\)')" &&
                printf '%s Success' "${i_BS_LGA_expr_match-}"
            } 2>&1
          ) in
    'Test Success') c_BS_LGA_CFG_USE__expr_exit_status=1 ;;
                 *) c_BS_LGA_CFG_USE__expr_exit_status=0 ;;
    esac ;;
0)  c_BS_LGA_CFG_USE__expr_exit_status=0 ;;
*)  c_BS_LGA_CFG_USE__expr_exit_status=1 ;;
esac

fn_bs_lga_readonly 'c_BS_LGA_CFG_USE__expr_exit_status'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_NO_EXPR_NESTED_CAPTURES`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_EXPR_NESTED_CAPTURES`](./README.MD#better_scripts_config_no_expr_nested_captures)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - Disable/\[Enable] using `expr` for any
#:   ["Basic Regular Expression" (_BRE_)][posix_bre] that
#:   includes nested captures.
#: - _OFF_: Use `expr` for a _BRE_ that includes nested
#:   captures.
#: - _ON_: Any _BRE_ that uses nested captures will not
#:   be used with `expr`, but will use a case specific
#:   work-around.
#: - Some versions of `expr` do not work well with or do not
#:   support nested captures.
#:
case ${BS_LIBGETARGS_CONFIG_NO_EXPR_NESTED_CAPTURES:-${BETTER_SCRIPTS_CONFIG_NO_EXPR_NESTED_CAPTURES:-A}} in
A)  case $(
            {
              i_BS_LGA_expr_match="$(expr 'Test Value' : '\(Te\(st\)\)')" &&
                printf '%s Success' "${i_BS_LGA_expr_match-}"
            } 2>&1
          ) in
    'Test Success') c_BS_LGA_CFG_USE__expr_nested_captures=1 ;;
                 *) c_BS_LGA_CFG_USE__expr_nested_captures=0 ;;
    esac ;;
0)  c_BS_LGA_CFG_USE__expr_nested_captures=0 ;;
*)  c_BS_LGA_CFG_USE__expr_nested_captures=1 ;;
esac

fn_bs_lga_readonly 'c_BS_LGA_CFG_USE__expr_nested_captures'

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### USER PREFERENCE (OVERRIDABLE)
#:
#: Configuration that CAN be overridden by OPTIONs.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - User set configuration options that are in the constant
#.   CLASS are converted to internal options which are made
#.   read-only. This happens even when the user option could
#.   be used directly. This allows the user to reuse the
#.   option if desired, and also avoids any manipulation of
#.   variables set externally.
#.
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_ALLOW_ABBREVIATIONS`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _ON_
#: - Override: `--[no-]abbreviations`
#: - \[Enable]/Disable LONG-OPTION abbreviations.
#: - _ON_: any LONG-OPTION matches if the name is a
#:   prefix of an OPTION-CONFIG name (e.g. `--debug` and
#:   `--deb` will both match `debug`).
#: - _OFF_: abbreviations are disabled and long options
#:   must match exactly.
#: - MAY cause unexpected results if combined with
#:   [`BS_LIBGETARGS_CONFIG_ALLOW_AMBIGUOUS`](#bs_libgetargs_config_allow_ambiguous).
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_ALLOW_AMBIGUOUS`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]ambiguous`
#: - \[Enable]/Disable detection of ambiguous user OPTIONs.
#: - _OFF_: any ambiguous OPTION is an error.
#: - _ON_: all OPTIONs use the first match found - this WILL
#:   mask some OPTION-CONFIG errors.
#: - OPTIONs are ambiguous when multiple OPTIONs have the
#:   same name or, if abbreviations are enabled, when
#:   an abbreviation matches multiple OPTIONs.
#: - If abbreviations are also enabled (see
#:   [`BS_LIBGETARGS_CONFIG_ALLOW_ABBREVIATIONS`](#bs_libgetargs_config_allow_abbreviations))
#:   there is a high chance of incorrectly matching OPTIONs.
#: - _Has a measurable impact on performance._
#:   Prefer **_ON_** for performance.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_CHECK_CONFIG`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]check-config`
#: - Enable/\[Disable] performing basic checks on
#:   OPTION-CONFIG and OPERAND-CONFIG before processing.
#: - _OFF_: don't do any additional checks.
#: - _ON_: preform extra checks to ensure that OPTION-CONFIG
#:   and OPERAND-CONFIG match the required specification.
#: - The currently available checks are relatively basic but
#:   will catch errors that MAY otherwise be missed, however
#:   some of these may be benign.
#: - _MAY have a performance impact._
#:   Prefer **_OFF_** for performance.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_FATAL_ERRORS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_FATAL_ERRORS`](./README.MD#better_scripts_config_fatal_errors)
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Enable/\[Disable] causing library errors to terminate
#:   the current (sub-)shell.
#: - _OFF_: errors stop any further processing, and cause a
#:   non-zero exit status, but do not cause an exception.
#: - _ON_: any library error will cause an "unset variable"
#:   shell exception using the
#:   [`${parameter:?[word]}`][posix_param_expansion]
#:   parameter expansion, where `word` is set to an error
#:   message that _should_ be displayed by the shell (this
#:   message is NOT suppressed by
#:   [`BS_LIBGETARGS_CONFIG_QUIET_ERRORS`](#bs_libgetargs_config_quiet_errors)).
#: - Both the library version of this option and the
#:   suite version can be modified between command
#:   invocations and will affect the next command.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]interleaved`, `--[no-]mixed`
#: - Enable/\[Disable] allowing matching OPTIONs _after_ an
#:   OPERAND is matched.
#: - _OFF_: all OPTIONs (and associated OPTION-ARGUMENTs)
#:   MUST appear before the first OPERAND; i.e., the first
#:   ARGUMENT that does NOT start with `-` (`<hyphen>`)
#:   and is NOT an OPTION-ARGUMENT causes ALL remaining
#:   OPTIONs to be assumed to be OPERANDs _even if they
#:   start with `-` (`<hyphen>`)_.
#: - _ON_: an ARGUMENT that does NOT start with `-`
#:   (`<hyphen>`) and is NOT an OPTION-ARGUMENT is assumed
#:   to be an OPERAND, but following ARGUMENTs continue to
#:   be checked for OPTIONs.
#: - In either mode the special ARGUMENT `--` stops OPTION
#:   processing and any remaining ARGUMENTs are treated as
#:   OPERANDs
#: - Implied by
#:   [`BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`](#bs_libgetargs_config_allow_unmatched)
#: - Mutually exclusive with
#:   [`BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`](#bs_libgetargs_config_strict_operands)
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_ALLOW_POSIX_LONG`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]posix-long`
#: - Enable/\[Disable] matching LONG-OPTIONs with a single
#:   preceding `-` (`<hyphen>`) character instead of the
#:   normally required two.
#: - _OFF_: LONG-OPTIONs require the prefix `--`
#: - _ON_: any multi-character OPTION following a single
#:   `-` (`<hyphen>`) is checked to see if it matches
#:   a LONG-OPTION before checking if it is a
#:   COMPOUND-OPTION, meaning matching COMPOUND-OPTIONs is
#:   slower.
#: - _Has a measurable impact on performance._
#:   Prefer **_OFF_** for performance.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_QUIET_ERRORS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - \[Enable]/Disable library error message output.
#: - _OFF_: error messages will be written to `STDERR` as:
#:   `[<ID>]: ERROR: <MESSAGE>` (where `<ID>` is
#:   set using the `--id` OPTION).
#: - _ON_: library error messages will be suppressed.
#: - The most recent error message is always available in
#:   [`BS_LIBGETARGS_LAST_ERROR`](#bs_libgetargs_last_error)
#:   even when error output is suppressed.
#: - Both the library version of this option and the
#:   suite version can be modified between command
#:   invocations and will affect the next command.
#: - Does NOT affect errors from non-library commands, which
#:   _may_ still produce output.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]strict`
#: - Enable/\[Disable] requiring the use of `--` to separate
#:   OPTIONs from OPERANDs.
#: - _OFF_: the first ARGUMENT that is not and OPTION or an
#:   OPTION-ARGUMENT is an OPERAND and causes all further
#:   ARGUMENTs to be OPERANDs.
#: - _ON_: an ARGUMENT that is exactly `--` must be present
#:   after _all_ OPTIONs and before _any_ OPERANDs.
#: - Can help detect some usage errors.
#: - Mutually exclusive with
#:   [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands).
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_ALLOW_UNSAFE_OPTIONS`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]unsafe`
#: - \[Enable]/Disable escaping OPTION characters
#:   to avoid any erroneous results when matching with
#:   regular expressions. Characters in the supported set
#:   for OPTION-NAMEs `[[:alnum:]_-]` do not need this
#:   processing, while characters outside this range
#:   MAY (e.g. `.` (`<period>`) is problematic).
#: - _OFF_: OPTION-NAMEs have all characters made safe for
#:   use in a regular expression.
#: - _ON_: OPTION-NAMEs are used as is and may match
#:   incorrectly if they contain specific characters.
#: - This affects the OPTIONs being processed and NOT those
#:   in the OPTION-CONFIG.
#: - MAY have a performance impact.
#:   Prefer **_ON_** for performance.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_AUTO_UNSET`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]unset`
#: - Enable/\[Disable] automatic unsetting of all
#:   VARIABLES named in OPTION-CONFIG and OPERAND-CONFIG.
#: - _ON_: every variable specified in OPTION-CONFIG and
#:   OPERAND-CONFIG is automatically unset before ARGUMENTs
#:   are processed.
#: - _OFF_: variables need to be set to a known value or it
#:   will not be possible to correctly determine what
#:   OPTIONs have been matched.
#: - Normally desirable to have enabled, but using it MAY
#:   have performance issues, and it can not be used
#:   alongside default values for variables (i.e. values set
#:   before `getargs` is invoked).
#: - MAY have a performance impact.
#:   Prefer **_OFF_** for performance.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`
#:
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - Override: `--[no-]unmatched`
#: - Enable/\[Disable] matching an unrecognized OPTION as an
#:   OPERAND.
#: - _OFF_: any unrecognized OPTION is an error.
#: - _ON_: any unrecognized OPTION is treated as an OPERAND.
#: - Useful for commands where most arguments are not used,
#:   but instead forwarded to another command, where having
#:   this enabled significantly reduces code and isolates
#:   the command from changes in the arguments accepted by
#:   the target command.
#: - In either mode the special ARGUMENT `--` stops OPTION
#:   processing and any remaining ARGUMENTs are treated as
#:   OPERANDs.
#: - Although still permitted, there is no practical way to
#:   support the normal OPERAND processing when this is
#:   enabled; the only OPERAND-CONFIG that is useful will
#:   be one containing a single `[+]` type. If other
#:   OPERANDs are required, these must be manually extracted
#:   from the resulting array.
#: - If using a VALIDATOR, any unmatched values will be
#:   sent to the VALIDATOR as OPERANDs.
#: - Implies
#:   [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands).
#: - Mutually exclusive with
#:   [`BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`](#bs_libgetargs_config_strict_operands).
#:

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### USER PREFERENCE
#:
#: Configuration that can NOT be overridden by OPTIONs.
#:
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_TRUE_VALUE`
#:
#: - Type:     TEXT
#: - Class:    VARIABLE
#: - Default:  `true`
#: - Value used as `true` for options with the type
#:   negatable SWITCH-OPTION (i.e. `[~]`).
#: - The value given to a negatable SWITCH-OPTION variable
#:   when the ARGUMENT was specified without an OPTION-TAG.
#: - Also one of the values accepted as an OPTION-TAG for
#:   negatable SWITCH-OPTIONs.
#: - Can be null.
#: - SHOULD differ from
#:   [`BS_LIBGETARGS_CONFIG_FALSE_VALUE`](#bs_libgetargs_config_false_value)
#:   however this is NOT enforced.
#: - A negatable SWITCH-OPTION _only_ accepts the value here
#:   or the value from
#:   [`BS_LIBGETARGS_CONFIG_FALSE_VALUE`](#bs_libgetargs_config_false_value)
#:   as an OPTION-TAG.
#:
: "${BS_LIBGETARGS_CONFIG_TRUE_VALUE=true}"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_FALSE_VALUE`
#:
#: - Type:     TEXT
#: - Class:    VARIABLE
#: - Default:  `false`
#: - Value used as `false` for options with the type
#:   negatable SWITCH-OPTION (i.e. `[~]`).
#: - This value can be specified as an OPTION-TAG for the
#:   OPTION in which case the OPTION variable will receive
#:   this value.
#: - Can be null.
#: - SHOULD differ from
#:   [`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)
#:   however this is NOT enforced.
#: - A negatable SWITCH-OPTION _only_ accepts the value here
#:   or the value from
#:   [`BS_LIBGETARGS_CONFIG_TRUE_VALUE`](#bs_libgetargs_config_true_value)
#:   as an OPTION-TAG.
#:
: "${BS_LIBGETARGS_CONFIG_FALSE_VALUE=false}"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_OPTIONAL_VALUE`
#:
#: - Type:     TEXT
#: - Class:    VARIABLE
#: - Default:  \<unset>
#: - The value an OPTION variable receives if it takes an
#:   optional OPTION-ARGUMENT and no OPTION-ARGUMENT was
#:   specified.
#: - It is not possible to set a value here that could not
#:   have also been set as the OPTION-ARGUMENT for the
#:   OPTION, e.g., the default of \<unset> is the same value
#:   as would occur if the OPTION-ARGUMENT was an empty
#:   string.
#: - It is highly recommended that this be set to a more
#:   useful value if optional OPTION-ARGUMENTs are used.
#:
: "${BS_LIBGETARGS_CONFIG_OPTIONAL_VALUE=}"

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### AUTO-HELP CONFIGURATION
#:
#: Configuration related only to [AUTO-HELP](#auto-help)
#: mode.
#:
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_HELP_WRAP_COLUMNS`
#:
#: - Type:     TEXT
#: - Class:    VARIABLE
#: - Default:  Value from the `COLUMNS` environment variable
#:             or `80` if that variable is not set.
#: - Specifies the maximum width of the generated help text,
#:   any lines longer than this will be wrapped.
#: - May be set to any numeric value greater than `8`,
#:   although small values will lead to illegible output.
#: - If set to the empty string (aka null), wrapping is
#:   disabled.
#: - If set to an invalid value, the default value is used.
#: - Help text uses an indent of `8` characters which counts
#:   towards the length of lines for the purposes of
#:   wrapping.
#:
: "${BS_LIBGETARGS_CONFIG_HELP_WRAP_COLUMNS=${COLUMNS:-80}}"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_HELP_MULTI_OPTION`
#:
#: - Type:     TEXT
#: - Class:    VARIABLE
#: - Default:  `May be specified multiple times.`
#: - A string added to help for OPTIONs of the `[+]` type.
#: - Used to indicate the OPTION can be specified more than
#:   once.
#: - If set to the empty string (aka null), no text is
#:   added.
#: - WILL cause errors if it contains any `\n` (`<newline>`)
#:   characters.
#:
case ${BS_LIBGETARGS_CONFIG_HELP_MULTI_OPTION+1} in
1) ;; *) BS_LIBGETARGS_CONFIG_HELP_MULTI_OPTION='May be specified multiple times.' ;;
esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_HELP_MULTI_OPERAND`
#:
#: - Type:     TEXT
#: - Class:    VARIABLE
#: - Default:  `May be specified multiple times.`
#: - A string added to help for OPERANDs of the `[+]` type.
#: - Used to indicate the OPERAND can be specified more than
#:   once.
#: - If set to the empty string (aka null), no text is
#:   added.
#: - WILL cause errors if it contains any `\n` (`<newline>`)
#:   characters.
#:
case ${BS_LIBGETARGS_CONFIG_HELP_MULTI_OPERAND+1} in
1) ;; *) BS_LIBGETARGS_CONFIG_HELP_MULTI_OPERAND='May be specified multiple times.' ;;
esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_CONFIG_HELP_ALTERNATIVE_OPERAND`
#:
#: - Type:     TEXT
#: - Class:    VARIABLE
#: - Default:  `Alternative to <OPTION>.`
#: - A string added to help for an OPERAND if there is an
#:   OPTION that provides the same purpose. (i.e. only
#:   OPERANDs of the type `[^]` or `[+]`).
#: - The literal string `<OPTION>` is replaced with one of
#:   the OPTION-NAMEs for the OPTION that can alternatively
#:   be used.
#: - If set to the empty string (aka null), no text is
#:   added.
#: - WILL cause errors if it contains any `\n` (`<newline>`)
#:   characters.
#:
case ${BS_LIBGETARGS_CONFIG_HELP_ALTERNATIVE_OPERAND+1} in
1) ;; *) BS_LIBGETARGS_CONFIG_HELP_ALTERNATIVE_OPERAND='Alternative to <OPTION>.' ;;
esac

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### INFORMATIONAL
#:
#: Variables that convey library information.
#:
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#.
#. _VERSION_
#. <!--  -->
#.
#. Uses [Semantic Versioning](https://semver.org/)
#.
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_VERSION_MAJOR`
#:
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_VERSION_MINOR`
#:
#: - Integer >= 0.
#: - Incremented for significant changes that do not
#:   break compatibility with previous versions.
#: - Reset to 0 when
#:   [`BS_LIBGETARGS_VERSION_MAJOR`](#bs_libgetargs_version_major)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_VERSION_PATCH`
#:
#: - Integer >= 0.
#: - Incremented for minor revisions or bugfixes.
#: - Reset to 0 when
#:   [`BS_LIBGETARGS_VERSION_MINOR`](#bs_libgetargs_version_minor)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_VERSION_RELEASE`
#:
#: - A string indicating a pre-release version, always
#:   null for full-release versions.
#: - Possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended).
#:
  BS_LIBGETARGS_VERSION_MAJOR=1;
  BS_LIBGETARGS_VERSION_MINOR=0;
  BS_LIBGETARGS_VERSION_PATCH=0;
BS_LIBGETARGS_VERSION_RELEASE=;

fn_bs_lga_readonly 'BS_LIBGETARGS_VERSION_MAJOR'   \
                   'BS_LIBGETARGS_VERSION_MINOR'   \
                   'BS_LIBGETARGS_VERSION_PATCH'   \
                   'BS_LIBGETARGS_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_VERSION_FULL`
#:
#: - Full version combining
#:   [`BS_LIBGETARGS_VERSION_MAJOR`](#bs_libgetargs_version_major),
#:   [`BS_LIBGETARGS_VERSION_MINOR`](#bs_libgetargs_version_minor),
#:   and [`BS_LIBGETARGS_VERSION_PATCH`](#bs_libgetargs_version_patch)
#:   as a single integer.
#: - Can be used in numerical comparisons.
#: - Format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded).
#:
BS_LIBGETARGS_VERSION_FULL=$(( \
    ( (BS_LIBGETARGS_VERSION_MAJOR * 1000) + BS_LIBGETARGS_VERSION_MINOR ) * 1000 \
    + BS_LIBGETARGS_VERSION_PATCH \
  ))

fn_bs_lga_readonly 'BS_LIBGETARGS_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_VERSION`
#:
#: - Full version combining
#:   [`BS_LIBGETARGS_VERSION_MAJOR`](#bs_libgetargs_version_major),
#:   [`BS_LIBGETARGS_VERSION_MINOR`](#bs_libgetargs_version_minor),
#:   [`BS_LIBARRAY_VERSION_PATCH`](#bs_libgetargs_version_patch),
#:   and
#:   [`BS_LIBGETARGS_VERSION_RELEASE`](#bs_libgetargs_version_release)
#:   as a formatted string.
#: - Format: `BetterScripts 'libgetargs' vMAJOR.MINOR.PATCH[-RELEASE]`.
#: - Derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#: - This value is output when the `--version` OPTION is
#:   used.
#:
BS_LIBGETARGS_VERSION="$(
    printf "BetterScripts 'libgetargs' v%d.%d.%d%s\n" \
           "${BS_LIBGETARGS_VERSION_MAJOR}"           \
           "${BS_LIBGETARGS_VERSION_MINOR}"           \
           "${BS_LIBGETARGS_VERSION_PATCH}"           \
           "${BS_LIBGETARGS_VERSION_RELEASE:+-${BS_LIBGETARGS_VERSION_RELEASE}}"
  )"

fn_bs_lga_readonly 'BS_LIBGETARGS_VERSION'

#===============================================================================
#===============================================================================
#  CONSTANTS
#===============================================================================
#===============================================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_TYPE_OPT_ARG`
#:
#: - Value passed to the validation command to indicate
#:   the type of ARGUMENT being validated.
#: - Indicates the OPTION parameter is a known OPTION and
#:   the VALUE parameter is the following ARGUMENT
#:   (e.g. `--OPTION VALUE`, `-O VALUE`, etc.).
#: - Implies the VALUE parameter MUST be a valid
#:   OPTION-ARGUMENT for the specified OPTION.
#: - See [`getargs_validate_option_value`](#getargs_validate_option_value),
#:
#: ---------------------------------------------------------
## cSpell:Ignore OVALUE
#:
#: #### `BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE`
#:
#: - Value passed to the validation command to indicate
#:   the type of ARGUMENT being validated.
#: - Indicates the OPTION parameter a known OPTION and
#:   the VALUE parameter was specified as part of the same
#:   ARGUMENT without any delimiter (e.g. `-OVALUE`).
#: - Implies the VALUE parameter MUST be a valid
#:   OPTION-ARGUMENT for the specified OPTION.
#: - See [`getargs_validate_option_value`](#getargs_validate_option_value),
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED`
#:
#: - Value passed to the validation command to indicate
#:   the type of ARGUMENT being validated.
#: - Indicates the OPTION parameter a known OPTION and
#:   the VALUE parameter was specified as part of the same
#:   ARGUMENT delimited by `=` (`<equals>`)
#:   (e.g. `--OPTION=VALUE`, `-O=VALUE`, etc.).
#: - Implies the VALUE parameter MUST be a valid
#:   OPTION-ARGUMENT for the specified OPTION.
#: - See [`getargs_validate_option_value`](#getargs_validate_option_value),
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_TYPE_OPERAND`
#:
#: - Value passed to the validation command to indicate
#:   the type of ARGUMENT being validated.
#: - Indicates the VALUE parameter is an ARGUMENT that was
#:   matched as an OPERAND.
#: - Implies the VALUE parameter MUST be a valid OPERAND.
#: - See [`getargs_validate_option_value`](#getargs_validate_option_value),
#:
          BS_LIBGETARGS_TYPE_OPT_ARG=' '
BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE='|'
BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED='='
          BS_LIBGETARGS_TYPE_OPERAND='#'

fn_bs_lga_readonly 'BS_LIBGETARGS_TYPE_OPT_ARG'           \
                   'BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE' \
                   'BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED' \
                   'BS_LIBGETARGS_TYPE_OPERAND'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_LAST_ERROR`
#:
#: - Stores the error message of the most recent error.
#: - ONLY valid immediately following a command for which
#:   the exit status is not `0` (`<zero>`).
#: - Available even when error output is suppressed.
#:
BS_LIBGETARGS_LAST_ERROR=; #< CLEAR ON SOURCING

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBGETARGS_SOURCED`
#:
#: - Set (and non-null) once the library has been sourced.
#: - Dependant scripts can query if this variable is set to
#:   determine if this file has been sourced.
#. - Used as a script guard on script sourcing.
#. - Only set at end of script (once script is
#.   successfully sourced).
#:

#===========================================================
#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### INTERNAL CONSTANTS
#.
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LGA__newline`
#.
#. - Literal `\n` (`<newline>`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_LGA__newline='
'

fn_bs_lga_readonly 'c_BS_LGA__newline'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LGA__tab`
#.
#. - Literal `\t` (`<tab>`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_LGA__tab='	'

fn_bs_lga_readonly 'c_BS_LGA__tab'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LGA__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_LGA__EX_DATAERR`
#.
#. - Exit code for use when user provided _BAD DATA_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_LGA__EX_CONFIG`
#.
#. - Exit code for use when _CONFIG IS INVALID_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
  c_BS_LGA__EX_USAGE=64
c_BS_LGA__EX_DATAERR=65
 c_BS_LGA__EX_CONFIG=78

fn_bs_lga_readonly 'c_BS_LGA__EX_USAGE'   \
                   'c_BS_LGA__EX_DATAERR' \
                   'c_BS_LGA__EX_CONFIG'

#===============================================================================
#. <!-- ................................................ -->
#.
#. #### `REGULAR EXPRESSIONS`
#.
#. A number of constants are defined for regular
#. expressions. Defining these as constants rather than
#. inline allows easier editing and ensures all expressions
#. use the same values (some of which are confusing when
#. used in complex expressions).
#.
#. It is possible there will be a performance penalty for
#. using these constants in place of inline values, but it
#. is likely to be small (no measurable difference was
#. detected in limited testing).
#.
#. Note that, outside of the `POSIX` locale character
#. ranges (i.e. `[a-z]`) can match unexpected values.
#. Character classes (i.e. `[:alpha:]`) are similar in this
#. regard and are not as widely supported. Using explicit
#. ranges is cumbersome, but has no known issues.
#.
#===============================================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_DIGIT`
#.
#. - String for use in regular expression
#.   [bracket expressions][posix_re_bracket_exp] to match
#.   a single digit.
#. - Equivalent to `[0-9]` or `[:digit:]` (in the
#.   `POSIX` locale)
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_ALPHA`
#.
#. - String for use in regular expression
#.   [bracket expressions][posix_re_bracket_exp] to match
#.   a single alphabetic character.
#. - Equivalent to `[a-zA-Z]` or `[:alpha:]` (in the
#.   `POSIX` locale)
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_ALNUM`
#.
#. - String for use in regular expression
#.   [bracket expressions][posix_re_bracket_exp] to match
#.   a single alphanumeric character.
#. - Equivalent to `[a-zA-Z0-9]` or `[:alnum:]` (in the
#.   `POSIX` locale)
#.
c_BS_LGA__re_DIGIT='0123456789'
c_BS_LGA__re_ALPHA='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
c_BS_LGA__re_ALNUM="${c_BS_LGA__re_ALPHA}${c_BS_LGA__re_DIGIT}"

fn_bs_lga_readonly 'c_BS_LGA__re_DIGIT' \
                   'c_BS_LGA__re_ALPHA' \
                   'c_BS_LGA__re_ALNUM'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_Alias_OtherChar`
#.
#. - [Bracket expression][posix_re_bracket_exp] that defines
#.   the characters permitted as the SECOND character
#.   onwards of an OPTION name.
#. - Only a small set of characters is strictly prohibited,
#.   while all characters outside these can be used they are
#.   unlikely to all be useful (and some may lead to errors)
#. - Prohibited characters:
#.
#.   Character                     | Prohibited because
#.   ----------------------------- | -----------------------------
#.   `|` (`<vertical-line>`)       | OPTION-CONFIG alias separator
#.   `[` (`<left-square-bracket>`) | OPTION-CONFIG type delimiter
#.   `,` (`<comma>`)               | OPTION-CONFIG OPTION delimiter
#.   `:` (`<colon>`)               | OPTION-TAG delimiter
#.   `=` (`<colon>`)               | OPTION-ARGUMENT delimiter
#.
#. - The character `]` (`<right-square-bracket>`) SHOULD
#.   also be prohibited, but some platforms struggle with
#.   this character appearing in bracket expressions, so
#.   it has to be omitted. Unfortunately there is no easy
#.   way to fix this, but it is unlikely to cause an issue
#.   in most scenarios.
#.
#. ---------------------------------------------------------
## cSpell:Ignore otherchar
#.
#. ##### `c_BS_LGA__re_Alias_FirstChar`
#.
#. - [Bracket expression][posix_re_bracket_exp] that defines
#.   the characters permitted as the FIRST character of an
#.   OPTION name.
#. - Identical to
#.   [c_BS_LGA__re_Alias_OtherChar](#c_bs_lga__re_alias_otherchar)
#.   with the addition of `-` (`<hyphen>`), which is the
#.   OPTION delimiter.
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_ALNUM`
#.
#. - String for use in regular expression
#.   [bracket expressions][posix_re_bracket_exp] to match
#.   a single alphanumeric character.
#. - Equivalent to `[a-zA-Z0-9]` or `[:alnum:]` (in the
#.   `POSIX` locale)
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_Alias`
#.
#. - ["Basic Regular Expression" (_BRE_)][posix_bre] that
#.   matches a single valid OPTION alias.
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_AliasList`
#.
#. - ["Basic Regular Expression" (_BRE_)][posix_bre] that
#.   matches a `|` (`<vertical-line>`) separated list of
#.   [`c_BS_LGA__re_Alias`](#c_bs_lga__re_alias) values.
#.
c_BS_LGA__re_Alias_OtherChar='[^|:=[,]'
c_BS_LGA__re_Alias_FirstChar='[^|:=[,-]'

    c_BS_LGA__re_Alias="${c_BS_LGA__re_Alias_FirstChar}${c_BS_LGA__re_Alias_OtherChar}\{0,\}"
c_BS_LGA__re_AliasList="${c_BS_LGA__re_Alias}\(|${c_BS_LGA__re_Alias}\)\{0,\}"

fn_bs_lga_readonly 'c_BS_LGA__re_Alias_FirstChar' \
                   'c_BS_LGA__re_Alias_OtherChar' \
                   'c_BS_LGA__re_Alias'           \
                   'c_BS_LGA__re_AliasList'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
## cSpell:Ignore varchar
#.
#. ##### `c_BS_LGA__re_VarChar_First`
#.
#. - [Bracket expression][posix_re_bracket_exp] that defines
#.   the characters permitted as the FIRST character of an
#.   VARIABLE name.
#. - Similar to
#.   [`c_BS_LGA__re_VarChar_Other`](#c_bs_lga__re_varchar_other)
#.   except does not allow digits.
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_VarChar_Other`
#.
#. - [Bracket expression][posix_re_bracket_exp] that defines
#.   the characters permitted as the SECOND character
#.   onwards of an VARIABLE name.
#. - Similar to
#.   [`c_BS_LGA__re_VarChar_First`](#c_bs_lga__re_varchar_first)
#.   but also allows digits.
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_Variable`
#.
#. - A complete [_BRE_ expression][posix_bre] that matches
#.   the characters permitted for a variable name.
#. - SHOULD only match valid _POSIX.1_ variable names, while
#.   reject all other values.
#.
#. ---------------------------------------------------------
#.
#. _NOTES_
#.
#. The _POSIX.1_ specification [states][posix_variable] that
#. a `NAME` is:
#.
#. > In the shell command language, a word consisting solely
#. > of underscores, digits, and alphabetics from the
#. > portable character set. The first character of a name
#. > is not a digit.
#.
#. Some shells allow additional characters, however, it is
#. effectively impossible to safely match anything beyond
#. those which the standard defines.
#.
c_BS_LGA__re_VarChar_First="[${c_BS_LGA__re_ALPHA}_]"
c_BS_LGA__re_VarChar_Other="[${c_BS_LGA__re_ALNUM}_]"

c_BS_LGA__re_Variable="${c_BS_LGA__re_VarChar_First}${c_BS_LGA__re_VarChar_Other}\{0,\}"

fn_bs_lga_readonly 'c_BS_LGA__re_VarChar_First' \
                   'c_BS_LGA__re_VarChar_Other' \
                   'c_BS_LGA__re_Variable'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_OptionType`
#.
#. - [Bracket expression][posix_re_bracket_exp] that defines
#.   the permitted OPTION-ARGUMENT types.
#.
#. _TYPES_
#. <!-- -->
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__OptType_Switch`
#.
#. : _incrementable_ SWITCH-OPTION
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__OptType_NegatableSwitch`
#.
#. : _negatable_ SWITCH-OPTION
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__OptType_OptArg_Optional`
#.
#. : _optional_ OPTION-ARGUMENT
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__OptType_OptArg`
#.
#. : _required_ OPTION-ARGUMENT
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__OptType_OptArg_Resettable`
#.
#. : _resettable_ OPTION-ARGUMENT
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__OptType_OptArg_Multiple`
#.
#. : _multi_ OPTION-ARGUMENT
#.
#. <!-- ------------------------------------------------ -->
#.
           c_BS_LGA__OptType_Switch='-'
  c_BS_LGA__OptType_NegatableSwitch='~'
  c_BS_LGA__OptType_OptArg_Optional='?'
           c_BS_LGA__OptType_OptArg=':'
c_BS_LGA__OptType_OptArg_Resettable=';'
  c_BS_LGA__OptType_OptArg_Multiple='+'

#  Option Type Match
c_BS_LGA__re_OptionType='[-~?:;+]'

fn_bs_lga_readonly 'c_BS_LGA__OptType_Switch'            \
                   'c_BS_LGA__OptType_NegatableSwitch'   \
                   'c_BS_LGA__OptType_OptArg_Optional'   \
                   'c_BS_LGA__OptType_OptArg'            \
                   'c_BS_LGA__OptType_OptArg_Resettable' \
                   'c_BS_LGA__OptType_OptArg_Multiple'   \
                   'c_BS_LGA__re_OptionType'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_OperandType`
#.
#. - [Bracket expression][posix_re_bracket_exp] that matches
#.   the permitted OPERAND types, EXCEPT _multi_ OPERAND
#.   which is always matched separately.
#.
#. _TYPES_
#. <!-- -->
#.
#. <!-- ------------------------------------------------ -->
## cSpell:Ignore Skippable
#.
#. `c_BS_LGA__re_OperandType_Skippable`
#.
#. : _skippable_ OPERAND
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__re_OperandType_Single`
#.
#. : _single value_ OPERAND
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__re_OperandType_Resettable`
#.
#. : _optional_ OPERAND
#.
#. <!-- ------------------------------------------------ -->
#.
#. `c_BS_LGA__re_OperandType_Multiple`
#.
#. : _multi_ OPERAND
#.
#. <!-- ------------------------------------------------ -->
#.
 c_BS_LGA__re_OperandType_Skippable='^'
    c_BS_LGA__re_OperandType_Single=':'
c_BS_LGA__re_OperandType_Resettable=';'
  c_BS_LGA__re_OperandType_Multiple='+'

#  Operand Type Match
c_BS_LGA__re_OperandType='[:;^]'

fn_bs_lga_readonly 'c_BS_LGA__re_OperandType_Skippable'  \
                   'c_BS_LGA__re_OperandType_Single'     \
                   'c_BS_LGA__re_OperandType_Resettable' \
                   'c_BS_LGA__re_OperandType_Multiple'   \
                   'c_BS_LGA__re_OperandType'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_Option`
#.
#. - ["Basic Regular Expression" (_BRE_)][posix_bre] that
#.   matches a single OPTION-CONFIG
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_OptionConfig`
#.
#. - ["Basic Regular Expression" (_BRE_)][posix_bre] that
#.   matches an OPTION-CONFIG with multiple parts
#.
#. ---------------------------------------------------------
## cSpell:Ignore matchsuffix
#.
#. ##### `c_BS_LGA__re_Option_MatchPrefix`
#.
#. - Partial ["Basic Regular Expression" (_BRE_)][posix_bre]
#.   that is prepended to an OPTION-NAME to create a full
#.   _BRE_ to use to look up the OPTION-CONFIG.
#. - MUST be used with
#.   [`c_BS_LGA__re_Option_MatchSuffix`](#c_bs_lga__re_option_matchsuffix)
#.
#. ---------------------------------------------------------
## cSpell:Ignore matchprefix
#.
#. ##### `c_BS_LGA__re_Option_MatchSuffix`
#.
#. - Partial ["Basic Regular Expression" (_BRE_)][posix_bre]
#.   that is appended to an OPTION-NAME to create a full
#.   _BRE_ to use to look up the OPTION-CONFIG.
#. - MUST be used with
#.   [`c_BS_LGA__re_Option_MatchPrefix`](#c_bs_lga__re_option_matchprefix)
#.
      c_BS_LGA__re_Option="${c_BS_LGA__re_AliasList}\[${c_BS_LGA__re_OptionType}\]${c_BS_LGA__re_Variable}"
c_BS_LGA__re_OptionConfig="\(${c_BS_LGA__re_Option},\)\{1,\}"

c_BS_LGA__re_Option_MatchPrefix="\(${c_BS_LGA__re_Alias}|\)\{0,\}"
c_BS_LGA__re_Option_MatchSuffix="\(|${c_BS_LGA__re_Alias}\)\{0,\}\[${c_BS_LGA__re_OptionType}\]${c_BS_LGA__re_Variable}"

fn_bs_lga_readonly 'c_BS_LGA__re_Option'             \
                   'c_BS_LGA__re_OptionConfig'       \
                   'c_BS_LGA__re_Option_MatchPrefix' \
                   'c_BS_LGA__re_Option_MatchSuffix'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_OperandSingle`
#.
#. - ["Basic Regular Expression" (_BRE_)][posix_bre] that
#.   matches an OPERAND-CONFIG for all OPERAND types EXCEPT
#.   _multi_ OPERANDs.
#.
#. ---------------------------------------------------------
#.
#. ##### `c_BS_LGA__re_OperandMulti`
#.
#. - ["Basic Regular Expression" (_BRE_)][posix_bre] that
#.   matches an OPERAND-CONFIG for _multi_ OPERAND types
#.
c_BS_LGA__re_OperandSingle="\[${c_BS_LGA__re_OperandType}\]${c_BS_LGA__re_Variable}"
 c_BS_LGA__re_OperandMulti="\[${c_BS_LGA__re_OperandType_Multiple}\]${c_BS_LGA__re_Variable}"

fn_bs_lga_readonly 'c_BS_LGA__re_OperandSingle' \
                   'c_BS_LGA__re_OperandMulti'

#===============================================================================
#===============================================================================
#; <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#;
#; ## INTERNAL COMMANDS
#;
#; _GENERAL NOTES_
#; <!-- ------ -->
#;
#; - Internal commands MUST not be invoked outside of the library.
#; - Command arguments MUST be validated by the **invoking** command.
#; - Most arguments to internal commands are mandatory.
#;
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_error`
#;
#; Error reporting command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_lga_error <MESSAGE>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `MESSAGE` \[in]
#;
#; : Error message.
#; : Multiple message values may be specified and
#;   will be joined into a single string delimited
#;   by `<space>` characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Any value given with the `--name` option will be used as part of the
#;   error message. If this is omitted the string 'getargs' is used.
#; - Any argument currently being processed will be appended to the error.
#;   (This is helpful if the error is due to a problem with a COMPOUND-OPTION.)
#; - If [`BS_LIBGETARGS_CONFIG_QUIET_ERRORS`](#bs_libgetargs_config_quiet_errors)
#;   is _OFF_ a message in the format `[<ID>]: ERROR: <MESSAGE>` is
#;   written to `STDERR`.
#; - If [`BS_LIBGETARGS_CONFIG_FATAL_ERRORS`](#bs_libgetargs_config_fatal_errors)
#;   is _ON_ then an "unset variable" shell exception will be triggered using
#;   the [`${parameter:?[word]}`][posix_param_expansion] parameter expansion,
#;   where `word` is set to the error message.
#; - [`BS_LIBGETARGS_LAST_ERROR`](#bs_libgetargs_last_error) will contain the
#;   `<MESSAGE>` without any additional prefix regardless of other settings.
#;
#_______________________________________________________________________________
fn_bs_lga_error() { ## cSpell:Ignore BS_LGAE
  BS_LIBGETARGS_LAST_ERROR=;
  case $# in
  0)  : "${1:?'[libgetargs::fn_bs_lga_error]: Internal Error: an error message is required'}" ;;
  1)  BS_LIBGETARGS_LAST_ERROR="$1" ;;
  *)  case ${IFS-} in
      ' '*) BS_LIBGETARGS_LAST_ERROR="$*" ;;
         *) BS_LIBGETARGS_LAST_ERROR="$1"
            shift
            BS_LIBGETARGS_LAST_ERROR="${BS_LIBGETARGS_LAST_ERROR}$(printf ' %s' "$@")" ;;
      esac
  esac

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #  Append the argument being processed
  case ${g_BS_LGA__CurrentArgument:+1} in
  1)  # The currently processed argument could be any value
      # passed to the command, so truncate the value to
      # ensure output remains somewhat reasonable.
      case ${#g_BS_LGA__CurrentArgument} in
      ?|1?|20) BS_LGAE_CurrentArgument="${g_BS_LGA__CurrentArgument}" ;; #< less than or equal to 20
            *) BS_LGAE_CurrentArgument="$(printf '%.17s...' "${g_BS_LGA__CurrentArgument}")" ;;
      esac
      BS_LIBGETARGS_LAST_ERROR="${BS_LIBGETARGS_LAST_ERROR} (while processing: ${BS_LGAE_CurrentArgument})" ;;
  esac

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #  Process error output...
  case ${g_BS_LGA_CFG_QuietErrors:-0} in
  0) printf '[%s]: ERROR: %s\n'           \
            "${g_BS_LGA__ID:-getargs}"    \
            "${BS_LIBGETARGS_LAST_ERROR}" >&2 ;;
  esac

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #  Process fatal errors...
  case ${g_BS_LGA_CFG_FatalErrors:-0} in
  1)  BS_LIBGETARGS__FatalError=;
      : "${BS_LIBGETARGS__FatalError:?"[${g_BS_LGA__ID:-getargs}]: ERROR: ${BS_LIBGETARGS_LAST_ERROR}"}" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_lga_invalid_args <CALLER> <MESSAGE>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `MESSAGE` \[in]
#;
#; : Error message.
#; : Multiple message values may be specified and
#;   will be joined into a single string delimited
#;   by `<space>` characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Intended to make caller commands more readable and less verbose at the
#;   cost of some performance when an error occurs.
#;
#_______________________________________________________________________________
fn_bs_lga_invalid_args() { ## cSpell:Ignore BS_LGAIA_
  fn_bs_lga_error 'Invalid Arguments:' "$@"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_expected`
#;
#; Helper for errors reporting incorrect number of arguments.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_expected <EXPECTED>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `EXPECTED` \[in]
#;
#; : Information detailing expected arguments.
#; : Each value should represent a _single_ expected
#;   argument, with additional expected arguments
#;   specified with additional values.
#; : Optional values should be noted as such.
#; : All values will be joined into a single string
#;   delimited by `,` (`<comma>`) characters, except
#;   the last which will be appended using the literal
#;   string: `, and `.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Intended to make caller commands more readable and less verbose and
#;   error messages more helpful, at the cost of some performance when an
#;   error occurs.
#;
#_______________________________________________________________________________
fn_bs_lga_expected() { ## cSpell:Ignore BS_LGAExpected_
  BS_LGAExpected_Message="expected ${1:?'[libgetargs::fn_bs_lga_expected]: Internal Error: an expected argument is required'}"
  case $# in
  1)  ;;
  *)  shift
      while : #< [ $# -gt 1 ]
      do
        #> LOOP TEST --------------
        case $# in 1) break ;; esac #< [ $# -gt 1 ]
        #> ------------------------

        BS_LGAExpected_Message="${BS_LGAExpected_Message}, $1"
        shift
      done #<: `while : #< [ $# -gt 1 ]`
      BS_LGAExpected_Message="${BS_LGAExpected_Message}, and $1" ;;
  esac
  fn_bs_lga_invalid_args "${BS_LGAExpected_Message}"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_validate_name`
#;
#; Check a value looks like a valid _POSIX.1_ compliant shell variable name, if
#; not report and error and return with an error exit status.
#;
#; As variable names are frequently used with `eval` it is important that they
#; are valid. While many values used with `eval` can easily be sanitized (using
#; quotes) to protect against execution of arbitrary code, variable names are
#; more difficult to protect as they appear on the left side of assignments.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_validate_name <NAME>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `NAME` \[in]
#;
#; : Variable name being tested.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The use of `eval` in any shell script means arbitrary code can be
#;   executed if sufficient care is not taken. This, clearly, represents a
#;   security risk, and also has the potential to cause significant harm even
#;   through non-malicious acts. The chances of such an issue actually causing
#;   real harm are entirely dependent on context, while almost certainly
#;   incredibly unlikely, are not zero.
#; - The _POSIX.1_ specification for shell variable names is:
#;
#;   > In the shell command language, a word consisting solely of
#;   > underscores, digits, and alphabetics from the portable character set.
#;   > The first character of a name is not a digit.
#;
#;   Although some shells may extend this definition to allow additional
#;   values, there is no safe way to allow for these values that does not
#;   cause additional issues that are not easily mitigated.
#; - Outside of the _POSIX_ locale character ranges (i.e. `[a-z]`) can match
#;   unexpected values. Character classes (i.e. `[:alpha:]`) are similar in
#;   this regard and are not as widely supported. Using explicit ranges is
#;   cumbersome, but more likely to provide the expected results. (Performance
#;   of each option is the same to within margin of error for all tested
#;   implementations.)
#;
#_______________________________________________________________________________
fn_bs_lga_validate_name() { ## cSpell:Ignore BS_LGAVN_
  BS_LGAVN_Name="${1?'[libgetargs::fn_bs_lga_validate_name]: Internal Error: a variable name is required'}"

  case ${BS_LGAVN_Name:-#} in
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_lga_invalid_args "invalid variable name '${BS_LGAVN_Name}'"
    return "${c_BS_LGA__EX_USAGE}" ;;
  esac
}

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## SHELL COMPATIBILITY COMMANDS
#.
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_expr_re`
#;
#; Some platforms have issues with `expr` which are hard to
#; work around, so use an alternative where required.
#;
#; Known Problematic Implementations (from
#; [`autoconf` portability documentation][autoconf_portable]):
#;
#; - _HP-UX_: does not allow nested captures in `expr`
#; - _QNX_: does not properly set return values when
#;   captures are used (can't determine success)
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_expr_re <VALUE> <BRE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE` \[in]
#;
#; : The value to test, as in: `expr <VALUE> : <BRE>`
#;
#; `BRE` \[in]
#;
#; : The regular expression to use, as in:
#;   `expr <VALUE> : <BRE>`
#; : MUST be a _POSIX.1_ "Basic Regular Expression" that
#;   `expr`, `sed`, and `grep` can process (tool used
#;   depends on requirements of expression and
#;   limitations of `expr` for the current platform).
#; : MUST NOT use the positional anchor `^` (`<circumflex>`).
#; : MAY use the  positional anchor `$` (`<dollar-sign>`),
#;   but this might not work with all implementations.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Fallback versions are written specifically for the limited functionality
#;   necessary for this library and are not suitable as general replacements.
#; - When using `expr` with a _BRE_, if the string matched can _ever_ be simply
#;   `0` (`<zero>`) then the exit status of `expr` can _not_ be used as the
#;   standard requires this results in a non-zero exit status. Some
#;   implementations may additionally treat strings containing only `0`
#;   (`<zero>`) characters the same way.
#;
#_______________________________________________________________________________
case ${c_BS_LGA_CFG_USE__expr_exit_status:-0}:${c_BS_LGA_CFG_USE__expr_nested_captures:-0} in
1:1)  #-----------------------------------------------------
      # `expr` AVAILABLE
      #
      # Simple `expr` wrapper.
      #-----------------------------------------------------
      fn_bs_lga_expr_re() { ## cSpell:Ignore BS_LGAER_
        BS_LGAER_Value="${1?'[libgetargs::fn_bs_lga_expr_re]: Internal Error: a value is required'}"
         BS_LGAER_Expr="${2:?'[libgetargs::fn_bs_lga_expr_re]: Internal Error: an expression is required'}"
        # An `_` (`<underscore>`) character is used to avoid
        # either value being mistaken for an `expr` OPTION
        expr "_${BS_LGAER_Value}" : "_${BS_LGAER_Expr}"
      }
  ;;  #< `case 1:1)`

0:*)  #-----------------------------------------------------
      # `expr` UNAVAILABLE: Exit status inaccurate
      #
      # `expr` wrapper with failure exit status
      # modified to be more accurate.
      #-----------------------------------------------------
      fn_bs_lga_expr_re() { ## cSpell:Ignore BS_LGAER_
        BS_LGAER_Value="${1?'[libgetargs::fn_bs_lga_expr_re]: Internal Error: a value is required'}"
         BS_LGAER_Expr="${2:?'[libgetargs::fn_bs_lga_expr_re]: Internal Error: an expression is required'}"

        # An `_` (`<underscore>`) character is used to avoid
        # either value being mistaken for an `expr` OPTION
        if  BS_LGAER_Result="$(expr "_${BS_LGAER_Value}" : "_${BS_LGAER_Expr}")"
        then
          return
        else
          case ${BS_LGAER_Result:-0} in
          0) return 1 ;;
          *) printf '%s\n' "${BS_LGAER_Result}" ;;
          esac
        fi
      }
  ;;  #< `case 0:*)`

*:0)  #-----------------------------------------------------
      # `expr` UNAVAILABLE: Nested captures not supported
      #
      # Emulated `expr`.
      #-----------------------------------------------------
      fn_bs_lga_expr_re() { ## cSpell:Ignore BS_LGAER_
        BS_LGAER_Value="${1?'[libgetargs::fn_bs_lga_expr_re]: Internal Error: a value is required'}"
         BS_LGAER_Expr="${2:?'[libgetargs::fn_bs_lga_expr_re]: Internal Error: an expression is required'}"

        # Implementation depends on use of captures
        case ${BS_LGAER_Expr} in
        *'\('*)
            #-----------------------------------------------
            # Have Captures:= Match and Return
            #-----------------------------------------------

            # `expr` functions as if expression has a
            # trailing `.*$`, so make sure this is the
            # case for `sed`
            case ${BS_LGAER_Expr} in
            *[!$]) BS_LGAER_Expr="${BS_LGAER_Expr}.*\$" ;;
            esac

            # `sed` script: if text matches then replace
            # _all_ text with the outer capture and print;
            # no output if no match.
            #
            #  NOTE:
            # - empty match is indistinguishable from no
            #   match, but here that should not be an issue
            # - `sed` returns exit success except on error
            BS_LGAER_Match="$(
              {
                printf '%s\n' "${BS_LGAER_Value}"
              } | {
                sed -n -e "s/^${BS_LGAER_Expr}/\1/p"
              }
            )" || return $?

            # Write to `STDOUT` even on no match
            printf '%s\n' "${BS_LGAER_Match:-}"

            # Determine Exit Status
            case ${BS_LGAER_Match:+1} in
            1) return 0 ;;
            *) return 1 ;;
            esac
          ;; #< `case *'\('*)`

        *)  #-----------------------------------------------
            # No Captures:= Only Check For Match
            #-----------------------------------------------

            # Don't use >/dev/null as that is not
            # always possible (e.g. restricted shells),
            # and avoid the `grep` options that silence
            # output because they are not always available
            # (or don't work)
            #
            # IMPLEMENTATION NOTE:
            # - might actually be faster to use `sed` here
            BS_LGAER_IgnoredOutput="$(
                {
                  printf '%s\n' "${BS_LGAER_Value}"
                } | {
                  grep "^${BS_LGAER_Expr}"
                }
              )" || return $?
          ;; #< `case *)`
        esac #< `case ${BS_LGAER_Expr} in`
      }
  ;;  #< `case *:0)`
esac #< `case <expr usable> in`

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## HELPER COMMANDS
#.
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_unset_from_config`
#;
#; `unset` all the variables named in in an OPTION-CONFIG or OPERAND-CONFIG.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_unset_from_config <CONFIG>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CONFIG` \[in]
#;
#; : MUST be a valid configuration.
#; : An option or operand config as passed to
#;   the main `getargs` command.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Configuration is assumed to be valid, but this is not checked. An invalid
#;   configuration MAY cause this command to never terminate.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Both option and operand configurations use the same format for delimiting
#.   target variables, so either is accepted by this command.
#.
#_______________________________________________________________________________
fn_bs_lga_unset_from_config() { ## cSpell:Ignore BS_LGAUFC_
  BS_LGAUFC_Config="${1:?'[libgetargs::fn_bs_lga_unset_from_config]: Internal Error: a config is required'}"

  while : #< [ -n "${BS_LGAUFC_Config:+1}" ]
  do
    #> LOOP TEST ----------------------------------------
    case ${BS_LGAUFC_Config:+1} in 1) ;; *) break ;; esac #< [ -n "${BS_LGAUFC_Config:+1}" ]
    #> --------------------------------------------------

    # Remove the first `]` and everything before
    BS_LGAUFC_Variable="${BS_LGAUFC_Config#*\]}"
    # Remove the first `,` and everything after
    BS_LGAUFC_Variable="${BS_LGAUFC_Variable%%,*}"

    # Remaining config is everything after the first
    # `,` that follows at least one character
    BS_LGAUFC_Config="${BS_LGAUFC_Config#*?,}"

    # Check the variable name is good
    fn_bs_lga_validate_name "${BS_LGAUFC_Variable}" || return $?

    # Unset the variable
    eval "${BS_LGAUFC_Variable}=; unset ${BS_LGAUFC_Variable}" || return $?
  done
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_check_var_unset`
#;
#; Check if a given variable has been assigned as the result of processing an
#; OPTION or OPERAND.
#;
#; Maintains a record of variables that have been previously checked; every
#; variable passed is added to the record. Exit status will be `EX_DATAERR` if
#; the variable was already in the list of checked variables.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_check_var_unset <VARIABLE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VARIABLE` \[in:ref]
#;
#; : Name of the variable to check.
#; : MUST be a valid _POSIX.1_ name.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Internal variable record is reset on each call to `getargs`.
#; - This is necessary since the built-in shell checks for unset parameters
#;   can not be used as it's NOT an error if a variable specified in an
#;   OPTION-CONFIG or OPERAND-CONFIG is set (this is explicitly permitted as a
#;   way to set default values).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - `VARIABLE` is NOT validated; caller is assumed to have done this.
#.
#_______________________________________________________________________________
fn_bs_lga_check_var_unset() { ## cSpell:Ignore BS_LGACU_
  BS_LGACU_Variable="${1:?'[libgetargs::fn_bs_lga_check_var_unset]: Internal Error: a variable to test is required'}"

  # Check if the variable has been set
  case ,${g_BS_LGA__AssignedVariables}, in
  *",${BS_LGACU_Variable},"*) return "${c_BS_LGA__EX_DATAERR}" ;;
  esac

  # Store the variable as set
  g_BS_LGA__AssignedVariables="${g_BS_LGA__AssignedVariables},$1"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_safe_quote`
#;
#; Safely quote a value such that if it were to be used in an `eval` it would
#; remain a single value.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_safe_quote <VALUE> [<SUFFIX>]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE`
#;
#; : Value to quote.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#; : MUST be a single value.
#;
#; `SUFFIX`
#;
#; : An optional suffix to append to the quoted string
#;   OUTSIDE the quotes, but prior to any `\n` (`<newline>`).
#; : Used to create a value suitable for an array.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Quotes the given string in the safest way possible, ensuring the value is
#;   preserved exactly as is. `SUFFIX` is provided so this can be used for both
#;   simple quoting, or creating array values while remaining as efficient as
#;   possible.
#;
#_______________________________________________________________________________
fn_bs_lga_safe_quote() { ## cSpell:Ignore BS_LGASQ_
  case $# in
  1)  BS_LGASQ_Value="$1"
     BS_LGASQ_Suffix=;    ;;
  2)  BS_LGASQ_Value="$1"
     BS_LGASQ_Suffix="$2" ;;
  esac

  #.........................................................
  # It is much faster to only invoke `sed` if required
  # to escape quote characters (even when taking into
  # account the cost of testing for the quote)
  #
  # NOTE:
  # - due to quoting rules for shells '\\\\' results
  #   in a single escape in the final string
  case ${BS_LGASQ_Value} in
    #.......................................................
    #> `case $BS_LGASQ_Value in`
    #> ------------
    #
    # Has `<apostrophe>` characters
    *"'"*)
      # Value contains `<apostrophe>` characters
      {
        printf '%s\n' "${BS_LGASQ_Value}"
      } | {
        # `sed` script:
        # - escape all `<apostrophe>` characters
        # - add a `<apostrophe>` character to the start
        #   of the value
        # - add a `<apostrophe>` to the end of the value
        #   and add the SUFFIX (which will either be empty
        #   or an escape sequence to escape the whitespace
        #   that must follow)
        #
        # NOTE:
        # - has to account for values that may
        #   contain `<newline>` characters
        sed -e "s/'/'\\\\''/g
                1s/^/'/
                \$s/\$/'${BS_LGASQ_Suffix}/"
      }
    ;;

    #.......................................................
    #> `case $BS_LGASQ_Value in`
    #> ------------
    #
    # No `<apostrophe>` characters
    *)  printf "'%s'${BS_LGASQ_Suffix}\n" "${BS_LGASQ_Value}" ;;
  esac #<: `case $1 in`
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_array_value`
#;
#; Create a single array element from a given value.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_array_value <VALUE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE`
#;
#; : Value to convert into an array value.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#; : MUST be a single value.
#;
#; _NOTES_
#; <!-- -->
#;
#; - More details about emulated shell arrays can be found in the documentation
#;   for [`libarray.sh`](./LIBARRAY.MD)
#;
#_______________________________________________________________________________
fn_bs_lga_array_value() { ## cSpell:Ignore BS_LGANAV_
  # SC1003: Want to escape a single quote? echo 'This is how it'\''s done'.
  # EXCEPT: Escape here is NOT for the quote character.
  # shellcheck disable=SC1003
  fn_bs_lga_safe_quote "${1?'[libgetargs::fn_bs_lga_array_value]: An array value is required'}" ' \\'
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_create_array`
#;
#; Create an emulated array from the given values.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_create_array [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE` \[in]
#;
#; : Can be specified multiple times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#; : Each value specified will become an array
#;   element.
#;
#; _NOTES_
#; <!-- -->
#;
#; - More details about emulated shell arrays can be found in the documentation
#;   for [`libarray.sh`](./LIBARRAY.MD)
#;
#_______________________________________________________________________________
fn_bs_lga_create_array() { ## cSpell:Ignore BS_LGACA_
  case $# in 0) return ;; esac #< Early out if nothing to do

  for BS_LGACA_Value
  do
    # SC1003: Want to escape a single quote? echo 'This is how it'\''s done'.
    # EXCEPT: Escape here is NOT for the quote character.
    # shellcheck disable=SC1003
    fn_bs_lga_safe_quote "${BS_LGACA_Value}" ' \\' || return $?
  done
  echo ' ' #<  Trailing whitespace is required
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_operands_to_options`
#;
#; Convert OPERANDs to OPTION & OPTION-ARGUMENT pairs, which enables easier
#; forwarding of OPERANDs to a subsequent command.
#;
#; The generated OPTIONs are written to `STDOUT` as an emulated array.
#;
#; More information can be found with
#; [`getargs_operands_to_options`](#getargs_operands_to_options), which this
#; command is used to implement.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_operands_to_options <OPTION> [<OPERAND>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `OPTION`
#;
#; : An OPTION name (used for each OPERAND).
#; : MUST have the appropriate '-' prefix.
#; : A trailing '=' causes the OPERAND to be appended to
#;   OPTION as a single value, otherwise a pair of an
#;   OPTION followed by the OPERAND is created.
#; : If OPTION is a single character OPTION any `=`
#;   (`<equals>`) is removed before the OPERAND is appended
#;   (this is more widely supported).
#;
#; `OPERAND`
#;
#; : Values to make OPTION-ARGUMENTs for `OPTION`.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#_______________________________________________________________________________
fn_bs_lga_operands_to_options() { ## cSpell:Ignore BS_LGAOTO_
  BS_LGAOTO_Option="${1:?'[libgetargs::fn_bs_lga_operands_to_options]: Internal Error: an option to append is required'}"
  shift

  case $# in 0) return ;; esac #< Early out if nothing to do

  case ${BS_LGAOTO_Option} in
  *=) #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Create a single OPTION & OPTION-ARGUMENT for
      # each operand
      #
      # Remove the `=` if the option is a short option as
      # the `-o=Value` syntax is not widely supported
      case ${BS_LGAOTO_Option} in
      -?=) BS_LGAOTO_Option="${BS_LGAOTO_Option%=}" ;;
      esac

      for BS_LGAOTO_Value
      do
        fn_bs_lga_array_value "${BS_LGAOTO_Option}${BS_LGAOTO_Value}" || return $?
      done ;;

  *)  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Create a an OPTION & OPTION-ARGUMENT pair for
      # each operand

      # Only need to convert the OPTION to an array value
      # once, then use that for every OPTION-ARGUMENT
      BS_LGAOTO_Option="$(fn_bs_lga_array_value "${BS_LGAOTO_Option}")" || return $?
      for BS_LGAOTO_Value
      do
        printf '%s\n' "${BS_LGAOTO_Option}"
        fn_bs_lga_array_value "${BS_LGAOTO_Value}" || return $?
      done ;;
  esac
  echo ' '  #< Trailing whitespace is required in either case
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_find_config`
#;
#; Find an OPTION in the OPTION-CONFIG and extract the details.
#;
#; Exit status will be zero only if the OPTION was located in the current
#; OPTION-CONFIG.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_find_config <OPTION> <TYPE> <VARIABLE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `OPTION` \[in]
#;
#; : The OPTION to search for.
#;
#; `TYPE` \[out:ref]
#;
#; : MUST be a valid _POSIX.1_ name
#; : Receives the OPTION type specified in the
#;   OPTION-CONFIG for `OPTION`.
#;
#; `VARIABLE` \[out:ref]
#;
#; : MUST be a valid _POSIX.1_ name
#; : Receives the target variable name specified in the
#;   OPTION-CONFIG for `OPTION`.
#;
#; _NOTES_
#; <!-- -->
#;
#; - If ambiguous OPTIONs are permitted, any ambiguous OPTION will use the first
#;   match, if they are not permitted the exit status will be `EX_DATAERR` if
#;   more than a single match is found.
#;
#_______________________________________________________________________________
fn_bs_lga_find_config() { ## cSpell:Ignore BS_LGAFC
       BS_LGAFC_Option="${1:?'[libgetargs::fn_bs_lga_find_config]: Internal Error: an option to match is required'}"
      BS_LGAFC_refType="${2:?'[libgetargs::fn_bs_lga_find_config]: Internal Error: a type output variable is required'}"
  BS_LGAFC_refVariable="${3:?'[libgetargs::fn_bs_lga_find_config]: Internal Error: a variable output variable is required'}"

  #---------------------------------------------------------
  # LONG-OPTIONs are indicated with a single `-`
  # (`<hyphen>`) prefix here, so remove it to get the
  # actual OPTION-ALIAS needing to be looked up.
  BS_LGAFC_OptionName="${BS_LGAFC_Option#-}"

  #---------------------------------------------------------
  # Build the "Basic Regular Expression" that will be used
  # to look up the OPTION. Regardless of the tool used to
  # perform the lookup, almost the entire expression will
  # be the same.
  BS_LGAFC_OptionRegExp="${BS_LGAFC_OptionName}"

  # OPTIONs are used as regular expressions, so MAY need
  # escaped to avoid errors. In most use cases this is
  # unlikely to be required, but it's impossible to know
  # in advance, and becomes particularly important if the
  # locale is not _POSIX.1_
  #
  # _NOTES_
  #
  # - Only safe way to escape a regular expression is to
  #   escape ALL characters that are not known to be safe.
  #   (This may result in some safe values being escaped.)
  # - Avoiding invoking the escaping is faster, even though
  #   it requires an additional check.
  case ${g_BS_LGA_CFG_AllowUnsafeOptions:-0}:${BS_LGAFC_OptionRegExp} in
  0:*[!${c_BS_LGA__re_ALNUM}_-]*)
    BS_LGAFC_OptionRegExp="$(
        {
          printf '%s\n' "${BS_LGAFC_OptionRegExp}"
        } | {
          sed -e "s/[^^${c_BS_LGA__re_ALNUM}_-]/[&]/g
                  s/\^/\\^/g"
        }
      )" ;;
  esac

  # A LONG-OPTION can be abbreviated, so need to allow
  # for extra characters. (SHORT-OPTIONs must always
  # match exactly.) A LONG-OPTION can be detected by a
  # single `-` (`<hyphen>`) prefix on the parameter
  # passed into this command.
  case ${g_BS_LGA_CFG_AllowAbbreviations:-0}${BS_LGAFC_Option} in
  1-*) BS_LGAFC_OptionRegExp="${BS_LGAFC_OptionRegExp}${c_BS_LGA__re_Alias_OtherChar}\{0,\}" ;;
  esac

  # Create the full regular expression
  BS_LGAFC_OptionRegExp="${c_BS_LGA__re_Option_MatchPrefix}${BS_LGAFC_OptionRegExp}${c_BS_LGA__re_Option_MatchSuffix}"

  #---------------------------------------------------------
  # Ambiguous OPTIONs are detected with `grep`, this is
  # slower but safer than ignoring ambiguous OPTIONs,
  # the alternative is to use `expr` which is faster, but
  # can not detect ambiguous OPTIONs.
  case ${g_BS_LGA_CFG_AllowAmbiguous:-0} in
  1)  # `expr` will extract the config that matches the
      # captured part of the regular expression which will
      # be the config for a single option. There is no easy
      # way to get `expr` to find ambiguous OPTIONs that
      # doesn't also negate the significant speed advantages
      # of using `expr`
      BS_LGAFC_OptionRegExp=".*,\(${BS_LGAFC_OptionRegExp}\),"
      {
        BS_LGAFC_Matched="$(
            fn_bs_lga_expr_re             \
              "${g_BS_LGA__OptionConfig}" \
              "${BS_LGAFC_OptionRegExp}"  2>&1
          )"
      } || {
        g_BS_LGA__UnrecognizedOption="Unrecognized option '${BS_LGAFC_OptionName}'"
        return "${c_BS_LGA__EX_DATAERR}"
      } ;;
  0)  # `grep` will return any matched config as a single
      # line containing the config for a single OPTION (or
      # multiple lines if the config was ambiguous).
      if  BS_LGAFC_Matched="$(
            {
              printf '%s\n' "${g_BS_LGA__OptionConfig}"
            } | {
              grep "^${BS_LGAFC_OptionRegExp}" 2>&1
            }
          )"
      then
        # Ambiguous options will return multiple matches,
        # easiest way to check for that is by looking for
        # a newline with characters before and after
        case ${BS_LGAFC_Matched} in
        *?"${c_BS_LGA__newline}"?*)
          fn_bs_lga_error "Ambiguous option '${BS_LGAFC_OptionName}'"
          return "${c_BS_LGA__EX_DATAERR}" ;;
        esac
      else
        g_BS_LGA__UnrecognizedOption="Unrecognized option '${BS_LGAFC_OptionName}'"
        return "${c_BS_LGA__EX_DATAERR}"
      fi ;;
  esac

  #---------------------------------------------------------
  # OPTION-CONFIG:
  #    <ALIAS_LIST> '[' <TYPE> ']' <VARIABLE>
  # where the first part is used only to find the correct
  # config, so can be discarded now
  BS_LGAFC_Matched="${BS_LGAFC_Matched#*\[}"

  # Extract the type (this is now the just the first
  # character, which is followed by a literal ']', so
  # remove that and everything after)
  #
  # NOTE: the calling function will validate this value
  BS_LGAFC_OptionType="${BS_LGAFC_Matched%]*}"

  # Extract the output variable (this is now the everything
  # after the ']' following the first character, so remove
  # both)
  BS_LGAFC_OptionVariable="${BS_LGAFC_Matched#?]}"

  # Verify the variable name is a valid value
  fn_bs_lga_validate_name "${BS_LGAFC_OptionVariable}" || return $?

  #---------------------------------------------------------
  # Save the found configuration
  eval "
        ${BS_LGAFC_refType}=\"\${BS_LGAFC_OptionType}\"
    ${BS_LGAFC_refVariable}=\"\${BS_LGAFC_OptionVariable}\"
  "
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_process_simple_option`
#;
#; Process a single OPTION (and any associated OPTION-ARGUMENT).
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_process_simple_option <USED> <OPTION> <TYPE> <VALUE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `USED` \[out:ref]
#;
#; : Variable to be set to indicate if `VALUE` was used as
#;   the OPTION-ARGUMENT for this `OPTION`.
#; : MUST be a valid _POSIX.1_ name.
#;
#; `OPTION` \[in]
#;
#; : OPTION to match.
#; : A single `-` (`<hyphen>`) prefix indicates this was a
#;   LONG-OPTION, no prefix indicates a SHORT-OPTION.
#;
#; `TYPE` \[in]
#;
#; : The type of `VALUE`.
#; : One of the `BS_LIBGETARGS_TYPE_*` constants:
#;   [`BS_LIBGETARGS_TYPE_OPT_ARG`](#bs_libgetargs_type_opt_arg),
#;   [`BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED`](#bs_libgetargs_type_opt_arg_delimited),
#;   [`BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE`](#bs_libgetargs_type_opt_arg_aggregate),
#;   or [`BS_LIBGETARGS_TYPE_OPERAND`](#bs_libgetargs_type_operand).
#;
#; `VALUE` \[in]
#;
#; : The OPTION-ARGUMENT to use for an OPTION that takes one.
#; : The `USED` output variable will be set if this is used.
#;
#_______________________________________________________________________________
fn_bs_lga_process_simple_option() { ## cSpell:Ignore BS_LGAPSO
  BS_LGAPSO_refValueUsed="${1:?'[libgetargs::fn_bs_lga_process_simple_option]: Internal Error: an output variable for params used is required'}"
        BS_LGAPSO_Option="${2:?'[libgetargs::fn_bs_lga_process_simple_option]: Internal Error: an option to match is required'}"
    BS_LGAPSO_OptArgType="${3?'[libgetargs::fn_bs_lga_process_simple_option]: Internal Error: a option-argument type is required'}"
        BS_LGAPSO_OptArg="${4?'[libgetargs::fn_bs_lga_process_simple_option]: Internal Error: a option-argument is required'}"

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Extract any OPTION-TAG (i.e. the value after any `:`
  # (`<colon>`) character in the option).
  #
  # NOTE:
  #
  # - OPTION-TAGs are only permitted from a specific set
  #   of possible values, but this is different for each
  #   option type and is dealt with later.
  BS_LGAPSO_HaveTag=0
  case ${BS_LGAPSO_Option} in
  *?':'*) BS_LGAPSO_OptionTag="${BS_LGAPSO_Option#*:}"
             BS_LGAPSO_Option="${BS_LGAPSO_Option%%:*}"
            BS_LGAPSO_HaveTag=1 ;;
  esac

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Lookup the OPTION-CONFIG
  BS_LGAPSO_OptionType=; BS_LGAPSO_refOptionVariable=;
  fn_bs_lga_find_config           \
    "${BS_LGAPSO_Option}"         \
    'BS_LGAPSO_OptionType'        \
    'BS_LGAPSO_refOptionVariable' || return $?

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Process the OPTION based on Type
  case ${BS_LGAPSO_OptionType} in
    #-------------------------------------------------------
    # Incrementing SWITCH-OPTION
    # Value:  No
    # Tag:    Integer >= 0
    "${c_BS_LGA__OptType_Switch}")
      #.................................
      # Error if a value was specified
      case ${BS_LGAPSO_OptArgType} in
      "${BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED}")
        fn_bs_lga_error "Option '${BS_LGAPSO_Option#-}' does not take a value"
        return "${c_BS_LGA__EX_DATAERR}" ;;
      esac

      #.................................
      # Check for & validate any tag
      case ${BS_LGAPSO_HaveTag} in
      0)  BS_LGAPSO_OptionTag=1 ;;
      1)  case ${BS_LGAPSO_OptionTag} in
          *[!0123456789]*)
            fn_bs_lga_error "Invalid tag '${BS_LGAPSO_OptionTag}' for option '${BS_LGAPSO_Option#-}'"
            return "${c_BS_LGA__EX_DATAERR}" ;;
          esac ;;
      esac

      #.................................
      # Increment and Save
      eval "
                       BS_LGAPSO_OptArg=\"\${${BS_LGAPSO_refOptionVariable}:-0}\"
        ${BS_LGAPSO_refOptionVariable}=\$((BS_LGAPSO_OptArg + BS_LGAPSO_OptionTag))
             ${BS_LGAPSO_refValueUsed}=0
      " || return $?
    ;;

    #-------------------------------------------------------
    # Negatable SWITCH-OPTION
    # Value:  No
    # Tag:    'true' or 'false'
    "${c_BS_LGA__OptType_NegatableSwitch}")
      #.................................
      #  Error if a value was specified
      case ${BS_LGAPSO_OptArgType} in
      "${BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED}")
        fn_bs_lga_error "Option '${BS_LGAPSO_Option#-}' does not take a value"
        return "${c_BS_LGA__EX_DATAERR}" ;;
      esac

      #.................................
      #  Check for & validate any tag
      case ${BS_LGAPSO_HaveTag} in
      0)  BS_LGAPSO_OptionTag="${BS_LIBGETARGS_CONFIG_TRUE_VALUE}" ;;
      1)  case ${BS_LGAPSO_OptionTag} in
          "${BS_LIBGETARGS_CONFIG_FALSE_VALUE}"|"${BS_LIBGETARGS_CONFIG_TRUE_VALUE}") ;;
          *)  fn_bs_lga_error "Invalid tag '${BS_LGAPSO_OptionTag}' for option '${BS_LGAPSO_Option#-}'"
              return "${c_BS_LGA__EX_DATAERR}" ;;
          esac ;;
      esac

      #.................................
      #  Save the value
      eval "
        ${BS_LGAPSO_refOptionVariable}=\"\${BS_LGAPSO_OptionTag}\"
             ${BS_LGAPSO_refValueUsed}=0
      " || return $?
    ;;

    #-------------------------------------------------------
    # Optional OPTION-ARGUMENT OPTION
    # Value:  Optional
    # Tag:    No
    "${c_BS_LGA__OptType_OptArg_Optional}")
      #.................................
      # Error if a tag was specified
      case ${BS_LGAPSO_HaveTag} in
      1)  fn_bs_lga_error "Option '${BS_LGAPSO_Option#-}' can not be specified with a tag ('${BS_LGAPSO_OptionTag}')"
          return "${c_BS_LGA__EX_DATAERR}" ;;
      esac

      #.................................
      # Optional Value Options can only
      # be set once
      fn_bs_lga_check_var_unset "${BS_LGAPSO_refOptionVariable}" || {
        fn_bs_lga_error "Multiple values for single value option '${BS_LGAPSO_Option#-}'"
        return "${c_BS_LGA__EX_DATAERR}"
      }

      #.................................
      # Optional values need to use an
      # aggregate value or they have no
      # value
      case ${BS_LGAPSO_OptArgType} in
      "${BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED}") BS_LGAPSO_OptArgUsed=1 ;;
      "${BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE}") BS_LGAPSO_OptArgUsed=1 ;;
      *)  BS_LGAPSO_OptArgUsed=0
              BS_LGAPSO_OptArg="${BS_LIBGETARGS_CONFIG_OPTIONAL_VALUE-}" ;;
      esac

      #.................................
      # Validate the value
      case ${g_BS_LGA_CFG_fn_Validator:+1} in
      1)  "${g_BS_LGA_CFG_fn_Validator}"     \
            "${BS_LGAPSO_refOptionVariable}" \
            "${BS_LGAPSO_Option#-}"          \
            "${BS_LGAPSO_OptArgType}"        \
            "${BS_LGAPSO_OptArg}"      >&2   || {
              ec_fn_bs_user_validator=$?
              fn_bs_lga_error "Invalid value '${BS_LGAPSO_OptArg}' for target variable '${BS_LGAPSO_refOptionVariable}'"
              return ${ec_fn_bs_user_validator}
            } ;;
      esac

      #.................................
      # Save the value
      eval "
        ${BS_LGAPSO_refOptionVariable}=\"\${BS_LGAPSO_OptArg}\"
             ${BS_LGAPSO_refValueUsed}=\${BS_LGAPSO_OptArgUsed}
      " || return $?
    ;;

    #-------------------------------------------------------
    # Single OPTION-ARGUMENT OPTION &
    # Resettable OPTION-ARGUMENT OPTION
    #
    # Value:  Yes
    # Tag:    No
    "${c_BS_LGA__OptType_OptArg}"|"${c_BS_LGA__OptType_OptArg_Resettable}")
      #.................................
      # Error if a tag was specified
      case ${BS_LGAPSO_HaveTag} in
      1) fn_bs_lga_error "Option '${BS_LGAPSO_Option#-}' can not be specified with a tag ('${BS_LGAPSO_OptionTag}')"
         return "${c_BS_LGA__EX_DATAERR}" ;;
      esac

      #.................................
      # A value is required
      case ${BS_LGAPSO_OptArgType:-0} in
      0) fn_bs_lga_error "Expected a value for option '${BS_LGAPSO_Option#-}'"
         return "${c_BS_LGA__EX_DATAERR}" ;;
      esac

      #.................................
      # Single Value Options can only
      # be set once
      case ${BS_LGAPSO_OptionType} in
      "${c_BS_LGA__OptType_OptArg}")
        fn_bs_lga_check_var_unset "${BS_LGAPSO_refOptionVariable}" || {
          fn_bs_lga_error "Multiple values for single value option '${BS_LGAPSO_Option#-}'"
          return "${c_BS_LGA__EX_DATAERR}"
        }
      ;;
      esac

      #...............................
      # Validate the value
      case ${g_BS_LGA_CFG_fn_Validator:+1} in
      1)  "${g_BS_LGA_CFG_fn_Validator}"     \
            "${BS_LGAPSO_refOptionVariable}" \
            "${BS_LGAPSO_Option#-}"          \
            "${BS_LGAPSO_OptArgType}"        \
            "${BS_LGAPSO_OptArg}"      >&2   || {
              ec_fn_bs_user_validator=$?
              fn_bs_lga_error "Invalid value '${BS_LGAPSO_OptArg}' for target variable '${BS_LGAPSO_refOptionVariable}'"
              return ${ec_fn_bs_user_validator}
            } ;;
      esac

      #.................................
      # Save the value
      eval "
        ${BS_LGAPSO_refOptionVariable}=\"\${BS_LGAPSO_OptArg}\"
             ${BS_LGAPSO_refValueUsed}=1
      " || return $?
    ;;

    #-------------------------------------------------------
    # Multiple OPTION-ARGUMENT OPTION
    # Value:  Yes
    # Tag:    'array', 'passthrough', 'passthru', 'forward'
    "${c_BS_LGA__OptType_OptArg_Multiple}")
      #.................................
      #  A value is required
      case ${BS_LGAPSO_OptArgType:-0} in
      0) fn_bs_lga_error "Expected a value for option '${BS_LGAPSO_Option#-}'"
         return "${c_BS_LGA__EX_DATAERR}" ;;
      esac

      #.................................
      # A tag is permitted and changes
      # processing
      case ${BS_LGAPSO_HaveTag} in
      0)
        # Validate the value
        case ${g_BS_LGA_CFG_fn_Validator:+1} in
        1)  "${g_BS_LGA_CFG_fn_Validator}"     \
              "${BS_LGAPSO_refOptionVariable}" \
              "${BS_LGAPSO_Option#-}"          \
              "${BS_LGAPSO_OptArgType}"        \
              "${BS_LGAPSO_OptArg}"      >&2   || {
                ec_fn_bs_user_validator=$?
                fn_bs_lga_error "Invalid value '${BS_LGAPSO_OptArg}' for target variable '${BS_LGAPSO_refOptionVariable}'"
                return ${ec_fn_bs_user_validator}
              } ;;
        esac
        BS_LGAPSO_OptArg="$(fn_bs_lga_create_array "${BS_LGAPSO_OptArg}")"
      ;;
      1)  # Validate the tag
          case ${BS_LGAPSO_OptionTag} in
          'array'|'passthrough'|'passthru'|'forward') ;;
          # Everything else is an error
          *) fn_bs_lga_error "Invalid tag '${BS_LGAPSO_OptArg}' in option '${BS_LGAPSO_Option#-}'"
             return "${c_BS_LGA__EX_DATAERR}" ;;
          esac

          # Value is already an array
          # (appended as is) or an array
          # reference (dereferenced then
          # appended)
          #
          # Arrays are always quoted with
          # single quotes, while references
          # SHOULD be unquoted
          case ${BS_LGAPSO_OptArg} in
          "'"*) ;;
             *) # Verify the variable name is a valid value
                fn_bs_lga_validate_name "${BS_LGAPSO_OptArg}" || return $?

                eval "BS_LGAPSO_OptArg=\"\${${BS_LGAPSO_OptArg}}\"" || return $? ;;
          esac
      ;;
      esac

      #.................................
      # Save the value (preserving
      # existing values)
      eval "
        ${BS_LGAPSO_refOptionVariable}=\"\${${BS_LGAPSO_refOptionVariable}-}\${BS_LGAPSO_OptArg}\"
             ${BS_LGAPSO_refValueUsed}=1
      " || return $?
    ;;

    #-------------------------------------------------------
    # Error
    *) fn_bs_lga_error "Invalid option type '${BS_LGAPSO_OptionType}' (option '${BS_LGAPSO_Option#-}', option variable '${BS_LGAPSO_refOptionVariable}')"
       return "${c_BS_LGA__EX_CONFIG}" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_process_complex_option`
#;
#; Process an OPTION (and any associated OPTION-ARGUMENT) where the OPTION may
#; be a single OPTION, or a COMPOUND-OPTION.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_process_complex_option <USED> <OPTION> <TYPE> <VALUE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `USED` \[out:ref]
#;
#; : Variable to be set to indicate if `VALUE` was used as
#;   the OPTION-ARGUMENT for this `OPTION`.
#; : MUST be a valid _POSIX.1_ name.
#;
#; `OPTION` \[in]
#;
#; : OPTION to match.
#; : A single `-` (`<hyphen>`) prefix indicates this was a
#;   LONG-OPTION, no prefix indicates a SHORT-OPTION.
#;
#; `TYPE` \[in]
#;
#; : The type of `VALUE`.
#; : One of the `BS_LIBGETARGS_TYPE_*` constants:
#;   [`BS_LIBGETARGS_TYPE_OPT_ARG`](#bs_libgetargs_type_opt_arg),
#;   [`BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED`](#bs_libgetargs_type_opt_arg_delimited),
#;   [`BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE`](#bs_libgetargs_type_opt_arg_aggregate),
#;   or [`BS_LIBGETARGS_TYPE_OPERAND`](#bs_libgetargs_type_operand).
#;
#; `VALUE` \[in]
#;
#; : The OPTION-ARGUMENT to use for an OPTION that takes one.
#; : The `USED` output variable will be set if this is used.
#;
#; _NOTES_
#; <!-- -->
#;
#; - COMPOUND-OPTIONs and _POSIX.1_ style LONG-OPTIONs are BOTH OPTIONs with
#;   multiple characters following a single `-` (`<hyphen>`) character, in
#;   addition a SHORT-OPTION can also be followed by an OPTION-ARGUMENT with no
#;   delimiting character(s) and will also match this general format. To handle
#;   all these different formats requires checking if a single `-` (`<hyphen>`)
#;   OPTION matches each in turn, making matches slower than other types of
#;   OPTION.
#; - Assuming all ARGUMENTs are valid, _POSIX.1_ style LONG-OPTIONs are as fast
#;   to match as normal LONG-OPTIONs, however if used along with other forms of
#;   single `-` (`<hyphen>`) OPTIONs with multiple characters, performance WILL
#;   be lower. It is advisable to use _either_ _POSIX.1_ style LONG-OPTIONs _or_
#;   other single `-` (`<hyphen>`) OPTIONs with multiple characters, but not
#;   both.
#;
#_______________________________________________________________________________
fn_bs_lga_process_complex_option() { ## cSpell:Ignore BS_LGAPCO_
  BS_LGAPCO_refValueUsed="${1:?'[libgetargs::fn_bs_lga_process_complex_option]: Internal Error: an output variable for params used is required'}"
        BS_LGAPCO_Option="${2:?'[libgetargs::fn_bs_lga_process_complex_option]: Internal Error: an option to match is required'}"
    BS_LGAPCO_OptArgType="${3?'[libgetargs::fn_bs_lga_process_complex_option]: Internal Error: a option-argument type is required'}"
        BS_LGAPCO_OptArg="${4?'[libgetargs::fn_bs_lga_process_complex_option]: Internal Error: a option-argument is required'}"

  #---------------------------------------------------------
  # Check for a LONG-OPTION match first - the whole
  # value must match a LONG-OPTION or it must be
  # one of the other formats.
  case ${g_BS_LGA_CFG_AllowPOSIXLong:-0} in
  1)  if  fn_bs_lga_process_simple_option \
            "${BS_LGAPCO_refValueUsed}"   \
            "${BS_LGAPCO_Option}"         \
            "${BS_LGAPCO_OptArgType}"     \
            "${BS_LGAPCO_OptArg}"
      then
        return
      else
        ec_process_compound_option=$?
        case ${g_BS_LGA__UnrecognizedOption:+1} in
        1) g_BS_LGA__UnrecognizedOption=;       ;; #< No true error
        *) return ${ec_process_compound_option} ;; #< Some error
        esac
      fi ;;
  esac #< case ${g_BS_LGA_CFG_AllowPOSIXLong:-0} in
  #---------------------------------------------------------

  #---------------------------------------------------------
  # Remove the prefix
  BS_LGAPCO_Option="${BS_LGAPCO_Option#-}"
  #---------------------------------------------------------

  #---------------------------------------------------------
  # While there are still characters available...
  while : #< [ -n "${BS_LGAPCO_Option:+1}" ]
  do
    #> LOOP TEST -------------------------------------------
    case ${BS_LGAPCO_Option:+1} in 1) ;; *) break ;; esac #< [ -n "${BS_LGAPCO_Option:+1}" ]
    #> -----------------------------------------------------

    #.......................................................
    # Split the OPTION
    BS_LGAPCO_Remaining="${BS_LGAPCO_Option#?}"
    case ${BS_LGAPCO_Remaining:+1} in
    1)  # BS_LGAPCO_Remaining is _not_ empty, a
        # value (if required) _must_ be whatever
        # is left in the COMPOUND-OPTION.

        #---------------------------------------------------
        # Getting just the first character of a
        # _POSIX.1_ parameter is annoyingly cumbersome,
        # and potentially not highly portable,
        # especially given the quoting requirements
        # (multiple quotes often seem the cause of
        #  portability issues).
        BS_LGAPCO_ShortOption="${BS_LGAPCO_Option%"${BS_LGAPCO_Remaining}"}"
        #---------------------------------------------------

        #---------------------------------------------------
        # If a delimited option was extracted
        # earlier this could be part of a
        # non-delimited OPTION-ARGUMENT, so append
        # it again
        case ${BS_LGAPCO_OptArgType} in
        "${BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED}")
            BS_LGAPCO_CompoundValue="${BS_LGAPCO_Remaining}${BS_LGAPCO_OptArg:+=${BS_LGAPCO_OptArg}}" ;;
        *) BS_LGAPCO_CompoundValue="${BS_LGAPCO_Remaining}" ;;
        esac
        #---------------------------------------------------

        #---------------------------------------------------
        # Process the OPTION
        BS_LGAPCO_CompoundValueUsed=0
        fn_bs_lga_process_simple_option             \
          'BS_LGAPCO_CompoundValueUsed'             \
          "${BS_LGAPCO_ShortOption}"                \
          "${BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE}" \
          "${BS_LGAPCO_CompoundValue}"              || return $?
        #---------------------------------------------------

        #---------------------------------------------------
        # If a value has been used, processing is
        # done, otherwise loop round again with the
        # processed SHORT-OPTION removed
        case ${BS_LGAPCO_CompoundValueUsed} in
        0) BS_LGAPCO_Option="${BS_LGAPCO_Remaining}" ;;
        1) break ;;
        esac
        #---------------------------------------------------
    ;;

    *)  #---------------------------------------------------
        # BS_LGAPCO_Remaining is empty, any value
        # must be the next argument (if it exists),
        # if used it will be shifted later
        fn_bs_lga_process_simple_option \
          "${BS_LGAPCO_refValueUsed}"   \
          "${BS_LGAPCO_Option}"         \
          "${BS_LGAPCO_OptArgType}"     \
          "${BS_LGAPCO_OptArg}"         || return $?
        #---------------------------------------------------
        break
    ;;

    esac #< `case ${BS_LGAPCO_Remaining:+1} in`
    #.......................................................
  done #< `while [ -n "${BS_LGAPCO_Option:+1}" ]`
  #---------------------------------------------------------
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_process_operand`
#;
#; Process one (or more) OPERAND(s).
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_process_operand <TYPE> <OPERAND>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `TYPE` \[in]
#;
#; : A value indicating how the OPERAND(s) were matched:
#;   a `--` if the OPERAND delimiter has been found, a `-`
#;   (`<hyphen>`) if this is an unmatched OPTION, and null
#;   (aka the empty string) for an OPERAND matched in any
#;   other way.
#; : Passed to any VALIDATOR.
#;
#; `OPERAND` \[in]
#;
#; : One or more OPERANDs to process.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - If
#;   [`BS_LIBGETARGS_CONFIG_STRICT_OPERANDS`](#bs_libgetargs_config_strict_operands)
#;   is _ON_, then `TYPE` is always `--`.
#; - Unmatched OPTIONs only occur if
#;   [`BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`](#bs_libgetargs_config_allow_unmatched)
#;   is _ON_.
#;
#_______________________________________________________________________________
fn_bs_lga_process_operand() { ## cSpell:Ignore BS_LGAPO_
  BS_LGAPO_OperandOption="${1?'[libgetargs::fn_bs_lga_process_operand]: Internal Error: an operand option value is required'}"
  shift

  #---------------------------------------------------------
  # Process each user OPERAND
  # (uses `while` as values may be consumed more
  #  than one at a time)
  while : #< [ $# -gt 0 ]
  do
    #> LOOP TEST -------------------------------------------
    case $# in 0) break ;; esac #< [ $# -gt 0 ]
    #> -----------------------------------------------------

    #-------------------------------------------------------
    # Store current ARGUMENT for error reporting
    #-------------------------------------------------------
    g_BS_LGA__CurrentArgument="$1"

    #-------------------------------------------------------
    # No remaining OPERAND-CONFIG, but still have OPERANDs
    #-------------------------------------------------------
    case ${g_BS_LGA__OperandConfig:+1} in
    1)  ;;
    *)  fn_bs_lga_error "Unexpected OPERAND(s): " "$@"
        return "${c_BS_LGA__EX_DATAERR}" ;;
    esac

    #-------------------------------------------------------
    # Extract the next OPERAND-CONFIG
    #
    # Config format:
    #    '[' <TYPE> ']' <VARIABLE>
    #-------------------------------------------------------
    BS_LGAPO_OperandConfig="${g_BS_LGA__OperandConfig%%,*}"

    # Extract the output variable name
    # (everything after the ']')
    BS_LGAPO_refOutput="${BS_LGAPO_OperandConfig#*\]}"

    # Verify the variable name is a valid value
    fn_bs_lga_validate_name "${BS_LGAPO_refOutput}" || return $?

    # Extract the Operand Type
    # (the character inside the square brackets)
    BS_LGAPO_OperandType="${BS_LGAPO_OperandConfig%\]*}"
    BS_LGAPO_OperandType="${BS_LGAPO_OperandType#\[}"

    #-------------------------------------------------------
    # Deal with the OPERAND-CONFIG TYPE
    #-------------------------------------------------------
    case ${BS_LGAPO_OperandType} in
      #.....................................................
      # SINGLE-VALUE OPERAND
      #  - can only be set once
      # &
      # SKIPPABLE-VALUE OPERAND
      #  - used if unset
      #  - if set skip to the next OPERAND-CONFIG
      "${c_BS_LGA__re_OperandType_Single}"|"${c_BS_LGA__re_OperandType_Skippable}")
        # Single use OPERAND-CONFIG, so remove it
        # from the available OPERAND-CONFIGS
        g_BS_LGA__OperandConfig="${g_BS_LGA__OperandConfig#*,}"

        # This OPERAND-CONFIG TYPE is only allowed to be
        # set once; if unset use it, if set then either an
        # error or skip this OPERAND-CONFIG and try the
        # next OPERAND-CONFIG with the _same_ OPERAND
        if fn_bs_lga_check_var_unset "${BS_LGAPO_refOutput}"; then
          # Validate the value
          case ${g_BS_LGA_CFG_fn_Validator:+1} in
          1)  "${g_BS_LGA_CFG_fn_Validator}"    \
                "${BS_LGAPO_refOutput}"         \
                "${BS_LGAPO_OperandOption}"     \
                "${BS_LIBGETARGS_TYPE_OPERAND}" \
                "$1"              >&2           || {
                  ec_fn_bs_user_validator=$?
                  fn_bs_lga_error "Invalid value '$1' for OPERAND target variable '${BS_LGAPO_refOutput}'"
                  return ${ec_fn_bs_user_validator}
                } ;;
          esac

          eval "${BS_LGAPO_refOutput}=\"\$1\"" || return $?
          shift # Only `shift` when a value is used
        else
          # Error for SINGLE-VALUE OPERAND only
          case ${BS_LGAPO_OperandConfig} in
          "${c_BS_LGA__re_OperandType_Single}")
            fn_bs_lga_error "Multiple values for single value variable '${BS_LGAPO_refOutput}'"
            return "${c_BS_LGA__EX_DATAERR}" ;;
          esac
        fi
      ;;

      #.....................................................
      # RESETTABLE-VALUE OPERAND
      #  - will always be set, only the final value will be
      #    available
      "${c_BS_LGA__re_OperandType_Resettable}")
        # Single use OPERAND-CONFIG, so remove it
        # from the available OPERAND-CONFIGS
        g_BS_LGA__OperandConfig="${g_BS_LGA__OperandConfig#*,}"

        # Validate the value
        case ${g_BS_LGA_CFG_fn_Validator:+1} in
        1)  "${g_BS_LGA_CFG_fn_Validator}"    \
              "${BS_LGAPO_refOutput}"         \
              "${BS_LGAPO_OperandOption}"     \
              "${BS_LIBGETARGS_TYPE_OPERAND}" \
              "$1"              >&2           || {
                ec_fn_bs_user_validator=$?
                fn_bs_lga_error "Invalid value '$1' for OPERAND target variable '${BS_LGAPO_refOutput}'"
                return ${ec_fn_bs_user_validator}
              } ;;
        esac

        # Save
        eval "${BS_LGAPO_refOutput}=\"\$1\"" || return $?
        shift
      ;;

      #.....................................................
      # MULTIPLE-VALUE OPERAND
      # - will always be set; all values will be kept
      #
      # NOTE:
      # - This must be the last OPERAND-CONFIG and will
      #   always consume all remaining OPERANDs
      "${c_BS_LGA__re_OperandType_Multiple}")
        #  Validate all remaining values
        case ${g_BS_LGA_CFG_fn_Validator:+1} in
        1)  for BS_LGAPO_OptArg
            do
              "${g_BS_LGA_CFG_fn_Validator}"    \
                "${BS_LGAPO_refOutput}"         \
                "${BS_LGAPO_OperandOption}"     \
                "${BS_LIBGETARGS_TYPE_OPERAND}" \
                "${BS_LGAPO_OptArg}"    >&2     || {
                  ec_fn_bs_user_validator=$?
                  fn_bs_lga_error "Invalid value '${BS_LGAPO_OptArg}' for OPERAND target variable '${BS_LGAPO_refOutput}'"
                  return ${ec_fn_bs_user_validator}
                }
            done ;;
        esac
        # Save all remaining OPERANDs
        BS_LGAPO_Output="$(fn_bs_lga_create_array "$@")"
        eval "${BS_LGAPO_refOutput}=\"\${${BS_LGAPO_refOutput}-}\${BS_LGAPO_Output}\"" || return $?
        break #< no more OPERANDs to process
      ;;

      #.....................................................
      # Error
      *) fn_bs_lga_error "Invalid operand type '${BS_LGAPO_OperandType}' (operand variable '${BS_LGAPO_refOutput}')"
         return "${c_BS_LGA__EX_CONFIG}" ;;
    esac
  done #< while [ $# -gt 0 ]

  #---------------------------------------------------------
  # Clear the currently processed argument
  #---------------------------------------------------------
  g_BS_LGA__CurrentArgument=;
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_process_arguments`
#;
#; Process all ARGUMENT(s).
#;
#; This is the main processing function for the library, the entry point command
#; performs initialization and configuration validation before invoking this to
#; do the desired work.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_process_arguments <ARGUMENT>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `ARGUMENT` \[in]
#;
#; : One or more ARGUMENTs to process.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Due to the complexities of passing the large number of state variables to
#;   all required functions, state and configuration are stored in global
#;   variables.
#;
#_______________________________________________________________________________
fn_bs_lga_process_arguments() { ## cSpell:Ignore BS_LGAPA
  #---------------------------------------------------------
  # Initialization:
  #---------------------------------------------------------
  BS_LGAPA_OperandOption=;

  # Setting this to a known `0` or `1`
  # simplifies the check in the loop.
  case ${g_BS_LGA_CFG_AutoHelp:+1} in
  1) BS_LGAPA_AutoHelpEnabled=1 ;;
  *) BS_LGAPA_AutoHelpEnabled=0 ;;
  esac

  #---------------------------------------------------------
  # Loop over all ARGUMENTs
  #---------------------------------------------------------
  while : #< [ $# -gt 0 ]
  do
    #> LOOP TEST -------------------------------------------
    case $# in 0) break ;; esac #< [ $# -gt 0 ]
    #> -----------------------------------------------------

    #-------------------------------------------------------
    # Loop initialization:
    #-------------------------------------------------------
    g_BS_LGA__CurrentArgument="$1" #< Store current ARGUMENT for error reporting
          BS_LGAPA_OptArgUsed=0    #< Any OPTION-ARGUMENT is unused

    #-------------------------------------------------------
    # Get the OPTION
    #-------------------------------------------------------
    case ${BS_LGAPA_AutoHelpEnabled}${g_BS_LGA_CFG_AllowPOSIXLong}:${g_BS_LGA__CurrentArgument} in
      #.....................................................
      # STOP: Consume any 'stop' value and break the loop
      ??:'--')
        BS_LGAPA_OperandOption='--'
        shift
        break
      ;;

      #.....................................................
      # Process auto-help
      1?:'--help'|11:'-help'|1?:'-h')
        fn_bs_lga_auto_help
        return 1
      ;;

      #.....................................................
      # Get the OPTION and any potential OPTION-ARGUMENT
      #
      # Values found may not be used, and are verified
      # when OPTION-TYPE is known (can't do more here)
      *'='*)
        BS_LGAPA_OptArgType="${BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED}"
            BS_LGAPA_OptArg="${g_BS_LGA__CurrentArgument#*=}"
            BS_LGAPA_Option="${g_BS_LGA__CurrentArgument%%=*}"
      ;;

      *)
        BS_LGAPA_Option="${g_BS_LGA__CurrentArgument}"
        case $# in
        1)  BS_LGAPA_OptArgType=;
                BS_LGAPA_OptArg=; ;;
        *)  BS_LGAPA_OptArgType="${BS_LIBGETARGS_TYPE_OPT_ARG}"
                BS_LGAPA_OptArg="$2" ;;
        esac
      ;;
    esac #< `case ${BS_LGAPA_AutoHelpEnabled}${g_BS_LGA_CFG_AllowPOSIXLong}:${g_BS_LGA__CurrentArgument} in`

    #-------------------------------------------------------
    # Process the OPTION
    #-------------------------------------------------------
    case ${BS_LGAPA_Option} in #< `shift` after `case`
      #.....................................................
      # Process "simple" OPTIONs:
      # - single SHORT-OPTIONs (with possible TAG)
      # - explicit LONG-OPTIONs (i.e. prefixed with '--')
      '-'[!-]|'-'[!-][:]*|'--'[!-]?*)
        #---------------------------------------------------
        # Remove a single '-' character, this allows
        # LONG-OPTIONs to be distinguished from
        # SHORT-OPTIONs in later processing
        #---------------------------------------------------
        BS_LGAPA_Option="${BS_LGAPA_Option#-}"

        #---------------------------------------------------
        # Process the OPTION
        #---------------------------------------------------
        {
          fn_bs_lga_process_simple_option \
            'BS_LGAPA_OptArgUsed'         \
            "${BS_LGAPA_Option}"          \
            "${BS_LGAPA_OptArgType}"      \
            "${BS_LGAPA_OptArg}"
        } || {
          ec_fn_bs_lga_process_arguments=$?
          case ${g_BS_LGA_CFG_AllowUnmatched:-0} in
          1)  fn_bs_lga_process_operand        \
                '-'                            \
                "${g_BS_LGA__CurrentArgument}" || return $? ;;
          *)  return ${ec_fn_bs_lga_process_arguments} ;;
          esac
        }
      ;;

      #.....................................................
      # Process "complex" OPTIONs:
      # - multiple SHORT-OPTIONs in a single ARGUMENT
      # - SHORT-OPTIONs followed immediately by an
      #   OPTION-ARGUMENT
      # - _POSIX.1_ compliant LONG-OPTIONS (multiple
      #   characters following a single '-')
      '-'[!-]?*)
        #---------------------------------------------------
        # Process the OPTION
        #---------------------------------------------------
        {
          fn_bs_lga_process_complex_option   \
                    'BS_LGAPA_OptArgUsed'    \
                    "${BS_LGAPA_Option}"     \
                    "${BS_LGAPA_OptArgType}" \
                    "${BS_LGAPA_OptArg}"
        } || {
          ec_fn_bs_lga_process_arguments=$?
          case ${g_BS_LGA_CFG_AllowUnmatched:-0} in
          1)  fn_bs_lga_process_operand        \
                '-'                            \
                "${g_BS_LGA__CurrentArgument}" || return $? ;;
          *) return ${ec_fn_bs_lga_process_arguments} ;;
          esac
        }
      ;;

      #.....................................................
      # Process OPERANDs
      *)
        #---------------------------------------------------
        # In "strict" mode, OPERANDs must be preceded by
        # the special ARGUMENT '--'
        #---------------------------------------------------
        case ${g_BS_LGA_CFG_StrictOperands:-0} in
        1)  fn_bs_lga_error "Unexpected OPERAND: " "${g_BS_LGA__CurrentArgument}"
            return "${c_BS_LGA__EX_DATAERR}" ;;
        esac

        #---------------------------------------------------
        # If "interleaved" OPERANDs are _not_ enabled then
        # the first OPERAND signals the end of OPTIONs and
        # the start of OPERANDs. (For performance reasons,
        # OPERANDs are processed together outside the
        # OPTION processing loop when possible.)
        #---------------------------------------------------
        case ${g_BS_LGA_CFG_InterleavedOperands:-0} in
        0) break ;;
        1) fn_bs_lga_process_operand       \
            "${BS_LGAPA_OperandOption}"    \
            "${g_BS_LGA__CurrentArgument}" || return $? ;;
        esac
      ;;
    esac #< `case ${BS_LGAPA_Option} in`

    #-------------------------------------------------------
    # SHIFT
    #
    # Either `shift` 1 or 2 ARGUMENTs depending on the
    # number of values used.
    #-------------------------------------------------------
    shift
    case ${BS_LGAPA_OptArgUsed}${BS_LGAPA_OptArgType} in
    "1${BS_LIBGETARGS_TYPE_OPT_ARG}") shift ;;
    esac
  done #< `while [ $# -gt 0 ]`

  #---------------------------------------------------------
  # Clear the current argument
  #---------------------------------------------------------
  g_BS_LGA__CurrentArgument=;

  #---------------------------------------------------------
  # Done if no more arguments
  #---------------------------------------------------------
  case $# in 0) return ;; esac

  #---------------------------------------------------------
  # Deal with any remaining OPERANDs
  #
  # BS_LGAPA_OperandOption contains the OPERAND delimiter
  # `--` if it was specified, or is empty otherwise. This
  # value is passed to the validator function to allow
  # different processing for OPERANDs explicitly defined
  # as such.
  #---------------------------------------------------------
  fn_bs_lga_process_operand     \
    "${BS_LGAPA_OperandOption}" \
    "$@"                        || return $?
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_auto_help`
#;
#; Generate a help text from OPTION-CONFIG and OPERAND-CONFIG which can be
#; displayed in a terminal window.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_auto_help
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; NONE.
#;
#; _NOTES_
#; <!-- -->
#;
#; - This is likely to have some performance impact.
#; - The text is generated using a lengthy `awk` script which is based on
#;   the _POSIX.1-2008_ standard version of `awk` - this is `nawk` or new `awk`
#;   and the resulting script may not work with traditional `awk`
#;   implementations.
#; - The data used to generate the help text is assumed to be valid - most
#;   data is unchecked and in places where errors may be checked they are often
#;   just silently ignored. Invalid data will only cause errors in the help
#;   text, so is largely considered a user issue.
#;
#_______________________________________________________________________________
fn_bs_lga_auto_help() { ## cSpell:Ignore BS_LGAAH_
  #---------------------------------------------------------
  # Initialize
  #---------------------------------------------------------
  BS_LGAAH_Command="${g_BS_LGA__ID:-getargs}"
  case ${BS_LGAAH_Command} in
  'getargs') BS_LGAAH_Command='<command>' ;;
  esac

  BS_LGAAH_WrapColumns="${BS_LIBGETARGS_CONFIG_HELP_WRAP_COLUMNS-}"
  case ${BS_LGAAH_WrapColumns-} in
  [012345678]|*[!0123456789]*) BS_LGAAH_WrapColumns="${COLUMNS:-80}" ;;
  esac

  #---------------------------------------------------------
  # Generate the text
  #
  # _NOTES_
  #
  # - Multi-line input can only be used with `awk` via a
  #   pipe (and not variables), however other values can be
  #   set using variable assignments.
  # - Some of the required quoting in this script is
  #   confusing, but is correct!
  #
  #---------------------------------------------------------
  BS_LGAAH_Help="$(
    {
      printf '%s\n--\n%s\n'                   \
             "${g_BS_LGA__OptionConfigHelp}"  \
             "${g_BS_LGA__OperandConfigHelp}"
    } | {
      awk -v "c_strCommand=${BS_LGAAH_Command}"                                              \
          -v "c_nWrapColumns=${BS_LGAAH_WrapColumns-}"                                       \
          -v "c_strMultiOptionHelp=${BS_LIBGETARGS_CONFIG_HELP_MULTI_OPTION-}"               \
          -v "c_strMultiOperandHelp=${BS_LIBGETARGS_CONFIG_HELP_MULTI_OPERAND-}"             \
          -v "c_strAlternativeOperandHelp=${BS_LIBGETARGS_CONFIG_HELP_ALTERNATIVE_OPERAND-}" \
      '
        ########################################################################
        # # HELP TEXT GENERATOR SCRIPT
        #
        # This script takes `getargs` configuration and produces help text as
        # might be expected from a command given the `-h` or `--help` option.
        #
        # **This script assumes the given config is valid!**
        #
        # _NOTES_
        #
        # - The format of the help text is slightly unusual as it is difficult
        #   to automatically align text in the format help text often takes.
        # - _POSIX.1_ `awk` is somewhat limited, making many things difficult to
        #   do at all, let alone easily. (For example, arrays can _only_ be
        #   iterated over in a random order when using built-in functionality.)
        # - `awk` does not have a means of enforcing usage constraints for
        #   variables, so variable names here are given prefixes that indicate
        #   intended usage - this both helps document the code, but also means
        #   some errors can be spotted more easily.
        # - The script assumes the config is valid, if it is not at best the
        #   output will not look as nice, at worst the script may not terminate.
        # - Script is based on the _POSIX.1_ standard `awk`, meaning "new awk"
        #   (aka `nawk`), and may not function correctly for a traditional
        #   implementation.
        #
        ########################################################################

        ########################################################################
        # FUNCTIONS
        ########################################################################

        #_______________________________________________________________________
        # ## `bs_fn_trim_l`
        #
        # Remove whitespace from the start of a string.
        #
        # _ARGUMENTS_
        #
        # `strText`
        #
        # : Text to trim.
        #
        #_______________________________________________________________________
        function bs_fn_trim_l(strText) {
          sub(/^[ \t\n\v\f\r]{1,}/, "", strText)
        }
        
        #_______________________________________________________________________
        # ## `bs_fn_trim_r`
        #
        # Remove whitespace from the end of a string.
        #
        # _ARGUMENTS_
        #
        # `strText`
        #
        # : Text to trim.
        #
        #_______________________________________________________________________
        function bs_fn_trim_r(strText) {
          sub(/[ \t\n\v\f\r]{1,}$/, "", strText)
        }

        #_______________________________________________________________________
        # ## `bs_fn_trim`
        #
        # Remove whitespace from the start and end of a string.
        #
        # _ARGUMENTS_
        #
        # `strText`
        #
        # : Text to trim.
        #
        #_______________________________________________________________________
        function bs_fn_trim(strText) {
          bs_fn_trim_l(strText)
          bs_fn_trim_r(strText)
        }

        #_______________________________________________________________________
        # ## `bs_fn_wrap`
        #
        # Wrap text at a specific number of columns where the resulting text is
        # also indented.
        #
        # **Assumes indent contains no control characters.** (e.g. no `\t`)
        #
        # _ARGUMENTS_
        #
        # `strText`
        #
        # : Text to wrap.
        #
        # `nColumns`
        #
        # : Maximum text width.
        #
        # `strIndent`
        #
        # : Indentation text to use.
        # : May be null/empty.
        # : Will affect wrapping based on _character_ count
        #   (i.e. a <tab> character is _one_ character)
        #
        # _NOTES_
        #
        # - The standard `fold` command is the easiest tool to use to wrap text,
        #   however having to do two way communication with an external command
        #   is not easy in _POSIX.1_ `awk`, the only way it is possible is to
        #   use a dynamic shell script which `awk` will execute correctly when
        #   it is used in the expression `<script> | getline <variable>`.
        # - The generated script needs to contain a literal copy of the text to
        #   be folded (it can _not_ be used from a variable). This can be given
        #   as an argument for the shell `printf` which is then piped to `fold`.
        #   Unfortunately this means that quoting becomes an issue, and care
        #   must be taken to ensure values in the generated script are properly
        #   quoted. (This is much the same as the processing required for
        #   emulating arrays in the shell itself.)
        # - As the `awk` script is a string quoted by `<apostrophe>` characters,
        #   using `<apostrophe>` characters in the script requires sequences
        #   of quote characters that are somewhat confusing. These sequences
        #   work because the shell will concatenate multiple strings together
        #   when they appear next to one another even if they are quoted using
        #   different characters.
        #_______________________________________________________________________
        function bs_fn_wrap(strText, nColumns, strIndent) {
          nIndent = length(strIndent)
          nWrapAt = nColumns - nIndent

          #-------------------------------------------------
          # The sequence '"'"' results in a single
          # `<apostrophe>` character in the final `awk`
          # script, the substitution here escapes any
          # `<apostrophe>` characters in the source text,
          # so it can be safely quoted using `<apostrophe>`
          # characters.
          #-------------------------------------------------
          gsub(/'"'"'/, "'"'"'\"'"'"'\"'"'"'", strText)

          #-------------------------------------------------
          # Create a shell script to fold the text
          #-------------------------------------------------
          cmdFold = "printf \"%s\" '"'"'" strText "'"'"' | fold -s -w" nWrapAt

          #-------------------------------------------------
          # Execute the script and read the output
          #-------------------------------------------------
          strWrapped = ""
          while ( (cmdFold | getline strLine) > 0 ) {
              strWrapped = (strWrapped ? (strWrapped c_chNewLine) : "") strIndent strLine
          }
          close(cmdFold)

          return strWrapped c_chNewLine
        } #< `function bs_fn_wrap`

        #_______________________________________________________________________
        # ## `bs_fn_get_option_help`
        #
        # Convert the data gathered from the full OPTION-CONFIG into some human
        # readable help text.
        #
        # _ARGUMENTS_
        #
        # `nCount`
        #
        # : Count of variables.
        #
        # `aData`
        #
        # : Data collected, containing at least `nCount`
        #   numbered entries.
        #
        # _NOTES_
        #
        # - SHOULD only be called after ALL of OPTION-CONFIG has been parsed.
        #_______________________________________________________________________
        function bs_fn_get_option_help(nCount, aData) {
          #-------------------------------------------------
          # Suffixes that indicate how any OPTION-ARGUMENT
          # must be specified for a specific OPTION.
          #-------------------------------------------------
          c_aOptionValue["?"] = "[=<VALUE>]"
          c_aOptionValue[":"] = " <VALUE>"
          c_aOptionValue["+"] = " <VALUE>"

          strOptionHelp = ""

          #-------------------------------------------------
          # Iterate through the variables - uses an index
          # and a count so that the order can be controlled
          # (using something like `<variable> in aData`
          #  uses whatever order the implementation likes)
          #-------------------------------------------------
          for (nVar = 1; nVar < nCount; ++nVar) {
            strVar     = aData[nVar]
            strOptions = aData[strVar, "options"]
            strType    = aData[strVar, "type"]
            strHelp    = aData[strVar, "help"]
            strValue   = c_aOptionValue[strType]

            strOptionList = ""

            #-----------------------------------------------
            # OPTION-NAMES are still stored in OPTION-CONFIG
            # format, so split them into individual options
            # and process each
            #-----------------------------------------------
            nOptionCount = split(strOptions, aOptions, "|");
            for (nOpt = 1; nOpt <= nOptionCount; ++nOpt) {
              strOption  = aOptions[nOpt]
              nOptionLen = length(strOption)

              #---------------------------------------------
              # Add the appropriate prefix
              #---------------------------------------------
              strOption = ((length(strOption) > 1) ? "--" : "-") strOption

              #---------------------------------------------
              # Store the longest OPTION-NAME for use
              # with help for `^` type OPERANDs
              #---------------------------------------------
              if (nOptionLen > length(aData[strVar, "main"])) {
                aData[strVar, "main"] = strOption
              }

              #---------------------------------------------
              # Add the value suffix and get new length
              #---------------------------------------------
              strOption  = strOption strValue
              nOptionLen = length(strOption)

              if (strOptionList) {
                #-------------------------------------------
                # Wrap if needed - as this is a
                # relatively simple wrapping case, just do
                # it manually
                #
                # _NOTES_
                #
                # - assumes OPTION-NAMEs are relatively
                #   short compared to the wrapping distance;
                #   no single OPTION-NAME is split
                # - the `+ 3` here represents the preceding
                #   ", " and succeeding "," that would be
                #   used in the final text if the option was
                #   appended to the current line
                #-------------------------------------------
                if (c_nWrapColumns && ((length(strOptionList) + nOptionLen + 3) > c_nWrapColumns)) {
                  strOptionHelp = strOptionHelp strOptionList "," c_chNewLine
                  strOptionList = ""
                } else {
                  strOptionList = strOptionList ", "
                }
              }
              strOptionList = strOptionList strOption
            }

            #-----------------------------------------------
            # Append common text where required
            #-----------------------------------------------
            if (c_strMultiOptionHelp && (strType == "+")) {
              strHelp = strHelp ? (strHelp " " c_strMultiOptionHelp) : c_strMultiOptionHelp
            }

            #-----------------------------------------------
            # If any help text is available, make sure
            # it is correctly formatted.
            #-----------------------------------------------
            if (strHelp) {
              if (c_nWrapColumns) {
                strHelp = bs_fn_wrap(strHelp, c_nWrapColumns, c_strIndent)
              } else {
                strHelp = c_strIndent strHelp c_chNewLine
              }
            }

            #-----------------------------------------------
            # Add all the data to the final help text,
            # `strHelp` is appended even if empty in this
            # case the result will be a blank line added
            # to the output, which is what would be expected
            #-----------------------------------------------
            strOptionHelp = strOptionHelp strOptionList c_chNewLine strHelp c_chNewLine
          }

          return strOptionHelp
        } #< `function bs_fn_get_option_help`

        #_______________________________________________________________________
        # ## `bs_fn_get_operand_help`
        #
        # Convert the data gathered from the full
        # OPERAND-CONFIG into some human readable help text.
        #
        # _ARGUMENTS_
        #
        # `nCount`
        #
        # : Count of variables.
        #
        # `aData`
        #
        # : Data collected, containing at least `nCount`
        #   numbered entries.
        #
        # `aOptionData`
        #
        # : Option data - used when an OPERAND and OPTION
        #   target the same variable. (Appends a reference
        #   to the OPTION.)
        #
        #_______________________________________________________________________
        function bs_fn_get_operand_help(nCount, aData, aOptionData) {
          strOperandHelp = ""
          for (nVar = 1; nVar < nCount; ++nVar) {
            strVar  = aData[nVar]
            strType = aData[strVar, "type"]
            strHelp = aData[strVar, "help"]

            if (strType == "^") {
              strOperand = "<VALUE" nVar ">" c_chNewLine
              if (c_strAlternativeOperandHelp) {
                strHelpSuffix = c_strAlternativeOperandHelp
                gsub(/<OPTION>/, aOptionData[strVar, "main"], strHelpSuffix)
                strHelp = strHelp ? (strHelp " " strHelpSuffix) : strHelpSuffix
              }
            } else if (strType == "+") {
              strOperand = "<VALUE" nVar ">..." c_chNewLine
              if (c_strAlternativeOperandHelp && aOptionData[strVar, "main"]) {
                strHelpSuffix = c_strAlternativeOperandHelp
                gsub(/<OPTION>/, aOptionData[strVar, "main"], strHelpSuffix)
                strHelp = strHelp ? (strHelp " " strHelpSuffix) : strHelpSuffix
              }
              if (c_strMultiOperandHelp) {
                strHelp = strHelp ? (strHelp " " c_strMultiOperandHelp) : c_strMultiOperandHelp
              }
            } else {
              strOperand = "<VALUE" nVar ">" c_chNewLine
            }

            #-----------------------------------------------
            # If any help text is available, make sure
            # it is correctly formatted.
            #-----------------------------------------------
            if (strHelp) {
              if (c_nWrapColumns) {
                strHelp = bs_fn_wrap(strHelp, c_nWrapColumns, c_strIndent)
              } else {
                strHelp = c_strIndent strHelp c_chNewLine
              }
              strOperand = strOperand strHelp c_chNewLine
            }

            strOperandHelp = strOperandHelp strOperand
          }

          return strOperandHelp
        } #< `function bs_fn_get_operand_help`

        ########################################################################
        # PATTERNS
        ########################################################################

        #===================================================
        # Initialize...
        #===================================================
        BEGIN {
          # Keep a flag indicating which type of
          # config is currently being processed.
          g_OperandMode = 0

          # Store the config value currently being processed
          # so that help continuation lines known where to
          # store the data.
          g_Current = ""

          # Indices are used for storing variable names as
          # awk arrays can only be traversed in a specific
          # order if this is done manually (i.e. using the
          # built-in array traversal options results in
          # un-ordered output).
          g_idxOptionVariables  = 1
          g_idxOperandVariables = 1

          # Character constant for `\n` (`<newline>`) to
          # make it easier to use in the reset of the
          # script.
          c_chNewLine = sprintf("\n")

          # The basic indent level. 8 spaces is used instead
          # of a tab as word wrapping depends on the number
          # of characters this occupies when printed - 8
          # spaces is the traditional tab size (and default
          # in most systems for the terminal). A literal
          # tab would have a length of 1 character and it
          # is not possible to measure how many it would
          # actually show as.
          c_strIndent = "        "
        }

        #===================================================
        # Gather data from help continuation lines
        #
        # _NOTES_
        #
        # - MUST be first to avoid other patterns matching
        #   before this
        #===================================================
        /^[ \t\n\v\f\r]*#/ {
          # Technically this is an error, but just ignore it
          if (!g_Current) next

          # Get the help text and trim it
          strHelp = substr($0, (index($0, "#") + 1)) ;
          bs_fn_trim(strHelp)

          # Append the help text to the appropriate text
          if (g_OperandMode) {
            if (g_aOperandData[g_Current, "help"]) {
              g_aOperandData[g_Current, "help"] = g_aOperandData[g_Current, "help"] " " strHelp
            } else {
              g_aOperandData[g_Current, "help"] = strHelp
            }
          } else {
            if (g_aOptionData[g_Current, "help"]) {
              g_aOptionData[g_Current, "help"] = g_aOptionData[g_Current, "help"] " " strHelp
            } else {
              g_aOptionData[g_Current, "help"] = strHelp
            }
          }

          next #< Do not match anything else
        } #< `/^[ \t\n\v\f\r]*#/`

        #=====================================================
        # Switch Modes
        #=====================================================
        /^--$/ {
          g_OperandMode=1

          next #< Do not match anything else
        } #< `/^--$/`

        #=====================================================
        # Gather data from CONFIG lines
        #=====================================================
        {
          # Skip any blank lines
          if (!$0) next

          strConfigMulti = $0;

          # Remove (and keep) any help text
          strHelp = "";
          if (idxHelp = index(strConfigMulti, "#")) {
            strHelp = substr(strConfigMulti, (idxHelp + 1)) ;
            bs_fn_trim(strHelp)
            strConfigMulti = substr(strConfigMulti, 1, (idxHelp - 1)) ;
          }

          # Process the config appropriately
          if (g_OperandMode) {
            nConfigCount = split(strConfigMulti, aConfig, ",");
            for (i = 1; i <= nConfigCount; ++i) {
              # Format: "[" <TYPE> "]" <VARIABLE>,
              # with <TYPE> being a single character
              strType = substr(aConfig[i], 2, 1)
              strVar  = substr(aConfig[i], 4)

              g_aOperandData[g_idxOperandVariables++] = strVar
              g_aOperandData[strVar, "type"]          = strType
            }

            # Help applies only to the last config variable
            if (strHelp) {
              if (g_aOperandData[strVar, "help"]) {
                g_aOperandData[strVar, "help"] = g_aOperandData[strVar, "help"] " " strHelp
              } else {
                g_aOperandData[strVar, "help"] = strHelp
              }
            }

            g_Current = strVar
          } else {
            strVar = ""
            nCount = split(strConfigMulti, aConfig, ",");
            for (i = 1; i <= nCount; ++i) {
              idxTypeStart = index(aConfig[i], "[")
              idxTypeEnd   = index(aConfig[i], "]")

              strOptions = substr(aConfig[i], 1, (idxTypeStart - 1))
              strType    = substr(aConfig[i], (idxTypeStart + 1), 1)
              strVar     = substr(aConfig[i], (idxTypeEnd + 1))

              g_aOptionData[g_idxOptionVariables++] = strVar
              g_aOptionData[strVar, "type"]         = strType
              g_aOptionData[strVar, "options"]      = g_aOptionData[strVar, "options"] ?
                                                        (g_aOptionData[strVar, "options"] "|" strOptions) :
                                                        strOptions
            }

            # Help applies only to the last config variable
            if (strHelp) {
              if (g_aOptionData[strVar, "help"]) {
                g_aOptionData[strVar, "help"] = g_aOptionData[strVar, "help"] " " strHelp
              } else {
                g_aOptionData[strVar, "help"] = strHelp
              }
            }

            g_Current = strVar
          }
        }

        #===================================================
        # Process the collected data
        #===================================================
        END {
          strSynopsis = c_strCommand

          strOptionHelp  = ""
          if (g_idxOptionVariables > 1) {
            strSynopsis = strSynopsis " <OPTIONS>"
            strOptionHelp = bs_fn_get_option_help(g_idxOptionVariables,
                                                  g_aOptionData)
          }

          strOperandHelp = ""
          if (g_idxOperandVariables > 1) {
            strSynopsis = strSynopsis " [--] <OPERANDS>"
            strOperandHelp = bs_fn_get_operand_help(g_idxOperandVariables,
                                                    g_aOperandData,
                                                    g_aOptionData)
          }

          strHelp = strSynopsis c_chNewLine

          if (strOptionHelp) {
            strHelp = strHelp c_chNewLine "Options:" c_chNewLine c_chNewLine strOptionHelp
          }

          if (strOperandHelp) {
            strHelp = strHelp c_chNewLine "Operands:" c_chNewLine c_chNewLine strOperandHelp
          }

          print strHelp
        }
      '
    }
  )" || {
    ec_fn_bs_lga_auto_help=$?
    fn_bs_lga_error 'unknown error while trying to generate help text'
    return ${ec_fn_bs_lga_auto_help}
  }

  #---------------------------------------------------------
  # Save or output the text
  #---------------------------------------------------------
  case ${g_BS_LGA_CFG_AutoHelp:--} in
  -) printf '%s\n' "${BS_LGAAH_Help}" ;;
  *) eval "${g_BS_LGA_CFG_AutoHelp}=\"\${BS_LGAAH_Help}\"" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_generate_script`
#;
#; Generate a dynamic script suitable for use with `eval` which recreates the
#; externally visible side-effects of running `getargs`.
#;
#; This is the basis of the standalone tool `getarg`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_generate_script
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; NONE.
#;
#; _NOTES_
#; <!-- -->
#;
#; - This is likely to have some performance impact.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Since the config format for both OPTION-CONFIG and OPERAND-CONFIG is the
#.   same for specifying variables (i.e. the variable always follows the type
#.   which always is written surrounded by square brackets) both configs can
#.   be processed together without caring which is which.
#.
#_______________________________________________________________________________
fn_bs_lga_generate_script() { ## cSpell:Ignore BS_LGA_GS_
  #---------------------------------------------------------
  # Append both configs - they can be processed together
  # here, but need to be a single line, so also replace any
  # `\n` (`<newline>`) characters with a `,` (`<comma>`).
  # (Note, this effectively reverses the substitution that
  #  happens in the main function related to ambiguous
  #  options.)
  #---------------------------------------------------------
  BS_LGA_GS_Config="${g_BS_LGA__OptionConfig},${g_BS_LGA__OperandConfig}"
  case ${g_BS_LGA_CFG_AllowAmbiguous:-0} in
  0)  BS_LGA_GS_Config="$(
          {
            printf '%s\n' "${BS_LGA_GS_Config}"
          } | {
            tr -s "${c_BS_LGA__newline}" ','
          }
        )" ;;
  esac

  #---------------------------------------------------------
  # For easier matching, make sure the string is surrounded
  # by `,` (`<comma>`) characters, but try not to add more
  # than one each side.
  #---------------------------------------------------------
  BS_LGA_GS_Config=",${BS_LGA_GS_Config#,}"
  BS_LGA_GS_Config="${BS_LGA_GS_Config%,},"

  #---------------------------------------------------------
  # Process the config text one variable at a time and add
  # them to the script as appropriate.
  #
  # _NOTES_
  #
  # - A variable can occur in multiple different configs,
  #   without checking for previously processed variables
  #   this would cause the resulting script to set these
  #   variables multiple times. Although this would be
  #   harmless, it's wasteful and easily avoided by keeping
  #   track of the variables already in the script.
  #---------------------------------------------------------
  BS_LGA_GS_Script=; BS_LGA_GS_Processed=;
  while : #< [ -n "${BS_LGA_GS_Config:+1}" ]
  do
    #> LOOP TEST ----------------------------------------
    case ${BS_LGA_GS_Config:+1} in 1) ;; *) break ;; esac #< [ -n "${BS_LGA_GS_Config:+1}" ]
    #> --------------------------------------------------

    #-------------------------------------------------------
    # Extract the variable:
    # - Remove the first `]` and everything before
    # - Remove the first `,` and everything after
    #-------------------------------------------------------
    BS_LGA_GS_refVariable="${BS_LGA_GS_Config#*\]}"
    BS_LGA_GS_refVariable="${BS_LGA_GS_refVariable%%,*}"

    #-------------------------------------------------------
    # Check the variable name
    #
    # _NOTES_
    #
    # - This is required as not all variables will have been
    #   processed in some cases (this code has to check if
    #   a variable has been set, if it has not then it will
    #   only have been checked if auto-unset was enabled).
    #-------------------------------------------------------
    fn_bs_lga_validate_name "${BS_LGA_GS_refVariable}" || return $?

    #-------------------------------------------------------
    # Update the config being processed:
    # - Remaining config is everything after the first
    #   `,` that follows at least one character
    #-------------------------------------------------------
    BS_LGA_GS_Config="${BS_LGA_GS_Config#*?,}"

    #-------------------------------------------------------
    # Skip any variable already processed
    #-------------------------------------------------------
    case ${BS_LGA_GS_Processed-} in
    *",${BS_LGA_GS_refVariable},"*) continue ;;
    
    *) BS_LGA_GS_Processed="${BS_LGA_GS_Processed-},${BS_LGA_GS_refVariable}," ;;
    esac

    #-------------------------------------------------------
    # Add the variable to the script
    #
    # _NOTES_
    #
    # - Values have to be carefully quoted to ensure they
    #   are later evaluated as intended.
    # - Formatting here is only to aid readability, the
    #   newlines in the strings are not required.
    #-------------------------------------------------------
    eval "
      case \${${BS_LGA_GS_refVariable}+1}:${g_BS_LGA_CFG_AutoUnset} in
      1:?) BS_LGA_GS_Script=\"\${BS_LGA_GS_Script}
                              \${BS_LGA_GS_refVariable}=\$(fn_bs_lga_safe_quote \"\${${BS_LGA_GS_refVariable}}\");
                            \" ;;
      *:1) BS_LGA_GS_Script=\"\${BS_LGA_GS_Script}
                              ${BS_LGA_GS_refVariable}=;
                              unset ${BS_LGA_GS_refVariable};
                            \" ;;
      esac
    " || return $?
  done

  #---------------------------------------------------------
  # Output or save the script
  #---------------------------------------------------------
  case ${g_BS_LGA_CFG_Script:--} in
  -) printf '%s\n' "${BS_LGA_GS_Script}" ;;
  *) eval "${g_BS_LGA_CFG_Script}=\"\${BS_LGA_GS_Script}\"" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_lga_display_help`
#;
#; Display help for the wrapper script `getarg`.
#;
#; To avoid duplication, the help here is very simple - all detailed information
#; is available elsewhere.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_lga_display_help
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; NONE.
#;
#_______________________________________________________________________________
fn_bs_lga_display_help() { ## cSpell:Ignore BS_LGA_DH_
  cat <<EndOfUsageText
Usage:

  MyArgs="\$(getarg <SPECIFICATION>... [--] <ARGUMENT>...)"
  ...
  eval "\$MyArgs"

Command argument processing for scripts and script functions.

Parses all <ARGUMENT>s according to the configuration from <SPECIFICATION>.

SPECIFICATION OPTIONS:

-o, --options <CONFIG>          Required. <CONFIG> describes how OPTIONs are
                                processed. MAY be specified multiple times.
-p, --positional <CONFIG>,
    --operands   <CONFIG>       <CONFIG> describes how OPERANDs are processed.
                                MAY be specified multiple times.
    --auto-help                 Automatically process a --help or -h <ARGUMENT>.
                                If --help or -h is encountered, help text is
                                generated and written, processing then stops and
                                an exit status of 1 is set.
-v, --validate=<VALIDATOR>      Use <VALIDATOR> as a command to validate all
                                OPTION-ARGUMENTs and OPERANDs.
-n, --name <ID>,
-i, --id <ID>                   Set an <ID> to use for error messages and with
                                auto-help.
    --[no-]abbreviations        [Enable]/Disable allowing LONG-OPTIONs to be
                                abbreviated.
    --[no-]ambiguous            [Enable]/Disable detection of ambiguous OPTIONs.
    --[no-]check-config         Enable/[Disable] performing basic checks on
                                OPTION-CONFIG and OPERAND-CONFIG before
                                processing.
    --[no-]interleaved,
    --[no-]mixed                Enable/[Disable] allowing matching OPTIONs after
                                the first OPERAND is matched. Can not be used
                                with --strict.
    --[no-]posix-long           Enable/[Disable] matching LONG-OPTIONs with a
                                single preceding '-' (<hyphen>) character
                                instead of the normally required two.
    --[no-]quiet[-error]        [Enable]/Disable error message output.
    --[no-]strict               Enable/[Disable] requiring the use of '--' to
                                separate OPTIONs from OPERANDs. Can not be used
                                with --interleaved or --unmatched
    --[no-]unsafe               [Enable]/Disable escaping OPTIONs to avoid any
                                erroneous results when matching with regular
                                expressions.
    --[no-]unset                Enable/[Disable] automatic unsetting of all
                                VARIABLES named in OPTION-CONFIG and
                                OPERAND-CONFIG.
    --[no-]unmatched            Enable/[Disable] matching an unrecognized OPTION
                                as an OPERAND. Implies --interleaved. Can not be
                                used with --strict.

-V, --version                   Write the library version number to STDOUT and
                                exit.
-h, --help                      Display this text and exit.

Preference option defaults are enclosed in square brackets, however all
preference options can also be configured using environment variables.

The command 'getarg' is a wrapper script that allows 'libgetargs' to be
invoked directly. Some options are omitted as they are only useful when using
'libgetargs' itself.

For more details see getarg(1), libgetargs(7), betterscripts(7).
EndOfUsageText
}

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## COMMANDS
#.
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `getargs`
#.
#. <DOCUMENTED AT TOP OF FILE>
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - There are a large number of variables needed to allow `getargs` to
#.   function as required. While it might be possible to pass these are
#.   command/function arguments this quickly becomes unwieldy, instead most
#.   values are stored in global variables that are reset on entry. The result
#.   is cleaner and likely to be faster, but can lead to errors if the current
#.   state is not carefully managed.
#.
#_______________________________________________________________________________
getargs() { ## cSpell:Ignore BS_LGA_
  #=========================================================
  # Initialize
  #=========================================================

  #---------------------------------------------------------
  # Config Override Variables
  #---------------------------------------------------------

  # Quiet Errors [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_QUIET_ERRORS:-${BETTER_SCRIPTS_CONFIG_QUIET_ERRORS:-0}} in
  0) g_BS_LGA_CFG_QuietErrors=0 ;;
  *) g_BS_LGA_CFG_QuietErrors=1 ;;
  esac
  # Fatal Errors [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in
  0) g_BS_LGA_CFG_FatalErrors=0 ;;
  *) g_BS_LGA_CFG_FatalErrors=1 ;;
  esac
  # Abbreviations [Default: _ON_]
  case ${BS_LIBGETARGS_CONFIG_ALLOW_ABBREVIATIONS:-1} in
  0) g_BS_LGA_CFG_AllowAbbreviations=0 ;;
  *) g_BS_LGA_CFG_AllowAbbreviations=1 ;;
  esac
  # Ambiguous [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_ALLOW_AMBIGUOUS:-0} in
  0) g_BS_LGA_CFG_AllowAmbiguous=0 ;;
  *) g_BS_LGA_CFG_AllowAmbiguous=1 ;;
  esac
  # Check Config [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_CHECK_CONFIG:-0} in
  0) g_BS_LGA_CFG_CheckConfig=0 ;;
  *) g_BS_LGA_CFG_CheckConfig=1 ;;
  esac
  # Interleaved Operands [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS:-0} in
  0) g_BS_LGA_CFG_InterleavedOperands=0 ;;
  *) g_BS_LGA_CFG_InterleavedOperands=1 ;;
  esac
  # POSIX Long [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_ALLOW_POSIX_LONG:-0} in
  0) g_BS_LGA_CFG_AllowPOSIXLong=0 ;;
  *) g_BS_LGA_CFG_AllowPOSIXLong=1 ;;
  esac
  # Strict Operands [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_STRICT_OPERANDS:-0} in
  0) g_BS_LGA_CFG_StrictOperands=0 ;;
  *) g_BS_LGA_CFG_StrictOperands=1 ;;
  esac
  # Unsafe Options [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_ALLOW_UNSAFE_OPTIONS:-0} in
  0) g_BS_LGA_CFG_AllowUnsafeOptions=0 ;;
  *) g_BS_LGA_CFG_AllowUnsafeOptions=1 ;;
  esac
  # Unmatched Options [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED:-0} in
  0) g_BS_LGA_CFG_AllowUnmatched=0 ;;
  *) g_BS_LGA_CFG_AllowUnmatched=1 ;;
  esac
  # Auto Unset [Default: _OFF_]
  case ${BS_LIBGETARGS_CONFIG_AUTO_UNSET:-0} in
  0) g_BS_LGA_CFG_AutoUnset=0 ;;
  *) g_BS_LGA_CFG_AutoUnset=1 ;;
  esac

  #---------------------------------------------------------
  # Early verification
  #---------------------------------------------------------
  case ${g_BS_LGA_CFG_StrictOperands:-0}${g_BS_LGA_CFG_InterleavedOperands:-0}${g_BS_LGA_CFG_AllowUnmatched:-0} in
  11) fn_bs_lga_invalid_args 'BS_LIBGETARGS_CONFIG_STRICT_OPERANDS can not be used with BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS or BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED'
      return "${c_BS_LGA__EX_CONFIG}" ;;
  esac

  #---------------------------------------------------------
  # Modes
  #---------------------------------------------------------

  # - Initialize Auto Help
  g_BS_LGA_CFG_AutoHelp=;
  unset 'g_BS_LGA_CFG_AutoHelp'

  # - Script Mode
  g_BS_LGA_CFG_Script=;
  unset 'g_BS_LGA_CFG_Script'

  # - Initialize Value Validator
  g_BS_LGA_CFG_fn_Validator=;
  unset 'g_BS_LGA_CFG_fn_Validator'

  #---------------------------------------------------------
  # Other Variables
  #---------------------------------------------------------

  # Main Variables
        g_BS_LGA__OptionConfig=; #< OPTION-CONFIG
    g_BS_LGA__OptionConfigHelp=; #< OPTION-CONFIG (auto-help)
       g_BS_LGA__OperandConfig=; #< OPERAND-CONFIG
   g_BS_LGA__OperandConfigHelp=; #< OPERAND-CONFIG (auto-help)
   g_BS_LGA__AssignedVariables=; #< All Variables Given Values

  # Error Helpers
  g_BS_LGA__CurrentArgument=; #< Current ARGUMENT
   BS_LIBGETARGS_LAST_ERROR=; #< Last Error
               g_BS_LGA__ID=; #< ID string

  #=========================================================
  # Detect if being run in "Standalone Mode"
  #=========================================================
  case ${1-} in
  'getarg') BS_LGA__StandaloneMode=1; shift ;;
         *) BS_LGA__StandaloneMode=0; ;;
  esac

  #=========================================================
  # Process `getargs` OPTIONs
  #=========================================================
  while : #< [ $# -gt 0 ]
  do
    #> LOOP TEST -----------------------
    case $# in 0) break ;; esac #< [ $# -gt 0 ]
    #> ---------------------------------

    case $1 in #< `shift` after `case`
      #.....................................................
      # STOP: Consume any 'stop' value and break the loop
      '--') shift; break ;;

      #.....................................................
      # VERSION
      '-V'|'--version')
        printf "%s\n" "${BS_LIBGETARGS_VERSION}"
        return ;;

      #.....................................................
      # HELP
      #
      # - if running in standalone mode, display help and
      #   exit, otherwise this must be the start of user
      #   arguments, so break the loop
      '-h'|'--help')
        case ${BS_LGA__StandaloneMode} in
        1) fn_bs_lga_display_help; return ;;
        0) break ;;
        esac
      ;;

      #.....................................................
      # OPTION-CONFIG
      '--options='*|'-o='*)
        BS_LGA__Arg="${1#-*=}"
        case ${BS_LGA__Arg:+1} in
        1)  g_BS_LGA__OptionConfigHelp="${g_BS_LGA__OptionConfigHelp-}${BS_LGA__Arg}${c_BS_LGA__newline}"
            g_BS_LGA__OptionConfig="${g_BS_LGA__OptionConfig-}${BS_LGA__Arg%%#*}," ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      '-o'[!=]*)
        BS_LGA__Arg="${1#-?}"
        g_BS_LGA__OptionConfigHelp="${g_BS_LGA__OptionConfigHelp-}${BS_LGA__Arg}${c_BS_LGA__newline}"
        g_BS_LGA__OptionConfig="${g_BS_LGA__OptionConfig-}${BS_LGA__Arg%%#*}," ;;

      '--options'|'-o')
        case ${2:+1} in
        1)  g_BS_LGA__OptionConfigHelp="${g_BS_LGA__OptionConfigHelp-}${2}${c_BS_LGA__newline}"
            g_BS_LGA__OptionConfig="${g_BS_LGA__OptionConfig-}${2%%#*},"
            shift ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      #.....................................................
      # OPERAND-CONFIG
      '--operands='*|'--positional='*|'-p='*)
        BS_LGA__Arg="${1#-*=}"
        case ${BS_LGA__Arg:+1} in
        1)  g_BS_LGA__OperandConfigHelp="${g_BS_LGA__OperandConfigHelp-}${BS_LGA__Arg}${c_BS_LGA__newline}"
            g_BS_LGA__OperandConfig="${g_BS_LGA__OperandConfig-}${BS_LGA__Arg%%#*}," ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      '-p'[!=]*)
        BS_LGA__Arg="${1#-?}"
        g_BS_LGA__OperandConfigHelp="${g_BS_LGA__OperandConfigHelp-}${BS_LGA__Arg}${c_BS_LGA__newline}"
        g_BS_LGA__OperandConfig="${g_BS_LGA__OperandConfig-}${BS_LGA__Arg%%#*}," ;;

      '--operands'|'--positional'|'-p')
        case ${2:+1} in
        1)  g_BS_LGA__OperandConfigHelp="${g_BS_LGA__OperandConfigHelp-}${2}${c_BS_LGA__newline}"
                g_BS_LGA__OperandConfig="${g_BS_LGA__OperandConfig-}${2%%#*},"
            shift ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      #.....................................................
      # ID/NAME
      '--id='*|'--name='*|'-i='*|'-n='*)
        case ${g_BS_LGA__ID:+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        BS_LGA__Arg="${1#-*=}"
        case ${BS_LGA__Arg:+1} in
        1)  g_BS_LGA__ID="${BS_LGA__Arg}" ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      '-i'[!=]*|'-n'[!=]*)
        case ${g_BS_LGA__ID:+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        g_BS_LGA__ID="${1#-?}" ;;

      '--id'|'--name'|'-i'|'-n')
        case ${g_BS_LGA__ID:+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        case ${2:+1} in
        1)  g_BS_LGA__ID="$2"
            shift ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      #...................................................
      # VALIDATOR
      '--validate='*|'-v='*)
        case ${g_BS_LGA_CFG_fn_Validator+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        BS_LGA__Arg="${1#-*=}"
        case ${BS_LGA__Arg:+1} in
        1)  g_BS_LGA_CFG_fn_Validator="${BS_LGA__Arg}" ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      '-v'[!=]*)
        case ${g_BS_LGA_CFG_fn_Validator+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        g_BS_LGA_CFG_fn_Validator="${1#-?}" ;;

      '--validate'|'-v')
        case ${g_BS_LGA_CFG_fn_Validator+1} in
        1) fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        g_BS_LGA_CFG_fn_Validator='getargs_validate_option_value' ;;

      #...................................................
      # AUTO-HELP
      '--auto-help='*)
        case ${g_BS_LGA_CFG_AutoHelp+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        BS_LGA__Arg="${1#-*=}"
        case ${BS_LGA__Arg:+1} in
        1)  g_BS_LGA_CFG_AutoHelp="${BS_LGA__Arg}" ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      '--auto-help')
        case ${g_BS_LGA_CFG_AutoHelp+1} in
        1) fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        g_BS_LGA_CFG_AutoHelp='-' ;;

      #...................................................
      # SCRIPT
      '--script='*|'-s='*)
        case ${g_BS_LGA_CFG_Script+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        BS_LGA__Arg="${1#-*=}"
        case ${BS_LGA__Arg:+1} in
        1)  g_BS_LGA_CFG_Script="${BS_LGA__Arg}" ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac ;;

      '-s'[!=]*)
        case ${g_BS_LGA_CFG_Script+1} in
        1)  fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        g_BS_LGA_CFG_Script="${1#-?}" ;;

      '--script'|'-s')
        case ${g_BS_LGA_CFG_Script+1} in
        1) fn_bs_lga_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_LGA__EX_USAGE}" ;;
        esac
        g_BS_LGA_CFG_Script=; ;;

      #...................................................
      # ENVIRONMENT OVERRIDES
      '--interleaved'     | '--mixed'          ) g_BS_LGA_CFG_InterleavedOperands=1 ;;
      '--no-interleaved'  | '--no-mixed'       ) g_BS_LGA_CFG_InterleavedOperands=0 ;;
      '--fatal'           | '--fatal-errors'   ) g_BS_LGA_CFG_FatalErrors=1 ;;
      '--no-fatal'        | '--no-fatal-errors') g_BS_LGA_CFG_FatalErrors=0 ;;
      '--quiet'           | '--quiet-error'    ) g_BS_LGA_CFG_QuietErrors=1 ;;
      '--no-quiet'        | '--no-quiet-error' ) g_BS_LGA_CFG_QuietErrors=0 ;;

      '--abbreviations'   ) g_BS_LGA_CFG_AllowAbbreviations=1 ;;
      '--no-abbreviations') g_BS_LGA_CFG_AllowAbbreviations=0 ;;
      '--ambiguous'       ) g_BS_LGA_CFG_AllowAmbiguous=1     ;;
      '--no-ambiguous'    ) g_BS_LGA_CFG_AllowAmbiguous=0     ;;
      '--check-config'    ) g_BS_LGA_CFG_CheckConfig=1        ;;
      '--no-check-config' ) g_BS_LGA_CFG_CheckConfig=0        ;;
      '--posix-long'      ) g_BS_LGA_CFG_AllowPOSIXLong=1     ;;
      '--no-posix-long'   ) g_BS_LGA_CFG_AllowPOSIXLong=0     ;;
      '--strict'          ) g_BS_LGA_CFG_StrictOperands=1     ;;
      '--no-strict'       ) g_BS_LGA_CFG_StrictOperands=0     ;;
      '--unmatched'       ) g_BS_LGA_CFG_AllowUnmatched=1     ;;
      '--no-unmatched'    ) g_BS_LGA_CFG_AllowUnmatched=0     ;;
      '--unsafe'          ) g_BS_LGA_CFG_AllowUnsafeOptions=1 ;;
      '--no-unsafe'       ) g_BS_LGA_CFG_AllowUnsafeOptions=0 ;;
      '--unset'           ) g_BS_LGA_CFG_AutoUnset=1          ;;
      '--no-unset'        ) g_BS_LGA_CFG_AutoUnset=0          ;;

      #.....................................................
      # Assume everything else is a user OPERAND
      *) break ;;
    esac
    shift
  done

  #=========================================================
  # Set Defaults
  #=========================================================

  # Allow Unmatched requires Interleaved Operands
  case ${g_BS_LGA_CFG_AllowUnmatched:-0} in
  1) g_BS_LGA_CFG_InterleavedOperands=1 ;;
  esac

  #=========================================================
  # ARGUMENT VALIDATION
  #=========================================================

  #---------------------------------------------------------
  # Basic Validation
  #---------------------------------------------------------
  case ${g_BS_LGA__OptionConfig:+1} in
  1) ;; *) fn_bs_lga_invalid_args 'OPTION-CONFIG is required'
           return "${c_BS_LGA__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Check Config
  #---------------------------------------------------------

  # Option Combinations
  case ${g_BS_LGA_CFG_StrictOperands:-0}:${g_BS_LGA_CFG_InterleavedOperands:-0}${g_BS_LGA_CFG_AllowUnmatched:-0} in
  1:*1*) fn_bs_lga_invalid_args '"--strict" can not be used with "--interleaved" or "--unmatched"'
         return "${c_BS_LGA__EX_CONFIG}" ;;
  esac

  # Config Checking
  case ${g_BS_LGA_CFG_CheckConfig} in
  1)  { # OPTION-CONFIG
          BS_LGA_IgnoreOutput="$(
              fn_bs_lga_expr_re                 \
                "${g_BS_LGA__OptionConfig}"     \
                "${c_BS_LGA__re_OptionConfig}$" 2>&1
            )"
      } || {
        fn_bs_lga_invalid_args "invalid OPTION-CONFIG '${g_BS_LGA__OptionConfig}'"
        return "${c_BS_LGA__EX_CONFIG}"
      }

      # OPERAND-CONFIG
      case ${g_BS_LGA__OperandConfig:+1} in
      1)  # If operand config contains the '+' type then
          # this has to be the last entry in the config. As
          # `expr` doesn't deal well with large optional
          # expressions, the validation expression has to be
          # dynamically constructed to match the config, and
          # is one of the following:
          # - \(non-multi BRE\)+\(multi BRE\)
          # - \(non-multi BRE\)+
          # - \(multi BRE\)
          BS_LGA_re_OperandConfig=

          case ${g_BS_LGA__OperandConfig} in
          '['[!+]']'*) BS_LGA_re_OperandConfig="${BS_LGA_re_OperandConfig-}\(${c_BS_LGA__re_OperandSingle},\)\{1,\}" ;;
          esac

          case ${g_BS_LGA__OperandConfig} in
          *'[+]'*) BS_LGA_re_OperandConfig="${BS_LGA_re_OperandConfig-}${c_BS_LGA__re_OperandMulti}," ;;
          esac

          {
            BS_LGA_IgnoreOutput="$(
                fn_bs_lga_expr_re               \
                  "${g_BS_LGA__OperandConfig}"  \
                  "${BS_LGA_re_OperandConfig}$" 2>&1
              )"
          } || {
            fn_bs_lga_invalid_args "invalid OPERAND-CONFIG '${g_BS_LGA__OperandConfig}'"
            return "${c_BS_LGA__EX_CONFIG}"
          } ;;
      esac ;;
  esac

  #---------------------------------------------------------
  # Verify Variable Names
  #---------------------------------------------------------

  # Script
  case ${g_BS_LGA_CFG_Script:+1}:${g_BS_LGA_CFG_Script-} in
  1:-) ;;
  1:*) fn_bs_lga_validate_name "${g_BS_LGA_CFG_Script-}" || return $? ;;
  esac

  # AutoHelp
  case ${g_BS_LGA_CFG_AutoHelp:+1}:${g_BS_LGA_CFG_AutoHelp-} in
  1:-) ;;
  1:*) fn_bs_lga_validate_name "${g_BS_LGA_CFG_AutoHelp-}" || return $? ;;
  esac

  #=========================================================
  # Main Processing
  #=========================================================

  #---------------------------------------------------------
  # Unset Target Variables
  #---------------------------------------------------------
  case ${g_BS_LGA_CFG_AutoUnset} in
  1)  # OPTION-CONFIG Variables
      fn_bs_lga_unset_from_config "${g_BS_LGA__OptionConfig}"

      # OPERAND-CONFIG Variables
      case ${g_BS_LGA__OperandConfig:+1} in
      1) fn_bs_lga_unset_from_config "${g_BS_LGA__OperandConfig}" ;;
      esac ;;
  esac

  #---------------------------------------------------------
  # Check if there are any user ARGUMENTs to process
  #
  # NOTE:
  # - caller must determine if no user ARGUMENTs
  #   is an error
  # - needs to happen _after_ verification and _after_
  #   unsetting variables
  #---------------------------------------------------------
  case $# in 0) return ;; esac

  #---------------------------------------------------------
  # Re-Format OPTION-CONFIG
  #---------------------------------------------------------
  case ${g_BS_LGA_CFG_AllowAmbiguous:-0} in
  0)  # Ambiguous options are detected with `grep` and
      # require a newline delimited format
      #
      # NOTE:
      # - Avoids using `\n` for `tr` to aid portability
      {
        g_BS_LGA__OptionConfig="$(
            {
              printf '%s\n' "${g_BS_LGA__OptionConfig%,}"
            } | {
              tr -s ',' "${c_BS_LGA__newline}"
            }
          )"
      } || {
        ec_getargs_tr=$?
        fn_bs_lga_error "'tr' failed while attempting to replace ',' with '\n' in option config '${g_BS_LGA__OptionConfig}'"
        return ${ec_getargs_tr}
      } ;;
  1)  # Surrounding the whole of OPTION-CONFIG values in
      # `,` makes matching easier (a trailing `,` is
      # already present).
      #
      # OPERAND-CONFIG does not benefit from this.
      g_BS_LGA__OptionConfig=",${g_BS_LGA__OptionConfig}" ;;
  esac

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Process user ARGUMENTs
  #
  # To allow for argument lookup using different formats
  # for the same argument, unrecognized option errors are
  # deferred, so need reported here when encountered.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  g_BS_LGA__UnrecognizedOption=;
  fn_bs_lga_process_arguments "$@" || {
    ec_getargs_proc_param=$?
    case ${g_BS_LGA__UnrecognizedOption:+1} in
    1) fn_bs_lga_error "${g_BS_LGA__UnrecognizedOption}" ;;
    esac
    return ${ec_getargs_proc_param}
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Generate a script if required
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  case ${g_BS_LGA_CFG_Script+1} in
  1) fn_bs_lga_generate_script ;;
  esac
}

#===============================================================================
#===============================================================================
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## ADDITIONAL COMMANDS
#:
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `getargs_validate_option_value`
#:
#: Simple VALIDATOR that writes a warning to `STDERR` if an OPTION-ARGUMENT or
#: OPERAND starts with a `-` (`<hyphen>`). No other action is taken; processing
#: continues as normal after the warning is generated.
#:
#: If validation is enabled without a VALIDATOR being specified, this VALIDATOR
#: is used.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     getargs_validate_option_value <TARGET> <OPTION> <TYPE> <VALUE>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `TARGET` \[in]
#:
#: : The **name** of the target variable specified in the
#:   OPTION-CONFIG or OPERAND-CONFIG for the OPTION.
#:
#: `OPTION` \[in]
#:
#: : The OPTION as it was matched.
#: : For an OPERAND this is either null (an empty string),
#:   `-` or `--`.
#:
#: `TYPE` \[in]
#:
#: : The type of `VALUE`.
#: : One of the `BS_LIBGETARGS_TYPE_*` constants:
#:   [`BS_LIBGETARGS_TYPE_OPT_ARG`](#bs_libgetargs_type_opt_arg),
#:   [`BS_LIBGETARGS_TYPE_OPT_ARG_DELIMITED`](#bs_libgetargs_type_opt_arg_delimited),
#:   [`BS_LIBGETARGS_TYPE_OPT_ARG_AGGREGATE`](#bs_libgetargs_type_opt_arg_aggregate),
#:   or [`BS_LIBGETARGS_TYPE_OPERAND`](#bs_libgetargs_type_operand).
#:
#: `VALUE` \[in]
#:
#: : The value to check.
#: : MAY be null (i.e. the empty string).
#:
#: _NOTES_
#: <!-- -->
#:
#: - When `TYPE` is [`BS_LIBGETARGS_TYPE_OPERAND`](#bs_libgetargs_type_operand),
#:   `OPTION` is used to indicate how the OPERAND was matched:
#:   - `--`: the OPERAND was preceded by the `--` argument (so is an
#:     explicit OPERAND)
#:   - null/empty: an interleaved/mixed OPERAND (see
#:     [`BS_LIBGETARGS_CONFIG_INTERLEAVED_OPERANDS`](#bs_libgetargs_config_interleaved_operands))
#:   - `-`: an unmatched OPTION (see
#:     [`BS_LIBGETARGS_CONFIG_ALLOW_UNMATCHED`](#bs_libgetargs_config_allow_unmatched)),
#:     in this case, `VALUE` _may_ be an OPTION.
#: - Provided as an example VALIDATOR, not likely to be generally useful,
#:   although it can detect some potential errors where an OPTION-ARGUMENT
#:   has been omitted.
#: - When validation is enabled, this is invoked for all OPTIONs that have an
#:   OPTION-ARGUMENT and for all OPERANDs.
#: - A VALIDATOR can NOT change the value, although it is possible to edit the
#:   contents of `TARGET` this is NOT supported and in most cases any changes
#:   will be lost.
#: - Any output written by a VALIDATOR to `STDOUT` is redirected to `STDERR`
#:   and is NOT affected by configuration that affects other `getargs` errors.
#: - An "invalid value" error will be generated by `getargs` for any value that
#:   fails validation, this will appear _after_ any output generated by the
#:   VALIDATOR.
#: - For this VALIDATOR the warning generated can NOT be suppressed (i.e. output
#:   is always generated if an issue is found).
#:
#_______________________________________________________________________________
getargs_validate_option_value() { ## cSpell:Ignore BS_LGAVVW_
   BS_LGAVVW_refTarget="${1:?'[libgetargs::getargs_validate_option_value]: Internal Error: a target variable name is required'}"
      BS_LGAVVW_Option="${2:?'[libgetargs::getargs_validate_option_value]: Internal Error: an option name is required'}"
   BS_LGAVVW_ValueType="${3:?'[libgetargs::getargs_validate_option_value]: Internal Error: a value type is required'}"
       BS_LGAVVW_Value="${4?'[libgetargs::getargs_validate_option_value]: Internal Error: a value is required'}"

  #  Skip explicit OPERANDs
  case ${BS_LGAVVW_Option} in '--') return ;; esac

  #  Only check OPTION-ARGUMENTs and OPERANDs
  case ${BS_LGAVVW_ValueType} in
  "${BS_LIBGETARGS_TYPE_OPT_ARG}"|"${BS_LIBGETARGS_TYPE_OPERAND}")
    case ${BS_LGAVVW_Value} in
    '-'[!-]* | '--'[!-]*)  # Value starts with '-', generate a warning
      printf "[%s]: WARNING: option argument '%s' for option '%s' (target variable '%s') looks like an option\n" \
             "${g_BS_LGA__ID:-getargs}" \
             "${BS_LGAVVW_Value}"       \
             "${BS_LGAVVW_Option}"      \
             "${BS_LGAVVW_refTarget}"   >&2 ;;
    esac ;;
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `getargs_operands_to_options`
#:
#: Helper to convert OPERANDs in OPTIONs with a given option name.
#:
#: Intended for use when OPERANDs need to be used with a command that does
#: not support OPERANDs. Each OPERAND becomes an OPTION-ARGUMENT for the
#: given OPTION (this requires the command allows specifying a specific OPTION
#: multiple times).
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     getargs_operands_to_options <VALUES> <OPTION>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `VALUES` \[in/out:ref]
#:
#: : An emulated array containing the values to be converted.
#: : Receives generated OPTIONs as an emulated array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array.
#:
#: `OPTION` \[in]
#:
#: : The OPTION-NAME to use for each element in `VALUES`.
#: : Each element in `VALUES` will become and
#:   OPTION-ARGUMENT for `OPTION`.
#: : A trailing `=` (`<equals>`) will cause the
#:   OPTION-ARGUMENT to be made an AGGREGATE-OPTION-ARGUMENT.
#; : A trailing `=` (`<equals>`) causes the OPERAND to be appended to
#;   OPTION as a single value, otherwise a pair of an
#;   OPTION followed by the OPERAND is created.
#:
#: _NOTES_
#: <!-- -->
#:
#: - A command that accepts OPERANDs often uses these to invoke additional
#:   commands. However, it's not always easy/possible/desirable to pass OPERANDs
#:   directly to the invoked commands - where this is the case, passing OPERANDs
#:   as multiple OPTIONs with OPTION-ARGUMENTs may be required.
#: - Although intended for OPERANDs, can be used for any values; simple turns
#:   all elements in `VALUES` into OPTION-ARGUMENTs for the given `OPTION`.
#: - For AGGREGATE-OPTION-ARGUMENTs the number of elements in the output will
#:   be the same as the input, otherwise there will be twice the number of
#:   output elements.
#: - Since the same OPTION is used for **all** parameters, this must be
#:   supported by the command for which the output is intended. In `getargs`
#:   terminology, this means the OPTION needs to have the type `[+]` (i.e. be a
#:   _multi_ OPTION-ARGUMENT) OPTION.
#: - For commands that support `getargs` this is not required as an array of
#:   values can be used directly with `[+]` type OPTIONs by using an
#:   OPTION-TAG.
#:
#_______________________________________________________________________________
getargs_operands_to_options() { ## cSpell:Ignore BS_LGAOTO_
  #---------------------------------------------------------
  case $# in
  2)  BS_LGAOTO_refOperands="$1"
           BS_LGAOTO_Option="$2" ;;
  *)  fn_bs_lga_expected 'an array of operands' 'an option'
      return "${c_BS_LGA__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  fn_bs_lga_validate_name "${BS_LGAOTO_refOperands:-}" || return $?

  #---------------------------------------------------------
  # Array Unpack
  eval "BS_LGAOTO_Operands=\${${BS_LGAOTO_refOperands}-}" || return $?
  eval "set 'i_BS_SET_DUMMY' ${BS_LGAOTO_Operands} && shift" || return $?

  #---------------------------------------------------------
  # Early out if nothing to do
  case $# in 0) return;; esac

  #---------------------------------------------------------
  # Set the appropriate prefix if none is present
  case ${BS_LGAOTO_Option} in
  [!-]     ) BS_LGAOTO_Option="-${BS_LGAOTO_Option}"  ;;
  [!-][!-]*) BS_LGAOTO_Option="--${BS_LGAOTO_Option}" ;;
  esac

  #---------------------------------------------------------
  # Repack the operands with the option as a prefix
  BS_LGAOTO_Operands="$(fn_bs_lga_operands_to_options "${BS_LGAOTO_Option}" "$@")"

  #---------------------------------------------------------
  # Save the converted values
  eval "${BS_LGAOTO_refOperands}=\"\${BS_LGAOTO_Operands}\""
}

#===============================================================================
#===============================================================================
#  SOURCED
#
#+ Helper to make it easier for reliant tools to check this file has been
#+ sourced. Needs to _never_ be exported (if exported it will report the
#+ script as sourced when running sub-commands where the functions are not
#+ actually available)
#===============================================================================
#===============================================================================
case $- in
*a*) set +a; BS_LIBGETARGS_SOURCED=1; set -a ;;
  *)         BS_LIBGETARGS_SOURCED=1         ;;
esac
fn_bs_lga_readonly 'BS_LIBGETARGS_SOURCED'

############################ DOCUMENTATION CONTINUED ###########################
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## VERSIONS
#.
#. v1.0.0          First Release
#.
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## STANDARDS
#:
#: - [_POSIX.1-2008_][posix]
#:   - also known as:
#:     - _The Open Group Base Specifications Issue 7_
#:     - _IEEE Std 1003.1-2008_
#:     - _The Single UNIX Specification Version 4 (SUSv4)_
#:   - the more recent
#:     [_POSIX.1-2017_][posix_2017]
#:     is functionally identical to _POSIX.1-2008_, but incorporates some errata
#: - [FreeBSD SYSEXITS(3)][sysexits]
#:   - while not truly standard, these are used by many projects
#: - [Semantic Versioning v2.0.0][semver]
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## NOTES
#:
#: <!-- ------------------------------------------------ -->
#:
#: ### TERMINOLOGY
#:
#: Terminology used for `getargs` is based on the
#: [_POSIX.1_ "Utility Conventions"][posix_utility_conventions].
#:
#: _POSIX.1 Terms_
#: <!-- ------ -->
#:
#: - `ARGUMENT`
#:   - a value passed to a command when invoked
#:   - assigned to shell positional parameters
#:   - every `ARGUMENT` is either an `OPTION`, an `OPTION-ARGUMENT`
#:     or an `OPERAND`
#: - `OPTION`
#:   - an `ARGUMENT` starts with `-` (`<hyphen>`) character
#:   - any `OPTION` may be associated with an `OPTION-ARGUMENT`
#: - `OPTION-ARGUMENT`
#:   - a value given to a specific `OPTION`
#:   - specified either as the subsequent `ARGUMENT`, or as part of the same
#:     `ARGUMENT` as the associated `OPTION`
#:   - an optional `OPTION-ARGUMENT` can only be specified as part of the same
#:     string as the `OPTION`
#: - `OPERAND`
#:   - an `ARGUMENT` that is not an `OPTION` or an `OPTION-ARGUMENT`
#:
#: _Additional Terms_
#: <!-- --------- -->
#:
#: - `OPTION-NAME` _or_ `NAME`
#:   - the characters excluding the `-` (`<hyphen>`) prefix
#:   - _uniquely_ defines an `OPTION` for a given command
#:   - if multiple `OPTION-NAME`s are provided for a single `OPTION`, each is
#:     an `OPTION-ALIAS` (_or_ `ALIAS`) for that `OPTION`
#: - `SHORT-OPTION` _or_ `SHORT`
#:   - an `OPTION` where the `OPTION-NAME` is a single character
#:   - always specified with a single leading `-` (`<hyphen>`)
#: - `COMPOUND-OPTION` _or_ `COMPOUND`
#:   - multiple `SHORT-OPTION`s specified as a single `OPTION` following a
#:     single leading `-` (`<hyphen>`)
#:   - only the last `SHORT-OPTION` in `COMPOUND-OPTION` can have an
#:     `OPTION-ARGUMENT`
#: - `LONG-OPTION` _or_ `LONG`
#:   - an `OPTION` where the `OPTION-NAME` is a two or more characters
#:   - may be specified using the prefix `-` (`<hyphen>`) or
#:     `--` (`<hyphen><hyphen>`)
#: - `POSIX-LONG-OPTION` _or_ `POSIX-LONG`
#:   - a `LONG-OPTION` with the prefix `-` (`<hyphen>`)
#: - `GNU-LONG-OPTION` _or_ `GNU-LONG`
#:   - a `LONG-OPTION` with the prefix `--` (`<hyphen><hyphen>`)
#: - `ABBREVIATED-LONG-OPTION` _or_ `ABBREVIATED-OPTION`
#:   - a `LONG-OPTION` that only matches as a prefix of a `OPTION-NAME`
#:   - has a minimum length of 2 characters
#: - `SWITCH-OPTION` _or_ `SWITCH`
#:   - an `OPTION` which has no `OPTION-ARGUMENT`
#: - `OPTION-TAG` _or_ `TAG`
#:   - a suffix appended to an `OPTION` following a `:` (`<colon>`) character
#:   - modifies how the `OPTION` is processed
#: - `AGGREGATE-OPTION-ARGUMENT` _or_ `AGGREGATE-ARGUMENT`
#:   - an `OPTION-ARGUMENT` specified as part of the same `ARGUMENT` as the
#:     `OPTION` itself
#:   - delimited from an `OPTION` using `=` (`<equals>`) (optional for
#:     `SHORT-OPTION`s and `COMPOUND-OPTION`s)
#:
#: For each `OPTION` an `OPTION-ARGUMENT` is either:
#:
#: - _prohibited_
#:   - the `OPTION` is a `SWITCH-OPTION`
#: - _optional_
#:   - an `OPTION-ARGUMENT` MAY be specified
#:   - `OPTION-ARGUMENT` MUST be specified in the same `ARGUMENT` as the
#:     `OPTION` (a `LONG-OPTION` with an `OPTION-ARGUMENT` MUST delimit the
#:     `OPTION` from the `OPTION-ARGUMENT` using an `=` (`<equals>`) character)
#: - _required_
#:   - an `OPTION-ARGUMENT` is REQUIRED
#:   - it is an error to specify the `OPTION` more than once
#: - _resettable_
#:   - an `OPTION-ARGUMENT` is REQUIRED
#:   - The `OPTION` can be specified multiple times
#:   - only the last specified `OPTION-ARGUMENT` is used
#: - _multi_
#:   - an `OPTION-ARGUMENT` is REQUIRED
#:   - the `OPTION` can be specified multiple times, and _all_
#:     `OPTION-ARGUMENT`s are used
#:
#: A `SWITCH-OPTION` is either:
#:
#: - _simple_
#:   - MUST be specified at most once
#: - _incrementing_
#:   - MAY be specified multiple times
#:   - each occurrence increments the currently stored value for the `OPTION`
#:   - MAY be specified with a _numerical_ `OPTION-TAG` which sets the
#:     currently stored value for the `OPTION`
#: - _negatable_
#:   - MAY be specified multiple times
#:   - is either `<unset>`, `true`, or `false`
#:   - MAY be specified with a `OPTION-TAG` of either `true` or `false` which
#:     sets the currently stored value for the `OPTION`
#:   - if no `OPTION-TAG` is specified, value is set to `true`
#:
#: _Notes_
#: <!-- -->
#:
#: - As the `GNU-LONG-OPTION` format is that which is most widely used it is
#:   sometimes referred to as simply `LONG-OPTION`, while a `POSIX-LONG-OPTION`
#:   is always explicitly named as such (when such a distinction matters).
#: - A _simple_ `SWITCH-OPTION` is _NOT_ directly supported by `getargs` but
#:   can be emulated using the other types of `SWITCH-OPTION`.
#:
#: _Example Arguments_
#: <!-- ---------- -->
#:
#:      command [-a] [-b] [-c value] [-debug] [--verbose|-v] [-user|-u[value]] [value...]
#:
#:      command -deb:false --verbose:1 -abc FIRST -uSECOND --password=THIRD FOURTH
#:
#: - `-a`,`-b`,`-c`,`-v`, and `-u` are `SHORT-OPTION`s
#: - `-debug` is a `POSIX-LONG-OPTION`
#: - `--verbose` is a `GNU-LONG-OPTION`
#: - `FIRST`, `SECOND`, and `THIRD` are `OPTION-ARGUMENT`s
#: - `FOURTH` is an `OPERAND`
#: - `-a`,`-b`,`-debug`,`--verbose|-v`, and `-u` are `SWITCH-OPTION`s
#: - `-abc` is a `COMPOUND-OPTION`
#: - `SECOND` and `THIRD` are `AGGREGATE-OPTION-ARGUMENT`s
#: - `SECOND` is an _optional_ `OPTION-ARGUMENT`
#: - `-deb` is an `ABBREVIATED-LONG-OPTION`
#: - `false` and `1` are `OPTION-TAG`s
#: - `-deb:false` is a _negatable_ `SWITCH-OPTION`
#: - `--verbose:1` is an _incrementing_ `SWITCH-OPTION`
#: - `--verbose:1` is equivalent to `--verbose` and `-deb:true` is equivalent to
#:   `-deb`
#:
#: <!-- ------------------------------------------------ -->
#:
#: ### GENERAL
#:
#: - The first ARGUMENT with the value `--` is a special ARGUMENT that acts as
#:   a delimiter marking the end of OPTIONs; any following ARGUMENTs are
#:   considered OPERANDs. It is highly recommended that this is used where
#:   possible - albeit rare, omitting this can lead to difficult to diagnose
#:   errors in some use cases.
#: - Much of this library is only supported in certain circumstances, for
#:   example when the `POSIX` locale is used; note that "unsupported" does not
#:   imply that such usage will not work, however unexpected behavior may occur
#:   and any bugs encountered are unlikely to be addressed.
#: - `getargs` supports all the functionality of `getopts` and `getopt`
#: - The [`util-linux`][util_linux] specified `getopt` is one of a number of
#:   commands with the same name and similar usage, however other versions seem
#:   much less capable (many of which are implementations of the precursor to
#:   standard specified `getopts`).
#:
#: <!-- ------------------------------------------------ -->
#:
#: ### PERFORMANCE
#:
#: Performance of `getargs` is always likely to be lower than that of `getopt`
#: or `getopts` as these utilities provide less functionality and are invoked
#: as binaries. However, when used to process arguments for an entire script,
#: performance is unlikely to be an issue.
#:
#: When using `getargs` for individual script functions it is possible that
#: performance MAY become an issue through accumulated costs (although it is
#: still likely to be far outweighed by other costs).
#:
#: In cases where performance of `getargs` becomes an issue it is possible to
#: improve performance with careful usage. The largest gains can be made by
#: changing the shell being used: for example, while `bash` is a highly
#: competent shell with a many useful extensions, the less well equipped `dash`
#: is significantly faster for use with `getargs`. Similarly the specific
#: implementation of utilities like `sed`, or `grep` used can have a measurable
#: impact.
#:
#: The configuration of `getargs` can also make a difference. The biggest single
#: change is to allow ambiguous options, which will use `expr` (or rarely `sed`)
#: rather than `grep`, resulting in improved performance. Disabling other
#: options where they are noted to have a performance impact will also help
#: (though to a lesser extent). Additionally, setting config using the provided
#: [environment variables](#environment) rather than passing as options to
#: `getargs` options, can make minor improvements.
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## CAVEATS
#:
#: The environment in which the library is invoked will dictate limitations
#: for the library that can not be avoided. In particular, the command line
#: length limit will impose restrictions on the length of a single invocation
#: of `getargs`, though other limitations may also be problematic.
#:
#: Importantly, the command line length limit imposes a limit on the combined
#: length of _both_ the SPECIFICATION _and_ the ARGUMENTs to process, and may
#: be a particular issue where [AUTO-HELP](#auto-help) is used.
#:
#: _For more details see the common suite [documentation](./README.MD#caveats)._
#: 
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## EXAMPLE
#:
#: Additional examples can be found in the test files for the library.
#:
#: ---------------------------------------------------------
#:
#: A `chmod` like utility providing additional options:
#:
#:     #!/bin/sh
#:
#:     . libgetargs.sh
#:
#:     getargs --unset              --auto-help                                            \
#:             -i "${0}"                                                                   \
#:             -o 'm|mode[:]opt_Mode#The mode to set for all paths.'                       \
#:             -o 'p|path[+]opt_aPaths#One or more paths to edit.'                         \
#:             -o 'R|recursive[-]opt_Recurse#Recurse into any directories.'                \
#:             -o 'L|traverse-links[-]opt_TraverseLinks#Evaluate any links encountered'    \
#:             -o 'single-device[-]opt_SingleDevice#Process only paths on a single device' \
#:             -o '1|one-device|xdev[-]opt_SingleDevice'                                   \
#:             -p '[^]opt_Mode,[+]opt_aPaths'                                              \
#:             -- "$@" || exit
#:
#:     eval "set -- ${opt_aPaths+${opt_aPaths}}"
#:
#:     case ${opt_Recurse:+R} in
#:     R) find ${opt_TraverseLinks+-L}       \
#:             "$@"                          \
#:             ${opt_SingleDevice+-xdev}     \
#:             -exec                         \
#:               'chmod'                     \
#:                 ${opt_Mode+"${opt_Mode}"} \
#:                 '{}' '+'
#:        ;;
#:
#:     *) 'chmod' ${opt_Mode+"${opt_Mode}"} "$@" ;;
#:     esac
#:
#: ### COMPARISON
#:
#: The following example is adapted from
#: [the Wikipedia page for `getopts`](<https://wikipedia.org/wiki/Getopts#Examples>)
#: and is implemented for `getopts`, `getopt` and `getargs`
#: to provide a comparison between the available tools.
#:
#: ---------------------------------------------------------
#:
#: **`getopts`**
#: <!-- ---- -->
#:
#:     #!/bin/bash
#:     VERBOSE=0
#:     ARTICLE=''
#:     LANG=en
#:
#:     while getopts ':a:l:v' opt; do
#:         case $opt in
#:           (v)   ((VERBOSE++));;
#:           (a)   ARTICLE=$OPTARG;;
#:           (l)   LANG=$OPTARG;;
#:           (:)   # "optional arguments" (missing option-argument handling)
#:                 case $OPTARG in
#:                   (a) exit 1;; # error, according to our syntax
#:                   (l) :;;      # acceptable but does nothing
#:                 esac;;
#:         esac
#:     done
#:
#:     shift "$OPTIND"
#:     # remaining is "$@"
#:
#:     if ((VERBOSE > 2)); then
#:       printf '%s\n' 'Non-option arguments:'
#:       printf '%q ' "${remaining[@]]}"
#:     fi
#:
#:     if ((VERBOSE > 1)); then
#:       printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
#:     fi
#:
#:     if [[ ! $ARTICLE ]]; then
#:       printf '%s\n' "No articles!">&2
#:       exit 1
#:     fi
#:
#:     save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"
#:
#: ---------------------------------------------------------
#:
#: **`getopt`**
#: <!-- --- -->
#:
#:     #!/bin/bash
#:     VERBOSE=0
#:     ARTICLE=''
#:     LANG=en
#:
#:     ARGS=$(getopt -o 'a:l::v' --long 'article:,language::,lang::,verbose' -- "$@") || exit
#:     eval "set -- $ARGS"
#:
#:     while true; do
#:         case $1 in
#:           (-v|--verbose)
#:                 ((VERBOSE++)); shift;;
#:           (-a|--article)
#:                 ARTICLE=$2; shift 2;;
#:           (-l|--lang|--language)
#:                 # handle optional: getopt normalizes it into an empty string
#:                 if [ -n "$2" ]; then
#:                   LANG=$2
#:                 fi
#:                 shift 2;;
#:           (--)  shift; break;;
#:           (*)   exit 1;;           # error
#:         esac
#:     done
#:     remaining=("$@")
#:
#:     if ((VERBOSE > 2)); then
#:       printf '%s\n' 'Non-option arguments:'
#:       printf '%q ' "${remaining[@]]}"
#:     fi
#:
#:     if ((VERBOSE > 1)); then
#:       printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
#:     fi
#:
#:     if [[ ! $ARTICLE ]]; then
#:       printf '%s\n' "No articles!">&2
#:       exit 1
#:     fi
#:
#:     save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"
#:     </pre>
#:
#: ---------------------------------------------------------
#:
#: **`getargs`**
#: <!-- ---- -->
#:
#:     #!/bin/sh
#:
#:     . libgetargs.sh
#:
#:     getargs --unset                     \
#:             -o 'verbose|v[:]VERBOSE'    \
#:             -o 'article|a[:]ARTICLE'    \
#:             -o 'language|lang|l[?]LANG' \
#:             -p '[+]REMAINING'           \
#:             -- "$@"                     || exit
#:     eval "set -- ${REMAINING+${REMAINING}}"
#:     : "${VERBOSE:=0}"
#:     : "${LANG:=en}"
#:
#:     if ((VERBOSE > 2)); then
#:        printf '%s\n' 'Non-option arguments:'
#:        printf '%q ' "$@"
#:     fi
#:
#:     if ((VERBOSE > 1)); then
#:        printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
#:     fi
#:
#:     if [[ ! $ARTICLE ]]; then
#:        printf '%s\n' "No articles!" \>&2
#:        exit 1
#:     fi
#:
#:     save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"
#:
#: ---------------------------------------------------------
#:
#: **`getarg`**
#: <!-- --- -->
#:
#:     #!/bin/sh
#:
#:     MyArgs="$(
#:        getarg --unset                   \
#:             -o 'verbose|v[:]VERBOSE'    \
#:             -o 'article|a[:]ARTICLE'    \
#:             -o 'language|lang|l[?]LANG' \
#:             -p '[+]REMAINING'           \
#:             -- "$@"
#:     )" || exit
#:     eval "${MyArgs}"
#:     eval "set -- ${REMAINING+${REMAINING}}"
#:     : "${VERBOSE:=0}"
#:     : "${LANG:=en}"
#:
#:     if ((VERBOSE > 2)); then
#:        printf '%s\n' 'Non-option arguments:'
#:        printf '%q ' "$@"
#:     fi
#:
#:     if ((VERBOSE > 1)); then
#:        printf 'Downloading %s:%s\n' "$LANG" "$ARTICLE"
#:     fi
#:
#:     if [[ ! $ARTICLE ]]; then
#:        printf '%s\n' "No articles!" \>&2
#:        exit 1
#:     fi
#:
#:     save_webpage "https://${LANG}.wikipedia.org/wiki/${ARTICLE}"
#:
#% <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#%
#% ## SEE ALSO
#%
#% betterscripts(7), libarray(7)
#%
#: <!-- -------------------------------------------------------------------- -->
#: <!-- REFERENCES -->
#: <!-- -------------------------------------------------------------------- -->
#:
#: [markdown]:                  <https://daringfireball.net/projects/markdown/syntax>                                                "Markdown: Syntax [daringfireball.net]"
#: [commonmark]:                <https://commonmark.org/>                                                                            "CommonMark [spec.commonmark.org]"
#: [commonmark_spec]:           <https://spec.commonmark.org/current/>                                                               "CommonMark Spec (current) [spec.commonmark.org]"
#:
#: [posix]:                     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                       "POSIX.1-2008 \[pubs.opengroup.org\]"
#: [posix_2017]:                <https://pubs.opengroup.org/onlinepubs/9699919799>                                                   "POSIX.1-2017 \[pubs.opengroup.org\]"
#: [posix_bre]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>     "Basic Regular Expression \[pubs.opengroup.org\]"
#: [posix_ere]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>     "Extended Regular Expression \[pubs.opengroup.org\]"
#: [posix_re_bracket_exp]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03_05>  "RE Bracket Expression \[pubs.opengroup.org\]"
#: [posix_param_expansion]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02> "Parameter Expansion \[pubs.opengroup.org\]"
#: [posix_getopts]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html>                "getopts \[pubs.opengroup.org\]"
#: [posix_utility_conventions]: <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap12.html>               "POSIX: Utility Conventions \[pubs.opengroup.org\]"
#: [posix_variable]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_230>    "Definitions: Name \[pubs.opengroup.org\]"
#:
#: [sysexits]:                  <https://www.freebsd.org/cgi/man.cgi?sysexits(3)>                                                    "FreeBSD SYSEXITS(3) \[freebsd.org\]"
#: [semver]:                    <https://semver.org/>                                                                                "Semantic Versioning \[semver.org\]"
#:
#: [util_linux]:                <https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/about/>                              "util-linux (about) \[git.kernel.org\]"
#:
#: [pandoc]:                    <https://pandoc.org/>                                                                                "Pandoc \[pandoc.org\]"
#:
#: [man_page]:                  <https://wikipedia.org/wiki/Man_page>                                                                "man page \[wikipedia.org\]"
#:
#: [autoconf_portable]:         <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>           "autoconf: Portable Shell Programming \[gnu.org\]"
#:
################################################################################

################################################################################
#  END
################################################################################
