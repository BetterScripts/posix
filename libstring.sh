#!/usr/bin/env false
# SPDX-License-Identifier: MPL-2.0
## cSpell:Ignore libstring shtoolkit
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libstring': Text processing helpers for POSIX.1 shells.     *#
#*                                                                            *#
#* Copyright (c) 2026 BetterScripts ( better.scripts@proton.me,               *#
#*                                    https://github.com/BetterScripts )      *#
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

################################### LIBSTRING ###################################
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
#% % libstring(7) BetterScripts libstring v1.0.0 | Text processing helpers for POSIX.1 shells.
#% % BetterScripts (better.scripts@proton.me)
#% % July 2026
#
#: <!-- #################################################################### -->
#: <!-- ############ THIS FILE WAS GENERATED FROM 'libstring.sh' ########### -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # LIBSTRING
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## SYNOPSIS
#:
#: _Full synopsis, description, arguments, examples and other information is_
#: _documented with each individual command._
#:
#: [`string_length [<OUTPUT>] <STRING>`](#string_length)
#:
#: [`string_quote [<OUTPUT>] <STRING>`](#string_quote)
#:
#: [`string_join [<OUTPUT>] <STRING>...`](#string_join)
#:
#: [`string_toupper [<OUTPUT>] <STRING>`](#string_toupper)
#:
#: [`string_tolower [<OUTPUT>] <STRING>`](#string_tolower)
#:
#: [`string_trim [<OUTPUT>] <STRING> <LENGTH>`](#string_trim)
#:
#: [`string_index [<OPTION>] [--] [<OUTPUT>] <STRING> <STRING>`](#string_index)
#:
#: [`string_match [<OPTION>] [--] <STRING> <STRING>`](#string_match)
#:
#: [`string_substr <OUTPUT> <STRING> <OFFSET> [<LENGTH>]`](#string_substr)
#:
#: [`string_truncate [<OUTPUT>] <STRING> <LENGTH>`](#string_truncate)
#:
#: [`string_sub [<OPTION>] [--] [<OUTPUT>] <STRING> <LENGTH>`](#string_sub)
#:
#: [`string_gsub [<OPTION>] [--] [<OUTPUT>] <STRING> <LENGTH>`](#string_gsub)
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## DESCRIPTION
#:
#: Provides commands for _POSIX.1_ compliant shell to assist processing text
#: safely and robustly.
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
case ${BS_LIBSTRING_SOURCED:+1} in 1) return ;; esac

#===============================================================================
#===============================================================================
# DEFAULTS
#===============================================================================
#===============================================================================
: "${BS_LIBSTRING_DEBUG:=${BS_DEBUG:-${DEBUG:-0}}}"
: "${BS_LIBSTRING_CONFIG_DEBUG:=${BS_LIBSTRING_DEBUG:-0}}"
: "${BS_LIBSTRING_DEBUG_FD:=${BS_DEBUG_FD:-2}}"

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
#. ### `fn_bs_libstring_readonly`
#.
#. Wrapper round `readonly`.
#.
#. Required because in its default configuration Z Shell's `readonly` causes
#. problems (due to variable scoping).
#.
#. See [`BS_LIBSTRING_CONFIG_NO_Z_SHELL_SETOPT`](#bs_libstring_config_no_z_shell_setopt)
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libstring_readonly <VAR>...
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
fn_bs_libstring_readonly() { ## cSpell:Ignore BS_LS_readonly_
  case ${c_BS_LIBSTRING_CFG__use_zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'POSIX_BUILTINS' ;;
  esac
  readonly "$@" || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_dbg_printf_to_fd`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      fn_bs_libstring_dbg_printf_to_fd <ARGS>...
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
#.   [`BS_LIBSTRING_DEBUG_FD`](#bs_libstring_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libstring_dbg_printf_to_fd() { ## cSpell:Ignore BS_LS_DPTFD_
  # SC2059: Don't use variables in the printf format string.
  #         Use printf "..%s.." "$foo".
  # EXCEPT: This is a printf wrapper.
  # SC2086: Double quote to prevent globbing and word
  #+        splitting.
  # EXCEPT: Quoting changes the meaning (under POSIX rules
  #+        the descriptor will be considered a file)
  # shellcheck disable=SC2059,SC2086
  case ${BS_LIBSTRING_DEBUG_FD:-2} in
  [123456789]) printf "$@" >&  ${BS_LIBSTRING_DEBUG_FD}      ;;
         '&'*) printf "$@" >&  ${BS_LIBSTRING_DEBUG_FD#'&'}  ;;
            *) printf "$@" >> "${BS_LIBSTRING_DEBUG_FD#'>'}" ;;
  esac || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_dbg_msg`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      fn_bs_libstring_dbg_msg <CALLER> <MESSAGE>...
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
#.   [`BS_LIBSTRING_DEBUG_FD`](#bs_libstring_debug_fd).
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Avoids using `$*` since `IFS` may not be set appropriately.
#. - Written for simplicity and not performance.
#.
#_______________________________________________________________________________
fn_bs_libstring_dbg_msg() { ## cSpell:Ignore BS_LS_DM_
  case ${BS_LIBSTRING_DEBUG:-0} in 0) return ;; esac

  BS_LS_DM_Caller=$1
  shift

  fn_bs_libstring_dbg_printf_to_fd                \
    "[libstring::${BS_LS_DM_Caller}]: DEBUG:%s\n" \
    "$(printf ' %s' "$@")"
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_config_constant`
#.
#. Helper to set configuration variables and report the set value when in
#. debug mode.
#.
#. In non-debug mode, identical to
#. [`fn_bs_libstring_readonly`](#fn_bs_libstring_readonly).
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libstring_config_constant <VAR>...
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
#. - Output is in form `[libstring::config]: DEBUG: <NAME>: <VALUE>` where
#.   `NAME` is the constant name and `VALUE` its value.
#. - Output is written to the file descriptor stored in
#.   [`BS_LIBSTRING_DEBUG_FD`](#bs_libstring_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libstring_config_constant() { ## cSpell:Ignore BS_LS_CFGCST_
  case ${BS_LIBSTRING_CONFIG_DEBUG:-0} in
  0)  ;;
  *)  for BS_LS_CFGCST_Name
      do
        eval "BS_LS_CFGCST_Value=\${${BS_LS_CFGCST_Name}-}" || BS_LS_CFGCST_Value=;
        fn_bs_libstring_dbg_printf_to_fd              \
          "[libstring::config]: DEBUG: %s: %s\n"      \
          "${BS_LS_CFGCST_Name#c_BS_LIBSTRING_CFG__}" \
          "${BS_LS_CFGCST_Value}"                     || true
      done ;;
  esac

  case ${c_BS_LIBSTRING_CFG__use_zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'POSIX_BUILTINS' ;;
  esac
  readonly "$@" || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_print_utf8_fw_A`
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
#. ### `fn_bs_libstring_print_utf8_fw_a`
#.
#. Print the UTF-8 character "Fullwidth Latin Small Letter
#. A" (code point `0xEF 0xBD 0x81`).
#.
#. See [`U+FF41`](https://www.compart.com/en/unicode/U+FF41)
#.
#. _Used for configuration tests._
#.
#_______________________________________________________________________________
fn_bs_libstring_print_utf8_fw_A() { echo '' | awk 'BEGIN{ print "\357\274\241" }'; }
fn_bs_libstring_print_utf8_fw_a() { echo '' | awk 'BEGIN{ print "\357\275\201" }'; }

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
#: #### `BS_LIBSTRING_CONFIG_NO_Z_SHELL_SETOPT`
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
#. - See [`fn_bs_libstring_readonly`](#fn_bs_libstring_readonly).
#. - **MUST BE SET BEFORE FIRST CALL TO `fn_...readonly`**
#:
case ${BS_LIBSTRING_CONFIG_NO_Z_SHELL_SETOPT:-${BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT:-A}} in
[AD]) case ${ZSH_VERSION:+1} in
      1) c_BS_LIBSTRING_CFG__use_zsh_setopt=1 ;;
      *) c_BS_LIBSTRING_CFG__use_zsh_setopt=0 ;;
      esac ;;
   0) c_BS_LIBSTRING_CFG__use_zsh_setopt=0 ;;
   *) c_BS_LIBSTRING_CFG__use_zsh_setopt=1 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__use_zsh_setopt'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_NO_DEV_NULL`
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
case ${BS_LIBSTRING_CONFIG_NO_DEV_NULL:-${BETTER_SCRIPTS_CONFIG_NO_DEV_NULL:-A}} in
[AD]) case $( ( echo 'TEST' >/dev/null ) 2>&1 && echo 'SUCCESS') in
      'SUCCESS') c_BS_LIBSTRING_CFG__use_dev_null=1 ;;
              *) c_BS_LIBSTRING_CFG__use_dev_null=0 ;;
      esac ;;
   0) c_BS_LIBSTRING_CFG__use_dev_null=1 ;;
   *) c_BS_LIBSTRING_CFG__use_dev_null=0 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__use_dev_null'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_MBC`
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
#: - **WARNING:** Automatic tests assume the locale has not
#:   been set since the current shell was invoked - if this
#:   is not the case configuration will be incorrect.
#: - See
#:   [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC`](./README.MD#better_scripts_config_shell_supports_mbc)
#:   for details.
#:
case ${BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_MBC:-${BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_MBC:-A}} in
  [AD])
    case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    C|POSIX)  c_BS_LIBSTRING_CFG__shell_supports_mbc=0 ;;
          *)  if i_BS_LIBSTRING__utf8_char=$(fn_bs_libstring_print_utf8_fw_A 2>&1)
              then
                case ${i_BS_LIBSTRING__utf8_char}:${i_BS_LIBSTRING__utf8_char} in
                [${i_BS_LIBSTRING__utf8_char}]:?) c_BS_LIBSTRING_CFG__shell_supports_mbc=1 ;;
                                               *) c_BS_LIBSTRING_CFG__shell_supports_mbc=0 ;;
                esac
              else
                c_BS_LIBSTRING_CFG__shell_supports_mbc=0
              fi
              unset i_BS_LIBSTRING__utf8_char ;;
    esac

    #*****************************************************
    # HACK: OILS currently corrupts some MBC strings.
    #       (It's not clear what causes the issue as
    #        all simple tests seem to work, but `sub`
    #        and `gsub` fail.)
    case ${OILS_VERSION:+1} in 1) c_BS_LIBSTRING_CFG__shell_supports_mbc=0;; esac
    #*****************************************************
  ;;

  0) c_BS_LIBSTRING_CFG__shell_supports_mbc=0 ;;
  *) c_BS_LIBSTRING_CFG__shell_supports_mbc=1 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__shell_supports_mbc'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](./README.MD#better_scripts_config_shell_supports_portable_glob)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - Disable/\[Enable] glob/wildcard pattern matching even
#:   if the pattern contains known problematic characters.
#: - _OFF_: use fallback code for patterns that contain
#:   problem characters.
#: - _ON_:  use shell pattern matching.
#: - Default is to run tests for the current shell when a
#:   library is sourced to determine if the current shell
#:   supports these as expected or not.
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
case ${BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB:-${BETTER_SCRIPTS_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB:-A}} in
  [AD])
    # NOTE: Can't use a `case` inside a command substitution
    #       since some shells (e.g. `posh`) don't parse that
    #       properly
    case $(
      {
        if [ "${c_BS_LIBSTRING_CFG__use_zsh_setopt}" = 1 ]
        then
          setopt  'LOCAL_OPTIONS' 'SH_FILE_EXPANSION' \
                  'SH_GLOB' 'GLOB_SUBST' 'NONOMATCH'
        fi

        i_BS_LIBSTRING_Test='\[a\((t)est*\string?'
        i_BS_LIBSTRING_Glob='\\\[a\\\((t)est\*\\string\?'
        i_BS_LIBSTRING_Test=${i_BS_LIBSTRING_Test##${i_BS_LIBSTRING_Glob}}
        printf '%s\n' "${i_BS_LIBSTRING_Test:-SUCCESS}"
      } 2>&1
    ) in
    'SUCCESS') c_BS_LIBSTRING_CFG__full_glob_support=1 ;;
            *) c_BS_LIBSTRING_CFG__full_glob_support=0 ;;
    esac
  ;;

  0) c_BS_LIBSTRING_CFG__full_glob_support=0 ;;
  *) c_BS_LIBSTRING_CFG__full_glob_support=1 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__full_glob_support'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS`](./README.MD#better_scripts_config_no_param_expansion_char_class)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - Disable/\[Enable] using `[:...:]` character classes in
#:   parameter expansions.
#: - _OFF_: use fallback code.
#: - _ON_:  use character classes.
#: - Default is to use character classes if possible.
#: - Modern shell implementations generally support using
#:   character classes in parameter expansions, which
#:   results in much better performance than the
#:   alternatives.
#: - See
#:   [`BETTER_SCRIPTS_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS`](./README.MD#better_scripts_config_no_param_expansion_char_class)
#:   for details.
#:
case ${BS_LIBSTRING_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS:-${BETTER_SCRIPTS_CONFIG_NO_PARAM_EXPANSION_CHAR_CLASS:-A}} in
[AD]) case $(
        {
          BS_LS_TEST_STR='    !TEST SUCCESS' &&
          printf '%s\n' "${BS_LS_TEST_STR#*[![:space:]]}"
        } 2>&1
      ) in
      'TEST SUCCESS') c_BS_LIBSTRING_CFG__use_param_expansion_char_class=1 ;;
                   *) c_BS_LIBSTRING_CFG__use_param_expansion_char_class=0 ;;
      esac ;;
   0) c_BS_LIBSTRING_CFG__use_param_expansion_char_class=1 ;;
   *) c_BS_LIBSTRING_CFG__use_param_expansion_char_class=0 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__use_param_expansion_char_class'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_NO_CASE_CHAR_CLASS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_NO_CASE_CHAR_CLASS`](./README.MD#better_scripts_config_no_case_char_class)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - Disable/\[Enable] using `[:...:]` character classes in
#:   `case` matches.
#: - _OFF_: use fallback code.
#: - _ON_:  use character classes.
#: - Default is to use character classes if possible.
#: - Modern shell implementations generally support using
#:   character classes in `case` matches, which results
#:   in much better performance than the alternatives.
#: - See
#:   [`BETTER_SCRIPTS_CONFIG_NO_CASE_CHAR_CLASS`](./README.MD#better_scripts_config_no_case_char_class)
#:   for details.
#:
case ${BS_LIBSTRING_CONFIG_NO_CASE_CHAR_CLASS:-${BETTER_SCRIPTS_CONFIG_NO_CASE_CHAR_CLASS:-A}} in
[AD])
  # SC2006: Use $(...) notation instead of legacy backticked `...`.
  # EXCEPT: Some shells (e.g. `posh`) have trouble with `case` statements
  #         inside `$(...)`, so need to use backticks for this test. (Not using
  #         command substitution is not an option as it could lead to leaked
  #         error output.)
  # SC2034: This word is constant. Did you forget the $ on a variable?
  # EXCEPT: It's supposed to be constant
  # shellcheck disable=SC2006,SC2194
  if  test 'SUCCESS' = "`{
                              case '    TEST' in
                              [[:space:]]*[![:space:]]) echo 'SUCCESS' ;;
                                                     *) echo 'FAILURE' ;;
                              esac
                          } 2>&1 `"
  then
    c_BS_LIBSTRING_CFG__use_case_char_class=1
  else
    c_BS_LIBSTRING_CFG__use_case_char_class=0
  fi ;;

0) c_BS_LIBSTRING_CFG__use_case_char_class=1 ;;
*) c_BS_LIBSTRING_CFG__use_case_char_class=0 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__use_case_char_class'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_TR_SUPPORTS_MBC`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_TR_SUPPORTS_MBC`](./README.MD#better_scripts_config_tr_supports_mbc)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic> (delayed)
#: - Disable/\[Enable] the use of `tr` outside the _POSIX_
#:   locale.
#: - _OFF_: do not use `tr` outside the _POSIX_ locale.
#: - _ON_: use `tr` for all locales.
#: - Some implementations of `tr` support _ONLY_ single-
#:   byte characters. Since it is difficult to determine if
#:   a string contains only supported characters, it is
#:   assumed that if the locale is not the _POSIX_ locale
#:   that _ALL_ strings contain multi-byte characters and so
#:   can not be correctly used with these versions of `tr`.
#: - See
#:   [`BETTER_SCRIPTS_CONFIG_TR_SUPPORTS_MBC`](./README.MD#better_scripts_config_tr_supports_mbc)
#:   for details.
#:
case ${BS_LIBSTRING_CONFIG_TR_SUPPORTS_MBC:-${BETTER_SCRIPTS_CONFIG_TR_SUPPORTS_MBC:-D}} in
  [AD]) c_BS_LIBSTRING__CMD__toupper=;
        c_BS_LIBSTRING__CMD__tolower=; ;; #< HANDLED LATER
     0) c_BS_LIBSTRING__CMD__toupper=fn_bs_libstring_toupper_awk
        c_BS_LIBSTRING__CMD__tolower=fn_bs_libstring_tolower_awk
        fn_bs_libstring_readonly  'c_BS_LIBSTRING__CMD__toupper' \
                                  'c_BS_LIBSTRING__CMD__tolower' ;;
     *) c_BS_LIBSTRING__CMD__toupper=fn_bs_libstring_toupper_tr
        c_BS_LIBSTRING__CMD__tolower=fn_bs_libstring_tolower_tr
        fn_bs_libstring_readonly  'c_BS_LIBSTRING__CMD__toupper' \
                                  'c_BS_LIBSTRING__CMD__tolower' ;;
esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_ALLOW_EXPR`
#:
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  _OFF_
#: - \[Disable]/Enable] the use of `expr` in some cases.
#: - _OFF_: do not use `expr`.
#: - _ON_: use `expr` by preference, fallback if it fails.
#: - For _Basic Regular Expressions_ `expr` is often the
#:   best performing utility available, however, it is also
#:   subject to significant portability issues that make it
#:   hard to use in the general case, therefore code that
#:   uses `expr` also needs fallback code to handle cases
#:   where it fails.
#: - When this variable is _OFF_, `expr` is not used and
#:   fallback code is used in all cases - this is safer, but
#:   loses some performance.
#: - When this variable is _ON_, fallback code is only used
#:   if `expr` fails - this is faster in general, but slower
#:   if `expr` always fails.
#: - Note that currently the use of `expr` is limited and
#:   will often be avoided entirely.
#:
case ${BS_LIBSTRING_CONFIG_ALLOW_EXPR:-0} in
0)  c_BS_LIBSTRING_CFG__use_expr=0 ;;
*)  c_BS_LIBSTRING_CFG__use_expr=1 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__use_expr'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_NO_AWK_ARGV`
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
#: - Note that since failure is highly input dependent this
#:   is a _VARIABLE_ value and can be changed between
#:   commands. This allows maximum performance in all cases
#:   if used appropriately.
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
#: #### `BS_LIBSTRING_VERSION_MAJOR`
#:
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_VERSION_MINOR`
#:
#: - Integer >= 0.
#: - Incremented for significant changes that do not
#:   break compatibility with previous versions.
#: - Reset to 0 when
#:   [`BS_LIBSTRING_VERSION_MAJOR`](#bs_libstring_version_major)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_VERSION_PATCH`
#:
#: - Integer >= 0.
#: - Incremented for minor revisions or bugfixes.
#: - Reset to 0 when
#:   [`BS_LIBSTRING_VERSION_MINOR`](#bs_libstring_version_minor)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_VERSION_RELEASE`
#:
#: - A string indicating a pre-release version, always
#:   null for full-release versions.
#: - Possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended).
#:
  BS_LIBSTRING_VERSION_MAJOR=1
  BS_LIBSTRING_VERSION_MINOR=0
  BS_LIBSTRING_VERSION_PATCH=0
BS_LIBSTRING_VERSION_RELEASE=;

fn_bs_libstring_readonly 'BS_LIBSTRING_VERSION_MAJOR'   \
                         'BS_LIBSTRING_VERSION_MINOR'   \
                         'BS_LIBSTRING_VERSION_PATCH'   \
                         'BS_LIBSTRING_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_VERSION_FULL`
#:
#: - Full version combining
#:   [`BS_LIBSTRING_VERSION_MAJOR`](#bs_libstring_version_major),
#:   [`BS_LIBSTRING_VERSION_MINOR`](#bs_libstring_version_minor),
#:   and [`BS_LIBSTRING_VERSION_PATCH`](#bs_libstring_version_patch)
#:   as a single integer.
#: - Can be used in numerical comparisons
#: - Format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded).
#:
BS_LIBSTRING_VERSION_FULL=$(( \
    ( (BS_LIBSTRING_VERSION_MAJOR * 1000) + BS_LIBSTRING_VERSION_MINOR ) * 1000 \
    + BS_LIBSTRING_VERSION_PATCH \
  ))

fn_bs_libstring_readonly 'BS_LIBSTRING_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_VERSION`
#:
#: - Full version combining
#:   [`BS_LIBSTRING_VERSION_MAJOR`](#bs_libstring_version_major),
#:   [`BS_LIBSTRING_VERSION_MINOR`](#bs_libstring_version_minor),
#:   [`BS_LIBSTRING_VERSION_PATCH`](#bs_libstring_version_patch),
#:   and
#:   [`BS_LIBSTRING_VERSION_RELEASE`](#bs_libstring_version_release)
#:   as a formatted string.
#: - Format: `BetterScripts 'libstring' vMAJOR.MINOR.PATCH[-RELEASE]`
#: - Derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#:
BS_LIBSTRING_VERSION="$(
    printf "BetterScripts 'libstring' v%d.%d.%d%s\n" \
           "${BS_LIBSTRING_VERSION_MAJOR}"           \
           "${BS_LIBSTRING_VERSION_MINOR}"           \
           "${BS_LIBSTRING_VERSION_PATCH}"           \
           "${BS_LIBSTRING_VERSION_RELEASE:+-${BS_LIBSTRING_VERSION_RELEASE}}"
  )"

fn_bs_libstring_readonly 'BS_LIBSTRING_VERSION'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_LAST_ERROR`
#:
#: - Stores the error message of the most recent error.
#: - ONLY valid immediately following a command for which
#:   the exit status is not `0` (`<zero>`).
#: - Available even when error output is suppressed.
#:
BS_LIBSTRING_LAST_ERROR=; #< CLEAR ON SOURCING

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_SOURCED`
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
#: #### `BS_LIBSTRING_CONFIG_QUIET_ERRORS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
#: - Type:     _FLAG_
#: - Class:    _VARIABLE_
#: - Default:  _OFF_
#: - \[Enable]/Disable library error message output.
#: - _OFF_: error messages will be written to `STDERR` as:
#:   `[libstring::<COMMAND>]: ERROR: <MESSAGE>`.
#: - _ON_: library error messages will be suppressed.
#: - The most recent error message is always available in
#:   [`BS_LIBSTRING_LAST_ERROR`](#bs_libstring_last_error)
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
#: #### `BS_LIBSTRING_CONFIG_FATAL_ERRORS`
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
#:   [`BS_LIBSTRING_CONFIG_QUIET_ERRORS`](#bs_libstring_config_quiet_errors)).
#: - Both the library version of this option and the
#:   suite version can be modified between command
#:   invocations and will affect the next command.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBSTRING_CONFIG_INDEX_ONE_BASED`
#:
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  _OFF_
#: - Enable/\[Disable] one-based indexing.
#: - _OFF_: use `0` (`<zero>`) based string indexes (i.e.
#:   in the range `[0, size)`).
#: - _ON_:  use `1` (`<one>`) based string indexes (i.e.
#:   in the range `[1, size]`).
#: - Only affects commands that use indexes, i.e.
#:   [`string_index`](#string_index),
#:   [`string_substr`](#string_substr),
#:   and [`string_truncate`](#string_truncate)
#:
case ${BS_LIBSTRING_CONFIG_INDEX_ONE_BASED:-0} in
0) c_BS_LIBSTRING_CFG__first_index=0 ;;
*) c_BS_LIBSTRING_CFG__first_index=1 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__first_index'

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
#. #### `c_BS_LIBSTRING__newline`
#.
#. - Literal `\n` (`<newline>`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_LIBSTRING__newline='
'

fn_bs_libstring_readonly 'c_BS_LIBSTRING__newline'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBSTRING__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
c_BS_LIBSTRING__EX_USAGE=64

fn_bs_libstring_readonly 'c_BS_LIBSTRING__EX_USAGE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBSTRING_CFG__use_param_exp_trim`
#.
#. - Combination of
#.   [`c_BS_LIBSTRING_CFG__use_case_char_class`](#c_bs_libstring_cfg__use_case_char_class)
#.   and
#.   [`c_BS_LIBSTRING_CFG__use_param_expansion_char_class`](#c_bs_libstring_cfg__use_param_expansion_char_class)
#.   to make later tests cleaner and a little faster.
#.
case ${c_BS_LIBSTRING_CFG__use_case_char_class:-0}:${c_BS_LIBSTRING_CFG__use_param_expansion_char_class:-0} in
1:1) c_BS_LIBSTRING_CFG__use_param_exp_trim=1 ;;
  *) c_BS_LIBSTRING_CFG__use_param_exp_trim=0 ;;
esac

fn_bs_libstring_config_constant 'c_BS_LIBSTRING_CFG__use_param_exp_trim'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBSTRING__awk_fn__glob_to_ere`
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
c_BS_LIBSTRING__awk_fn__glob_to_ere='
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

fn_bs_libstring_readonly 'c_BS_LIBSTRING__awk_fn__glob_to_ere'

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
#; ### `fn_bs_libstring_error`
#;
#; Error reporting command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libstring_error <CALLER> <MESSAGE>...
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
#; - If [`BS_LIBSTRING_CONFIG_QUIET_ERRORS`](#bs_libstring_config_quiet_errors)
#;   is _OFF_ a message in the format `[libstring::<COMMAND>]: ERROR: <MESSAGE>`
#;   is written to `STDERR`.
#; - If [`BS_LIBSTRING_CONFIG_FATAL_ERRORS`](#bs_libstring_config_fatal_errors)
#;   is _ON_ then an "unset variable" shell exception will be triggered using
#;   the [`${parameter:?[word]}`][posix_param_expansion] parameter expansion,
#;   where `word` is set to the error message.
#; - [`BS_LIBSTRING_LAST_ERROR`](#bs_libstring_last_error) will contain the
#;   `<MESSAGE>` without any additional prefix regardless of other settings.
#;
#_______________________________________________________________________________
fn_bs_libstring_error() { ## cSpell:Ignore BS_LSE_
  BS_LSE_Caller=${1:?'[libstring::fn_bs_libstring_error]: Internal Error: a command name is required'}

  BS_LIBSTRING_LAST_ERROR=;
  case $# in
  1)  : "${2:?'[libstring::fn_bs_libstring_error]: Internal Error: an error message is required'}" ;;
  2)  BS_LIBSTRING_LAST_ERROR=$2 ;;
  *)  shift
      # NOTE: unset `IFS` == default `IFS`
      #       null  `IFS` == null  `IFS`
      case ${IFS-' '} in
      ' '*) BS_LIBSTRING_LAST_ERROR=$* ;;
         *) BS_LIBSTRING_LAST_ERROR=$(printf '%s ' "$@")
            BS_LIBSTRING_LAST_ERROR=${BS_LIBSTRING_LAST_ERROR% } ;;
      esac ;; #<: `case ${IFS-' '} in`
  esac #<: `case $# in`

  # OUTPUT ERROR
  case ${BS_LIBSTRING_CONFIG_QUIET_ERRORS:-${BETTER_SCRIPTS_CONFIG_QUIET_ERRORS:-0}} in
  0)  printf '[libstring::%s]: ERROR: %s\n' \
             "${BS_LSE_Caller}"            \
             "${BS_LIBSTRING_LAST_ERROR}"   >&2 ;;
  esac

  # ERROR EXCEPTION
  case ${BS_LIBSTRING_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in
  0)  ;;
  *)  BS_LIBSTRING__FatalError=;
      BS_LIBSTRING__ErrorMessage="[libstring::${BS_LSE_Caller}]: ERROR: ${BS_LIBSTRING_LAST_ERROR}"
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
      1)  eval 'BS_LIBSTRING__ErrorMessage=${(qq)BS_LIBSTRING__ErrorMessage}'
          eval ": \"\${BS_LIBSTRING__FatalError:?${BS_LIBSTRING__ErrorMessage}}\"" ;;
      *) : "${BS_LIBSTRING__FatalError:?${BS_LIBSTRING__ErrorMessage}}" ;;
      esac ;;
  esac
} #<: `fn_bs_libstring_error()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libstring_invalid_args <CALLER> <MESSAGE>...
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
fn_bs_libstring_invalid_args() { ## cSpell:Ignore BS_LSIA_
  BS_LSIA_Caller=${1:?'[libstring::fn_bs_libstring_invalid_args]: Internal Error: a command name is required'}
  shift
  fn_bs_libstring_error "${BS_LSIA_Caller}" 'Invalid Arguments:' "$@"
} #<: `fn_bs_libstring_invalid_args()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_expected`
#;
#; Helper for errors reporting incorrect number of arguments.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_expected <CALLER> <EXPECTED>...
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
fn_bs_libstring_expected() { ## cSpell:Ignore BS_LSExpected_
  BS_LSExpected_Caller=${1:?'[libstring::fn_bs_libstring_expected]: Internal Error: a caller is required'}
  shift
  BS_LSExpected_Message=${1:?'[libstring::fn_bs_libstring_expected]: Internal Error: an expected argument is required'}
  shift

  #=========================================================
  #
  #=========================================================
  while : #<: `[ $# -gt 1 ]`
  do
    case $# in
    0)  break ;;
    1)  BS_LSExpected_Message="${BS_LSExpected_Message}, and $1"
        break ;;
    *)  BS_LSExpected_Message="${BS_LSExpected_Message}, $1"
        shift ;;
    esac
  done #<: `while [ $# -gt 1 ]`

  #=========================================================
  #
  #=========================================================
  fn_bs_libstring_error        \
    "${BS_LSExpected_Caller}"  \
    "Invalid Arguments: expected ${BS_LSExpected_Message}"
} #<: `fn_bs_libstring_expected()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_validate_name`
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
#;     fn_bs_libstring_validate_name <CALLER> <NAME>
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
fn_bs_libstring_validate_name() { ## cSpell:Ignore BS_LSVN_
  BS_LSVN_Caller=${1:?'[libstring::fn_bs_libstring_validate_name]: Internal Error: a command name is required'}
    BS_LSVN_Name=${2?'[libstring::fn_bs_libstring_validate_name]: Internal Error: a variable name is required'}

  case ${BS_LSVN_Name:-#} in
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libstring_invalid_args \
      "${BS_LSVN_Caller}"        \
      "invalid variable name '${BS_LSVN_Name}'"
    return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libstring_validate_name()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_validate_name_hyphen`
#;
#; Similar to [`fn_bs_libstring_validate_name`](#fn_bs_libstring_validate_name)
#; but additionally allows the name to be `-` (`<hyphen>`), which implies
#; that `STDOUT` or `STDIN` should in place of the variable be used as
#; appropriate.
#;
#; See [`fn_bs_libstring_validate_name`](#fn_bs_libstring_validate_name) for more
#; details.
#;
#_______________________________________________________________________________
fn_bs_libstring_validate_name_hyphen() { ## cSpell:Ignore BS_LSVNH_
  BS_LSVNH_Caller=${1:?'[libstring::fn_bs_libstring_validate_name_hyphen]: Internal Error: a command name is required'}
    BS_LSVNH_Name=${2?'[libstring::fn_bs_libstring_validate_name_hyphen]: Internal Error: a variable name is required'}

  #---------------------------------------------------------
  # This command is called for many of the main commands.
  # To avoid an additional command call the test from
  # `fn_bs_libstring_validate_name` is duplicated here
  case ${BS_LSVNH_Name:-#} in
  -) : ;;
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libstring_invalid_args \
      "${BS_LSVNH_Caller}"       \
      "invalid variable name '${BS_LSVNH_Name}'"
    return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libstring_validate_name_hyphen()`

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
#; ### `fn_bs_libstring_awk_run_script`
#;
#; Run `awk` with a given script, first passing values via `ARGV` then, if that
#; fails, passing via `STDIN`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_awk_run_script <CALLER> <SCRIPT> <ARG>...
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
#; : Script to run.
#; : _MUST_ contain a function named `bs_fn_main` that
#;   takes an array and a count.
#;
#; `ARG` \[in]
#;
#; : One or more values to pass to `SCRIPT`.
#; : Can be specified one or more times.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - **WARNING:** _Assumes a non-zero exit status is an error._
#; - Any `SCRIPT` that uses a non-zero exit status for a non-error condition
#;   will be run twice - once using `ARGV`, then once using `STDIN`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
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
#.   is restricted to very specific scripts.) Similarly, the widely supported
#.   `-v <assignment>` will **NOT** work as a replacement for `ARGV` as it does
#.   _not_ permit literal `<newline>` characters _and_ processes some escape
#.   sequences.
#. - Arbitrary values passed via `STDIN` to `awk` are possible in numerous ways.
#.   (Recall that `awk` separates input into records and this can not be
#.   disabled, so data containing the record separator must be reconstructed
#.   inside `awk` somehow.) The easiest way is to pass data as a pair of values:
#.   a length, and the data. This allows for multi-line values, along with any
#.   arbitrary data to be passed into `awk` and for `awk` to read the data
#.   easily and correctly as a single value. This is also likely to be the
#.   fastest way to do this, and has no edge cases. (Alternatives may be
#.   faster in some cases, but tend to be more complicated and slower in edge
#.   cases.)
#.
#_______________________________________________________________________________
fn_bs_libstring_awk_run_script() {  ## cSpell:Ignore BS_LS_ARS_
  BS_LS_ARS_Caller=${1:?'[libstring::fn_bs_libstring_awk_run_script]: Internal Error: a caller is required'}
  shift
  BS_LS_ARS_Script=${1:?'[libstring::fn_bs_libstring_awk_run_script]: Internal Error: a script is required'}
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
  case ${BS_LIBSTRING_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBSTRING_CFG__use_dev_null:-0} in
    0:1)
      if  {
            awk "
              ${BS_LS_ARS_Script}"'
              BEGIN {
                bs_fn_main(ARGV, ARGC)
              }
            ' "$@"
          } 2>/dev/null
      then
        return
      fi ;;

    0:0)
      if  BS_LS_ARS_Output=$(
            {
              awk "
                ${BS_LS_ARS_Script}"'
                BEGIN {
                  bs_fn_main(ARGV, ARGC)
                }
              ' "$@"
            } 2>&1
          )
      then
        printf '%s\n' "${BS_LS_ARS_Output}"
        return
      fi ;;
  esac #<: `case ${BS_LIBSTRING_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBSTRING_CFG__use_dev_null:-0} in`

  #=========================================================
  #
  #=========================================================
  fn_bs_libstring_dbg_msg \
    "${BS_LS_ARS_Caller}" \
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
      #.................................
      C|POSIX)
        for BS_LS_ARS_Element
        do
          printf  '%d\n%s\n'              \
                  "${#BS_LS_ARS_Element}" \
                  "${BS_LS_ARS_Element}"
        done
      ;; #<: `C|POSIX)`

      #.................................
      *)
        for BS_LS_ARS_Element
        do
          {
            printf '%s' "${BS_LS_ARS_Element}" | wc -m
          } || {
            fn_bs_libstring_error   \
              "${BS_LS_ARS_Caller}" \
              'unknown error while invoking "wc"'
          }
          printf '%s\n' "${BS_LS_ARS_Element}"
        done
      ;; #<: `*)`
    esac #<: `case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in`
  } | {
    awk "
      ${BS_LS_ARS_Script}"'
      BEGIN {
        getline BS_LS_Count
        BS_LS_Count = BS_LS_Count + 1
        for (i = 1; i < BS_LS_Count; ++i) {
          getline nValueLength
          nValueLength = nValueLength + 0
          getline strValue
          while((length(strValue) < nValueLength) && getline) {
            strValue = strValue "\n" $0
          }
          BS_LS_aValues[i] = strValue
        }

        bs_fn_main(BS_LS_aValues, BS_LS_Count)
      }
    '
  }
} #<: `fn_bs_libstring_awk_run_script()`

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
#; ### `fn_bs_libstring_sanitize_sed_bre`
#;
#; Escape a ["Basic Regular Expression"][posix_bre] such that it can be safely
#; used in a `sed` script.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_sanitize_sed_bre <BRE>
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
fn_bs_libstring_sanitize_sed_bre() { ## cSpell:Ignore BS_LS_SSBRE_
  BS_LS_SSBRE_BRE=${1?'[libstring::fn_bs_libstring_sanitize_sed_bre]: Internal Error: a BRE is required'}

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
    printf '%s\n' "${BS_LS_SSBRE_BRE}"
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
} #<: `fn_bs_libstring_sanitize_sed_bre()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_sanitize_sed_repl`
#;
#; Escape a ["Basic Regular Expression"][posix_bre] such that it can be safely
#; used in a `sed` script as a replacement.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_sanitize_sed_repl <REPLACEMENT>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `REPLACEMENT` \[in]
#;
#; : A value to be used as a replacement in `s/.../.../`.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - If `REPLACEMENT` ends with a `<newline>` character, the caller must take
#;   care that this is not lost.
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
#. - Four sequences need handling here: `\N` (`<backslash><digit>`)
#.   back-reference sequences and `&` (`<ampersand>`, the whole match), both
#.   of which need escaped since, unescaped, they have special meaning in a
#.   `sed` replacement; and `/` (`<slash>`) and `<newline>` characters, which
#.   need escaped for the same reasons as in
#.   [`fn_bs_libstring_sanitize_sed_bre`](#fn_bs_libstring_sanitize_sed_bre).
#.
#_______________________________________________________________________________
fn_bs_libstring_sanitize_sed_repl() { ## cSpell:Ignore BS_LS_SSR_
  BS_LS_SSR_Repl=${1?'[libstring::fn_bs_libstring_sanitize_sed_repl]: Internal Error: a BRE is required'}

  #=========================================================
  #
  #=========================================================
  {
    printf '%s\n' "${BS_LS_SSR_Repl}"
  } | {
    sed -e '
        :LOOP
          $!N
          $!b LOOP
        s|\([^\\]\)\(\\\\\)\(\2*\)\(\\[0123456789]\)|\1\2\3\\\4|g
        s|\([^\\]\)\(\\[0123456789]\)|\1\\\2|g
        s|^\\[0123456789]|\\&|
        s|\([^\\]\)\(\\\\\)\(\2*\)\([/\n&]\)|\1\2\3\\\4|g
        s|\([^\\]\)\([/\n&]\)|\1\\\2|g
        s|^[/\n&]|\\&|
      '
  }
} #<: `fn_bs_libstring_sanitize_sed_repl()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_string_length`
#;
#; Measure the length of a string in **characters**.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_string_length <CALLER> <OUTPUT> <STRING>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable that will contain the output.
#; : MUST be a valid _POSIX.1_ name.
#; : Any current contents will be lost.
#;
#; `STRING` \[in]
#;
#; : Text to be measured.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - Only accurate if the current locale is set appropriately for `STRING` -
#;   see [`string_length`](#string_length), which selects a faster
#;   shell-native path in the `C`/`POSIX` locale instead of calling this
#;   command.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Uses `wc -m`, which is required to correctly count multi-byte
#;   characters outside the `C`/`POSIX` locale.
#;
#_______________________________________________________________________________
fn_bs_libstring_string_length() { ## cSpell:Ignore BS_LS_StrLen_
     BS_LS_StrLen_Caller=${1:?'[libstring::fn_bs_libstring_string_length]: Internal Error: a caller is required'}
  BS_LS_StrLen_refLength=${2:?'[libstring::fn_bs_libstring_string_length]: Internal Error: an output variable is required'}
     BS_LS_StrLen_String=${3?'[libstring::fn_bs_libstring_string_length]: Internal Error: a string is required'}

  {
    eval "
      ${BS_LS_StrLen_refLength}=\$(
          {
            printf '%s' \"\${BS_LS_StrLen_String}\"
          } | {
            wc -m
          }
        )
    "
  } || {
    BS_LS_StrLen_ExitCode=$?
    fn_bs_libstring_error      \
      "${BS_LS_StrLen_Caller}" \
      'unknown error while invoking "wc"'
    return ${BS_LS_StrLen_ExitCode}
  }
} #<: `fn_bs_libstring_string_length()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_string_quote`
#;
#; Safely quote an arbitrary string.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_string_quote <STRING>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `STRING` \[in]
#;
#; : A string to quote.
#;
#_______________________________________________________________________________
fn_bs_libstring_string_quote() { ## cSpell:Ignore BS_LS_SQT_
  BS_LS_SQT_String=${1?'[libstring::fn_bs_libstring_string_quote]: Internal Error: a string is required'}

  {
    printf '%s\n' "${BS_LS_SQT_String}"
  } | {
    #  Script:
    #   - escape embedded <quote> characters
    #   - add a new <quote> as the first character
    #   - add a new <quote> as the last character
    sed -e "
        s/'/'\\\\''/g
        1s/^/'/
        \$s/\$/'/
      "
  }
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_toupper_tr`
#.
#. Wrapper to invoke `tr '[:lower:]' '[:upper:]'`.
#.
#. Intended for use via Parameter Expansion when `tr` is
#. known to support multi-byte characters - in other cases
#. [`fn_bs_libstring_toupper_awk`](#fn_bs_libstring_toupper_awk)
#. should be used.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.    fn_bs_libstring_toupper_tr <STRING>
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `STRING` \[in]
#.
#. : Text to be converted to upper case.
#.
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_tolower_tr`
#.
#. Wrapper to invoke `tr '[:upper:]' '[:lower:]'`.
#.
#. Intended for use via Parameter Expansion when `tr` is
#. known to support multi-byte characters - in other cases
#. [`fn_bs_libstring_tolower_awk`](#fn_bs_libstring_tolower_awk)
#. should be used.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.    fn_bs_libstring_tolower_tr <STRING>
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `STRING` \[in]
#.
#. : Text to be converted to lower case.
#.
#_______________________________________________________________________________
fn_bs_libstring_toupper_tr() { ## cSpell:Ignore BS_LS_TUT_
  BS_LS_TUT_String=${1?'[libstring::fn_bs_libstring_toupper_tr]: Internal Error: a string is required'}
  {
    printf '%s\n' "${BS_LS_TUT_String}"
  } | {
    tr '[:lower:]' '[:upper:]'
  }
}

fn_bs_libstring_tolower_tr() { ## cSpell:Ignore BS_LS_TLT_
  BS_LS_TLT_String=${1?'[libstring::fn_bs_libstring_tolower_tr]: Internal Error: a string is required'}
  {
    printf '%s\n' "${BS_LS_TLT_String}"
  } | {
    tr '[:upper:]' '[:lower:]'
  }
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_toupper_awk`
#.
#. Wrapper to invoke `awk '{ print toupper($0); }'`.
#.
#. Intended for use when `tr` is known to **NOT** support
#. multi-byte characters. Slower but likely to work more
#. widely than the alternative.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.    fn_bs_libstring_toupper_awk <STRING>
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `STRING` \[in]
#.
#. : Text to be converted to upper case.
#.
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libstring_tolower_awk`
#.
#. Wrapper to invoke ` awk '{ print tolower($0); }'`.
#.
#. Intended for use when `tr` is known to **NOT** support
#. multi-byte characters. Slower but likely to work more
#. widely than the alternative.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.    fn_bs_libstring_tolower_awk <STRING>
#.
#. _ARGUMENTS_
#. <!-- -- -->
#.
#. `STRING` \[in]
#.
#. : Text to be converted to lower case.
#.
#_______________________________________________________________________________
fn_bs_libstring_toupper_awk() { ## cSpell:Ignore BS_LS_TUA_
  BS_LS_TUA_String=${1?'[libstring::fn_bs_libstring_toupper_awk]: Internal Error: a string is required'}
  case ${BS_LIBSTRING_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBSTRING_CFG__use_dev_null:-0} in
    0:1)
      if awk '{ print toupper($0); }' "${BS_LS_TUA_String}" 2>/dev/null
      then
        return
      fi ;;
  esac #<: `case ${BS_LIBSTRING_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBSTRING_CFG__use_dev_null:-0} in`

  {
    printf '%s\n' "${BS_LS_TUA_String}"
  } | {
    awk '{ print toupper($0); }'
  }
}

fn_bs_libstring_tolower_awk() { ## cSpell:Ignore BS_LS_TLA_
  BS_LS_TLA_String=${1?'[libstring::fn_bs_libstring_tolower_awk]: Internal Error: a string is required'}
  case ${BS_LIBSTRING_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBSTRING_CFG__use_dev_null:-0} in
    0:1)
      if awk '{ print tolower($0); }' "${BS_LS_TLA_String}" 2>/dev/null
      then
        return
      fi ;;
  esac #<: `case ${BS_LIBSTRING_CONFIG_NO_AWK_ARGV:-${BETTER_SCRIPTS_CONFIG_NO_AWK_ARGV:-0}}:${c_BS_LIBSTRING_CFG__use_dev_null:-0} in`

  {
    printf '%s\n' "${BS_LS_TLA_String}"
  } | {
    awk '{ print tolower($0); }'
  }
}

#_______________________________________________________________________________
## cSpell:Ignore toupper tolower
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_init_cmd_toupper`
#;
#; Resolve the fastest command available for converting text to upper case,
#; then, if any arguments were given, forward them to the resolved command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_init_cmd_toupper [<STRING>]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `STRING` \[in]
#;
#; : Optional - text to be converted to upper case, forwarded to the
#;   resolved command once it has been determined.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - Acts as a lazy (delayed) placeholder for `c_BS_LIBSTRING__CMD__toupper`:
#;   the first call resolves the fastest command, makes the choice permanent
#;   via [`fn_bs_libstring_readonly`](#fn_bs_libstring_readonly), and forwards
#;   any given `STRING` to it so the first call is not wasted.
#; - Only used when
#;   [`BS_LIBSTRING_CONFIG_TR_SUPPORTS_MBC`](#bs_libstring_config_tr_supports_mbc)
#;   resolves to `D` (the default), i.e. resolution is delayed until first
#;   use rather than performed eagerly while the library is sourced.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Prefers [`fn_bs_libstring_toupper_tr`](#fn_bs_libstring_toupper_tr) (`tr`)
#;   if the shell's `tr` correctly round-trips a multi-byte test character,
#;   otherwise falls back to
#;   [`fn_bs_libstring_toupper_awk`](#fn_bs_libstring_toupper_awk) (`awk`).
#;
#-------------------------------------------------------------------------------
# SC2120: foo references arguments, but none are ever passed.
# EXCEPT: Arguments are optional.
# shellcheck disable=SC2120
#_______________________________________________________________________________
fn_bs_libstring_init_cmd_toupper() { ## cSpell:Ignore BS_LS_ICTU_
  #=========================================================
  #
  #=========================================================
  c_BS_LIBSTRING__CMD__toupper=fn_bs_libstring_toupper_awk

  #=========================================================
  #
  #=========================================================
  if  {
        BS_LS_ICTU_fw_A=$(
          fn_bs_libstring_print_utf8_fw_A 2>&1
        )
      } && {
        BS_LS_ICTU_fw_a_toupper=$(
          fn_bs_libstring_print_utf8_fw_a | tr '[:lower:]' '[:upper:]' 2>&1
        )
      }
  then
    case ${BS_LS_ICTU_fw_a_toupper} in
    "${BS_LS_ICTU_fw_A}")
      c_BS_LIBSTRING__CMD__toupper=fn_bs_libstring_toupper_tr ;;
    esac
  fi

  #=========================================================
  #
  #=========================================================
  fn_bs_libstring_readonly 'c_BS_LIBSTRING__CMD__toupper'

  #=========================================================
  #
  #=========================================================
  case $# in
  0) ;;
  *) "${c_BS_LIBSTRING__CMD__toupper}" "$@" ;;
  esac
}

#_______________________________________________________________________________
## cSpell:Ignore toupper tolower
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_init_cmd_tolower`
#;
#; Resolve the fastest command available for converting text to lower case,
#; then, if any arguments were given, forward them to the resolved command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_init_cmd_tolower [<STRING>]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `STRING` \[in]
#;
#; : Optional - text to be converted to lower case, forwarded to the
#;   resolved command once it has been determined.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - Acts as a lazy (delayed) placeholder for `c_BS_LIBSTRING__CMD__tolower`:
#;   the first call resolves the fastest command, makes the choice permanent
#;   via [`fn_bs_libstring_readonly`](#fn_bs_libstring_readonly), and forwards
#;   any given `STRING` to it so the first call is not wasted.
#; - Only used when
#;   [`BS_LIBSTRING_CONFIG_TR_SUPPORTS_MBC`](#bs_libstring_config_tr_supports_mbc)
#;   resolves to `D` (the default), i.e. resolution is delayed until first
#;   use rather than performed eagerly while the library is sourced.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Prefers [`fn_bs_libstring_tolower_tr`](#fn_bs_libstring_tolower_tr) (`tr`)
#;   if the shell's `tr` correctly round-trips a multi-byte test character,
#;   otherwise falls back to
#;   [`fn_bs_libstring_tolower_awk`](#fn_bs_libstring_tolower_awk) (`awk`).
#;
#-------------------------------------------------------------------------------
# SC2120: foo references arguments, but none are ever passed.
# EXCEPT: Arguments are optional.
# shellcheck disable=SC2120
#_______________________________________________________________________________
fn_bs_libstring_init_cmd_tolower() { ## cSpell:Ignore BS_LS_ICTL_
  #=========================================================
  #
  #=========================================================
  c_BS_LIBSTRING__CMD__tolower=fn_bs_libstring_tolower_awk

  #=========================================================
  #
  #=========================================================
  if  {
        BS_LS_ICTL_fw_a=$(
          fn_bs_libstring_print_utf8_fw_a 2>&1
        )
      } && {
        BS_LS_ICTL_fw_A_tolower=$(
          fn_bs_libstring_print_utf8_fw_A | tr '[:upper:]' '[:lower:]' 2>&1
        )
      }
  then
    case ${BS_LS_ICTL_fw_A_tolower} in
    "${BS_LS_ICTL_fw_a}")
      c_BS_LIBSTRING__CMD__tolower=fn_bs_libstring_tolower_tr ;;
    esac
  fi

  #=========================================================
  #
  #=========================================================
  fn_bs_libstring_readonly 'c_BS_LIBSTRING__CMD__tolower'

  #=========================================================
  #
  #=========================================================
  case $# in
  0) ;;
  *) "${c_BS_LIBSTRING__CMD__tolower}" "$@" ;;
  esac
}

#_______________________________________________________________________________
#
#_______________________________________________________________________________
case ${BS_LIBSTRING_CONFIG_TR_SUPPORTS_MBC:-${BETTER_SCRIPTS_CONFIG_TR_SUPPORTS_MBC:-D}} in
A)  fn_bs_libstring_init_cmd_tolower && fn_bs_libstring_init_cmd_toupper ;;
D)  c_BS_LIBSTRING__CMD__tolower='fn_bs_libstring_init_cmd_tolower'
    c_BS_LIBSTRING__CMD__toupper='fn_bs_libstring_init_cmd_toupper' ;;
esac

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_trim_fast`
#;
#; Trim leading and/or trailing whitespace from a string using parameter
#; expansion.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_trim_fast <CALLER> <OUTPUT> <TRIM-LEFT> <TRIM-RIGHT> <STRING>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable that will contain the output.
#; : MUST be a valid _POSIX.1_ name, or `-` (`<hyphen>`)
#;   to write to `STDOUT`.
#; : Any current contents will be lost.
#;
#; `TRIM-LEFT` \[in]
#;
#; : `1` to trim the left (start) of `STRING`, `0` to
#;   leave it unchanged.
#;
#; `TRIM-RIGHT` \[in]
#;
#; : `1` to trim the right (end) of `STRING`, `0` to
#;   leave it unchanged.
#;
#; `STRING` \[in]
#;
#; : Text to be trimmed.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - This will **not** work correctly **unless** the shell was _invoked_ with
#;   the correct locale in effect. Changing the locale _after_ invocation does
#;   **not** change how the shell itself processes data.
#; - Requires the shell supports character classes with _both_ `case` _and_
#;   parameter expansion. If either is unsupported, operations are instead
#;   handled by [`fn_bs_libstring_trim_safe`](#fn_bs_libstring_trim_safe).
#;
#; _NOTES_
#; <!-- -->
#;
#; - Selected by [`string_trim`](#string_trim) when
#;   [`c_BS_LIBSTRING_CFG__use_param_exp_trim`](#c_bs_libstring_cfg__use_param_exp_trim)
#;   is enabled and either the current locale is `C`/`POSIX` or the shell
#;   supports multi-byte characters.
#;
#_______________________________________________________________________________
fn_bs_libstring_trim_fast() { ## cSpell:Ignore BS_LS_STF_
      BS_LS_STF_Caller=${1:?'[libstring::fn_bs_libstring_trim_fast]: Internal Error: a caller is required'}
  BS_LS_STF_refTrimmed=${2:?'[libstring::fn_bs_libstring_trim_fast]: Internal Error: an output variable is required'}
       BS_LS_STF_TrimL=${3:?'[libstring::fn_bs_libstring_trim_fast]: Internal Error: a trim flag (left) required'}
       BS_LS_STF_TrimR=${4:?'[libstring::fn_bs_libstring_trim_fast]: Internal Error: a trim flag (right) required'}
      BS_LS_STF_String=${5:?'[libstring::fn_bs_libstring_trim_fast]: Internal Error: a string is required'}

  #=========================================================
  # Trim
  #=========================================================
  case ${BS_LS_STF_TrimL:-1}:${BS_LS_STF_TrimR:-1} in
    #-------------------------------------------------------
    1:0)
       BS_LS_STF_Prefix=${BS_LS_STF_String%%[![:space:]]*}
      BS_LS_STF_Trimmed=${BS_LS_STF_String#"${BS_LS_STF_Prefix}"}
    ;;

    #-------------------------------------------------------
    0:1)
       BS_LS_STF_Suffix=${BS_LS_STF_String##*[![:space:]]}
      BS_LS_STF_Trimmed=${BS_LS_STF_String%"${BS_LS_STF_Suffix}"}
    ;;

    #-------------------------------------------------------
    *)
       BS_LS_STF_Prefix=${BS_LS_STF_String%%[![:space:]]*}
      BS_LS_STF_Trimmed=${BS_LS_STF_String#"${BS_LS_STF_Prefix}"}

       BS_LS_STF_Suffix=${BS_LS_STF_Trimmed##*[![:space:]]}
      BS_LS_STF_Trimmed=${BS_LS_STF_Trimmed%"${BS_LS_STF_Suffix}"}
    ;;
  esac

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_STF_refTrimmed} in
  -) printf '%s\n' "${BS_LS_STF_Trimmed}"                 ;;
  *) eval "${BS_LS_STF_refTrimmed}=\${BS_LS_STF_Trimmed}" ;;
  esac
} #<: `fn_bs_libstring_trim_fast()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_trim_safe`
#;
#; Trim leading and/or trailing whitespace from a string using `expr` or
#; `sed` - a portable fallback for shells where
#; [`fn_bs_libstring_trim_fast`](#fn_bs_libstring_trim_fast) can not be used.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_trim_safe <CALLER> <OUTPUT> <TRIM-LEFT> <TRIM-RIGHT> <STRING>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable that will contain the output.
#; : MUST be a valid _POSIX.1_ name, or `-` (`<hyphen>`)
#;   to write to `STDOUT`.
#; : Any current contents will be lost.
#;
#; `TRIM-LEFT` \[in]
#;
#; : `1` to trim the left (start) of `STRING`, `0` to
#;   leave it unchanged.
#;
#; `TRIM-RIGHT` \[in]
#;
#; : `1` to trim the right (end) of `STRING`, `0` to
#;   leave it unchanged.
#;
#; `STRING` \[in]
#;
#; : Text to be trimmed.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - Slower than [`fn_bs_libstring_trim_fast`](#fn_bs_libstring_trim_fast), but
#;   does not depend on shell support for character classes in `case` or
#;   parameter expansion.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Prefers `expr` when
#;   [`BS_LIBSTRING_CONFIG_ALLOW_EXPR`](#bs_libstring_config_allow_expr) is
#;   enabled, falling back to `sed` if `expr` fails or is disabled.
#;
#_______________________________________________________________________________
fn_bs_libstring_trim_safe() { ## cSpell:Ignore BS_LS_STS_
      BS_LS_STS_Caller=${1:?'[libstring::fn_bs_libstring_trim_safe]: Internal Error: a caller is required'}
  BS_LS_STS_refTrimmed=${2:?'[libstring::fn_bs_libstring_trim_safe]: Internal Error: an output variable is required'}
       BS_LS_STS_TrimL=${3:?'[libstring::fn_bs_libstring_trim_safe]: Internal Error: a trim flag (left) required'}
       BS_LS_STS_TrimR=${4:?'[libstring::fn_bs_libstring_trim_safe]: Internal Error: a trim flag (right) required'}
      BS_LS_STS_String=${5:?'[libstring::fn_bs_libstring_trim_safe]: Internal Error: a string is required'}

  #=========================================================
  #
  #=========================================================
  case ${c_BS_LIBSTRING_CFG__use_expr} in
  1)  case ${BS_LS_STS_TrimL:-1}:${BS_LS_STS_TrimR:-1} in
      1:0) BS_LS_STS_Expr='[[:space:]]\{1,\}\(.*\)' ;;
      0:1) BS_LS_STS_Expr='\(.*[^[:space:]]\)[[:space:]]\{1,\}' ;;
        *) BS_LS_STS_Expr='[[:space:]]\{1,\}\(.*[^[:space:]]\)[[:space:]]\{1,\}' ;;
      esac

      if  BS_LS_STS_Trimmed=$(
              expr "_${BS_LS_STS_String}_" : "_${BS_LS_STS_Expr}_" 2>&1 && echo '_'
            )
      then
        case ${BS_LS_STS_refTrimmed} in
        -) printf '%s\n' "${BS_LS_STS_Trimmed%?_}"                 ;;
        *) eval "${BS_LS_STS_refTrimmed}=\${BS_LS_STS_Trimmed%?_}" ;;
        esac
        return
      fi ;;
  esac

  #=====================================================
  #
  #=====================================================
  case ${BS_LS_STS_TrimL:-1}:${BS_LS_STS_TrimR:-1} in
  1:0) BS_LS_STS_Expr='s/^[[:space:]]\{1,\}//'   ;;
  0:1) BS_LS_STS_Expr='s/[[:space:]]\{1,\}_$/_/' ;;
    *) BS_LS_STS_Expr='s/^[[:space:]]\{1,\}//
                       s/[[:space:]]\{1,\}_$/_/' ;;
  esac

  #=====================================================
  # Trim
  #=====================================================
  BS_LS_STS_Trimmed=$(
      {
        printf '%s\n' "${BS_LS_STS_String}_"
      } | {
        sed -e '
          :LOOP
            $!N
            $!b LOOP
          '"${BS_LS_STS_Expr}"
      }
    )

  BS_LS_STS_Trimmed=${BS_LS_STS_Trimmed%_}

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_STS_refTrimmed} in
  -) printf '%s\n' "${BS_LS_STS_Trimmed}"                 ;;
  *) eval "${BS_LS_STS_refTrimmed}=\${BS_LS_STS_Trimmed}" ;;
  esac
} #<: `fn_bs_libstring_trim_safe()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_substr_lc_posix`
#;
#; Get a substring from a string by character offset and length - for use in
#; the `C`/`POSIX` locale, where bytes and characters are equivalent.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_substr_lc_posix <CALLER> <STRING> <OFFSET> <LENGTH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `STRING` \[in]
#;
#; : Text to extract a substring from.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `OFFSET` \[in]
#;
#; : Offset of the substring in characters.
#;
#; `LENGTH` \[in]
#;
#; : Length of the substring in characters.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - Only correct in the `C`/`POSIX` locale - see
#;   [`fn_bs_libstring_substr_lc_other`](#fn_bs_libstring_substr_lc_other) for
#;   other locales.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Uses `printf`'s `%.Ns` precision specifier, which is byte-wise, but
#;   equivalent to character-wise in the `C`/`POSIX` locale.
#;
#_______________________________________________________________________________
fn_bs_libstring_substr_lc_posix() { ## cSpell:Ignore BS_LS_SSLCP_
  BS_LS_SSLCP_Caller=${1:?'[libstring::fn_bs_libstring_substr_lc_posix]: Internal Error: a caller is required'}
  BS_LS_SSLCP_String=${2?'[libstring::fn_bs_libstring_substr_lc_posix]: Internal Error: a string is required'}
  BS_LS_SSLCP_Offset=${3:?'[libstring::fn_bs_libstring_substr_lc_posix]: Internal Error: an offset is required'}
  BS_LS_SSLCP_Length=${4:?'[libstring::fn_bs_libstring_substr_lc_posix]: Internal Error: a length is required'}

  #=========================================================
  #
  #=========================================================
  case ${c_BS_LIBSTRING_CFG__first_index} in
  0) BS_LS_SSLCP_ZeroOffset=${BS_LS_SSLCP_Offset}       ;;
  1) BS_LS_SSLCP_ZeroOffset=$((BS_LS_SSLCP_Offset - 1)) ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SSLCP_ZeroOffset} in
    0)
      printf  "%.${BS_LS_SSLCP_Length}s_\n" \
              "${BS_LS_SSLCP_String}"
    ;;

    *)
      if  [ ${#BS_LS_SSLCP_String} -le "${BS_LS_SSLCP_ZeroOffset}" ]
      then
        echo;
      else
        BS_LS_SSLCP_Prefix=$(
            printf  "%.${BS_LS_SSLCP_ZeroOffset}s_\n" \
                    "${BS_LS_SSLCP_String}"
          )

        BS_LS_SSLCP_SubStr=${BS_LS_SSLCP_String#"${BS_LS_SSLCP_Prefix%_}"}

        printf  "%.${BS_LS_SSLCP_Length}s_\n" \
                "${BS_LS_SSLCP_SubStr}"
      fi
    ;;
  esac
} #<: `fn_bs_libstring_substr_lc_posix()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_substr_lc_other`
#;
#; Get a substring from a string by character offset and length - a
#; locale-aware fallback for use outside the `C`/`POSIX` locale.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_substr_lc_other <CALLER> <STRING> <OFFSET> <LENGTH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `STRING` \[in]
#;
#; : Text to extract a substring from.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `OFFSET` \[in]
#;
#; : Offset of the substring in characters.
#;
#; `LENGTH` \[in]
#;
#; : Length of the substring in characters.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - Slower than [`fn_bs_libstring_substr_lc_posix`](#fn_bs_libstring_substr_lc_posix),
#;   but correctly handles multi-byte characters.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Prefers `expr` when
#;   [`BS_LIBSTRING_CONFIG_ALLOW_EXPR`](#bs_libstring_config_allow_expr) is
#;   enabled, falling back to `awk` if `expr` fails or is disabled.
#;
#_______________________________________________________________________________
fn_bs_libstring_substr_lc_other() { ## cSpell:Ignore BS_LS_SSLCO_
  BS_LS_SSLCO_Caller=${1:?'[libstring::fn_bs_libstring_substr_lc_other]: Internal Error: a caller is required'}
  BS_LS_SSLCO_String=${2?'[libstring::fn_bs_libstring_substr_lc_other]: Internal Error: a string is required'}
  BS_LS_SSLCO_Offset=${3:?'[libstring::fn_bs_libstring_substr_lc_other]: Internal Error: an offset is required'}
  BS_LS_SSLCO_Length=${4:?'[libstring::fn_bs_libstring_substr_lc_other]: Internal Error: a length is required'}

  #=========================================================
  #
  #=========================================================

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  fn_bs_libstring_string_length \
    "${BS_LS_SSLCO_Caller}"     \
    BS_LS_SSLCO_StringLen       \
    "${BS_LS_SSLCO_String}"     || return $?

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${c_BS_LIBSTRING_CFG__first_index} in
  0) BS_LS_SSLCO_ZeroOffset=${BS_LS_SSLCO_Offset}       ;;
  1) BS_LS_SSLCO_ZeroOffset=$((BS_LS_SSLCO_Offset - 1)) ;;
  esac

  #=========================================================
  #
  #=========================================================
  if  [ "${BS_LS_SSLCO_StringLen-0}" -le "${BS_LS_SSLCO_ZeroOffset}" ]
  then
    echo;
    return
  fi

  #=========================================================
  #
  #=========================================================
  case ${c_BS_LIBSTRING_CFG__use_expr:-0} in
  1)  case ${BS_LS_SSLCO_ZeroOffset} in
      0) BS_LS_SSLCO_Expr="\(.\{1,${BS_LS_SSLCO_Length}}\).*" ;;
      *) BS_LS_SSLCO_Expr=".\{${BS_LS_SSLCO_ZeroOffset}\}\(.\{1,${BS_LS_SSLCO_Length}}\).*" ;;
      esac

      if  BS_LS_SSLCO_SubStr=$(
              expr "_${BS_LS_SSLCO_String}_" : "_${BS_LS_SSLCO_Expr}_" 2>&1 && echo '_'
            )
      then
        printf '%s\n' "${BS_LS_SSLCO_SubStr%?_}_"
        return
      fi ;;
  esac #<: `for case ${c_BS_LIBSTRING_CFG__use_expr:-0} in`

  #=========================================================
  # NOTE: Some versions of `awk` do not process values as
  #       numerical **unless** they have had arithmetic
  #       performed upon them - hence the need for `+ 0` in
  #       some locations.
  #=========================================================
  fn_bs_libstring_awk_run_script \
    "${BS_LS_SSLCO_Caller}"      \
    '
      function bs_fn_main(argArray, argCount) {
        BS_LS_Offset = argArray[1]
        BS_LS_Offset = BS_LS_Offset + 1
        BS_LS_Length = argArray[2]
        BS_LS_Length = BS_LS_Length + 0
        BS_LS_String = argArray[3]

        if (BS_LS_Length > 0) {
          print substr(BS_LS_String, BS_LS_Offset, BS_LS_Length) "_"
        } else {
          print substr(BS_LS_String, BS_LS_Offset) "_"
        }
      }
    '                           \
    "${BS_LS_SSLCO_ZeroOffset}" \
    "${BS_LS_SSLCO_Length}"     \
    "${BS_LS_SSLCO_String}"
} #<: `fn_bs_libstring_substr_lc_other()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_sub_fixed`
#;
#; Replace one, or all, occurrences of a literal (fixed) string within a
#; string.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_sub_fixed <CALLER> <MODE> <EXPRESSION> <REPLACEMENT> <STRING>
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
#; : `sub` to replace only the first match, any other
#;   value (conventionally `gsub`) to replace all matches.
#;
#; `EXPRESSION` \[in]
#;
#; : Literal (fixed) text to search for.
#;
#; `REPLACEMENT` \[in]
#;
#; : Text used to replace each match.
#;
#; `STRING` \[in]
#;
#; : Text to search for matches within.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `EXPRESSION` MUST NOT be null - it would never match in `sub` mode, and
#;   would cause the replace-all loop to never terminate in `gsub` mode.
#;   Callers (e.g. [`fn_bs_libstring_sub`](#fn_bs_libstring_sub)) MUST
#;   special-case a null `EXPRESSION` before calling this command.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The result is always written to `STDOUT`.
#; - Matches `EXPRESSION` as a literal string - no pattern or regular
#;   expression characters are treated as special.
#;
#_______________________________________________________________________________
fn_bs_libstring_sub_fixed() { ## cSpell:Ignore BS_LS_SubstF_
  BS_LS_SubstF_Caller=${1:?'[libstring::fn_bs_libstring_sub_fixed]: Internal Error: a caller is required'}
    BS_LS_SubstF_Mode=${2:?'[libstring::fn_bs_libstring_sub_fixed]: Internal Error: a mode is required'}
    BS_LS_SubstF_Expr=${3:?'[libstring::fn_bs_libstring_sub_fixed]: Internal Error: an expression is required'}
    BS_LS_SubstF_Repl=${4:?'[libstring::fn_bs_libstring_sub_fixed]: Internal Error: a replacement is required'}
  BS_LS_SubstF_String=${5:?'[libstring::fn_bs_libstring_sub_fixed]: Internal Error: a string is required'}

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SubstF_Mode} in
    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    'sub')
      case ${BS_LS_SubstF_String} in
        #...............................
        #
        #...............................
        *"${BS_LS_SubstF_Expr}"*)
          BS_LS_SubstF_Prefix=${BS_LS_SubstF_String%%"${BS_LS_SubstF_Expr}"*}
          BS_LS_SubstF_Suffix=${BS_LS_SubstF_String#*"${BS_LS_SubstF_Expr}"}
          printf '%s%s%s\n'               \
                 "${BS_LS_SubstF_Prefix}" \
                 "${BS_LS_SubstF_Repl}"   \
                 "${BS_LS_SubstF_Suffix}"
        ;;

        #...............................
        #
        #...............................
        *)
          printf '%s\n' "${BS_LS_SubstF_String}"
        ;;
      esac
    ;; #<: `'sub')`

    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    *)
       BS_LS_SubstF_Processed=;
       BS_LS_SubstF_Remaining=${BS_LS_SubstF_String}

      while :
      do
        case ${BS_LS_SubstF_Remaining} in
          #.............................
          #
          #.............................
          *"${BS_LS_SubstF_Expr}"*)
                BS_LS_SubstF_Prefix=${BS_LS_SubstF_Remaining%%"${BS_LS_SubstF_Expr}"*}
             BS_LS_SubstF_Processed="${BS_LS_SubstF_Processed}${BS_LS_SubstF_Prefix}${BS_LS_SubstF_Repl}"
             BS_LS_SubstF_Remaining=${BS_LS_SubstF_Remaining#*"${BS_LS_SubstF_Expr}"}
          ;;

          #.............................
          #
          #.............................
          *)
            printf '%s%s\n'                    \
                   "${BS_LS_SubstF_Processed}" \
                   "${BS_LS_SubstF_Remaining}"
            break
          ;;
        esac #<: `case ${BS_LS_SubstF_Remaining} in`
      done #<: `while :`
    ;; #<: `*)`
  esac #<: `case ${BS_LS_SubstF_Mode} in`
} #<: `fn_bs_libstring_sub_fixed()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_sub_glob`
#;
#; Replace one, or all, occurrences of a
#; ["Pattern Matching Notation"][posix_glob] match within a string.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_sub_glob <CALLER> <MODE> <GLOB> <REPLACEMENT> <STRING>
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
#; : `sub` to replace only the first match, `gsub` to
#;   replace all matches.
#;
#; `GLOB` \[in]
#;
#; : ["Pattern Matching Notation"][posix_glob] pattern to
#;   search for.
#;
#; `REPLACEMENT` \[in]
#;
#; : Text used to replace each match.
#; : A literal `&` (`<ampersand>`) is replaced with the
#;   matched text.
#;
#; `STRING` \[in]
#;
#; : Text to search for matches within.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `GLOB` MUST NOT be null - see
#;   [`fn_bs_libstring_sub`](#fn_bs_libstring_sub)'s _CAVEATS_.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The result is always written to `STDOUT`.
#; - When the shell natively supports the pattern (i.e.
#;   [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libstring_config_shell_supports_portable_glob)
#;   is _ON_, or the pattern does not contain characters known to be
#;   problematic), shell pattern matching is used directly. Otherwise `GLOB`
#;   is converted to an equivalent
#;   ["Extended Regular Expression"][posix_ere] and processed using `awk`.
#;
#_______________________________________________________________________________
fn_bs_libstring_sub_glob() { ## cSpell:Ignore BS_LS_SubstGF_
   BS_LS_SubstGF_Caller=${1:?'[libstring::fn_bs_libstring_sub_glob]: Internal Error: a caller is required'}
     BS_LS_SubstGF_Mode=${2:?'[libstring::fn_bs_libstring_sub_glob]: Internal Error: a mode is required'}
     BS_LS_SubstGF_Glob=${3:?'[libstring::fn_bs_libstring_sub_glob]: Internal Error: a glob is required'}
     BS_LS_SubstGF_Repl=${4:?'[libstring::fn_bs_libstring_sub_glob]: Internal Error: a replacement is required'}
   BS_LS_SubstGF_String=${5:?'[libstring::fn_bs_libstring_sub_glob]: Internal Error: a string is required'}

  #=========================================================
  #
  #=========================================================
  BS_LS_SubstGF_Fast=0
  case ${c_BS_LIBSTRING_CFG__full_glob_support}:${c_BS_LIBSTRING_CFG__shell_supports_mbc}:${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    1:1:*|1:0:C|1:0:POSIX)
      BS_LS_SubstGF_Fast=1 ;;

    0:1:*|0:0:C|0:0:POSIX)
      case ${BS_LS_SubstGF_Glob} in
      *[\\\(\)]*) BS_LS_SubstGF_Fast=0 ;;
               *) BS_LS_SubstGF_Fast=1 ;;
      esac ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SubstGF_Fast} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1)
      #-----------------------------------------------------
      # As ever, `zsh` needs some settings changed or it
      # will always fail.
      #-----------------------------------------------------
      case ${c_BS_LIBSTRING_CFG__use_zsh_setopt} in
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
      case ${BS_LS_SubstGF_Mode} in
        #...................................................
        #
        #...................................................
        'sub')
          BS_LS_SubstGF_Prefix=${BS_LS_SubstGF_String%%${BS_LS_SubstGF_Glob}*}

          if [ ${#BS_LS_SubstGF_Prefix} -lt ${#BS_LS_SubstGF_String} ]
          then
            BS_LS_SubstGF_Suffix=${BS_LS_SubstGF_String#*${BS_LS_SubstGF_Glob}}
            printf '%s%s%s\n'                \
                   "${BS_LS_SubstGF_Prefix}" \
                   "${BS_LS_SubstGF_Repl}"   \
                   "${BS_LS_SubstGF_Suffix}"
          else
            printf '%s\n' "${BS_LS_SubstGF_String}"
          fi
        ;; #<: `'sub')`

        #...................................................
        #
        #...................................................
        *)
          BS_LS_SubstGF_Processed=;
          BS_LS_SubstGF_Remaining=${BS_LS_SubstGF_String}

          while :
          do
            BS_LS_SubstGF_Prefix=${BS_LS_SubstGF_Remaining%%${BS_LS_SubstGF_Glob}*}

            if [ ${#BS_LS_SubstGF_Prefix} -lt ${#BS_LS_SubstGF_Remaining} ]
            then
              BS_LS_SubstGF_Processed="${BS_LS_SubstGF_Processed}${BS_LS_SubstGF_Prefix}${BS_LS_SubstGF_Repl}"
              BS_LS_SubstGF_Remaining=${BS_LS_SubstGF_Remaining#*${BS_LS_SubstGF_Glob}}
            else
              printf '%s%s\n'                     \
                     "${BS_LS_SubstGF_Processed}" \
                     "${BS_LS_SubstGF_Remaining}"
              break
            fi
          done #<: `while :`
        ;; #<: `*)`
      esac #<: `case ${BS_LS_SubstGF_Mode} in`
    ;; #<: `1)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    0)
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libstring_dbg_msg     \
        "${BS_LS_SubstGF_Caller}" \
        "Using emulated globs (expression '${BS_LS_SubstGF_Glob}')"

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      case ${BS_LS_SubstGF_Repl} in
      *'&'*)  BS_LS_SubstGF_Repl=$(
                  {
                    printf '%s_\n' "${BS_LS_SubstGF_Repl}"
                  } | {
                    sed -e '
                        s|\([^\\]\)\(\\\\\)\(\2*\)&|\1\2\3\\\&|g
                        s|\([^\\]\)&|\1\\\&|g
                        s|^&|\\\&|
                      '
                  }
                )
              BS_LS_SubstGF_Repl=${BS_LS_SubstGF_Repl%_} ;;
      esac

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libstring_awk_run_script \
        "${BS_LS_SubstGF_Caller}"    \
        "${c_BS_LIBSTRING__awk_fn__glob_to_ere}"'
          function bs_fn_main(argArray, argCount) {
            BS_LS_Glob   = argArray[1]
            BS_LS_Repl   = argArray[2]
            BS_LS_String = argArray[3]

            BS_LS_ERE = bs_fn_glob_to_ere(BS_LS_Glob)

            '"${BS_LS_SubstGF_Mode}"'(BS_LS_ERE, BS_LS_Repl, BS_LS_String)
            print BS_LS_String
          }
        '                        \
        "${BS_LS_SubstGF_Glob}"  \
        "${BS_LS_SubstGF_Repl}"  \
        "${BS_LS_SubstGF_String}"
    ;; #<: `0)`
  esac #<: `case ${BS_LS_SubstGF_Fast} in`
} #<: `fn_bs_libstring_sub_glob()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_sub_bre`
#;
#; Replace one, or all, occurrences of a
#; ["Basic Regular Expression"][posix_bre] match within a string, using `sed`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_sub_bre <CALLER> <MODE> <BRE> <REPLACEMENT> <STRING>
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
#; : `sub` to replace only the first match, `gsub` to
#;   replace all matches.
#;
#; `BRE` \[in]
#;
#; : ["Basic Regular Expression"][posix_bre] pattern to
#;   search for.
#;
#; `REPLACEMENT` \[in]
#;
#; : Text used to replace each match.
#; : Supports `sed`'s `s/.../.../` replacement syntax
#;   (e.g. `&`, `\N` back-references).
#;
#; `STRING` \[in]
#;
#; : Text to search for matches within.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `BRE` MUST NOT be null - see
#;   [`fn_bs_libstring_sub`](#fn_bs_libstring_sub)'s _CAVEATS_.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The result is always written to `STDOUT`.
#; - `BRE`/`REPLACEMENT` are escaped as needed (via
#;   [`fn_bs_libstring_sanitize_sed_bre`](#fn_bs_libstring_sanitize_sed_bre)/
#;   [`fn_bs_libstring_sanitize_sed_repl`](#fn_bs_libstring_sanitize_sed_repl))
#;   to safely embed values containing `/`, `&`, back-reference-like
#;   sequences, or embedded `<newline>` characters in the `sed` script.
#;
#_______________________________________________________________________________
fn_bs_libstring_sub_bre() { ## cSpell:Ignore BS_LS_SubstBRE_
  BS_LS_SubstBRE_Caller=${1:?'[libstring::fn_bs_libstring_sub_bre]: Internal Error: a caller is required'}
    BS_LS_SubstBRE_Mode=${2:?'[libstring::fn_bs_libstring_sub_bre]: Internal Error: a mode is required'}
    BS_LS_SubstBRE_Expr=${3:?'[libstring::fn_bs_libstring_sub_bre]: Internal Error: a BRE is required'}
    BS_LS_SubstBRE_Repl=${4:?'[libstring::fn_bs_libstring_sub_bre]: Internal Error: a replacement is required'}
  BS_LS_SubstBRE_String=${5:?'[libstring::fn_bs_libstring_sub_bre]: Internal Error: a string is required'}

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SubstBRE_Mode} in
   sub) BS_LS_SubstBRE_Mode=; ;;
  gsub) BS_LS_SubstBRE_Mode=g ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SubstBRE_Expr} in
  *'/'*|*"${c_BS_LIBSTRING__newline}"*)
    BS_LS_SubstBRE_Expr=$(
        fn_bs_libstring_sanitize_sed_bre "${BS_LS_SubstBRE_Expr}_"
      ) || return $?
    BS_LS_SubstBRE_Expr=${BS_LS_SubstBRE_Expr%_} ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SubstBRE_Repl} in
  *'/'*|*'&'*|*\\[0123456789]*|*"${c_BS_LIBSTRING__newline}"*)
    BS_LS_SubstBRE_Repl=$(
        fn_bs_libstring_sanitize_sed_repl "${BS_LS_SubstBRE_Repl}_"
      ) || return $?
    BS_LS_SubstBRE_Repl=${BS_LS_SubstBRE_Repl%_} ;;
  esac #<: `case ${BS_LS_SubstBRE_Repl} in`

  #=========================================================
  #
  #=========================================================
  {
    printf '%s\n' "${BS_LS_SubstBRE_String}"
  } | {
    sed -e "
      :LOOP
        \$!N
        \$!b LOOP
      s/${BS_LS_SubstBRE_Expr}/${BS_LS_SubstBRE_Repl}/${BS_LS_SubstBRE_Mode}
    "
  }
} #<: `fn_bs_libstring_sub_bre()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_sub_ere`
#;
#; Replace one, or all, occurrences of an
#; ["Extended Regular Expression"][posix_ere] match within a string, using
#; `awk`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_sub_ere <CALLER> <MODE> <ERE> <REPLACEMENT> <STRING>
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
#; : `sub` to replace only the first match, `gsub` to
#;   replace all matches.
#;
#; `ERE` \[in]
#;
#; : ["Extended Regular Expression"][posix_ere] pattern
#;   to search for.
#;
#; `REPLACEMENT` \[in]
#;
#; : Text used to replace each match.
#; : A literal `&` (`<ampersand>`) is replaced with the
#;   matched text.
#;
#; `STRING` \[in]
#;
#; : Text to search for matches within.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `ERE` MUST NOT be null - see
#;   [`fn_bs_libstring_sub`](#fn_bs_libstring_sub)'s _CAVEATS_.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The result is always written to `STDOUT`.
#; - `MODE` is used directly as the name of the underlying `awk` function -
#;   callers MUST pass exactly `sub` or `gsub`.
#;
#_______________________________________________________________________________
fn_bs_libstring_sub_ere() { ## cSpell:Ignore BS_LS_SearchERE_
  BS_LS_SearchERE_Caller=${1:?'[libstring::fn_bs_libstring_sub_ere]: Internal Error: a caller is required'}
    BS_LS_SearchERE_Mode=${2:?'[libstring::fn_bs_libstring_sub_ere]: Internal Error: a mode is required'}
    BS_LS_SearchERE_Expr=${3:?'[libstring::fn_bs_libstring_sub_ere]: Internal Error: an ERE is required'}
    BS_LS_SearchERE_Repl=${4:?'[libstring::fn_bs_libstring_sub_ere]: Internal Error: a replacement is required'}
  BS_LS_SearchERE_String=${5:?'[libstring::fn_bs_libstring_sub_ere]: Internal Error: a string is required'}

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SearchERE_Repl} in
  *'&'*)  BS_LS_SearchERE_Repl=$(
              {
                printf '%s_\n' "${BS_LS_SearchERE_Repl}"
              } | {
                sed -e '
                    s|\([^\\]\)\(\\\\\)\(\2*\)&|\1\2\3\\\&|g
                    s|\([^\\]\)&|\1\\\&|g
                    s|^&|\\\&|
                  '
              }
            )
          BS_LS_SearchERE_Repl=${BS_LS_SearchERE_Repl%_} ;;
  esac

  #=========================================================
  #
  #=========================================================
  fn_bs_libstring_awk_run_script \
    "${BS_LS_SearchERE_Caller}"  \
    "${c_BS_LIBSTRING__awk_fn__glob_to_ere}"'
      function bs_fn_main(argArray, argCount) {
        BS_LS_ERE    = argArray[1]
        BS_LS_Repl   = argArray[2]
        BS_LS_String = argArray[3]
        '"${BS_LS_SearchERE_Mode}"'(BS_LS_ERE, BS_LS_Repl, BS_LS_String)
        print BS_LS_String
      }
    '                          \
    "${BS_LS_SearchERE_Expr}"  \
    "${BS_LS_SearchERE_Repl}"  \
    "${BS_LS_SearchERE_String}"
} #<: `fn_bs_libstring_sub_ere()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_sub`
#;
#; Replace one, or all, occurrences of a pattern within a string -
#; implementation is delegated to one of
#; [`fn_bs_libstring_sub_ere`](#fn_bs_libstring_sub_ere) (default),
#; [`fn_bs_libstring_sub_bre`](#fn_bs_libstring_sub_bre),
#; [`fn_bs_libstring_sub_fixed`](#fn_bs_libstring_sub_fixed), or
#; [`fn_bs_libstring_sub_glob`](#fn_bs_libstring_sub_glob) depending on the
#; pattern-matching option given.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_sub <CALLER> <MODE> [-E|--ere|--extended-regexp] [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#;
#;     fn_bs_libstring_sub <CALLER> <MODE> -F|--text|--fixed-strings [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#;
#;     fn_bs_libstring_sub <CALLER> <MODE> -G|--bre|--basic-regexp [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#;
#;     fn_bs_libstring_sub <CALLER> <MODE> -W|--glob|--wildcard [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `-E`, `--ere`, `--extended-regexp` \[in]
#;
#; : Interpret `EXPRESSION` as an
#;   ["Extended Regular Expression"][posix_ere].
#; : This is the default.
#;
#; `-F`, `--text`, `--fixed-strings` \[in]
#;
#; : Interpret `EXPRESSION` as a fixed string.
#;
#; `-G`, `--bre`, `--basic-regexp` \[in]
#;
#; : Interpret `EXPRESSION` as a
#;   ["Basic Regular Expression"][posix_bre].
#;
#; `-W`, `--glob`, `--wildcard` \[in]
#;
#; : Interpret `EXPRESSION` as
#;   ["Pattern Matching Notation"][posix_glob].
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Added to the output message.
#;
#; `MODE` \[in]
#;
#; : `sub` to replace only the first match, `gsub` to
#;   replace all matches.
#;
#; `STRING` \[in]
#;
#; : Text to search for matches within.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `EXPRESSION` \[in]
#;
#; : Pattern to search for, interpreted according to the
#;   option given.
#; : Can be null.
#;
#; `REPLACEMENT` \[in]
#;
#; : Text used to replace each match.
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable that will contain the output.
#; : MUST be a valid _POSIX.1_ name.
#; : Any current contents will be lost.
#; : If not specified, or specified as `-` (`<hyphen>`)
#;   output is written to `STDOUT`.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - If `STRING` or `EXPRESSION` is null, the result is always null (**not**
#;   `STRING` unchanged) - this avoids delegating to the resolved
#;   implementation command, none of which correctly support a null
#;   `EXPRESSION` (see e.g.
#;   [`fn_bs_libstring_sub_fixed`](#fn_bs_libstring_sub_fixed)'s _CAVEATS_).
#;
#; _NOTES_
#; <!-- -->
#;
#; - `MODE` is forwarded unchanged to the resolved implementation command,
#;   and, other than for
#;   [`fn_bs_libstring_sub_fixed`](#fn_bs_libstring_sub_fixed), used directly
#;   as the name of the underlying `awk` function (`sub`/`gsub`) - callers
#;   MUST pass exactly `sub` or `gsub`.
#;
#_______________________________________________________________________________
fn_bs_libstring_sub() { ## cSpell:Ignore BS_LS_Sub_
  BS_LS_Sub_Caller=${1:?'[libstring::fn_bs_libstring_sub]: Internal Error: a caller is required'}
  shift
  BS_LS_Sub_SubMode=${1:?'[libstring::fn_bs_libstring_sub]: Internal Error: a mode is required'}
  shift

  #=========================================================
  # Argument Processing
  #=========================================================

  #---------------------------------------------------------
  # Check for options
  #---------------------------------------------------------
  BS_LS_Sub_Command='fn_bs_libstring_sub_ere'
  case ${1-} in
  '-E' | '--ere'  | '--extended-regexp') BS_LS_Sub_Command='fn_bs_libstring_sub_ere';   shift ;;
  '-F' | '--text' | '--fixed-strings'  ) BS_LS_Sub_Command='fn_bs_libstring_sub_fixed'; shift ;;
  '-G' | '--bre'  | '--basic-regexp'   ) BS_LS_Sub_Command='fn_bs_libstring_sub_bre';   shift ;;
  '-W' | '--glob' | '--wildcard'       ) BS_LS_Sub_Command='fn_bs_libstring_sub_glob';  shift ;;
  esac

  #---------------------------------------------------------
  # Skip any option delimiter
  #---------------------------------------------------------
  case ${1-} in --) shift ;; esac

  #---------------------------------------------------------
  # Process operands
  #---------------------------------------------------------
  case $# in
  3)     BS_LS_Sub_String=$1
           BS_LS_Sub_Expr=$2
           BS_LS_Sub_Repl=$3
      BS_LS_Sub_refOutput=-  ;;

  4)  BS_LS_Sub_refOutput=$1
         BS_LS_Sub_String=$2
           BS_LS_Sub_Expr=$3
           BS_LS_Sub_Repl=$4

      fn_bs_libstring_validate_name_hyphen \
        "${BS_LS_Sub_Caller}"              \
        "${BS_LS_Sub_refOutput}"           || return $? ;;

  *)  fn_bs_libstring_expected \
        "${BS_LS_Sub_Caller}"  \
        'one of -G|--bre|--basic-regexp, -E|--ere|--extended-regexp, -F|--text|--fixed-strings, or -W|--glob|--wildcard (optional)' \
        'an output variable (optional)' \
        'a string'             \
        'an expression'        \
        'replacement text'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac

  #=========================================================
  # Sub & Output/Save
  #=========================================================
  case ${BS_LS_Sub_String:+S}:${BS_LS_Sub_Expr:+E}:${BS_LS_Sub_refOutput-} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    S:E:-)
      "${BS_LS_Sub_Command}"   \
        "${BS_LS_Sub_Caller}"  \
        "${BS_LS_Sub_SubMode}" \
        "${BS_LS_Sub_Expr}"    \
        "${BS_LS_Sub_Repl}"    \
        "${BS_LS_Sub_String}"  || return $?
    ;; #:< `-)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    S:E:*)
      BS_LS_Sub_Output=$(
          if  "${BS_LS_Sub_Command}"   \
                "${BS_LS_Sub_Caller}"  \
                "${BS_LS_Sub_SubMode}" \
                "${BS_LS_Sub_Expr}"    \
                "${BS_LS_Sub_Repl}"    \
                "${BS_LS_Sub_String}"
          then
            echo '_'
          else
            return $?
          fi
        )

      eval "${BS_LS_Sub_refOutput}=\${BS_LS_Sub_Output%?_}"
    ;; #:< `S:E:*)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    S::-|:E:-|::-)
      echo
    ;; #:< `S::-|:E:-|::-)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      eval "${BS_LS_Sub_refOutput}="
    ;; #:< `*)`
  esac #:< `case ${BS_LS_Sub_refOutput-} in`
} #<: `fn_bs_libstring_sub()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_search_fixed`
#;
#; Find the first occurrence of a literal (fixed) string within another
#; string.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_search_fixed <CALLER> <STRING> <SEARCH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `STRING` \[in]
#;
#; : Text to be searched.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `SEARCH` \[in]
#;
#; : Literal (fixed) text to search for.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `SEARCH` MUST NOT be null - see
#;   [`fn_bs_libstring_search`](#fn_bs_libstring_search)'s _CAVEATS_.
#;
#; _NOTES_
#; <!-- -->
#;
#; - On success, sets `BS_LIBSTRING_MATCH_START` (offset of the first match)
#;   and `BS_LIBSTRING_MATCH_LENGTH` (length of `SEARCH`).
#; - Returns `1` (`<one>`) if `SEARCH` is not found within `STRING`.
#; - Matches `SEARCH` as a literal string - no pattern or regular expression
#;   characters are treated as special.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Uses shell pattern matching (`case ${STRING} in *"${SEARCH}"*) ...`) to
#.   test for a match, then parameter expansion
#.   (`${STRING%%"${SEARCH}"*}`) to compute the prefix preceding the match,
#.   whose length gives `BS_LIBSTRING_MATCH_START`.
#.
#_______________________________________________________________________________
fn_bs_libstring_search_fixed() { ## cSpell:Ignore BS_LS_SearchF_
  BS_LS_SearchF_Caller=${1:?'[libstring::fn_bs_libstring_search_fixed]: Internal Error: a caller is required'}
  BS_LS_SearchF_String=${2:?'[libstring::fn_bs_libstring_search_fixed]: Internal Error: a string is required'}
  BS_LS_SearchF_Search=${3:?'[libstring::fn_bs_libstring_search_fixed]: Internal Error: an expression is required'}

  #=========================================================
  #
  #=========================================================
  case "${BS_LS_SearchF_String}" in
  *"${BS_LS_SearchF_Search}"*) ;;
  *) return 1 ;;
  esac

  #=========================================================
  #
  #=========================================================
  BS_LS_SearchF_Match=${BS_LS_SearchF_String%%"${BS_LS_SearchF_Search}"*}

  #=========================================================
  #
  #=========================================================
  case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    C|POSIX)
       BS_LIBSTRING_MATCH_START=${#BS_LS_SearchF_Match}
      BS_LIBSTRING_MATCH_LENGTH=${#BS_LS_SearchF_Search}
    ;;

    *)
      fn_bs_libstring_string_length \
        "${BS_LS_SearchF_Caller}"   \
        BS_LIBSTRING_MATCH_START    \
        "${BS_LS_SearchF_Match}"    || return $?

      fn_bs_libstring_string_length \
        "${BS_LS_SearchF_Caller}"   \
        BS_LIBSTRING_MATCH_LENGTH   \
        "${BS_LS_SearchF_Search}"   || return $?
    ;;
  esac
} #<: `fn_bs_libstring_search_fixed()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_search_glob`
#;
#; Find the first occurrence of a
#; ["Pattern Matching Notation"][posix_glob] match within another string.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_search_glob <CALLER> <STRING> <SEARCH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `STRING` \[in]
#;
#; : Text to be searched.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `SEARCH` \[in]
#;
#; : ["Pattern Matching Notation"][posix_glob] pattern to
#;   search for.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `SEARCH` MUST NOT be null - see
#;   [`fn_bs_libstring_search`](#fn_bs_libstring_search)'s _CAVEATS_.
#;
#; _NOTES_
#; <!-- -->
#;
#; - On success, sets `BS_LIBSTRING_MATCH_START` (offset of the first match)
#;   and `BS_LIBSTRING_MATCH_LENGTH` (length of the match).
#; - Returns `1` (`<one>`) if `SEARCH` does not match `STRING`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - In the `C`/`POSIX` locale, shell pattern matching is used directly.
#.   In any other locale, `SEARCH` is converted to an equivalent
#.   ["Extended Regular Expression"][posix_ere] and matched using `awk`.
#.
#_______________________________________________________________________________
fn_bs_libstring_search_glob() { ## cSpell:Ignore BS_LS_SGLP_
  BS_LS_SGLP_Caller=${1:?'[libstring::fn_bs_libstring_search_glob]: Internal Error: a caller is required'}
  BS_LS_SGLP_String=${2:?'[libstring::fn_bs_libstring_search_glob]: Internal Error: a string is required'}
  BS_LS_SGLP_Search=${3:?'[libstring::fn_bs_libstring_search_glob]: Internal Error: an expression is required'}

  #=========================================================
  #
  #=========================================================
  BS_LS_SGLP_Fast=0
  case ${c_BS_LIBSTRING_CFG__full_glob_support}:${c_BS_LIBSTRING_CFG__shell_supports_mbc}:${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    1:1:*|1:0:C|1:0:POSIX)
      BS_LS_SGLP_Fast=1 ;;

    0:1:*|0:0:C|0:0:POSIX)
      case ${BS_LS_SGLP_Search} in
      *[\\\(\)]*) BS_LS_SGLP_Fast=0 ;;
               *) BS_LS_SGLP_Fast=1 ;;
      esac ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SGLP_Fast} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1)
      #-----------------------------------------------------
      # As ever, `zsh` needs some settings changed or it
      # will always fail.
      #-----------------------------------------------------
      case ${c_BS_LIBSTRING_CFG__use_zsh_setopt} in
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
      {
        BS_LS_SGLP_Prefix=${BS_LS_SGLP_String%%${BS_LS_SGLP_Search}*}

        if [ ${#BS_LS_SGLP_Prefix} -lt ${#BS_LS_SGLP_String} ]
        then
          BS_LS_SGLP_Suffix=${BS_LS_SGLP_String#*${BS_LS_SGLP_Search}}

          BS_LIBSTRING_MATCH_START=${#BS_LS_SGLP_Prefix}
          BS_LIBSTRING_MATCH_LENGTH=$((
              ${#BS_LS_SGLP_String} - (${#BS_LS_SGLP_Prefix} + ${#BS_LS_SGLP_Suffix})
            ))
        else
          return 1
        fi
      }
    ;; #<: `C|POSIX)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libstring_dbg_msg  \
        "${BS_LS_SGLP_Caller}" \
        "Using emulated globs (expression '${BS_LS_SGLP_Search}')"

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      BS_LS_SGLP_Match=$(
          fn_bs_libstring_awk_run_script \
            "${BS_LS_SGLP_Caller}"       \
            "${c_BS_LIBSTRING__awk_fn__glob_to_ere}"'
              function bs_fn_main(argArray, argCount) {
                  BS_LS_Glob   = argArray[1]
                  BS_LS_String = argArray[2]

                  BS_LS_ERE = bs_fn_glob_to_ere(BS_LS_Glob)

                  if (match(BS_LS_String, BS_LS_ERE)) {
                    printf("MATCH\n%d\n%d\n", (RSTART - 1), RLENGTH)
                  } else {
                    print "NO MATCH"
                  }
              }
            '                      \
            "${BS_LS_SGLP_Search}" \
            "${BS_LS_SGLP_String}"
        ) || return $?

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      case ${BS_LS_SGLP_Match} in 'NO MATCH') return 1 ;; esac

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      BS_LS_SGLP_Match=${BS_LS_SGLP_Match#*"${c_BS_LIBSTRING__newline}"}

       BS_LIBSTRING_MATCH_START=${BS_LS_SGLP_Match%%"${c_BS_LIBSTRING__newline}"*}
      BS_LIBSTRING_MATCH_LENGTH=${BS_LS_SGLP_Match#*"${c_BS_LIBSTRING__newline}"}
    ;; #<: `*)`
  esac #<: `case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in`
} #<: `fn_bs_libstring_search_glob()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_search_bre`
#;
#; Find the first occurrence of a ["Basic Regular Expression"][posix_bre]
#; match within another string, using `sed`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_search_bre <CALLER> <STRING> <SEARCH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `STRING` \[in]
#;
#; : Text to be searched.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `SEARCH` \[in]
#;
#; : ["Basic Regular Expression"][posix_bre] pattern to
#;   search for.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `SEARCH` MUST NOT be null - see
#;   [`fn_bs_libstring_search`](#fn_bs_libstring_search)'s _CAVEATS_.
#;
#; _NOTES_
#; <!-- -->
#;
#; - On success, sets `BS_LIBSTRING_MATCH_START` (offset of the first match)
#;   and `BS_LIBSTRING_MATCH_LENGTH` (length of the match).
#; - Returns `1` (`<one>`) if `SEARCH` does not match `STRING`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Uses `sed -n` with two `s/.../.../` commands to isolate the first
#.   (leftmost, then shortest) match, since `sed` matches are greedy and a
#.   single `s/^.*\(SEARCH\).*$/\1/` would always select the **last**
#.   matching substring.
#. - `SEARCH` is escaped as needed (via
#.   [`fn_bs_libstring_sanitize_sed_bre`](#fn_bs_libstring_sanitize_sed_bre))
#.   to safely embed values containing `/` or embedded `<newline>`
#.   characters in the `sed` script.
#.
#_______________________________________________________________________________
fn_bs_libstring_search_bre() { ## cSpell:Ignore BS_LS_SubstBRE_
  BS_LS_SubstBRE_Caller=${1:?'[libstring::fn_bs_libstring_search_bre]: Internal Error: a caller is required'}
  BS_LS_SubstBRE_String=${2:?'[libstring::fn_bs_libstring_search_bre]: Internal Error: a string is required'}
  BS_LS_SubstBRE_Search=${3:?'[libstring::fn_bs_libstring_search_bre]: Internal Error: a BRE is required'}

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SubstBRE_Search} in
  *'/'*|*"${c_BS_LIBSTRING__newline}"*)
    BS_LS_SubstBRE_Search=$(
        fn_bs_libstring_sanitize_sed_bre "${BS_LS_SubstBRE_Search}_"
      ) || return $?
    BS_LS_SubstBRE_Search=${BS_LS_SubstBRE_Search%_} ;;
  esac

  #=========================================================
  # NOTE:
  #  - The `sed` script needs two `s/.../.../` functions as
  #    `sed` matches are greedy and so matches will always
  #    select the **last** matching expression when used
  #    as `s/^.*\(${BS_LS_SubstBRE_Search}\).*_$/\1_/`.
  #=========================================================
  BS_LS_SubstBRE_Match=$(
      {
        printf '%s\n' "${BS_LS_SubstBRE_String}_"
      } | {
        sed -n -e "
            :LOOP
              \$!N
              \$!b LOOP
            s/\(${BS_LS_SubstBRE_Search}\).*_\$/\1_/
            s/^.*\(${BS_LS_SubstBRE_Search}\)_\$/\1_/p
          "
      }
    )

  #=========================================================
  # As an `_` (`<underscore>`) is added to successful
  # matches, the output will always contain at least a
  # single character on success.
  #=========================================================
  case ${BS_LS_SubstBRE_Match:+1} in 1) ;; *) return 1 ;; esac

  #=========================================================
  #
  #=========================================================
  BS_LS_SubstBRE_Match=${BS_LS_SubstBRE_Match%_}

  BS_LS_SubstBRE_Prefix=${BS_LS_SubstBRE_String%%"${BS_LS_SubstBRE_Match}"*}
  BS_LS_SubstBRE_Suffix=${BS_LS_SubstBRE_String#*"${BS_LS_SubstBRE_Match}"}

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    C|POSIX)
      BS_LS_SearchG_PrefixLen=${#BS_LS_SubstBRE_Prefix}
      BS_LS_SearchG_SuffixLen=${#BS_LS_SubstBRE_Suffix}
      BS_LS_SearchG_StringLen=${#BS_LS_SubstBRE_String}
    ;;

    *)
      fn_bs_libstring_string_length \
        "${BS_LS_SubstBRE_Caller}"  \
        BS_LS_SearchG_PrefixLen     \
        "${BS_LS_SubstBRE_Prefix}"  || return $?

      fn_bs_libstring_string_length \
        "${BS_LS_SubstBRE_Caller}"  \
        BS_LS_SearchG_SuffixLen     \
        "${BS_LS_SubstBRE_Suffix}"  || return $?

      fn_bs_libstring_string_length \
        "${BS_LS_SubstBRE_Caller}"  \
        BS_LS_SearchG_StringLen     \
        "${BS_LS_SubstBRE_String}"  || return $?
    ;;
  esac

  #=========================================================
  #
  #=========================================================
   BS_LIBSTRING_MATCH_START=${BS_LS_SearchG_PrefixLen}
  BS_LIBSTRING_MATCH_LENGTH=$((
      BS_LS_SearchG_StringLen - (BS_LS_SearchG_PrefixLen + BS_LS_SearchG_SuffixLen)
    ))
} #<: `fn_bs_libstring_search_bre()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_search_ere`
#;
#; Find the first occurrence of an ["Extended Regular Expression"][posix_ere]
#; match within another string, using `awk`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_search_ere <CALLER> <STRING> <SEARCH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `STRING` \[in]
#;
#; : Text to be searched.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `SEARCH` \[in]
#;
#; : ["Extended Regular Expression"][posix_ere] pattern
#;   to search for.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - `SEARCH` MUST NOT be null - see
#;   [`fn_bs_libstring_search`](#fn_bs_libstring_search)'s _CAVEATS_.
#;
#; _NOTES_
#; <!-- -->
#;
#; - On success, sets `BS_LIBSTRING_MATCH_START` (offset of the first match)
#;   and `BS_LIBSTRING_MATCH_LENGTH` (length of the match).
#; - Returns `1` (`<one>`) if `SEARCH` does not match `STRING`.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Uses `awk`'s `match()` function, which sets `RSTART`/`RLENGTH` to the
#.   (one-based) offset and length of the leftmost-longest match.
#.
#_______________________________________________________________________________
fn_bs_libstring_search_ere() { ## cSpell:Ignore BS_LS_SearchERE_
  BS_LS_SearchERE_Caller=${1:?'[libstring::fn_bs_libstring_search_ere]: Internal Error: a caller is required'}
  BS_LS_SearchERE_String=${2:?'[libstring::fn_bs_libstring_search_ere]: Internal Error: a string is required'}
  BS_LS_SearchERE_Search=${3:?'[libstring::fn_bs_libstring_search_ere]: Internal Error: an offset is required'}

  #=========================================================
  #
  #=========================================================
  BS_LS_SearchERE_Match=$(
      fn_bs_libstring_awk_run_script \
        "${BS_LS_SearchERE_Caller}"  \
        '
          function bs_fn_main(argArray, argCount) {
            BS_LS_Search = argArray[1]
            BS_LS_String = argArray[2]
            if (match(BS_LS_String, BS_LS_Search)) {
              printf("MATCH\n%d\n%d\n", (RSTART - 1), RLENGTH)
            } else {
              print "NO MATCH"
            }
          }
        '                           \
        "${BS_LS_SearchERE_Search}" \
        "${BS_LS_SearchERE_String}"
    ) || return $?

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SearchERE_Match} in 'NO MATCH') return 1 ;; esac

  #=========================================================
  #
  #=========================================================
  BS_LS_SearchERE_Match=${BS_LS_SearchERE_Match#*"${c_BS_LIBSTRING__newline}"}

   BS_LIBSTRING_MATCH_START=${BS_LS_SearchERE_Match%%"${c_BS_LIBSTRING__newline}"*}
  BS_LIBSTRING_MATCH_LENGTH=${BS_LS_SearchERE_Match#*"${c_BS_LIBSTRING__newline}"}
} #<: `fn_bs_libstring_search_ere()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libstring_search`
#;
#; Find the location of one string within another.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libstring_search <CALLER> <MODE> <STRING> <EXPRESSION>
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
#; : `E` to interpret `EXPRESSION` as an
#;   ["Extended Regular Expression"][posix_ere], `F` as a
#;   fixed string, `G` as a
#;   ["Basic Regular Expression"][posix_bre], or `W` as
#;   ["Pattern Matching Notation"][posix_glob].
#;
#; `STRING` \[in]
#;
#; : Text to be searched.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; `EXPRESSION` \[in]
#;
#; : Text to search for.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - If the locale is set to the _POSIX_ locale, the index is a count of
#;   **bytes**, not characters.
#; - If `STRING` or `EXPRESSION` is null, the command fails (returns `1`)
#;   without setting `BS_LIBSTRING_MATCH_START`/`BS_LIBSTRING_MATCH_LENGTH`.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Resulting index is one-based if
#;   [`BS_LIBSTRING_CONFIG_INDEX_ONE_BASED`](#bs_libstring_config_index_one_based)
#;   is set, or zero-based otherwise.
#; - Exit code will be `0` (`<zero>`) if the string was located, `1` (`<one>`)
#;   if it was _not_ located, and an error code otherwise.
#;
#_______________________________________________________________________________
fn_bs_libstring_search() { ## cSpell:Ignore BS_LS_Search_
  BS_LS_Search_Caller=${1:?'[libstring::fn_bs_libstring_search]: Internal Error: a caller is required'}
    BS_LS_Search_Mode=${2:?'[libstring::fn_bs_libstring_search]: Internal Error: a mode is required'}
  BS_LS_Search_String=${3?'[libstring::fn_bs_libstring_search]: Internal Error: a string is required'}
    BS_LS_Search_Expr=${4?'[libstring::fn_bs_libstring_search]: Internal Error: an expression is required'}

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_Search_String:+S}:${BS_LS_Search_Expr:+E} in
  S:E) ;;
    *) return 1 ;;
  esac

  #=========================================================
  # Index
  #=========================================================
  case ${BS_LS_Search_Mode} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ERE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    E)
      fn_bs_libstring_search_ere \
        "${BS_LS_Search_Caller}" \
        "${BS_LS_Search_String}" \
        "${BS_LS_Search_Expr}"   || return $?
    ;; #<: `E)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Fixed Strings
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    F)
      fn_bs_libstring_search_fixed \
        "${BS_LS_Search_Caller}"   \
        "${BS_LS_Search_String}"   \
        "${BS_LS_Search_Expr}"     || return $?
    ;; #<: `F)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # BRE
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    G)
      fn_bs_libstring_search_bre \
        "${BS_LS_Search_Caller}" \
        "${BS_LS_Search_String}" \
        "${BS_LS_Search_Expr}"   || return $?
    ;; #<: `G)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Wildcard
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    W)
      fn_bs_libstring_search_glob \
        "${BS_LS_Search_Caller}"  \
        "${BS_LS_Search_String}"  \
        "${BS_LS_Search_Expr}"    || return $?
    ;; #<: `W)`
  esac #<: `case ${BS_LS_Search_Mode} in`

  #=========================================================
  # Offset
  #=========================================================
  case ${c_BS_LIBSTRING_CFG__first_index} in
  1) BS_LIBSTRING_MATCH_START=$((BS_LIBSTRING_MATCH_START + 1)) ;;
  esac
} #<: `fn_bs_libstring_search()`

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
#: ### `string_length`
#:
#: Get the length of text.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_length [<OUTPUT>] <STRING>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be measured.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     string_length Length "a string"
#:     Length=$(string_length "a string")
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - Requires the current locale is set appropriately for `STRING`.
#: - If the current locale is the _POSIX_ locale the result is always a count of
#:   **bytes** - setting the appropriate locale causes the result to be in
#:   **characters**.
#:
#: _NOTES_
#: <!-- -->
#:
#: - Although the shell provides `${#PARAMETER}` to determine the length of
#:   a value stored in a parameter, outside the _POSIX_ locale this often does
#:   not work as expected, instead returning the number of **bytes** rather than
#:   the number of **characters** - this command avoids this issue.
#:
#_______________________________________________________________________________
string_length() { ## cSpell:Ignore BS_LS_SL_
  case $# in
  1)  BS_LS_SL_refLength='-'
         BS_LS_SL_String=$1 ;;
  2)  BS_LS_SL_refLength=$1
         BS_LS_SL_String=$2
      fn_bs_libstring_validate_name_hyphen \
        'string_length'                    \
        "${BS_LS_SL_refLength}"            || return $? ;;
  *)  fn_bs_libstring_expected          \
        'string_length'                 \
        'an output variable (optional)' \
        'text to measure'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
  C|POSIX)  BS_LS_SL_Length=${#BS_LS_SL_String} ;;
        *)  fn_bs_libstring_string_length \
              'string_length'             \
              BS_LS_SL_Length             \
              "${BS_LS_SL_String}"        || return $? ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SL_refLength-} in
  -) printf '%s\n' "${BS_LS_SL_Length}"               ;;
  *) eval "${BS_LS_SL_refLength}=\${BS_LS_SL_Length}" ;;
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_quote`
#:
#: Quote text such that it can safely passed to, for example, `eval`.
#:
#: Similar to `%Q` format specifier available for some implementations of
#: `printf`.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_quote [<OUTPUT>] <STRING>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be quoted.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     string_quote Quoted "a 'string'"
#:     Quoted=$(string_quote "a 'string'")
#:
#: _NOTES_
#: <!-- -->
#:
#: - Correct quoting is both essential in shell scripting, and also tricky to
#:   do correctly (it is easy to miss some edge case). In most cases it is
#:   enough to quote parameters as the shell expands them (i.e. "${parameter}"),
#:   but when using parameters in a situation where a parameter will be
#:   evaluated multiple times it becomes necessary to quote more carefully. Most
#:   obviously this may occur when using `eval`, or when writing values via a
#:   pipe. In cases where a value needs quoted, this command not ensures
#:   safe quoting.
#: - The command is optimized for the common case, which should as fast as (or
#:   even faster) than `printf '%Q'` (where available).
#:
#_______________________________________________________________________________
string_quote() { ## cSpell:Ignore BS_LS_SQ_
  case $# in
  1)  BS_LS_SQ_refQuoted='-'
         BS_LS_SQ_String=$1 ;;
  2)  BS_LS_SQ_refQuoted=$1
         BS_LS_SQ_String=$2
      fn_bs_libstring_validate_name_hyphen \
        'string_quote'                     \
        "${BS_LS_SQ_refQuoted}"             || return $? ;;
  *)  fn_bs_libstring_expected          \
        'string_quote'                  \
        'an output variable (optional)' \
        'a value to quote'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SQ_String} in
  *"'"*)  BS_LS_SQ_Quoted=$(
              fn_bs_libstring_string_quote "${BS_LS_SQ_String}"
            ) || return $? ;;

      *)  BS_LS_SQ_Quoted="'${BS_LS_SQ_String}'" ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LS_SQ_refQuoted-} in
  -) printf '%s\n' "${BS_LS_SQ_Quoted}"               ;;
  *) eval "${BS_LS_SQ_refQuoted}=\${BS_LS_SQ_Quoted}" ;;
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_join`
#:
#: Join multiple strings into a single string, using a single ` ` (`<space>`)
#: as a separator.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_join [<OUTPUT>] [--] <STRING>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be joined.
#: : May be specified multiple times.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     string_join Joined "a string" " in " "bits"
#:     Joined=$(string_join "a string" " in " "bits")
#:
#: _NOTES_
#: <!-- -->
#:
#: - This is equivalent to `$*` **if, and only if** the first character of `IFS`
#:   is ` ` (`<space>`).
#: - `$*` uses the first character of `IFS` to join arguments - this allows the
#:   use of different characters to join a string, but when using `$*` it means
#:   care is needed to check or set `IFS` or errors may occur. Unfortunately,
#:   the value of `IFS` affects how a great many things happen in the shell and
#:   setting it prior to use of `$*` means care needs taken to reset it after
#:   it's been used - if an error or signal occurs before the value is reset
#:   later code may behave unexpectedly. This can be worked around in a number
#:   of ways, but these often have unobvious edge cases which can trip up the
#:   unwary, while alternative solutions that are robust can have performance
#:   implications (e.g. using subshell(s)). This command joins the arguments
#:   using ` ` (`<space>`) as efficiently as possible, while avoiding common
#:   pitfalls, and  not altering `IFS`.
#: - If `OUTPUT` is omitted, `--` is _required_. The same effect can be
#:   achieved by specifying `OUTPUT` as `-` (`<hyphen>`).
#:
#_______________________________________________________________________________
string_join() { ## cSpell:Ignore BS_LS_SJ_
  #=========================================================
  # Arguments
  #=========================================================
  case $#:${1-} in
  0:)
    fn_bs_libstring_expected          \
      'string_join'                   \
      'an output variable (optional)' \
      'zero or more values'
    return "${c_BS_LIBSTRING__EX_USAGE}" ;;

  *:--)
    BS_LS_SJ_refOutput='-'
    shift ;;

  *)
    BS_LS_SJ_refOutput=$1
    fn_bs_libstring_validate_name \
      'string_join'               \
      "${BS_LS_SJ_refOutput}"      || return $?
    shift
    case ${1-} in --) shift ;; *) esac ;;
  esac #<: `case $#:${1-} in`

  #=========================================================
  # Join the arguments
  #
  # The slightly odd code here `"$#: "*)` is to avoid a very
  # unlikely case where `IFS` contains the sequence
  # `: ` (`<colon><space>`) which would match the more
  # obvious `*': '*)` even though that's not what is
  # intended. Using a single `case` is a performance win so
  # this works out as the most efficient way to correctly
  # match the desired values.
  #=========================================================
  case $#:${IFS-} in
  0:*    )  BS_LS_SJ_Joined=;  ;;
  1:*    )  BS_LS_SJ_Joined=$1 ;;
  "$#: "*)  BS_LS_SJ_Joined=$* ;;
        *)  BS_LS_SJ_Joined=$(printf '%s ' "$@" '_')
            BS_LS_SJ_Joined=${BS_LS_SJ_Joined%' _ '} ;;
  esac #<: `case $#:${IFS-} in`

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_SJ_refOutput-} in
  -) printf '%s\n' "${BS_LS_SJ_Joined}"              ;;
  *) eval "${BS_LS_SJ_refOutput}=\${BS_LS_SJ_Joined}" ;;
  esac
} #<: `string_join()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_toupper`
#:
#: Convert a string to upper case.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_toupper [<OUTPUT>] <STRING>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be converted to upper case.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     string_toupper Upper "all lower case"
#:     Upper=$(string_toupper "all lower case")
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - Requires the current locale is set appropriately for `STRING`.
#: - If the locale is set to the _POSIX_ locale, conversion is byte-wise and
#:   may not handle multi-byte characters correctly.
#:
#: _NOTES_
#: <!-- -->
#:
#: - Uses the fastest available method for case conversion, preferring `tr`
#:   with character classes if supported, otherwise falling back to `awk`.
#: - Note that some common versions of `tr` do **not** support multi-byte
#:   characters regardless of locale.
#:
#_______________________________________________________________________________
string_toupper() { ## cSpell:Ignore BS_LS_TU_
  #=========================================================
  #
  #=========================================================
  case $# in
  1)  BS_LS_TU_refUpper='-'
        BS_LS_TU_String=$1 ;;
  2)  BS_LS_TU_refUpper=$1
        BS_LS_TU_String=$2
      fn_bs_libstring_validate_name_hyphen \
        'string_toupper'                   \
        "${BS_LS_TU_refUpper}"            || return $? ;;
  *)  fn_bs_libstring_expected          \
        'string_toupper'                \
        'an output variable (optional)' \
        'a string'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    C|POSIX)
      BS_LS_TU_Upper=$(
          {
            printf '%s_\n' "${BS_LS_TU_String}"
          } | {
            tr 'abcdefghijklmnopqrstuvwxyz' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          }
        ) || return $?
    ;; #<: `C|POSIX)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      BS_LS_TU_Upper=$(
          "${c_BS_LIBSTRING__CMD__toupper}" "${BS_LS_TU_String}_"
        ) || return $?
    ;; #<: `*)`
  esac #<: `case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in`

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_TU_refUpper} in
  -) printf '%s\n' "${BS_LS_TU_Upper%_}" ;;
  *) eval "${BS_LS_TU_refUpper}=\${BS_LS_TU_Upper%_}" ;;
  esac
} #<: `string_toupper()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_tolower`
#:
#: Convert a string to lower case.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_tolower [<OUTPUT>] <STRING>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be converted to lower case.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     string_tolower Upper "ALL UPPER CASE"
#:     Upper=$(string_tolower "ALL UPPER CASE")
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - Requires the current locale is set appropriately for `STRING`.
#: - If the locale is set to the _POSIX_ locale, conversion is byte-wise and
#:   may not handle multi-byte characters correctly.
#:
#: _NOTES_
#: <!-- -->
#:
#: - Uses the fastest available method for case conversion, preferring `tr`
#:   with character classes if supported, otherwise falling back to `awk`.
#: - Note that some common versions of `tr` do **not** support multi-byte
#:   characters regardless of locale.
#:
#_______________________________________________________________________________
string_tolower() { ## cSpell:Ignore BS_LS_TL_
  #=========================================================
  #
  #=========================================================
  case $# in
  1)  BS_LS_TL_refLower='-'
        BS_LS_TL_String=$1 ;;
  2)  BS_LS_TL_refLower=$1
        BS_LS_TL_String=$2
      fn_bs_libstring_validate_name_hyphen \
        'string_tolower'                   \
        "${BS_LS_TL_refLower}"             || return $? ;;
  *)  fn_bs_libstring_expected          \
        'string_tolower'                \
        'an output variable (optional)' \
        'a string'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    C|POSIX)
      BS_LS_TL_Lower=$(
          {
            printf '%s_\n' "${BS_LS_TL_String}"
          } | {
            tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'
          }
        ) || return $?
    ;; #<: `C|POSIX)`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *)
      BS_LS_TL_Lower=$(
          "${c_BS_LIBSTRING__CMD__tolower}" "${BS_LS_TL_String}_"
        ) || return $?
    ;; #<: `*)`
  esac #<: `case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in`

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_TL_refLower} in
  -) printf '%s\n' "${BS_LS_TL_Lower%_}" ;;
  *) eval "${BS_LS_TL_refLower}=\${BS_LS_TL_Lower%_}" ;;
  esac
} #<: `string_tolower()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_trim`
#:
#: Trim whitespace from a string.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_trim [-l|--left] [-r|--right] [--] [<OUTPUT>] <STRING>
#:
#:     string_trim [-a|--all] [--] [<OUTPUT>] <STRING>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-l`, `--left` \[in]
#:
#: : Trim the _left_ (i.e. start) of `STRING`.
#:
#: `-r`, `--right` \[in]
#:
#: : Trim the _right_ (i.e. end) of `STRING`.
#:
#: `-a`, `--all` \[in]
#:
#: : Trim both ends of `STRING`.
#: : This is the default.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be trimmed.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     string_trim --all Trimmed "   a string   "
#:     Trimmed=$(string_trim -l "   a string   ")
#:
#: _NOTES_
#: <!-- -->
#:
#: - The characters removed are those belonging to the `:space:` character class
#:   which contains characters appropriate to the current locale.
#: - The use of the _POSIX_ locale should be safe all cases, but will not remove
#:   multi-byte white space characters (e.g. non-breaking space).
#:
#_______________________________________________________________________________
string_trim() { ## cSpell:Ignore BS_LS_TM_
  #=========================================================
  # Arguments
  #=========================================================

  #---------------------------------------------------------
  # Options must be first
  #---------------------------------------------------------
  BS_LS_TM_TrimL=; BS_LS_TM_TrimR=
  while :
  do
    case ${1-} in
    '-l'|'--left')
      BS_LS_TM_TrimL=1
      : "${BS_LS_TM_TrimR:=0}"
      shift ;;

    '-r'|'--right')
      BS_LS_TM_TrimR=1
      : "${BS_LS_TM_TrimL:=0}"
      shift ;;

    '-lr'|'-rl'|'-a'|'--all')
      BS_LS_TM_TrimL=1; BS_LS_TM_TrimR=1
      shift ;;

    '--') shift; break ;;

       *) break ;;
    esac #<: `case ${1-} in`
  done

  #---------------------------------------------------------
  # Other arguments follow
  #---------------------------------------------------------
  case $# in
  1)  BS_LS_TM_refTrimmed='-'
          BS_LS_TM_String=$1 ;;
  2)  BS_LS_TM_refTrimmed=$1
          BS_LS_TM_String=$2
      fn_bs_libstring_validate_name_hyphen \
        'string_trim'                      \
        "${BS_LS_TM_refTrimmed}"           || return $? ;;
  *)  fn_bs_libstring_expected          \
        'string_trim'                   \
        'options: -l|--left, -r|--right, or -a|--all (optional)' \
        'an output variable (optional)' \
        'a value to trim'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Trim
  #=========================================================
  case ${BS_LS_TM_String:+1} in
    1)
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      case ${c_BS_LIBSTRING_CFG__use_param_exp_trim}:${c_BS_LIBSTRING_CFG__shell_supports_mbc}:${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
      1:1:*|1:0:C|1:0:POSIX)
        fn_bs_libstring_trim_fast  \
          'string_trim'            \
          "${BS_LS_TM_refTrimmed}" \
          "${BS_LS_TM_TrimL:-1}"   \
          "${BS_LS_TM_TrimR:-1}"   \
          "${BS_LS_TM_String}"     || return $? ;;
      *)
        fn_bs_libstring_trim_safe  \
          'string_trim'            \
          "${BS_LS_TM_refTrimmed}" \
          "${BS_LS_TM_TrimL:-1}"   \
          "${BS_LS_TM_TrimR:-1}"   \
          "${BS_LS_TM_String}"     || return $? ;;
      esac

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
    ;;
  esac
} #<: `string_trim()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_index`
#:
#: Find the location of one string within another. On success the values
#: `BS_LIBSTRING_MATCH_START` and `BS_LIBSTRING_MATCH_LENGTH` contain the
#: location of the sub-string.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_index [-E|--ere|--extended-regexp] [--] [<OUTPUT>] <STRING> <EXPRESSION>
#:
#:     string_index -F|--text|--fixed-strings [--] [<OUTPUT>] <STRING> <EXPRESSION>
#:
#:     string_index -G|--bre|--basic-regexp [--] [<OUTPUT>] <STRING> <EXPRESSION>
#:
#:     string_index -W|--glob|--wildcard [--] [<OUTPUT>] <STRING> <EXPRESSION>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-E`, `--ere`, `--extended-regexp` \[in]
#:
#: : Interpret `EXPRESSION` as an
#:   ["Extended Regular Expression"][posix_ere].
#: : This is the default.
#:
#: `-F`, `--text`, `--fixed-strings` \[in]
#:
#: : Interpret `EXPRESSION` as a fixed string.
#:
#: `-G`, `--bre`, `--basic-regexp` \[in]
#:
#: : Interpret `EXPRESSION` as a
#:   ["Basic Regular Expression"][posix_bre].
#:
#: `-W`, `--glob`, `--wildcard` \[in]
#:
#: : Interpret `EXPRESSION` as
#:   ["Pattern Matching Notation"][posix_glob].
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : On success, any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be searched.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: `EXPRESSION` \[in]
#:
#: : Text to search for.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     string_index 'Index' "the quick brown fox" ':'
#:     Index=$(string_index -E "the quick brown fox" '[fs]ox')
#:     Index=$(string_index -W "the quick brown fox" '?rown')
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - `BS_LIBSTRING_MATCH_START` and `BS_LIBSTRING_MATCH_LENGTH` are valid
#:   **only** immediately following this command.
#: - Requires the current locale is set appropriately for `STRING`.
#: - If the locale is set to the _POSIX_ locale, the results are in **bytes**,
#:   not characters.
#: - Not all wildcard patterns, _BRE_, or _ERE_ can be used portably.
#: - For _wildcard patterns_ the locale in effect is that of the shell as
#:   invoked - _it is **not** possible to change the locale of a running shell_.
#: - In some cases wildcard pattern matches will be implemented using fallback
#:   code - this is unavoidable as not all implementations provide the expected
#:   behavior for all expressions. See
#:   ["PATTERN MATCHING"](./README.MD#pattern-matching),
#:   [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_MBC`](#bs_libstring_config_shell_supports_mbc),
#:   and [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libstring_config_shell_supports_portable_glob).
#: - **Single character _ERE_ will be interpreted as fixed strings.** (This is
#:   due to limitations in `awk`.)
#:
#: _NOTES_
#: <!-- -->
#:
#: - Exit code will be `0` (`<zero>`) if the string was located, `1` (`<one>`)
#:   if it was _not_ located, and an error code otherwise.
#: - Resulting index is one-based if
#:   [`BS_LIBSTRING_CONFIG_INDEX_ONE_BASED`](#bs_libstring_config_index_one_based)
#:   is set, or zero-based otherwise.
#: - Following this command, `BS_LIBSTRING_MATCH_START` and
#:   `BS_LIBSTRING_MATCH_LENGTH` can be passed to
#:   [`string_substr`](#string_substr) to extract the located sub-string.
#:
#_______________________________________________________________________________
string_index() { ## cSpell:Ignore BS_LS_SI_
  #=========================================================
  # Initialize
  #=========================================================
   BS_LIBSTRING_MATCH_START=-1;
  BS_LIBSTRING_MATCH_LENGTH=0

  #=========================================================
  # Argument Processing
  #=========================================================

  #---------------------------------------------------------
  # Check for options
  #---------------------------------------------------------
  BS_LS_SI_Mode=E
  case ${1-} in
  '-E' | '--ere'  | '--extended-regexp') BS_LS_SI_Mode=E; shift ;;
  '-F' | '--text' | '--fixed-strings'  ) BS_LS_SI_Mode=F; shift ;;
  '-G' | '--bre'  | '--basic-regexp'   ) BS_LS_SI_Mode=G; shift ;;
  '-W' | '--glob' | '--wildcard'       ) BS_LS_SI_Mode=W; shift ;;
  esac

  #---------------------------------------------------------
  # Skip any option delimiter
  #---------------------------------------------------------
  case ${1-} in --) shift ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in
  2)  BS_LS_SI_refIndex='-'
        BS_LS_SI_String=$1
        BS_LS_SI_Search=$2 ;;
  3)  BS_LS_SI_refIndex=$1
        BS_LS_SI_String=$2
        BS_LS_SI_Search=$3
      fn_bs_libstring_validate_name_hyphen \
        'string_index'                     \
        "${BS_LS_SI_refIndex}"             || return $? ;;
  *)  fn_bs_libstring_expected          \
        'string_index'                  \
        'one of -G|--bre|--basic-regexp, -E|--ere|--extended-regexp, -F|--text|--fixed-strings, or -W|--glob|--wildcard (optional)' \
        'an output variable (optional)' \
        'a string to search'            \
        'an expression to search for'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  #=========================================================
  fn_bs_libstring_search \
    'string_index'       \
    "${BS_LS_SI_Mode}"   \
    "${BS_LS_SI_String}" \
    "${BS_LS_SI_Search}" || return $?

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_SI_refIndex} in
  -) printf '%s\n' "${BS_LIBSTRING_MATCH_START-}" ;;
  *) eval "${BS_LS_SI_refIndex}=\${BS_LIBSTRING_MATCH_START-}" ;;
  esac
} #<: `string_index()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_match`
#:
#: Find the location of one string within another. Equivalent to
#: [`string_index`](#string_index) with output of the index suppressed.
#:
#: As with [`string_index`](#string_index) on a successful match
#: `BS_LIBSTRING_MATCH_START` and `BS_LIBSTRING_MATCH_LENGTH` are set.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_match [-E|--ere|--extended-regexp] [--] <STRING> <EXPRESSION>
#:
#:     string_match -F|--text|--fixed-strings [--] <STRING> <EXPRESSION>
#:
#:     string_match -G|--bre|--basic-regexp [--] <STRING> <EXPRESSION>
#:
#:     string_match -W|--glob|--wildcard [--] <STRING> <EXPRESSION>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-E`, `--ere`, `--extended-regexp` \[in]
#:
#: : Interpret `EXPRESSION` as an
#:   ["Extended Regular Expression"][posix_ere].
#: : This is the default.
#:
#: `-F`, `--text`, `--fixed-strings` \[in]
#:
#: : Interpret `EXPRESSION` as a fixed string.
#:
#: `-G`, `--bre`, `--basic-regexp` \[in]
#:
#: : Interpret `EXPRESSION` as a
#:   ["Basic Regular Expression"][posix_bre].
#:
#: `-W`, `--glob`, `--wildcard` \[in]
#:
#: : Interpret `EXPRESSION` as
#:   ["Pattern Matching Notation"][posix_glob].
#:
#: `STRING` \[in]
#:
#: : Text to be searched.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: `EXPRESSION` \[in]
#:
#: : Text to search for.
#: : _EXPECTS_:
#:   - an _ERE_ with `-E`, `--ere`, or`--extended-regexp`.
#:   - a _string_ with `-F`, `--text`, `--fixed-strings`.
#:   - a _BRE_ with `-G`, `--bre`, or `--basic-regexp`.
#:   - a _wildcard pattern_ with `-W`, `--glob`, or
#:     `--wildcard`.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if string_match "the quick brown fox" ':'; then ...
#:     if string_match -E "the quick brown fox" '[fs]ox'; then ...
#:     if string_match -W "the quick brown fox" '?rown'; then ...
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - As for [`string_index`](#string_index).
#:
#: _NOTES_
#: <!-- -->
#:
#: - As for [`string_index`](#string_index).
#:
#_______________________________________________________________________________
string_match() { ## cSpell:Ignore BS_LS_SM_
  #=========================================================
  # Initialize
  #=========================================================
   BS_LIBSTRING_MATCH_START=-1;
  BS_LIBSTRING_MATCH_LENGTH=0

  #=========================================================
  # Argument Processing
  #=========================================================

  #---------------------------------------------------------
  # Check for options
  #---------------------------------------------------------
  BS_LS_SM_Mode=E
  case ${1-} in
  '-E' | '--ere'  | '--extended-regexp') BS_LS_SM_Mode=E; shift ;;
  '-F' | '--text' | '--fixed-strings'  ) BS_LS_SM_Mode=F; shift ;;
  '-G' | '--bre'  | '--basic-regexp'   ) BS_LS_SM_Mode=G; shift ;;
  '-W' | '--glob' | '--wildcard'       ) BS_LS_SM_Mode=W; shift ;;
  esac

  #---------------------------------------------------------
  # Skip any option delimiter
  #---------------------------------------------------------
  case ${1-} in --) shift ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in
  2)  ;;
  *)  fn_bs_libstring_expected \
        'string_match'         \
        'one of -G|--bre|--basic-regexp, -E|--ere|--extended-regexp, -F|--text|--fixed-strings, or -W|--glob|--wildcard (optional)' \
        'text to search'       \
        'an expression to search for'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac

  #=========================================================
  #
  #=========================================================
  fn_bs_libstring_search \
    'string_match'       \
    "${BS_LS_SM_Mode}"   \
    "$@"
} #<: `string_match()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_substr`
#:
#: Get a substring from a string, index, and length.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_substr <OUTPUT> <STRING> <OFFSET> [<LENGTH>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to extract a substring from.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: `OFFSET` \[in]
#:
#: : Position at which the substring starts.
#:
#: `LENGTH` \[in]
#:
#: : Length of the substring in characters.
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - Requires the current locale is set appropriately for `STRING`.
#: - If the locale is set to the _POSIX_ locale, `OFFSET` and `LENGTH` are in
#:   **bytes**, _not_ characters.
#: - If `LENGTH` is omitted, the sub-string will contain all characters from
#:   `STRING`, starting at `OFFSET`.
#:
#: _NOTES_
#: <!-- -->
#:
#: - `OFFSET` is one-based if
#:   [`BS_LIBSTRING_CONFIG_INDEX_ONE_BASED`](#bs_libstring_config_index_one_based)
#:   is set, or zero-based otherwise.
#: - If `LENGTH` is omitted, this command provides a complimentary command to
#:   [`string_truncate`](#string_truncate) - both behave similarly but on
#:   different ends of the input string.
#:
#_______________________________________________________________________________
string_substr() { ## cSpell:Ignore BS_LS_SS_
  #=========================================================
  #
  #=========================================================
  case $# in
  3)  BS_LS_SS_refSubstr=$1
         BS_LS_SS_String=$2
         BS_LS_SS_Offset=$3
         BS_LS_SS_Length=;
         unset BS_LS_SS_Length ;;
  4)  BS_LS_SS_refSubstr=$1
         BS_LS_SS_String=$2
         BS_LS_SS_Offset=$3
         BS_LS_SS_Length=$4 ;;
  *)  fn_bs_libstring_expected \
        'string_substr'        \
        'an output variable'   \
        'a string'             \
        'an offset'            \
        'a length (optional)'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  fn_bs_libstring_validate_name_hyphen \
    'string_substr'                    \
    "${BS_LS_SS_refSubstr}"            || return $?

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${BS_LS_SS_Offset}:${BS_LS_SS_Length-0} in
  *[!0123456789]*:*|*:*[!0123456789]*|'':*|*:'')
    fn_bs_libstring_invalid_args \
      'string_substr'            \
      "expected a whole number for offset ('${BS_LS_SS_Offset}')" \
      ${BS_LS_SS_Length+" and a whole number for length ('${BS_LS_SS_Length}')"}
    return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${c_BS_LIBSTRING_CFG__first_index}:${BS_LS_SS_Offset} in
  1:0)
    fn_bs_libstring_invalid_args \
      'string_substr'            \
      "expected a whole number greater than 0 for offset ('${BS_LS_SS_Offset}')"
    return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    C|POSIX)
      BS_LS_SS_SubStr=$(
          fn_bs_libstring_substr_lc_posix \
            'string_substr'               \
            "${BS_LS_SS_String}"          \
            "${BS_LS_SS_Offset:-1}"       \
            "${BS_LS_SS_Length:-0}"
        ) || return $?
    ;;

    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    *)
      BS_LS_SS_SubStr=$(
          fn_bs_libstring_substr_lc_other \
            'string_substr'               \
            "${BS_LS_SS_String}"          \
            "${BS_LS_SS_Offset:-1}"       \
            "${BS_LS_SS_Length:-0}"
        ) || return $?
    ;;
  esac #<: `case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in`

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_SS_refSubstr} in
  -) printf '%s\n' "${BS_LS_SS_SubStr%_}" ;;
  *) eval "${BS_LS_SS_refSubstr}=\${BS_LS_SS_SubStr%_}" ;;
  esac
} #<: `string_substr()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_truncate`
#:
#: Truncate a given string to a specific length.
#:
#: Equivalent to [`string_substr`](#string_substr) with no offset.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_truncate [<OUTPUT>] <STRING> <LENGTH>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to be truncated.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: `LENGTH` \[in]
#:
#: : Length of the truncated string.
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - Requires the current locale is set appropriately for `STRING`.
#: - If the locale is set to the _POSIX_ locale, `LENGTH` is a count of
#:   **bytes**, otherwise it is a count of **characters**.
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `STRING` is shorter than `LENGTH` no changes will be made.
#:
#_______________________________________________________________________________
string_truncate() { ## cSpell:Ignore BS_LS_ST_
  case $# in
  2)  BS_LS_ST_refTruncated='-'
            BS_LS_ST_String=$1
            BS_LS_ST_Length=$2 ;;
  3)  BS_LS_ST_refTruncated=$1
            BS_LS_ST_String=$2
            BS_LS_ST_Length=$3
      fn_bs_libstring_validate_name_hyphen \
        'string_truncate'                  \
        "${BS_LS_ST_refTruncated}"          || return $? ;;
  *)  fn_bs_libstring_expected          \
        'string_truncate'               \
        'an output variable (optional)' \
        'a value to truncate'           \
        'a length to truncate to'
      return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac #<: `case $# in`

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${BS_LS_ST_Length} in
  *[!0123456789]*|''|0)
    fn_bs_libstring_invalid_args \
      'string_truncate'          \
      "invalid truncation length; expected a whole number greater than zero, got '${BS_LS_ST_Length}'"
    return "${c_BS_LIBSTRING__EX_USAGE}" ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${LC_ALL:-${LC_CTYPE:-${LANG:-C}}} in
  C|POSIX)
    BS_LS_ST_Truncated=$(
        fn_bs_libstring_substr_lc_posix        \
          'string_truncate'                    \
          "${BS_LS_ST_String}"                 \
          "${c_BS_LIBSTRING_CFG__first_index}" \
          "${BS_LS_ST_Length}"
      ) || return $? ;;

  *)
    BS_LS_ST_Truncated=$(
      fn_bs_libstring_substr_lc_other        \
        'string_truncate'                    \
        "${BS_LS_ST_String}"                 \
        "${c_BS_LIBSTRING_CFG__first_index}" \
        "${BS_LS_ST_Length}"
    ) || return $? ;;
  esac

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LS_ST_refTruncated} in
  -) printf '%s\n' "${BS_LS_ST_Truncated%_}" ;;
  *) eval "${BS_LS_ST_refTruncated}=\${BS_LS_ST_Truncated%_}" ;;
  esac
} #<: `string_truncate()`

#_______________________________________________________________________________
## cSpell:Ignore rown
#: ---------------------------------------------------------
#:
#: ### `string_sub`
#:
#: Replace the _first_ occurrence of an expression with a given value. (Similar
#: to the `awk` function `sub`.)
#:
#: See [`string_gsub`](#string_gsub) for replacing _all_ occurrences.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_sub [-E|--ere|--extended-regexp] [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#:     string_sub -F|--text|--fixed-strings [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#:     string_sub -G|--bre|--basic-regexp [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#:     string_sub -W|--glob|--wildcard [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-E`, `--ere`, `--extended-regexp` \[in]
#:
#: : Interpret `EXPRESSION` as an
#:   ["Extended Regular Expression"][posix_ere].
#: : This is the default.
#:
#: `-F`, `--text`, `--fixed-strings` \[in]
#:
#: : Interpret `EXPRESSION` as a fixed string.
#:
#: `-G`, `--bre`, `--basic-regexp` \[in]
#:
#: : Interpret `EXPRESSION` as a
#:   ["Basic Regular Expression"][posix_bre].
#:
#: `-W`, `--glob`, `--wildcard` \[in]
#:
#: : Interpret `EXPRESSION` as
#:   ["Pattern Matching Notation"][posix_glob].
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the new string.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   output is written to `STDOUT`.
#:
#: `STRING` \[in]
#:
#: : Text to search.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: `EXPRESSION` \[in]
#:
#: : Text to search for.
#: : _EXPECTS_:
#:   - an _ERE_ with `-E`, `--ere`, or`--extended-regexp`.
#:   - a _string_ with `-F`, `--text`, `--fixed-strings`.
#:   - a _BRE_ with `-G`, `--bre`, or `--basic-regexp`.
#:   - a _wildcard pattern_ with `-W`, `--glob`, or
#:     `--wildcard`.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: `REPLACEMENT` \[in]
#:
#: : Text to be inserted.
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     NewString=$(string_sub -F "the quick brown fox" 'fox' 'dog')
#:     NewString=$(string_sub -E "the quick brown fox" '[fs]ox' 'dog')
#:     NewString=$(string_sub -W "the quick brown fox" '?rown' 'red')
#:     string_sub -W -- NewString "the quick brown fox" '?rown' 'red'
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - Requires the current locale is set appropriately for `STRING`.
#: - For _wildcard patterns_ the locale in effect is that of the shell as
#:   invoked - _it is **not** possible to change the locale of a running shell_.
#: - Not all wildcard patterns, _BRE_, or _ERE_ can be used portably.
#: - In some cases wildcard pattern matches will be implemented using fallback
#:   code - this is unavoidable as not all implementations provide the expected
#:   behavior for all expressions. See
#:   ["PATTERN MATCHING"](./README.MD#pattern-matching),
#:   [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_MBC`](#bs_libstring_config_shell_supports_mbc),
#:   and [`BS_LIBSTRING_CONFIG_SHELL_SUPPORTS_PORTABLE_GLOB`](#bs_libstring_config_shell_supports_portable_glob).
#: - **Single character _ERE_ will be interpreted as fixed strings.** (This is
#:   due to limitations in `awk`.)
#:
#: _NOTES_
#: <!-- -->
#:
#: - The `-F`/`--fixed-strings` mode can safely be used in the _POSIX_ locale
#:   with multi-byte characters.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - The default mode is `E` to align with defaults for other libraries in
#.   `shtoolkit` (the first command to use this default initially only provided
#.   that mode).
#.
#_______________________________________________________________________________
string_sub() { fn_bs_libstring_sub 'string_sub' 'sub' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `string_gsub`
#:
#: Identical to [`string_sub`](#string_sub) except _all_ occurrences of the
#: expression are replaced. (Similar to the `awk` function `gsub`.)
#:
#: See [`string_sub`](#string_sub) for more information.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     string_gsub [-E|--ere|--extended-regexp] [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#:     string_gsub -F|--text|--fixed-strings [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#:     string_gsub -G|--bre|--basic-regexp [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#:     string_gsub -W|--glob|--wildcard [--] [<OUTPUT>] <STRING> <EXPRESSION> <REPLACEMENT>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: As for [`string_sub`](#string_sub).
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     NewString=$(string_gsub -F "the quick brown fox" 'fox' 'dog')
#:     NewString=$(string_gsub -E "the quick brown fox" '[fs]ox' 'dog')
#:     NewString=$(string_gsub -W "the quick brown fox" '?rown' 'red')
#:     string_gsub -W -- NewString "the quick brown fox" '?rown' 'red'
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - As for [`string_sub`](#string_sub).
#:
#: _NOTES_
#: <!-- -->
#:
#: - As for [`string_sub`](#string_sub).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - The default mode is `E` to align with defaults for other libraries in
#.   `shtoolkit` (the first command to use this default initially only provided
#.   that mode).
#.
#_______________________________________________________________________________
string_gsub() { fn_bs_libstring_sub 'string_gsub' 'gsub' ${1+"$@"}; }

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
*a*) set +a; BS_LIBSTRING_SOURCED=1; set -a ;;
  *)         BS_LIBSTRING_SOURCED=1         ;;
esac

fn_bs_libstring_readonly 'BS_LIBSTRING_SOURCED'

############################ DOCUMENTATION CONTINUED ###########################
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## VERSIONS
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
#: - The names and design of the command interfaces in this library is heavily
#:   based on that of `awk`.
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## CAVEATS
#:
#: - This library is design to support any locale that the underlying tools
#:   support. It is not, however, possible to robustly, portably test for
#:   that support - the library does "best effort" testing to choose appropriate
#:   tools to provide functionality, but this should not be relied upon. **In
#:   particular, the library does NOT have any way to determine if a locale is
#:   entirely unsupported.**[^openbsd_locale]
#: - Some commands have fallback implementations which are needed for certain
#:   argument/environment combinations. While these provide the functionality
#:   required they may have very different performance characteristics to the
#:   normal version. In some cases better performance will be possible by using
#:   alternative options, for example, pattern matching using _ERE_ **may**
#:   prove to have more consistent performance across platforms then, say,
#:   wildcards (which use fallback implementations in some cases).
#: - For **ALL** string commands, the locale of any string arguments MUST match
#:   the current locale _OR_ the current locale MUST be the _POSIX_ locale. Any
#:   other combination of locales is likely to lead to errors.[^string_locale]
#: - There exist locales which may be largely compatible with other locales
#:   (especially those that are Unicode locales) - however this compatibility is
#:   _NOT_ universal and differences will exist.[^non_compatible_locale]
#: - _It is **not** possible to alter the locale of the currently active shell._
#:   (The locale the shell was invoked with remains in effect for the duration
#:    of the shell process - locale variables affect **external** commands
#:    only.)
#: - The library attempts to account for differences between implementations
#:   (where known), however, it is not possible to do this for every case.
#:
#: [^openbsd_locale]: For example, the default tools available in OpenBSD make
#:                    it impossible to support multi-byte characters properly,
#:                    but also impossible to determine that this is an issue.
#:
#: [^string_locale]: While variables/parameters have no explicit locale the
#:                   value of the bytes they store will have been written in
#:                   a specific locale (with the expectation that these bytes
#:                   are interpreted according to that locale) - this is the
#:                   locale of the data. Processing this data is only possible
#:                   in the same locale, or the _POSIX_ locale.
#:
#: [^non_compatible_locale]: The easiest example of this is the various English
#:                           UTF-8 locales. While they will match, for example,
#:                           character code-points, sort order, etc. they will
#:                           also differ in monetary symbol, date format, etc.
#:                           (which are _also_ governed by the locale). In most
#:                           cases these differences will not be an issue for
#:                           users of this library, but there exist potential
#:                           edge cases where they may be problematic.
#:
#: _For more details see the `shtoolkit` general [documentation](./README.MD#caveats)._
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
