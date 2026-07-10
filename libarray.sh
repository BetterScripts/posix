#!/usr/bin/env false
# SPDX-License-Identifier: MPL-2.0
## cSpell:Ignore libarray shtoolkit
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libarray': Array emulation for POSIX.1 compliant shells.    *#
#*                                                                            *#
#* Copyright (c) 2022-2026 BetterScripts ( better.scripts@proton.me,          *#
#*                         https://github.com/BetterScripts )                 *#
#*                                                                            *#
#* This file is part of the BetterScripts `shtoolkit` (aka _the suite_).      *#
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
#* been provided alongside this file; LICENSE.MD clarifies how the Mozilla    *#
#* Public License v2.0 applies to this file and MAY confer additional rights. *#
#*                                                                            *#
#* Should there be any apparent ambiguity (implied or otherwise) the terms    *#
#* and conditions from the Mozilla Public License v2.0 shall apply.           *#
#*                                                                            *#
#* If a copy of LICENSE.MD was not provided it can be obtained from           *#
#* https://github.com/BetterScripts/shtoolkit/LICENSE.MD.                     *#
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
# in addition to `shtoolkit` general documentation which includes details
# common to multiple libraries that may not be noted here.
#
# The included `Makefile` can be used to generate standalone documentation in
# various formats with various verbosity settings. The `Makefile` can also be
# used to install scripts and documentation in appropriate locations.
#
# As far as possible, terminology and conventions follow those of the
# [_POSIX.1-2008_ Standard][posix_2008].
#
################################################################################

################################ DOCUMENTATION #################################
#
#% % libarray(7) BetterScripts libarray v2.0.0  | Array emulation for POSIX.1 shells.
#% % BetterScripts (better.scripts@proton.me)
#% % July 2026
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
#: _Full synopsis, description, arguments, examples and other information is_
#: _documented with each individual command._
#:
#: [`array_value <VALUE>`](#array_value)
#:
#: [`array_new [--reverse|--reversed|-r] [--] <ARRAY> [<VALUE>...]`](#array_new)
#:
#: [`array_size <ARRAY> [<OUTPUT>]`](#array_size)
#:
#: [`array_get <ARRAY> <INDEX> [<OUTPUT>]`](#array_get)
#:
#: [`array_set <ARRAY> <INDEX> <VALUE>`](#array_set)
#:
#: [`array_insert <ARRAY> <INDEX> <VALUE>...`](#array_insert)
#:
#: [`array_remove <ARRAY> <INDEX>|<RANGE>|<PRIMARY> [<ARGUMENT>]`](#array_remove)
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
#: [`array_split [<OPTION>] [--] [<ARRAY>] <TEXT> <DELIMITER>`](#array_split)
#:
#: [`array_printf <ARRAY> <FORMAT>`](#array_printf)
#:
#: [`array_from_path [--all|-a] [--] [<ARRAY>] <PATH>`](#array_from_path)
#:
#: [`array_from_find [<ARRAY>] [--] [<ARGUMENT>...]`](#array_from_find)
#:
#: [`array_from_find_allow_print <ARRAY> [<FD>] [--] [<ARGUMENT>...]`](#array_from_find_allow_print)
#:
#: [`array_is_array <ARRAY>`](#array_is_array)
#:
#: **_BREAKING CHANGES_**
#: <!-- ------------- -->
#:
#: With `v2.0.0` several breaking changes were introduced:
#:
#: - [`array_from_path`](#array_from_path) now requires options precede other
#:   arguments (previously they could be specified in any order);
#: - [`array_printf`](#array_printf) no longer writes out anything for empty
#:   arrays;
#: - _Pattern Matching_ options have been entirely re-written and in some cases
#:   will no longer work as they did. This affects
#:   [`array_remove`](#array_remove), [`array_search`](#array_search),
#:   [`array_contains`](#array_contains), and [`array_split`](#array_split).
#:
#: These changes were necessary to fix several issues, some of which made the
#: previous implementations impossible to use safely in certain circumstances.
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
#: - An exit status that is _NOT_ `0` (`<zero>`) from an external command will
#:   be propagated to the caller where relevant (and possible).
#: - Exit status' not covered by any of the above use values as described in
#:   [FreeBSD `SYSEXITS(3)`][sysexits] - including the `EX_USAGE` which is used
#:   for all usage errors.
#: - Exit status is configuration agnostic.
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
# DEFAULTS
#===============================================================================
#===============================================================================
: "${BS_LIBARRAY_DEBUG:=${BS_DEBUG:-${DEBUG:-0}}}"
: "${BS_LIBARRAY_CONFIG_DEBUG:=${BS_CONFIG_DEBUG:-${BS_LIBARRAY_DEBUG:-0}}}"
: "${BS_LIBARRAY_DEBUG_FD:=${BS_DEBUG_FD:-2}}"

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## INTERNAL HELPERS
#.
#. Low level commands required to implement other parts of the library.
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
#. See [`BS_LIBARRAY_CONFIG_NO_Z_SHELL_SETOPT`](#bs_libarray_config_no_z_shell_setopt).
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
  case ${c_BS_LIBARRAY_CFG__use_zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'POSIX_BUILTINS' ;;
  esac
  readonly "$@" || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libarray_dbg_printf_to_fd`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      fn_bs_libarray_dbg_printf_to_fd <ARGS>...
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `ARGS` \[in]
#.
#. : Arguments to `printf`.
#.
#. _NOTES_
#. <!-- -->
#.
#. - Output is written to the file descriptor stored in
#.   [`BS_LIBARRAY_DEBUG_FD`](#bs_libarray_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libarray_dbg_printf_to_fd() { ## cSpell:Ignore BS_LA_DPTFD_
  # SC2059: Don't use variables in the printf format string.
  #         Use printf "..%s.." "$foo".
  # EXCEPT: This is a printf wrapper.
  # SC2086: Double quote to prevent globbing and word
  #+        splitting.
  # EXCEPT: Quoting changes the meaning (under POSIX rules
  #+        the descriptor will be considered a file)
  # shellcheck disable=SC2059,SC2086
  case ${BS_LIBARRAY_DEBUG_FD:-2} in
  [123456789]) printf "$@" >&  ${BS_LIBARRAY_DEBUG_FD}      ;;
         '&'*) printf "$@" >&  ${BS_LIBARRAY_DEBUG_FD#'&'}  ;;
            *) printf "$@" >> "${BS_LIBARRAY_DEBUG_FD#'>'}" ;;
  esac || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libarray_dbg_msg`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      fn_bs_libarray_dbg_msg <CALLER> <MESSAGE>...
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `CALLER` \[in]
#.
#. : Name of the calling command.
#. : Added to the output message.
#.
#. `MESSAGE` \[in]
#.
#. : Debug message.
#. : Multiple message values may be specified and
#.   will be joined into a single string delimited
#.   by `<space>` characters.
#.
#. _NOTES_
#. <!-- -->
#.
#. - A no-op unless debugging is enabled.
#. - Output is written to the file descriptor stored in
#.   [`BS_LIBARRAY_DEBUG_FD`](#bs_libarray_debug_fd).
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Avoids using `$*` since `IFS` may not be set appropriately.
#. - Written for simplicity and not performance.
#.
#_______________________________________________________________________________
fn_bs_libarray_dbg_msg() { ## cSpell:Ignore BS_LA_DM_
  case ${BS_LIBARRAY_DEBUG:-0} in 0) return ;; esac

  BS_LA_DM_Caller=$1
  shift

  fn_bs_libarray_dbg_printf_to_fd                \
    "[libarray::${BS_LA_DM_Caller}]: DEBUG:%s\n" \
    "$(printf ' %s' "$@")"
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libarray_config_constant`
#.
#. Helper to set configuration variables and report the set value when in
#. debug mode.
#.
#. In non-debug mode, identical to
#. [`fn_bs_libarray_readonly`](#fn_bs_libarray_readonly).
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libarray_config_constant <VAR>...
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `VAR` \[in]
#.
#. : Can be any value accepted by `readonly`.
#. : Can be specified multiple times.
#.
#. _NOTES_
#. <!-- -->
#.
#. - Output is in form `[libarray::config]: DEBUG: <NAME>: <VALUE>` where
#.   `NAME` is the constant name and `VALUE` its value.
#. - Output is written to the file descriptor stored in
#.   [`BS_LIBARRAY_DEBUG_FD`](#bs_libarray_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libarray_config_constant() { ## cSpell:Ignore BS_LA_CFGCST_
  case ${BS_LIBARRAY_CONFIG_DEBUG:-0} in
  0)  ;;
  *)  for BS_LA_CFGCST_Name
      do
        eval "BS_LA_CFGCST_Value=\${${BS_LA_CFGCST_Name}-}" || BS_LA_CFGCST_Value=;
        fn_bs_libarray_dbg_printf_to_fd              \
          "[libarray::config]: DEBUG: %s: %s\n"      \
          "${BS_LA_CFGCST_Name#c_BS_LIBARRAY_CFG__}" \
          "${BS_LA_CFGCST_Value}"                    || true
      done ;;
  esac

  case ${c_BS_LIBARRAY_CFG__use_zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'POSIX_BUILTINS' ;;
  esac
  readonly "$@" || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libarray_print_utf8_fw_A`
#.
#. Print the UTF-8 character "Fullwidth Latin Capital
#. Letter A" (code point `0xEF 0xBC 0xA1`).
#.
#. See [`U+FF21`](https://www.compart.com/en/unicode/U+FF21)
#.
#. _Used for configuration tests._
#.
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libarray_print_utf8_fw_a`
#.
#. Print the UTF-8 character "Fullwidth Latin Small Letter
#. A" (code point `0xEF 0xBD 0x81`).
#.
#. See [`U+FF41`](https://www.compart.com/en/unicode/U+FF41)
#.
#. _Used for configuration tests._
#.
#_______________________________________________________________________________
fn_bs_libarray_print_utf8_fw_A() { echo '' | awk 'BEGIN{ print "\357\274\241" }'; }
fn_bs_libarray_print_utf8_fw_a() { echo '' | awk 'BEGIN{ print "\357\275\201" }'; }

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
#: If unset, some variables will take an initial value from a common `shtoolkit`
#: variable applicable to all libraries, these allow the same configuration to
#: be used across libraries more easily.
#:
#: After the library has been sourced, external commands must not set library
#: environment variables that are classified as _CONSTANT_. Variables may use
#: the `readonly` command to enforce this.
#:
#: **_If not otherwise specified, an `<unset>` variable is equivalent to the_**
#: **_default value._**
#:
#: _For more details see the `shtoolkit` general [documentation](./README.MD#environment)._
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
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
#:   _POSIX.1_ like behavior.
#: - Automatically enabled if _Z Shell_ is detected.
#: - Any use of `setopt` is scoped as tightly as possible
#:   and SHOULD not affect other commands.
#. - See [`fn_bs_libarray_readonly`](#fn_bs_libarray_readonly).
#. - **MUST BE SET BEFORE FIRST CALL TO `fn_...readonly`**
#:
case ${BS_LIBARRAY_CONFIG_NO_Z_SHELL_SETOPT:-${BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT:-A}} in
[AD]) case ${ZSH_VERSION:+1} in
      1) c_BS_LIBARRAY_CFG__use_zsh_setopt=1 ;;
      *) c_BS_LIBARRAY_CFG__use_zsh_setopt=0 ;;
      esac ;;
   0) c_BS_LIBARRAY_CFG__use_zsh_setopt=0 ;;
   *) c_BS_LIBARRAY_CFG__use_zsh_setopt=1 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__use_zsh_setopt'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_MULTIDIGIT_PARAMETER`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_MULTIDIGIT_PARAMETER`](./README.MD#better_scripts_config_no_multidigit_parameter)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - \[Disable]/Enable using only single digit shell
#:   parameters, i.e. `$0` to `$9`.
#: - _OFF_: Use multi-digit shell parameters.
#: - _ON_: Use only single-digit shell parameters.
#: - Multi-digit parameters are faster but may not be
#:   supported by all implementations.
#:
case ${BS_LIBARRAY_CONFIG_NO_MULTIDIGIT_PARAMETER:-${BETTER_SCRIPTS_CONFIG_NO_MULTIDIGIT_PARAMETER:-A}} in
[AD]) case $(
          {
            set 1 2 3 4 5 6 7 8 9 10 11 12
            if test "${10}" -eq 10
            then
              echo 'SUCCESS'
            else
              echo 'FAILED'
            fi
          } 2>&1
      ) in
      'SUCCESS') c_BS_LIBARRAY_CFG__use_multidigit_param=1 ;;
              *) c_BS_LIBARRAY_CFG__use_multidigit_param=0 ;;
      esac ;;
   0) c_BS_LIBARRAY_CFG__use_multidigit_param=1 ;;
   *) c_BS_LIBARRAY_CFG__use_multidigit_param=0 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__use_multidigit_param'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_SHIFT_N`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_SHIFT_N`](./README.MD#better_scripts_config_no_shift_n)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - \[Disable]/Enable using only `shift` and not `shift N`
#:   for multiple parameters.
#: - _OFF_: Use `shift N`.
#: - _ON_: Use only `shift`.
#: - Multi-parameter `shift` is faster but may not be
#:   supported by all implementations
#:
case ${BS_LIBARRAY_CONFIG_NO_SHIFT_N:-${BETTER_SCRIPTS_CONFIG_NO_SHIFT_N:-A}} in
[AD]) case $(
        {
          set 1 2 3 4 5 6 7 8 9 10 11 12
          if shift 10 && test "$1" -eq 11
          then
            echo 'SUCCESS'
          else
            echo 'FAILED'
          fi
        } 2>&1
      ) in
      'SUCCESS') c_BS_LIBARRAY_CFG__use_shift_n=1 ;;
              *) c_BS_LIBARRAY_CFG__use_shift_n=0 ;;
      esac ;;
   0) c_BS_LIBARRAY_CFG__use_shift_n=1 ;;
   *) c_BS_LIBARRAY_CFG__use_shift_n=0 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__use_shift_n'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_DEV_NULL`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_DEV_NULL`](./README.MD#better_scripts_config_no_dev_null)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
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
#. - Capturing output is **not** equivalent to redirection
#.   to `/dev/null` in some cases, specifically, without
#.   using an additional file descriptor it is not possible
#.   to _only_ capture `STDERR`.
#. - An additional subshell is needed here to suppress shell
#.   error messages when `/dev/null` is not accessible.
#.
case ${BS_LIBARRAY_CONFIG_NO_DEV_NULL:-${BETTER_SCRIPTS_CONFIG_NO_DEV_NULL:-A}} in
[AD]) case $( ( echo 'TEST' >/dev/null ) 2>&1 && echo 'SUCCESS') in
      'SUCCESS') c_BS_LIBARRAY_CFG__use_dev_null=1 ;;
              *) c_BS_LIBARRAY_CFG__use_dev_null=0 ;;
      esac ;;
   0) c_BS_LIBARRAY_CFG__use_dev_null=1 ;;
   *) c_BS_LIBARRAY_CFG__use_dev_null=0 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__use_dev_null'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_MBC`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC`](./README.MD#better_scripts_config_shell_supports_mbc)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - Disable/\[Enable] support for multi-byte character
#:   processing within the shell itself.
#: - _OFF_: use fallback code for operations affected.
#: - _ON_:  use internal shell operations.
#: - Default is to run tests for the current shell when a
#:   library is sourced to determine if such support is
#:   present.
#: - See
#:   [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC`](./README.MD#better_scripts_config_shell_supports_mbc)
#:   for details.
#:
case ${BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_MBC:-${BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC:-A}} in
[AD]) case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
      C|POSIX)  c_BS_LIBARRAY_CFG__shell_supports_mbc=0 ;;
            *)  if i_BS_LIBARRAY__utf8_char=$(fn_bs_libarray_print_utf8_fw_A 2>&1)
                then
                  case ${i_BS_LIBARRAY__utf8_char}:${i_BS_LIBARRAY__utf8_char} in
                  [${i_BS_LIBARRAY__utf8_char}]:?) c_BS_LIBARRAY_CFG__shell_supports_mbc=1 ;;
                                                *) c_BS_LIBARRAY_CFG__shell_supports_mbc=0 ;;
                  esac
                else
                  c_BS_LIBARRAY_CFG__shell_supports_mbc=0
                fi
                unset i_BS_LIBARRAY__utf8_char ;;
      esac ;;
   0) c_BS_LIBARRAY_CFG__shell_supports_mbc=0 ;;
   *) c_BS_LIBARRAY_CFG__shell_supports_mbc=1 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__shell_supports_mbc'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](./README.MD#better_scripts_config_shell_supports_portable_glob)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - Disable/\[Enable] glob/wildcard pattern
#:   matching even if the pattern contains known problematic characters.
#: - _OFF_: use fallback code for patterns that contain problem characters.
#: - _ON_:  use shell pattern matching.
#: - Default is to run tests for the current shell when a library is sourced to
#:   determine if the current shell supports these as expected or not.
#: - See
#:   [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](./README.MD#better_scripts_config_shell_supports_portable_glob)
#:   for details.
#:
#---------------------------------------------------------
# SC2295: Expansions inside ${..} need to be quoted
#         separately, otherwise they will match as a
#         pattern.
# EXCEPT: Want globbing to happen here.
# shellcheck disable=SC2295
case ${BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB:-${BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB:-A}} in
[AD]) case $(
        {
          if [ "${c_BS_LIBARRAY_CFG__use_zsh_setopt}" = 1 ]
          then
            setopt  'LOCAL_OPTIONS' 'SH_FILE_EXPANSION' \
                    'SH_GLOB' 'GLOB_SUBST' 'NONOMATCH'
          fi

          i_BS_LIBARRAY_Test='\[a\((t)est*\string?'
          i_BS_LIBARRAY_Glob='\\\[a\\\((t)est\*\\string\?'
          i_BS_LIBARRAY_Test=${i_BS_LIBARRAY_Test##${i_BS_LIBARRAY_Glob}}
          printf '%s\n' "${i_BS_LIBARRAY_Test:-SUCCESS}"
        } 2>&1
      ) in
      'SUCCESS') c_BS_LIBARRAY_CFG__full_glob_support=1 ;;
              *) c_BS_LIBARRAY_CFG__full_glob_support=0 ;;
      esac ;;
   0) c_BS_LIBARRAY_CFG__full_glob_support=0 ;;
   *) c_BS_LIBARRAY_CFG__full_glob_support=1 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__full_glob_support'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_GREP_E`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_GREP_E`](./README.MD#better_scripts_config_no_grep_e)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - \[Disable]/Enable using the non-standard `egrep`
#:   instead of `grep -E`.
#: - _OFF_: Use `grep -E`.
#: - _ON_: Use `egrep`.
#: - While `grep -E` is standard, it is not always available
#:   but in the cases it is not `egrep` often is and
#:   provides the required functionality.
#:
case ${BS_LIBARRAY_CONFIG_NO_GREP_E:-${BETTER_SCRIPTS_CONFIG_NO_GREP_E:-A}} in
[AD]) case $(printf '(TEST*EXTENDED)\n' | grep -E -e '\(TEST[*_%.](EXTENDED|CONTRACTED){1,}\)' 2>&1 || echo 'FAILED') in
      '(TEST*EXTENDED)') c_BS_LIBARRAY_CFG__use_grep_E=1 ;;
                      *) c_BS_LIBARRAY_CFG__use_grep_E=0 ;;
      esac ;;
   0) c_BS_LIBARRAY_CFG__use_grep_E=0 ;;
   *) c_BS_LIBARRAY_CFG__use_grep_E=1 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__use_grep_E'

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
  BS_LIBARRAY_VERSION_MAJOR=2
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
BS_LIBARRAY_VERSION_FULL=$((\
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
BS_LIBARRAY_VERSION=$(
    printf "BetterScripts 'libarray' v%d.%d.%d%s\n" \
           "${BS_LIBARRAY_VERSION_MAJOR}"           \
           "${BS_LIBARRAY_VERSION_MINOR}"           \
           "${BS_LIBARRAY_VERSION_PATCH}"           \
           "${BS_LIBARRAY_VERSION_RELEASE:+-${BS_LIBARRAY_VERSION_RELEASE}}"
  )

fn_bs_libarray_readonly 'BS_LIBARRAY_VERSION'

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
#: - Type:     _FLAG_
#: - Class:    _VARIABLE_
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
#: - Type:     _FLAG_
#: - Class:    _VARIABLE_
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
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
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
0) c_BS_LIBARRAY_CFG__start_index=0 ;;
*) c_BS_LIBARRAY_CFG__start_index=1 ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__start_index'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`
#:
#: - Type:     _TEXT_
#: - Class:    _CONSTANT_
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
    *)  BS_LIBARRAY__ConfigError=;
        : "${BS_LIBARRAY__ConfigError:?'[libarray]: Config Error: BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1 must be an integer greater than 2.'}" ;;
    esac
    c_BS_LIBARRAY_CFG__find_fd_1=${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1} ;;
*)  c_BS_LIBARRAY_CFG__find_fd_1=3 ;;
esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`
#:
#: - Type:     _TEXT_
#: - Class:    _CONSTANT_
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
    *)   BS_LIBARRAY__ConfigError=;
        : "${BS_LIBARRAY__ConfigError:?'[libarray]: Config Error: BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2 must be an integer greater than 2.'}" ;;
    esac
    c_BS_LIBARRAY_CFG__find_fd_2=${BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2} ;;
*)  # FD_2 = FD_1 + 1, but kept in set [3456789] so that 10->3:
    #    - 3   ->  shift to range [0,7]
    #    + 1   ->  increment
    #    % 7   ->  wrap
    #    + 3   ->  shift to range [3,9]
    #
    # FD_2 = (((FD_1 - 3) + 1) % 7 + 3)
    c_BS_LIBARRAY_CFG__find_fd_2=$((( (c_BS_LIBARRAY_CFG__find_fd_1 - 2) % 7) + 3))
esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check
# [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1`](#bs_libarray_config_find_redirect_fd_1)
# is different to
# [`BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2`](#bs_libarray_config_find_redirect_fd_2)
case $((c_BS_LIBARRAY_CFG__find_fd_1 - c_BS_LIBARRAY_CFG__find_fd_2)) in
0)  BS_LIBARRAY__ConfigError=;
    : "${BS_LIBARRAY__ConfigError:?'[libarray]: Config Error: BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_1 and BS_LIBARRAY_CONFIG_FIND_REDIRECT_FD_2 must be different.'}" ;;
esac

fn_bs_libarray_config_constant 'c_BS_LIBARRAY_CFG__find_fd_1' \
                               'c_BS_LIBARRAY_CFG__find_fd_2'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBARRAY_CONFIG_NO_AWK_ARGV`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV`](./README.MD#better_scripts_config_no_awk_argv)
#: - Type:     _FLAG_
#: - Class:    _VARIABLE_
#: - Default:  `0` (Use `awk` `ARGV`)
#: - Disable/\[Enable] using `ARGV` within `awk` - enabling
#:   gives significantly better performance, but is subject
#:   to some limitations.
#: - _OFF_: Use `ARGV` within `awk`.
#: - _ON_: Avoid `ARGV` within `awk`.
#: - When _ON_ `ARGV` will be used whenever appropriate, if
#:   this fails (likely due one of the limitations), the
#:   code for the _OFF_ condition will be used to get the
#:   required results. This comes with a small cost as the
#:   `ARGV` code must first be run and fail (although this
#:   should be relatively fast, it does have an impact).
#: - This is _not_ autodetected as the point is not to test
#:   if `ARGV` is available (it is assumed to be), but
#:   if it should be used for performance reasons. There is
#:   no real way to test this it will be system and data
#:   specific.
#:
#. _IMPLEMENTATION NOTES_
#.
#. - The primary limitation for using `ARGV` is the Command
#.   Line Length limit. As this can be queried using
#.   `getconf ARG_MAX` it would be possible to implement
#.   conditional usage of `ARGV`, however, this is not the
#.   only limitation - the Linux Kernel imposes an
#.   additional limitation `MAX_ARG_STRLEN` which defines
#.   the maximum size of any single argument. Unfortunately
#.   this value is not standard, (far) easier to hit, (far)
#.   harder to deal with, and _not_ queryable. Ultimately,
#.   the Linux version of code this controls would always
#.   likely work the way the current code does, while other
#.   systems might have different possible options.
#.

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### EXTERNAL CONSTANTS
#:
#===========================================================
#===========================================================

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
#: - Passing `BS_LIBARRAY_SH_TO_ARRAY` as the first argument
#:   to the script is not required, however it is useful to
#:   avoid accidentally setting `$0`.
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
    case ${1-} in --) shift ;; esac
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
#. #### `c_BS_LIBARRAY__awk_fn__array_print`
#.
#. - An `awk` code snippet that defines a function that
#.   creates a `libarray.sh` style array value from a
#.   given value.
#. - Array value is output to `STDOUT` as a single array
#.   element.
#.
#. _IMPLEMENTATION NOTES_
#.
#. - `awk` is used in a number of different places where
#.   it performs different tasks, but often requires similar
#.   tools to accomplish these tasks. The easiest way to
#.   avoid code repetition is to have functions defined in
#.   code snippets that can be included in the scripts that
#.   use them (via parameter expansion).
#.
#. ##### `bs_fn_array_print`
#.
#. Print a `libarray.sh` style array value from `awk`.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      bs_fn_array_print(<VALUE>)
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `VALUE` \[in]
#.
#. : Value to convert into an array value.
#. : Can be null.
#. : Can contain any arbitrary text excluding any
#.   embedded `\0` (`<NUL>`) characters.
#.
c_BS_LIBARRAY__awk_fn__array_print="
  function bs_fn_array_print(strValue) {
    gsub(\"'\", \"'\\\\''\", strValue)
    printf(\"'%s' \\\\\n\", strValue)
  }
"

fn_bs_libarray_readonly 'c_BS_LIBARRAY__awk_fn__array_print'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBARRAY__awk_fn__glob_to_ere`
#.
#. - An `awk` code snippet that defines a function that
#.   converts a _Wildcard_ pattern to an
#.   _Extended Regular Expression_ (_ERE_).
#. - There are a number of cases when a _Wildcard_ pattern
#.   will not work as expected - including shell support for
#.   certain characters, and locale issues. This is used
#.   when any of these cases is detected.
#.
#. _IMPLEMENTATION NOTES_
#.
#. - It always seems like converting one form of pattern
#.   matching expression to another form _should_ be
#.   relatively easy, however, there are many pitfalls and
#.   edge cases that cause this not to be true. `awk` and
#.   _ERE_ may seem somewhat like overkill, but alternatives
#.   do not work (e.g. `sed`), or are significantly more
#.   complex and prone to further portability issues (e.g.
#.   processing using the shell). Ultimately `awk` is easier
#.   and safer to do what is required.
#.
#. ##### `bs_fn_glob_to_ere`
#.
#. Convert a _Wildcard_ pattern to an _ERE_.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      <VARIABLE>=bs_fn_glob_to_ere(<WILDCARD>)
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `WILDCARD` \[in]
#.
#. : _Wildcard_ pattern to convert into an _ERE_.
#. : Can be null.
#. : Can contain any arbitrary text excluding any
#.   embedded `\0` (`<NUL>`) characters.
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - While it would seem like this can be written more
#.   simply, it turns out that certain edge cases make that
#.   more challenging than it appears. The most straight-
#.   forward way would be simple iteration over _all_
#.   characters and process each appropriately, however,
#.   `awk` lacks this ability, so `match` is used instead.
#. - The algorithm is:
#.   - find the first character that is "special"
#.   - for `[` characters find the appropriate `]` (dealing
#.     with `[:...:]` style sequences as well as `\` and
#.     escaped `]` characters, while converting `[!...]` to
#.     `[^...]` and `[^...]` to `[\^...]`)
#.   - for `\` characters check for repeated sequences and
#.     copy them appropriately - if `\` escapes a character
#.     ensure it remains escaped.
#.   - convert `*` and `?` to `.*` and `.?` respectively
#.   - escape all other special characters with `\`
#. - _NOTE:_ escaping most characters could also be
#.   written as `[c]`, but this fails for `^` so it is
#.   easier to simply use `\` in all cases.
#. - _NOTE:_ some wildcard sequences that are not normally
#.   possible to use (at least portably) can be used here -
#.   for example, the use of `]` inside `[...]` works here,
#.   but is hard to use as a wildcard pattern.
#. - _NOTE:_ In both wildcard patterns and _ERE_ closing
#.   braces are _only_ special if following an opening
#.   brace and so do not need to be processed.
#. - **WARNING:** Invalid sequences are **NOT** detected.
#.
c_BS_LIBARRAY__awk_fn__glob_to_ere='
  function bs_fn_glob_to_ere(strGlob) {
    strERE = ""

    while (match(strGlob, /[\\.(+{|^$[*?]/)) {
      if (RSTART > 1) {
        strERE  = strERE substr(strGlob, 1, (RSTART - 1))
        strGlob = substr(strGlob, RSTART)
      }

      ch = substr(strGlob, 1, 1)
      if (ch == "[") {
        strGlob = substr(strGlob, 2)
        chNext  = substr(strGlob, 1, 1)
        if (chNext == "!") {
          strERE  = strERE "[^"
          ch      = substr(strGlob, 2, 1)
          strGlob = substr(strGlob, 3)
        } else if (chNext == "^") {
          strERE  = strERE "[\\^"
          ch      = substr(strGlob, 2, 1)
          strGlob = substr(strGlob, 3)
        }

        while (ch && ch != "]") {
          strERE = strERE ch
          if (match(strGlob, /^\[([:.=])[^\]]*\1\]/)) {
            strERE  = strERE substr(strGlob, 1, RLENGTH)
            ch      = substr(strGlob, RLENGTH, 1)
            strGlob = substr(strGlob, (RLENGTH + 1))
          } else {
            chNext = substr(strGlob, 1, 1)
            if (ch == "\\" && (chNext == "]" || chNext == "\\")) {
              strERE  = strERE chNext
              ch      = substr(strGlob, 2, 1)
              strGlob = substr(strGlob, 3)
            } else {
              ch      = chNext
              strGlob = substr(strGlob, 2)
            }
          }
        }

        strERE = strERE "]"
      } else if (ch == "\\") {
        nLength = 1
        if (match(strGlob,/^(\\\\)*[^\\]/)) {
          nLength = RLENGTH - 1
        } else if (match(strGlob,/^(\\\\)*\\[^\\]/)) {
          nLength = RLENGTH
        }
        strERE  = strERE substr(strGlob, 1, nLength)
        strGlob = substr(strGlob, nLength + 1)
      } else if (ch == "*" || ch == "?") {
        strERE  = strERE "." ch
        strGlob = substr(strGlob, 2)
      } else {
        strERE  = strERE "\\" ch
        strGlob = substr(strGlob, 2)
      }
    }

    if (strGlob) {
      strERE = strERE strGlob
    }

    return strERE
  }
'

fn_bs_libarray_readonly 'c_BS_LIBARRAY__awk_fn__glob_to_ere'

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
fn_bs_libarray_error() { ## cSpell:Ignore BS_LA_E_
  BS_LA_E_Caller=${1:?'[libarray::fn_bs_libarray_error]: Internal Error: a caller is required'}

  BS_LIBARRAY_LAST_ERROR=;
  case $# in
  1)  : "${2:?'[libarray::fn_bs_libarray_error]: Internal Error: an error message is required'}" ;;
  2)  BS_LIBARRAY_LAST_ERROR=$2 ;;
  *)  shift
      # NOTE: unset `IFS` == default `IFS`
      #       null  `IFS` == null `IFS`
      case ${IFS-' '} in
      ' '*) BS_LIBARRAY_LAST_ERROR=$* ;;
         *) BS_LIBARRAY_LAST_ERROR=$(printf '%s ' "$@")
            BS_LIBARRAY_LAST_ERROR=${BS_LIBARRAY_LAST_ERROR% } ;;
      esac ;; #<: `case ${IFS-' '} in`
  esac #<: `case $# in`

  # OUTPUT ERROR
  case ${BS_LIBARRAY_CONFIG_QUIET_ERRORS:-${BETTER_SCRIPTS_CONFIG_QUIET_ERRORS:-0}} in
  0)  printf '[libarray::%s]: ERROR: %s\n' \
             "${BS_LA_E_Caller}"            \
             "${BS_LIBARRAY_LAST_ERROR}"   >&2 ;;
  esac

  # ERROR EXCEPTION
  case ${BS_LIBARRAY_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in
  0)  ;;
  *)  BS_LIBARRAY__FatalError=;
      BS_LIBARRAY__ErrorMessage="[libarray::${BS_LA_E_Caller}]: ERROR: ${BS_LIBARRAY_LAST_ERROR}"
      # `zsh`, being it's own special self, does not perform parameter expansion
      # of `word` in `${parameter:?[word]}`, so a workaround is required to
      # make the error message shown. It's not clear how to do this other than
      # to use `eval`, but that opens up a can of worms regarding the message
      # contents - specifically what happens if the message contains special
      # characters. In this regard, `zhs` is useful as it provides a mechanism
      # for quoting parameters, which makes it safe.
      #
      # NOTE: Although shells should ignore the `zsh` branch of the `case` here
      #       some fail to parse it. For now that means the use of two `eval`
      #       statements - the first simply blocks other shells from seeing
      #       the `zsh` specific code.
      #
      # SC2296: Parameter expansions can't start with {. Double check syntax.
      # EXCEPT: The code here is fine in `zsh`, and should be ignored in other
      #         shells.
      # shellcheck disable=SC2296
      case ${ZSH_VERSION:+1} in
      1)  eval 'BS_LIBARRAY__ErrorMessage=${(qq)BS_LIBARRAY__ErrorMessage}'
          eval ": \"\${BS_LIBARRAY__FatalError:?${BS_LIBARRAY__ErrorMessage}}\"" ;;
      *) : "${BS_LIBARRAY__FatalError:?${BS_LIBARRAY__ErrorMessage}}" ;;
      esac ;;
  esac  #<: `case ${BS_LIBARRAY_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in`
} #<: `fn_bs_libarray_error()`

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
fn_bs_libarray_invalid_args() { ## cSpell:Ignore BS_LA_IA_
  BS_LA_IA_Caller=${1:?'[libarray::fn_bs_libarray_invalid_args]: Internal Error: a caller is required'}
  shift
  fn_bs_libarray_error "${BS_LA_IA_Caller}" 'Invalid Arguments:' "$@"
} #<: `fn_bs_libarray_invalid_args()`

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
fn_bs_libarray_expected() { ## cSpell:Ignore BS_LA_Expected_
  BS_LA_Expected_Caller=${1:?'[libarray::fn_bs_libarray_expected]: Internal Error: a caller is required'}
  shift
  BS_LA_Expected_Message=${1:?'[libarray::fn_bs_libarray_expected]: Internal Error: an expected argument is required'}
  shift

  #=========================================================
  #
  #=========================================================
  while : #<: `[ $# -gt 1 ]`
  do
    case $# in
    0)  break ;;
    1)  BS_LA_Expected_Message="${BS_LA_Expected_Message}, and $1"
        break ;;
    *)  BS_LA_Expected_Message="${BS_LA_Expected_Message}, $1"
        shift ;;
    esac
  done #<: `while [ $# -gt 1 ]`

  #=========================================================
  #
  #=========================================================
  fn_bs_libarray_error         \
    "${BS_LA_Expected_Caller}"  \
    "Invalid Arguments: expected ${BS_LA_Expected_Message}"
} #<: `fn_bs_libarray_expected()`

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
fn_bs_libarray_validate_name() { ## cSpell:Ignore BS_LA_VN_
  BS_LA_VN_Caller=${1:?'[libarray::fn_bs_libarray_validate_name]: Internal Error: a caller is required'}
    BS_LA_VN_Name=${2?'[libarray::fn_bs_libarray_validate_name]: Internal Error: a variable name is required'}

  case ${BS_LA_VN_Name:-#} in
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libarray_invalid_args \
      "${BS_LA_VN_Caller}"       \
      "invalid variable name '${BS_LA_VN_Name}'"
    return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libarray_validate_name()`

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
fn_bs_libarray_validate_name_hyphen() { ## cSpell:Ignore BS_LA_VNH_
  BS_LA_VNH_Caller=${1:?'[libarray::fn_bs_libarray_validate_name_hyphen]: Internal Error: a caller is required'}
    BS_LA_VNH_Name=${2?'[libarray::fn_bs_libarray_validate_name_hyphen]: Internal Error: a variable name is required'}

  #=========================================================
  # This command is called for many of the main commands.
  # To avoid an additional command call the test from
  # `fn_bs_libarray_validate_name` is duplicated here
  case ${BS_LA_VNH_Name:-#} in
  -) : ;;
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libarray_invalid_args \
      "${BS_LA_VNH_Caller}"      \
      "invalid variable name '${BS_LA_VNH_Name}'"
    return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libarray_validate_name_hyphen()`

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
#; ### `fn_bs_libarray_get_multidigit_param`
#;
#; Some shells only allow numbered parameters in the single digit range, this
#; provides a work around where needed.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_get_multidigit_param <OUTPUT> <INDEX> [<VALUE>...]
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
fn_bs_libarray_get_multidigit_param() { ## cSpell:Ignore BS_LA_GP_
  BS_LA_GP_refOutput=${1:?'[libarray::fn_bs_libarray_get_multidigit_param]: Internal Error: an output variable is required'}
  shift
  BS_LA_GP_Param=${1:?'[libarray::fn_bs_libarray_get_multidigit_param]: Internal Error: a parameter is required'}
  shift

  #---------------------------------------------------------
  # Index is out-of-bounds, so do not modify anything
  #---------------------------------------------------------
  if [ $# -lt "${BS_LA_GP_Param}" ]
  then
    return
  fi

  #---------------------------------------------------------
  # Loop till single digit index. (No need to check
  # `$# > 0` as the above check ensures it has to be)
  #
  # NOTES: Assumes if no multidigit param support
  #        there is also no `shift N` support.
  #---------------------------------------------------------
  while : #<: `[ "${BS_LA_GP_Param}" -gt 9 ]`
  do
    #> LOOP TEST -------------------------------------------
    case ${#BS_LA_GP_Param} in 1) break;; esac #<: `[ "${BS_LA_GP_Param}" -gt 9 ]`
    #< -----------------------------------------------------

    shift
    BS_LA_GP_Param=$((BS_LA_GP_Param - 1))
  done #<: `[ "${BS_LA_GP_Param}" -gt 9 ]`

  #---------------------------------------------------------
  # SAVE
  #---------------------------------------------------------
  eval "${BS_LA_GP_refOutput}=\${${BS_LA_GP_Param}}"
} #<: `fn_bs_libarray_get_multidigit_param()`

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
#; ### `fn_bs_libarray_awk_run_script`
#;
#; Run an `awk` script against the given array values, using whichever
#; supported method of passing those values to `awk` is expected to perform
#; best.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_awk_run_script <CALLER> <SCRIPT> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `SCRIPT` \[in]
#;
#; : An `awk` code snippet that MUST define a
#;   `bs_fn_main(argArray, argCount)` function.
#; : `bs_fn_main` will be called once `argArray` has
#;   been populated with the given `VALUE` arguments
#;   (indexed `[1, argCount)`), and is expected to
#;   write any required output to `STDOUT`.
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Exit status and any output are entirely determined by `SCRIPT`/
#;   `bs_fn_main` - this command imposes no convention of its own.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - When `awk` `ARGV` is used (the default, see
#.   [`BS_LIBARRAY_CONFIG_NO_AWK_ARGV`](#bs_libarray_config_no_awk_argv)),
#.   `VALUE` arguments are passed directly as `awk` arguments; if this fails
#.   (or `ARGV` use is disabled), values are instead streamed over `STDIN`
#.   length-prefixed so that embedded `<newline>` characters are handled
#.   correctly.
#. - This is written in a way that is somewhat non-obvious and
#.   counter-intuitive - it would seem that a simpler way to deal with this
#.   would be to create a function, say `bs_fn_getargs`, that retrieves passed
#.   args from either `ARGV` or `STDIN` and puts them in an array for `SCRIPT`.
#.   This has significant advantages, including that `SCRIPT` could call
#.   `bs_fn_getargs` where ever it wanted - it would be neater, clearer, and
#.   easier to follow. However, the goal of the use of `ARGV` is performance
#.   and while the standard notes that arrays are passed by reference, it makes
#.   no mention of how an array is copied. The problem, then, is that
#.   `bs_fn_getargs` _MUST_ copy `ARGV` to work as expected, _BUT_ it's
#.   not possible to know how this will occur - it _could_ be implemented much
#.   like a reference and so of no real cost, _or_ it _could_ be a full copy of
#.   the entire array (which could be a significant cost). In order to have the
#.   best performance in all cases the current, slightly odd, implementation
#.   is required.
#. - In `awk`, `ARGV` is _writable_, which _may_ lead to the thought that this
#.   could be implemented by simply populating `ARGV` from `STDIN` when
#.   required (`SCRIPT` would simply always use `ARGV`) - unfortunately this is
#.   not possible as, although, `ARGV` is writable, it is also special - when
#.   data is passed via `STDIN` any values in `ARGV` are assumed to be paths
#.   that should also be read for input. (The use of `ARGV` for arguments alone
#.   is restricted to very specific scripts.)
#. - Arbitrary values passed via `STDIN` to `awk` are possible in numerous ways.
#.   (Recall that `awk` separates input into records and this can not be
#.   disabled, so data containing the record separator must be reconstructed
#.   inside `awk` somehow.) The easiest way is to pass data as a pair of values:
#.   a length, and the data. This allows for multi-line values, along with any
#.   arbitrary data to be passed into `awk` and for `awk` to read the data
#.   easily and correctly as a single value. This is also likely to be the
#.   fastest way to do this, and has no fewer edge cases. (Alternatives may be
#.   faster in some cases, but tend to be more complicated and slower in edge
#.   cases.)
#. - Multi-byte support requires both `awk` **and** `wc` support for the
#.   fallback code. The requirement for `wc` is unlikely significant as `awk`
#.   itself is far less likely to support multi-byte and in this case many more
#.   things in this library will fail to work if given such characters.
#.
#_______________________________________________________________________________
fn_bs_libarray_awk_run_script() {  ## cSpell:Ignore BS_LA_ARS_
  BS_LA_ARS_Caller=${1:?'[libarray::fn_bs_libarray_awk_run_script]: Internal Error: a caller is required'}
  shift
  BS_LA_ARS_Script=${1:?'[libarray::fn_bs_libarray_awk_run_script]: Internal Error: a script is required'}
  shift

  #=========================================================
  # It is very much faster to use `ARGV` to pass values to
  # `awk`, however this may fail for large arrays due to the
  # command line length limitations. As this should be the
  # only reason this fails, and it should fail early in the
  # process of invoking `awk` it is reasonable to try this
  # approach first before falling back on the slower method.
  #
  # In the vast majority of cases this should be sufficient.
  #=========================================================
  case ${BS_LIBARRAY_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBARRAY_CFG__use_dev_null:-0} in
    0:1)
      if  {
            awk "
              ${BS_LA_ARS_Script}"'
              BEGIN {
                bs_fn_main(ARGV, ARGC)
              }
            ' "$@"
          } 2>/dev/null
      then
        return
      fi ;;

    0:0)
      if  BS_LA_ARS_Output=$(
            {
              awk "
                ${BS_LA_ARS_Script}"'
                BEGIN {
                  bs_fn_main(ARGV, ARGC)
                }
              ' "$@"
            } 2>&1
          )
      then
        printf '%s\n' "${BS_LA_ARS_Output}"
        return
      fi ;;

    *) ;;
  esac #<: `case ${BS_LIBARRAY_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBARRAY_CFG__use_dev_null:-0} in`

  #=========================================================
  #
  #=========================================================
  fn_bs_libarray_dbg_msg  \
    "${BS_LA_ARS_Caller}" \
    'Using emulated ARGV for awk'

  #=========================================================
  # NOTE:
  # - Some versions of `awk` do not process values as
  #   numerical **unless** they have had arithmetic
  #   performed upon them - hence the need for `+ 0` in
  #   some locations.
  # - `wc` is required to determine the length outside the
  #   _POSIX_ locale.
  # - The test against the string length is `<` to avoid
  #   an infinite loop - it _should_ be possible to use
  #   `!=`, but this may fail in cases where the current
  #   locale is not correctly supported and would cause an
  #   infinite loop - on balance it was deemed this was
  #   a worse outcome than bad data as it would be far far
  #   harder to diagnose.
  #=========================================================
  {
    printf '%d\n' $#
    case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
      C|POSIX)
        for BS_LA_ARS_Element
        do
          printf  '%d\n%s\n'              \
                  "${#BS_LA_ARS_Element}" \
                  "${BS_LA_ARS_Element}"
        done
      ;;

      *)
        for BS_LA_ARS_Element
        do
          {
            printf '%s' "${BS_LA_ARS_Element}" | wc -m
          } || {
            fn_bs_libarray_error    \
              "${BS_LA_ARS_Caller}" \
              'unknown error while invoking "wc"'
          }
          printf '%s\n' "${BS_LA_ARS_Element}"
        done
      ;;
    esac
  } | {
    awk "
      ${BS_LA_ARS_Script}"'
      BEGIN {
        getline BS_LA_Count
        BS_LA_Count = BS_LA_Count + 1
        for (i = 1; i < BS_LA_Count; ++i) {
          getline nValueLength
          nValueLength = nValueLength + 0
          getline strValue
          while((length(strValue) < nValueLength) && getline) {
            strValue = strValue "\n" $0
          }
          BS_LA_aValues[i] = strValue
        }

        bs_fn_main(BS_LA_aValues, BS_LA_Count)
      }
    '
  }
} #<: `fn_bs_libarray_awk_run_script()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_create`
#;
#; Create an array.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_create <CALLER> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
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
#; _CAVEATS_
#; <!-- - -->
#;
#; - A trailing `<newline>` followed by a `<space>` **MUST** be added by the
#;   caller to terminate any created array. (That is, `echo ' '`.)
#;
#_______________________________________________________________________________
fn_bs_libarray_create() { ## cSpell:Ignore BS_LA_Create_
  BS_LA_Create_Caller=${1:?'[libarray::fn_bs_libarray_create]: Internal Error: a caller is required'}
  shift

  #---------------------------------------------------------
  # Loop through values, creating the array
  #---------------------------------------------------------
  for BS_LA_Create_Value
  do
    array_value "${BS_LA_Create_Value}" || return $?
  done
} #<: `fn_bs_libarray_create()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_create_count`
#;
#; Create an array of a specific length.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_create_count <CALLER> <COUNT> [<VALUE>...]
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
#; _CAVEATS_
#; <!-- - -->
#;
#; - A trailing `<newline>` followed by a `<space>` **MUST** be added by the
#;   caller to terminate any created array. (That is, `echo ' '`.)
#;
#; _NOTES_
#; <!-- -->
#;
#; - If there are more `VALUE` arguments than required, only the first `COUNT`
#;   are used.
#;
#_______________________________________________________________________________
fn_bs_libarray_create_count() { ## cSpell:Ignore BS_LA_CC_
  BS_LA_CC_Caller=${1:?'[libarray::fn_bs_libarray_create_count]: Internal Error: a caller is required'}
  shift
  BS_LA_CC_Count=${1:?'[libarray::fn_bs_libarray_create_count]: Internal Error: a count of values is required'}
  shift

  #---------------------------------------------------------
  # Loop through values, creating the array
  #---------------------------------------------------------
  while : #<: `[ "${BS_LA_CC_Count}" -gt 0 ]`
  do
    #> LOOP TEST -------------------------------------------
    case ${BS_LA_CC_Count} in 0) break;; esac #<: `[ "${BS_LA_CC_Count}" -gt 0 ]`
    #< -----------------------------------------------------

    array_value "$1" || return $?
    shift || return $?
    BS_LA_CC_Count=$((BS_LA_CC_Count - 1))
  done #<: `while [ "${BS_LA_CC_Count}" -gt 0 ]`
} #<: `fn_bs_libarray_create_count()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_create_count_reverse`
#;
#; Create a reverse array of a specific length.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_create_count_reverse <CALLER> <COUNT> [<VALUE>...]
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
#; _CAVEATS_
#; <!-- - -->
#;
#; - A trailing `<newline>` followed by a `<space>` **MUST** be added by the
#;   caller to terminate any created array. (That is, `echo ' '`.)
#;
#; _NOTES_
#; <!-- -->
#;
#; - If there are more `VALUE` arguments than required, only the first `COUNT`
#;   are used. (The first value in a reverse array _may_ therefore _not_ be the
#;   last `VALUE` argument provided.)
#;
#_______________________________________________________________________________
fn_bs_libarray_create_count_reverse() { ## cSpell:Ignore BS_LA_CCR_
  BS_LA_CCR_Caller=${1:?'[libarray::fn_bs_libarray_create_count_reverse]: Internal Error: a caller is required'}
  shift
  BS_LA_CCR_Count=${1:?'[libarray::fn_bs_libarray_create_count_reverse]: Internal Error: a count of values is required'}
  shift

  #---------------------------------------------------------
  # Loop through values backwards, creating the array
  #---------------------------------------------------------
  while : #<: `[ "${BS_LA_CCR_Count}" -gt 0 ]`
  do
    #> LOOP TEST -------------------------------------------
    case ${BS_LA_CCR_Count} in 0) break;; esac #<: `[ "${BS_LA_CCR_Count}" -gt 0 ]`
    #< -----------------------------------------------------

    BS_LA_CCR_Value=;
    case ${c_BS_LIBARRAY_CFG__use_multidigit_param:-0} in
    1)  eval "BS_LA_CCR_Value=\${${BS_LA_CCR_Count}}" ;;
    0)  fn_bs_libarray_get_multidigit_param \
          'BS_LA_CCR_Value'                 \
          "${BS_LA_CCR_Count}"              \
          "$@"                              ;;
    esac || return $?

    array_value "${BS_LA_CCR_Value}" || return $?

    BS_LA_CCR_Count=$((BS_LA_CCR_Count - 1))
  done #<: `while [ "${BS_LA_CCR_Count}" -gt 0 ]`
} #<: `fn_bs_libarray_create_count_reverse()`

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
fn_bs_libarray_process_index() { ## cSpell:Ignore BS_LA_PI_
     BS_LA_PI_Caller=${1:?'[libarray::fn_bs_libarray_process_index]: Internal Error: a caller is required'}
   BS_LA_PI_refIndex=${2:?'[libarray::fn_bs_libarray_process_index]: Internal Error: an index variable is required'}
  BS_LA_PI_ArraySize=${3:?'[libarray::fn_bs_libarray_process_index]: Internal Error: an array size is required'}

  case $# in
  4) BS_LA_PI_MaxIndex=$4 ;;
  *) BS_LA_PI_MaxIndex=${BS_LA_PI_ArraySize} ;;
  esac

  #=========================================================
  # Load
  #=========================================================
  BS_LA_PI_Index=;
  eval "BS_LA_PI_Index=\${${BS_LA_PI_refIndex}-}" || return $?

  #=========================================================
  # Validate Index
  # NOTES: removing any '-' prefix makes testing easier
  #=========================================================
  case ${BS_LA_PI_Index#-}${c_BS_LIBARRAY_CFG__start_index} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Index is '0'; first index is '1'
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    01)
      fn_bs_libarray_invalid_args \
        "${BS_LA_PI_Caller}"      \
        "invalid index '${BS_LA_PI_Index}' (one-based indexes are enabled)"
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Index is literally '-', or otherwise non-numeric
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ?|*[!0123456789]*)
      fn_bs_libarray_invalid_args \
        "${BS_LA_PI_Caller}"      \
        "invalid index '${BS_LA_PI_Index}'"
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case ${BS_LA_PI_Index#-}${c_BS_LIBARRAY_CFG__start_index} in`

  #=========================================================
  # Convert to a zero-based, forward index
  #=========================================================
  case ${BS_LA_PI_Index} in
  -*) BS_LA_PI_RealIndex=$((BS_LA_PI_ArraySize + BS_LA_PI_Index)) ;;            #< Negative Indexes:= Count Backwards
   *) BS_LA_PI_RealIndex=$((BS_LA_PI_Index - c_BS_LIBARRAY_CFG__start_index)) ;; #< Positive Indexes:= Count Forwards
  esac

  #=========================================================
  # Validate range:
  #     0 <= BS_LA_PI_RealIndex <= BS_LA_PI_MaxIndex
  # so both
  #     BS_LA_PI_RealIndex >= 0
  # and
  #     (BS_LA_PI_MaxIndex - BS_LA_PI_RealIndex) >= 0
  # must be true
  #=========================================================
  case ${BS_LA_PI_RealIndex}$((BS_LA_PI_MaxIndex - BS_LA_PI_RealIndex)) in
  *-*)  fn_bs_libarray_invalid_args \
          "${BS_LA_PI_Caller}"      \
          "index '${BS_LA_PI_Index}' is out of range [${c_BS_LIBARRAY_CFG__start_index}, ${BS_LA_PI_MaxIndex}]"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # SAVE
  #=========================================================
  eval "${BS_LA_PI_refIndex}=\${BS_LA_PI_RealIndex}"
} #<: `fn_bs_libarray_process_index()`

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
fn_bs_libarray_process_range() { ## cSpell:Ignore BS_LA_PR_
     BS_LA_PR_Caller=${1:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a caller is required'}
   BS_LA_PR_refStart=${2:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a start output variable is required'}
  BS_LA_PR_refLength=${3:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a length output variable is required'}
      BS_LA_PR_Range=${4:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a range is required'}
   BS_LA_PR_MaxIndex=${5:?'[libarray::fn_bs_libarray_process_range]: Internal Error: a maximum index is required'}

  #=========================================================
  # Ranges can be in multiple formats...
  #=========================================================
  case ${BS_LA_PR_Range} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # '[<START>]:[<END>]'
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *':'*)
      #---------------------------------
      #   '[<START>]:[<END>]'
      #     translates to
      #      [START, END)
      #---------------------------------

      # Process START
      BS_LA_PR_Start=${BS_LA_PR_Range%:*}
      case ${BS_LA_PR_Start:+1} in
      1)  fn_bs_libarray_process_index \
            "${BS_LA_PR_Caller}"       \
            'BS_LA_PR_Start'           \
            "${BS_LA_PR_MaxIndex}"     || return $? ;;
      *)  BS_LA_PR_Start=0 ;;
      esac #<: `case ${BS_LA_PR_Start:+1} in`

      # Process END
      BS_LA_PR_End=${BS_LA_PR_Range#*:}
      case ${BS_LA_PR_End:+1} in
      1)  fn_bs_libarray_process_index \
            "${BS_LA_PR_Caller}"       \
            'BS_LA_PR_End'             \
            $((BS_LA_PR_MaxIndex + 1)) || return $? ;;
      *)  BS_LA_PR_End=${BS_LA_PR_MaxIndex} ;;
      esac #<: `case ${BS_LA_PR_End:+1} in`

      BS_LA_PR_Length=$((BS_LA_PR_End - BS_LA_PR_Start))
    ;; #<: `*':'*)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # '[<START>]#[<LENGTH>]'
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *'#'*)
      #---------------------------------
      #   '[<START>]#[<LENGTH>]'
      #         translates to
      #   [START, START + LENGTH)
      #---------------------------------

      # Process START
      BS_LA_PR_Start=${BS_LA_PR_Range%[#]*}
      case ${BS_LA_PR_Start:+1} in
      1)  fn_bs_libarray_process_index \
            "${BS_LA_PR_Caller}"       \
            'BS_LA_PR_Start'           \
            "${BS_LA_PR_MaxIndex}"     || return $? ;;
      *)  BS_LA_PR_Start=0 ;;
      esac

      # Process LENGTH
      BS_LA_PR_Length=${BS_LA_PR_Range#*[#]}
      case ${BS_LA_PR_Length:+1} in
      1)  case ${BS_LA_PR_Length#-} in
          ''|*[!0123456789]*)
            fn_bs_libarray_invalid_args \
              "${BS_LA_PR_Caller}"      \
              "invalid range length '${BS_LA_PR_Range}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
          esac ;;
      *)  BS_LA_PR_Length=$((BS_LA_PR_MaxIndex - BS_LA_PR_Start)) ;;
      esac

      # Calculate END (for validation)
      BS_LA_PR_End=$((BS_LA_PR_Start + BS_LA_PR_Length))

      # Validate range:
      #    0 <= BS_LA_PR_End <= BS_LA_PR_MaxIndex
      case ${BS_LA_PR_End}$((BS_LA_PR_MaxIndex - BS_LA_PR_End)) in
      *-*)  fn_bs_libarray_invalid_args \
              "${BS_LA_PR_Caller}"      \
              "invalid range length '${BS_LA_PR_Range}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac
    ;; #<: `*'#'*)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  fn_bs_libarray_invalid_args \
          "${BS_LA_PR_Caller}"      \
          "invalid range '${BS_LA_PR_Range}'"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case ${BS_LA_PR_Range} in`

  #=========================================================
  # A zero LENGTH is invalid, while a negative LENGTH means
  # the range is a reversed range where START should point
  # to the highest numbered array element (the range then
  # counts backwards from this element).
  #=========================================================
  case ${BS_LA_PR_Length} in
  0|-0) fn_bs_libarray_invalid_args \
          "${BS_LA_PR_Caller}"      \
          "invalid range '${BS_LA_PR_Range}' (Length: ${BS_LA_PR_Length})"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
    -*) BS_LA_PR_Start=$((BS_LA_PR_Start + 1 + BS_LA_PR_Length)) ;;
  esac #<: `case ${BS_LA_PR_Length} in`

  #=========================================================
  # SAVE
  #=========================================================
  eval " ${BS_LA_PR_refStart}=\${BS_LA_PR_Start}
        ${BS_LA_PR_refLength}=\${BS_LA_PR_Length}"
} #<: `fn_bs_libarray_process_range()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_any_contain_newline`
#;
#; Check if any passed values contain `<newline>` characters.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_any_contain_newline <CALLER> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
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
#; - This is required to determine which version of some algorithms to use as
#;   not all support embedded `<newline>` characters.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - There are a number of ways of implementing this, the most obvious of which
#.   is probably to use `$*` and check if the result contains any `<newline>`
#.   characters. Unfortunately, this relies on the value of `IFS`, which is
#.   likely to be suitable, but _may_ not be. There is also the potential for
#.   `$*` to be a performance issue - depending on how it is implemented by any
#.   given shell _and_ the size of the resulting value (this has not shown up
#.   in testing for multiple shells, but remains possible). The best
#.   alternative, then, is to check each value in turn - iterating over them in
#.   a way that is most likely to be performant regardless of the shell. (In
#.   tests, this was measured as equivalent in performance to `$*` - perhaps
#.   even (very) marginally faster in general and possibly much faster if any
#.   values contain `<newline>` characters due to the possibility of an early
#.   exit.)
#.
#_______________________________________________________________________________
fn_bs_libarray_any_contain_newline() { ## cSpell:Ignore BS_LA_ACN_
  BS_LA_ACN_Caller=${1:?'[libarray::fn_bs_libarray_any_contain_newline]: Internal Error: a caller is required'}
  shift

  #---------------------------------------------------------
  # Loop over all values and check each in turn
  #---------------------------------------------------------
  for BS_LA_ACN_Value
  do
    case ${BS_LA_ACN_Value} in
    *"${c_BS_LIBARRAY__newline}"*) return 0 ;;
    esac
  done

  #---------------------------------------------------------
  # No `<newline>` characters if we got here.
  #---------------------------------------------------------
  return 1
} #<: `fn_bs_libarray_any_contain_newline()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_escape_for_sort`
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
#;     fn_bs_libarray_escape_for_sort <CALLER> <ARRAY>
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
fn_bs_libarray_escape_for_sort() { ## cSpell:Ignore BS_LA_EFS_
    BS_LA_EFS_Caller=${1:?'[libarray::fn_bs_libarray_escape_for_sort]: Internal Error: a caller is required'}
  BS_LA_EFS_refArray=${2:?'[libarray::fn_bs_libarray_escape_for_sort]: Internal Error: an array variable name is required'}

  #=========================================================
  # Unpack...
  #=========================================================
  eval "BS_LA_EFS_Array=\${${BS_LA_EFS_refArray}-}"        || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_EFS_Array?} && shift" || return $?

  #=========================================================
  # Escape the values (to standard out)...
  #=========================================================
  for BS_LA_EFS_Value
  do
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Processing only when required can have a significant
    # performance impact.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${BS_LA_EFS_Value} in
      #-----------------------------------------------------
      # NEEDS ESCAPED
      #-----------------------------------------------------
      *\\*|*"${c_BS_LIBARRAY__newline}"*)
        # By default `sed` acts on individual lines, however
        # this can be changed with the `N` directive which
        # reads another line and appends it to the pattern
        # space delimited by a literal `<newline>`
        # character. The `sed` address `$` matches the end
        # of input, here this means the pattern space holds
        # everything from `BS_LA_EFS_Value`.
        {
          printf '%s\n' "${BS_LA_EFS_Value}"
        } | {
          sed -e ':LOOP
                    $!N
                    $!b LOOP
                  s/\\/\\\\/g
                  s/\n/ \\n/g'
        }
      ;;

      #-----------------------------------------------------
      # FINE AS IS
      #-----------------------------------------------------
      *) printf '%s\n' "${BS_LA_EFS_Value}" ;;
    esac #<: `case ${BS_LA_EFS_Value} in`
  done #<: `for BS_LA_EFS_Value`
} #<: `fn_bs_libarray_escape_for_sort()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_sanitize_sed_bre`
#;
#; Escape a ["Basic Regular Expression"][posix_bre] such that it can be safely
#; used in a `sed` script.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_sanitize_sed_bre <BRE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `BRE` \[in]
#;
#; : A _POSIX.1_ ["Basic Regular Expression"][posix_bre].
#; : Any `/` (`<slash>`) or `<newline>` characters will be
#;   escaped - no other characters will be modified.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - If `BRE` ends with a `<newline>` character, the caller must take care that
#;   this is not lost.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The escaped `BRE` is written to `STDOUT`.
#; - It is expected that the caller has determined that escaping is required -
#;   this command always processes values.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - There are only two characters that need to be handled here: `<newline>`
#.   characters and `/` (`<slash>`) characters. `<newline>` characters need
#.   escaped as some implementations of `sed` do not support a literal
#.   `<newline>` character as part of a _BRE_, although they _do_ as
#.   replacements (if properly escaped). `<slash>` characters need escaped as
#.   they are used to demark the _BRE_ in the `sed` script, and while it is
#.   supposed to be possible to use alternative characters for this, not all
#.   versions of `sed` support alternative characters in all cases. (Notably,
#.   Solaris 11 has a version of `sed` that allows alternative characters for
#.   the `s/.../.../` function, but not for the `/.../` function.) In both cases
#.   the escaped value seems to be highly portable.
#.
#_______________________________________________________________________________
fn_bs_libarray_sanitize_sed_bre() { ## cSpell:Ignore BS_LA_SSBRE_
  BS_LA_SSBRE_BRE=${1?'[libarray::fn_bs_libarray_sanitize_sed_bre]: Internal Error: a BRE is required'}

  #=========================================================
  # Some implementations of `sed` do not support general
  # usage of `*` (`<asterisk>`) or interval patterns (i.e.
  # `{N[,[M]]}`) - restricting them to use with either a
  # single character _or_ a back reference.
  #
  # In this case it means the expression to match unescaped
  # `/` (`<slash>`) characters can not be (portably) written
  # in the most obvious way, namely `\([^\\]\(\\\\\)*\)/` -
  # however, this can be converted to a more portable
  # alternative using multiple capture groups and back
  # references: `\([^\\]\)\(\\\\\)\(\2*\)/`. Note that this
  # needs paired with a version without `\(\\\\\)` to
  # completely replace the previous expression.
  #
  # This is likely to be marginally less performant in the
  # common case, but it's unlikely to be noticeable.
  #=========================================================
  {
    printf '%s\n' "${BS_LA_SSBRE_BRE}"
  } | {
    sed -e '
        :LOOP
          $!N
          $!b LOOP
        s|\n|\\n|g
        s|\([^\\]\)\(\\\\\)\(\2*\)/|\1\2\3\\/|g
        s|\([^\\]\)/|\1\\/|g
        s|^/|\\/|
      '
  }
} #<: `fn_bs_libarray_sanitize_sed_bre()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_cmp_glob`
#;
#; Compare a value with a shell pattern (aka glob) expression.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_cmp_glob <CALLER> <OPERATOR> <VALUE> <GLOB>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `VALUE` \[in]
#;
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `GLOB` \[in]
#;
#; : Shell ["Pattern Matching Notation"][posix_glob] value.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all characters can be used portably._
#; - The locale used is that of the shell as invoked -
#;   _it is **not** possible to change the locale of a running shell_.
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#; _NOTES_
#; <!-- -->
#;
#; - Shell ["Pattern Matching Notation"][posix_glob] are commonly called "globs"
#;   or "wildcards", and are a simple way of matching patterns in values that is
#;   most commonly used when dealing with file names (it is also often referred
#;   to explicitly as such), or with `case` matches (although the `case` syntax
#;   is slightly extended from other uses).
#; - Exit status is dependent on `OPERATOR`: `~` a success status indicates a
#;   match, while for `!~` a success status indicates no match.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - The most obvious method for matching a value against a glob is the `case`
#.   statement: `case ${Value} in ${Pattern})...`. Unfortunately, this also
#.   turns out to be one of the least portable ways to do this, with problems
#.   handling `(`, `)`, `|`, and `\` and possibly more. In some cases these can
#.   be handled portably, while in others it seems impossible to do
#.   so.[^case_glob] Parameter Expansion avoids several of these issues, but
#.   continues to have problems with `\`.
#. - [`autoconf` docs][autoconf_portable] mention that `pdksh` does not properly
#.   handle parameter expansion of some forms, however the example sited in the
#.   docs appears to have no issues on `pdksh` versions available on modern
#.   systems. (`pdksh` was last properly updated in 1999, the version sited in
#.   the `autoconf` docs is `5.2.14` while the latest version appears to be
#.   `5.2.14.2` - but it is not clear where this version comes from nor what
#.   changes might be present since the last version.) It is assumed, therefore
#.   this issue is historical, and is ignored.
#.
#. [^case_glob]: For some shells the characters `(` and/or `)` cause a parsing
#.               error. With `|`, some shells treat this as the normal `case`
#.               special alternation operator, while for others it is a literal
#.               `|` character - for those where it is an operator, it is not
#.               always easy to escape the character, and in either case it is
#.               not possible to use the character portably.
#.
#_______________________________________________________________________________
fn_bs_libarray_cmp_glob() { ## cSpell:Ignore BS_LA_CmpGlob_
  BS_LA_CmpGlob_Caller=${1:?'[libarray::fn_bs_libarray_cmp_glob]: Internal Error: a caller is required'}
      BS_LA_CmpGlob_Op=${2:?'[libarray::fn_bs_libarray_cmp_glob]: Internal Error: an operator is required'}
    BS_LA_CmpGlob_Expr=${3?'[libarray::fn_bs_libarray_cmp_glob]: Internal Error: an expression is required'}
   BS_LA_CmpGlob_Value=${4?'[libarray::fn_bs_libarray_cmp_glob]: Internal Error: a value is required'}

  #=========================================================
  # The most portable way to test for a glob match is using
  # parameter expansion. The use of "longest match" syntax
  # (i.e. `${Parameter##[word]}`) rather than the (perhaps
  # more obvious) "shortest match" syntax (i.e.
  # `${Parameter#[word]}`) is to avoid issues with
  # some shells which do not properly handle the latter if
  # the pattern starts with `#`.
  #=========================================================
  # SC2295: Expansions inside ${..} need to be quoted
  #         separately, otherwise they will match as a
  #         pattern.
  # EXCEPT: Want globbing to happen here.
  # shellcheck disable=SC2295
  BS_LA_CmpGlob_Match=${BS_LA_CmpGlob_Value##${BS_LA_CmpGlob_Expr}}

  #=========================================================
  # If the glob matched the result will be an empty value,
  # if the value was empty to begin with, it is always
  # considered a non-match.
  #=========================================================
  case ${BS_LA_CmpGlob_Op}:${BS_LA_CmpGlob_Value:+1}:${BS_LA_CmpGlob_Match:+1} in
  '~:1:'|'!~:1:1') return 0 ;;
                *) return 1 ;;
  esac
} #<: `fn_bs_libarray_cmp_glob()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_cmp_sed`
#;
#; Test if a value matches a ["Basic Regular Expression" (_BRE_)][posix_bre]
#; without generating any output.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_cmp_sed <CALLER> <OPERATOR> <VALUE> <BRE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
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
#; : _MUST_ **not** contain literal `<newline>` characters
#;   or unescaped `/` (`<slash>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _BRE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - There are multiple _POSIX.1_ specified utilities that support _BRE_ (e.g.
#.   `expr`, `grep`, `sed`, etc). However, not all of these are suitable for
#.   use here; `grep`, for example, can't make a match that may span
#.   multiple lines. While this is not necessarily an issue in most cases
#.   it is not easy to detect when such a use is intended, instead the
#.   result would simply be incorrect.
#.
#_______________________________________________________________________________
fn_bs_libarray_cmp_sed() { ## cSpell:Ignore BS_LA_CmpSed_
  BS_LA_CmpSed_Caller=${1:?'[libarray::fn_bs_libarray_cmp_sed]: Internal Error: a caller is required'}
      BS_LA_CmpSed_Op=${2:?'[libarray::fn_bs_libarray_cmp_sed]: Internal Error: an operator is required'}
    BS_LA_CmpSed_Expr=${3?'[libarray::fn_bs_libarray_cmp_sed]: Internal Error: an expression is required'}
   BS_LA_CmpSed_Value=${4?'[libarray::fn_bs_libarray_cmp_sed]: Internal Error: a value is required'}

  #=========================================================
  # The use of the `i\` function in `sed` has two purposes
  # here: firstly, it handles the edge case when the value
  # contains only `<newline>` characters (which would
  # otherwise) be stripped by the shell; secondly, it
  # _may_ be more efficient in some shells - if the value
  # being tested is large, the shell will allocate the
  # output accordingly, but since we only need to know if
  # a match occurred we can use a smaller string
  # potentially avoiding the need for the shell to do a
  # large allocation that's not needed.
  #=========================================================
  BS_LA_CmpSed_Match=$(
      {
        printf '%s\n' "${BS_LA_CmpSed_Value}"
      } | {
        sed -n -e '
          :LOOP
            $!N
            $!b LOOP
          /'"${BS_LA_CmpSed_Expr}"'/i\
Matched'
      }
    ) || return $?

  #=========================================================
  # Success is dependent on both a match
  # being made _and_ the operator used.
  #=========================================================
  case ${BS_LA_CmpSed_Op}:${BS_LA_CmpSed_Match:+1} in
   '~:1'|'!~:') return 0 ;;
             *) return 1 ;;
  esac
} #<: `fn_bs_libarray_cmp_sed()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_remove_by_glob`
#;
#; Create a new array by filtering out all the values that match the given shell
#; pattern (aka glob) expression.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_remove_by_glob <CALLER> <OPERATOR> <GLOB> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `GLOB` \[in]
#;
#; : Shell ["Pattern Matching Notation"][posix_glob] value.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - See [`fn_bs_libarray_cmp_glob`](#fn_bs_libarray_cmp_glob).
#;
#_______________________________________________________________________________
fn_bs_libarray_remove_by_glob() {  ## cSpell:Ignore BS_LA_RBG_
  BS_LA_RBG_Caller=${1:?'[libarray::fn_bs_libarray_remove_by_glob]: Internal Error: a caller is required'}
  shift
  BS_LA_RBG_Op=${1:?'[libarray::fn_bs_libarray_remove_by_glob]: Internal Error: an operator is required'}
  shift
  BS_LA_RBG_Expr=${1?'[libarray::fn_bs_libarray_remove_by_glob]: Internal Error: an expression is required'}
  shift

  #=========================================================
  #
  #=========================================================
  BS_LA_RBG_Fast=0
  case ${c_BS_LIBARRAY_CFG__full_glob_support}:${c_BS_LIBARRAY_CFG__shell_supports_mbc}:${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    1:1:*|1:0:C|1:0:POSIX)
      BS_LA_RBG_Fast=1 ;;

    0:1:*|0:0:C|0:0:POSIX)
      case ${BS_LA_RBG_Expr} in
      *[\\\(\)]*) BS_LA_RBG_Fast=0 ;;
               *) BS_LA_RBG_Fast=1 ;;
      esac ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_RBG_Fast} in
    1)
      #-----------------------------------------------------
      # As ever, `zsh` needs some settings changed or it
      # will always fail.
      #-----------------------------------------------------
      case ${c_BS_LIBARRAY_CFG__use_zsh_setopt} in
      1) setopt 'LOCAL_OPTIONS' 'SH_FILE_EXPANSION' 'SH_GLOB' \
                'GLOB_SUBST'    'NONOMATCH'                   ;; ## cSpell:Ignore NONOMATCH
      esac

      #-----------------------------------------------------
      # Loop through the values, including only those where
      # the glob match is _false_.
      #-----------------------------------------------------
      BS_LA_RBG_HaveElements=0
      for BS_LA_RBG_Value
      do
        {
          fn_bs_libarray_cmp_glob \
            "${BS_LA_RBG_Caller}" \
            "${BS_LA_RBG_Op}"     \
            "${BS_LA_RBG_Expr}"   \
            "${BS_LA_RBG_Value}"
        } || {
          array_value "${BS_LA_RBG_Value}" || return $?
          BS_LA_RBG_HaveElements=1
        }
      done #<: `for BS_LA_RBG_Value`

      #-----------------------------------------------------
      # Trailing whitespace is always required (if there are
      # any elements)
      #-----------------------------------------------------
      case ${BS_LA_RBG_HaveElements} in 1) echo ' ' ;; esac
    ;;

    0)
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libarray_dbg_msg  \
        "${BS_LA_RBG_Caller}" \
        "Using emulated globs (expression '${BS_LA_RBG_Expr}')"

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libarray_awk_run_script \
        "${BS_LA_RBG_Caller}"       \
        " ${c_BS_LIBARRAY__awk_fn__glob_to_ere}
          ${c_BS_LIBARRAY__awk_fn__array_print}"'
          function bs_fn_main(argArray, argCount) {
            BS_LA_ERE = bs_fn_glob_to_ere(argArray[1])

            BS_LA_HaveElements = 0
            for (i = 2; i < argCount; ++i) {
              if (! (argArray[i] '"${BS_LA_RBG_Op}"' BS_LA_ERE)) {
                bs_fn_array_print(argArray[i])
                BS_LA_HaveElements = 1
              }
            }

            if (BS_LA_HaveElements == 1) {
              print " "
            }
          }
        '                   \
        "${BS_LA_RBG_Expr}" \
        "$@"
    ;;
  esac
} #<: `fn_bs_libarray_remove_by_glob()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_remove_by_grep`
#;
#; Create a new array by filtering out values using `grep` with either a
#; ["Basic Regular Expression" (_BRE_)][posix_bre] or an
#; ["Extended Regular Expressions" (_ERE_)][posix_ere].
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_remove_by_grep <CALLER> <MODE> <OPERATOR> <REGEX> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `MODE` \[in]
#;
#; : Either `-G` or `-E` indicating whether `REGEX` is a
#;   _BRE_ (`-G`) or an _ERE_ (`-E`).
#; : _NOT_ tested for correctness.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `REGEX` \[in]
#;
#; : A ["Basic Regular Expressions" (_BRE_)][posix_bre] if
#;   `MODE` is `-G`, an
#;   ["Extended Regular Expressions" (_ERE_)][posix_ere]
#;   otherwise.
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - Can match array values that _contain_ `<newline>` characters, **but** can
#;   _not_ match `<newline>` characters themselves. (That is, it is **not**
#;   possible to match entire entries than span more than a single line - only
#;   single lines can be matched.)
#; - Performance is significantly increased when array values do _not_ contain
#;   `<newline>` characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - `MODE` is assumed to be `-G` unless specified as `-E`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Some platforms do not support `grep -E` but support the non-standard
#.   `egrep`. This allows for either case.
#.
#_______________________________________________________________________________
fn_bs_libarray_remove_by_grep() {  ## cSpell:Ignore BS_LA_RBG_
  BS_LA_RBG_Caller=${1:?'[libarray::fn_bs_libarray_remove_by_grep]: Internal Error: a caller is required'}
  shift
  BS_LA_RBG_Mode=${1?'[libarray::fn_bs_libarray_remove_by_grep]: Internal Error: a mode is required'}
  shift
  BS_LA_RBG_Op=${1:?'[libarray::fn_bs_libarray_remove_by_grep]: Internal Error: a value is required'}
  shift
  BS_LA_RBG_Expr=${1?'[libarray::fn_bs_libarray_remove_by_grep]: Internal Error: an expression is required'}
  shift

  #=========================================================
  # It _should_ be possible to use a single parameter for
  # the whole command to be used, unfortunately, this
  # relies on the value of `IFS` - additionally some shells
  # (e.g. `osh`) do not seem to properly split the value
  # regardless of `IFS`.
  #=========================================================
  case ${c_BS_LIBARRAY_CFG__use_grep_E}:${BS_LA_RBG_Mode} in
  0':-E') BS_LA_RBG_grep_cmd='egrep'; BS_LA_RBG_grep_args=;    ;;
  1':-E') BS_LA_RBG_grep_cmd='grep';  BS_LA_RBG_grep_args='E'; ;;
       *) BS_LA_RBG_grep_cmd='grep';  BS_LA_RBG_grep_args=;    ;;
  esac

  #=========================================================
  # If the array values contain `<newline>` characters,
  # `grep` has to be used to check each value in turn -
  # there is no real way to check them all at once,
  # otherwise all the values can be checked in a single
  # call.
  #=========================================================
  if fn_bs_libarray_any_contain_newline "${BS_LA_RBG_Caller}" "$@"
  then
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BS_LA_RBB_HaveElements=0
    for BS_LA_RBB_Value
    do
      if  BS_LA_RBB_Ignored=$(
              {
                printf '%s\n' "${BS_LA_RBB_Value}"
              } | {
                ${BS_LA_RBG_grep_cmd} \
                  ${BS_LA_RBG_grep_args:+"-${BS_LA_RBG_grep_args}"} \
                  "${BS_LA_RBG_Expr}"
              }
            )
      then
        case ${BS_LA_RBG_Op} in  '~') continue ;; esac
      else
        case ${BS_LA_RBG_Op} in '!~') continue ;; esac
      fi

      array_value "${BS_LA_RBB_Value}" || return $?
      BS_LA_RBB_HaveElements=1
    done #<: `for BS_LA_RBB_Value`

    #-------------------------------------------------------
    # Trailing whitespace is always required (if there are
    # any elements)
    #-------------------------------------------------------
    case ${BS_LA_RBB_HaveElements} in 1) echo ' ' ;; esac
  else #<: `if fn_bs_libarray_any_contain_newline`
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${BS_LA_RBG_Op} in
    '~') BS_LA_RBG_grep_args="${BS_LA_RBG_grep_args-}v" ;;
    esac

    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    {
      printf '%s\n' "$@"
    } | {
      ${BS_LA_RBG_grep_cmd} \
        ${BS_LA_RBG_grep_args:+"-${BS_LA_RBG_grep_args}"} \
        "${BS_LA_RBG_Expr}"
    } | {
      sed -e "s/'/'\\\\''/g
              s/^/'/
              s/\$/' \\\\/"
      echo ' '  #< NOTE: This adds whitespace even if no
                #< values were found, this is difficult to
                #< deal with here, so is dealt with by
                #< the caller
    }
  fi #<: `if fn_bs_libarray_any_contain_newline`
} #<: `fn_bs_libarray_remove_by_grep()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_remove_by_sed`
#;
#; Create a new array by filtering out values using a
#; ["Basic Regular Expressions" (_BRE_)][posix_bre].
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_remove_by_sed <CALLER> <OPERATOR> <BRE> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `BRE` \[in]
#;
#; : A ["Basic Regular Expressions" (_BRE_)][posix_bre].
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _BRE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - While `expr` can also be utilized for this purpose, it suffers from
#.   significant issues that make it hard to properly utilize. While some
#.   platforms (e.g. Solaris 11) have a more capable `expr` than `sed`, in
#.   general `sed` is the safer choice.
#.
#_______________________________________________________________________________
fn_bs_libarray_remove_by_sed() {  ## cSpell:Ignore BS_LA_RBS_
  BS_LA_RBS_Caller=${1:?'[libarray::fn_bs_libarray_remove_by_sed]: Internal Error: a caller is required'}
  shift
  BS_LA_RBS_Op=${1:?'[libarray::fn_bs_libarray_remove_by_sed]: Internal Error: a value is required'}
  shift
  BS_LA_RBS_Expr=${1?'[libarray::fn_bs_libarray_remove_by_sed]: Internal Error: an expression is required'}
  shift

  #=========================================================
  # The BRE is going to be used as part of a `sed` script,
  # so literal `<newline>` characters along with `/`
  # (`<slash>`) characters need to be escaped, or they will
  # cause errors.
  #
  # NOTE: Although `sed` is supposed to support characters
  #       other than `/` (`<slash>`) for "functions", some
  #       implementations do not, so it's easier to always
  #       use `/` (`<slash>`) than try to use something
  #       else in cases when the BRE contains it.
  #=========================================================
  case ${BS_LA_RBS_Expr} in
  *'/'*|*"${c_BS_LIBARRAY__newline}"*)
    BS_LA_RBS_Expr=$(fn_bs_libarray_sanitize_sed_bre "${BS_LA_RBS_Expr}_") || return $?
    BS_LA_RBS_Expr=${BS_LA_RBS_Expr%_} ;;
  esac

  #=========================================================
  # Iterate and keep only the required values.
  #=========================================================
  BS_LA_RBS_HaveElements=0
  for BS_LA_RBS_Value
  do
    {
      fn_bs_libarray_cmp_sed  \
        "${BS_LA_RBS_Caller}" \
        "${BS_LA_RBS_Op}"     \
        "${BS_LA_RBS_Expr}"   \
        "${BS_LA_RBS_Value}"
    } || {
      array_value "${BS_LA_RBS_Value}" || return $?
      BS_LA_RBS_HaveElements=1
    }
  done #<: `for BS_LA_RBS_Value`

  #=========================================================
  # Trailing whitespace is always required (if there are
  # any elements)
  #=========================================================
  case ${BS_LA_RBS_HaveElements} in 1) echo ' ' ;; esac
} #<: `fn_bs_libarray_remove_by_sed()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_remove_by_awk`
#;
#; Create a new array by filtering out values using an
#;  ["Extended Regular Expression" (_ERE_)][posix_ere].
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_remove_by_awk <CALLER> <OPERATOR> <ERE> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `ERE` \[in]
#;
#; : An ["Extended Regular Expression" (_ERE_)][posix_ere].
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _ERE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#_______________________________________________________________________________
fn_bs_libarray_remove_by_awk() {  ## cSpell:Ignore BS_LA_RBA_
  BS_LA_RBA_Caller=${1:?'[libarray::fn_bs_libarray_remove_by_awk]: Internal Error: a caller is required'}
  shift
  BS_LA_RBA_Op=${1:?'[libarray::fn_bs_libarray_remove_by_awk]: Internal Error: an operator is required'}
  shift
  BS_LA_RBA_Expr=${1?'[libarray::fn_bs_libarray_remove_by_awk]: Internal Error: an expression is required'}
  shift

  #=========================================================
  #
  #=========================================================
  fn_bs_libarray_awk_run_script \
    "${BS_LA_RBA_Caller}"       \
    "${c_BS_LIBARRAY__awk_fn__array_print}"'
      function bs_fn_main(argArray, argCount) {
        BS_LA_Expression   = argArray[1]
        BS_LA_HaveElements = 0
        for (i = 2; i < argCount; ++i) {
          if (! (argArray[i] '"${BS_LA_RBA_Op}"' BS_LA_Expression)) {
            bs_fn_array_print(argArray[i])
            BS_LA_HaveElements = 1
          }
        }

        if (BS_LA_HaveElements == 1) {
          print " "
        }
      }
    '                   \
    "${BS_LA_RBA_Expr}" \
    "$@"
} #<: `fn_bs_libarray_remove_by_awk()`

#_______________________________________________________________________________
## cSpell:Ignore notlike notmatch matchex notmatchex matchbre matchere
## cSpell:IgnoreRegExp -\w*[be]re\w*\b
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_remove_by_filter`
#;
#; Create an array excluding any values that match a filter.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_remove_by_filter <CALLER> <PRIMARY> <EXPRESSION> [<VALUE>...]
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
#; : A test operator used with EXPRESSION.
#; : MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
#;   `-lt`, `-le`, `-like`, `-notlike`, `-bre`, `-notbre`,
#;   `-ere`, or `-notere`.
#;
#; `EXPRESSION` \[in]
#;
#; : Value to use with `PRIMARY`.
#; : Can be null.
#; : _EXPECTS_:
#;   - a _string_ when `PRIMARY` is `=`, or `!=`
#;   - a _number_ when `PRIMARY` is `-eq`, `-ne`,
#;     `-gt`, `-ge`,  `-lt`, or `-le`
#;   - a _pattern_ when `PRIMARY` is `-like`, or `-notlike`.
#;   - a _BRE_ when `PRIMARY` is `-bre`, or `-notbre`.
#;   - an _ERE_ when `PRIMARY` is `-ere`, or `-notere`.
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all patterns, _BRE_, or _ERE_ can be used portably.
#; - The `-like`/`-notlike` operators use the locale of the shell as invoked -
#;   _it is **not** possible to change the locale of a running shell_.
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#; _NOTES_
#; <!-- -->
#;
#; - Several aliases are provided: `-[not]match` and `-[not]matchbre` for
#;   `-[not]bre`; `-[not]matchex` and `-[not]matchere` for
#;   `-[not]ere`. Additionally, `=~` for `-ere` and `!~` for `-notere`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Primarily a helper for removing elements from an existing array, meaning
#.   the logic can be a little confusing as it is often inverted from that
#.   which might be expected.
#.
#_______________________________________________________________________________
fn_bs_libarray_remove_by_filter() { ## cSpell:Ignore BS_LA_RBF_
  BS_LA_RBF_Caller=${1:?'[libarray::fn_bs_libarray_remove_by_filter]: Internal Error: a caller is required'}
  shift
  BS_LA_RBF_Primary=${1:?'[libarray::fn_bs_libarray_remove_by_filter]: Internal Error: a primary is required'}
  shift
  BS_LA_RBF_Expr=${1?'[libarray::fn_bs_libarray_remove_by_filter]: Internal Error: an expression is required'}
  shift

  : "${1?'[libarray::fn_bs_libarray_remove_by_filter]: Internal Error: one or more array values are required'}"

  #=========================================================
  # Keep a copy of the input primary for error messages.
  #=========================================================
  BS_LA_RBF_TestPrimary=${BS_LA_RBF_Primary}

  #=========================================================
  # Pre-match some common elements and remove them from the
  # primary:
  #
  # - `-not<PRIMARY>` becomes `-<PRIMARY>`
  # - `=~` becomes `-ere`
  # - `!~` becomes `-ere`
  #
  # A flag is used to indicate the operator logic: `~` means
  # a match is being looked for, `!~` means the opposite,
  # and is only used for some primaries.
  #
  # Doing this significantly simplifies the subsequent code,
  # but leaves open the potential for invalid primaries
  # being specified. Most of these cases are handled later,
  # but some are simply ignored. (To handle _all_ cases
  # further complicates the code with little benefits - of
  # note, the trailing specifiers `:s` and `:m` are ignored
  # with `-[not]like` - there is no special case code for
  # this combination, but semantically it makes sense for
  # such operators them to exist.)
  #=========================================================
  BS_LA_RBF_Op='~'
  case ${BS_LA_RBF_TestPrimary} in
    '-not'*)
      BS_LA_RBF_TestPrimary=-${BS_LA_RBF_TestPrimary#'-not'}
      BS_LA_RBF_Op='!~'
    ;;

    '=~')
      BS_LA_RBF_TestPrimary='-ere'
      BS_LA_RBF_Op='~'
    ;;

    '!~')
      BS_LA_RBF_TestPrimary='-ere'
      BS_LA_RBF_Op='!~'
    ;;
  esac #<: `case ${BS_LA_RBF_TestPrimary} in`

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_RBF_TestPrimary%:[sm]} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # GLOB
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-like')
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libarray_remove_by_glob \
        "${BS_LA_RBF_Caller}"       \
        "${BS_LA_RBF_Op}"           \
        "${BS_LA_RBF_Expr}"         \
        "$@"                        || return $?
    ;; #<: `'-like')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # BRE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-match'|'-matchbre'|'-bre')
      case ${BS_LA_RBF_TestPrimary} in
        #...............................
        # SINGLE LINE MODE
        #...............................
        *':s')
          fn_bs_libarray_remove_by_grep \
            "${BS_LA_RBF_Caller}"       \
            '-G'                        \
            "${BS_LA_RBF_Op}"           \
            "${BS_LA_RBF_Expr}"         \
            "$@"                        || return $? ;;

        #...............................
        # MULTI-LINE MODE
        #...............................
        *)
          fn_bs_libarray_remove_by_sed \
            "${BS_LA_RBF_Caller}"      \
            "${BS_LA_RBF_Op}"          \
            "${BS_LA_RBF_Expr}"        \
            "$@"                       || return $? ;;
      esac #<: `case ${BS_LA_RBF_TestPrimary} in`
    ;; #<: `'-match'|'-matchbre'|'-bre')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ERE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-matchex'|'-matchere'|'-ere')
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      case ${BS_LA_RBF_TestPrimary} in
        #...............................
        # SINGLE LINE MODE
        #...............................
        *':s')
          fn_bs_libarray_remove_by_grep \
            "${BS_LA_RBF_Caller}"       \
            '-E'                        \
            "${BS_LA_RBF_Op}"           \
            "${BS_LA_RBF_Expr}"         \
            "$@"                        || return $? ;;

        #...............................
        # MULTI-LINE MODE
        #...............................
        *)
          fn_bs_libarray_remove_by_awk \
            "${BS_LA_RBF_Caller}"      \
            "${BS_LA_RBF_Op}"          \
            "${BS_LA_RBF_Expr}"        \
            "$@"                       || return $? ;;
      esac #<: `case ${BS_LA_FI_TestPrimary} in`
    ;; #<: `'-matchex'|'-matchere'|'-ere')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # STRING EQUALITY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '=')
      case ${BS_LA_RBF_TestPrimary} in
        #---------------------------------------------------
        #
        #---------------------------------------------------
        "${BS_LA_RBF_Primary}")
          BS_LA_RBF_HaveElements=0
          for BS_LA_RBF_Value
          do
            case ${BS_LA_RBF_Value} in
            "${BS_LA_RBF_Expr}") continue ;;
            esac
            array_value "${BS_LA_RBF_Value}" || return $?
            BS_LA_RBF_HaveElements=1
          done #<: `for BS_LA_RBF_Value

          #-----------------------------
          # Trailing whitespace is
          # always required (if there
          # are any elements)
          #-----------------------------
          case ${BS_LA_RBF_HaveElements} in 1) echo ' ' ;; esac
        ;; #<: `"${BS_LA_RBF_Primary}")`

        #---------------------------------------------------
        # Invalid Primary (e.g. `=:s`)
        #---------------------------------------------------
        *)  fn_bs_libarray_invalid_args \
              "${BS_LA_RBF_Caller}"     \
              "invalid primary '${BS_LA_RBF_Primary}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac #<: `case ${BS_LA_RBF_TestPrimary} in`
    ;; #<: `'=')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # STRING INEQUALITY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '!=')
      case ${BS_LA_RBF_TestPrimary} in
        #---------------------------------------------------
        #
        #---------------------------------------------------
        "${BS_LA_RBF_Primary}")
          BS_LA_RBF_HaveElements=0
          for BS_LA_RBF_Value
          do
            case ${BS_LA_RBF_Value} in
            "${BS_LA_RBF_Expr}")
              array_value "${BS_LA_RBF_Value}" || return $?
              BS_LA_RBF_HaveElements=1 ;;
            esac
          done #<: `for BS_LA_RBF_Value`

          #-----------------------------
          # Trailing whitespace is
          # always required (if there
          # are any elements)
          #-----------------------------
          case ${BS_LA_RBF_HaveElements} in 1) echo ' ' ;; esac
        ;; #<: `"${BS_LA_RBF_Primary}")`

        #---------------------------------------------------
        # Invalid Primary (e.g. `!=:s`)
        #---------------------------------------------------
        *)  fn_bs_libarray_invalid_args \
              "${BS_LA_RBF_Caller}"     \
              "invalid primary '${BS_LA_RBF_Primary}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac #<: `case ${BS_LA_RBF_TestPrimary} in`
    ;; #<: `'!=')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # NUMERICAL COMPARISON
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-eq'|'-ne'|'-gt'|'-ge'|'-lt'|'-le')
      case ${BS_LA_RBF_TestPrimary} in
        #---------------------------------------------------
        #
        #---------------------------------------------------
        "${BS_LA_RBF_Primary}")
          BS_LA_RBF_HaveElements=0
          for BS_LA_RBF_Value
          do
            if test "${BS_LA_RBF_Value}"   \
                    "${BS_LA_RBF_Primary}" \
                    "${BS_LA_RBF_Expr}"
            then
              continue
            else
              array_value "${BS_LA_RBF_Value}" || return $?
              BS_LA_RBF_HaveElements=1
            fi
          done #<: `for BS_LA_RBF_Value`

          #-----------------------------
          # Trailing whitespace is
          # always required (if there
          # are any elements)
          #-----------------------------
          case ${BS_LA_RBF_HaveElements} in 1) echo ' ' ;; esac
        ;; #<: `"${BS_LA_RBF_Primary}")`

        #---------------------------------------------------
        # Invalid Primary (e.g. `-gt:s`)
        #---------------------------------------------------
        *)  fn_bs_libarray_invalid_args \
              "${BS_LA_RBF_Caller}"     \
              "invalid primary '${BS_LA_RBF_Primary}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac #<: `case ${BS_LA_RBF_TestPrimary} in`
    ;; #<: `'-gt'|'-ge'|'-lt'|'-le')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  fn_bs_libarray_invalid_args \
          "${BS_LA_RBF_Caller}"     \
          "invalid primary '${BS_LA_RBF_Primary}'"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case ${BS_LA_RBF_TestPrimary} in`
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
fn_bs_libarray_remove_by_range() { ## cSpell:Ignore BS_LA_RBR_
    BS_LA_RBR_Caller=${1:?'[libarray::fn_bs_libarray_remove_by_range]: Internal Error: a caller is required'}
  BS_LA_RBR_refArray=${2:?'[libarray::fn_bs_libarray_remove_by_range]: Internal Error: an array variable is required'}
     BS_LA_RBR_Range=${3:?'[libarray::fn_bs_libarray_remove_by_range]: Internal Error: a range is required'}

  #=========================================================
  # Unpack the array
  #=========================================================
  eval "BS_LA_RBR_Array=\${${BS_LA_RBR_refArray}-}" || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_RBR_Array?}" && shift || return $?

  #=========================================================
  # Early out
  #=========================================================
  case $# in 0) return ;; esac

  #=========================================================
  # Determine START and LENGTH
  # NOTES: START will be zero-based, LENGTH >= 1
  case ${BS_LA_RBR_Range} in
    #...................................
    # USING A RANGE
    #...................................
    *[#:]*)
      fn_bs_libarray_process_range \
        "${BS_LA_RBR_Caller}"       \
        'BS_LA_RBR_Start'           \
        'BS_LA_RBR_Length'          \
        "${BS_LA_RBR_Range}"        \
        $#                         || return $?
    ;;

    #...................................
    # USING AN INDEX
    # (convert to single element range)
    #...................................
    *)
      fn_bs_libarray_process_index \
        "${BS_LA_RBR_Caller}"       \
        'BS_LA_RBR_Range'           \
        $#                         || return $?
      BS_LA_RBR_Length=1
       BS_LA_RBR_Start=${BS_LA_RBR_Range}
    ;;
  esac #<: `case ${BS_LA_RBR_Range} in`

  #=========================================================
  # PROCESS \[START, START + LENGTH)
  #=========================================================
  BS_LA_RBR_End=;
  case ${BS_LA_RBR_Start} in
    #...................................
    # START is zero
    # - keep nothing
    # - skip \[0, LENGTH)
    #...................................
    0)
      BS_LA_RBR_Array=;
        BS_LA_RBR_End=${BS_LA_RBR_Length}
    ;;

    #...................................
    # START is non-zero
    # - keep \[0, START)
    # - skip \[START, START + LENGTH)
    #...................................
    *)
      # Add kept values
      BS_LA_RBR_Array=$(
          {
            fn_bs_libarray_create_count \
              "${BS_LA_RBR_Caller}"      \
              "${BS_LA_RBR_Start}"       \
              "$@"
          } && {
            echo ' '
          }
        ) || return $?

      # Skip kept values + skipped values
      BS_LA_RBR_End=$((BS_LA_RBR_Start + BS_LA_RBR_Length))
    ;;
  esac #<: `case ${BS_LA_RBR_Start} in`

  #=========================================================
  # Append any remaining elements
  #=========================================================
  case $# in
    #...................................
    # NOTHING TO ADD
    #...................................
    0|"${BS_LA_RBR_End}") ;;

    #...................................
    # ONE OR MORE ELEMENTS TO ADD
    #...................................
    *)
      # `shift` all processed elements
      case ${c_BS_LIBARRAY_CFG__use_shift_n:-0} in
      0)  while : #<: `[ "${BS_LA_RBR_End}" -ge 0 ]`
          do
            shift
            BS_LA_RBR_End=$((BS_LA_RBR_End - 1))
            #> LOOP TEST -----------------------------------
            case ${BS_LA_RBR_End} in 0) break;; esac #<: `[ "${BS_LA_RBR_End}" -ge 0 ]`
            #< ---------------------------------------------
          done ;;
      1)  shift "${BS_LA_RBR_End}" ;;
      esac

      BS_LA_RBR_Array="${BS_LA_RBR_Array}$(
          {
            fn_bs_libarray_create  \
              "${BS_LA_RBR_Caller}" \
              "$@"
          } && {
            echo ' '
          }
        )" || return $? ;;
  esac #<: `case $# in`

  #=========================================================
  # SAVE
  #=========================================================
  eval "${BS_LA_RBR_refArray}=\${BS_LA_RBR_Array}"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_find_index_glob`
#;
#; Use `awk` to find the first array element that matches a _ERE_ and print the
#; index of that element to `STDOUT`.
#;
#; Exit status will be zero _only_ if a match was found, otherwise it will be
#; non-zero.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_find_index_glob <CALLER> <OPERATOR> <ERE> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `ERE` \[in]
#;
#; : An ["Extended Regular Expression" (_ERE_)][posix_ere].
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _ERE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#_______________________________________________________________________________
fn_bs_libarray_find_index_glob() {  ## cSpell:Ignore BS_LA_FIG_
  BS_LA_FIG_Caller=${1:?'[libarray::fn_bs_libarray_find_index_glob]: Internal Error: a caller is required'}
  shift
  BS_LA_FIG_Op=${1:?'[libarray::fn_bs_libarray_find_index_glob]: Internal Error: an operator is required'}
  shift
  BS_LA_FIG_Expr=${1?'[libarray::fn_bs_libarray_find_index_glob]: Internal Error: an expression is required'}
  shift

  #=========================================================
  #
  #=========================================================
  BS_LA_FIG_Fast=0
  case ${c_BS_LIBARRAY_CFG__full_glob_support}:${c_BS_LIBARRAY_CFG__shell_supports_mbc}:${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    1:1:*|1:0:C|1:0:POSIX)
      BS_LA_FIG_Fast=1 ;;

    0:1:*|0:0:C|0:0:POSIX)
      case ${BS_LA_FIG_Expr} in
      *[\\\(\)]*) BS_LA_FIG_Fast=0 ;;
               *) BS_LA_FIG_Fast=1 ;;
      esac ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_FIG_Fast} in
    1)
      #-----------------------------------------------------
      # As ever, `zsh` needs some settings changed or it
      # will always fail.
      #-----------------------------------------------------
      case ${c_BS_LIBARRAY_CFG__use_zsh_setopt} in
      1) setopt 'LOCAL_OPTIONS' 'SH_FILE_EXPANSION' 'SH_GLOB' \
                'GLOB_SUBST'    'NONOMATCH'                   ;; ## cSpell:Ignore NONOMATCH
      esac

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      BS_LA_FIG_Index=1
      for BS_LA_FIG_Element
      do
        if  fn_bs_libarray_cmp_glob \
              "${BS_LA_FIG_Caller}" \
              "${BS_LA_FIG_Op}"     \
              "${BS_LA_FIG_Expr}"   \
              "${BS_LA_FIG_Element}"
        then
          printf '%d\n' "${BS_LA_FIG_Index}"
          return
        else
          BS_LA_FIG_Index=$((BS_LA_FIG_Index + 1))
        fi
      done
    ;;

    0)
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libarray_dbg_msg  \
        "${BS_LA_FIG_Caller}" \
        "Using emulated globs (expression '${BS_LA_FIG_Expr}')"

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libarray_awk_run_script \
        "${BS_LA_FIG_Caller}"       \
        "${c_BS_LIBARRAY__awk_fn__glob_to_ere}"'
          function bs_fn_main(argArray, argCount) {
            BS_LA_Expr = bs_fn_glob_to_ere(argArray[1])
            for (i = 2; i < argCount; ++i) {
              if (argArray[i] '"${BS_LA_FIG_Op}"' BS_LA_Expr) {
                print (i - 1)
                exit
              }
            }
          }
        '                   \
        "${BS_LA_FIG_Expr}" \
        "$@"
    ;;
  esac
} #<: `fn_bs_libarray_find_index_glob()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_find_index_grep`
#;
#; Use `grep` to find the first array element that matches an expression and
#; print the index of that element to `STDOUT`.
#;
#; Exit status will be zero _only_ if a match was found, otherwise it will be
#; non-zero.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_find_index_grep <CALLER> <MODE> <OPERATOR> <REGEX> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `MODE` \[in]
#;
#; : Either `-G` or `-E` indicating whether `REGEX` is a
#;   _BRE_ (`-G`) or an _ERE_ (`-E`).
#; : _NOT_ tested for correctness.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `REGEX` \[in]
#;
#; : A ["Basic Regular Expressions" (_BRE_)][posix_bre] if
#;   `MODE` is `-G`, an
#;   ["Extended Regular Expressions" (_ERE_)][posix_ere]
#;   otherwise.
#;
#; `VALUE` \[in]
#;
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - `MODE` is assumed to be `-G` unless specified as `-E`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Some platforms do not support `grep -E` but support the non-standard
#.   `egrep`. This allows for either case.
#.
#_______________________________________________________________________________
fn_bs_libarray_find_index_grep() {  ## cSpell:Ignore BS_LA_FIG_
  BS_LA_FIG_Caller=${1:?'[libarray::fn_bs_libarray_find_index_grep]: Internal Error: a caller is required'}
  shift
  BS_LA_FIG_Mode=${1?'[libarray::fn_bs_libarray_find_index_grep]: Internal Error: a mode is required'}
  shift
  BS_LA_FIG_Op=${1:?'[libarray::fn_bs_libarray_find_index_grep]: Internal Error: an operator is required'}
  shift
  BS_LA_FIG_Expr=${1?'[libarray::fn_bs_libarray_find_index_grep]: Internal Error: an expression is required'}
  shift

  #=========================================================
  # It _should_ be possible to use a single parameter for
  # the whole command to be used, unfortunately, this
  # relies on the value of `IFS` - additionally some shells
  # (e.g. `osh`) do not seem to properly split the value
  # regardless of `IFS`.
  #=========================================================
  case ${c_BS_LIBARRAY_CFG__use_grep_E}:${BS_LA_FIG_Mode} in
  0':-E') BS_LA_FIG_grep_cmd='egrep'; BS_LA_FIG_grep_args=;    ;;
  1':-E') BS_LA_FIG_grep_cmd='grep';  BS_LA_FIG_grep_args='E'; ;;
       *) BS_LA_FIG_grep_cmd='grep';  BS_LA_FIG_grep_args=;    ;;
  esac

  #=========================================================
  # If the array values contain `<newline>` characters,
  # `grep` has to be used to check each value in turn -
  # there is no real way to check them all at once,
  # otherwise all the values can be checked in a single
  # call.
  #=========================================================
  if fn_bs_libarray_any_contain_newline "${BS_LA_FIG_Caller}" "$@"
  then
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BS_LA_FIG_Index=1
    for BS_LA_FIG_Element
    do
      if  BS_LA_FIG_Ignored=$(
              {
                printf '%s\n' "${BS_LA_FIG_Element}"
              } | {
                ${BS_LA_FIG_grep_cmd} \
                  ${BS_LA_FIG_grep_args:+"-${BS_LA_FIG_grep_args}"} \
                  "${BS_LA_FIG_Expr}"
              }
            )
      then
        case ${BS_LA_FIG_Op} in  '~') printf '%d\n' "${BS_LA_FIG_Index}"; return ;; esac
      else
        case ${BS_LA_FIG_Op} in '!~') printf '%d\n' "${BS_LA_FIG_Index}"; return ;; esac
      fi

      BS_LA_FIG_Index=$((BS_LA_FIG_Index + 1))
    done
  else
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Using the `-n` option to `grep` gives us the index
    # without having to calculate it directly, however, note
    # the value is _one_ based.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${BS_LA_FIG_Op} in
    '!~') BS_LA_FIG_grep_args="${BS_LA_FIG_grep_args-}vn" ;;
       *) BS_LA_FIG_grep_args="${BS_LA_FIG_grep_args-}n"  ;;
    esac

    {
      printf '%s\n' "$@"
    } | {
      ${BS_LA_FIG_grep_cmd}       \
        "-${BS_LA_FIG_grep_args}" \
        "${BS_LA_FIG_Expr}"
    } | {
      # Need to use the `q` function in `sed` or multiple
      # matches will cause errors.
      sed -n -e '
          s/:.*$//p
          q
        '
    }
  fi
} #<: `fn_bs_libarray_find_index_grep()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_find_index_sed`
#;
#; Use `sed` to find the first array element that matches a _BRE_ and print the
#; index of that element to `STDOUT`.
#;
#; Exit status will be zero _only_ if a match was found, otherwise it will be
#; non-zero.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_find_index_sed <CALLER> <OPERATOR> <BRE> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `BRE` \[in]
#;
#; : A ["Basic Regular Expressions" (_BRE_)][posix_bre].
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _BRE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#_______________________________________________________________________________
fn_bs_libarray_find_index_sed() {  ## cSpell:Ignore BS_LA_FIS_
  BS_LA_FIS_Caller=${1:?'[libarray::fn_bs_libarray_find_index_sed]: Internal Error: a caller is required'}
  shift
  BS_LA_FIS_Op=${1:?'[libarray::fn_bs_libarray_find_index_sed]: Internal Error: an operator is required'}
  shift
  BS_LA_FIS_Expr=${1?'[libarray::fn_bs_libarray_find_index_sed]: Internal Error: an expression is required'}
  shift


  #=========================================================
  # The BRE is going to be used as part of a `sed` script,
  # so literal `<newline>` characters along with `/`
  # (`<slash>`) characters need to be escaped, or they will
  # cause errors.
  #
  # NOTE: Although `sed` is supposed to support characters
  #       other than `/` (`<slash>`) for "functions", some
  #       implementations do not, so it's easier to always
  #       use `/` (`<slash>`) than try to use something
  #       else in cases when the BRE contains it.
  #=========================================================
  case ${BS_LA_FIS_Expr} in
  *'/'*|*"${c_BS_LIBARRAY__newline}"*)
    BS_LA_FIS_Expr=$(fn_bs_libarray_sanitize_sed_bre "${BS_LA_FIS_Expr}_") || return $?
    BS_LA_FIS_Expr=${BS_LA_FIS_Expr%_} ;;
  esac #<: `case ${BS_LA_FIS_Expr} in`

  #=========================================================
  #
  #=========================================================
  BS_LA_FIS_Index=1
  for BS_LA_FIS_Element
  do
    if  fn_bs_libarray_cmp_sed  \
          "${BS_LA_FIS_Caller}" \
          "${BS_LA_FIS_Op}"     \
          "${BS_LA_FIS_Expr}"   \
          "${BS_LA_FIS_Element}"
    then
      printf '%s\n' "${BS_LA_FIS_Index}"
      break
    else
      BS_LA_FIS_Index=$((BS_LA_FIS_Index + 1))
    fi
  done #<: `for BS_LA_FIS_Element`
} #<: `fn_bs_libarray_find_index_sed()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_find_index_awk`
#;
#; Use `awk` to find the first array element that matches a _ERE_ and print the
#; index of that element to `STDOUT`.
#;
#; Exit status will be zero _only_ if a match was found, otherwise it will be
#; non-zero.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_find_index_awk <CALLER> <OPERATOR> <ERE> [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OPERATOR` \[in]
#;
#; : Either `~` or `!~` indicating whether a match (`~`) or
#;   a non-match (`!~`) is being tested.
#; : _NOT_ tested for correctness.
#;
#; `ERE` \[in]
#;
#; : An ["Extended Regular Expression" (_ERE_)][posix_ere].
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _ERE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#_______________________________________________________________________________
fn_bs_libarray_find_index_awk() {  ## cSpell:Ignore BS_LA_FIA_
  BS_LA_FIA_Caller=${1:?'[libarray::fn_bs_libarray_find_index_awk]: Internal Error: a caller is required'}
  shift
  BS_LA_FIA_Op=${1:?'[libarray::fn_bs_libarray_find_index_awk]: Internal Error: an operator is required'}
  shift
  BS_LA_FIA_Expr=${1?'[libarray::fn_bs_libarray_find_index_awk]: Internal Error: an expression is required'}
  shift

  #=========================================================
  #
  #=========================================================
  fn_bs_libarray_awk_run_script \
    "${BS_LA_FIA_Caller}"       \
    '
      function bs_fn_main(argArray, argCount) {
        BS_LA_Expr = argArray[1]
        for (i = 2; i < argCount; ++i) {
          if (argArray[i] '"${BS_LA_FIA_Op}"' BS_LA_Expr) {
            print (i - 1)
            exit
          }
        }
      }
    '                   \
    "${BS_LA_FIA_Expr}" \
    "$@"
} #<: `fn_bs_libarray_find_index_awk()`

#_______________________________________________________________________________
## cSpell:Ignore notlike notmatch matchex notmatchex
## cSpell:IgnoreRegExp -\w*[be]re\w*\b
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_find_index`
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
#; : Variable which will contain the index of the found
#;   element; will be set to null if element is not found.
#; : Any current contents will be lost.
#; : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
#; : If specified as `-` (`<hyphen>`) index is written to
#;   `STDOUT`.
#; : If the variable is _not_ currently null, the value it
#;   contains is used as an offset from which the search
#;   should begin.
#;
#; `PRIMARY` \[in]
#;
#; : A test operator used with EXPRESSION.
#; : MUST be ONE of: `=`, `!=`, `-eq`, `-ne`, `-gt`, `-ge`,
#;   `-lt`, `-le`, `-like`, `-notlike`, `-bre`, `-notbre`,
#;   `-ere`, or `-notere`.
#;
#; `EXPRESSION` \[in]
#;
#; : Value to use with `PRIMARY`.
#; : Can be null.
#; : _EXPECTS_:
#;   - a _string_ when `PRIMARY` is `=`, or `!=`
#;   - a _number_ when `PRIMARY` is `-eq`, `-ne`,
#;     `-gt`, `-ge`,  `-lt`, or `-le`
#;   - a _pattern_ when `PRIMARY` is `-like`, or `-notlike`.
#;   - a _BRE_ when `PRIMARY` is `-bre`, or `-notbre`.
#;   - an _ERE_ when `PRIMARY` is `-ere`, or `-notere`.
#;
#; `VALUE` \[in]
#;
#; : Can be specified zero or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all patterns, _BRE_, or _ERE_ can be used portably.
#; - The `-like`/`-notlike` operators use the locale of the shell as invoked -
#;   _it is **not** possible to change the locale of a running shell_.
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#; _NOTES_
#; <!-- -->
#;
#; - Several aliases are provided: `-[not]match` and `-[not]matchbre` for
#;   `-[not]bre`; `-[not]matchex` and `-[not]matchere` for
#;   `-[not]ere`. Additionally, `=~` for `-ere` and `!~` for `-notere`.
#;
#_______________________________________________________________________________
fn_bs_libarray_find_index() { ## cSpell:Ignore BS_LA_FI_
  BS_LA_FI_Caller=${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: a caller is required'}
  shift
  BS_LA_FI_refIndex=${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: an index variable is required'}
  shift
  BS_LA_FI_Primary=${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: a primary is required'}
  shift
  BS_LA_FI_Expr=${1:?'[libarray::fn_bs_libarray_find_index]: Internal Error: an expression is required'}
  shift

  : "${1?'[libarray::fn_bs_libarray_find_index]: Internal Error: one or more array values are required'}"

  #=========================================================
  # Keep a copy of the input primary for error messages.
  #=========================================================
  BS_LA_FI_TestPrimary=${BS_LA_FI_Primary}

  #=========================================================
  # Pre-match some common elements and remove them from the
  # primary:
  #
  # - `-not<PRIMARY>` becomes `-<PRIMARY>`
  # - `=~` becomes `-ere`
  # - `!~` becomes `-ere`
  #
  # A flag is used to indicate the operator logic: `~` means
  # a match is being looked for, `!~` means the opposite,
  # and is only used for some primaries.
  #
  # Doing this significantly simplifies the subsequent code,
  # but leaves open the potential for invalid primaries
  # being specified. Most of these cases are handled later,
  # but some are simply ignored. (To handle _all_ cases
  # further complicates the code with little benefits - of
  # note, the trailing specifiers `:s` and `:m` are ignored
  # with `-[not]like` - there is no special case code for
  # this combination, but semantically it makes sense for
  # such operators them to exist.)
  #=========================================================
  BS_LA_FI_Op='~'
  case ${BS_LA_FI_TestPrimary} in
    '-not'*)
      BS_LA_FI_TestPrimary=-${BS_LA_FI_TestPrimary#'-not'}
      BS_LA_FI_Op='!~'
    ;;

    '=~')
      BS_LA_FI_TestPrimary='-ere'
      BS_LA_FI_Op='~'
    ;;

    '!~')
      BS_LA_FI_TestPrimary='-ere'
      BS_LA_FI_Op='!~'
    ;;
  esac #<: `case ${BS_LA_FI_TestPrimary} in`

  #=========================================================
  # CHECK ALL PARAMETERS FOR A MATCHING VALUE
  #=========================================================
  BS_LA_FI_Found=;
  case ${BS_LA_FI_TestPrimary%:[sm]} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # GLOB
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-like')
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      BS_LA_FI_Found=$(
          fn_bs_libarray_find_index_glob  \
            "${BS_LA_FI_Caller}"          \
            "${BS_LA_FI_Op}"              \
            "${BS_LA_FI_Expr}"            \
            "$@"
        ) || return $?
    ;; #<: `'-like')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # BRE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-match'|'-matchbre'|'-bre')
      case ${BS_LA_FI_TestPrimary} in
        #...............................
        # SINGLE LINE MODE
        #...............................
        *':s')
          BS_LA_FI_Found=$(
              fn_bs_libarray_find_index_grep \
                "${BS_LA_FI_Caller}"         \
                '-G'                         \
                "${BS_LA_FI_Op}"             \
                "${BS_LA_FI_Expr}"           \
                "$@"
            ) || return $? ;;

        #...............................
        # MULTI-LINE MODE
        #...............................
        *)
          BS_LA_FI_Found=$(
              fn_bs_libarray_find_index_sed \
                "${BS_LA_FI_Caller}"        \
                "${BS_LA_FI_Op}"            \
                "${BS_LA_FI_Expr}"          \
                "$@"
            ) || return $? ;;
      esac #<: `case ${BS_LA_FI_TestPrimary} in`
    ;; #<: `'-match'|'-matchbre'|'-bre')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ERE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-matchex'|'-matchere'|'-ere')
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      case ${BS_LA_FI_TestPrimary} in
        #...............................
        # SINGLE LINE MODE
        #...............................
        *':s')
          BS_LA_FI_Found=$(
              fn_bs_libarray_find_index_grep \
                "${BS_LA_FI_Caller}"         \
                '-E'                         \
                "${BS_LA_FI_Op}"             \
                "${BS_LA_FI_Expr}"           \
                "$@"
            ) || return $? ;;

        #...............................
        # MULTI-LINE MODE
        #...............................
        *)
          BS_LA_FI_Found=$(
              fn_bs_libarray_find_index_awk \
                "${BS_LA_FI_Caller}"        \
                "${BS_LA_FI_Op}"            \
                "${BS_LA_FI_Expr}"          \
                "$@"
            ) || return $? ;;
      esac #<: `case ${BS_LA_FI_TestPrimary} in`
    ;; #<: `'-matchex'|'-matchere'|'-ere')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # STRING EQUALITY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '=')
      case ${BS_LA_FI_TestPrimary} in
        #---------------------------------------------------
        #
        #---------------------------------------------------
        "${BS_LA_FI_Primary}")
          BS_LA_FI_Index=1
          for BS_LA_FI_Element
          do
            case ${BS_LA_FI_Element} in
            "${BS_LA_FI_Expr}")
              BS_LA_FI_Found=${BS_LA_FI_Index}
              break ;;
            esac
            BS_LA_FI_Index=$((BS_LA_FI_Index + 1))
          done #<: `for BS_LA_FI_Element`
        ;; #<: `"${BS_LA_FI_Primary}")`

        #---------------------------------------------------
        # Invalid Primary (e.g. `-eq:s`)
        #---------------------------------------------------
        *)  fn_bs_libarray_invalid_args \
              "${BS_LA_FI_Caller}"      \
              "invalid primary '${BS_LA_FI_Primary}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac #<: `case ${BS_LA_FI_TestPrimary} in`
    ;; #<: `'=')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # STRING INEQUALITY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '!=')
      case ${BS_LA_FI_TestPrimary} in
        #---------------------------------------------------
        #
        #---------------------------------------------------
        "${BS_LA_FI_Primary}")
          BS_LA_FI_Index=1
          for BS_LA_FI_Element
          do
            case ${BS_LA_FI_Element} in
              "${BS_LA_FI_Expr}")
                BS_LA_FI_Index=$((BS_LA_FI_Index + 1))
                continue ;;

              *)
                BS_LA_FI_Found=${BS_LA_FI_Index}
                break ;;
            esac
          done #<: `for BS_LA_FI_Element`
        ;; #<: `"${BS_LA_FI_Primary}")`

        #---------------------------------------------------
        # Invalid Primary (e.g. `-ne:s`)
        #---------------------------------------------------
        *)  fn_bs_libarray_invalid_args \
              "${BS_LA_FI_Caller}"      \
              "invalid primary '${BS_LA_FI_Primary}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac #<: `case ${BS_LA_FI_TestPrimary} in`
    ;; #<: `'!=')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # NUMERICAL COMPARISON
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '-eq'|'-ne'|'-gt'|'-ge'|'-lt'|'-le')
      case ${BS_LA_FI_TestPrimary} in
        #---------------------------------------------------
        #
        #---------------------------------------------------
        "${BS_LA_FI_Primary}")
          BS_LA_FI_Index=1
          for BS_LA_FI_Element
          do
            if test "${BS_LA_FI_Element}" \
                    "${BS_LA_FI_Primary}" \
                    "${BS_LA_FI_Expr}"
            then
              BS_LA_FI_Found=${BS_LA_FI_Index}
              break
            else
              BS_LA_FI_Index=$((BS_LA_FI_Index + 1))
            fi
          done
        ;; #<: `"${BS_LA_FI_Primary}")`

        #---------------------------------------------------
        # Invalid Primary (e.g. `-gt:s`)
        #---------------------------------------------------
        *)  fn_bs_libarray_invalid_args \
              "${BS_LA_FI_Caller}"      \
              "invalid primary '${BS_LA_FI_Primary}'"
            return "${c_BS_LIBARRAY__EX_USAGE}" ;;
      esac #<: `case ${BS_LA_FI_TestPrimary} in`
    ;; #<: `'-gt'|'-ge'|'-lt'|'-le')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  fn_bs_libarray_invalid_args \
          "${BS_LA_FI_Caller}"      \
          "invalid primary '${BS_LA_FI_Primary}'"
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case ${BS_LA_FI_TestPrimary%:[sm]} in`

  #=========================================================
  # SAVE
  #=========================================================
  eval "${BS_LA_FI_refIndex}=\${BS_LA_FI_Found}"
} #<: `fn_bs_libarray_find_index()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_split_fixed`
#;
#; Split text into an array using fixed text.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_split_fixed <CALLER> <TEXT> <DELIMITER>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `TEXT` \[in]
#;
#; : Text to split into array elements.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `DELIMITER` \[in]
#;
#; : Expression used to split `TEXT`.
#; : Can contain any arbitrary text excluding
#;   any embedded `\0` (`<NUL>`) characters.
#;
#_______________________________________________________________________________
fn_bs_libarray_split_fixed() { ## cSpell:Ignore BS_LA_SF_
  BS_LA_SF_Caller=${1:?'[libarray::fn_bs_libarray_split_fixed]: Internal Error: a caller is required'}
    BS_LA_SF_Text=${2?'[libarray::fn_bs_libarray_split_fixed]: Internal Error: text to split is required'}
   BS_LA_SF_Delim=${3?'[libarray::fn_bs_libarray_split_fixed]: Internal Error: a delimiter is required'}

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_SF_Text:+1}:${BS_LA_SF_Text} in
    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    1:*"${BS_LA_SF_Delim}"*)
      #.................................
      #
      #.................................
      while :
      do
        # Use of `${#...}` is safe here
        # even in presence of multi-byte
        # characters as it is used for
        # comparison only.
        BS_LA_SF_PrevLen=${#BS_LA_SF_Text}
          BS_LA_SF_Value=${BS_LA_SF_Text%%"${BS_LA_SF_Delim}"*}

        array_value "${BS_LA_SF_Value}" || return $?

        BS_LA_SF_Text=${BS_LA_SF_Text#*"${BS_LA_SF_Delim}"}
        case ${BS_LA_SF_Text:+1}:${BS_LA_SF_PrevLen} in
        :*|"1:${#BS_LA_SF_Text}") break ;;
        esac
      done

      #.................................
      # Trailing whitespace is required
      #.................................
      echo ' '
    ;;

    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    1:*)
      array_value "${BS_LA_SF_Text}" || return $?

      #.................................
      # Trailing whitespace is required
      #.................................
      echo ' '
    ;;

    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    *) ;;
  esac #<: `case ${BS_LA_SF_Text:+1}:${BS_LA_SF_Text} in`
} #<: `fn_bs_libarray_split_fixed()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_split_glob`
#;
#; Split text into an array using a shell pattern (aka glob) expression.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_split_glob <CALLER> <TEXT> <DELIMITER>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `TEXT` \[in]
#;
#; : Text to split into array elements.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `DELIMITER` \[in]
#;
#; : Expression used to split `TEXT`.
#; : Shell ["Pattern Matching Notation"][posix_glob] value.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all characters can be used portably._
#; - The locale used is that of the shell as invoked -
#;   _it is **not** possible to change the locale of a running shell_.
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#_______________________________________________________________________________
fn_bs_libarray_split_glob() { ## cSpell:Ignore BS_LA_SG_
  BS_LA_SG_Caller=${1:?'[libarray::fn_bs_libarray_split_glob]: Internal Error: a caller is required'}
    BS_LA_SG_Text=${2?'[libarray::fn_bs_libarray_split_glob]: Internal Error: text to split is required'}
   BS_LA_SG_Delim=${3?'[libarray::fn_bs_libarray_split_glob]: Internal Error: a delimiter is required'}

  #=========================================================
  #
  #=========================================================
  BS_LA_SG_Fast=0
  case ${c_BS_LIBARRAY_CFG__full_glob_support}:${c_BS_LIBARRAY_CFG__shell_supports_mbc}:${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    1:1:*|1:0:C|1:0:POSIX)
      BS_LA_SG_Fast=1 ;;

    0:1:*|0:0:C|0:0:POSIX)
      case ${BS_LA_SG_Delim} in
      *[\\\(\)]*) BS_LA_SG_Fast=0 ;;
               *) BS_LA_SG_Fast=1 ;;
      esac ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_SG_Fast} in
    1)
      #-----------------------------------------------------
      # As ever, `zsh` needs some settings changed or it
      # will always fail.
      #-----------------------------------------------------
      case ${c_BS_LIBARRAY_CFG__use_zsh_setopt} in
      1) setopt 'LOCAL_OPTIONS' 'SH_FILE_EXPANSION' 'SH_GLOB' \
                'GLOB_SUBST'    'NONOMATCH'                   ;; ## cSpell:Ignore NONOMATCH
      esac

      #-----------------------------------------------------
      # SC2295: Expansions inside ${..} need to be quoted
      #         separately, otherwise they will match as a
      #         pattern.
      # EXCEPT: Want globbing to happen here.
      # shellcheck disable=SC2295
      #-----------------------------------------------------
      while :
      do
        BS_LA_SG_PrevLen=${#BS_LA_SG_Text}
          BS_LA_SG_Value=${BS_LA_SG_Text%%${BS_LA_SG_Delim}*}

        array_value "${BS_LA_SG_Value}" || return $?

        BS_LA_SG_Text=${BS_LA_SG_Text#*${BS_LA_SG_Delim}}
        case ${BS_LA_SG_Text:+1}:${BS_LA_SG_PrevLen} in
        :*|"1:${#BS_LA_SG_Text}") break ;;
        esac
      done

      #.................................
      # Trailing whitespace is required
      #.................................
      echo ' '
    ;;

    0)
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libarray_dbg_msg \
        "${BS_LA_SG_Caller}" \
        "Using emulated globs (expression '${BS_LA_SG_Delim}')"

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libarray_awk_run_script \
        "${BS_LA_SG_Caller}"        \
        " ${c_BS_LIBARRAY__awk_fn__glob_to_ere}
          ${c_BS_LIBARRAY__awk_fn__array_print}"'
          function bs_fn_main(argArray, argCount) {
            BS_LA_Text  = argArray[1]
            BS_LA_Delim = bs_fn_glob_to_ere(argArray[2])

            iSplitCount = split(BS_LA_Text, BS_LA_aSplitText, BS_LA_Delim)
            for (i = 1; i <= iSplitCount; i = i + 1) {
              bs_fn_array_print(BS_LA_aSplitText[i])
            }
            printf(" \n")
          }
        '                   \
        "${BS_LA_SG_Text}"  \
        "${BS_LA_SG_Delim}"
    ;;
  esac
} #<: `fn_bs_libarray_split_glob()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_split_bre`
#;
#; Split text into an array using a ["Basic Regular Expression"][posix_bre].
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_split_bre <CALLER> <TEXT> <DELIMITER>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `TEXT` \[in]
#;
#; : Text to split into array elements.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `DELIMITER` \[in]
#;
#; : Expression used to split `TEXT`.
#; : A ["Basic Regular Expression"][posix_bre].
#; : Can contain any arbitrary text excluding
#;   any embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _BRE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#; - If `DELIMITER` contains any `'` (`<apostrophe>`) characters the
#;   performance of this function will be significantly slower than if it does
#;   not. This is unavoidable.
#; - Some `sed` implementations have significant limits on the amount of data
#;   they can process. As this command needs to process all input at once, it
#;   is likely that these limitations will be an issue for relatively short
#;   input values. Unfortunately, it is not possible to avoid this.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Earlier versions of this (i.e. libarray.sh v1.x.x) were all subtly, but
#.   badly broken. This reworked version is significantly more robust and fixes
#.   most of the issues previously present. However, the command is complicated
#.   and subject to many edge cases that are not immediately obvious.
#. - The current implementation makes the assumption that `sed` matches are
#.   always "greedy". This is _not_ explicitly stated in the standard, but is
#.   implied and is what all tested implementations use. If an implementation
#.   is shown to use "non-greedy" matches an alternative algorithm should be
#.   easy to create, but without such an implementation is untestable.
#. - The additional assumption is made that anchors (i.e. `^` and `$`) apply to
#.   the whole text and not single lines - that is, `^` matches the start of the
#.   `sed` pattern space and `$` matches the end regardless of any `<newline>`
#.   characters. This is what the standard requires, but implementations may
#.   vary. Again, it would be possible to create `sed` scripts that account for
#.   this, but there is no point in doing this unless it's shown as necessary.
#.
#_______________________________________________________________________________
fn_bs_libarray_split_bre() { ## cSpell:Ignore BS_LA_SBRE_
  BS_LA_SBRE_Caller=${1:?'[libarray::fn_bs_libarray_split_bre]: Internal Error: a caller is required'}
    BS_LA_SBRE_Text=${2?'[libarray::fn_bs_libarray_split_bre]: Internal Error: text to split is required'}
   BS_LA_SBRE_Delim=${3?'[libarray::fn_bs_libarray_split_bre]: Internal Error: a delimiter is required'}

  #=========================================================
  # The BRE is going to be used as part of a `sed` script,
  # so literal `<newline>` characters along with `/`
  # (`<slash>`) characters need to be escaped, or they will
  # cause errors.
  #
  # NOTE: Although `sed` is supposed to support characters
  #       other than `/` (`<slash>`) for "functions", some
  #       implementations do not, so it's easier to always
  #       use `/` (`<slash>`) than try to use something
  #       else in cases when the BRE contains it.
  #=========================================================
  case ${BS_LA_SBRE_Delim} in
  *'/'*|*"${c_BS_LIBARRAY__newline}"*)
    BS_LA_SBRE_Delim=$(fn_bs_libarray_sanitize_sed_bre "${BS_LA_SBRE_Delim}_") || return $?
    BS_LA_SBRE_Delim=${BS_LA_SBRE_Delim%_} ;;
  esac

  #=========================================================
  # Split the text
  #
  # If `DELIMITER` contains `'` (`<apostrophe>`) characters
  # splitting becomes much more complex as it's necessary to
  # isolate all array values before they can be turned into
  # proper array elements by quoting, and escaping as
  # required. When `DELIMITER` does _not_ contain `'`
  # (`<apostrophe>`) characters escaping can occur to the
  # entire input text _before_ splitting, making the
  # process much simpler. (Escaping changes the text so
  # changes what needs matched by `DELIMITER` in a way that
  # is not easy to fix automatically.)
  #=========================================================
  case ${BS_LA_SBRE_Delim} in
    #-------------------------------------------------------
    # CONTAINS `'` (`<apostrophe>`) CHARACTERS
    #-------------------------------------------------------
    *"'"*)
      #.....................................................
      # `sed` matches are greedy, so the only way to isolate
      # the array values is matching them at the **end** of
      # the input text - given how the rest of the script
      # needs to work this means the values must be output
      # in _reverse_ order. While unfortunate, this is easy
      # to fix, but does involve a significant amount of
      # additional work - some of which will repeat actions
      # already made by the split script, but are
      # unavoidable.
      #.....................................................
      BS_LA_SBRE_Array=$(
          {
            printf '%s\n' "${BS_LA_SBRE_Text}"
          } | {
            sed -e "
                :INPUT
                  \$!N
                  \$!b INPUT
                :SPLIT
                  /${BS_LA_SBRE_Delim}/{
                    h
                    s/.*${BS_LA_SBRE_Delim}//
                    s/'/'\\\\''/g
                    s/^/'/
                    s/\$/' \\\\/
                    p
                    x
                    s/\(.*\)${BS_LA_SBRE_Delim}.*/\1/
                    b SPLIT
                  }
                s/'/'\\\\''/g
                s/^/'/
                s/\$/' \\\\/
              "
          } && {
            echo ' '
          }
        ) || return $?

      #.....................................................
      #
      #.....................................................
      case ${BS_LA_SBRE_Array:+1} in 1) ;; *) return ;; esac

      #.....................................................
      #
      #.....................................................
      eval "set 'BS_DUMMY_PARAM' ${BS_LA_SBRE_Array} && shift" || return $?

      #.....................................................
      #
      #.....................................................
      fn_bs_libarray_create_count_reverse \
        "${BS_LA_SBRE_Caller}"            \
        $#                                \
        "$@"                              || return $?
      echo ' '
    ;; #<: `*"'"*`

    #-------------------------------------------------------
    # DOES NOT CONTAIN `'` (`<apostrophe>`) CHARACTERS
    #-------------------------------------------------------
    *)
      #.....................................................
      #
      #.....................................................
      {
        printf '%s\n' "${BS_LA_SBRE_Text}"
      } | {
        sed -e "
            :INPUT
              \$!N
              \$!b INPUT
            s/'/'\\\\''/g
            s/^/'/
            s/\$/' \\\\/
            s/${BS_LA_SBRE_Delim}/' \\\\\\
'/g"
      } && {
        echo ' '
      }
    ;; #<: `*)`
  esac #<: `case ${BS_LA_SBRE_Delim} in`
} #<: `fn_bs_libarray_split_bre()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_split_ere`
#;
#; Split text into an array using an ["Extended Regular Expression"][posix_ere].
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_split_ere <CALLER> <TEXT> <DELIMITER>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `TEXT` \[in]
#;
#; : Text to split into array elements.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `DELIMITER` \[in]
#;
#; : Expression used to split `TEXT`.
#; : An ["Extended Regular Expression"][posix_ere].
#; : Can contain any arbitrary text excluding
#;   any embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Not all _ERE_ can be used portably._
#; - See ["PATTERN MATCHING"](./README.MD#pattern-matching).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Earlier versions of this (i.e. libarray.sh v1.x.x) were somewhat broken,
#.   with some security issues and cases that would not work (but should have).
#.   The current version is far more robust and should avoid most of the issues
#.   of previous versions, while remaining relatively similar in performance.
#.
#_______________________________________________________________________________
fn_bs_libarray_split_ere() { ## cSpell:Ignore BS_LA_SERE_
  BS_LA_SERE_Caller=${1:?'[libarray::fn_bs_libarray_split_ere]: Internal Error: a caller is required'}
    BS_LA_SERE_Text=${2?'[libarray::fn_bs_libarray_split_ere]: Internal Error: text to split is required'}
   BS_LA_SERE_Delim=${3?'[libarray::fn_bs_libarray_split_ere]: Internal Error: a delimiter is required'}

  #=========================================================
  #
  #=========================================================
  fn_bs_libarray_awk_run_script \
    "${BS_LA_SERE_Caller}"      \
    " ${c_BS_LIBARRAY__awk_fn__array_print}"'
      function bs_fn_main(argArray, argCount) {
        BS_LA_Text  = argArray[1]
        BS_LA_Delim = argArray[2]

        iSplitCount = split(BS_LA_Text, BS_LA_aSplitText, BS_LA_Delim)
        for (i = 1; i <= iSplitCount; i = i + 1) {
          bs_fn_array_print(BS_LA_aSplitText[i])
        }
        printf(" \n")
      }
    '                     \
    "${BS_LA_SERE_Text}"  \
    "${BS_LA_SERE_Delim}"
} #<: `fn_bs_libarray_split_ere()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libarray_create_from_path`
#;
#; Create an array (printed to `STDOUT`) from the paths contained in the given
#; path.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libarray_create_from_path <CALLER> <FLAG> <PATH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `FLAG` \[in]
#;
#; : A flag indicating if "dot files" should be included.
#; : If `0` "dot files" are omitted, otherwise they are
#;   included.
#; : Values other than `0` (`<zero>`) only make sense if
#;   `PATH` is a directory.
#;
#; `PATH` \[in]
#;
#; : A valid path for the current platform.
#; : Path MUST be suitable for appending a glob pattern.
#; : Partial paths are permitted.
#; : Interpreted literally (i.e. glob characters will not be
#;   used as glob characters).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - This implements [`array_from_path`](#array_from_path) and was previously
#.   written inline. Unfortunately, some shells (e.g. `posh`) have problems
#.   with parentheses inside `$(...)`. While this can be solved by using
#.   backticks instead of `$(...)`, using a function also works and does not
#.   have the issues that backticks are known for. (Note that the use of a
#.   function _inside_ `$(...)` causes some shells to create a subshell where
#.   they otherwise might not have - meaning a reduction in performance. This
#.   is unlikely to have an effect here, but may need testing to be sure.)
#. - Uses `ls` as a more portable replacement for `test -e` which
#.   [`autoconf` docs][autoconf_portable] suggest is not universally available.
#.   This may be unnecessary and is likely to be less performant, however it is
#.   only used in a relatively unlikely branch and it is probable that the costs
#.   will not be an issue in practice. Since any path being tested may begin
#.   with `-` (and therefore be incorrectly matched as an option for `ls`) the
#.   path is modified in this case to have `./` prepended. This _should_ be an
#.   identical path, but one that is not mistaken for an option. While it would
#.   be possible to use the special `--` argument for this purpose, the current
#.   code should be the most portable of all possible implementations.
#.
#_______________________________________________________________________________
fn_bs_libarray_create_from_path() { ## cSpell:Ignore BS_LA_CFP_
    BS_LA_CFP_Caller=${1:?'[libarray::fn_bs_libarray_create_from_path]: Internal Error: a caller is required'}
  BS_LA_CFP_DotFiles=${2:?'[libarray::fn_bs_libarray_create_from_path]: Internal Error: a flag is required'}
      BS_LA_CFP_Path=${3:?'[libarray::fn_bs_libarray_create_from_path]: Internal Error: a path is required'}

  #=========================================================
  # Z Shell needs some options set or the subsequent
  # code will fail
  #=========================================================
  case ${c_BS_LIBARRAY_CFG__use_zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'SH_FILE_EXPANSION' 'SH_GLOB' \
            'GLOB_SUBST'    'NONOMATCH'                   ;; ## cSpell:Ignore NONOMATCH
  esac

  #=========================================================
  # Iterate over the set of globs
  #=========================================================
  BS_LA_CFP_FoundPaths=0
  for BS_LA_CFP_Glob in '*' '.[!.]*' '..?*'
  do
    # Expand the glob. (This sets the current positional
    # parameters to each matched path)
    #
    # If there are no files, the first parameter will be
    # set to the glob, so there will be a single path -
    # to deal with this case, when a single path is
    # generated, need to test for existence. For maximum
    # performance, 'ls' is used for this rather than
    # 'test -e' as the latter may not be available.
    # To avoid using the '--' argument the test path is
    # modified so it does not begin with '-'.
    #
    # SC2086: Double quote to prevent globbing
    #         and word splitting.
    # EXCEPT: Want globbing to happen here
    # shellcheck disable=SC2086
    set 'BS_DUMMY_PARAM' "${BS_LA_CFP_Path}"${BS_LA_CFP_Glob}
    case $# in
      1)  ;; #< Should never match

      2)  case $2 in
          -*) BS_LA_CFP_GlobPath=./$2 ;;
           *) BS_LA_CFP_GlobPath=$2   ;;
          esac
          if BS_LA_CFP_Ignored=$(ls -d "${BS_LA_CFP_GlobPath}" 2>&1)
          then
            BS_LA_CFP_FoundPaths=1
            array_value "$2" || return $?
          fi ;;

      *)  shift #< Remove BS_DUMMY_PARAM
          BS_LA_CFP_FoundPaths=1
          for BS_LA_CFP_GlobPath
          do
            array_value "${BS_LA_CFP_GlobPath}" || return $?
          done ;;
    esac #<: case $# in

    case ${BS_LA_CFP_DotFiles} in 0) break ;; esac
  done #<: for BS_LA_CFP_Glob in '*' '.[!.]*' '..?*'

  #=========================================================
  # Trailing whitespace is always required (if there are
  # any elements)
  #=========================================================
  case ${BS_LA_CFP_FoundPaths:-0} in 1) echo ' ' ;; esac
} #<: `fn_bs_libarray_create_from_path()`

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
#:     ArrayValue=$(array_value 'Value')
#:     Array="$(
#:       for ArrayValue in "$@"
#:       do
#:         array_value "$ArrayValue"
#:       done
#:       echo ' '
#:     )"
#:
#_______________________________________________________________________________
array_value() { ## cSpell:Ignore BS_LA_Value_
  #=========================================================
  # Validate arguments
  #=========================================================
  case $# in
  1)  ;;
  *)  fn_bs_libarray_expected 'array_value' 'a single value'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # It is much faster to only invoke `sed` if required
  # to escape quote characters (even when taking into
  # account the cost of testing for the quote)
  # NOTES:
  # - due to quoting rules for shells '\\\\' results
  #   in a single escape in the final string
  #=========================================================
  case $1 in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Has `<apostrophe>` characters
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
    ;; #<: `*"'"*)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # No `<apostrophe>` characters
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      printf "'%s' \\\\\n" "$1"
    ;;
  esac #<: `case $1 in`
} #<: `array_value()`

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
#:     array_new [--reverse|--reversed|-r] [--] <ARRAY> [<VALUE>...]
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
#: `--` \[in]
#:
#: : Causes all remaining arguments to be interpreted
#:   as `ARRAY` followed by `VALUE`s (i.e. disables
#:   further option processing).
#:
#: `ARRAY` \[out:ref]
#:
#: : Variable that will contain the new array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
#:     Array=$(grep -e 'ERROR' /var/log/syslog | array_new)
#:     Array=$(array_new - "$Value1" ... "$ValueN")
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
#: - When given no arguments, will read array values from `STDIN`; if this is
#:   erroneously used without `STDIN` directed into the command this will block
#:   indefinitely.
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
array_new() { ## cSpell:Ignore BS_LA_New_
  #=========================================================
  #=========================================================
  # FROM STDIN
  #=========================================================
  #=========================================================
  case $# in
  0)  sed -e "s/'/'\\\\''/g
              s/^/'/
              s/\$/' \\\\/"
      echo ' '
      return ;;
  esac

  #=========================================================
  #=========================================================
  # FROM PARAMETERS
  #=========================================================
  #=========================================================

  #=========================================================
  # Process Arguments
  #=========================================================

  #---------------------------------------------------------
  # Option(s) must be first
  #---------------------------------------------------------
  BS_LA_New_Reverse=0
  while :
  do
    case ${1-} in
    '--reverse'|'--reversed'|'-reverse'|'-reversed'|'-r')
      BS_LA_New_Reverse=1
      shift ;;

    '--') shift; break ;;

       *) break ;;
    esac #<: `case ${1-} in`
  done

  #---------------------------------------------------------
  # Other arguments follow
  #---------------------------------------------------------
  case $# in
  0)  fn_bs_libarray_expected           \
        'array_new'                     \
        'a --reverse option (optional)' \
        'an array variable'             \
        'zero or more values'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  BS_LA_New_refArray=$1
  fn_bs_libarray_validate_name_hyphen \
    'array_new'                       \
    "${BS_LA_New_refArray}"            || return $?
  shift

  #=========================================================
  # Create the array
  #=========================================================
  case $#:${BS_LA_New_Reverse} in
  0:*)  BS_LA_New_Array='' ;;
  *:0)  BS_LA_New_Array=$(
            {
              fn_bs_libarray_create \
                'array_new'         \
                "$@"
            } && {
              echo ' '
            }
          ) || return $? ;;
  *:1)  BS_LA_New_Array=$(
            {
              fn_bs_libarray_create_count_reverse \
                'array_new'                       \
                $#                                \
                "$@"
            } && {
              echo ' '
            }
          ) || return $? ;;
  esac

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LA_New_refArray} in
  -) printf '%s\n' "${BS_LA_New_Array}" ;;                   #< OUTPUT
  *) eval "${BS_LA_New_refArray}=\${BS_LA_New_Array}" ;;      #< SAVE
  esac
} #<: `array_new()`

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
#:     Size=$(array_size 'Array')
#:     Size=$(array_size 'Array' -)
#:     array_size 'Array' 'Size'
#:
#_______________________________________________________________________________
array_size() { ## cSpell:Ignore BS_LA_Size_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  1)  BS_LA_Size_refArray=$1
      fn_bs_libarray_validate_name \
        'array_size'               \
        "${BS_LA_Size_refArray}"    || return $?
      BS_LA_Size_refSize='-' ;;

  2)  BS_LA_Size_refArray=$1
      fn_bs_libarray_validate_name \
        'array_size'               \
        "${BS_LA_Size_refArray}"    || return $?

      BS_LA_Size_refSize=$2
      fn_bs_libarray_validate_name_hyphen \
        'array_size'                      \
        "${BS_LA_Size_refSize}"            || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_size'          \
        'an array variable'   \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Unpack
  #=========================================================
  eval "BS_LA_Size_Array=\${${BS_LA_Size_refArray}-}"        || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Size_Array?} && shift" || return $?

  #=========================================================
  # Return value
  #=========================================================
  case ${BS_LA_Size_refSize} in
  -) printf '%d\n' $# ;;                #< OUTPUT
  *) eval "${BS_LA_Size_refSize}=$#" ;;  #< SAVE
  esac
} #<: `array_size()`

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
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   value is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_get 'Array' 4 'ValueVar'
#:     ValueVar=$(array_get 'Array' 4)
#:     ValueVar=$(array_get 'Array' 4 -)
#:
#: _NOTES_
#: <!-- -->
#:
#: - Supports zero-based, one-based, or negative indexing (see
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
array_get() { ## cSpell:Ignore BS_LA_Get_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  2)  BS_LA_Get_refArray=$1
      fn_bs_libarray_validate_name \
        'array_get'                \
         "${BS_LA_Get_refArray}"    || return $?

         BS_LA_Get_Index=$2
      BS_LA_Get_refValue='-' ;;

  3)  BS_LA_Get_refArray=$1
      fn_bs_libarray_validate_name \
        'array_get'                \
         "${BS_LA_Get_refArray}"    || return $?

         BS_LA_Get_Index=$2
      BS_LA_Get_refValue=$3
      fn_bs_libarray_validate_name_hyphen \
        'array_get'                       \
        "${BS_LA_Get_refValue}"            || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_get'           \
        'an array variable'   \
        'an array index'      \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Unpack
  #=========================================================
  eval "BS_LA_Get_Array=\${${BS_LA_Get_refArray}-}"     || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Get_Array?} && shift" || return $?

  #=========================================================
  # Validate the array
  #=========================================================
  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_get'               \
        'can not "get" value from empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # Process and validate the index
  # NOTES: Resulting `BS_LA_Get_Index` is zero-based
  #=========================================================
  fn_bs_libarray_process_index \
    'array_get'                \
    'BS_LA_Get_Index'           \
    $#                         || return $?

  #=========================================================
  # Lookup the value
  #=========================================================
  BS_LA_Get_Value=;
  case ${c_BS_LIBARRAY_CFG__use_multidigit_param:-0} in
  1)  eval "BS_LA_Get_Value=\${$((BS_LA_Get_Index + 1))}" ;;
  0)  fn_bs_libarray_get_multidigit_param  \
        'BS_LA_Get_Value'                   \
        $((BS_LA_Get_Index + 1))            \
        "$@"                               ;;
  esac || return $?

  #=========================================================
  # Return value
  #=========================================================
  case ${BS_LA_Get_refValue} in
  -) printf '%s\n' "${BS_LA_Get_Value}" ;;                   #< OUTPUT
  *) eval "${BS_LA_Get_refValue}=\${BS_LA_Get_Value}" ;;      #< SAVE
  esac
} #<: `array_get()`

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
#: - Supports zero-based, one-based, or negative indexing (see
#:   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Internal indexes are zero-based, as shell parameters are one-based this
#.   means some operations will add 1 to the index used.
#.
#_______________________________________________________________________________
array_set() { ## cSpell:Ignore BS_LA_Set_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  3)  BS_LA_Set_refArray=$1
         BS_LA_Set_Index=$2
      BS_LA_Set_NewValue=$3 ;;
  *)  fn_bs_libarray_expected \
        'array_set'           \
        'an array variable'   \
        'an array index'      \
        'a value'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # Validate the reference
  #=========================================================
  fn_bs_libarray_validate_name \
    'array_set'                \
    "${BS_LA_Set_refArray}"     || return $?

  #=========================================================
  # Unpack
  #=========================================================
  eval "BS_LA_Set_Array=\${${BS_LA_Set_refArray}-}"        || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Set_Array} && shift" || return $?

  #=========================================================
  # Validate the array
  #=========================================================
  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_set'               \
        'can not "set" value in empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # Process and validate the index
  # NOTES: The returned `BS_LA_Set_Index` is zero-based
  #=========================================================
  fn_bs_libarray_process_index \
    'array_set'                \
    'BS_LA_Set_Index'           \
    $#                         || return $?

  #=========================================================
  # Set the new value:
  #  - resave up to the indexed value
  #  - skip the set value
  #  - set the new value
  #  - save any remaining values
  #
  # NOTE: This uses `test` rather than `case` as some shells
  #       do not support the use of `case` inside `$(...)`
  #       (applies at least to `posh`).
  #=========================================================
  BS_LA_Set_Array=$(
      while [ "${BS_LA_Set_Index}" -gt 0 ]
      do
        array_value "$1" || return $?
        shift
        BS_LA_Set_Index=$((BS_LA_Set_Index - 1))
      done #<: `while [ "${BS_LA_Set_Index}" -gt 0 ]`

      shift
      array_value "${BS_LA_Set_NewValue}" || return $?

      {
        fn_bs_libarray_create \
          'array_set'         \
          "$@"
      } && {
        echo ' '
      }
    ) || return $?

  #=========================================================
  # SAVE
  #=========================================================
  eval "${BS_LA_Set_refArray}=\${BS_LA_Set_Array}"
} #<: `array_set()`

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
#: - Supports zero-based, one-based, or negative indexing (see
#:   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Internal indexes are zero-based, as shell parameters are one-based this
#.   means some operations will add 1 to the index used.
#.
#_______________________________________________________________________________
array_insert() { ## cSpell:Ignore BS_LA_Insert_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  0|1|2)  fn_bs_libarray_expected \
            'array_insert'        \
            'an array variable'   \
            'an array index'      \
            'one or more values'
          return "${c_BS_LIBARRAY__EX_USAGE}"
  ;;
  esac

  BS_LA_Insert_refArray=$1
  fn_bs_libarray_validate_name \
    'array_insert'             \
    "${BS_LA_Insert_refArray}"  || return $?
  shift

  BS_LA_Insert_Index=$1
  shift

  #=========================================================
  # Create a new array from the values to insert (this
  # needs done here as the old array must be unpacked and
  # will overwrite the positional parameters)
  #
  # NOTE: This is **not** a true array - the trailing
  #       whitespace is omitted. This will be added later.
  #=========================================================
  BS_LA_Insert_Inserted=$(fn_bs_libarray_create 'array_insert' "$@") || return $?

  #=========================================================
  # Unpack the existing array
  #=========================================================
  eval "BS_LA_Insert_Array=\${${BS_LA_Insert_refArray}-}"  || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Insert_Array?} && shift" || return $?

  #=========================================================
  # Process and validate the index
  # NOTES: Resulting `BS_LA_Insert_Index` is zero-based
  #=========================================================
  fn_bs_libarray_process_index \
    'array_insert'             \
    'BS_LA_Insert_Index'        \
    $#                         || return $?

  #=========================================================
  # Insert the values:
  #   - save everything up to the insert index
  #   - insert the new values
  #   - save any remaining values
  #
  # NOTE: This uses `test` rather than `case` as some shells
  #       do not support the use of `case` inside `$(...)`
  #       (applies at least to `posh`).
  #=========================================================
  BS_LA_Insert_Array=$(
      while [ "${BS_LA_Insert_Index}" -gt 0 ]
      do
        array_value "$1" || return $?
        shift
        BS_LA_Insert_Index=$((BS_LA_Insert_Index - 1))
      done #<: `while [ "${BS_LA_Insert_Index}" -gt 0 ]`

      printf '%s\n' "${BS_LA_Insert_Inserted}"

      {
        fn_bs_libarray_create \
          'array_insert'      \
          "$@"
      } && {
        echo ' '
      }
    ) || return $?

  #=========================================================
  # Save
  #=========================================================
  eval "${BS_LA_Insert_refArray}=\${BS_LA_Insert_Array}"
} #<: `array_insert()`

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
#:   `-lt`, `-le`, `-like`, `-notlike`, `-bre`, `-notbre`,
#:   `-ere`, or `-notere`.
#:
#: `EXPRESSION` \[in]
#:
#: : Value to use with `PRIMARY`.
#: : Can be null.
#: : _EXPECTS_:
#:   - a _string_ when `PRIMARY` is `=`, or `!=`
#:   - a _number_ when `PRIMARY` is `-eq`, `-ne`,
#:     `-gt`, `-ge`,  `-lt`, or `-le`
#:   - a _wildcard pattern_ when `PRIMARY` is `-like`, or
#:     `-notlike`.
#:   - a _BRE_ when `PRIMARY` is `-bre`, or `-notbre`.
#:   - an _ERE_ when `PRIMARY` is `-ere`, or `-notere`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_remove 'Array' 2
#:     array_remove 'Array' '4:7'
#:     array_remove 'Array' -bre '.*an error.*'
#:     array_remove 'Array' -ere '.*an error.*|.*a warning.*'
#:
#: _BREAKING CHANGES_
#: <!-- --------- -->
#:
#: As of `v2.0.0`:
#:
#: - `-like`/`-notlike`: no longer support the `|` (`<vertical-line>`) operator;
#: - `-eq`/`-ne`: _require_ numerical values.
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - Removal requires unpacking then rebuilding the array, as such it is likely
#:   to be a relatively slow operation and should be avoided in performance
#:   critical sections of code.
#: - Not all wildcard patterns, _BRE_, or _ERE_ can be used portably.
#: - For _wildcard patterns_ the locale in effect is that of the shell as invoked -
#:   _it is **not** possible to change the locale of a running shell_.
#: - In some cases wildcard pattern matches will be implemented using fallback
#:   code - this is unavoidable as not all implementations provide the expected
#:   behavior for all expressions. See
#:   ["PATTERN MATCHING"](./README.MD#pattern-matching),
#:   [`BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_MBC`](#bs_libarray_config_shell_supports_mbc),
#:   and [`BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libarray_config_shell_supports_portable_glob).
#:
#: _NOTES_
#: <!-- -->
#:
#: - Several aliases are provided: `-[not]match` and `-[not]matchbre` for
#:   `-[not]bre`; `-[not]matchex` and `-[not]matchere` for
#:   `-[not]ere`. Additionally, `=~` for `-ere` and `!~` for `-notere`.
#: - `-eq`, `-ne`, `-gt`, `-ge`, `-lt`, and `-le` are implemented using `test`
#:   and behave as with the `test` command.
#: - `=` and `!=` are functionally identical to the `test` operators of the same
#:   name, but do _not_ use `test`.
#: - `-like` and `-notlike` support ["Pattern Matching Notation"][posix_glob]
#:   (aka globs or wildcards).
#: - `-bre` and `-notbre` support ["Basic Regular Expressions"][posix_bre].
#: - `-ere` and `-notere` support ["Extended Regular Expressions"][posix_ere].
#: - `-bre`, `-notbre`, `-ere`, and `-notere` may also be specified with the
#:   suffix `:s` or `:m` (e.g. `-bre:s`), where `s` indicates _Single Line Mode_
#:   and `m` indicates _Multi-line Mode_ (and is the default). Using `s` can
#:   have significant performance advantages, but the regular expressions can
#:   **not** match `<newline>` characters explicitly (e.g. `\n`) _or_ implicitly
#:   (e.g. `.`). _Multi-line Mode_ is implemented using `sed` or `awk`, while
#:   _Single Line Mode_ uses `grep` or `grep -E` - it is therefore possible that
#:   the supported expressions differ between these modes.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Earlier versions of this (i.e. libarray.sh v1.x.x) were all broken.
#.   This reworked version is significantly more robust and fixes most (all?) of
#.   the issues previously present. The current version is also faster in
#.   some cases, while most other cases should have similar performance.
#.
#_______________________________________________________________________________
array_remove() { ## cSpell:Ignore BS_LA_Remove_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # REMOVE by RANGE or INDEX
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2)
      BS_LA_Remove_refArray=$1
      fn_bs_libarray_validate_name \
        'array_remove'             \
        "${BS_LA_Remove_refArray}"  || return $?

       BS_LA_Remove_Range=$2
       fn_bs_libarray_remove_by_range \
        'array_remove'                \
        "${BS_LA_Remove_refArray}"     \
        "${BS_LA_Remove_Range}"
    ;; #<: `2)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # REMOVE by FILTER
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    3)
      BS_LA_Remove_refArray=$1
      fn_bs_libarray_validate_name \
        'array_remove'             \
        "${BS_LA_Remove_refArray}"  || return $?

      BS_LA_Remove_Primary=$2
         BS_LA_Remove_Expr=$3

      # Unpack the array
      eval "BS_LA_Remove_Array=\${${BS_LA_Remove_refArray}-}"      || return $?
      eval "set 'BS_DUMMY_PARAM' ${BS_LA_Remove_Array?} && shift" || return $?

      case $# in
        0)  BS_LA_Remove_Array='' ;;
        *)  BS_LA_Remove_Array=$(
                fn_bs_libarray_remove_by_filter \
                  'array_remove'                \
                  "${BS_LA_Remove_Primary}"      \
                  "${BS_LA_Remove_Expr}"         \
                  "$@"
              ) || return $?

            # In some cases, the above command can add
            # whitespace for empty arrays - it's easier to
            # remove here than deal with elsewhere.
            case ${BS_LA_Remove_Array} in
            "${c_BS_LIBARRAY__newline} "|' ') BS_LA_Remove_Array=; ;;
            esac
        ;;
      esac

      # Save the new array
      eval "${BS_LA_Remove_refArray}=\${BS_LA_Remove_Array}"  #< SAVE
    ;; #<: `3)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      fn_bs_libarray_expected \
        'array_remove'        \
        'an array variable'   \
        'an index, range, or glob'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;; #<: `*)`
  esac #<: `case $# in`
} #<: `array_remove()`

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
array_push() { ## cSpell:Ignore BS_LA_Push_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    0)  fn_bs_libarray_expected \
          'array_push'          \
          'an array variable'   \
          'zero or more values'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # No values, but still need to validate array name
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1)  fn_bs_libarray_validate_name \
          'array_push'               \
          "$1"                       || return $?
        return ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # One or more values
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  BS_LA_Push_refArray=$1
        fn_bs_libarray_validate_name \
          'array_push'               \
          "${BS_LA_Push_refArray}"    || return $?
        shift ;;
  esac #<: `case $# in`

  #=========================================================
  # Create an array from new values
  #=========================================================
  BS_LA_Push_New=$(
      {
        fn_bs_libarray_create \
          'array_push'        \
          "$@"
      } && {
        echo ' '
      }
    ) || return $?

  #=========================================================
  # Save both old array and new array concatenated
  #=========================================================
  eval "${BS_LA_Push_refArray}=\${${BS_LA_Push_refArray}-}\${BS_LA_Push_New}"
} #<: `array_push()`

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
array_pop() { ## cSpell:Ignore BS_LA_Pop_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    2)  BS_LA_Pop_refArray=$1
        fn_bs_libarray_validate_name \
          'array_pop'                \
          "${BS_LA_Pop_refArray}"     || return $?

        BS_LA_Pop_refValue=$2
        fn_bs_libarray_validate_name \
          'array_pop'                \
          "${BS_LA_Pop_refValue}"     || return $?
    ;;
    *)  fn_bs_libarray_expected \
          'array_pop'           \
          'an array variable'   \
          'an output variable'
        return "${c_BS_LIBARRAY__EX_USAGE}"
    ;;
  esac

  #=========================================================
  #
  #=========================================================
  eval "BS_LA_Pop_Array=\${${BS_LA_Pop_refArray}-}"        || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Pop_Array} && shift" || return $?

  #=========================================================
  #
  #=========================================================
  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_pop'               \
        'can not "pop" from empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # Save the popped value
  #=========================================================
  case ${c_BS_LIBARRAY_CFG__use_multidigit_param:-0} in
  1)  eval "${BS_LA_Pop_refValue}=\${$#}"   ;;
  0)  fn_bs_libarray_get_multidigit_param  \
        "${BS_LA_Pop_refValue}"             \
        $#                                 \
        "$@"                               ;;
  esac || return $?

  #=========================================================
  # Resave everything else
  #=========================================================
  case $# in
    0|1)
      eval "${BS_LA_Pop_refArray}="                          #< SAVE (EMPTY)
    ;;

    *)
      BS_LA_Pop_Array=$(
          {
            fn_bs_libarray_create_count \
              'array_pop'               \
              $(($# - 1))               \
              "$@"
          } && {
            echo ' '
          }
        ) || return $?
      eval "${BS_LA_Pop_refArray}=\${BS_LA_Pop_Array}"        #< SAVE
    ;;
  esac
} #<: `array_pop()`

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
array_unshift() { ## cSpell:Ignore BS_LA_Unshift_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    0)  fn_bs_libarray_expected \
          'array_unshift'       \
          'an array variable'   \
          'zero or more values'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # No values, but still need to validate array name
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1)  fn_bs_libarray_validate_name \
          'array_unshift'            \
          "$1"                       || return $?
        return ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # One or more values
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  BS_LA_Unshift_refArray=$1
        fn_bs_libarray_validate_name \
          'array_unshift'            \
          "${BS_LA_Unshift_refArray}" || return $?
        shift ;;
  esac #<: `case $# in`

  #=========================================================
  # Create an array from new values
  #=========================================================
  BS_LA_Unshift_New=$(
      {
        fn_bs_libarray_create \
          'array_unshift'     \
          "$@"
      } && {
        echo ' '
      }
    ) || return $?

  #=========================================================
  # Save both old array and new array concatenated
  #=========================================================
  eval "${BS_LA_Unshift_refArray}=\${BS_LA_Unshift_New}\${${BS_LA_Unshift_refArray}-}"
} #<: `array_unshift()`

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
array_shift() { ## cSpell:Ignore BS_LA_Shift_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  2)  BS_LA_Shift_refArray=$1
      fn_bs_libarray_validate_name \
        'array_shift'              \
        "${BS_LA_Shift_refArray}"   || return $?

      BS_LA_Shift_refValue=$2
      fn_bs_libarray_validate_name \
        'array_shift'              \
        "${BS_LA_Shift_refValue}"   || return $? ;;
  *)  fn_bs_libarray_expected \
        'array_shift'         \
        'an array variable'   \
        'an output variable'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  #
  #=========================================================
  eval "BS_LA_Shift_Array=\${${BS_LA_Shift_refArray}-}"      || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Shift_Array} && shift" || return $?

  #=========================================================
  #
  #=========================================================
  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_shift'             \
        'can not "shift" from empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # Save the shifted value
  #=========================================================
  eval "${BS_LA_Shift_refValue}=\$1" || return $?

  #=========================================================
  # Resave everything else
  #=========================================================
  case $# in
    0|1)
      eval "${BS_LA_Shift_refArray}="                        #< SAVE (EMPTY)
    ;;

    *)
      shift
      BS_LA_Shift_Array=$(
          {
            fn_bs_libarray_create \
              'array_shift'       \
              "$@"
          } && {
            echo ' '
          }
        ) || return $?
      eval "${BS_LA_Shift_refArray}=\${BS_LA_Shift_Array}"    #< SAVE
    ;;
  esac
} #<: `array_shift()`

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
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
#:     ReversedArrayVar=$(array_reverse 'Array' -)
#:
#_______________________________________________________________________________
array_reverse() { ## cSpell:Ignore BS_LA_Reverse_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  1)  BS_LA_Reverse_refArray=$1
      fn_bs_libarray_validate_name \
        'array_reverse'            \
        "${BS_LA_Reverse_refArray}" || return $?

      BS_LA_Reverse_refReversed=${BS_LA_Reverse_refArray} ;;

  2)  BS_LA_Reverse_refArray=$1
      fn_bs_libarray_validate_name \
        'array_reverse'            \
        "${BS_LA_Reverse_refArray}" || return $?

      BS_LA_Reverse_refReversed=$2
      fn_bs_libarray_validate_name_hyphen \
        'array_reverse'                   \
        "${BS_LA_Reverse_refReversed}"     || return $? ;;

  *)  fn_bs_libarray_expected \
        'array_reverse'       \
        'an array variable'   \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  eval "BS_LA_Reverse_Array=\${${BS_LA_Reverse_refArray}-}"    || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Reverse_Array} && shift" || return $?

  #=========================================================
  #
  #=========================================================
  case $# in
  0)  BS_LA_Reverse_Array='' ;;
  *)  BS_LA_Reverse_Array=$(
          {
            fn_bs_libarray_create_count_reverse \
              'array_reverse'                   \
              $#                                \
              "$@"
          } && {
            echo ' '
          }
        ) || return $? ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_Reverse_refReversed} in
  -) printf '%s\n' "${BS_LA_Reverse_Array}" ;;                       #< OUTPUT
  *) eval "${BS_LA_Reverse_refReversed}=\${BS_LA_Reverse_Array}" ;;   #< SAVE
  esac
} #<: `array_reverse()`

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
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
#: _NOTES_
#: <!-- -->
#:
#: - Supports zero-based, one-based, or negative indexing (see
#:   [`BS_LIBARRAY_CONFIG_START_INDEX_ONE`](#bs_libarray_config_start_index_one)).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - See [`fn_bs_libarray_process_range`](#fn_bs_libarray_process_range)
#.   for further details of the supported formats for `RANGE`.
#.
#_______________________________________________________________________________
array_slice() { ## cSpell:Ignore BS_LA_Slice_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  2)  BS_LA_Slice_refArray=$1
      fn_bs_libarray_validate_name \
        'array_slice'              \
        "${BS_LA_Slice_refArray}"   || return $?

         BS_LA_Slice_Range=$2
      BS_LA_Slice_refSlice='-' ;;

  3)  BS_LA_Slice_refArray=$1
      fn_bs_libarray_validate_name \
        'array_slice'              \
        "${BS_LA_Slice_refArray}"   || return $?

         BS_LA_Slice_Range=$2
      BS_LA_Slice_refSlice=$3
      fn_bs_libarray_validate_name_hyphen \
        'array_slice'                     \
        "${BS_LA_Slice_refSlice}"          || return $? ;;

  *)  fn_bs_libarray_expected     \
        'array_slice'             \
        'an array variable'       \
        'a slice range'           \
        'an output variable (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  eval "BS_LA_Slice_Array=\${${BS_LA_Slice_refArray}-}"      || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Slice_Array} && shift" || return $?

  #=========================================================
  #
  #=========================================================
  case $# in
  0)  fn_bs_libarray_invalid_args \
        'array_slice'             \
        'can not "slice" empty array'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # Process Slice Range...
  #=========================================================
  BS_LA_Slice_Start=;   BS_LA_Slice_Length=;
  fn_bs_libarray_process_range \
    'array_slice'              \
    'BS_LA_Slice_Start'         \
    'BS_LA_Slice_Length'        \
    "${BS_LA_Slice_Range}"      \
    $#                         || return $?

  #=========================================================
  # `shift` to the start of the slice
  #=========================================================
  case ${c_BS_LIBARRAY_CFG__use_shift_n:-0} in
  0)  while : #<: `[ "${BS_LA_Slice_Start}" -gt 0 ]`
      do
        #> LOOP TEST ---------------------------------------
        case ${BS_LA_Slice_Start} in 0) break ;; esac #<: `[ "${BS_LA_Slice_Start}" -gt 0 ]`
        #< -------------------------------------------------

        shift
        BS_LA_Slice_Start=$((BS_LA_Slice_Start - 1))
      done ;;
  1) shift "${BS_LA_Slice_Start}" ;;
  esac

  #=========================================================
  # Create Slice...
  #=========================================================
  case ${BS_LA_Slice_Length} in
  -*) BS_LA_Slice_Array=$(
          {
            fn_bs_libarray_create_count_reverse \
              'array_slice'                     \
              $(( -BS_LA_Slice_Length ))         \
              "$@"
          } && {
            echo ' '
          }
        ) || return $? ;;
   *) BS_LA_Slice_Array=$(
          {
            fn_bs_libarray_create_count \
              'array_slice'             \
              "${BS_LA_Slice_Length}"    \
              "$@"
          } && {
            echo ' '
          }
        ) || return $?;;
  esac

  #=========================================================
  # Return values
  #=========================================================
  case ${BS_LA_Slice_refSlice} in
  -) printf '%s\n' "${BS_LA_Slice_Array}" ;;                 #< OUTPUT
  *) eval "${BS_LA_Slice_refSlice}=\${BS_LA_Slice_Array}" ;;  #< SAVE
  esac
} #<: `array_slice()`

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
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
#:     SortedArrayVar=$(array_sort 'Array' - -r)
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - Because the `sort` command works on lines, values containing `<newline>`
#:   characters have to be modified to be a single line. This _will_ affect sort
#:   order in some cases (i.e. the output may _not_ be strictly
#:   lexicographically correct with regards to any embedded `<newline>`
#:   characters), however the sort order of these values _will_ be stable.
#:
#_______________________________________________________________________________
array_sort() { ## cSpell:Ignore BS_LA_Sort_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    0)
      fn_bs_libarray_expected           \
        'array_sort'                    \
        'an array variable'             \
        'an output variable (optional)' \
        'sort arguments (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;; #<: `0)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ARRAY ONLY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1)
      BS_LA_Sort_refArray=$1
      fn_bs_libarray_validate_name \
        'array_sort'               \
        "${BS_LA_Sort_refArray}"    || return $?
      shift

      BS_LA_Sort_refSorted=${BS_LA_Sort_refArray}
    ;; #<: `1)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # MULTIPLE ARGUMENTS
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      BS_LA_Sort_refArray=$1
      fn_bs_libarray_validate_name \
        'array_sort'               \
        "${BS_LA_Sort_refArray}"    || return $?
      shift

      case $1 in
       --)  BS_LA_Sort_refSorted=${BS_LA_Sort_refArray}
            shift ;;
      -?*)  BS_LA_Sort_refSorted=${BS_LA_Sort_refArray} ;;
        *)  BS_LA_Sort_refSorted=$1
            fn_bs_libarray_validate_name_hyphen \
              'array_sort'                      \
              "${BS_LA_Sort_refSorted}"          || return $?
            shift
            case ${1-} in --) shift ;; esac ;;
      esac #<: `case $1 in`
    ;; #<: `*)`
  esac #<: `case $# in`

  eval "BS_LA_Sort_Array=\${${BS_LA_Sort_refArray}-}" || return $?

  #=========================================================
  # Early out if empty array
  #=========================================================
  case ${BS_LA_Sort_Array:+1} in
  1) ;; *)  case ${BS_LA_Sort_refSorted} in
            -) echo ;;                                      #< OUTPUT (EMPTY)
            *) eval "${BS_LA_Sort_refSorted}=;" ;;           #< SAVE (EMPTY)
            esac
            return ;;
  esac

  #=========================================================
  # Sort the array
  #=========================================================
  BS_LA_Sort_SortedArray=$(
      {
        # Convert values to be on single lines and print them all.
        # See [`fn_bs_libarray_escape_for_sort`](#fn_bs_libarray_escape_for_sort)
        fn_bs_libarray_escape_for_sort \
          'array_sort'                 \
          'BS_LA_Sort_Array'
      } | {
        # Sort the flattened values
        sort ${1+"$@"}
      } | {
        # Undo the conversion and turn each
        # value back into an array value
        sed -e "
            s/'/'\\\\''/g
            s/^/'/
            s/\$/' \\\\/
            s/ \\\\n/\\
/g
            s/\\\\\\\\/\\\\/g"
        echo ' '
      }
    )

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_Sort_refSorted} in
  -) printf '%s\n' "${BS_LA_Sort_SortedArray}" ;;                #< OUTPUT
  *) eval "${BS_LA_Sort_refSorted}=\${BS_LA_Sort_SortedArray}" ;; #< SAVE
  esac
} #<: `array_sort()`

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
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
#:   `-lt`, `-le`, `-like`, `-notlike`, `-bre`, `-notbre`,
#:   `-ere`, or `-notere`.
#: : If not specified `=` is used.
#:
#: `EXPRESSION` \[in]
#:
#: : Value to use with `PRIMARY`.
#: : Can be null.
#: : _EXPECTS_:
#:   - a _string_ when `PRIMARY` is `=`, or `!=`
#:   - a _number_ when `PRIMARY` is `-eq`, `-ne`,
#:     `-gt`, `-ge`,  `-lt`, or `-le`
#:   - a _wildcard pattern_ when `PRIMARY` is `-like`, or
#:     `-notlike`.
#:   - a _BRE_ when `PRIMARY` is `-bre`, or `-notbre`.
#:   - an _ERE_ when `PRIMARY` is `-ere`, or `-notere`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     while array_search 'Array' 'Location' -like '*an error*'
#:     do
#:       ...
#:     done
#:
#: _BREAKING CHANGES_
#: <!-- --------- -->
#:
#: As of `v2.0.0`:
#:
#: - `-like`/`-notlike`: no longer support the `|` (`<vertical-line>`) operator;
#:   can not (portably) use the `\` (`<backslash>`) character (in any way).
#: - the `-bre`/`-notbre` primaries: no longer use `expr`; are no longer
#:   anchored to the start of a value.
#: - the `-ere`/`-notere` primaries: no longer anchored to the start of a value.
#: - `-eq`/`-ne`: _require_ numerical values.
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - Not all wildcard patterns, _BRE_, or _ERE_ can be used portably.
#: - For _wildcard patterns_ the locale in effect is that of the shell as invoked -
#:   _it is **not** possible to change the locale of a running shell_.
#: - In some cases wildcard pattern matches will be implemented using fallback
#:   code - this is unavoidable as not all implementations provide the expected
#:   behavior for all expressions. See
#:   ["PATTERN MATCHING"](./README.MD#pattern-matching),
#:   [`BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_MBC`](#bs_libarray_config_shell_supports_mbc),
#:   and [`BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libarray_config_shell_supports_portable_glob).
#:
#: _NOTES_
#: <!-- -->
#:
#: - See [`array_contains`](#array_contains) for an alternative when INDEX is
#:   not required.
#: - Several aliases are provided: `-[not]match` and `-[not]matchbre` for
#:   `-[not]bre`; `-[not]matchex` and `-[not]matchere` for
#:   `-[not]ere`. Additionally, `=~` for `-ere` and `!~` for `-notere`.
#: - `-eq`, `-ne`, `-gt`, `-ge`, `-lt`, and `-le` are implemented using `test`
#:   and behave as with the `test` command.
#: - `=` and `!=` are functionally identical to the `test` operators of the same
#:   name, but do _not_ use `test`.
#: - `-like` and `-notlike` support ["Pattern Matching Notation"][posix_glob]
#:   (aka globs or wildcards).
#: - `-bre` and `-notbre` support ["Basic Regular Expressions"][posix_bre].
#: - `-ere` and `-notere` support ["Extended Regular Expressions"][posix_ere].
#: - `-bre`, `-notbre`, `-ere`, and `-notere` may also be specified with the
#:   suffix `:s` or `:m` (e.g. `-bre:s`), where `s` indicates _Single Line Mode_
#:   and `m` indicates _Multi-line Mode_ (and is the default). Using `s` can
#:   have significant performance advantages, but the regular expressions can
#:   **not** match `<newline>` characters explicitly (e.g. `\n`) _or_ implicitly
#:   (e.g. `.`). _Multi-line Mode_ is implemented using `sed` or `awk`, while
#:   _Single Line Mode_ uses `grep` or `grep -E` - it is therefore possible that
#:   the supported expressions differ between these modes.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Earlier versions of this (i.e. libarray.sh v1.x.x) were all broken.
#.   This reworked version is significantly more robust and fixes most (all?) of
#.   the issues previously present. The current version is also faster in
#.   some cases, while most other cases should have similar performance.
#. - Found index is **ONE** based, regardless of configuration - this simplifies
#.   some code (while for other code there is no real difference).
#.
#_______________________________________________________________________________
array_search() { ## cSpell:Ignore BS_LA_Search_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # WITHOUT INDEX AND PRIMARY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2)  BS_LA_Search_refArray=$1
        BS_LA_Search_refIndex='-'
         BS_LA_Search_Primary='='
            BS_LA_Search_Expr=$2 ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # WITHOUT INDEX OR PRIMARY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    3)  BS_LA_Search_refArray=$1
        case $2 in
        '-'?*|'='|'!='|'=~'|'!~')
          BS_LA_Search_refIndex='-'
           BS_LA_Search_Primary=$2 ;;
        *)
          BS_LA_Search_refIndex=$2
           BS_LA_Search_Primary='=' ;;
        esac
        BS_LA_Search_Expr=$3 ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # WITH ALL PARAMETERS
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    4)  BS_LA_Search_refArray=$1
        BS_LA_Search_refIndex=$2
         BS_LA_Search_Primary=$3
            BS_LA_Search_Expr=$4 ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  fn_bs_libarray_expected                 \
          'array_search'                        \
          'an array variable'                   \
          'an output index variable (optional)' \
          'a primary (optional)'                \
          'an expression'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  fn_bs_libarray_validate_name \
    'array_search'             \
    "${BS_LA_Search_refArray}"  || return $?

  #=========================================================
  #
  #=========================================================
  eval "BS_LA_Search_Array=\${${BS_LA_Search_refArray}-}"      || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Search_Array?} && shift" || return $?

  #=========================================================
  # Skip elements
  #=========================================================
  case ${BS_LA_Search_refIndex} in
  [!-]*)
    fn_bs_libarray_validate_name \
      'array_search'             \
      "${BS_LA_Search_refIndex}"  || return $?

    eval "BS_LA_Search_SearchStart=\${${BS_LA_Search_refIndex}-}" || return $?

    case ${BS_LA_Search_SearchStart:+1} in
    1)  fn_bs_libarray_process_index \
          'array_search'             \
          'BS_LA_Search_SearchStart'  \
          $#                         || return $?

        BS_LA_Search_SearchStart=$((BS_LA_Search_SearchStart + 1))

        case ${c_BS_LIBARRAY_CFG__use_shift_n:-0} in
        1)  shift "${BS_LA_Search_SearchStart}" ;;
        0)  BS_LA_Search_ShiftCount=${BS_LA_Search_SearchStart}
            while : #<: `[ "${BS_LA_Search_ShiftCount}" -gt 0 ]`
            do
              #> LOOP TEST ---------------------------------
              case ${BS_LA_Search_ShiftCount} in 0) break ;; esac #<: `[ "${BS_LA_Search_ShiftCount}" -gt 0 ]`
              #< -------------------------------------------
              shift
              BS_LA_Search_ShiftCount=$((BS_LA_Search_ShiftCount - 1))
            done ;;
        esac

        BS_LA_Search_SearchStart=$((BS_LA_Search_SearchStart + c_BS_LIBARRAY_CFG__start_index)) ;;
    *)  BS_LA_Search_SearchStart=${c_BS_LIBARRAY_CFG__start_index} ;;
    esac #<: `case ${BS_LA_Search_SearchStart:+1} in`
  ;;
  esac #<: `case ${BS_LA_Search_refIndex} in`

  #=========================================================
  # Search the remaining array
  #=========================================================
  BS_LA_Search_Found=;
  fn_bs_libarray_find_index   \
    'array_search'            \
    'BS_LA_Search_Found'       \
    "${BS_LA_Search_Primary}"  \
    "${BS_LA_Search_Expr}"     \
    "$@"                      || return $?

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_Search_Found:+1} in
  1)  BS_LA_Search_Found=$((BS_LA_Search_Found + BS_LA_Search_SearchStart - 1))
      BS_LA_Search_ExitCode=0 ;;
  *)  BS_LA_Search_Found=;
      BS_LA_Search_ExitCode=1 ;;
  esac

  #=========================================================
  # Report the results
  #=========================================================
  case ${BS_LA_Search_refIndex} in
  -) printf '%s\n' "${BS_LA_Search_Found}" ;;                   #< OUTPUT
  *) eval "${BS_LA_Search_refIndex}=\${BS_LA_Search_Found}" ;;  #< SAVE
  esac

  return ${BS_LA_Search_ExitCode}
} #<: `array_search()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_contains`
#:
#: Identical to [`array_search`](#array_search) except the index is not returned
#: (allowing this to be much faster when `PRIMARY` is `=`, or `!=`).
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
#:     if array_contains 'Array' -like '*an error*'
#:     then
#:       ...
#:     fi
#:
#: _NOTES_
#: <!-- -->
#:
#: - As for [`array_search`](#array_search).
#:
#_______________________________________________________________________________
array_contains() { ## cSpell:Ignore BS_LA_Contains_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # WITHOUT PRIMARY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2)  BS_LA_Contains_refArray=$1
        fn_bs_libarray_validate_name  \
          'array_contains'            \
          "${BS_LA_Contains_refArray}" || return $?

        BS_LA_Contains_Primary='='
           BS_LA_Contains_Expr=$2 ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # WITH ALL PARAMETERS
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    3)  BS_LA_Contains_refArray=$1
        fn_bs_libarray_validate_name  \
          'array_contains'            \
          "${BS_LA_Contains_refArray}" || return $?

        BS_LA_Contains_Primary=$2
           BS_LA_Contains_Expr=$3 ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  fn_bs_libarray_expected  \
          'array_contains'       \
          'an array variable'    \
          'a primary (optional)' \
          'an expression'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Checking if an array contains/does not contain an exact
  # value can be very fast and does not required the array
  # is unpacked, so deal with those operations as a special
  # case
  #=========================================================
  case ${BS_LA_Contains_Primary} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # STRING EQUALITY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '=')
      BS_LA_Contains_Expr=$(array_value "${BS_LA_Contains_Expr}") || return $?

      eval "BS_LA_Contains_Array=\${${BS_LA_Contains_refArray}-}" || return $?

      case ${BS_LA_Contains_Array?} in
      *"${BS_LA_Contains_Expr}"*) return 0 ;;
                              *) return 1 ;;
      esac
    ;; #<: `'=')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # STRING INEQUALITY
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '!=')
      BS_LA_Contains_Expr=$(array_value "${BS_LA_Contains_Expr}") || return $?

      eval "BS_LA_Contains_Array=\${${BS_LA_Contains_refArray}-}" || return $?

      case ${BS_LA_Contains_Array?} in
      *"${BS_LA_Contains_Expr}"*) return 1 ;;
                              *) return 0 ;;
      esac
    ;; #<: `'!=')`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # OTHER
    #
    # Nothing much to be gained by having specialized
    # versions of the other operators, so delegate to
    # [`fn_bs_libarray_find_index`](#fn_bs_libarray_find_index)
    # - but ignore the found index.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      # Unpack the array
      eval "BS_LA_Contains_Array=\${${BS_LA_Contains_refArray}-}"     || return $?
      eval "set 'BS_DUMMY_PARAM' ${BS_LA_Contains_Array?} && shift"  || return $?

      BS_LA_Contains_IgnoredIndex=;
      fn_bs_libarray_find_index       \
        'array_contains'              \
        'BS_LA_Contains_IgnoredIndex'  \
        "${BS_LA_Contains_Primary}"    \
        "${BS_LA_Contains_Expr}"       \
        "$@"                          || return $?

      case ${BS_LA_Contains_IgnoredIndex:+1} in
      1) return 0 ;;
      *) return 1 ;;
      esac
    ;; #<: `*)`
  esac #<: `case ${BS_LA_Contains_Primary} in`
} #<: `array_contains()`

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
#: : Can contain any escape sequences that `printf`
#:   understands, however `%` (`<percent-sign>`)
#:   characters will be output literally.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the joined string.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   joined string is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_join 'Array' ',' 'JoinedTextVar'
#:     JoinedTextVar=$(array_join 'Array' ',')
#:     JoinedTextVar=$(array_join 'Array' ',' -)
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
array_join() { ## cSpell:Ignore BS_LA_Join_ Delim
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2)  BS_LA_Join_refArray=$1
        fn_bs_libarray_validate_name \
          'array_join'               \
          "${BS_LA_Join_refArray}"    || return $?

            BS_LA_Join_Delim=$2
        BS_LA_Join_refJoined='-' ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    3)  BS_LA_Join_refArray=$1
        fn_bs_libarray_validate_name \
          'array_join'               \
          "${BS_LA_Join_refArray}"    || return $?

        BS_LA_Join_Delim=$2

        BS_LA_Join_refJoined=$3
        fn_bs_libarray_validate_name_hyphen \
          'array_join'                      \
          "${BS_LA_Join_refJoined}"          || return $? ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  fn_bs_libarray_expected \
          'array_join'          \
          'an array variable'   \
          'join text'           \
          'an output variable (optional)'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  eval "BS_LA_Join_Array=\${${BS_LA_Join_refArray}-}"        || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Join_Array?} && shift" || return $?

  #=========================================================
  # Early out if array is empty
  #=========================================================
  case $#:${BS_LA_Join_refJoined} in
  0:-) echo; return ;;                            #< OUTPUT (EMPTY)
  0:*) eval "${BS_LA_Join_refJoined}=;"; return ;; #< SAVE (EMPTY)
  esac

  #=========================================================
  # Join the values
  #=========================================================
  BS_LA_Join_Joined='_'
  while : #<: `[ $# -gt 1 ]`
  do
    #> LOOP TEST -----------------------
    case $# in 1) break ;; esac #<: `[ $# -gt 1 ]`
    #< ---------------------------------

    BS_LA_Join_Joined="${BS_LA_Join_Joined%_}$(
        printf '%s%b_' "$1" "${BS_LA_Join_Delim}"
      )"
    shift
  done #<: `while [ $# -gt 1 ]`

  #=========================================================
  # Join the last value after the loop
  # so DELIM is not appended to it
  #=========================================================
  BS_LA_Join_Joined="${BS_LA_Join_Joined%_}$(printf '%s_' "$1")"

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_Join_refJoined} in
  -) printf '%s\n' "${BS_LA_Join_Joined%_}" ;;                #< OUTPUT
  *) eval "${BS_LA_Join_refJoined}=\${BS_LA_Join_Joined%_}" ;; #< SAVE
  esac
} #<: `array_join()`

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
#:     array_split [-E|--ere|--extended-regexp] [--] [<ARRAY>] <TEXT> <DELIMITER>
#:
#:     array_split -F|--text|--fixed-strings [--] [<ARRAY>] <TEXT> <DELIMITER>
#:
#:     array_split -G|--bre|--basic-regexp [--] [<ARRAY>] <TEXT> <DELIMITER>
#:
#:     array_split -W|--glob|--wildcard [--] [<ARRAY>] <TEXT> <DELIMITER>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-E`, `--ere`, `--extended-regexp` \[in]
#:
#: : Interpret `DELIMITER` as an
#:   ["Extended Regular Expression"][posix_ere].
#: : This is the default.
#:
#: `-F`, `--text`, `--fixed-strings` \[in]
#:
#: : Interpret `DELIMITER` as a fixed string.
#:
#: `-G`, `--bre`, `--basic-regexp` \[in]
#:
#: : Interpret `DELIMITER` as a
#:   ["Basic Regular Expression"][posix_bre].
#:
#: `-W`, `--glob`, `--wildcard` \[in]
#:
#: : Interpret `DELIMITER` as
#:   ["Pattern Matching Notation"][posix_glob].
#:
#: `ARRAY` \[out:ref]
#:
#: : Variable that will contain the new array.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
#: `DELIMITER` \[in]
#:
#: : Expression used to split `TEXT`.
#: : _EXPECTS_:
#:   - an _ERE_ with `-E`, `--ere`, or`--extended-regexp`.
#:   - a _string_ with `-F`, `--text`, `--fixed-strings`.
#:   - a _BRE_ with `-G`, `--bre`, or`--basic-regexp`.
#:   - a _wildcard pattern_ with `-W`, `--glob`, or
#:     `--wildcard`.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     array_split 'Array' "$PATH" ':'
#:     Array=$(array_split -F "$PATH" ':')
#:     Array=$(array_split - "$PATH" ':')
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - **_BRE_**: If `DELIMITER` contains any `'` (`<apostrophe>`) characters the
#:   performance of this function may be significantly slower than if it does
#:   not.
#: - **_ERE_**: A single character `DELIMITER` in "Extended Regular Expression"
#:   mode will **not** match as a regular expression. This is due to the
#:   behavior of the `split` function in `awk` which treats single characters
#:   literally.
#: - An empty (i.e. null) `DELIMITER` is **not** permitted.
#: - Not all wildcard patterns, _BRE_, or _ERE_ can be used portably.
#: - For _wildcard patterns_ the locale in effect is that of the shell as invoked -
#:   _it is **not** possible to change the locale of a running shell_.
#: - In some cases wildcard pattern matches will be implemented using fallback
#:   code - this is unavoidable as not all implementations provide the expected
#:   behavior for all expressions. See
#:   ["PATTERN MATCHING"](./README.MD#pattern-matching),
#:   [`BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_MBC`](#bs_libarray_config_shell_supports_mbc),
#:   and [`BS_LIBARRAY_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libarray_config_shell_supports_portable_glob).
#:
#: _NOTES_
#: <!-- -->
#:
#: - The default mode is "Extended Regular Expression" mode as this was the only
#:   mode offered by the first version of this command. New uses should always
#:   specify a mode explicitly.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Option names are taken from GNU `grep` since these are likely widely known
#.   and are extensions of the standard `grep` options. (There is no equivalent
#.   to "wildcard" mode in GNU `grep`, but `-W` is unused and the obvious
#.   alternative (`-H`) is used for another purpose.)
#. - Earlier versions of this (i.e. libarray.sh v1.x.x) were all broken.
#.   This reworked version is significantly more robust and fixes most (all?) of
#.   the issues previously present. The current version is also faster in
#.   some cases, while most other cases should have similar performance.
#.
#_______________________________________________________________________________
array_split() { ## cSpell:Ignore BS_LA_Split_ gsub
  #=========================================================
  # Argument Processing
  #=========================================================

  #---------------------------------------------------------
  # Check for options
  #---------------------------------------------------------
  BS_LA_Split_Mode=E
  case ${1-} in
  '-E' | '--ere'  | '--extended-regexp') BS_LA_Split_Mode=E; shift ;;
  '-F' | '--text' | '--fixed-strings'  ) BS_LA_Split_Mode=F; shift ;;
  '-G' | '--bre'  | '--basic-regexp'   ) BS_LA_Split_Mode=G; shift ;;
  '-W' | '--glob' | '--wildcard'       ) BS_LA_Split_Mode=W; shift ;;
  esac

  #---------------------------------------------------------
  # Skip any option delimiter
  #---------------------------------------------------------
  case ${1-} in --) shift ;; esac

  #---------------------------------------------------------
  # Process operands
  #---------------------------------------------------------
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2)   BS_LA_Split_refArray='-'
             BS_LA_Split_Text=$1
        BS_LA_Split_Delimiter=$2 ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    3)  BS_LA_Split_refArray=$1
        fn_bs_libarray_validate_name_hyphen \
          'array_split'                     \
          "${BS_LA_Split_refArray}"          || return $?

             BS_LA_Split_Text=$2
        BS_LA_Split_Delimiter=$3 ;;

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)  fn_bs_libarray_expected          \
          'array_split'                  \
          'one of -G|--bre|--basic-regexp, -E|--ere|--extended-regexp, -F|--text|--fixed-strings, or -W|--glob|--wildcard (optional)' \
          'an array variable (optional)' \
          'input text'                   \
          'a delimiter'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Argument Verification & Early Out
  #
  # Check for null input:
  #  - null DELIMITER is an error
  #  - early out for null TEXT
  #=========================================================
  case ${BS_LA_Split_Delimiter:+1}:${BS_LA_Split_Text:+1} in
  1:1)  ;;
  1: )  case ${BS_LA_Split_refArray} in
        -) echo ;;                                          #< OUTPUT (EMPTY)
        *) eval "${BS_LA_Split_refArray}=;" ;;               #< SAVE (EMPTY)
        esac
        return ;;
   :*)  fn_bs_libarray_invalid_args \
          'array_split'             \
          'split delimiter can not be null'
        return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # SPLIT
  #=========================================================
  case ${BS_LA_Split_Mode} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ERE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    E)
      BS_LA_Split_Array=$(
          fn_bs_libarray_split_ere    \
            'array_split'             \
            "${BS_LA_Split_Text}"      \
            "${BS_LA_Split_Delimiter}"
        ) || return $?
    ;; #<: `E)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Fixed Strings
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    F)
      BS_LA_Split_Array=$(
          fn_bs_libarray_split_fixed  \
            'array_split'             \
            "${BS_LA_Split_Text}"      \
            "${BS_LA_Split_Delimiter}"
        ) || return $?
    ;; #<: `F)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # BRE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    G)
      BS_LA_Split_Array=$(
          fn_bs_libarray_split_bre    \
            'array_split'             \
            "${BS_LA_Split_Text}"      \
            "${BS_LA_Split_Delimiter}"
        ) || return $?
    ;; #<: `G)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Wildcard
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    W)
      BS_LA_Split_Array=$(
          fn_bs_libarray_split_glob   \
            'array_split'             \
            "${BS_LA_Split_Text}"      \
            "${BS_LA_Split_Delimiter}"
        ) || return $?
    ;; #<: `W)`
  esac #<: `case ${BS_LA_Split_Mode} in`

  #=========================================================
  # OUTPUT/SAVE
  #=========================================================
  case ${BS_LA_Split_refArray} in
  -) printf '%s\n' "${BS_LA_Split_Array}" ;;                 #< OUTPUT
  *) eval "${BS_LA_Split_refArray}=\${BS_LA_Split_Array}" ;;  #< SAVE
  esac
} #<: `array_split()`

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
#: _BREAKING CHANGES_
#: <!-- --------- -->
#:
#: As of `v2.0.0`:
#:
#: - the command no longer writes anything for empty arrays (previously a single
#:   `<newline>` character was written).
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `FORMAT` contains no format code, the literal string it contains will
#:   be output once per element in `ARRAY`. Some implementations of `printf`
#:   may complain in this case.
#:
#_______________________________________________________________________________
array_printf() { ## cSpell:Ignore BS_LA_Printf_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
    2)
      # Allow transposed arguments
      case $1 in
      *%*)  BS_LA_Printf_refArray=$2
              BS_LA_Printf_Format=$1 ;;
        *)  BS_LA_Printf_refArray=$1
              BS_LA_Printf_Format=$2 ;;
      esac

      fn_bs_libarray_validate_name \
        'array_printf'             \
        "${BS_LA_Printf_refArray}"  || return $?
    ;;

    *)
      fn_bs_libarray_expected \
        'array_printf'        \
        'an array variable'   \
        'a print format'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;;
  esac

  #=========================================================
  #
  #=========================================================
  eval "BS_LA_Printf_Array=\${${BS_LA_Printf_refArray}-}"      || return $?
  eval "set 'BS_DUMMY_PARAM' ${BS_LA_Printf_Array?} && shift" || return $?

  #=========================================================
  #
  #=========================================================
  case $# in 0) return ;; esac

  #=========================================================
  # PRINT
  #=========================================================
  # SC2059: Don't use variables in the printf format string.
  #         Use printf "..%s.." "$foo".
  # EXCEPT: The intention here is to allow callers to set
  #         the format themselves
  # shellcheck disable=SC2059
  printf "${BS_LA_Printf_Format}" ${1+"$@"}
} #<: `array_printf()`

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
#:     array_from_path [--all|-a] [--] [<ARRAY>] <PATH>
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
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
array_from_path() { ## cSpell:Ignore BS_LA_FP_
  #=========================================================
  # Process Arguments
  #=========================================================

  #---------------------------------------------------------
  # Option(s) must be first
  #---------------------------------------------------------
  BS_LA_FP_DotFiles=0
  while :
  do
    case ${1-} in
    '-a'|'-all'|'--all')
      BS_LA_FP_DotFiles=1
      shift ;;

    '--') shift; break ;;

       *) break ;;
    esac #<: `case ${1-} in`
  done

  #---------------------------------------------------------
  # Other arguments follow
  #---------------------------------------------------------
  case $# in
  1)  BS_LA_FP_refArray='-'
          BS_LA_FP_Path=$1 ;;
  2)  BS_LA_FP_refArray=$1
          BS_LA_FP_Path=$2
      fn_bs_libarray_validate_name_hyphen \
        'array_from_path'                 \
        "${BS_LA_FP_refArray}"             || return $? ;;
  *)  fn_bs_libarray_expected          \
        'array_from_path'              \
        'options: -a|--all (optional)' \
        'an array variable (optional)' \
        'a path'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # No dot files for non-directory paths
  #=========================================================
  case ${BS_LA_FP_DotFiles}${BS_LA_FP_Path} in
  1*[!/]) [ -d "${BS_LA_FP_Path}" ] || BS_LA_FP_DotFiles=0 ;;
  esac

  #=========================================================
  # Get the paths
  #=========================================================
  BS_LA_FP_Array=$(
      #-----------------------------------------------------
      # Ensure globbing is enabled.
      # (This will be scoped to the subshell.)
      #-----------------------------------------------------
      set +f

      fn_bs_libarray_create_from_path \
        'array_from_path'             \
        "${BS_LA_FP_DotFiles}"         \
        "${BS_LA_FP_Path}"
    ) || return $?

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LA_FP_refArray} in
  -) printf '%s\n' "${BS_LA_FP_Array}" ;;                    #< OUTPUT
  *) eval "${BS_LA_FP_refArray}=\${BS_LA_FP_Array}" ;;        #< SAVE
  esac
} #<: `array_from_path()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_from_find`
#:
#: Create an array from the results of the `find` command.
#:
#: In contrast to [`array_from_find_allow_print`](#array_from_find_allow_print),
#: this command builds the array by capturing `STDOUT`; any output from `find`
#: that is sent to `STDOUT` _will_ result in broken array.
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
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
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
#:     Array=$(array_from_find - -L "$PWD" -type f)
#:
#: _CAVEATS_
#: <!--  -->
#:
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
#:
#: _NOTES_
#: <!-- -->
#:
#: - Implemented using [`BS_LIBARRAY_SH_TO_ARRAY`](#bs_libarray_sh_to_array)
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
array_from_find() { ## cSpell:Ignore BS_LA_FF_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $#:${1-} in
    0:)
      BS_LA_FF_refArray='-'
    ;;

    "$#":-)
      BS_LA_FF_refArray='-'
      shift
      case $1 in --) shift ;; esac
    ;;

    "$#":--)
      BS_LA_FF_refArray='-'
      shift
    ;;

    "$#":-[!-]*)
      BS_LA_FF_refArray='-'
    ;;

    *)
      BS_LA_FF_refArray=$1
      fn_bs_libarray_validate_name_hyphen \
        'array_from_find'                 \
        "${BS_LA_FF_refArray}"             || return $?
      shift
      case ${1-} in --) shift ;; esac
    ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  BS_LA_FF_Array=$(
      {
        find  ${1+"$@"} \
              -exec sh -c "${BS_LIBARRAY_SH_TO_ARRAY}" \
                          'BS_LIBARRAY_SH_TO_ARRAY'    \
                          '{}' '+'
      } && {
        echo ' '
      }
    ) || return $?

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LA_FF_refArray} in
  -) printf '%s\n' "${BS_LA_FF_Array}" ;;                    #< OUTPUT
  *) eval "${BS_LA_FF_refArray}=\${BS_LA_FF_Array}" ;;        #< SAVE
  esac
} #<: `array_from_find()`

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
#: _CAVEATS_
#: <!--  -->
#:
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
#: - To support output from `find` primaries and also generate an array it
#:   is necessary to redirect output. If the file descriptors used are
#:   already in use this **will** cause errors.
#:
#: _NOTES_
#: <!-- -->
#:
#: - Implemented using [`BS_LIBARRAY_SH_TO_ARRAY`](#bs_libarray_sh_to_array)
#: - [`array_from_find_allow_print`](#array_from_find_allow_print) is provided
#:   if `find` primaries that generate output are required.
#: - This is likely to be of limited use; capturing the output from the
#:   `find` primaries would require a subshell meaning that the generated
#:   array would **only** be available _within_ that subshell.
#: - The _POSIX.1_ standard _allows_ for multi-digit file descriptors, however
#:   only _requires_ support for single-digit descriptors and at least some
#:   common implementations do not support multi-digit file descriptors, so
#:   they are not permitted for use here.
#:
#_______________________________________________________________________________
array_from_find_allow_print() { ## cSpell:Ignore BS_LA_FFAP_
  #=========================================================
  # Set defaults
  #=========================================================
  BS_LA_FFAP_FD_1=${c_BS_LIBARRAY_CFG__find_fd_1}
  BS_LA_FFAP_FD_2=${c_BS_LIBARRAY_CFG__find_fd_2}

  #=========================================================
  # Process arguments...
  #=========================================================
  case $# in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # INVALID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    0)
      fn_bs_libarray_expected             \
        'array_from_find_allow_print'     \
        'an output variable'              \
        'two file descriptors (optional)' \
        'arguments for find (optional)'
      return "${c_BS_LIBARRAY__EX_USAGE}"
    ;; #<: `0)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Single Argument: Must be an output variable
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1)
      BS_LA_FFAP_refArray=$1
      fn_bs_libarray_validate_name    \
        "array_from_find_allow_print" \
        "${BS_LA_FFAP_refArray}"       || return $?
      shift
    ;; #<: `1)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Multiple Arguments: Must be an output variable...
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      BS_LA_FFAP_refArray=$1
      fn_bs_libarray_validate_name    \
        "array_from_find_allow_print" \
        "${BS_LA_FFAP_refArray}"       || return $?
      shift

      # ... _MAY_ be followed by file descriptors
      case $1 in
      [3456789],[3456789])
        BS_LA_FFAP_FD_1=${1%,?}
        BS_LA_FFAP_FD_2=${1#?,}
        case ${BS_LA_FFAP_FD_1} in
        "${BS_LA_FFAP_FD_2}")
          fn_bs_libarray_invalid_args     \
            'array_from_find_allow_print' \
            "file descriptors '$1' must be different values"
          return "${c_BS_LIBARRAY__EX_USAGE}"
        ;;
        esac
        shift ;;
      esac #<: `case $1 in`

      # ... _MAY_ be followed the XBD special arg `--`
      case ${1-} in --) shift; esac
    ;; #<: `*)`
  esac #<: `case $# in`

  #=========================================================
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
  #=========================================================
  eval '
      {
        '"${BS_LA_FFAP_refArray}"'=$(
            {
              {
                find ${1+"$@"} -exec sh -c \
                    " {
                        ${BS_LIBARRAY_SH_TO_ARRAY}
                      } >&'"${BS_LA_FFAP_FD_1}"'
                    " \
                    BS_LIBARRAY_SH_TO_ARRAY \
                    "{}" "+" >&'"${BS_LA_FFAP_FD_2}"'
              } && {
                echo " " >&'"${BS_LA_FFAP_FD_1}"'
              }
            } '"${BS_LA_FFAP_FD_1}"'>&1
          )
      } '"${BS_LA_FFAP_FD_2}"'>&1
    '
} #<: `array_from_find_allow_print()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `array_is_array`
#:
#: Determine if a variable looks like it contains array like data.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     array_is_array <ARRAY>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `ARRAY` \[in:ref]
#:
#: : Variable that may contain a array.
#: : MUST be a valid _POSIX.1_ name.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if array_is_array 'Var'; then ...; fi
#:
#: _NOTES_
#: <!-- -->
#:
#: - An empty or unset `ARRAY` is _not_ a valid array.
#: - Exit status will be `0` (`<zero>`) if `ARRAY` appears to be a valid array,
#:   while the exit status will be `1` (`<one>`) in all other (non-error) cases.
#:
#_______________________________________________________________________________
array_is_array() { ## cSpell:Ignore BS_LA_AIA_
  #=========================================================
  # Process Arguments
  #=========================================================
  case $# in
  1)  BS_LA_AIA_refArray=$1 ;;
  *)  fn_bs_libarray_expected \
        'array_is_array'      \
        'an array variable'
      return "${c_BS_LIBARRAY__EX_USAGE}" ;;
  esac

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libarray_validate_name \
    'array_is_array'           \
    "${BS_LA_AIA_refArray}"     || return $?

  #=========================================================
  # Unpack
  #=========================================================
  eval "BS_LA_AIA_Array=\${${BS_LA_AIA_refArray}-}" || return $?

  #=========================================================
  #
  #=========================================================
  case ${BS_LA_AIA_Array?} in
  "'"*"' \\${c_BS_LIBARRAY__newline} ") return 0 ;;
                                     *) return 1 ;;
  esac
} #<: `array_is_array()`

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
#. v2.0.0       - \[NEW] Added simple debugging output (disabled by default),
#.                controlled by `BS_LIBARRAY_DEBUG`, `BS_LIBARRAY_CONFIG_DEBUG`,
#.                and `BS_LIBARRAY_DEBUG_FD`.
#.              - \[CHANGE] **BREAKING** Rewrote pattern matching - new code
#.                fixes several issues, but changes how some matches are made.
#.                Affects [`array_remove`](#array_remove),
#.                [`array_search`](#array_search),
#.                [`array_contains`](#array_contains), and
#.                [`array_split`](#array_split).
#.              - \[CHANGE] **BREAKING** Command options now _MUST_ precede any
#.                non-option arguments. This better matches the standard and
#.                other suite libraries. Affects
#.                [`array_from_path`](#array_from_path).
#.              - \[CHANGE] **BREAKING** [`array_printf`](#array_printf) no
#.                longer writes anything for empty arrays (previously a
#.                single `<newline>` would be written).
#.              - \[CHANGE] Large rewrite of much of the library: fixing
#.                issues, improving security, removing unnecessary code,
#.                homogenizing command interfaces, and more. (In some cases
#.                this has _changed_ or even _reduced_ functionality.)
#.              - \[CHANGE] _(PORTABILITY)_ Removed some portability branches
#.                and replaced with alternative code that works in all versions.
#.                (Most notably related to `sed`.) The previously
#.                available `BS_LIBARRAY_CONFIG_NO_SED_SLASH_N_NEWLINE` is now
#.                ignored.
#.              - \[CHANGE] Commands that support pattern matching now support
#.                all forms. (Previously some commands supported only a
#.                subset.)
#.              - \[CHANGE] Modified `awk` scripts to remove unnecessary
#.                function usage, increase security and robustness. (Especially
#.                relevant to the [`array_split`](#array_split) function which
#.                is much changed in this regard.)
#.              - \[CHANGE] Removed checks for `-print` options to `find` for
#.                [`array_from_find`](#array_from_find) as it was brittle and
#.                unlikely to be much help.
#.              - \[CHANGE] _(PERFORMANCE)_ Added code path to use `awk` `ARGV`
#.                if possible - this can drastically improve performance in
#.                cases when it can be used. Added a new configuration variable
#.                [BS_LIBARRAY_CONFIG_NO_AWK_ARGV](#bs_libarray_config_no_awk_argv)
#.                to disable it if required.
#.              - \[CHANGE] _(PERFORMANCE)_ Inlined some code where the common
#.                case would likely much slower otherwise.
#.              - \[CHANGE] Other clean-ups and refactoring.
#.              - \[CHANGE] Documentation updates/fixes.
#.              - \[FIX] _(PORTABILITY)_ Changed parameter expansion of the form
#.                `${parameter:?[word]}` to use a fixed string, or a workaround
#.                for `zsh` which fails to expand parameters used in `word`.
#.              - \[FIX] _(PORTABILITY)_ changed some parameter expansions to
#.                ensure that meta-characters where safe (e.g. `#` to `[#]`).
#.              - \[FIX] _(PORTABILITY)_ Replaced all usage of `expr` with
#.                `sed`. Although `expr` is often significantly faster, it also
#.                has many more portability issues - many of which are
#.                impossible to catch when using user supplied expressions. The
#.                previously available `BS_LIBARRAY_CONFIG_NO_EXPR_BRE_MATCH` is
#.                now ignored.
#.              - \[FIX] Changed [`array_from_path`](#array_from_path) to avoid
#.                erroneous output in edge cases. Also now enables globbing as
#.                if it is disabled via shell options nothing would be
#.                generated (enabling is scoped appropriately). Additional fix
#.                to avoid an error when `ls` does not support `-q`.
#.
#. v1.2.0       - \[NEW] Added [`array_is_array`](#array_is_array).
#.              - \[NEW] [`array_split`](#array_split) now has multiple ways of
#.                splitting text.
#.              - \[FIX] _(PORTABILITY)_ Added trailing '\n' to `printf` -
#.                without it some implementations will effectively discard the
#.                last line of data.
#.              - \[FIX] _(PORTABILITY)_ Rewrote `awk` scripts to better match
#.                platform capabilities. (All `awk` usage has changed
#.                considerably.)
#.              - \[FIX] _(PORTABILITY)_ Added workarounds for `sed` where '\n'
#.                in a replacement expression does not result in a `<newline>`.
#.                (New configuration variable:
#.                [`BS_LIBARRAY_CONFIG_NO_SED_SLASH_N_NEWLINE`](#bs_libarray_config_no_sed_slash_n_newline))
#.              - \[FIX] _(PORTABILITY)_ Changed `sed` scripts to avoid long
#.                label names and remove grouping with `{` when not required.
#.              - \[FIX] _(PORTABILITY)_ Minor changes to some `case` statements
#.                which should now be more portable, though never showed any
#.                issues (e.g. add `;;` to some statements where it was missing
#.                even though this was permitted.)
#.              - \[FIX] _(PORTABILITY)_ Use null string instead of no arguments
#.                for `echo` when intent is only to output a `<newline>`.
#.              - \[FIX] _(PORTABILITY)_ Minor changes to parameter expansion to
#.                avoid issues with ksh88.
#.
#. v1.0.1       - \[FIX] Fixed error with `shift` in
#.                [`fn_bs_libarray_error`](#fn_bs_libarray_error) that would
#.                cause parameters to appear incorrectly in the error message
#.                (only affected calls with multiple parameters).
#.
#. v1.0.0       - First Release
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
#: _For more details see the `shtoolkit` general [documentation](./README.MD#standards)._
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
#: - Arrays can be serialized (e.g. saved to, or loaded
#:   from, a file). However, each array is _only_ supported
#:   by the library version used to created it - the
#:   internal format for an array _may_ change between
#:   versions without notice.
#: - Arrays may contain other arrays, however this is likely
#:   to have performance implications (due to the need to
#:   escape values). Where possible storing a reference to
#:   another array is preferable (i.e. save the _name_ of
#:   a variable that contains the second array).
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## CAVEATS
#:
#: - The library attempts to account for differences between implementations
#:   (where known), however, it is not possible to do this for every case.
#: - The maximum size of any array is limited by the environment in which it is
#:   used. Of particular note is that exceeding the command line length limit
#:   will cause arrays to be unusable in many (platform dependent)
#:   circumstances, though other limitations will also exist. Note that
#:   exporting a variable containing an array will cause that variable to be
#:   counted against the command line length limit **TWICE** if the array is
#:   also used with a command.
#:
#: _See also the common [documentation](./README.MD#caveats)._
#:
#% <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#%
#% ## SEE ALSO
#%
#% shtoolkit(7)
#%
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#: <!-- REFERENCES -->
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: [markdown]:                  <https://daringfireball.net/projects/markdown/syntax>                                                "Markdown: Syntax [daringfireball.net]"
#: [commonmark]:                <https://commonmark.org/>                                                                            "CommonMark [spec.commonmark.org]"
#: [commonmark_spec]:           <https://spec.commonmark.org/current/>                                                               "CommonMark Spec (current) [spec.commonmark.org]"
#:
#: [posix]:                     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                       "POSIX.1-2008 \[pubs.opengroup.org\]"
#: [posix_2013]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2013edition>                                       "POSIX.1-2013 \[pubs.opengroup.org\]"
#: [posix_2016]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2016edition>                                       "POSIX.1-2016 \[pubs.opengroup.org\]"
#: [posix_2018]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2018edition>                                       "POSIX.1-2018 \[pubs.opengroup.org\]"
#: [posix_2024]:                <https://pubs.opengroup.org/onlinepubs/9799919799.2024edition>                                       "POSIX.1-2024 \[pubs.opengroup.org\]"
#:
#: [posix_bre]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>     "Basic Regular Expression \[pubs.opengroup.org\]"
#: [posix_ere]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>     "Extended Regular Expression \[pubs.opengroup.org\]"
#: [posix_re_bracket_exp]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03_05>  "RE Bracket Expression \[pubs.opengroup.org\]"
#: [posix_param_expansion]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02> "Parameter Expansion \[pubs.opengroup.org\]"
#: [posix_getopts]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html>                "getopts \[pubs.opengroup.org\]"
#: [posix_utility_conventions]: <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap12.html>               "POSIX: Utility Conventions \[pubs.opengroup.org\]"
#: [posix_variable]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_230>    "Definitions: Name \[pubs.opengroup.org\]"
#: [posix_execl]:               <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/functions/execl.html>                  "execl \[pubs.opengroup.org\]"
#: [posix_chars]:               <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap06.html#tag_06_01>     "Portable Character Set \[pubs.opengroup.org\]"
#: [posix_glob]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_13>    "Pattern Matching Notation \[pubs.opengroup.org\]"
#:
#: [sysexits]:                  <https://www.freebsd.org/cgi/man.cgi?sysexits(3)>                                                    "FreeBSD SYSEXITS(3) \[freebsd.org\]"
#:
#: [semver]:                    <https://semver.org/>                                                                                "Semantic Versioning \[semver.org\]"
#:
#: [util_linux]:                <https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/about/>                              "util-linux (about) \[git.kernel.org\]"
#:
#: [pandoc]:                    <https://pandoc.org/>                                                                                "Pandoc \[pandoc.org\]"
#:
#: [man_page]:                  <https://wikipedia.org/wiki/Man_page>                                                                "man page \[wikipedia.org\]"
#:
#: [autoconf_portable]:         <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>                  "autoconf: Portable Shell Programming \[gnu.org\]"
#: [autoconf_awk]:              <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#awk>  "autoconf: Limitations of Usual Tools \[gnu.org\]"
#: [autoconf_sed]:              <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#sed>  "autoconf: Limitations of Usual Tools \[gnu.org\]"
#: [autoconf_grep]:             <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Limitations-of-Usual-Tools.html#grep> "autoconf: Limitations of Usual Tools \[gnu.org\]"
#:
#: [inclusivenaming]:           <https://inclusivenaming.org/>                                                                       "Inclusive Naming Initiative \[inclusivenaming.org\]"
#:
################################################################################

################################################################################
################################################################################
# END
################################################################################
################################################################################
