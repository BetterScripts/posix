#!/usr/bin/env false
# SPDX-License-Identifier: MPL-2.0
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libarray': Array emulation for POSIX.1 compliant shells.    *#
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

################################### LIBARRAY ###################################
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
#===============================================================================
## cSpell:Ignore libarray
################################ DOCUMENTATION #################################
#
#% % libarray(7) BetterScripts | Array emulation for POSIX.1 shells.
#% % BetterScripts (better.scripts@proton.me)
#
#: <!-- #################################################################### -->
#: <!-- ############ THIS FILE WAS GENERATED FROM 'libarray.sh' ############ -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # LIBARRAY
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## SYNOPSIS
#:
#: [`array_value <VALUE>`](#array_value)
#:
#: [`array_new [--reverse|--reversed|-r] <ARRAY> [<VALUE>...]`](#array_new)
#:
#: [`array_size <ARRAY> [<OUTPUT>]`](#array_size)
#:
#: [`array_get <ARRAY> <INDEX> [<OUTPUT>]`](#array_get)
#:
#: [`array_set <ARRAY> <INDEX> <VALUE>`](#array_set)
#:
#: [`array_insert <ARRAY> <INDEX> <VALUE>...`](#array_insert)
#:
#: [`array_remove <ARRAY> [<PRIMARY>] <EXPRESSION>`](#array_remove)
#:
#: [`array_push <ARRAY> [<VALUE>...]`](#array_push)
#:
#: [`array_pop <ARRAY> <OUTPUT>`](#array_pop)
#:
#: [`array_unshift <ARRAY> [<VALUE>...]`](#array_unshift)
#:
#: [`array_shift <ARRAY> <OUTPUT>`](#array_shift)
#:
#: [`array_reverse <ARRAY> [<OUTPUT>]`](#array_reverse)
#:
#: [`array_slice <ARRAY> <RANGE> [<OUTPUT>]`](#array_slice)
#:
#: [`array_sort <ARRAY> [<OUTPUT>] [--] [<ARGUMENT>...]`](#array_sort)
#:
#: [`array_search <ARRAY> [<INDEX>] [<PRIMARY>] <EXPRESSION>`](#array_search)
#:
#: [`array_contains <ARRAY> [<PRIMARY>] <EXPRESSION>`](#array_contains)
#:
#: [`array_join <ARRAY> <DELIM> [<OUTPUT>]`](#array_join)
#:
#: [`array_split [<ARRAY>] <TEXT> <SEPARATOR>`](#array_split)
#:
#: [`array_printf <ARRAY> <FORMAT>`](#array_printf)
#:
#: [`array_from_path [--all|-a] [<ARRAY>] <DIRECTORY>`](#array_from_path)
#:
#: [`array_from_find [<ARRAY>] [--] [<ARGUMENT>...]`](#array_from_find)
#:
#: [`array_from_find_allow_print <ARRAY> [<DESC>] [--] [<ARGUMENT>...]`](#array_from_find_allow_print)
#:
#: _Full synopsis, description, arguments, examples and other information is_
#: _documented with each individual command._
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## DESCRIPTION
#:
#: Provides commands to allow any _POSIX.1_ compliant shell to use emulated
#: arrays with all common array operations supported.
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## EXIT STATUS
#:
#: - For all commands the exit status will be `0` (`<zero>`) if, and only if,
#:   the command was completed successfully.
#: - For any command which is intended to perform a test, an exit status of
#:   `1` (`<one>`) indicates "false", while `0` (`<zero>`) indicates "true".
#: - An exit status that is NOT `0` (`<zero>`) from an external command will
#:   be propagated to the caller where relevant (and possible).
#: - For any usage error (e.g. an unsupported variable name), the `EX_USAGE`
#:   error code from [FreeBSD `SYSEXITS(3)`][sysexits] is used.
#: - Configuration SHOULD NOT change the value of any exit status.
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
#         variables intended for use by scripts that source this library.      #
#         Using `export` is _not_ a solution as these values should only be    #
#         present in the current shell environment and _not_ inherited.        #
# shellcheck disable=SC2034                                                    #
#                                                                              #
################################################################################

#===============================================================================
#===============================================================================
# SOURCE GUARD
#===============================================================================
#===============================================================================
case ${BS_LIBARRAY_SOURCED:+1} in 1) return ;; esac

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
#. ### `fn_bs_libarray_readonly`
#.
#. Wrapper round `readonly`.
#.
#. Required because in its default configuration Z Shell's `readonly` causes
#. problems (due to variable scoping).
#.
#. See [`BS_LIBARRAY_CONFIG_NO_Z_SHELL_SETOPT`](#bs_libarray_config_no_z_shell_setopt)
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libarray_readonly <VAR>...
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
fn_bs_libarray_readonly() { ## cSpell:Ignore BS_LA_readonly_
  case ${c_BS_LIBARRAY_CFG_USE__zsh_setopt} in
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
#: #### `BS_LIBARRAY_CONFIG_NO_Z_SHELL_SETOPT`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`](./README.MD#better_scripts_config_no_z_shell_setopt)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
#:   _POSIX.1_ like behavior.
#: - Automatically enabled if _Z Shell_ is detected.
#: - Any use of `setopt` is scoped as tightly as possible
#:   and SHOULD not affect other commands.
#. - See [`fn_bs_libarray_readonly`](#fn_bs_libarray_readonly).
#:
case ${BS_LIBARRAY_CONFIG_NO_Z_SHELL_SETOPT:-${BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT:-A}} in
A)  case ${ZSH_VERSION:+1} in
    1) c_BS_LIBARRAY_CFG_USE__zsh_setopt=1 ;;
    *) c_BS_LIBARRAY_CFG_USE__zsh_setopt=0 ;;
    esac ;;
0) c_BS_LIBARRAY_CFG_USE__zsh_setopt=0 ;;
*) c_BS_LIBARRAY_CFG_USE__zsh_setopt=1 ;;
esac

fn_bs_libarray_readonly 'c_BS_LIBARRAY_CFG_USE__zsh_setopt'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_MULTIDIGIT_PARAMETER`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_MULTIDIGIT_PARAMETER`](./README.MD#better_scripts_config_no_multidigit_parameter)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - \[Disable]/Enable using only single digit shell
#:   parameters, i.e. `$0` to `$9`.
#: - _OFF_: Use multi-digit shell parameters.
#: - _ON_: Use only single-digit shell parameters.
#: - Multi-digit parameters are faster but may not be
#:   supported by all implementations.
#:
case ${BS_LIBARRAY_CONFIG_NO_MULTIDIGIT_PARAMETER:-${BETTER_SCRIPTS_CONFIG_NO_MULTIDIGIT_PARAMETER:-A}} in
A)  case $(
            {
              set 1 2 3 4 5 6 7 8 9 10 11 12
              if test "${10}" -eq 10; then
                echo 'SUCCESS'
              else
                echo 'FAILED'
              fi
            } 2>&1
          ) in
    'SUCCESS') c_BS_LIBARRAY_CFG_USE__multidigit_param=1 ;;
            *) c_BS_LIBARRAY_CFG_USE__multidigit_param=0 ;;
    esac ;;
0)  c_BS_LIBARRAY_CFG_USE__multidigit_param=1 ;;
*)  c_BS_LIBARRAY_CFG_USE__multidigit_param=0 ;;
esac

fn_bs_libarray_readonly 'c_BS_LIBARRAY_CFG_USE__multidigit_param'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_SHIFT_N`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_SHIFT_N`](./README.MD#better_scripts_config_no_shift_n)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - \[Disable]/Enable using only `shift` and not `shift N`
#:   for multiple parameters.
#: - _OFF_: Use `shift N`.
#: - _ON_: Use only `shift`.
#: - Multi-parameter `shift` is faster but may not be
#:   supported by all implementations
#:
case ${BS_LIBARRAY_CONFIG_NO_SHIFT_N:-${BETTER_SCRIPTS_CONFIG_NO_SHIFT_N:-A}} in
A)  case $(
            {
              set 1 2 3 4 5 6 7 8 9 10 11 12
              if shift 10 && test "$1" -eq 11; then
                echo 'SUCCESS'
              else
                echo 'FAILED'
              fi
            } 2>&1
          ) in
    'SUCCESS') c_BS_LIBARRAY_CFG_USE__shift_n=1 ;;
            *) c_BS_LIBARRAY_CFG_USE__shift_n=0 ;;
    esac ;;
0)  c_BS_LIBARRAY_CFG_USE__shift_n=1 ;;
*)  c_BS_LIBARRAY_CFG_USE__shift_n=0 ;;
esac

fn_bs_libarray_readonly 'c_BS_LIBARRAY_CFG_USE__shift_n'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_EXPR_BRE_MATCH`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_EXPR_BRE_MATCH`](./README.MD#better_scripts_config_no_expr_bre_match)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - \[Disable]/Enable using alternatives to `expr` for
#:   matching a
#:   ["Basic Regular Expression (_BRE_)"][posix_bre].
#: - _OFF_: Use `expr`.
#: - _ON_: Use an alternative command (i.e. `sed`).
#: - `expr` is much faster if it works correctly, but
#:   some implementations make that difficult, while
#:   `sed` is more robust for this use case.
#:
case ${BS_LIBARRAY_CONFIG_NO_EXPR_BRE_MATCH:-${BETTER_SCRIPTS_CONFIG_NO_EXPR_BRE_MATCH:-A}} in
A)  case $(
            {
              # HP-UX 11: Only One \(
              # QNX 4.25: Exit Status Always 1 If \( Used
              BS_LA_expr_match1="$(expr 'Test Value' : '\(Te\(st\)\)')" || echo 'FAILED'
              # QNX 4.25: Failed Match -> Output '0'
              BS_LA_expr_match2="$(expr 'Test Value' : '\(No Test\)')" && echo 'FAILED'
              # Tru64: Strips Leading Zeros (string -> number)
              BS_LA_expr_match3="$(expr '0000000100' : '.*\(.....\)')" || echo 'FAILED'
              # Mac OS X 10.4: [^-] problems
              BS_LA_expr_match4="$(expr 'Expr-Test-Successful' : '[^-]*-[^-]*-\(.*\)')" || echo 'FAILED'
              printf '%s%s %s%% %s'           \
                      "${BS_LA_expr_match1-}" \
                      "${BS_LA_expr_match2-}" \
                      "${BS_LA_expr_match3-}" \
                      "${BS_LA_expr_match4-}"
            } 2>&1
          ) in
    'Test 00100% Successful') c_BS_LIBARRAY_CFG_USE__expr_bre_match=1 ;;
                           *) c_BS_LIBARRAY_CFG_USE__expr_bre_match=0 ;;
    esac ;;
0)  c_BS_LIBARRAY_CFG_USE__expr_bre_match=0 ;;
*)  c_BS_LIBARRAY_CFG_USE__expr_bre_match=1 ;;
esac

fn_bs_libarray_readonly 'c_BS_LIBARRAY_CFG_USE__expr_bre_match'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_DEV_NULL`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_DEV_NULL`](./README.MD#better_scripts_config_no_dev_null)
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  \<automatic>
#: - \[Disable]/Enable using alternatives to `/dev/null` as
#:   a redirection source/target (e.g. for output
#:   suppression).
#: - _OFF_: Use `/dev/null`.
#: - _ON_: Use an alternative to `/dev/null`.
#: - Using `/dev/null` as a redirection target is a
#:   common idiom, but not always possible (e.g.
#:   restricted shells generally forbid this), the
#:   alternative is to capture output (and ignore it)
#:   but this is much slower as it involves a subshell.
#:
#. _IMPLEMENTATION NOTES_
#.
#. - An additional subshell is needed here to suppress shell
#.   error messages when `/dev/null` is not accessible.
#.
case ${BS_LIBARRAY_CONFIG_NO_DEV_NULL:-${BETTER_SCRIPTS_CONFIG_NO_DEV_NULL:-A}} in
A)  case $( ( echo 'TEST' >/dev/null ) 2>&1 && echo 'SUCCESS') in
    'SUCCESS') c_BS_LIBARRAY_CFG_USE__dev_null=1 ;;
            *) c_BS_LIBARRAY_CFG_USE__dev_null=0 ;;
    esac ;;
0)  c_BS_LIBARRAY_CFG_USE__dev_null=1 ;;
*)  c_BS_LIBARRAY_CFG_USE__dev_null=0 ;;
esac

fn_bs_libarray_readonly 'c_BS_LIBARRAY_CFG_USE__dev_null'

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### USER PREFERENCE
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
#: #### `BS_LIBARRAY_CONFIG_QUIET_ERRORS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - \[Enable]/Disable library error message output.
#: - _OFF_: error messages will be written to `STDERR` as:
#:   `[libarray::<COMMAND>]: ERROR: <MESSAGE>`.
#: - _ON_: library error messages will be suppressed.
#: - The most recent error message is always available in
#:   [`BS_LIBARRAY_LAST_ERROR`](#bs_libarray_last_error)
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
#: #### `BS_LIBARRAY_CONFIG_FATAL_ERRORS`
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
#:   [`BS_LIBARRAY_CONFIG_QUIET_ERRORS`](#bs_libarray_config_quiet_errors)).
#: - Both the library version of this option and the
#:   suite version can be modified between command
#:   invocations and will affect the next command.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_START_INDEX_ONE`
#:
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  _OFF_
#: - Enable/\[Disable] one-based indexing.
#: - _OFF_: use `0` (`<zero>`)  based array indexes (i.e.
#:   in the range `[0, size)`).
#: - _ON_:  use `1` (`<one>`) based array indexes (i.e.
#:   in the range `[1, size]`).
#: - Only affects commands that use indexes, i.e.
#:   [`array_get`](#array_get),
#:   [`array_set`](#array_set),
#:   [`array_remove`](#array_remove),
#:   [`array_insert`](#array_insert),
#:   and [`array_slice`](#array_slice)
#: - Negative indexes are **not** affected `-1` is
#:   **always** the last element in the array.
#:
case ${BS_LIBARRAY_CONFIG_START_INDEX_ONE:-0} in
0) c_BS_LIBARRAY_CFG__StartIndex=0 ;;
*) c_BS_LIBARRAY_CFG__StartIndex=1 ;;
esac

fn_bs_libarray_readonly 'c_BS_LIBARRAY_CFG__StartIndex'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`
#:
#: - Type:     TEXT
#: - Class:    CONSTANT
#: - Default:  3
#: - Used by
#:   [`array_from_find_allow_print`](#array_from_find_allow_print)
#:   as the first of two file descriptors to use to redirect
#:   output.
#: - MUST be a single digit integer in the range \[3,9]
#:   (the standard allows for multiple digit file
#:   descriptors, but only _requires_ (and most
#:   implementations only support) single digits)
#: - When the given descriptor is used if it is already
#:   in use with a previous (non-library) command this
#:   _will_ cause errors.
#: - MUST be different to
#:   [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`](#bs_libarray_config_find_redirect_fd_2)
#: - An invalid value will cause a fatal error while
#:   **sourcing**.
#:
case ${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1:+1} in
1)  case ${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1} in
    [3456789]) : ;;
    *) BS_LIBARRAY__ConfigError=;
      : "${BS_LIBARRAY__ConfigError:?"[libarray]: CONFIG ERROR: BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1 (${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1}) must be an integer > 2."}" ;;
    esac
    c_BS_LIBARRAY_CFG__find_fd_1="${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1}" ;;
*)  c_BS_LIBARRAY_CFG__find_fd_1=3 ;;
esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`
#:
#: - Type:     TEXT
#: - Class:    CONSTANT
#: - Default:  4
#: - Used by
#:   [`array_from_find_allow_print`](#array_from_find_allow_print)
#:   as the second of two file descriptors to use to
#:   redirect output.
#: - MUST be a single digit integer in the range \[3,9]
#:   (the standard allows for multiple digit file
#:   descriptors, but only _requires_ (and most
#:   implementations only support) single digits)
#: - When the given descriptor is used if it is already
#:   in use with a previous (non-library) command this
#:   _will_ cause errors.
#: - MUST be different to
#:   [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`](#bs_libarray_config_find_redirect_fd_1)
#: - An invalid value will cause a fatal error while
#:   **sourcing**.
#:
case ${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2:+1} in
1)  case ${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2} in
    [3456789]) : ;;
    *) BS_LIBARRAY__ConfigError=;
      : "${BS_LIBARRAY__ConfigError:?"[libarray]: CONFIG ERROR: BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2 (${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2}) must be an integer > 2."}" ;;
    esac
    c_BS_LIBARRAY_CFG__find_fd_2="${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2}" ;;
*)  # FD_2 = FD_1 + 1, but kept in set [3456789] so that 10->3:
    #    - 3   ->  shift to range [0,7]
    #    + 1   ->  increment
    #    % 7   ->  wrap
    #    + 3   ->  shift to range [3,9]
    #
    # FD_2 = (((FD_1 - 3) + 1) % 7 + 3)
    c_BS_LIBARRAY_CFG__find_fd_2=$(( ( (c_BS_LIBARRAY_CFG__find_fd_1 - 2) % 7) + 3 ))
esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check
# [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`](#bs_libarray_config_find_redirect_fd_1)
# is different to
# [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`](#bs_libarray_config_find_redirect_fd_2)
case $((c_BS_LIBARRAY_CFG__find_fd_1 - c_BS_LIBARRAY_CFG__find_fd_2)) in
0) BS_LIBARRAY__ConfigError=;
   : "${BS_LIBARRAY__ConfigError:?"[libarray]: CONFIG ERROR: BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1 (${c_BS_LIBARRAY_CFG__find_fd_1}) and BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2 (${c_BS_LIBARRAY_CFG__find_fd_2}) must be different."}" ;;
esac

fn_bs_libarray_readonly 'c_BS_LIBARRAY_CFG__find_fd_1' \
                        'c_BS_LIBARRAY_CFG__find_fd_2'

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
#: #### `BS_LIBARRAY_VERSION_MAJOR`
#:
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_VERSION_MINOR`
#:
#: - Integer >= 0.
#: - Incremented for significant changes that do not
#:   break compatibility with previous versions.
#: - Reset to 0 when
#:   [`BS_LIBARRAY_VERSION_MAJOR`](#bs_libarray_version_major)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_VERSION_PATCH`
#:
#: - Integer >= 0.
#: - Incremented for minor revisions or bugfixes.
#: - Reset to 0 when
#:   [`BS_LIBARRAY_VERSION_MINOR`](#bs_libarray_version_minor)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_VERSION_RELEASE`
#:
#: - A string indicating a pre-release version, always
#:   null for full-release versions.
#: - Possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended).
#:
  BS_LIBARRAY_VERSION_MAJOR=1
  BS_LIBARRAY_VERSION_MINOR=0
  BS_LIBARRAY_VERSION_PATCH=0
BS_LIBARRAY_VERSION_RELEASE=;

fn_bs_libarray_readonly 'BS_LIBARRAY_VERSION_MAJOR'   \
                        'BS_LIBARRAY_VERSION_MINOR'   \
                        'BS_LIBARRAY_VERSION_PATCH'   \
                        'BS_LIBARRAY_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_VERSION_FULL`
#:
#: - Full version combining
#:   [`BS_LIBARRAY_VERSION_MAJOR`](#bs_libarray_version_major),
#:   [`BS_LIBARRAY_VERSION_MINOR`](#bs_libarray_version_minor),
#:   and [`BS_LIBARRAY_VERSION_PATCH`](#bs_libarray_version_patch)
#:   as a single integer.
#: - Can be used in numerical comparisons
#: - Format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded).
#:
BS_LIBARRAY_VERSION_FULL=$(( \
    ( (BS_LIBARRAY_VERSION_MAJOR * 1000) + BS_LIBARRAY_VERSION_MINOR ) * 1000 \
    + BS_LIBARRAY_VERSION_PATCH \
  ))

fn_bs_libarray_readonly 'BS_LIBARRAY_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_VERSION`
#:
#: - Full version combining
#:   [`BS_LIBARRAY_VERSION_MAJOR`](#bs_libarray_version_major),
#:   [`BS_LIBARRAY_VERSION_MINOR`](#bs_libarray_version_minor),
#:   [`BS_LIBARRAY_VERSION_PATCH`](#bs_libarray_version_patch),
#:   and
#:   [`BS_LIBARRAY_VERSION_RELEASE`](#bs_libarray_version_release)
#:   as a formatted string.
#: - Format: `BetterScripts 'libarray' vMAJOR.MINOR.PATCH[-RELEASE]`
#: - Derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#:
BS_LIBARRAY_VERSION="$(
    printf "BetterScripts 'libarray' v%d.%d.%d%s\n" \
           "${BS_LIBARRAY_VERSION_MAJOR}"           \
           "${BS_LIBARRAY_VERSION_MINOR}"           \
           "${BS_LIBARRAY_VERSION_PATCH}"           \
           "${BS_LIBARRAY_VERSION_RELEASE:+-${BS_LIBARRAY_VERSION_RELEASE}}"
  )"

fn_bs_libarray_readonly 'BS_LIBARRAY_VERSION'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_SH_TO_ARRAY`
#:
#: - Contains a shell script which can be used with
#:   `sh -c` (or any compliant shell) to create an
#:   array from the arguments passed to the shell.
#: - Primarily designed to be used with `find -exec`
#:   to output an array:
#:
#:       find "${PWD}" -exec sh -c \
#:         "${BS_LIBARRAY_SH_TO_ARRAY}" \
#:         BS_LIBARRAY_SH_TO_ARRAY -- '{}' '+'
#:       echo ' ' #< This is required
#:
#: - The array MUST have whitespace appended once it is
#:   generated or it will fail to work as expected.
#: - _POSIX.1_ specifies that the first argument following
#:   the script is interpreted as the "command name" (and
#:   is used for `$0` inside the script).
#: - Used internally by
#:   [`array_from_find`](#array_from_find) and
#:   [`array_from_find_allow_print`](#array_from_find_allow_print).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Nesting of strings and shells makes quoting and
#.   escaping the script confusing and error prone.
#. - See [`array_value`](#array_value) for information on
#.   specifics of how each array value is created.
#.
#  SC1003: Want to escape a single quote? echo 'This is
#          how it'\''s done'.
#  EXCEPT: The flagged expression is to output escaped
#          quotes from `sed`
#  SC2016: Expressions don't expand in single quotes, use
#          double quotes for that.
#  EXCEPT: The variables here are intended to be expanded
#          later, not here
#  shellcheck disable=SC1003,SC2016
BS_LIBARRAY_SH_TO_ARRAY='
  {
    case ${1-} in "BS_LIBARRAY_SH_TO_ARRAY") shift ;; esac
    for BS_LIBARRAY_PARAM
    do
      case ${BS_LIBARRAY_PARAM} in
      *"'\''"*) {
                  printf "%s\n" "${BS_LIBARRAY_PARAM}"
                } | {
                  sed -e "s/'\''/'\''\\\\'\'''\''/g
                          1s/^/'\''/
                          \$s/\$/'\'' \\\\/"
                } ;;
             *) printf "'\''%s'\'' \\\\\n" "${BS_LIBARRAY_PARAM}" ;;
      esac
    done
  }
'

fn_bs_libarray_readonly 'BS_LIBARRAY_SH_TO_ARRAY'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_LAST_ERROR`
#:
#: - Stores the error message of the most recent error.
#: - ONLY valid immediately following a command for which
#:   the exit status is not `0` (`<zero>`).
#: - Available even when error output is suppressed.
#:
BS_LIBARRAY_LAST_ERROR=; #< CLEAR ON SOURCING

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_SOURCED`
#:
#: - Set (and non-null) once the library has been sourced.
#: - Dependant scripts can query if this variable is set to
#:   determine if this file has been sourced.
#. - Used as a script guard on script sourcing
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
#. #### `c_BS_LIBARRAY__newline`
#.
#. - Literal `\n` (`<newline>`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_LIBARRAY__newline='
'

fn_bs_libarray_readonly 'c_BS_LIBARRAY__newline'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBARRAY__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
c_BS_LIBARRAY__EX_USAGE=64

fn_bs_libarray_readonly 'c_BS_LIBARRAY__EX_USAGE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBARRAY__awk_match`
#.
#. - script used for making
#.   ["Extended Regular Expression"][posix_ere] matches
#.   using `awk`
#. - used for [`array_search`][#array_search] and
#.   [`array_contains`][#array_contains]
#. - Requires `awk` supports the `ENVIRON` array which was
#.   added in 1989, but is not part of the traditional `awk`
#.   specification and may be omitted in some
#.   implementations. (This is required due to how strings
#.   are processed when passed to `awk` as arguments: not
#.   only do these have to be escaped in ways that are hard
#.   to do correctly, but they may not contain embedded
#.   newline characters. The `ENVIRON` array has neither
#.   restriction.)
#.
c_BS_LIBARRAY__awk_match='
  BEGIN {
    MatchString=ENVIRON["BS_ENV__AWK_MATCH__STRING"];
    MatchRegExp=ENVIRON["BS_ENV__AWK_MATCH__ERE"];
    if (match(MatchString, MatchRegExp)>0) {
      exit 0;
    } else {
      exit 1;
    }
  }
'

fn_bs_libarray_readonly 'c_BS_LIBARRAY__awk_match'

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
#; ### `fn_bs_libarray_error`
#;
#; Error reporting command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libarray_error <CALLER> <MESSAGE>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Added to the output message.
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
#; - If [`BS_LIBARRAY_CONFIG_QUIET_ERRORS`](#bs_libarray_config_quiet_errors)
#;   is _OFF_ a message in the format `[libarray::<COMMAND>]: ERROR: <MESSAGE>`
#;   is written to `STDERR`.
#; - If [`BS_LIBARRAY_CONFIG_FATAL_ERRORS`](#bs_libarray_config_fatal_errors)
#;   is _ON_ then an "unset variable" shell exception will be triggered using
#;   the [`${parameter:?[word]}`][posix_param_expansion] parameter expansion,
#;   where `word` is set to the error message.
#; - [`BS_LIBARRAY_LAST_ERROR`](#bs_libarray_last_error) will contain the
#;   `<MESSAGE>` without any additional prefix regardless of other settings.
#;
#_______________________________________________________________________________
fn_bs_libarray_error() { ## cSpell:Ignore BS_LAE_
  BS_LAE_Caller="${1:?'[libarray::fn_bs_libarray_error]: Internal Error: a command name is required'}"

  BS_LIBARRAY_LAST_ERROR=;
  case $# in
  1)  : "${2:?'[libarray::fn_bs_libarray_error]: Internal Error: an error message is required'}" ;;
  2)  BS_LIBARRAY_LAST_ERROR="$2" ;;
  *)  case ${IFS-} in
      ' '*) BS_LIBARRAY_LAST_ERROR="$*" ;;
         *) BS_LIBARRAY_LAST_ERROR="$2"
            shift; shift
            BS_LIBARRAY_LAST_ERROR="${BS_LIBARRAY_LAST_ERROR}$(
                printf ' %s' "$@"
              )" ;;
      esac ;; #<: `case ${IFS-} in`
  esac #<: `case $# in`

  case ${BS_LIBARRAY_CONFIG_QUIET_ERRORS:-${BETTER_SCRIPTS_CONFIG_QUIET_ERRORS:-0}} in
  0)  # OUTPUT ERROR
      printf '[libarray::%s]: ERROR: %s\n' \
            "${BS_LAE_Caller}"             \
            "${BS_LIBARRAY_LAST_ERROR}"    >&2 ;;
  esac

  case ${BS_LIBARRAY_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in
  0)  ;;
  *)  # ERROR EXCEPTION
      BS_LIBARRAY__FatalError=;
      : "${BS_LIBARRAY__FatalError:?"[libarray::${BS_LAE_Caller}]: ERROR: ${BS_LIBARRAY_LAST_ERROR}"}" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libarray_invalid_args <CALLER> <MESSAGE>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Added to the output message.
#;
#; `MESSAGE` \[in]
#;
#; - Error message.
#; - Multiple message values may be specified and
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
fn_bs_libarray_invalid_args() { ## cSpell:Ignore BS_LAIA_
  BS_LAIA_Caller="${1:?'[libarray::fn_bs_libarray_invalid_args]: Internal Error: a command name is required'}"
  shift
  fn_bs_libarray_error "${BS_LAIA_Caller}" 'Invalid Arguments:' "$@"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_expected`
#;
#; Helper for errors reporting incorrect number of arguments.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_expected <CALLER> <EXPECTED>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Added to the output message.
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
fn_bs_libarray_expected() { ## cSpell:Ignore BS_LAExpected_
   BS_LAExpected_Caller="${1:?'[libarray::fn_bs_libarray_expected]: Internal Error: a command name is required'}"
  BS_LAExpected_Message="Invalid Arguments: expected ${2:?'[libarray::fn_bs_libarray_expected]: Internal Error: an expected argument is required'}"

  case $# in
  2)  ;;
  *)  shift; shift
      while : #< [ $# -gt 1 ]
      do
        #> LOOP TEST --------------
        case $# in 1) break ;; esac #< [ $# -gt 1 ]
        #> ------------------------

        BS_LAExpected_Message="${BS_LAExpected_Message}, $1"
        shift
      done #<: `while : #< [ $# -gt 1 ]`
      BS_LAExpected_Message="${BS_LAExpected_Message}, and $1";;
  esac #<: `case $# in`

  fn_bs_libarray_invalid_args  \
    "${BS_LAExpected_Caller}"  \
    "${BS_LAExpected_Message}"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_validate_name`
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
#;     fn_bs_libarray_validate_name <CALLER> <NAME>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
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
fn_bs_libarray_validate_name() { ## cSpell:Ignore BS_LAVN_
  BS_LAVN_Caller="${1:?'[libarray::fn_bs_libarray_validate_name]: Internal Error: a command name is required'}"
    BS_LAVN_Name="${2?'[libarray::fn_bs_libarray_validate_name]: Internal Error: a variable name is required'}"

  case ${BS_LAVN_Name:-#} in
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libarray_invalid_args \
      "${BS_LAVN_Caller}"       \
      "invalid variable name '${BS_LAVN_Name}'"
    return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_validate_name_hyphen`
#;
#; Similar to [`fn_bs_libarray_validate_name`](#fn_bs_libarray_validate_name)
#; but additionally allows the name to be `-` (`<hyphen>`), which implies
#; that `STDOUT` or `STDIN` should in place of the variable be used as
#; appropriate.
#;
#; See [`fn_bs_libarray_validate_name`](#fn_bs_libarray_validate_name) for more
#; details.
#;
#_______________________________________________________________________________
fn_bs_libarray_validate_name_hyphen() { ## cSpell:Ignore BS_LAVNH_
  BS_LAVNH_Caller="${1:?'[libarray::fn_bs_libarray_validate_name_hyphen]: Internal Error: a command name is required'}"
    BS_LAVNH_Name="${2?'[libarray::fn_bs_libarray_validate_name_hyphen]: Internal Error: a variable name is required'}"

  #---------------------------------------------------------
  # This command is called for many of the main commands.
  # To avoid an additional command call the test from
  # `fn_bs_libarray_validate_name` is duplicated here
  case ${BS_LAVNH_Name:-#} in
  -) : ;;
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libarray_invalid_args \
      "${BS_LAVNH_Caller}"      \
      "invalid variable name '${BS_LAVNH_Name}'"
    return "${c_BS_LIBARRAY__EX_USAGE}" ;;
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
#; ### `fn_bs_libarray_get_param`
#;
#; Some shells only allow numbered parameters in the single digit range, this
#; provides a work around where needed.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_get_param <OUTPUT> <INDEX> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable to hold the parameter value.
#; : MUST be a valid _POSIX.1_ name.
#; : Will be set to the `VALUE` associated with `INDEX`,
#;   will not be modified if `INDEX` is out-of-bounds.
#;
#; `INDEX` \[in]
#;
#; : Parameter to retrieve.
#; : A **one-based** index.
#; : MUST be numeric.
#;
#; `VALUE` \[in]
#;
#; : Parameters.
#; : Can be specified multiple times.
#; : Can be null.
#;
#; _NOTES_
#; <!-- -->
#;
#; - `INDEX` is **always** one-based and will access the appropriately numbered
#;   shell parameter
#; - If the index is out-of-bounds, `OUTPUT` will not be modified;
#;   if the value reference is null `OUTPUT` will also be null
#; - `OUTPUT` SHOULD be `unset` before invoking this command or previous values
#;   may be retained; setting `OUTPUT` to null is not sufficient as it is then
#;   impossible to determine if `INDEX` was out-of-bounds, or if the parameter
#;   itself was null.
#;
#_______________________________________________________________________________
case ${c_BS_LIBARRAY_CFG_USE__multidigit_param:-0} in
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #> `case ${c_BS_LIBARRAY_CFG_USE__multidigit_param:-0} in`
  #> -------------------------------------------------------
  #
  # multi-digit parameters AVAILABLE
  #
  # Access parameters directly
  1)
    fn_bs_libarray_get_param() { ## cSpell:Ignore BS_LAGP_
      BS_LAGP_refOutput="${1:?'[libarray::fn_bs_libarray_get_param]: Internal Error: an output variable is required'}"
      shift
      BS_LAGP_Param="${1:?'[libarray::fn_bs_libarray_get_param]: Internal Error: a parameter is required'}"
      shift

      #.....................................................
      #  Index is out-of-bounds, so do not modify anything
      #  [ $# -lt "${BS_LAGP_Param}" ] && return
      case $(($# - BS_LAGP_Param)) in -*) return ;; esac

      eval "${BS_LAGP_refOutput}=\"\${${BS_LAGP_Param}}\""  #< SAVE
    }
  ;;

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #> `case ${c_BS_LIBARRAY_CFG_USE__multidigit_param:-0} in`
  #> -------------------------------------------------------
  #
  # multi-digit parameters UNAVAILABLE
  #
  # Only way to access multi-digit parameters is to
  # use `shift` and single-digit parameters
  0)
    fn_bs_libarray_get_param() { ## cSpell:Ignore BS_LAGP_
      BS_LAGP_refOutput="${1:?'[libarray::fn_bs_libarray_get_param]: Internal Error: an output variable is required'}"
      shift
      BS_LAGP_Param="${1:?'[libarray::fn_bs_libarray_get_param]: Internal Error: a parameter is required'}"
      shift

      #.....................................................
      # Index is out-of-bounds, so do not modify anything
      # [ $# -lt "${BS_LAGP_Param}" ] && return
      case $(($# - BS_LAGP_Param)) in -*) return ;; esac

      #.....................................................
      # Loop till single digit index. (No need to check
      # `$# > 0` as the above check ensures it has to be)
      #
      # NOTES: Assumes if no multidigit param support
      #        there is also no `shift N` support.
      while : #< [ "${BS_LAGP_Param}" -gt 9 ]
      do
        #> LOOP TEST ----------------------------
        case ${BS_LAGP_Param} in ?) break ;; esac #< [ "${BS_LAGP_Param}" -gt 9 ]
        #> --------------------------------------
        shift
        BS_LAGP_Param=$((BS_LAGP_Param - 1))
      done

      eval "${BS_LAGP_refOutput}=\"\${${BS_LAGP_Param}}\""  #< SAVE
    }
  ;;
esac #<: `case ${c_BS_LIBARRAY_CFG_USE__multidigit_param:-0} in`

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## INTERNAL HELPER COMMANDS
#.
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_process_index`
#;
#; Validate an index and convert it to a _ZERO-BASED FORWARD INDEX_.
#;
#; Functions that use indexes can accept them in a number of formats:
#;
#; - zero-based, positive integers: `[0, size)`
#; - one-based, positive integers: `[1, size]`
#; - negative integers `[-1, -size]`
#;
#; Zero-based indexing is likely more familiar to programmers and matches the
#; indexing used in shells that provide native arrays.
#;
#; One-based indexing is less confusing when mixed with positional parameters,
#; which are also one-based.
#;
#; The choice between zero-based and one-based indexing can be made via
#; configuration options, but MUST be done before sourcing the library.
#;
#; Negative indexes count backwards from the end of the array and numbering is
#; **not** affected by the choice of zero or one-based indexing; `-1` is
#; _always_ the last element in an array.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_process_index <CALLER> <INDEX> <SIZE> [<MAX>]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `INDEX` \[in/out:ref]
#;
#; : Variable that holds the index and will
#;   be updated with the processed index.
#; : MUST be a valid _POSIX.1_ name.
#; : Referenced value MUST be numeric.
#;
#; `SIZE` \[in]
#;
#; : Array size.
#; : MUST be numeric.
#;
#; `MAX` \[in]
#;
#; : Maximum index.
#; : MUST be numeric.
#; : Used for ranges, where the end index is
#;   exclusive (i.e. one passed the end), which
#;   causes problems when testing for an index
#;   that's valid for other cases.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Processed index is zero-based since that's the default configuration
#.   setting and for most commands using indexes zero-based is most useful
#.
#_______________________________________________________________________________
fn_bs_libarray_process_index() { ## cSpell:Ignore BS_LAPI_
     BS_LAPI_Caller="${1:?'[libarray::fn_bs_libarray_process_index]: Internal Error: a command name is required'}"
   BS_LAPI_refIndex="${2:?'[libarray::fn_bs_libarray_process_index]: Internal Error: an index variable is required'}"
  BS_LAPI_ArraySize="${3:?'[libarray::fn_bs_libarray_process_index]: Internal Error: an array size is required'}"
  case $# in
  4) BS_LAPI_MaxIndex="$4" ;;
  *) BS_LAPI_MaxIndex="${BS_LAPI_ArraySize}" ;;
  esac

  BS_LAPI_Index=;
  eval "BS_LAPI_Index=\"\${${BS_LAPI_refIndex}}\"" || return $?

  #---------------------------------------------------------
  # Validate Index
  # NOTES: removing any '-' prefix makes testing easier
  case ${BS_LAPI_Index#-}${c_BS_LIBARRAY_CFG__StartIndex} in
    #...................................
    #  Index is '0'; first index is '1'
    01)
      fn_bs_libarray_invalid_args \
        "${BS_LAPI_Caller}"       \
        "invalid index '${BS_LAPI_Index}' (one-based indexes are enabled)"
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;

    #...................................
    # Index is literally '-', or
    # otherwise non-numeric
    ?|*[!0123456789]*)
      fn_bs_libarray_invalid_args \
        "${BS_LAPI_Caller}"       \
        "invalid index '${BS_LAPI_Index}'"
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #< `case ${BS_LAPI_Index#-}${c_BS_LIBARRAY_CFG__StartIndex} in`

  #---------------------------------------------------------
  # Convert to a zero-based, forward index
  case ${BS_LAPI_Index} in
  -*) BS_LAPI_RealIndex=$((BS_LAPI_ArraySize + BS_LAPI_Index)) ;;               #< Negative Indexes:= Count Backwards
   *) BS_LAPI_RealIndex=$((BS_LAPI_Index - c_BS_LIBARRAY_CFG__StartIndex)) ;;   #< Positive Indexes:= Count Forwards
  esac

  #---------------------------------------------------------
  # Validate range:
  #     0 <= BS_LAPI_RealIndex <= BS_LAPI_MaxIndex
  # so both
  #     BS_LAPI_RealIndex >= 0
  # and
  #     (BS_LAPI_MaxIndex - BS_LAPI_RealIndex) >= 0
  # must be true
  case ${BS_LAPI_RealIndex}$((BS_LAPI_MaxIndex - BS_LAPI_RealIndex)) in
  *-*)  fn_bs_libarray_invalid_args \
          "${BS_LAPI_Caller}"       \
          "index '${BS_LAPI_Index}' is out of range [${c_BS_LIBARRAY_CFG__StartIndex}, ${BS_LAPI_MaxIndex}]"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  eval "${BS_LAPI_refIndex}=\"\${BS_LAPI_RealIndex}\""      #< SAVE
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_process_range`
#;
#; Process a range string into a _START_ and _LENGTH_, where _START_ is a
#; _ZERO-BASED FORWARD INDEX_ and _LENGTH_ is a _POSITIVE LENGTH >= 1_.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_process_range <CALLER> <START> <LENGTH> <RANGE> <MAX>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `START` \[out:ref]
#;
#; : Variable that will contain the range start index.
#; : Any current contents will be lost.
#; : MUST be a valid _POSIX.1_ name.
#;
#; `LENGTH` \[out:ref]
#;
#; : Variable that will contain the range length.
#; : Any current contents will be lost.
#; : MUST be a valid _POSIX.1_ name.
#;
#; `RANGE` \[in]
#;
#; : A range within the array specified as either
#;   '\[START]:\[END]' or '\[START]#\[LENGTH]' where _START_
#;   and _END_ are array indexes in the range \[START, END),
#;   and _LENGTH_ is the count of elements in the range.
#; : If _LENGTH_ is negative or _START_ is greater
#;   than _END_ the range is a reverse range.
#; : If _START_ is omitted, the range will begin with
#;   the first element of the array.
#; : If _END_ or _LENGTH_ are omitted, the range will
#;   end at the last element of the array.
#; : All elements MUST be within array bounds.
#; : MUST contain at least the character `:` (`<colon>`) or
#;   `#` (`<number-sign>`).
#; : MUST result in a range of size >= 1.
#;
#; `MAX` \[in]
#;
#; : Maximum index.
#; : MUST be numeric.
#;
#; _NOTES_
#; <!-- -->
#;
#; - `RANGE` supports zero-based, one-based, or negative indexing (see
#;   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#; - If `RANGE` is exactly `:` (`<colon>`) or `#` (`<number-sign>`) the range
#;   covers the entire array.
#; - The `RANGE` indexes are converted _zero-based_ forward indexes **before**
#;   the test for a reverse `RANGE` is performed. This is by design but means
#;   that a `RANGE` that produces a reverse range for one array, _may not_ do so
#;   for a different array. For example, a `RANGE` of `4:-4` is a reverse range
#;   for an array of length 6, but a forward range for an array of length 12.
#; - A _reversed_ `RANGE` that ends at the _first_ array element can **only** be
#;   specified using the `START#-LENGTH` format since setting _END_ as
#;   `-1` would be interpreted as the final array element and **not** the
#;   intended first array element, while using `0` (`<zero>`) would result in
#;   the first element being omitted when using 0-based indexing, and is not a
#;   valid index when using 1-based indexing.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Internal indexes are zero-based, as shell parameters are one-based this
#.   means some operations will add 1 to the index used.
#.
#_______________________________________________________________________________
fn_bs_libarray_process_range() { ## cSpell:Ignore BS_LAPR_
     BS_LAPR_Caller="${1:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a command name is required'}"
   BS_LAPR_refStart="${2:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a start output variable is required'}"
  BS_LAPR_refLength="${3:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a length output variable is required'}"
      BS_LAPR_Range="${4:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a range is required'}"
   BS_LAPR_MaxIndex="${5:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a maximum index is required'}"

  case ${BS_LAPR_Range} in
    #...................................
    #> `case ${BS_LAPR_Range} in`
    #> --------------------------
    #
    # Range is of form
    #    '[<START>]:[<END>]'
    # which translates to a range of
    #    [START, END)
    *':'*)
      BS_LAPR_Start="${BS_LAPR_Range%:*}"
        BS_LAPR_End="${BS_LAPR_Range#*:}"

      # Process START
      case ${BS_LAPR_Start:+1} in
      1)  fn_bs_libarray_process_index \
            "${BS_LAPR_Caller}"        \
            'BS_LAPR_Start'            \
            "${BS_LAPR_MaxIndex}"      || return $? ;;
      *)  BS_LAPR_Start=0 ;;
      esac

      # Process END
      case ${BS_LAPR_End:+1} in
      1)  fn_bs_libarray_process_index \
            "${BS_LAPR_Caller}"        \
            'BS_LAPR_End'              \
            $((BS_LAPR_MaxIndex + 1))  || return $? ;;
      *)  BS_LAPR_End="${BS_LAPR_MaxIndex}" ;;
      esac

      BS_LAPR_Length=$((BS_LAPR_End - BS_LAPR_Start))
    ;;

    #...................................
    #> `case ${BS_LAPR_Range} in`
    #> --------------------------
    #
    # Range is of form
    #    '[<START>]#[<LENGTH>]'
    # which translates to a range of
    #    [START, START + LENGTH)
    *'#'*)
      BS_LAPR_Start="${BS_LAPR_Range%#*}"
      BS_LAPR_Length="${BS_LAPR_Range#*#}"

      # Process START
      case ${BS_LAPR_Start:+1} in
      1)  fn_bs_libarray_process_index \
            "${BS_LAPR_Caller}"        \
            'BS_LAPR_Start'            \
            "${BS_LAPR_MaxIndex}"      || return $? ;;
      *)  BS_LAPR_Start=0 ;;
      esac

      # Process LENGTH
      case ${BS_LAPR_Length:+1} in
      1)  case ${BS_LAPR_Length#-} in
          ''|*[!0123456789]*)
            fn_bs_libarray_invalid_args \
              "${BS_LAPR_Caller}"       \
              "invalid range length '${BS_LAPR_Range}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
          esac ;;
      *)  BS_LAPR_Length=$((BS_LAPR_MaxIndex - BS_LAPR_Start)) ;;
      esac

      # Calculate END (for validation)
      BS_LAPR_End=$((BS_LAPR_Start + BS_LAPR_Length))

      # Validate range:
      #    0 <= BS_LAPR_End <= BS_LAPR_MaxIndex
      case ${BS_LAPR_End}$((BS_LAPR_MaxIndex - BS_LAPR_End)) in
      *-*)  fn_bs_libarray_invalid_args \
              "${BS_LAPR_Caller}"       \
              "invalid range length '${BS_LAPR_Range}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac
    ;;

    #...................................
    #> `case ${BS_LAPR_Range} in`
    #> --------------------------
    #
    # Range is invalid
    *)
      fn_bs_libarray_invalid_args \
        "${BS_LAPR_Caller}"       \
        "invalid range '${BS_LAPR_Range}'"
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case ${BS_LAPR_Range} in`

  #---------------------------------------------------------
  # A zero LENGTH is invalid, while a negative LENGTH means
  # the range is a reversed range where START should point
  # to the highest numbered array element (the range then
  # counts backwards from this element).
  case ${BS_LAPR_Length} in
  0|-0) fn_bs_libarray_invalid_args \
          "${BS_LAPR_Caller}"       \
          "invalid range '${BS_LAPR_Range}' (Length: ${BS_LAPR_Length})"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
    -*) BS_LAPR_Start=$((BS_LAPR_Start + 1 + BS_LAPR_Length)) ;;
  esac

  eval " ${BS_LAPR_refStart}=\"\${BS_LAPR_Start}\"
        ${BS_LAPR_refLength}=\"\${BS_LAPR_Length}\""        #< SAVE
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_match_bre`
#;
#; Test if a value matches a ["Basic Regular Expression" (_BRE_)][posix_bre]
#; without generating any output.
#;
#; Exit Status will be zero (i.e. "success") if the value matches the _BRE_.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_match_bre <VALUE> <BRE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE` \[in]
#;
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `BRE` \[in]
#;
#; : A _POSIX.1_ ["Basic Regular Expression"][posix_bre].
#; : _Always_ anchored to the start of `VALUE` (i.e. an
#;   implicit `^` (`<circumflex>`) precedes the expression).
#; : Multiple line matches are permitted, but should
#;   avoid the line end anchor `$` (`<dollar-sign>`) as
#;   this is not portable.
#; : May be used with different utilities on
#;   different platforms; should not assume any
#;   non-standard extensions will work.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - There are multiple _POSIX.1_ specified utilities that support _BRE_ (e.g.
#.   `expr`, `grep`, `sed`, etc). However, not all of these are suitable for
#.   use here; `grep`, for example, can't easily do a match that may span
#.   multiple lines. While this is not necessarily an issue in most cases
#.   it is not easy to detect when such a use is intended, instead the
#.   result would simply be incorrect.
#.
#_______________________________________________________________________________
case ${c_BS_LIBARRAY_CFG_USE__expr_bre_match:-0} in
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #> `case ${c_BS_LIBARRAY_CFG_USE__expr_bre_match:-0} in`
  #> -----------------------------------------------------
  #
  # `expr` AVAILABLE
  #
  # Simple `expr` wrapper but with `STDOUT`
  # suppressed
  1)
    case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in
      #.....................................................
      #> `case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in`
      #> -----------------------------------------------
      #
      # `/dev/null` AVAILABLE
      1)
        fn_bs_libarray_match_bre() { ## cSpell:Ignore BS_LAMBRE_
          BS_LAMBRE_Value="${1?'[libarray::fn_bs_libarray_match_bre]: Internal Error: a value is required'}"
          BS_LAMBRE_Expr="${2:?'[libarray::fn_bs_libarray_match_bre]: Internal Error: an expression is required'}"
          expr "_${BS_LAMBRE_Value}" : "_${BS_LAMBRE_Expr#^}" >/dev/null
        }
      ;;

      #.....................................................
      #> `case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in`
      #> -----------------------------------------------
      #
      # `/dev/null` UNAVAILABLE
      #
      # This requires output is captured, so a subshell
      # is needed, making this slower than the previous
      # solution
      0)
        fn_bs_libarray_match_bre() { ## cSpell:Ignore BS_LAMBRE_
            BS_LAMBRE_Value="${1?'[libarray::fn_bs_libarray_match_bre]: Internal Error: a value is required'}"
            BS_LAMBRE_Expr="${2:?'[libarray::fn_bs_libarray_match_bre]: Internal Error: an expression is required'}"
          BS_LAMBRE_Ignored="$(expr "_${BS_LAMBRE_Value}" : "_${BS_LAMBRE_Expr#^}")"
        }
      ;;
    esac #<: `case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in`
  ;;

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #> `case ${c_BS_LIBARRAY_CFG_USE__expr_bre_match:-0} in`
  #> -----------------------------------------------------
  #
  # `expr` UNAVAILABLE
  #
  # Emulation of `expr` using `sed -n` which only writes
  # to `STDOUT` if the _BRE_ was matched.
  #
  # Requires multiple commands in a pipeline, for which
  # the output must also be captured, this results in
  # two subshell environments (one for capture, one for
  # pipeline) so is slower than the above alternatives.
  0)
    fn_bs_libarray_match_bre() { ## cSpell:Ignore BS_LAMBRE_
      BS_LAMBRE_Value="${1?'[libarray::fn_bs_libarray_match_bre]: Internal Error: a value is required'}"
      BS_LAMBRE_Expr="${2:?'[libarray::fn_bs_libarray_match_bre]: Internal Error: an expression is required'}"

      # `printf` needs to append a `<newline>` as `sed` will
      # strip the trailing `<newline>` from the value when
      # it reads the input, and it's not possible to
      # detect if this has been done within `sed` itself.
      #
      # By default `sed` acts on individual lines, however
      # this can be changed with the `N` directive which
      # reads another line and appends it to the pattern
      # space delimited by a literal `\n` (`<newline>`)
      # character. The `sed` address `$` matches the end of
      # input, here this means the pattern space holds
      # everything from `BS_LAMBRE_Value`.
      BS_LAMBRE_Match="$(
          {
            printf '%s\n' "${BS_LAMBRE_Value}"
          } | {
            sed -n -e " :NEWLINE {
                          \$!N
                          \$!b NEWLINE
                        }
                        /^${BS_LAMBRE_Expr#^}/p"
          }
        )" || return $?

      case ${BS_LAMBRE_Match:+1} in
      1) return 0 ;;
      *) return 1 ;;
      esac
    }
  ;;
esac #<: `case ${c_BS_LIBARRAY_CFG_USE__expr_bre_match:-0} in`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_match_ere`
#;
#; Test if a value matches a ["Extended Regular Expression" (_ERE_)][posix_ere]
#; without generating any output.
#;
#; Exit Status will be zero (i.e. "success") if the value matches the _ERE_.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_match_ere <VALUE> <ERE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE` \[in]
#;
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `ERE` \[in]
#;
#; : A _POSIX.1_ ["Extended Regular Expression"][posix_ere].
#; : _Always_ anchored to the start of `VALUE` (i.e. an
#;   implicit `^` (`<circumflex>`) precedes the expression).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - The only _POSIX.1_ specified utilities that support _ERE_ are `awk` and
#.   `grep`. However, `grep` can not be used for the same reasons it can't
#.   be used to match "Basic Regular Expressions" (see
#.   [`fn_bs_libarray_match_bre`](#fn_bs_libarray_match_bre)).
#.   Unfortunately, not all implementations of `awk` support the `match`
#.   command required to match an _ERE_. This includes the base version of
#.   `awk` on 'Solaris 10', for example. Unless an alternative version of `awk`
#.   is available there is no way for this to work.
#. - Most `awk` portability issues do not apply to the simple script used here,
#.   but the following do:
#.   - _HP-UX 11_ (and others?) may mishandle anchors;
#.     [`autoconf`: Portable Shell Programming][autoconf_portable]
#.     suggest brackets to avoid this (this should not
#.     change how the _ERE_ is matched)
#.   - _Solaris 10_ (and other traditional `awk`
#.     implementations) attempt to read from `STDIN`,
#.     even when the standard says it should not.
#.     This can be dealt with by providing some
#.     arbitrary input (here, `/dev/null` or output from
#.     `echo`), unfortunately these implementations may
#.     also not support `match`
#.
#_______________________________________________________________________________
case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #> `case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in`
  #> -----------------------------------------------
  #
  # `/dev/null` AVAILABLE
  1)
    fn_bs_libarray_match_ere() { ## cSpell:Ignore BS_LAMERE_
      BS_LAMERE_Value="${1?'[libarray::fn_bs_libarray_match_ere]: Internal Error: a value is required'}"
       BS_LAMERE_Expr="${2:?'[libarray::fn_bs_libarray_match_ere]: Internal Error: an expression is required'}"
      ec_fn_bs_libarray_match_ere=0
      {
        BS_ENV__AWK_MATCH__STRING="${BS_LAMERE_Value}"
           BS_ENV__AWK_MATCH__ERE="^(${BS_LAMERE_Expr#^})"
        export 'BS_ENV__AWK_MATCH__STRING' \
               'BS_ENV__AWK_MATCH__ERE'
        awk "${c_BS_LIBARRAY__awk_match}" </dev/null
      } || ec_fn_bs_libarray_match_ere=$?
      #  Undo the `export` above
      unset 'BS_ENV__AWK_MATCH__STRING' \
            'BS_ENV__AWK_MATCH__ERE'
      return "${ec_fn_bs_libarray_match_ere}"
    }
  ;;

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #> `case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in`
  #> -----------------------------------------------
  #
  # `/dev/null` UNAVAILABLE
  0)
    fn_bs_libarray_match_ere() { ## cSpell:Ignore BS_LAMERE_
      BS_LAMERE_Value="${1?'[libarray::fn_bs_libarray_match_ere]: Internal Error: a value is required'}"
       BS_LAMERE_Expr="${2:?'[libarray::fn_bs_libarray_match_ere]: Internal Error: an expression is required'}"
      {
        echo ' '
      } | {
        # The pipe means this is a subshell and all
        # exports will be local to that subshell
        BS_ENV__AWK_MATCH__STRING="${BS_LAMERE_Value}"
           BS_ENV__AWK_MATCH__ERE="^(${BS_LAMERE_Expr#^})"
        export 'BS_ENV__AWK_MATCH__STRING' \
               'BS_ENV__AWK_MATCH__ERE'
        awk "${c_BS_LIBARRAY__awk_match}"
      }
    }
  ;;
esac #<: `case ${c_BS_LIBARRAY_CFG_USE__dev_null:-0} in`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_as_safe_case_pattern`
#;
#; Escape a `case` pattern so that it can be used safely with `eval`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_as_safe_case_pattern <PATTERN>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `PATTERN` \[in/out:ref]
#;
#; : Variable that contains the pattern and will
#;   receive the escaped pattern.
#; : All `case` special pattern matching characters
#;   (e.g. `*` (`<asterisk>`), `?` (`<question-mark>`), etc)
#;   retain their special meaning and need escaped if meant
#;   to match literally.
#; : Value can be a single `case` pattern or
#;   multiple patterns using the `case` pattern
#;   delimiter (i.e. `|` (`<vertical-line>`)).
#; : All characters outside the _POSIX.1_ specified
#;   `case` pattern matching characters are made
#;   literal, notably this includes quote characters.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - The set of characters NOT escaped is deliberately very limited. There is
#.   no performance gain from using a larger set and there is more potential
#.   for unsafe characters to be missed.
#. - The character `]` (`<right-square-bracket>`) is _only_ special **if**
#.   preceded by `[` (`<left-square-bracket>`), otherwise it is literal.
#.   (This is true for both `case` and `sed` - both of which are used here.)
#. - There are two sequences that need special attention: the character
#.   `]` (`<right-square-bracket>`), and the sequence `[!`
#.   (`<left-square-bracket><exclamation-mark>`) both are difficult to exclude
#.   from being escaped but neither should be escaped. It is easier to unescape
#.   these sequences specifically than attempt to avoid them being escaped in
#.   the first place.
#. - For any `PATTERN` that consists of only characters that are not escaped,
#.   this command is a no-op.
#.
#_______________________________________________________________________________
fn_bs_libarray_as_safe_case_pattern() { ## cSpell:Ignore BS_LAASCP_
  BS_LAASCP_refPattern="${1:?'[libarray::fn_bs_libarray_as_safe_case_pattern]: Internal Error: a pattern variable is required'}"

  eval "BS_LAASCP_Pattern=\"\${${BS_LAASCP_refPattern}-}\"" || return $?

  # Avoid escaping if possible (the performance advantage is worth the check)
  case ${BS_LAASCP_Pattern} in
  *[!-*?\\\|[_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789]*)
    BS_LAASCP_Pattern="$(
        {
          printf '%s' "${BS_LAASCP_Pattern}"
        } | {
          sed -e 's/[^-*?\\|[_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789]/\\&/g
                  s/\\]/]/g
                  s/\[\\!/[!/g'
        }
      )"
    eval "${BS_LAASCP_refPattern}=\"\${BS_LAASCP_Pattern}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_escape_newlines`
#;
#; Unpack the given array with each value flattened to a single line by
#; replacing any newline characters with an escape sequence that can not
#; otherwise appear in those values, and write the values to `STDOUT`.
#;
#; All `\` (`<backslash>`) characters are replaced with `\\`
#; (`<backslash><backslash>`), then all newline characters are replace with the
#; literal text ` \n` (`<space><slash><n>`), a value which can _only_
#; appear if a newline was present (it can not appear otherwise as a single `\`
#; (`<backslash>`) can not appear following a ` ` (`<space>`) since all `\`
#; (`<backslash>`) characters are now `\\` (`<backslash><backslash>`)).
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_escape_newlines <CALLER> <ARRAY>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `ARRAY` \[in:ref]
#;
#; : Array variable containing values to be escaped.
#; : Can reference an empty array or `unset` variable.
#; : MUST be a valid _POSIX.1_ name.
#;
#; _NOTES_
#; <!-- -->
#;
#; - If the caller process the output in a way that alters `\` (`<backslash>`)
#;   characters, it may not be possible to correctly undo the modifications made
#;   by this command.
#; - For lexicographical comparison purposes the resulting output _may_ not sort
#;   as expected, but _will_ sort in the same order every time.
#;
#_______________________________________________________________________________
fn_bs_libarray_escape_newlines() { ## cSpell:Ignore BS_LAEN_
    BS_LAEN_Caller="${1:?'[libarray::fn_bs_libarray_escape_newlines]: Internal Error: a command name is required'}"
  BS_LAEN_refArray="${2:?'[libarray::fn_bs_libarray_escape_newlines]: Internal Error: an array variable name is required'}"

  # Unpack...
  eval "BS_LAEN_Array=\"\${${BS_LAEN_refArray}-}\""      || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAEN_Array?} && shift" || return $?

  # Escape the values (to standard out)...
  for BS_LAEN_Value
  do
    # Processing only when required can have a significant
    # performance impact.
    case ${BS_LAEN_Value} in
      #...................................
      #> `case ${BS_LAEN_Value} in
      #> -------------------------
      #
      # NEEDS ESCAPED
      *\\*|*${c_BS_LIBARRAY__newline}*)
        # `printf` needs to append a `<newline>` as `sed` will
        # strip the trailing `<newline>` from the value when
        # it reads the input, and it's not possible to
        # detect if this has been done within `sed` itself.
        #
        # By default `sed` acts on individual lines, however
        # this can be changed with the `N` directive which
        # reads another line and appends it to the pattern
        # space delimited by a literal `<newline>` character.
        # The `sed` address `$` matches the end of input,
        # here this means the pattern space holds everything
        # from `BS_LAMBRE_Value`.
        {
          printf '%s\n' "${BS_LAEN_Value}"
        } | {
          sed -e ':NEWLINE {
                    $!N
                    $!b NEWLINE
                  }
                  s/\\/\\\\/g
                  s/\n/ \\n/g'
        } ;;

      #...................................
      #> `case ${BS_LAEN_Value} in
      #> -------------------------
      #
      # FINE AS IS
      *) printf '%s\n' "${BS_LAEN_Value}" ;;
    esac #<: `case ${BS_LAEN_Value} in`
  done #<: `for BS_LAEN_Value`
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_create`
#;
#; Create an array or a reverse array of a specific length.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_create <CALLER> <COUNT> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `COUNT` \[in]
#;
#; : Number of values in final array.
#; : Can be less than the number of `VALUE`
#;   arguments provided.
#; : If negative `VALUE`s are added in reverse order.
#; : MUST be numeric.
#;
#; `VALUE` \[in]
#;
#; : Can be specified multiple times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#; : MUST be _at least_ `COUNT` `VALUE` arguments provided,
#;   but only the first `COUNT` `VALUE` arguments will be
#;   used.
#;
#; _NOTES_
#; <!-- -->
#;
#; - if `COUNT` is negative the resulting array is created using the provided
#;   `VALUE` arguments in reverse. If there are more `VALUE` arguments than
#;   required, only the first `COUNT` are used. (The first value in a
#;   reverse array _may_ therefore _not_ be the last `VALUE` argument provided.)
#;
#_______________________________________________________________________________
fn_bs_libarray_create() { ## cSpell:Ignore BS_LACreate_
  BS_LACreate_Caller="${1:?'[libarray::fn_bs_libarray_create]: Internal Error: a command name is required'}"
  shift
  BS_LACreate_Count="${1:?'[libarray::fn_bs_libarray_create]: Internal Error: a count of values is required'}"
  shift

  case ${BS_LACreate_Count} in
    #...................................
    #> `case ${BS_LACreate_Count} in`
    #> ------------------------------
    #
    #  Empty Array
    0) return ;;

    #...................................
    #> `case ${BS_LACreate_Count} in`
    #> ------------------------------
    #
    # Negative Count:= Reverse Array
    -*)
      BS_LACreate_Count=$((0 - BS_LACreate_Count))

      case $(($# - BS_LACreate_Count)) in #< [ "${BS_LACreate_Count}" -gt $# ]
      -*) fn_bs_libarray_invalid_args \
            "${BS_LACreate_Caller}"   \
            "not enough values for count (${BS_LACreate_Count} > $#)"
          return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac

      while : #< [ "${BS_LACreate_Count}" -gt 0 ]
      do
        #> LOOP TEST --------------------------------
        case ${BS_LACreate_Count} in 0) break ;; esac #< [ "${BS_LACreate_Count}" -gt 0 ]
        #> ------------------------------------------
        BS_LACreate_Value=;
        fn_bs_libarray_get_param \
          'BS_LACreate_Value'    \
          "${BS_LACreate_Count}" \
          "$@"                   || return $?
        array_value "${BS_LACreate_Value}" || return $?
        BS_LACreate_Count=$((BS_LACreate_Count - 1))
      done #<: `while : #< [ "${BS_LACreate_Count}" -gt 0 ]`
    ;;

    #...................................
    #> `case ${BS_LACreate_Count} in`
    #> ------------------------------
    #
    # Positive Count:= Normal Array
    *)
      case $(($# - BS_LACreate_Count)) in  #< [ "${BS_LACreate_Count}" -gt $# ]
      -*) fn_bs_libarray_invalid_args \
            "${BS_LACreate_Caller}"   \
            "not enough values for count (${BS_LACreate_Count} > $#)"
          return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac

      while : #< [ "${BS_LACreate_Count}" -gt 0 ]
      do
        #> LOOP TEST --------------------------------
        case ${BS_LACreate_Count} in 0) break ;; esac #< [ "${BS_LACreate_Count}" -gt 0 ]
        #> ------------------------------------------
        array_value "$1" || return $?
        shift
        BS_LACreate_Count=$((BS_LACreate_Count - 1))
      done #<: `while : #< [ "${BS_LACreate_Count}" -gt 0 ]`
    ;;
  esac #<: `case ${BS_LACreate_Count} in`

  echo ' ' #< Trailing whitespace is always required
}

#_______________________________________________________________________________
## cSpell:Ignore notlike
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_create_from_unfiltered`
#;
#; Create an array excluding any VALUEs that match a filter.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_create_from_unfiltered <CALLER> <PRIMARY> <EXPRESSION>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `PRIMARY` \[in]
#;
#; : A test operator used for filtering.
#; : MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
#;   `-lt`, `-le`, `-like`, or `-notlike`.
#; : The primaries `-gt`, `-ge`, `-lt`, and `-le` are
#;   identical to the `test` primaries of the same
#;   names, while `=`, `!=`, `-eq`, `-ne` are
#;   functionally similar, but do not distinguish
#;   between numerical and string values.
#; : The `-like` primary performs a `case` pattern
#;   match and supports the glob characters as
#;   supported by `case`, the `-notlike` primary is
#;   identical, but with inverted meaning.
#; : `-like` and `-notlike` support the normal `case`
#;   pattern matching characters, and can consist of
#;   multiple patterns delimited by the `|` character.
#;
#; `EXPRESSION` \[in]
#;
#; : Value to use with `PRIMARY`.
#; : Can be null.
#; : _EXPECTS_
#;   - a _string_ when `PRIMARY` is `=`, `!=`
#;   - a _number_ when `PRIMARY` is `-eq`, `-ne`,
#;     `-gt`, `-ge`,  `-lt`, `-le`
#;   - a `case` pattern when `PRIMARY` is `-like`,
#;     or `-notlike`.
#; : _ALLOWS_
#;   - a _number_ when PRIMARY is `=` or `!=`
#;   - a _string_ when PRIMARY is `-eq` or `-ne`.
#; : `case` pattern allows the normal `case` pattern
#;   matching characters: `*` (`<asterisk>`)
#;   `?` (`<question-mark>`), and
#;   `[` (`<left-square-bracket>`) with the same
#;   meanings as with a standard `case` match;
#;   also supported is the pattern delimiter `|`
#;   (`<vertical-line>`) which can be used to separate
#;   multiple patterns in a single `EXPRESSION`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Primarily a helper for removing elements from an existing array, meaning
#.   the logic can be a little confusing as it is often inverted from that
#.   which might be expected.
#.
#_______________________________________________________________________________
fn_bs_libarray_create_from_unfiltered() { ## cSpell:Ignore BS_LACFU_
  BS_LACFU_Caller="${1:?'[libarray::fn_bs_libarray_create_from_unfiltered]: Internal Error: a command name is required'}"
  shift
  BS_LACFU_Primary="${1:?'[libarray::fn_bs_libarray_create_from_unfiltered]: Internal Error: a primary is required'}"
  shift
  BS_LACFU_Expression="${1?'[libarray::fn_bs_libarray_create_from_unfiltered]: Internal Error: an expression is required'}"
  shift

  BS_LACFU_HaveElements=0  #< Flag indicating if any array values were output

  case ${BS_LACFU_Primary} in
    #.......................................................
    #> `case ${BS_LACFU_Primary} in`
    #> -----------------------------
    #
    # EXCLUDE VALUES MATCHING A GLOB
    '-like')
      case ${BS_LACFU_Expression:+1} in
        #'''''''''''''''''''''''''''''''''''''''''''''''''''
        #> `case ${BS_LACFU_Expression:+1} in`
        #> -----------------------------------
        #
        # NORMAL PATTERN
        1)
          fn_bs_libarray_as_safe_case_pattern 'BS_LACFU_Expression' || return $?
          # NOTES:
          # - `array_value` has to be after the `case`
          #    statement since the GLOB could be simply '*'
          #    which would cause errors if the
          #    `array_value` was added to the `case` using
          #    the '*)' catch-all match
          eval "for BS_LACFU_Value
                do
                  case \${BS_LACFU_Value} in
                  ${BS_LACFU_Expression:-''}) continue ;;
                  esac
                  array_value \"\${BS_LACFU_Value}\" || return \$?
                  BS_LACFU_HaveElements=1
                done" || return $? ;;

        #'''''''''''''''''''''''''''''''''''''''''''''''''''
        #> `case ${BS_LACFU_Expression:+1} in`
        #> -----------------------------------
        #
        # NULL PATTERN
        #
        # Slightly faster version for
        # creating from non-null values
        *)
          for BS_LACFU_Value
          do
            case ${BS_LACFU_Value} in
            *?*)  array_value "${BS_LACFU_Value}" || return $?
                  BS_LACFU_HaveElements=1 ;;
            esac
          done ;;
      esac #<: `case ${BS_LACFU_Expression:+1} in`
    ;;

    #.......................................................
    #> `case ${BS_LACFU_Primary} in`
    #> -----------------------------
    #
    # INCLUDE VALUES MATCHING A GLOB
    '-notlike')
      fn_bs_libarray_as_safe_case_pattern 'BS_LACFU_Expression' || return $?

      eval "for BS_LACFU_Value
            do
              case \${BS_LACFU_Value} in
              ${BS_LACFU_Expression:-''})
                array_value \"\${BS_LACFU_Value}\" || return \$?
                BS_LACFU_HaveElements=1 ;;
              esac
            done" || return $?
    ;;

    #.......................................................
    #> `case ${BS_LACFU_Primary} in`
    #> -----------------------------
    #
    # EXCLUDE MATCHING VALUES
    '-eq'|'=')
      for BS_LACFU_Value
      do
        case ${BS_LACFU_Value} in
        "${BS_LACFU_Expression}") continue ;;
        esac
        array_value "${BS_LACFU_Value}" || return $?
        BS_LACFU_HaveElements=1
      done
    ;;

    #.......................................................
    #> `case ${BS_LACFU_Primary} in`
    #> -----------------------------
    #
    # INCLUDE MATCHING VALUES
    '-ne'|'!=')
      for BS_LACFU_Value
      do
        case ${BS_LACFU_Value} in
        "${BS_LACFU_Expression}")
          array_value "${BS_LACFU_Value}" || return $?
          BS_LACFU_HaveElements=1 ;;
        esac
      done
    ;;

    #.......................................................
    #> `case ${BS_LACFU_Primary} in`
    #> -----------------------------
    #
    # EXCLUDE SUCCESSFUL `test`s
    '-gt'|'-ge'|'-lt'|'-le')
      for BS_LACFU_Value
      do
        if test "${BS_LACFU_Value}"      \
                "${BS_LACFU_Primary}"    \
                "${BS_LACFU_Expression}"
        then
          continue
        else
          array_value "${BS_LACFU_Value}" || return $?
          BS_LACFU_HaveElements=1
        fi
      done
    ;;

    #.......................................................
    #> `case ${BS_LACFU_Primary} in`
    #> -----------------------------
    #
    # INVALID
    *)
      fn_bs_libarray_invalid_args \
        "${BS_LACFU_Caller}"      \
        "invalid primary '${BS_LACFU_Primary}'"
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case ${BS_LACFU_Primary} in`

  # Avoid writing the trailing space unless there are
  # elements as this allows the final array variable to
  # be null and easier to check if empty (otherwise the
  # variable will always contain at least whitespace)
  case ${BS_LACFU_HaveElements} in
  1) echo ' '
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_remove_by_range`
#;
#; Remove one or more elements from an existing array using a range or index.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_remove_by_range <CALLER> <ARRAY> <RANGE>
#;
#;     fn_bs_libarray_remove_by_range <CALLER> <ARRAY> <INDEX>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `ARRAY` \[in:ref]
#;
#; : Array variable containing values to be removed.
#; : MUST be a valid _POSIX.1_ name.
#; : Can reference an empty array or `unset` variable.
#;
#; `RANGE` \[in]
#;
#; : A range within the array specified as either
#;   '\[START]:\[END]' or '\[START]#\[LENGTH]' where _START_
#;   and _END_ are array indexes in the range \[START, END),
#;   and _LENGTH_ is the count of elements in the range.
#; : If _LENGTH_ is negative or _START_ is greater
#;   than _END_ the range is a reverse range.
#; : If _START_ is omitted, the range will begin with
#;   the first element of the array.
#; : If _END_ or _LENGTH_ are omitted, the range will
#;   end at the last element of the array.
#; : All elements MUST be within array bounds.
#; : MUST contain at least the character `:` (`<colon>`) or
#;   `#` (`<number-sign>`).
#; : MUST result in a range of size >= 1.
#;
#; `INDEX` \[in]
#;
#; : Index of the array element to remove.
#; : MUST be numeric.
#; : MUST be within array bounds.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Supports zero-based, one-based, or negative indexing
#;   (see
#;    [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#; - If `ARRAY` is null or empty no validation occurs for
#;   the `RANGE`/`INDEX` argument.
#;
#_______________________________________________________________________________
fn_bs_libarray_remove_by_range() { ## cSpell:Ignore BS_LARBR_
    BS_LARBR_Caller="${1:?'[libarray::fn_bs_libarray_remove_by_range]: Internal Error: a command name is required'}"
  BS_LARBR_refArray="${2:?'[libarray::fn_bs_libarray_remove_by_range]: Internal Error: an array variable is required'}"
     BS_LARBR_Range="${3:?'[libarray::fn_bs_libarray_remove_by_range]: Internal Error: a range is required'}"

  #---------------------------------------------------------
  # Unpack the array
  eval "BS_LARBR_Array=\"\${${BS_LARBR_refArray}-}\"" || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LARBR_Array?}" && shift || return $?

  #---------------------------------------------------------
  # Early out
  case $# in 0) return ;; esac

  #---------------------------------------------------------
  # Determine START and LENGTH
  # NOTES: START will be zero-based, LENGTH >= 1
  case ${BS_LARBR_Range} in
    #...................................
    #> `case ${BS_LARBR_Range} in`
    #> ---------------------------
    #
    #  USING A RANGE
    *[#:]*)
      fn_bs_libarray_process_range \
        "${BS_LARBR_Caller}"       \
        'BS_LARBR_Start'           \
        'BS_LARBR_Length'          \
        "${BS_LARBR_Range}"        \
        $#                         || return $? ;;

    #.................................
    #> `case ${BS_LARBR_Range} in`
    #> ---------------------------
    #
    # USING AN INDEX
    # (convert to a single
    #  element range)
    *)
      fn_bs_libarray_process_index \
        "${BS_LARBR_Caller}"       \
        'BS_LARBR_Range'           \
        $#                         || return $?
      BS_LARBR_Start="${BS_LARBR_Range}"
      BS_LARBR_Length=1 ;;
  esac #<: `case ${BS_LARBR_Range} in`

  #---------------------------------------------------------
  # PROCESS \[START, START + LENGTH)
  BS_LARBR_End=;
  case ${BS_LARBR_Start} in
    #...................................
    #> `case ${BS_LARBR_Start} in`
    #> ---------------------------
    #
    # START is zero
    # - keep nothing
    # - skip \[0, LENGTH)
    0)  BS_LARBR_Array=;
        BS_LARBR_End="${BS_LARBR_Length}" ;;

    #...................................
    #> `case ${BS_LARBR_Start} in`
    #> ---------------------------
    #
    # START is non-zero
    # - keep \[0, START)
    # - skip \[START, START + LENGTH)
    *)
      #  Add kept values
      BS_LARBR_Array="$(
          fn_bs_libarray_create  \
            "${BS_LARBR_Caller}" \
            "${BS_LARBR_Start}"  \
            "$@"
        )" || return $?

      #  Skip kept values + skipped values
      BS_LARBR_End=$((BS_LARBR_Start + BS_LARBR_Length)) ;;
  esac #<: `case ${BS_LARBR_Start} in`

  #---------------------------------------------------------
  # Append any remaining elements
  case $# in
    #...................................
    #> `case $# in`
    #> ------------
    #
    # NOTHING TO ADD
    0|"${BS_LARBR_End}") ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    # ONE OR MORE ELEMENTS TO ADD
    *)
      # `shift` all processed elements
      case ${c_BS_LIBARRAY_CFG_USE__shift_n:-0} in
      0)  while : #< [ "${BS_LARBR_End}" -ge 0 ]
          do
            #> LOOP TEST ---------------------------
            case ${BS_LARBR_End} in 0) break ;; esac #< [ "${BS_LARBR_End}" -ge 0 ]
            #> -------------------------------------
            shift
            BS_LARBR_End=$((BS_LARBR_End - 1))
          done ;;
      1) shift "${BS_LARBR_End}" ;;
      esac

      BS_LARBR_Array="${BS_LARBR_Array}$(
          fn_bs_libarray_create \
            'array_insert'      \
            $#                  \
            "$@"
        )" || return $? ;;
  esac #<: `case $# in`

  eval "${BS_LARBR_refArray}=\"\${BS_LARBR_Array}\""        #< SAVE
}

#_______________________________________________________________________________
## cSpell:Ignore notmatch
#; ---------------------------------------------------------
#;
#; ### fn_bs_libarray_find_index
#;
#; Search an array for an element and get the index of that element.
#;
#; Exit status will be zero _only_ if a match was found, otherwise it will be
#; non-zero.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_find_index <CALLER> <INDEX> <PRIMARY> <EXPRESSION> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `INDEX` \[out:ref]
#;
#; : Variable which will contain the index of the
#;   found element; will be set to null if element
#;   is not found.
#; : Any current contents will be lost.
#; : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#; : If specified as `-` (`<hyphen>`) index is written to `STDOUT`.
#; : If the variable is _not_ currently null, the value it
#;   contains is used as an offset from which the search
#;   should begin.
#;
#; `PRIMARY` \[in]
#;
#; : A test operator used with `EXPRESSION`.
#; : MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
#;   `-lt`, `-le`, `-like`, or `-notlike`, `-bre`,
#;   `-notbre`, `-ere`, or `-notere`.
#; : The primaries `-gt`, `-ge`, `-lt`, and `-le`
#;   are identical to the `test` primaries of the
#;   same names, while `=`, `!=`, `-eq`, and `-ne`
#;   are functionally similar, but do not distinguish
#;   between numerical and string values.
#; : The `-like` primary performs a `case` pattern
#;   match and supports the glob characters as
#;   supported by `case`, the `-notlike` primary is
#;   identical, but with inverted meaning.
#; : `-like` and `-notlike` support the normal `case`
#;   pattern matching characters, and can consist of
#;   multiple patterns delimited by the `|` character.
#; : `-bre` supports ["Basic Regular Expression"][posix_bre]
#;   sequences that are _always_ implicitly
#;   anchored to the start of the value, the
#;   `-notbre` primary is identical, but with
#;   inverted meaning.
#; : `-ere` supports ["Extended Regular Expression"][posix_ere]
#;   sequences that are _always_ implicitly
#;   anchored to the start of the value, the
#;   `-notere` primary is identical, but with
#;   inverted meaning.
#; : The following aliases are also recognized:
#;
#;   > `-bre`    :   `-match`,       `-matchbre`
#;   > `-notbre` :   `-notmatch`,    `-notmatchbre`
#;   > `-ere`    :   `-matchex`,     `-matchere`
#;   > `-notere` :   `-notmatchex`,  `-notmatchere`
#;
#; `EXPRESSION` \[in]
#;
#; : Value to use with `PRIMARY`.
#; : Can be null.
#; : _EXPECTS_
#;   - a _string_ when PRIMARY is `=` or `!=`
#;   - a _number_ when PRIMARY is `-eq`, `-ne`,
#;     `-gt`, `-ge`, `-lt`, or `-le`
#;   - a `case` pattern when PRIMARY is `-like`
#;     or `-notlike`
#;   - a "Basic Regular Expression" when `PRIMARY` is
#;     `-bre` or `-notbre`
#;   - an "Extended Regular Expression" when
#;     `PRIMARY` is `-ere` or `-notere`.
#; : _ALLOWS_
#;   - a _number_ when `PRIMARY` is `=` or `!=`
#;   - a _string_ when `PRIMARY` is `-eq` or `-ne`.
#; : `case` pattern allows the normal `case` pattern
#;   matching characters: `*` (`<asterisk>`)
#;   `?` (`<question-mark>`), and
#;   `[` (`<left-square-bracket>`) with the same
#;   meanings as with a standard `case` match;
#;   also supported is the pattern delimiter `|`
#;   (`<vertical-line>`) which can be used to separate
#;   multiple patterns in a single `EXPRESSION`.
#; : When a "Basic Regular Expression" or an
#;   "Extended Regular Expression", the match is
#;   _always_ anchored to the start of `VALUE`.
#;
#; `VALUE` \[in]
#;
#; : Can be specified multiple times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; **IMPORTANT NOTES**
#; <!-- ---------- -->
#;
#; - Support for "Extended Regular Expressions" depends on `awk` supporting
#;   `match` and `ENVIRON`. If either of these are not supported then EREs
#;   will not work.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The performance of primaries varies, and is often implementation dependent
#;   however, generally the expectation would be that:
#;
#;       -eq|-ne > -like|-notlike >> -bre|-notbre >> -ere|-notere
#;
#;   (The differences between the regular expression primaries is much more
#;    likely to vary between implementations.)
#; - See [`fn_bs_libarray_match_bre`](#fn_bs_libarray_match_bre) for more about
#;   "Basic Regular Expression" matching, and
#;   [`fn_bs_libarray_match_ere`](#fn_bs_libarray_match_ere)
#;   for "Extended Regular Expression" matching
#;
#_______________________________________________________________________________
fn_bs_libarray_find_index() { ## cSpell:Ignore BS_LAFI_
  BS_LAFI_Caller="${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: a command name is required'}"
  shift
  BS_LAFI_refIndex="${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: an index variable is required'}"
  shift
  BS_LAFI_Primary="${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: a primary is required'}"
  shift
  BS_LAFI_Expression="${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: an expression is required'}"
  shift

  #---------------------------------------------------------
  #  CHECK ALL PARAMETERS FOR A MATCHING VALUE
  BS_LAFI_Found=;  BS_LAFI_Index=0;
  case ${BS_LAFI_Primary} in
    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    # MATCH: CASE PATTERN
    '-like')
      fn_bs_libarray_as_safe_case_pattern 'BS_LAFI_Expression' || return $?
      eval "for BS_LAFI_Element
            do
              case \${BS_LAFI_Element} in
              ${BS_LAFI_Expression:-''})
                BS_LAFI_Found=\"\${BS_LAFI_Index}\"
                break ;;
              esac
              BS_LAFI_Index=\$((BS_LAFI_Index + 1))
            done" || return $?
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    # MATCH: CASE PATTERN [INVERTED]
    '-notlike')
      fn_bs_libarray_as_safe_case_pattern 'BS_LAFI_Expression' || return $?
      eval "for BS_LAFI_Element
            do
              case \${BS_LAFI_Element} in
              ${BS_LAFI_Expression:-''})
                BS_LAFI_Index=\$((BS_LAFI_Index + 1))
                continue ;;
              esac
              BS_LAFI_Found=\"\${BS_LAFI_Index}\"
              break
            done" || return $?
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    #  MATCH A BRE
    ## cSpell:IgnoreRegExp -\w*bre\w*\b
    '-match'|'-matchbre'|'-bre')
      for BS_LAFI_Element
      do
        if  fn_bs_libarray_match_bre  \
              "${BS_LAFI_Element}"    \
              "${BS_LAFI_Expression}"
        then
          BS_LAFI_Found="${BS_LAFI_Index}"
          break
        else
          BS_LAFI_Index=$((BS_LAFI_Index + 1))
        fi
      done
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    #  MATCH A BRE (INVERTED)
    '-notmatch'|'-notmatchbre'|'-notbre')
      for BS_LAFI_Element
      do
        if  fn_bs_libarray_match_bre  \
              "${BS_LAFI_Element}"    \
              "${BS_LAFI_Expression}"
        then
          BS_LAFI_Index=$((BS_LAFI_Index + 1))
        else
          BS_LAFI_Found="${BS_LAFI_Index}"
          break
        fi
      done
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    #  MATCH AN ERE
    ## cSpell:IgnoreRegExp -((\w*ere\w*)|(\w*matchex))\b
    '-matchex'|'-matchere'|'-ere')
      for BS_LAFI_Element
      do
        if  fn_bs_libarray_match_ere  \
              "${BS_LAFI_Element}"    \
              "${BS_LAFI_Expression}"
        then
          BS_LAFI_Found="${BS_LAFI_Index}"
          break
        else
          BS_LAFI_Index=$((BS_LAFI_Index + 1))
        fi
      done
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    #  MATCH AN ERE (INVERTED)
    '-notmatchex'|'-notmatchere'|'-notere')
      for BS_LAFI_Element
      do
        if  fn_bs_libarray_match_ere  \
              "${BS_LAFI_Element}"    \
              "${BS_LAFI_Expression}"
        then
          BS_LAFI_Index=$((BS_LAFI_Index + 1))
        else
          BS_LAFI_Found="${BS_LAFI_Index}"
          break
        fi
      done
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    #  MATCH: EQUALS
    '-eq'|'=')
      for BS_LAFI_Element
      do
        case ${BS_LAFI_Element} in
        "${BS_LAFI_Expression}")
          BS_LAFI_Found="${BS_LAFI_Index}"
          break ;;
        esac
        BS_LAFI_Index=$((BS_LAFI_Index + 1))
      done
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    #  MATCH: NOT EQUALS
    '-ne'|'!=')
      for BS_LAFI_Element
      do
        case ${BS_LAFI_Element} in
        "${BS_LAFI_Expression}")
          BS_LAFI_Index=$((BS_LAFI_Index + 1))
          continue ;;
        esac
        BS_LAFI_Found="${BS_LAFI_Index}"
        break
      done
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    #  MATCH: TEST EXPRESSION
    '-gt'|'-ge'|'-lt'|'-le')
      for BS_LAFI_Element
      do
        if test "${BS_LAFI_Element}"    \
                "${BS_LAFI_Primary}"    \
                "${BS_LAFI_Expression}"
        then
          BS_LAFI_Found="${BS_LAFI_Index}"
          break
        else
          BS_LAFI_Index=$((BS_LAFI_Index + 1))
        fi
      done
    ;;

    #...................................
    #> `case ${BS_LAFI_Primary} in`
    #> ----------------------------
    #
    # INVALID
    *)  fn_bs_libarray_invalid_args \
          "${BS_LAFI_Caller}"       \
          "invalid primary '${BS_LAFI_Primary}'"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case ${BS_LAFI_Primary} in`

  eval "${BS_LAFI_refIndex}=\"\${BS_LAFI_Found}\""          #< SAVE
}

#===============================================================================
#===============================================================================
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## COMMANDS
#:
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_value`
#:
#: Create a single array element from a given value.
#:
#: Primarily for internal use, but may be of use should the normal array
#: creation commands not be suitable in a given situation.
#:
#: Should **not** be used for values then passed to other commands for adding
#: to arrays.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_value <VALUE>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `VALUE` \[in]
#:
#: : Value to convert into an array value.
#: : Can be null.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : MUST be a single value.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     ArrayValue="$(array_value 'Value')"
#:     Array="$(
#:       for ArrayValue in "$@"
#:       do
#:         array_value "$ArrayValue"
#:       done
#:       echo ' '
#:     )"
#:
#_______________________________________________________________________________
array_value() { ## cSpell:Ignore BS_LAValue_
  case $# in
  1)  ;;
  *)  fn_bs_libarray_expected 'array_value' 'a value'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # It is much faster to only invoke `sed` if required
  # to escape quote characters (even when taking into
  # account the cost of testing for the quote)
  # NOTES:
  # - due to quoting rules for shells '\\\\' results
  #   in a single escape in the final string
  case $1 in
    #.......................................................
    #> `case $1 in`
    #> ------------
    #
    # Has `<apostrophe>` characters
    *"'"*)
      {
        printf '%s\n' "$1"
      } | {
        # `sed` script:
        # - escape all `<apostrophe>` characters
        # - add a `<apostrophe>` character to the start
        #   of the value
        # - add a `<apostrophe>` to the end of the value
        #   **and** add an escape after that (this
        #   will escape the whitespace that must follow)
        #
        # NOTES:
        # - has to account for values that may
        #   contain `<newline>` characters
        sed -e "s/'/'\\\\''/g
                1s/^/'/
                \$s/\$/' \\\\/"
      }
    ;;

    #.......................................................
    #> `case $1 in`
    #> ------------
    #
    # No `<apostrophe>` characters
    *)  printf "'%s' \\\\\n" "$1" ;;
  esac #<: `case $1 in`
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_new`
#:
#: Create a new named array from the given arguments _or_ an array written to
#: `STDOUT` with values from `STDIN`.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     ... | array_new
#:
#:     array_new [--reverse|--reversed|-r] <ARRAY> [<VALUE>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `--reverse`, `--reversed`, `-r` \[in]
#:
#: : Create the array in reverse order, first `VALUE`
#:   will be the last array element, etc.
#: : Can _not_ be used for arrays created from `STDIN`.
#:
#: `ARRAY` \[out:ref]
#:
#: : Variable that will contain the new array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If specified as `-` (`<hyphen>`) array is written to
#:   `STDOUT`.
#: : REQUIRED if _any_ other argument is specified.
#:
#: `VALUE` \[in]
#:
#: : Can be specified multiple times.
#: : Can be null.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : Each value specified will become an array
#:   element.
#:
#: If `ARRAY` is specified but _no_ `VALUE`s are
#: specified an empty array is created.
#:
#: If no arguments are provided input is from `STDIN`
#: and array is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Array="$(grep -e 'ERROR' /var/log/syslog | array_new)"
#:     Array="$(array_new - "$Value1" ... "$ValueN")"
#:     array_new 'Array' "$Value1" ... "$ValueN"
#:     array_new --reverse 'Array' "$@"
#:
#:     array_new 'Array' "$@"
#:     ...
#:     eval "set -- ${Array}"
#:     for Value in "$@"; do ...; done
#:
#: _NOTES_
#: <!-- -->
#:
#: - When given no arguments, will read array values from `STDIN`; if
#:   this is erroneously used without `STDIN` directed into the
#:   command this will block indefinitely.
#: - An array created from `STDIN` will have one element per line of input;
#:   if values need to contain embedded `<newline>` characters the array
#:   must be created with arguments.
#: - An empty array created when _only_ `ARRAY` is specified will result in
#:   `ARRAY` being set to null.
#: - An empty array created when _no_ arguments are specified (i.e. an
#:   empty array from a pipe/`STDIN`) will **ALWAYS** contain at least
#:   whitespace, i.e. any variable set to the captured output will **NOT** be
#:   null even if the array is empty. To test for an empty array in this case
#:   use [`array_size`](#array_size).
#: - Creating a reverse array is slower than a normal array, though the
#:   difference is unlikely to be measurable in most cases.
#:
#_______________________________________________________________________________
array_new() { ## cSpell:Ignore BS_LANew_
  #---------------------------------------------------------
  # FROM STDIN
  case $# in
  0)  sed -e "s/'/'\\\\''/g
              s/^/'/
              s/\$/' \\\\/"
      echo ' '
      return ;;
  esac

  #---------------------------------------------------------
  # FROM PARAMETERS
   BS_LANew_Reverse=0
  BS_LANew_refArray=;

  #.....................................
  # Extract Options
  while : #< [ $# -gt 0 ]
  do
    #> LOOP TEST --------------
    case $# in 0) break ;; esac #< [ $# -gt 0 ]
    #> ------------------------
    case $1 in
      #'''''''''''''''''''''''''''''''''
      #> `case $1 in`
      #> ------------
      '--reverse'|'--reversed'|'-reverse'|'-reversed'|'-r')
        case ${BS_LANew_Reverse}:$# in
        1:*)  fn_bs_libarray_expected           \
                'array_new'                     \
                'a --reverse option (optional)' \
                'an array variable'             \
                'zero or more values'
              return "${c_BS_LIBARRAY__EX_USAGE}" ;;
        *:1)  fn_bs_libarray_invalid_args \
                'array_new'               \
                "an array variable is required with '--reverse'"
              return "${c_BS_LIBARRAY__EX_USAGE}" ;;
        esac
        BS_LANew_Reverse=1
      ;;

      #'''''''''''''''''''''''''''''''''
      #> `case $1 in`
      #> ------------
      *)
        case ${BS_LANew_refArray:+1} in
        1)  break ;;
        *)  BS_LANew_refArray="$1"
            fn_bs_libarray_validate_name_hyphen \
              'array_new'                       \
              "${BS_LANew_refArray}"            || return $? ;;
        esac
      ;;
    esac #<: `case $1 in`
    shift
  done #<: `while : #< [ $# -gt 0 ]`

  #.....................................
  # Create Array
  case $# in
  0)  BS_LANew_Array=; ;;
  *)  case ${BS_LANew_Reverse} in
      0) BS_LANew_Count=$#          ;;
      1) BS_LANew_Count=$((0 - $#)) ;;
      esac

      BS_LANew_Array="$(
          fn_bs_libarray_create \
            'array_new'         \
            "${BS_LANew_Count}" \
            "$@"
        )" || return $? ;;
  esac #<: `case $# in`

  case ${BS_LANew_refArray} in
  -) printf '%s\n' "${BS_LANew_Array}" ;;                   #< OUTPUT
  *) eval "${BS_LANew_refArray}=\"\${BS_LANew_Array}\"" ;;  #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_size`
#:
#: Get the size of the given array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_size <ARRAY> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the array size.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   size is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Size="$(array_size 'Array')"
#:     Size="$(array_size 'Array' -)"
#:     array_size 'Array' 'Size'
#:
#_______________________________________________________________________________
array_size() { ## cSpell:Ignore BS_LASize_
  case $# in
  1)  BS_LASize_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_size'               \
        "${BS_LASize_refArray}"    || return $?
      BS_LASize_refSize='-' ;;

  2)  BS_LASize_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_size'               \
        "${BS_LASize_refArray}"    || return $?

      BS_LASize_refSize="$2"
      fn_bs_libarray_validate_name_hyphen \
        'array_size'                      \
        "${BS_LASize_refSize}"            || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_size'          \
        'an array variable'   \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LASize_Array=\"\${${BS_LASize_refArray}-}\""    || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LASize_Array?} && shift" || return $?

  case ${BS_LASize_refSize} in
  -) printf '%d\n' $# ;;                                    #< OUTPUT
  *) eval "${BS_LASize_refSize}=$#" ;;                      #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_get`
#:
#: Look up an array value by index.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_get <ARRAY> <INDEX> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : MUST be an existing array of size > `INDEX`.
#:
#: `INDEX` \[in]
#:
#: : Array index.
#: : MUST be numeric.
#: : MUST be within array bounds.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the element value.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   value is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_get 'Array' 4 'ValueVar'
#:     ValueVar="$(array_get 'Array' 4)"
#:     ValueVar="$(array_get 'Array' 4 -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Supports zero-based, one-based, or negative indexing
#:   (see
#:   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#: - If value is output to `STDOUT` data _may_ be lost if the array value ends
#:   with a `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be
#:   removed from the end of output generated by commands).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Internal indexes are zero-based, as shell parameters are one-based this
#.   means some operations will add 1 to the index used.
#.
#_______________________________________________________________________________
array_get() { ## cSpell:Ignore BS_LAGet_
  case $# in
  2)  BS_LAGet_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_get'                \
         "${BS_LAGet_refArray}"    || return $?

         BS_LAGet_Index="$2"
      BS_LAGet_refValue='-' ;;

  3)  BS_LAGet_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_get'                \
         "${BS_LAGet_refArray}"    || return $?

         BS_LAGet_Index="$2"
      BS_LAGet_refValue="$3"
      fn_bs_libarray_validate_name_hyphen \
        'array_get'                       \
        "${BS_LAGet_refValue}"            || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_get'           \
        'an array variable'   \
        'an array index'      \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LAGet_Array=\"\${${BS_LAGet_refArray}-}\""     || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAGet_Array?} && shift" || return $?

  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_get'               \
        'can not "get" value from empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  # Process and validate the index
  # NOTES: `BS_LAGet_Index` is zero-based
  fn_bs_libarray_process_index \
    'array_get'                \
    'BS_LAGet_Index'           \
    $#                         || return $?

  #  Lookup the value
  BS_LAGet_Value=;
  fn_bs_libarray_get_param  \
    'BS_LAGet_Value'        \
    $((BS_LAGet_Index + 1)) \
    "$@"                    || return $?

  case ${BS_LAGet_refValue} in
  -) printf '%s\n' "${BS_LAGet_Value}" ;;                   #< OUTPUT
  *) eval "${BS_LAGet_refValue}=\"\${BS_LAGet_Value}\"" ;;  #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_set`
#:
#: Set an array value by index.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_set <ARRAY> <INDEX> <VALUE>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : MUST be an existing array of size > `INDEX`.
#:
#: `INDEX` \[in]
#:
#: : Array index.
#: : MUST be numeric.
#: : MUST be within array bounds.
#:
#: `VALUE` \[in]
#:
#: : Can be null.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : MUST be a single value.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_set 'Array' 4 'New Value'
#:
#: _NOTES_
#: <!-- -->
#:
#: - Supports zero-based, one-based, or negative indexing
#:   (see
#:   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Internal indexes are zero-based, as shell parameters are one-based this
#.   means some operations will add 1 to the index used.
#.
#_______________________________________________________________________________
array_set() { ## cSpell:Ignore BS_LASet_
  case $# in
  3)  BS_LASet_refArray="$1"
         BS_LASet_Index="$2"
      BS_LASet_NewValue="$3" ;;
  *)  fn_bs_libarray_expected \
        'array_set'           \
        'an array variable'   \
        'an array index'      \
        'a value'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  fn_bs_libarray_validate_name \
    'array_set'                \
    "${BS_LASet_refArray}"     || return $?

  eval "BS_LASet_Array=\"\${${BS_LASet_refArray}-}\""    || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LASet_Array} && shift" || return $?

  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_set'               \
        'can not "set" value in empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  # Process and validate the index
  # NOTES: `BS_LASet_Index` is zero-based
  fn_bs_libarray_process_index \
    'array_set'                \
    'BS_LASet_Index'           \
    $#                         || return $?

  #  Resave up to the indexed value
  case ${BS_LASet_Index} in
  0) BS_LASet_Array=; ;;
  *) BS_LASet_Array="$(
        fn_bs_libarray_create \
          'array_set'         \
          "${BS_LASet_Index}" \
          "$@"
      )" || return $? ;;
  esac

  # `shift` all the values no longer needed
  # (i.e. everything up to and including the index)
  #
  # NOTES:
  # - `BS_LASet_Index` is zero-based, while shell
  #   parameters are one-based, so an extra `shift`
  #   is performed
  case ${c_BS_LIBARRAY_CFG_USE__shift_n:-0} in
  1)  shift $((BS_LASet_Index + 1)) ;;
  0)  while : #< [ "${BS_LASet_Index}" -ge 0 ]
      do
        #> LOOP TEST ------------------------------
        case ${BS_LASet_Index} in -1) break ;; esac #< [ "${BS_LASet_Index}" -ge 0 ]
        #> ----------------------------------------
        shift
        BS_LASet_Index=$((BS_LASet_Index - 1))
      done ;;
  esac

  # Set the value & append remaining values
  #
  # NOTES:
  # - no need to deal with "$@" specially here as even if
  #   the shell creates a parameter when it should not,
  #   the count is used to create the array and it will
  #   be correct
  BS_LASet_Array="${BS_LASet_Array}$(
      fn_bs_libarray_create    \
        'array_set'            \
        $(($# + 1))            \
        "${BS_LASet_NewValue}" \
        "$@"
    )" || return $?

  eval "${BS_LASet_refArray}=\"\${BS_LASet_Array}\""        #< SAVE
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_insert`
#:
#: Insert one or more values into an existing array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_insert <ARRAY> <INDEX> <VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable
#:   (a new array will be created).
#:
#: `INDEX` \[in]
#:
#: : Array index of first inserted element.
#: : MUST be numeric.
#: : MUST be within array bounds.
#:
#: `VALUE` \[in]
#:
#: : Can be specified multiple times.
#: : Can be null.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_insert 'Array' 4 'Inserted Value' 'Another Inserted Value'
#:
#: _NOTES_
#: <!-- -->
#:
#: - Supports zero-based, one-based, or negative indexing
#:   (see
#:   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Internal indexes are zero-based, as shell parameters are one-based this
#.   means some operations will add 1 to the index used.
#.
#_______________________________________________________________________________
array_insert() { ## cSpell:Ignore BS_LAInsert_
  case $# in
  0|1|2)
      fn_bs_libarray_expected \
        'array_insert'        \
        'an array variable'   \
        'an array index'      \
        'one or more values'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;

  *)  BS_LAInsert_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_insert'             \
        "${BS_LAInsert_refArray}"  || return $?
      shift

      BS_LAInsert_Index="$1"
      shift ;;
  esac #<: `case $# in`

  #  Create a new array from the values to insert (this
  #+ needs done here as the old array must be unpacked and
  #+ will overwrite the positional parameters)
  BS_LAInset_Inserted="$(
      fn_bs_libarray_create \
        'array_insert'      \
        $#                  \
        "$@"
    )" || return $?

  #  Unpack the existing array
  eval "BS_LAInsert_Array=\"\${${BS_LAInsert_refArray}-}\""  || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAInsert_Array?} && shift" || return $?

  # Process and validate the index
  # NOTES: `BS_LAInsert_Index` is zero-based
  fn_bs_libarray_process_index \
    'array_insert'             \
    'BS_LAInsert_Index'        \
    $#                         || return $?

  #---------------------------------------------------------
  # Resave current values up to the index and
  # append the inserted values
  case ${BS_LAInsert_Index} in
  0) BS_LAInsert_Array="${BS_LAInset_Inserted}"; ;;
  *) BS_LAInsert_Array="$(
        fn_bs_libarray_create    \
          'array_insert'         \
          "${BS_LAInsert_Index}" \
          "$@"
      )${BS_LAInset_Inserted}" || return $? ;;
  esac

  #---------------------------------------------------------
  # Append any remaining values from the original array
  case $# in
    #...................................
    #> `case $# in`
    #> ------------
    #
    #  NOTHING ELSE TO ADD
    "${BS_LAInsert_Index}") ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    # ONE OR MORE VALUES TO ADD
    *)
      # `shift` all the values already added
      case ${c_BS_LIBARRAY_CFG_USE__shift_n:-0} in
      1)  shift "${BS_LAInsert_Index}" ;;
      0)  while : #< [ "${BS_LAInsert_Index}" -ge 0 ]
          do
            #> LOOP TEST --------------------------------
            case ${BS_LAInsert_Index} in 0) break ;; esac #< [ "${BS_LAInsert_Index}" -ge 0 ]
            #> ------------------------------------------
            shift
            BS_LAInsert_Index=$((BS_LAInsert_Index - 1))
          done ;;
      esac

      # Append the remaining values
      BS_LAInsert_Array="${BS_LAInsert_Array}$(
          fn_bs_libarray_create \
            'array_insert'      \
            $#                  \
            "$@"
        )" || return $? ;;
  esac #<: `case $# in`

  eval "${BS_LAInsert_refArray}=\"\${BS_LAInsert_Array}\""  #< SAVE
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_remove`
#:
#: Remove one or more values from an existing array, by index, range, or
#: matching an expression.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_remove <ARRAY> <INDEX>
#:
#:     array_remove <ARRAY> <RANGE>
#:
#:     array_remove <ARRAY> <PRIMARY> <EXPRESSION>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : MUST be an existing array of size >= 1.
#:
#: `INDEX` \[in]
#:
#: : Array index.
#: : MUST be numeric.
#: : MUST be within array bounds.
#:
#: `RANGE` \[in]
#:
#: : A range within the array specified as either:
#:     `[START]:[END]`
#:   or
#:     `[START]#[LENGTH]`
#:   where START and END are array indexes in the
#:   range \[START, END), and LENGTH is the count
#:   of elements in the range.
#: : If LENGTH is negative or START is greater
#:   than END the range is a reverse range.
#: : If START is omitted, the range will begin with
#:   the first element of the array.
#: : If END or LENGTH are omitted, the range will
#:   end at the last element of the array.
#: : All elements MUST be within array bounds.
#: : MUST contain at least the character `:` (`<colon>`) or
#:   `#` (`<number-sign>`).
#: : MUST result in a range of size >= 1.
#:
#: `PRIMARY` \[in]
#:
#: : A test operator used with EXPRESSION.
#: : MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
#:   `-lt`, `-le`, `-like`, or `-notlike`.
#: : The primaries `-gt`, `-ge`, `-lt`, and `-le` are
#:   identical to the `test` primaries of the same
#:   names, while `=`, `!=`, `-eq`, and `-ne` are
#:   functionally similar, but do not distinguish
#:   between numerical and string values.
#: : The `-like` primary performs a `case` pattern
#:   match and supports the glob characters as
#:   supported by `case`, the `-notlike` primary is
#:   identical, but with inverted meaning.
#: : `-like` and `-notlike` support the normal `case`
#:   pattern matching characters, and can consist of
#:   multiple patterns delimited by the `|` character.
#:
#: `EXPRESSION` \[in]
#:
#: : Value to use with `PRIMARY`.
#: : Can be null.
#: : _EXPECTS_
#:   - a _string_ when `PRIMARY` is `=` or `!=`
#:   - a _number_ when `PRIMARY` is `-eq`, `-ne`,
#:     `-gt`, `-ge`, `-lt`, or `-le`
#:   - a `case` pattern when `PRIMARY` is `-like`
#:     or `-notlike`.
#: : _ALLOWS_
#:   - a _number_ when `PRIMARY` is `=` or `!=`
#:   - a _string_ when `PRIMARY` is `-eq` or `-ne`.
#: : `case` pattern allows the normal `case` pattern
#:   matching characters: `*` (`<asterisk>`)
#:   `?` (`<question-mark>`), and
#:   `[` (`<left-square-bracket>`) with the same
#:   meanings as with a standard `case` match;
#:   also supported is the pattern delimiter `|`
#:   (`<vertical-line>`) which can be used to separate
#:   multiple patterns in a single `EXPRESSION`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_remove 'Array' 2
#:     array_remove 'Array' '4:7'
#:     array_remove 'Array' -like '*an error*|*a warning*'
#:     array_remove 'Array' -notlike '*an error*|*a warning*'
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - See
#.   [`fn_bs_libarray_process_range`](#fn_bs_libarray_process_range)
#.   and
#.   [`fn_bs_libarray_create_from_unfiltered`](#fn_bs_libarray_create_from_unfiltered)
#.   for further details of the supported formats for `INDEX`, `RANGE`,
#.   `PRIMARY` and `EXPRESSION`
#.
#_______________________________________________________________________________
array_remove() { ## cSpell:Ignore BS_LARemove_
  case $# in
    #-----------------------------------
    #> `case $# in`
    #> ------------
    #
    # REMOVE by RANGE or INDEX
    2)
      BS_LARemove_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_remove'             \
        "${BS_LARemove_refArray}"  || return $?

       BS_LARemove_Range="$2"
       fn_bs_libarray_remove_by_range \
        'array_remove'                \
        "${BS_LARemove_refArray}"     \
        "${BS_LARemove_Range}"
    ;;

    #-----------------------------------
    #> `case $# in`
    #> ------------
    #
    # REMOVE by FILTER
    3)
      BS_LARemove_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_remove'             \
        "${BS_LARemove_refArray}"  || return $?

         BS_LARemove_Primary="$2"
      BS_LARemove_Expression="$3"

      #  Unpack the array
      eval "BS_LARemove_Array=\"\${${BS_LARemove_refArray}-}\""  || return $?
      eval "set 'BS_DUMMY_PARAM' ${BS_LARemove_Array?} && shift" || return $?

      case $# in
      0)  BS_LARemove_Array=; ;;
      *)  #  Create a new filtered array
          BS_LARemove_Array="$(
            fn_bs_libarray_create_from_unfiltered \
              'array_remove'                      \
              "${BS_LARemove_Primary}"            \
              "${BS_LARemove_Expression}"         \
              "$@"
          )" || return $? ;;
      esac

      #  Save the new array
      eval "${BS_LARemove_refArray}=\"\${BS_LARemove_Array}\"" #< SAVE
    ;;

    #-----------------------------------
    #> `case $# in`
    #> ------------
    #
    # INVALID
    *)
      fn_bs_libarray_expected \
        'array_remove'        \
        'an array variable'   \
        'an index, range, or glob'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;;
  esac #<: `case $# in`
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_push`
#:
#: Add one or more values to the end of an array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_push <ARRAY> [<VALUE>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable
#:   (a new array will be created).
#:
#: `VALUE` \[in]
#:
#: : Can be specified multiple times.
#: : Can be null.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_push 'Array' 'Pushed Value 1' ... 'Pushed Value N'
#:     array_push 'Array' "$@"
#:
#: _NOTES_
#: <!-- -->
#:
#: - If no VALUEs are specified, no modification is made to `ARRAY`.
#: - Performance of [`array_push`](#array_push),
#:   [`array_unshift`](#array_unshift), and [`array_new`](#array_new)
#:   are not measurably different given the same input.
#:
#_______________________________________________________________________________
array_push() { ## cSpell:Ignore BS_LAPush_
  case $# in
  0)  fn_bs_libarray_expected \
        'array_push'          \
        'an array variable'   \
        'zero or more values'
       return "${c_BS_LIBARRAY__EX_USAGE}" ;;

  1)  #  No values, but still need to validate array name
      fn_bs_libarray_validate_name \
        'array_push'               \
        "$1"                       || return $? ;;

  *)  BS_LAPush_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_push'               \
        "${BS_LAPush_refArray}"    || return $?
        shift ;;
  esac #<: `case $# in`

  BS_LAPush_New="$(
      fn_bs_libarray_create \
        'array_push'        \
        $#                  \
        "$@"
    )" || return $?

  eval "${BS_LAPush_refArray}=\"\${${BS_LAPush_refArray}-}\${BS_LAPush_New}\""  #< SAVE
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_pop`
#:
#: Remove a single value from the back of an array and save it to a variable.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_pop <ARRAY> <OUTPUT>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : MUST be an existing array of size >= 1.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the popped value.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_pop 'Array' 'ValueVar'
#:
#: _NOTES_
#: <!-- -->
#:
#: - If popping results in an empty array the array variable will be set to
#:   null.
#:
#_______________________________________________________________________________
array_pop() { ## cSpell:Ignore BS_LAPop_
  case $# in
  2)  BS_LAPop_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_pop'                \
        "${BS_LAPop_refArray}"     || return $?

      BS_LAPop_refValue="$2"
      fn_bs_libarray_validate_name \
        'array_pop'                \
        "${BS_LAPop_refValue}"     || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_pop'           \
        'an array variable'   \
        'an output variable'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LAPop_Array=\"\${${BS_LAPop_refArray}-}\""    || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAPop_Array} && shift" || return $?

  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_pop'               \
        'can not "pop" from empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #  Save the popped value
  BS_LAGet_Value=;
  fn_bs_libarray_get_param \
    "${BS_LAPop_refValue}" \
    $#                     \
    "$@"                   || return $?

  #  Resave everything else
  case $# in
  1)  eval "${BS_LAPop_refArray}=" ;;                                           #< SAVE (EMPTY)
  *)  BS_LAPop_Array="$(
          fn_bs_libarray_create \
            'array_pop'         \
            $(($# - 1))         \
            "$@"
        )" || return $?
      eval "${BS_LAPop_refArray}=\"\${BS_LAPop_Array}\"" ;;                     #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_unshift`
#:
#: Add one or more values to the front of an array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_unshift <ARRAY> [<VALUE>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable
#:   (a new array will be created).
#:
#: `VALUE` \[in]
#:
#: : Can be specified multiple times.
#: : Can be null.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_unshift 'Array' 'Value 1' ... 'Value N'
#:     array_unshift 'Array' "$@"
#:
#: _NOTES_
#: <!-- -->
#:
#: - If no VALUEs are specified, no modification is made to `ARRAY`.
#: - Performance of [`array_push`](#array_push),
#:   [`array_unshift`](#array_unshift), and [`array_new`](#array_new)
#:   are not measurably different given the same input.
#:
#_______________________________________________________________________________
array_unshift() { ## cSpell:Ignore BS_LAUnshift_
  case $# in
  0)  fn_bs_libarray_expected \
        'array_unshift'       \
        'an array variable'   \
        'zero or more values'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;

  1)  #  No values, but still need to validate array name
      fn_bs_libarray_validate_name \
        'array_unshift'            \
        "$1"                       || return $? ;;

  *)  BS_LAUnshift_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_unshift'            \
        "${BS_LAUnshift_refArray}" || return $?
      shift ;;
  esac #<: `case $# in`

  #  Create new array from unshifted values
  BS_LAUnshift_New="$(#
      fn_bs_libarray_create \
        'array_unshift'     \
        $#                  \
        "$@"
    )" || return $?

  #  Prepend new values to old array
  eval "${BS_LAUnshift_refArray}=\"\${BS_LAUnshift_New}\${${BS_LAUnshift_refArray}-}\""  #< SAVE
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_shift`
#:
#: Remove a single value from the front of an array and save it to a variable.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_shift <ARRAY> <OUTPUT>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : MUST be an existing array of size >= 1.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the shifted value.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_shift 'Array' 'ValueVar'
#:
#: _NOTES_
#: <!-- -->
#:
#: - If shifting results in an empty array the array variable will be set to
#:   null
#:
#_______________________________________________________________________________
array_shift() { ## cSpell:Ignore BS_LAShift_
  case $# in
  2)  BS_LAShift_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_shift'              \
        "${BS_LAShift_refArray}"   || return $?

      BS_LAShift_refValue="$2"
      fn_bs_libarray_validate_name \
        'array_shift'              \
        "${BS_LAShift_refValue}"   || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_shift'         \
        'an array variable'   \
        'an output variable'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LAShift_Array=\"\${${BS_LAShift_refArray}-}\""  || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAShift_Array} && shift" || return $?

  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_shift'             \
        'can not "shift" from empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #  Save the shifted value
  eval "${BS_LAShift_refValue}=\"\$1\"" || return $? #< SAVE

  #  Resave everything else
  case $# in
  1)  eval "${BS_LAShift_refArray}=" ;; #< SAVE (EMPTY)
  *)  shift
      BS_LAShift_Array="$(
          fn_bs_libarray_create \
            'array_shift'       \
            $#                  \
            "$@"
        )" || return $?
      eval "${BS_LAShift_refArray}=\"\${BS_LAShift_Array}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_reverse`
#:
#: Reverse the elements of an array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_reverse <ARRAY> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the reversed array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If specified as `-` (`<hyphen>`) reversed array is
#:   written to `STDOUT`.
#: : If not specified the array is reversed in-place
#:   (i.e. the input array is also the output array).
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_reverse 'Array'
#:     array_reverse 'Array' 'ReversedArrayVar'
#:     ReversedArrayVar="$(array_reverse 'Array' -)"
#:
#_______________________________________________________________________________
array_reverse() { ## cSpell:Ignore BS_LAReverse_
  case $# in
  1)  BS_LAReverse_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_reverse'            \
        "${BS_LAReverse_refArray}" || return $?

      BS_LAReverse_refReversed="${BS_LAReverse_refArray}" ;;

  2)  BS_LAReverse_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_reverse'            \
        "${BS_LAReverse_refArray}" || return $?

      BS_LAReverse_refReversed="$2"
      fn_bs_libarray_validate_name_hyphen \
        'array_reverse'                   \
        "${BS_LAReverse_refReversed}"     || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_reverse'       \
        'an array variable'   \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LAReverse_Array=\"\${${BS_LAReverse_refArray}-}\"" || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAReverse_Array} && shift"  || return $?

  #  Early out if no values
  case $# in
  0)  case ${BS_LAReverse_refReversed} in
      -) echo ;;                                            #< OUTPUT (EMPTY)
      *) eval "${BS_LAReverse_refReversed}=;" ;;            #< SAVE (EMPTY)
      esac
      return ;;
  esac

  BS_LAReverse_Array="$(
      fn_bs_libarray_create \
        'array_reverse'     \
        $((0 - $#))         \
        "$@"
    )" || return $?

  case ${BS_LAReverse_refReversed} in
  -) printf '%s\n' "${BS_LAReverse_Array}" ;;                         #< OUTPUT
  *) eval "${BS_LAReverse_refReversed}=\"\${BS_LAReverse_Array}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_slice`
#:
#: Get a slice of an existing array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_slice <ARRAY> <RANGE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : MUST be an existing array of size >= 1.
#:
#: `RANGE` \[in]
#:
#: : A range within the array specified as either:
#:     `[START]:[END]`
#:   or
#:     `[START]#[LENGTH]`
#:   where START and END are array indexes in the
#:   range \[START, END), and LENGTH is the count
#:   of elements in the range.
#: : If LENGTH is negative or START is greater
#:   than END the range is a reverse range.
#: : If START is omitted, the range will begin with
#:   the first element of the array.
#: : If END or LENGTH are omitted, the range will
#:   end at the last element of the array.
#: : All elements MUST be within array bounds.
#: : MUST contain at least the character `:` (`<colon>`) or
#:   `#` (`<number-sign>`).
#: : MUST result in a range of size >= 1.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the array slice.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   array slice is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_slice 'Array' '2:4'  'SlicedArrayVar'
#:     array_slice 'Array' ':2'   'SlicedArrayVar'
#:     array_slice 'Array' '2#2'  'SlicedArrayVar'
#:     array_slice 'Array' '4:2'  'SlicedArrayVar'
#:     array_slice 'Array' '4#-2' 'SlicedArrayVar'
#:
#: NOTES:
#:
#: - Supports zero-based, one-based, or negative indexing
#:   (see
#:   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - See
#.   [`fn_bs_libarray_process_range`](#fn_bs_libarray_process_range)
#.   for further details of the supported formats for `RANGE`.
#.
#_______________________________________________________________________________
array_slice() { ## cSpell:Ignore BS_LASlice_
  #-----------------
  case $# in
  2)  BS_LASlice_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_slice'              \
        "${BS_LASlice_refArray}"   || return $?

         BS_LASlice_Range="$2"
      BS_LASlice_refSlice='-' ;;

  3)  BS_LASlice_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_slice'              \
        "${BS_LASlice_refArray}"   || return $?

         BS_LASlice_Range="$2"
      BS_LASlice_refSlice="$3"
      fn_bs_libarray_validate_name_hyphen \
        'array_slice'                     \
        "${BS_LASlice_refSlice}"          || return $? ;;

  *)  fn_bs_libarray_expected     \
        'array_slice'             \
        'an array variable'       \
        'a slice range'           \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LASlice_Array=\"\${${BS_LASlice_refArray}-}\""  || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LASlice_Array} && shift" || return $?

  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_slice'             \
        'can not "slice" empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  #  Process Slice Range...
  BS_LASlice_Start=;   BS_LASlice_Length=;
  fn_bs_libarray_process_range \
    'array_slice'              \
    'BS_LASlice_Start'         \
    'BS_LASlice_Length'        \
    "${BS_LASlice_Range}"      \
    $#                         || return $?

  #---------------------------------------------------------
  #  `shift` to the start of the slice
  case ${c_BS_LIBARRAY_CFG_USE__shift_n:-0} in
  0)  while : #< [ "${BS_LASlice_Start}" -gt 0 ]
      do
        #> LOOP TEST -------------------------------
        case ${BS_LASlice_Start} in 0) break ;; esac #< [ "${BS_LASlice_Start}" -gt 0 ]
        #> -----------------------------------------
        shift
        BS_LASlice_Start=$((BS_LASlice_Start - 1))
      done ;;
  1) shift "${BS_LASlice_Start}" ;;
  esac

  #---------------------------------------------------------
  #  Create Slice...
  BS_LASlice_Array="$(
      fn_bs_libarray_create    \
        'array_slice'          \
        "${BS_LASlice_Length}" \
        "$@"
    )" || return $?

  case ${BS_LASlice_refSlice} in
  -) printf '%s\n' "${BS_LASlice_Array}" ;;                    #< OUTPUT
  *) eval "${BS_LASlice_refSlice}=\"\${BS_LASlice_Array}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_sort`
#:
#: Sort an array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_sort <ARRAY> [<OUTPUT>] [--] [<ARGUMENT>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in/out:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the sorted array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If specified as `-` (`<hyphen>`) sorted array is
#:   written to `STDOUT`.
#: : If not specified array is sorted "in-place".
#:
#: `--` \[in]
#:
#: : Causes all remaining arguments to be interpreted
#:   as arguments for `sort`.
#: : REQUIRED if `OUTPUT` is _not_ specified and the
#:   first argument to `sort` does _not_ being with a
#:   `<hyphen>`.
#:
#: `ARGUMENT` \[in]
#:
#: : Can be specified multiple times.
#: : All values passed directly to `sort`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_sort 'Array' -r
#:     array_sort 'Array' -- -r
#:     array_sort 'Array' 'SortedArrayVar' -r
#:     SortedArrayVar="$(array_sort 'Array' - -r)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Because `sort` works on lines, values containing `<newline>` characters
#:   have to be modified to be a single line. This _will_ affect sort order in
#:   some cases (i.e. the output may _not_ be strictly lexicographically
#:   correct with regards to any embedded `<newline>` characters), however the
#:   sort order of these values _will_ be stable.
#:
#_______________________________________________________________________________
array_sort() { ## cSpell:Ignore BS_LASort_
  case $# in
    #...................................
    #> `case $# in`
    #> ------------
    #
    # INVALID
    0)
      fn_bs_libarray_expected           \
        'array_sort'                    \
        'an array variable'             \
        'an output variable (optional)' \
        'sort arguments (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;;

    #.....................................
    #> `case $# in`
    #> ------------
    #
    # ARRAY ONLY
    1)
      BS_LASort_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_sort'               \
        "${BS_LASort_refArray}"    || return $?
      shift

      BS_LASort_refSorted="${BS_LASort_refArray}"
    ;;

    #.....................................
    #> `case $# in`
    #> ------------
    #
    # MULTIPLE ARGUMENTS
    *)
      BS_LASort_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_sort'               \
        "${BS_LASort_refArray}"    || return $?
      shift

      case $1 in
       --)  BS_LASort_refSorted="${BS_LASort_refArray}"
            shift ;;
      -?*)  BS_LASort_refSorted="${BS_LASort_refArray}" ;;
        *)  BS_LASort_refSorted="$1"
            fn_bs_libarray_validate_name_hyphen \
              'array_sort'                      \
              "${BS_LASort_refSorted}"          || return $?
            shift
            case ${1-} in --) shift; esac ;;
      esac #<: `case $1 in`
    ;;
  esac #<: `case $# in`

  eval "BS_LASort_Array=\"\${${BS_LASort_refArray}-}\"" || return $?

  #---------------------------------------------------------
  #  Early out if empty array
  case ${BS_LASort_Array:+1} in
  1) ;; *)  case ${BS_LASort_refSorted} in
            -) echo ;;                                      #< OUTPUT (EMPTY)
            *) eval "${BS_LASort_refSorted}=;" ;;           #< SAVE (EMPTY)
            esac
            return ;;
  esac

  #---------------------------------------------------------
  #  Set the `sort` command
  #
  # NOTES:
  # - setting the command like this is more portable than
  #   using `sort "$@"` or `sort ${1+"$@"}` later
  #
  # - an alternative to this might be to use the XBD
  #   argument '-' (i.e. "`STDIN`") if no other
  #   arguments are given (i.e. `set -`) but this also
  #   suffers from portability issues.
  #
  #  SC2121: To assign a variable, use just
  #          var=value, not set ...
  #  EXCEPT: It's not an assignment
  #  shellcheck disable=SC2121
  case $# in
  0) set sort      ;;
  *) set sort "$@" ;;
  esac

  #---------------------------------------------------------
  #  Sort the array
  BS_LASort_SortedArray="$(
      {
        # Convert values to be on single lines and print them all.
        # See [`fn_bs_libarray_escape_newlines`](#fn_bs_libarray_escape_newlines)
        fn_bs_libarray_escape_newlines \
          'array_sort'                 \
          'BS_LASort_Array'
      } | {
        #  Sort the flattened values
        "$@"
      } | {
        # Undo the conversion and turn each
        # value back into an array value
        sed -e "s/'/'\\\\''/g
                s/^/'/
                s/\$/' \\\\/
                s/ \\\\n/\n/g
                s/\\\\\\\\/\\\\/g"
      }
      echo ' '
    )"

  case ${BS_LASort_refSorted} in
  -) printf '%s\n' "${BS_LASort_SortedArray}" ;;                    #< OUTPUT
  *) eval "${BS_LASort_refSorted}=\"\${BS_LASort_SortedArray}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_search`
#:
#: Search an array for an element and get the index of that element.
#:
#: Exit status will be zero _only_ if a match was found, otherwise it will be
#: non-zero.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_search <ARRAY> [<INDEX>] [<PRIMARY>] <EXPRESSION>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable.
#:
#: `INDEX` \[in/out:ref]
#:
#: : Variable which will contain the index of the
#:   found element, or will be set to null otherwise.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   index is written to `STDOUT`.
#: : If the variable specified is _not_ null, the
#:   value is used as an offset from which the
#:   search should begin.
#:
#: `PRIMARY` \[in]
#:
#: : A test operator used with EXPRESSION.
#: : MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
#:   `-lt`, `-le`, `-like`, or `-notlike`.
#: : The primaries `-gt`, `-ge`, `-lt`, and `-le` are
#:   identical to the `test` primaries of the same
#:   names, while `=`, `!=`, `-eq`, and `-ne` are
#:   functionally similar, but do not distinguish
#:   between numerical and string values.
#: : The `-like` primary performs a `case` pattern
#:   match and supports the glob characters as
#:   supported by `case`, the `-notlike` primary is
#:   identical, but with inverted meaning.
#: : `-like` and `-notlike` support the normal `case`
#:   pattern matching characters, and can consist of
#:   multiple patterns delimited by the `|` character.
#: : If not specified the primary `=` is used.
#:
#: `EXPRESSION` \[in]
#:
#: : Value to use with PRIMARY.
#: : Can be null.
#: : _EXPECTS_
#:   - a _string_ when PRIMARY is `=` or `!=`
#:   - a _number_ when PRIMARY is `-eq`, `-ne`,
#:     `-gt`, `-ge`, `-lt`, or `-le`
#:   - a `case` pattern when PRIMARY is `-like`
#:     or `-notlike`.
#: : _ALLOWS_
#:   - a _number_ when PRIMARY is `=` or `!=`
#:   - a _string_ when PRIMARY is `-eq` or `-ne`.
#: : `case` pattern allows the normal `case` pattern
#:   matching characters: `*` (`<asterisk>`)
#:   `?` (`<question-mark>`), and
#:   `[` (`<left-square-bracket>`) with the same
#:   meanings as with a standard `case` match;
#:   also supported is the pattern delimiter `|`
#:   (`<vertical-line>`) which can be used to separate
#:   multiple patterns in a single `EXPRESSION`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     while array_search 'Array' 'Location' -like '*an error*|*a warning*'
#:     do
#:       ...
#:     done
#:
#: _NOTES_
#: <!-- -->
#:
#: - See [`array_contains`](#array_contains) for an alternative when INDEX is
#:   not required.
#:
#_______________________________________________________________________________
array_search() { ## cSpell:Ignore BS_LASearch_
  case $# in
    #...................................
    #> `case $# in`
    #> ------------
    #
    #  WITHOUT INDEX AND PRIMARY
    2)    BS_LASearch_refArray="$1"
          BS_LASearch_refIndex='-'
          BS_LASearch_Primary='='
        BS_LASearch_Expression="$2" ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    #  WITHOUT INDEX OR PRIMARY
    3)  BS_LASearch_refArray="$1"
        case $2 in
        '-'?*|'='|'!=')
          BS_LASearch_refIndex='-'
          BS_LASearch_Primary="$2" ;;
        *)
          BS_LASearch_refIndex="$2"
          BS_LASearch_Primary='=' ;;
        esac
        BS_LASearch_Expression="$3" ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    #  WITH ALL PARAMETERS
    4)    BS_LASearch_refArray="$1"
          BS_LASearch_refIndex="$2"
          BS_LASearch_Primary="$3"
        BS_LASearch_Expression="$4" ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    #  INVALID
    *)  fn_bs_libarray_expected                 \
          'array_search'                        \
          'an array variable'                   \
          'an output index variable (optional)' \
          'a primary (optional)'                \
          'an expression'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  fn_bs_libarray_validate_name \
    'array_search'             \
    "${BS_LASearch_refArray}"  || return $?

  eval "BS_LASearch_Array=\"\${${BS_LASearch_refArray}-}\""  || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LASearch_Array?} && shift" || return $?

  #---------------------------------------------------------
  #  Skip elements
  case ${BS_LASearch_refIndex} in
  [!-]*)
    fn_bs_libarray_validate_name \
      'array_search'             \
      "${BS_LASearch_refIndex}"  || return $?

    eval "BS_LASearch_SearchStart=\"\${${BS_LASearch_refIndex}-}\"" || return $?

    case ${BS_LASearch_SearchStart:+1} in
    1)  fn_bs_libarray_process_index \
          'array_search'             \
          'BS_LASearch_SearchStart'  \
          $#                         || return $?
        BS_LASearch_SearchStart=$((BS_LASearch_SearchStart + 1))
        case ${c_BS_LIBARRAY_CFG_USE__shift_n:-0} in
        1)  shift "${BS_LASearch_SearchStart}" ;;
        0)  BS_LASearch_ShiftCount="${BS_LASearch_SearchStart}"
            while : #< [ "${BS_LASearch_ShiftCount}" -ge 0 ]
            do
              #> LOOP TEST -------------------------------------
              case ${BS_LASearch_ShiftCount} in 0) break ;; esac #< [ "${BS_LASearch_ShiftCount}" -ge 0 ]
              #> -----------------------------------------------
              shift
              BS_LASearch_ShiftCount=$((BS_LASearch_ShiftCount - 1))
            done ;;
        esac
        BS_LASearch_SearchStart=$((BS_LASearch_SearchStart + c_BS_LIBARRAY_CFG__StartIndex)) ;;
    *)  BS_LASearch_SearchStart="${c_BS_LIBARRAY_CFG__StartIndex}" ;;
    esac #<: `case ${BS_LASearch_SearchStart:+1} in`
  ;;
  esac #<: `case ${BS_LASearch_refIndex} in`

  #---------------------------------------------------------
  #  Search the remaining array
  BS_LASearch_Found=;
  fn_bs_libarray_find_index     \
    'array_search'              \
    'BS_LASearch_Found'         \
    "${BS_LASearch_Primary}"    \
    "${BS_LASearch_Expression}" \
    "$@"                        || return $?

  #---------------------------------------------------------
  # Report the results
  case ${BS_LASearch_Found:+1} in
  1)  # Index needs offset correctly
      BS_LASearch_Found=$((BS_LASearch_Found + BS_LASearch_SearchStart))
      case ${BS_LASearch_refIndex} in
      -) printf '%s\n' "${BS_LASearch_Found}" ;;                      #< OUTPUT
      *) eval "${BS_LASearch_refIndex}=\"\${BS_LASearch_Found}\"" ;;  #< SAVE
      esac ;;
  *)  case ${BS_LASearch_refIndex} in
      -) echo ;;                             #< OUTPUT (EMPTY)
      *) eval "${BS_LASearch_refIndex}=;" ;; #< SAVE (EMPTY)
      esac
      return 1 ;;
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_contains`
#:
#: Identical to [`array_search`](#array_search) except the index is not returned
#: (allowing this to be much faster when `PRIMARY` is
#:  `=`, `!=`, `-eq`, or `-ne`).
#:
#: See [`array_search`](#array_search) for more information.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_contains <ARRAY> [<PRIMARY>] <EXPRESSION>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: As for [`array_search`](#array_search), with the exception of
#: `INDEX` (which is not supported).
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if array_contains 'Array' -like '*an error*|*a warning*'
#:     then
#:       ...
#:     fi
#:
#_______________________________________________________________________________
array_contains() { ## cSpell:Ignore BS_LAContains_
  case $# in
    #...................................
    #> `case $# in`
    #> ------------
    #
    #  WITHOUT PRIMARY
    2)  BS_LAContains_refArray="$1"
        fn_bs_libarray_validate_name  \
          'array_contains'            \
          "${BS_LAContains_refArray}" || return $?

           BS_LAContains_Primary='='
        BS_LAContains_Expression="$2" ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    #  WITH ALL PARAMETERS
    3)  BS_LAContains_refArray="$1"
        fn_bs_libarray_validate_name  \
          'array_contains'            \
          "${BS_LAContains_refArray}" || return $?

           BS_LAContains_Primary="$2"
        BS_LAContains_Expression="$3" ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    #  INVALID
    *)  fn_bs_libarray_expected  \
          'array_contains'       \
          'an array variable'    \
          'a primary (optional)' \
          'an expression'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #---------------------------------------------------------
  # Checking if an array contains/does not contain an exact
  # value can be very fast and does not required the array
  # is unpacked, so deal with those operations as a special
  # case
  case ${BS_LAContains_Primary} in
    #.......................................................
    #> `case ${BS_LAContains_Primary} in`
    #> ----------------------------------
    '-eq'|'=')
      BS_LAContains_Expression="$(array_value "${BS_LAContains_Expression}")" || return $?

      eval "BS_LAContains_Array=\"\${${BS_LAContains_refArray}-}\"" || return $?
      case ${BS_LAContains_Array?} in
      *"${BS_LAContains_Expression}"*) return 0 ;;
                                    *) return 1 ;;
      esac
    ;;

    #.......................................................
    #> `case ${BS_LAContains_Primary} in`
    #> ----------------------------------
    '-ne'|'!=')
      BS_LAContains_Expression="$(array_value "${BS_LAContains_Expression}")" || return $?

      eval "BS_LAContains_Array=\"\${${BS_LAContains_refArray}-}\"" || return $?
      case ${BS_LAContains_Array?} in
      *"${BS_LAContains_Expression}"*) return 1 ;;
                                    *) return 0 ;;
      esac
    ;;

    #.......................................................
    #> `case ${BS_LAContains_Primary} in`
    #> ----------------------------------
    #
    # Nothing much to be gained by having specialized
    # versions of the other operators, so delegate to
    # [`fn_bs_libarray_find_index`](#fn_bs_libarray_find_index)
    # - but ignore the found index.
    *)
      #  Unpack the array
      eval "BS_LAContains_Array=\"\${${BS_LAContains_refArray}-}\"" || return $?
      eval "set 'BS_DUMMY_PARAM' ${BS_LAContains_Array?} && shift"  || return $?

      BS_LAContains_IgnoredIndex=;
      fn_bs_libarray_find_index       \
        'array_contains'              \
        'BS_LAContains_IgnoredIndex'  \
        "${BS_LAContains_Primary}"    \
        "${BS_LAContains_Expression}" \
        "$@"                          || return $?

      case ${BS_LAContains_IgnoredIndex:+1} in
      1) return 0 ;;
      *) return 1 ;;
      esac
    ;;
  esac #<: `case ${BS_LAContains_Primary} in`
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_join`
#:
#: Join all array values into a single string.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_join <ARRAY> <DELIM> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty array or `unset` variable.
#:
#: `DELIM` \[in]
#:
#: : Value used to delimit joined values.
#: : Can be null.
#: : Can contain any escape sequences that
#:   `printf` understands, however `%` (`<percent-sign>`)
#:   characters will be output literally.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the joined string.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   joined string is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_join 'Array' ',' 'JoinedTextVar'
#:     JoinedTextVar="$(array_join 'Array' ',')"
#:     JoinedTextVar="$(array_join 'Array' ',' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - If joined text is output to `STDOUT` data _may_ be lost if if the _last_
#:   array value ends with a `\n` (`<newline>`) (_POSIX.1_ rules state that
#:   newlines should be removed from the end of output generated by commands).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - When command output is captured, _POSIX.1_ requires that trailing
#.   `<newline>` characters are stripped, when the data being written out might
#.   itself contain trailing `<newline>` characters care is required to ensure
#.   they are not lost. For this command, many values have an `<underscore>`
#.   character appended (then later removed) which avoids the loss of any data.
#.
#_______________________________________________________________________________
array_join() { ## cSpell:Ignore BS_LAJoin_ Delim
  case $# in
  2)  BS_LAJoin_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_join'               \
        "${BS_LAJoin_refArray}"    || return $?

          BS_LAJoin_Delim="$2"
      BS_LAJoin_refJoined='-' ;;

  3)  BS_LAJoin_refArray="$1"
      fn_bs_libarray_validate_name \
        'array_join'               \
        "${BS_LAJoin_refArray}"    || return $?

      BS_LAJoin_Delim="$2"

      BS_LAJoin_refJoined="$3"
      fn_bs_libarray_validate_name_hyphen \
        'array_join'                      \
        "${BS_LAJoin_refJoined}"          || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_join'          \
        'an array variable'   \
        'join text'           \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LAJoin_Array=\"\${${BS_LAJoin_refArray}-}\""    || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAJoin_Array?} && shift" || return $?

  #-------------------------------------
  #  Early out if array is empty
  case $# in
  0)  case ${BS_LAJoin_refJoined} in
      -) echo ;;                            #< OUTPUT (EMPTY)
      *) eval "${BS_LAJoin_refJoined}=;" ;; #< SAVE (EMPTY)
      esac
      return ;;
  esac

  #-------------------------------------
  #  Process DELIM to escape `printf`
  #+ format characters
  case ${BS_LAJoin_Delim} in
  *'%'*)  BS_LAJoin_Delim="$(
              {
                printf '%s_' "${BS_LAJoin_Delim}"
              } | {
                sed -e 's/%/%%/g'
              }
            )"
          BS_LAJoin_Delim="${BS_LAJoin_Delim%_}" ;;
  esac

  #-------------------------------------
  #  Join the values
  BS_LAJoin_Joined='_'
  BS_LAJoin_Format="%s${BS_LAJoin_Delim}_"
  while : #< [ $# -gt 1 ]
  do
    #> LOOP TEST --------------
    case $# in 1) break ;; esac #< [ $# -gt 1 ]
    #> ------------------------

    # SC2059: Don't use variables in the printf format
    #         string. Use printf "..%s.." "$foo".
    # EXCEPT: The intention here is to allow join text to
    #         have printf format codes.
    # shellcheck disable=SC2059
    BS_LAJoin_Joined="${BS_LAJoin_Joined%_}$(
        printf "${BS_LAJoin_Format}" "$1"
      )"
    shift
  done #<: `while : #< [ $# -gt 1 ]`

  # Join the last value after the loop
  # so DELIM is not appended to it
  BS_LAJoin_Joined="${BS_LAJoin_Joined%_}$(printf '%s_' "$1")"

  case ${BS_LAJoin_refJoined} in
  -) printf '%s\n' "${BS_LAJoin_Joined%_}" ;;                    #< OUTPUT
  *) eval "${BS_LAJoin_refJoined}=\"\${BS_LAJoin_Joined%_}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_split`
#:
#: Create an array by splitting text.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_split [<ARRAY>] <TEXT> <SEPARATOR>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[out:ref]
#:
#: : Variable that will contain the new array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   joined string is written to `STDOUT`.
#:
#: `TEXT` \[in]
#:
#: : Text to split into array elements.
#: : Can be null.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: `SEPARATOR` \[in]
#:
#: : Expression used to split `TEXT`.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : Is interpreted as a _POSIX.1_
#:   ["Extended Regular Expression"][posix_ere] _unless_
#:   exactly _one_ character when it is interpreted
#:   literally.
#: : Is used with the `awk` command `split`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_split 'Array' "$PATH" ':'
#:     Array="$(array_split "$PATH" ':')"
#:     Array="$(array_split - "$PATH" ':')"
#:
#: _NOTES_
#: <!-- -->
#:
#: - The `awk` command `split` is used to split text, so both `TEXT` and
#:   `SEPARATOR` are subject to the general `awk` requirements and any
#:   specific `split` requirements. Whether or not "empty" elements are
#:   created, may also be dependent on how `split` operates.
#: - If the separator text is intended to be a simple string longer than a
#:   single character, any regular expression commands MUST be escaped.
#:   Importantly, this includes `.` (`<period>`)) which will match **any**
#:   character if not escaped.
#: - Requires `awk` supports the `ENVIRON` array which was added in 1989, but
#:   is not part of the traditional `awk` specification and may be omitted in
#:   some implementations. (This is due to how strings are processed when passed
#:   to `awk` as arguments: not only do these have to be escaped in ways
#:   that are hard to do correctly, but they may not contain embedded newline
#:   characters. The `ENVIRON` array has neither restriction.)
#:
#_______________________________________________________________________________
array_split() { ## cSpell:Ignore BS_LASplit_ gsub
  case $# in
  2)   BS_LASplit_refArray='-'
           BS_LASplit_Text="$1"
      BS_LASplit_Separator="$2" ;;

  3)  BS_LASplit_refArray="$1"
      fn_bs_libarray_validate_name_hyphen \
        'array_split'                     \
        "${BS_LASplit_refArray}"          || return $?

           BS_LASplit_Text="$2"
      BS_LASplit_Separator="$3" ;;

  *)  fn_bs_libarray_expected \
        'array_split'         \
        'an array variable'   \
        'input text'          \
        'a separator'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  case ${BS_LASplit_Separator:+1} in
  1) ;; *)  fn_bs_libarray_invalid_args \
            'array_split'               \
            'split separator can not be null'
          return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  # Early out for null TEXT
  case ${BS_LASplit_Text:+1} in
  1) ;; *)  case ${BS_LASplit_refArray} in
            -) echo ;;                            #< OUTPUT (EMPTY)
            *) eval "${BS_LASplit_refArray}=;" ;; #< SAVE (EMPTY)
            esac
            return ;;
  esac

  # Split
  #
  # To avoid problems with how `awk` interprets strings the
  # strings are passed in as environment variables (this
  # skips some of `awk` string processing and also seems to
  # permit values that _POSIX.1_ disallows if accessed in
  # other ways, e.g. values that contain embedded
  # `<newline>` characters).
  #
  # In addition to splitting the given text the script
  # generates array values in the same way the `sed` script
  # used with [`array_value`](#array_value) does.
  #
  # Despite the script here not using input, according to
  # the `autoconf` portability documentation some `awk`
  # implementations try to read (and discard) input so
  # ensure there is some to read (`autoconf` suggests
  # redirecting input from `/dev/null`, but this will fail
  # in restricted shells)
  BS_LASplit_Array="$(
      {
        echo ' '
      } | {
        export BS_LASplit_Text
        export BS_LASplit_Separator
        awk ' BEGIN {
                   ENV_Source=ENVIRON["BS_LASplit_Text"];
                ENV_Separator=ENVIRON["BS_LASplit_Separator"];
                ORS="'\'' \\\n";
                iSplitCount=split(ENV_Source, aSplitText, ENV_Separator);
                for (iIndex=1; iIndex<=iSplitCount; ++iIndex) {
                  gsub("'\''", "'\'''\\\\\'''\''", aSplitText[iIndex]);
                  print "'\''" aSplitText[iIndex];
                }
              }
            '
      }
      echo ' '
    )" || return $?

  case ${BS_LASplit_refArray} in
  -) printf '%s\n' "${BS_LASplit_Array}" ;;                    #< OUTPUT
  *) eval "${BS_LASplit_refArray}=\"\${BS_LASplit_Array}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_printf`
#:
#: Print each element of the array with the given format.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_printf <ARRAY> <FORMAT>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in:ref]
#:
#: : Variable containing an array.
#: : MUST be a valid _POSIX.1_ name.
#: : MAY reference an empty array or `unset` variable.
#:
#: `FORMAT` \[in]
#:
#: : Passed directly to `printf`.
#: : Applied for each array element in turn.
#: : SHOULD include a `%` (`<percent-sign>`) format code.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_printf 'Array' 'Array Value: "%s"\n'
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `FORMAT` contains no format code, the literal string it contains will
#:   be output once per element in `ARRAY`.
#:
#_______________________________________________________________________________
array_printf() { ## cSpell:Ignore BS_LAPrintf_
  case $# in
  2)  #  Allow transposed arguments
      case $1 in
      *%*) BS_LAPrintf_refArray="$2"
             BS_LAPrintf_Format="$1" ;;
        *) BS_LAPrintf_refArray="$1"
             BS_LAPrintf_Format="$2" ;;
      esac

      fn_bs_libarray_validate_name \
        'array_printf'             \
        "${BS_LAPrintf_refArray}"  || return $? ;;
  *)  fn_bs_libarray_expected \
        'array_printf'        \
        'an array variable'   \
        'a print format'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  eval "BS_LAPrintf_Array=\"\${${BS_LAPrintf_refArray}-}\""  || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LAPrintf_Array?} && shift" || return $?

  # SC2059: Don't use variables in the printf format string.
  #         Use printf "..%s.." "$foo".
  # EXCEPT: The intention here is to allow callers to set
  #         the format themselves
  # shellcheck disable=SC2059
  case $# in
  0) echo ;;                                #< OUTPUT (EMPTY)
  *) printf "${BS_LAPrintf_Format}" "$@" ;; #< OUTPUT
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_from_path`
#:
#: Populate an array with the paths contained in the given path.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_from_path [--all|-a] [<ARRAY>] <PATH>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `--all`, `-a` \[in]
#:
#: : Include "dot files" (aka "hidden files").
#: : Ignored if `PATH` is _not_ a directory.
#:
#: `ARRAY` \[out:ref]
#:
#: : Variable that will contain the new array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   array is written to `STDOUT`.
#:
#: `PATH` \[in]
#:
#: : A valid path for the current platform.
#: : Path MUST be suitable for appending a glob pattern.
#: : Partial paths are permitted.
#: : Interpreted literally (i.e. glob characters will not be
#:   used as glob characters).
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     #< find /usr/local/share, /usr/local/sbin, etc
#:     array_from_path 'Array' /usr/local/s
#:
#:     #< find all paths in /usr/bin/
#:     array_from_path --all 'Array' /usr/bin
#:
#: _NOTES_
#: <!-- -->
#:
#: - It is relatively straightforward to create an array from a shell
#:   glob expression, however, there are a number of cases that can elicit
#:   unexpected results and require special care (e.g. paths containing special
#:   characters, globs for non-existing paths, etc). Additionally, there are
#:   potential issues with specific platforms that make it harder to write a
#:   truly portable solution than it seems.
#:
#_______________________________________________________________________________
array_from_path() { ## cSpell:Ignore BS_LAFP_
  BS_LAFP_DotFiles=;  BS_LAFP_refArray=;  BS_LAFP_Directory=;

  case $# in
    #...................................
    #> `case $# in`
    #> ------------
    #
    # DIRECTORY ONLY
    1)
       BS_LAFP_refArray='-'
      BS_LAFP_Directory="$1"
    ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    # DIRECTORY PLUS OTHER PARAM(S)
    2|3)
      while : #< [ $# -gt 0 ]
      do
        #> LOOP TEST --------------
        case $# in 0) break ;; esac #< [ $# -gt 0 ]
        #> ------------------------
        case $1 in
          #'''''''''''''''''''''''''''''
          #> `case $1 in`
          #> ------------
          #
          # 'all' option
          '--all'|'-a')
            case ${BS_LAFP_DotFiles:+1} in
            1)  fn_bs_libarray_expected          \
                  'array_from_directory'         \
                  'an --all option (optional)'   \
                  'an array variable (optional)' \
                  'a directory'
                return "${c_BS_LIBARRAY__EX_USAGE}" ;;
            esac
            BS_LAFP_DotFiles=1
          ;;

          #'''''''''''''''''''''''''''''
          #> `case $1 in`
          #> ------------
          #
          # Other option
          *)
            case ${BS_LAFP_refArray:+1} in
              1)  case ${BS_LAFP_Directory:+1} in
                  1)  fn_bs_libarray_expected          \
                        'array_from_directory'         \
                        'an --all option (optional)'   \
                        'an array variable (optional)' \
                        'a directory'
                      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
                  esac
                  BS_LAFP_Directory="$1" ;;
              *)  BS_LAFP_refArray="$1"
                  fn_bs_libarray_validate_name_hyphen \
                    'array_from_directory'            \
                    "${BS_LAFP_refArray}"             || return $? ;;
            esac #<: `case ${BS_LAFP_refArray:+1} in`
          ;;
        esac #<: `case $1 in`
        shift
      done #<: `while : #< [ $# -gt 0 ]`
    ;;

    #...................................
    #> `case $# in`
    #> ------------
    #
    # INVALID
    *)
      fn_bs_libarray_expected          \
        'array_from_directory'         \
        'an --all option (optional)'   \
        'an array variable (optional)' \
        'a directory'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;;
  esac #<: `case $# in`

  : "${BS_LAFP_DotFiles:=0}"

  #---------------------------------------------------------
  # No dot files for non-directory paths
  case ${BS_LAFP_DotFiles}${BS_LAFP_Directory} in
  1*[!/]) [ -d "${BS_LAFP_Directory}" ] || BS_LAFP_DotFiles=0 ;;
  esac

  #---------------------------------------------------------
  # Z Shell needs some options set or
  # the subsequent code will fail
  case ${c_BS_LIBARRAY_CFG_USE__zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'GLOB_SUBST' 'NONOMATCH' ;; ## cSpell:Ignore NONOMATCH
  esac
  #---------------------------------------------------------

  BS_LAFP_Array=;
  for BS_LAFP_Glob in '*' '.[!.]*' '..?*'
  do
    # Expand the glob. (This sets the current positional
    # parameters to each matched path)
    #
    #  SC2086: Double quote to prevent globbing
    #          and word splitting.
    #  EXCEPT: Want globbing to happen here
    #  shellcheck disable=SC2086
    set 'BS_DUMMY_PARAM' "${BS_LAFP_Directory}"${BS_LAFP_Glob}
    case $# in
    1)  ;;
    2)  # `test -e` is not universally supported, the
        # following does the same job but should work
        # even when `test -e` can't be used
        #
        # NOTE:
        # - although it seems like it should be easy to
        #   replace `test -e` with multiple `test` commands
        #   it is harder than it seems as paths can
        #   represent more than files and directories, with
        #   the exact types supported varying by platform
        if BS_LAFP_Ignored="$(ls -d -q -- "$2" 2>&1)"; then
          BS_LAFP_Array="${BS_LAFP_Array}$(array_value "$2"; echo ' ')"
        fi ;;
    *)  shift
        BS_LAFP_Array="${BS_LAFP_Array}$(
            fn_bs_libarray_create    \
              'array_from_directory' \
              $#                     \
              "$@"
          )"
        ;;
    esac #<: `case $# in`

    case ${BS_LAFP_DotFiles} in 0) break ;; esac
  done #<: `for BS_LAFP_Glob in '*' '.[!.]*' '..?*'`

  case ${BS_LAFP_refArray} in
  -) printf '%s\n' "${BS_LAFP_Array}" ;;                 #< OUTPUT
  *) eval "${BS_LAFP_refArray}=\"\${BS_LAFP_Array}\"" ;; #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_from_find`
#:
#: Create an array from the results of the `find` command.
#:
#: In contrast to [`array_from_find_allow_print`](#array_from_find_allow_print),
#: this command builds the array by capturing `STDOUT`; any output from `find`
#: that is sent to `STDOUT` _will_ result in broken array (the `-print` primary
#: is explicitly checked for and triggers an error if detected).
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_from_find [<ARRAY>] [--] [<ARGUMENT>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[out:ref]
#:
#: : Variable that will contain the new array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   array is written to `STDOUT`.
#:
#: `--` \[in]
#:
#: : Causes all remaining arguments to be interpreted as
#:   arguments for `find`.
#: : REQUIRED if ARRAY is _not_ specified and the
#:   first argument to `find` does _not_ being with a
#:   `<hyphen>`.
#:
#: `ARGUMENT` \[in]
#:
#: : Can be specified multiple times.
#: : All values passed directly to `find`.
#: : Can include any values accepted by `find`, including
#:   options (e.g. `-H`), paths, and **most** `find`
#:   primaries.
#: : MUST **not** include any `find` primaries that
#:   write to `STDOUT` (e.g. `-print`).
#: : Expression created by using `find` primaries and
#:   operators _may_ need grouped into a `find`
#:   sub-expression (even when this would not normally
#:   be required).
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_from_find 'Array' -- -L "$PWD" '(' -type f -o -type d ')'
#:     Array="$(array_from_find - -L "$PWD" -type f)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Implemented using [`BS_LIBARRAY_SH_TO_ARRAY`](#bs_libarray_sh_to_array)
#: - Requires `sh` is an available command that can execute a simple shell
#:   script with the `-c` option, as specified in the _POSIX.1_ standard.
#: - The array is built by appending an `-exec` primary to any passed primaries,
#:   i.e. the array is built as a result of an implicit `-a` where the left hand
#:   side being is whatever expression was last in the list of primaries passed
#:   to the command. This can result in unintended output when using the `-o`
#:   primary, where properly grouping primaries (using `(`
#:   (`<left-parenthesis>`), and `)` (`<right-parenthesis>`)) is essential.
#: - Some implementations of `find` allow it to be invoked without any
#:   arguments, or with arguments but without any paths. This is supported
#:   by this command if supported by the current platform.
#: - [`array_from_find_allow_print`](#array_from_find_allow_print) is provided
#:   if `find` primaries that generate output are required.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - It would be possible to allow the shell used to be configurable, however
#.   this could be a significant security risk; if a malicious actor can set
#.   the configuration option (e.g. as a system wide environment variable),
#.   arbitrary code could be executed without it being easy to detect such
#.   issues. On balance it seems better to always use `sh` as users can
#.   create alternative versions if need be.
#. - Automatically adding the required `find` parenthesis around the whole
#.   `find` expression is not attempted because to do so would require
#.   determining which arguments are the expression and which are other options
#.   (i.e. `find` options, paths, etc). This is non-trivial. Additionally the
#.   caller may not intend the entire expression to be used in that way,
#.   for example the expression `( -type d -prune ) -o -type f` could be
#.   intended to create an array of only files _or_ of files _and_ directories.
#.
#_______________________________________________________________________________
array_from_find() { ## cSpell:Ignore BS_LAFF_
  #.........................................................
  # Process arguments...
  case $# in
  0)  #<: No Arguments: Array to `STDOUT`
      BS_LAFF_refArray='-'
    ;;

  *)  #<: Multiple Arguments...

      # Determine what the first argument is...
      case $1 in
      -|--) BS_LAFF_refArray='-'
            shift ;;
        -*) BS_LAFF_refArray='-' ;;
         *) BS_LAFF_refArray="$1"
            fn_bs_libarray_validate_name_hyphen \
              'array_from_find'                 \
              "${BS_LAFF_refArray}"             || return $?
            shift
            case ${1-} in --) shift; esac ;;
      esac

      # Check for prohibited predicates in the
      # remaining arguments...
      case $# in
      0)  ;;
      *)  case $* in
          -print*|*[!-]-print*)
            fn_bs_libarray_invalid_args \
                  'array_from_find'     \
                  'the "-print" predicate can not be used here'
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
          esac ;; #<: `case $* in`
      esac ;; #<: `case $# in`
  esac #<: `case $# in`
  #.........................................................

  BS_LAFF_Array="$(
      {
        find  ${1+"$@"} \
              '-exec' 'sh' \
                      '-c' "${BS_LIBARRAY_SH_TO_ARRAY}" \
                           'BS_LIBARRAY_SH_TO_ARRAY'    \
                           '{}' '+'
      } && {
        echo ' '
      }
    )" || return $?

  case ${BS_LAFF_refArray} in
  -) printf '%s\n' "${BS_LAFF_Array}" ;;                    #< OUTPUT
  *) eval "${BS_LAFF_refArray}=\"\${BS_LAFF_Array}\"" ;;    #< SAVE
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_from_find_allow_print`
#:
#: Create an array from the results of the `find` command.
#:
#: Similar to [`array_from_find`](#array_from_find) but builds the array using
#: output redirection instead of simply capturing `STDOUT` so any `find` primary
#: that emits data to `STDOUT` (e.g. `-print`) can be used _in addition_ to
#: building the array.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_from_find_allow_print <ARRAY> [<FD>] [--] [<ARGUMENT>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[out:ref]
#:
#: : Variable that will contain the new array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `FD` \[in]
#:
#: : A pair of file descriptors in the form `<FD>,<FD>`
#:   where each `FD` is a _different_ single digit
#:   from the set `[3456789]`.
#: : If omitted values are taken from the configuration
#:   values
#:   [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`](#bs_libarray_config_find_redirect_fd_1)
#:   and
#:   [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`](#bs_libarray_config_find_redirect_fd_2).
#:
#: `--` \[in]
#:
#: : Causes all remaining arguments to be interpreted
#:   as arguments for `find`.
#: : REQUIRED if `FD` is _not_ specified and the
#:   first argument to `find` looks like `FD`.
#:
#: `ARGUMENT` \[in]
#:
#: : Can be specified multiple times.
#: : All values passed directly to `find`.
#: : Can include any values accepted by `find`, including
#:   options (e.g. `-H`), paths, and `find` primaries.
#: : Expression created by using `find` primaries and
#:   operators _may_ need grouped into a `find`
#:   sub-expression (even when this would not normally
#:   be required).
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     # Find all broken links in the current directory tree
#:     # and both store in an array AND print to STDOUT
#:     array_from_find_allow_print 'Array' 5,7 -- -L "$PWD" -type l -print
#:
#: _NOTES_
#: <!-- -->
#:
#: - Implemented using [`BS_LIBARRAY_SH_TO_ARRAY`](#bs_libarray_sh_to_array)
#: - Requires `sh` is an available command that can execute a simple shell
#:   script with the `-c` option, as specified in the _POSIX.1_ standard.
#: - The array is built by appending an `-exec` primary to any passed primaries,
#:   i.e. the array is built as a result of an implicit `-a` where the left hand
#:   side being is whatever expression was last in the list of primaries passed
#:   to the command. This can result in unintended output when using the `-o`
#:   primary, where properly grouping primaries (using `(`
#:   (`<left-parenthesis>`), and `)` (`<right-parenthesis>`)) is essential.
#: - This is likely to be of limited use; capturing the output from the
#:   `find` primaries would require a subshell meaning that the generated
#:   array would **only** be available _within_ that subshell.
#: - To support output from `find` primaries and also generate an array it
#:   is necessary to redirect output. If the file descriptors used are
#:   already in use this **will** cause errors.
#: - The _POSIX.1_ standard _allows_ for multi-digit file descriptors, however
#:   only _requires_ support for single-digit descriptors and at least some
#:   common implementations do not support multi-digit file descriptors, so
#:   they are not permitted for use here.
#:
#_______________________________________________________________________________
array_from_find_allow_print() { ## cSpell:Ignore BS_LAFFAP_
  BS_LAFFAP_FD_1="${c_BS_LIBARRAY_CFG__find_fd_1}"
  BS_LAFFAP_FD_2="${c_BS_LIBARRAY_CFG__find_fd_2}"

  #.........................................................
  # Process arguments...
  case $# in
  0)  #<: No Arguments: Error
      fn_bs_libarray_expected             \
        'array_from_find_allow_print'     \
        'an output variable'              \
        'two file descriptors (optional)' \
        'arguments for find (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;;

  1)  #<: Single Argument: Must be an output variable
      BS_LAFFAP_refArray="$1"
      fn_bs_libarray_validate_name    \
        "array_from_find_allow_print" \
        "${BS_LAFFAP_refArray}"       || return $?
      shift ;;

  *)  #<: Multiple Arguments: Must be an output variable...
      BS_LAFFAP_refArray="$1"
      fn_bs_libarray_validate_name    \
        "array_from_find_allow_print" \
        "${BS_LAFFAP_refArray}"       || return $?
      shift

      # ... _MAY_ be followed by file descriptors
      case $1 in
      [3456789],[3456789])
        BS_LAFFAP_FD_1="${1%,?}"
        BS_LAFFAP_FD_2="${1#?,}"
        case $((BS_LAFFAP_FD_1 - BS_LAFFAP_FD_2)) in
        0)  fn_bs_libarray_invalid_args     \
              'array_from_find_allow_print' \
              "file descriptors '$1' must be different values"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
        esac
        shift ;;
      esac #<: `case $1 in`

      # ... _MAY_ be followed the XBD special arg `--`
      case ${1-} in --) shift; esac ;;
  esac #<: `case $# in`
  #.........................................................

  #.........................................................
  # Run command...
  #
  # In order to do dynamic redirection use of `eval` is
  # required as the expression `$FD>&1` is not valid
  # (although `1>&$FD` is), i.e. it is valid to redirect an
  # existing stream to a dynamic file descriptor, but it is
  # _NOT_ possible to redirect a dynamic descriptor to
  # another descriptor.
  #
  # Some of the braces used here are used to split otherwise
  # long expression into more easily understandable blocks,
  # however many seemingly optional braces are actually
  # required for redirection to work correctly.
  eval "
      {
        ${BS_LAFFAP_refArray}=\"\$(
            {
              {
                find ${1+\"\$@\"} \
                    '-exec' 'sh' '-c' \
                    \"
                      {
                        \${BS_LIBARRAY_SH_TO_ARRAY}
                      } >&${BS_LAFFAP_FD_1}
                    \" \
                    'BS_LIBARRAY_SH_TO_ARRAY' \
                    '{}' '+' >&${BS_LAFFAP_FD_2}
              } && {
                echo ' ' >&${BS_LAFFAP_FD_1}
              }
            } ${BS_LAFFAP_FD_1}>&1
          )\"
      } ${BS_LAFFAP_FD_2}>&1
    "
  #.........................................................
}

#===============================================================================
#===============================================================================
# SOURCE GUARD
#
# Helper to make it easier for reliant tools to check this file has been
# sourced. MUST _never_ be exported, even under `set +a` (if exported it will
# report the script as sourced when running in sub-shells where the script
# commands are not actually available).
#===============================================================================
#===============================================================================
case $- in
*a*) set +a; BS_LIBARRAY_SOURCED=1; set -a ;;
  *)         BS_LIBARRAY_SOURCED=1         ;;
esac

fn_bs_libarray_readonly 'BS_LIBARRAY_SOURCED'

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
#: - [_POSIX.1-2008_][posix].
#: - [FreeBSD SYSEXITS(3)][sysexits].
#: - [Semantic Versioning v2.0.0][semver].
#: - [Inclusive Naming Initiative][inclusivenaming].
#:
#: _For more details see the common suite [documentation](./README.MD#standards)._
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## NOTES
#:
#: <!-- ------------------------------------------------ -->
#:
#: ### TERMINOLOGY
#:
#: - An _array_ contains zero or more _elements_.
#: - Each _element_ is any _value_ that can be stored in a
#:   standard shell variable, however:
#:   - the `\0` (`<NUL>`) character is not supported
#:   - support for any characters not appearing in the
#:     _POSIX_ locale is entirely dependent on the shell
#:     and utilities used
#: - A _value_ may be _null_, which is equivalent to the
#:   empty string.
#:   - a _null_ _value_ is different from a `<NUL>` character
#: - Each _array_ is stored in a single shell variable.
#: - An _array_ is passed to a command by _reference_, i.e.
#:   the **name** of the _array_ shell variable is passed
#:   to commands, **not** the contents:
#:
#:       array_new  'Fibonacci' 0 1 1 2 3 5 #< New array stored in $Fibonacci
#:       array_size 'Fibonacci'             #< Outputs 6
#:
#: - _Array_ _elements_ can be manipulated using the
#:   commands in this library, or can be accessed using
#:   shell positional parameters (i.e. `$@`, `$1`, `$2`,
#:   ...) by _unpacking_ the _array_ using:
#:
#:       array_new 'Fibonacci' 0 1 1 2 3 5  #< New array stored in $Fibonacci
#:       eval "set -- $Fibonacci"
#:       print '%d\n' "$4"                  #< Outputs 2
#:
#: <!-- ------------------------------------------------ -->
#:
#: ### GENERAL
#:
#: - General modification of an array outside of the library
#:   is not supported, however arrays can be concatenated by
#:   appending the contents of the array variables:
#:
#:       ArrayCat="${ArrayOne}${ArrayTwo}"
#:
#: - Argument validation occurs where possible and
#:   (relatively) performant for all arguments to
#:   all commands.
#:
#: <!-- ------------------------------------------------ -->
#:
#. ## IMPLEMENTATION NOTES
#. <!-- -------------- -->
#.
#. - Unpacking array variables passed to commands by
#.   name (aka reference) need TWO `eval` commands to
#.   correctly set positional parameters. While it seems
#.   like these could be combined into a single `eval`
#.   this is not possible; dereferencing the variable
#.   then unpacking the array have to happen separately.
#.
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## CAVEATS
#:
#: The maximum size of any array is limited by the environment in which it is
#: used, specifically no array will be able to exceed the command line length
#: limit, though other limitations may also exist.
#:
#: Note that exporting a variable containing an array will cause that variable
#: to be counted against the command line length limit **TWICE** (for any array
#: operations).
#:
#: _For more details see the common suite [documentation](./README.MD#caveats)._
#:
#% <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#%
#% ## SEE ALSO
#%
#% betterscripts(7)
#%
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#: <!-- REFERENCES -->
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
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
#: [posix_execl]:               <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/functions/execl.html>                  "execl \[pubs.opengroup.org\]"
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
################################################################################
# END
################################################################################
################################################################################
