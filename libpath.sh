#!/usr/bin/env false
# SPDX-License-Identifier: MPL-2.0
## cSpell:Ignore libpath mktemp mktmp shtoolkit
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libpath': Path processing helpers for POSIX.1 compliant     *#
#*                          shells.                                           *#
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

################################### LIBPATH ####################################
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
#% % libpath(7) BetterScripts libpath v1.0.0 | Path helpers for POSIX.1 shell scripts.
#% % BetterScripts (better.scripts@proton.me)
#% % July 2026
#
#: <!-- #################################################################### -->
#: <!-- ############# THIS FILE WAS GENERATED FROM 'libpath.sh' ############ -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # `libpath.sh`
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## SYNOPSIS
#:
#: _Full synopsis, description, arguments, examples and other information is_
#: _documented with each individual command._
#:
#: [`path_basename <VARIABLE> [--] <PATH> [<SUFFIX>]`](#path_basename)
#:
#: [`path_dirname <VARIABLE> [--] <PATH>`](#path_dirname)
#:
#: [`path_pwd <VARIABLE> [<OPTIONS>...]`](#path_pwd)
#:
#: [`path_serial [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>`](#path_serial)
#:
#: [`path_size [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>`](#path_size)
#:
#: [`path_owner [-L|--dereference|--follow-links] [-n|--name] [--] [<VARIABLE>] <PATH>`](#path_owner)
#:
#: [`path_mode [-L|--dereference|--follow-links] [-c|--chmod] [--] [<VARIABLE>] <PATH>`](#path_mode)
#:
#: [`path_mktemp [<OPTIONS>...] [--] [<TEMPLATE>]`](#path_mktemp)
#:
#: [`path_mktmp [<OPTIONS>...] [--] [<TEMPLATE>]`](#path_mktmp)
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## DESCRIPTION
#:
#: Provides commands to allow any _POSIX.1_ compliant shell to process paths
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
case ${BS_LIBPATH_SOURCED:+1} in 1) return ;; esac

#===============================================================================
#===============================================================================
# DEFAULTS
#===============================================================================
#===============================================================================
: "${BS_LIBPATH_DEBUG:=${BS_DEBUG:-${DEBUG:-0}}}"
: "${BS_LIBPATH_CONFIG_DEBUG:=${BS_LIBPATH_DEBUG:-0}}"
: "${BS_LIBPATH_DEBUG_FD:=${BS_DEBUG_FD:-2}}"

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
#. ### `fn_bs_libpath_readonly`
#.
#. Wrapper round `readonly`.
#.
#. Required because in its default configuration Z Shell's `readonly` causes
#. problems (due to variable scoping).
#.
#. See [`BS_LIBPATH_CONFIG_NO_Z_SHELL_SETOPT`](#bs_libpath_config_no_z_shell_setopt)
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libpath_readonly <VAR>...
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
fn_bs_libpath_readonly() { ## cSpell:Ignore BS_LP_readonly_
  case ${c_BS_LIBPATH_CFG__use_zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'POSIX_BUILTINS' ;;
  esac
  readonly "$@" || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libpath_dbg_printf_to_fd`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libpath_dbg_printf_to_fd <ARGS>...
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
#.   [`BS_LIBPATH_DEBUG_FD`](#bs_libpath_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libpath_dbg_printf_to_fd() { ## cSpell:Ignore BS_LP_DPTFD_
  # SC2059: Don't use variables in the printf format string.
  #         Use printf "..%s.." "$foo".
  # EXCEPT: This is a printf wrapper.
  # SC2086: Double quote to prevent globbing and word
  #+        splitting.
  # EXCEPT: Quoting changes the meaning (under POSIX rules
  #+        the descriptor will be considered a file)
  # shellcheck disable=SC2059,SC2086
  case ${BS_LIBPATH_DEBUG_FD:-2} in
  [123456789]) printf "$@" >&  ${BS_LIBPATH_DEBUG_FD}      ;;
         '&'*) printf "$@" >&  ${BS_LIBPATH_DEBUG_FD#'&'}  ;;
            *) printf "$@" >> "${BS_LIBPATH_DEBUG_FD#'>'}" ;;
  esac || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libpath_dbg_msg`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libpath_dbg_msg <CALLER> <MESSAGE>...
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
#.   [`BS_LIBPATH_DEBUG_FD`](#bs_libpath_debug_fd).
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Avoids using `$*` since `IFS` may not be set appropriately.
#. - Written for simplicity and not performance.
#.
#_______________________________________________________________________________
fn_bs_libpath_dbg_msg() { ## cSpell:Ignore BS_LP_DM_
  case ${BS_LIBPATH_DEBUG:-0} in 0) return ;; esac

  BS_LP_DM_Caller=$1
  shift

  fn_bs_libpath_dbg_printf_to_fd                \
    "[libpath::${BS_LP_DM_Caller}]: DEBUG:%s\n" \
    "$(printf ' %s' "$@")"
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libpath_config_constant`
#.
#. Helper to set configuration variables and report the set value when in
#. debug mode.
#.
#. In non-debug mode, identical to
#. [`fn_bs_libpath_readonly`](#fn_bs_libpath_readonly).
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libpath_config_constant <VAR>...
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
#. - Output is in form `[libpath::config]: DEBUG: <NAME>: <VALUE>` where
#.   `NAME` is the constant name and `VALUE` its value.
#. - Output is written to the file descriptor stored in
#.   [`BS_LIBPATH_DEBUG_FD`](#bs_libpath_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libpath_config_constant() { ## cSpell:Ignore BS_LP_CFGCST_
  case ${BS_LIBPATH_CONFIG_DEBUG:-0} in
  0)  ;;
  *)  for BS_LP_CFGCST_Name
      do
        eval "BS_LP_CFGCST_Value=\${${BS_LP_CFGCST_Name}-}" || BS_LP_CFGCST_Value=;
        fn_bs_libpath_dbg_printf_to_fd              \
          "[libpath::config]: DEBUG: %s: %s\n"      \
          "${BS_LP_CFGCST_Name#c_BS_LIBPATH_CFG__}" \
          "${BS_LP_CFGCST_Value}"                   || true
      done ;;
  esac

  case ${c_BS_LIBPATH_CFG__use_zsh_setopt} in
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
#: #### `BS_LIBPATH_CONFIG_NO_Z_SHELL_SETOPT`
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
#. - See [`fn_bs_libpath_readonly`](#fn_bs_libpath_readonly).
#. - **MUST BE SET BEFORE FIRST CALL TO `fn_...readonly`**
#:
case ${BS_LIBPATH_CONFIG_NO_Z_SHELL_SETOPT:-${BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT:-A}} in
[AD]) case ${ZSH_VERSION:+1} in
      1) c_BS_LIBPATH_CFG__use_zsh_setopt=1 ;;
      *) c_BS_LIBPATH_CFG__use_zsh_setopt=0 ;;
      esac ;;
   0) c_BS_LIBPATH_CFG__use_zsh_setopt=0 ;;
   *) c_BS_LIBPATH_CFG__use_zsh_setopt=1 ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__use_zsh_setopt'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_CONFIG_EXTENDED_FILE_MODE_FORMAT`
#:
#: - Type:     _TEXT_
#: - Class:    _CONSTANT_
#: - Default:  `posix`
#: - Used by [`path_mode`](#path_mode) to determine how to
#:   convert modes into `chmod` format.
#: - Some implementations extend the standard with
#:   additional file modes, this determines if those
#:   extensions are handled or if they result in an error.
#: - MUST be either `posix` (default) or `solaris`.
#: - _`posix`_: use only the standard defined file modes,
#:   anything else will cause an error for certain
#:   operations.
#: - `solaris`: allow the "mandatory file locking" mode
#:   extension.
#: - The default is to use `solaris` only when `uname -s` is
#:   `SunOS`, and `posix` in all other cases.
#:
case ${BS_LIBPATH_CONFIG_EXTENDED_FILE_MODE_FORMAT:-A} in
  [AD])
    case $(uname -s 2>&1 || echo 'FAILED') in
    [Ss][Uu][nN][Oo][Ss]) c_BS_LIBPATH_CFG__file_mode_format='solaris' ;;
                       *) c_BS_LIBPATH_CFG__file_mode_format='posix'   ;;
    esac ;;

  [Ss][Oo][Ll][Aa][Rr][Ii][Ss]|[Ss][Uu][nN][Oo][Ss])
    c_BS_LIBPATH_CFG__file_mode_format='solaris' ;;

  [Pp][Oo][Ss][Ii][Xx])
    c_BS_LIBPATH_CFG__file_mode_format='posix' ;;

  *)
    BS_LIBPATH__ConfigError=;
    : "${BS_LIBPATH__ConfigError:?'[libpath]: Config Error: invalid value for BS_LIBPATH_CONFIG_EXTENDED_FILE_MODE_FORMAT.'}" ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__file_mode_format'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_CONFIG_NO_LS_Q`
#:
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  \<automatic>
#: - Indicates if `-q` is an accepted option for `ls`.
#: - Although `-q` is required by the standard, some
#:   implementations do not support it (e.g. `busybox`).
#: - While `-q` is never absolutely necessary, it is helpful
#:   to use to ensure output does not cause unexpected
#:   problems. (Generally `ls` output is parsed only for
#:   information **not** related to the filename output.)
#:
#  <!-- ................................................ -->
#
# `-q`
#
# : "Force each instance of non-printable filename
#    characters and <tab> characters to be written as the
#    <question-mark> ( '?' ) character."
#
case ${BS_LIBPATH_CONFIG_NO_LS_Q:-A} in
  [AD])
    if i_BS_LIBPATH_IGNORED=$(ls -q . 2>&1)
    then
      c_BS_LIBPATH_CFG__have_ls_q=1
    else
      c_BS_LIBPATH_CFG__have_ls_q=;
    fi

    unset i_BS_LIBPATH_IGNORED
  ;;

  0) c_BS_LIBPATH_CFG__have_ls_q=; ;;
  *) c_BS_LIBPATH_CFG__have_ls_q=1 ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__have_ls_q'

#===========================================================
#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### PLATFORM CONFIGURATION (INTERNAL)
#.
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBPATH_CFG__have_cmd__mktemp`
#.
#. - Indicates if `mktemp` is present and appears to work
#.   as expected:
#.   - `0` indicates `mktemp` is not available;
#.   - `1` indicates `mktemp` is available with most
#.     functionality present;
#.   - `g` indicates `mktemp` is available with GNU extended
#.     options available (i.e. `--suffix` works and template
#.     can have trailing non-XXX characters).
#. - While `mktemp` is widely available, versions differ in
#.   what options they permit and how the path is generated
#.   - e.g. `mktemp` on BSD will use the template as is if
#.   it does not end with XXX.
#. - Even if `mktemp` is available, other configuration and
#.   requirements may mean it is never used.
#. - This variable only determines if `mktemp` is available,
#.   [`BS_LIBPATH_CONFIG_NO_MKTEMP`](#bs_libpath_config_no_mktemp)
#.   is the user configuration variable that determines if
#.   it is used. These are separated as combining the tests
#.   becomes unwieldy.
#.
case $({ mktemp -u -p "${TMPDIR:-/tmp}" template.XXXXXX; } 2>&1) in
  /tmp/template.XXXXXX)
    c_BS_LIBPATH_CFG__have_cmd__mktemp=0 ;;

  /tmp/template.??????)
    case $({ mktemp -u -p "${TMPDIR:-/tmp}" --suffix '.test' template.XXXXXX; } 2>&1) in
    /tmp/template.??????.test) c_BS_LIBPATH_CFG__have_cmd__mktemp=g ;;
                            *) c_BS_LIBPATH_CFG__have_cmd__mktemp=1 ;;
    esac ;;

  *)
    c_BS_LIBPATH_CFG__have_cmd__mktemp=0 ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__have_cmd__mktemp'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBPATH_CFG__have_cmd__od`
#.
#. - Type:     _FLAG_
#. - Class:    _CONSTANT_
#. - Indicates if `od` is present and appears to work
#.   as expected.
#. - Even if `od` is available, other configuration and
#.   requirements may mean it is never used.
#. - This variable only determines if `od` is available,
#.   [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump)
#.   is the user configuration variable that determines if
#.   it is used. These are separated as combining the tests
#.   becomes unwieldy.
#.
case $({ printf 'TEST\n' | { od -v -A n -c -N 4 || true; } | tr -d ' 	'; } 2>&1) in
TEST) c_BS_LIBPATH_CFG__have_cmd__od=1 ;;
   *) c_BS_LIBPATH_CFG__have_cmd__od=0 ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__have_cmd__od'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBPATH_CFG__have_cmd__hexdump`
#.
#. - Indicates if `hexdump` is present and appears to work
#.   as expected.
#. - `hexdump` is widely available and can be used if the
#.   standard specified `od` is not available.
#. - Even if `hexdump` is available, other configuration and
#.   requirements may mean it is never used.
#. - This variable only determines if `hexdump` is available,
#.   [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump)
#.   is the user configuration variable that determines if
#.   it is used. These are separated as combining the tests
#.   becomes unwieldy.
#.
case $({ printf 'TEST\n' | hexdump -v -e '4/1 "%_u" 1 "\n"' -n 4 || true; } 2>&1) in
TEST) c_BS_LIBPATH_CFG__have_cmd__hexdump=1 ;;
   *) c_BS_LIBPATH_CFG__have_cmd__hexdump=0 ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__have_cmd__hexdump'

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
#: #### `BS_LIBPATH_VERSION_MAJOR`
#:
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_VERSION_MINOR`
#:
#: - Integer >= 0.
#: - Incremented for significant changes that do not
#:   break compatibility with previous versions.
#: - Reset to 0 when
#:   [`BS_LIBPATH_VERSION_MAJOR`](#bs_libpath_version_major)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_VERSION_PATCH`
#:
#: - Integer >= 0.
#: - Incremented for minor revisions or bugfixes.
#: - Reset to 0 when
#:   [`BS_LIBPATH_VERSION_MINOR`](#bs_libpath_version_minor)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_VERSION_RELEASE`
#:
#: - A string indicating a pre-release version, always
#:   null for full-release versions.
#: - Possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended).
#:
  BS_LIBPATH_VERSION_MAJOR=1
  BS_LIBPATH_VERSION_MINOR=0
  BS_LIBPATH_VERSION_PATCH=0
BS_LIBPATH_VERSION_RELEASE=;

fn_bs_libpath_readonly 'BS_LIBPATH_VERSION_MAJOR' \
                       'BS_LIBPATH_VERSION_MINOR' \
                       'BS_LIBPATH_VERSION_PATCH' \
                       'BS_LIBPATH_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_VERSION_FULL`
#:
#: - Full version combining
#:   [`BS_LIBPATH_VERSION_MAJOR`](#bs_libpath_version_major),
#:   [`BS_LIBPATH_VERSION_MINOR`](#bs_libpath_version_minor),
#:   and [`BS_LIBPATH_VERSION_PATCH`](#bs_libpath_version_patch)
#:   as a single integer.
#: - Can be used in numerical comparisons
#: - Format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded).
#:
BS_LIBPATH_VERSION_FULL=$(( \
    ( (BS_LIBPATH_VERSION_MAJOR * 1000) + BS_LIBPATH_VERSION_MINOR ) * 1000 \
    + BS_LIBPATH_VERSION_PATCH \
  ))

fn_bs_libpath_readonly 'BS_LIBPATH_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_VERSION`
#:
#: - Full version combining
#:   [`BS_LIBPATH_VERSION_MAJOR`](#bs_libpath_version_major),
#:   [`BS_LIBPATH_VERSION_MINOR`](#bs_libpath_version_minor),
#:   [`BS_LIBPATH_VERSION_PATCH`](#bs_libpath_version_patch),
#:   and
#:   [`BS_LIBPATH_VERSION_RELEASE`](#bs_libpath_version_release)
#:   as a formatted string.
#: - Format: `BetterScripts 'libpath' vMAJOR.MINOR.PATCH[-RELEASE]`
#: - Derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#:
BS_LIBPATH_VERSION=$(
    printf "BetterScripts 'libpath' v%d.%d.%d%s\n" \
           "${BS_LIBPATH_VERSION_MAJOR}"           \
           "${BS_LIBPATH_VERSION_MINOR}"           \
           "${BS_LIBPATH_VERSION_PATCH}"           \
           "${BS_LIBPATH_VERSION_RELEASE:+-${BS_LIBPATH_VERSION_RELEASE}}"
  )

fn_bs_libpath_readonly 'BS_LIBPATH_VERSION'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_LAST_ERROR`
#:
#: - Stores the error message of the most recent error.
#: - ONLY valid immediately following a command for which
#:   the exit status is not `0` (`<zero>`).
#: - Available even when error output is suppressed.
#:
BS_LIBPATH_LAST_ERROR=; #< CLEAR ON SOURCING

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_SOURCED`
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
#: #### `BS_LIBPATH_CONFIG_QUIET_ERRORS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
#: - Type:     _FLAG_
#: - Class:    _VARIABLE_
#: - Default:  _OFF_
#: - \[Enable]/Disable library error message output.
#: - _OFF_: error messages will be written to `STDERR` as:
#:   `[libpath::<COMMAND>]: ERROR: <MESSAGE>`.
#: - _ON_: library error messages will be suppressed.
#: - The most recent error message is always available in
#:   [`BS_LIBPATH_LAST_ERROR`](#bs_libpath_last_error)
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
#: #### `BS_LIBPATH_CONFIG_FATAL_ERRORS`
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
#:   [`BS_LIBPATH_CONFIG_QUIET_ERRORS`](#bs_libpath_config_quiet_errors)).
#: - Both the library version of this option and the
#:   suite version can be modified between command
#:   invocations and will affect the next command.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_CONFIG_PREFER_HEXDUMP`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_PREFER_HEXDUMP`](./README.MD#better_scripts_config_prefer_hexdump)
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  _OFF_
#: - Enable/\[Disable] using `hexdump` in preference to `od`.
#: - _OFF_: use `od` whenever possible.
#: - _ON_:  use `hexdump` even if `od` is available.
#: - Only affects [`path_mktemp`](#path_mktemp).
#: - Has no effect unless both `od` and `hexdump` are
#:   available.
#: - Some systems lack `od`, but provide `hexdump` for the
#:   same purpose, while many provide both. This flag allows
#:   the use of either `od` or `hexdump` to be preferred.
#: - The default is to use `od` if available and `hexdump`
#:   otherwise. If neither command is available different
#:   (situation dependent) methods for generating data are
#:   used.
#: - See also:
#:   [`BS_LIBPATH_CONFIG_RANDOM_SOURCE`](#bs_libpath_config_random_source),
#:   and
#:   [`BS_LIBPATH_CONFIG_NO_MKTEMP`](#bs_libpath_config_no_mktemp).
#:
case ${BS_LIBPATH_CONFIG_PREFER_HEXDUMP:-${BETTER_SCRIPTS_CONFIG_PREFER_HEXDUMP:-A}}:${c_BS_LIBPATH_CFG__have_cmd__od}:${c_BS_LIBPATH_CFG__have_cmd__hexdump} in
[0A]:1:?) c_BS_LIBPATH_CFG__dump_util='od'      ;;
   *:?:1) c_BS_LIBPATH_CFG__dump_util='hexdump' ;;
       *) c_BS_LIBPATH_CFG__dump_util=;         ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__dump_util'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_CONFIG_RANDOM_SOURCE`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_RANDOM_SOURCE`](./README.MD#better_scripts_config_random_source)
#: - Type:     _TEXT_
#: - Class:    _CONSTANT_
#: - Default:  `/dev/urandom`
#: - Specify a source for random data.
#: - Only affects [`path_mktemp`](#path_mktemp).
#: - MUST be either the special value `awk` or a path to
#:   use as a source for random data.
#: - If specified as a path, the path MUST be readable,
#:   and MUST behave like `/dev/urandom`.
#: - If specified as `awk`, random data is generated by
#:   `awk` - **this is insecure** as the data generated is
#:   of poor quality and likely to be easy to guess.
#: - Has no effect if neither `od` nor `hexdump` is
#:   available.
#: - WARNING: `/dev/urandom` **can** block in some
#:   circumstances - when this may occur varies by system.
#: - See also:
#:   [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump),
#:   and
#:   [`BS_LIBPATH_CONFIG_NO_MKTEMP`](#bs_libpath_config_no_mktemp).
#:
c_BS_LIBPATH_CFG__rand_util=;
c_BS_LIBPATH_CFG__rand_src=${BS_LIBPATH_CONFIG_RANDOM_SOURCE:-${BETTER_SCRIPTS_CONFIG_RANDOM_SOURCE-}}
case ${c_BS_LIBPATH_CFG__dump_util:+1}:${c_BS_LIBPATH_CFG__rand_src}:$(test -r "${c_BS_LIBPATH_CFG__rand_src:-/dev/urandom}" && echo 'TRUE') in
  #-------------------------------------
  # `awk` forced
  *:awk:*)
    c_BS_LIBPATH_CFG__rand_util='awk' ;;

  #-------------------------------------
  # Checks passed
  1:*:TRUE)
    c_BS_LIBPATH_CFG__rand_util=${c_BS_LIBPATH_CFG__dump_util}
    : "${c_BS_LIBPATH_CFG__rand_src:=/dev/urandom}" ;;

  #-------------------------------------
  # Error: path not readable
  1:?*:)
    BS_LIBPATH__ConfigError=;
    : "${BS_LIBPATH__ConfigError:?'[libpath]: Config Error: invalid value for BS_LIBPATH_CONFIG_RANDOM_SOURCE (specified path is not readable).'}" ;;

  #-------------------------------------
  # Default to `awk` (something isn't
  # available)
  *)
    c_BS_LIBPATH_CFG__rand_util='awk' ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__rand_util' \
                              'c_BS_LIBPATH_CFG__rand_src'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBPATH_CONFIG_NO_MKTEMP`
#:
#: - Type:     _FLAG_
#: - Class:    _CONSTANT_
#: - Default:  _OFF_
#: - \[Enable]/Disable allowing the use of `mktemp`.
#: - _OFF_: allow `mktemp` to be used when possible.
#: - _ON_:  force `mktemp` to never be used, even if it
#:   is available.
#: - Only affects [`path_mktemp`](#path_mktemp).
#: - Has no effect if `mktemp` is not available.
#: - Functionality of `mktemp` implementations varies, and
#:   even when available it may not be possible to use
#:   `mktemp` in all cases. For example,
#:   [GNU `mktemp`][gnu_mktemp] provides more
#:   functionality than implementations such as
#:   [BSD][freebsd_mktemp] [variants][openbsd_mktemp].
#: - See also:
#:   [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump),
#:   and
#:   [`BS_LIBPATH_CONFIG_RANDOM_SOURCE`](#bs_libpath_config_random_source).
#:
case ${BS_LIBPATH_CONFIG_NO_MKTEMP:-A}:${c_BS_LIBPATH_CFG__have_cmd__mktemp} in
[A0]:g) c_BS_LIBPATH_CFG__mktemp_util='gmktemp'                       ;;       ## cSpell:Ignore gmktemp
[A0]:1) c_BS_LIBPATH_CFG__mktemp_util='mktemp'                        ;;
     *) c_BS_LIBPATH_CFG__mktemp_util=${c_BS_LIBPATH_CFG__rand_util}  ;;
esac

fn_bs_libpath_config_constant 'c_BS_LIBPATH_CFG__mktemp_util'

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
#. #### `c_BS_LIBPATH__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_LIBPATH__EX_NOINPUT`
#.
#. - Exit code for use on _INPUT ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
  c_BS_LIBPATH__EX_USAGE=64
c_BS_LIBPATH__EX_NOINPUT=66 ## cSpell:Ignore NOINPUT

fn_bs_libpath_readonly 'c_BS_LIBPATH__EX_USAGE'   \
                       'c_BS_LIBPATH__EX_NOINPUT'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBPATH__newline`
#.
#. - Literal `\n` (`<newline>`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_LIBPATH__newline='
'

fn_bs_libpath_readonly 'c_BS_LIBPATH__newline'


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
#; ### `fn_bs_libpath_error`
#;
#; Error reporting command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_error <CALLER> <MESSAGE>...
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
#; - If [`BS_LIBPATH_CONFIG_QUIET_ERRORS`](#bs_libpath_config_quiet_errors)
#;   is _OFF_ a message in the format `[libpath::<COMMAND>]: ERROR: <MESSAGE>`
#;   is written to `STDERR`.
#; - If [`BS_LIBPATH_CONFIG_FATAL_ERRORS`](#bs_libpath_config_fatal_errors)
#;   is _ON_ then an "unset variable" shell exception will be triggered using
#;   the [`${parameter:?[word]}`][posix_param_expansion] parameter expansion,
#;   where `word` is set to the error message.
#; - [`BS_LIBPATH_LAST_ERROR`](#bs_libpath_last_error) will contain the
#;   `<MESSAGE>` without any additional prefix regardless of other settings.
#;
#_______________________________________________________________________________
fn_bs_libpath_error() { ## cSpell:Ignore BS_LPE_
  BS_LPE_Caller=${1:?'[libpath::fn_bs_libpath_error]: Internal Error: a command name is required'}

  BS_LIBPATH_LAST_ERROR=;
  case $# in
  1)  : "${2:?'[libpath::fn_bs_libpath_error]: Internal Error: an error message is required'}" ;;
  2)  BS_LIBPATH_LAST_ERROR=$2 ;;
  *)  shift
      # NOTE: unset `IFS` == default `IFS`
      #       null  `IFS` == null  `IFS`
      case ${IFS-' '} in
      ' '*) BS_LIBPATH_LAST_ERROR=$* ;;
         *) BS_LIBPATH_LAST_ERROR=$(printf '%s ' "$@")
            BS_LIBPATH_LAST_ERROR=${BS_LIBPATH_LAST_ERROR% } ;;
      esac ;; #<: `case ${IFS-' '} in`
  esac #<: `case $# in`

  # OUTPUT ERROR
  case ${BS_LIBPATH_CONFIG_QUIET_ERRORS:-${BETTER_SCRIPTS_CONFIG_QUIET_ERRORS:-0}} in
  0)  printf '[libpath::%s]: ERROR: %s\n' \
             "${BS_LPE_Caller}"           \
             "${BS_LIBPATH_LAST_ERROR}"   >&2 ;;
  esac

  # ERROR EXCEPTION
  case ${BS_LIBPATH_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in
  0)  ;;
  *)  BS_LIBPATH__FatalError=;
      BS_LIBPATH__ErrorMessage="[libpath::${BS_LPE_Caller}]: ERROR: ${BS_LIBPATH_LAST_ERROR}"
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
      1)  eval 'BS_LIBPATH__ErrorMessage=${(qq)BS_LIBPATH__ErrorMessage}'
          eval ": \"\${BS_LIBPATH__FatalError:?${BS_LIBPATH__ErrorMessage}}\"" ;;
      *) : "${BS_LIBPATH__FatalError:?${BS_LIBPATH__ErrorMessage}}" ;;
      esac ;;
  esac
} #<: `fn_bs_libpath_error()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_invalid_args <CALLER> <MESSAGE>...
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
#; - Intended to make caller commands more readable and less verbose at the
#;   cost of some performance when an error occurs.
#;
#_______________________________________________________________________________
fn_bs_libpath_invalid_args() { ## cSpell:Ignore BS_LPIA_
  BS_LPIA_Caller=${1:?'[libpath::fn_bs_libpath_invalid_args]: Internal Error: a command name is required'}
  shift
  fn_bs_libpath_error "${BS_LPIA_Caller}" 'Invalid Arguments:' "$@"
} #<: `fn_bs_libpath_invalid_args()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_expected`
#;
#; Helper for errors reporting incorrect number of arguments.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_expected <CALLER> <EXPECTED>...
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
fn_bs_libpath_expected() { ## cSpell:Ignore BS_LPExpected_
  BS_LPExpected_Caller=${1:?'[libpath::fn_bs_libpath_expected]: Internal Error: a caller is required'}
  shift
  BS_LPExpected_Message=${1:?'[libpath::fn_bs_libpath_expected]: Internal Error: an expected argument is required'}
  shift

  #=========================================================
  #
  #=========================================================
  while : #<: `[ $# -gt 1 ]`
  do
    case $# in
    0)  break ;;
    1)  BS_LPExpected_Message="${BS_LPExpected_Message}, and $1"
        break ;;
    *)  BS_LPExpected_Message="${BS_LPExpected_Message}, $1"
        shift ;;
    esac
  done #<: `while [ $# -gt 1 ]`

  #=========================================================
  #
  #=========================================================
  fn_bs_libpath_error         \
    "${BS_LPExpected_Caller}" \
    "Invalid Arguments: expected ${BS_LPExpected_Message}"
} #<: `fn_bs_libpath_expected()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_validate_name`
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
#;     fn_bs_libpath_validate_name <CALLER> <NAME>
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
fn_bs_libpath_validate_name() { ## cSpell:Ignore BS_LPVN_
  BS_LPVN_Caller=${1:?'[libpath::fn_bs_libpath_validate_name]: Internal Error: a command name is required'}
    BS_LPVN_Name=${2?'[libpath::fn_bs_libpath_validate_name]: Internal Error: a variable name is required'}

  case ${BS_LPVN_Name:-#} in
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libpath_invalid_args \
      "${BS_LPVN_Caller}"      \
      "invalid variable name '${BS_LPVN_Name}'"
    return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libpath_validate_name()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_validate_name_hyphen`
#;
#; Similar to [`fn_bs_libpath_validate_name`](#fn_bs_libpath_validate_name)
#; but additionally allows the name to be `-` (`<hyphen>`), which implies
#; that `STDOUT` or `STDIN` should in place of the variable be used as
#; appropriate.
#;
#; See [`fn_bs_libpath_validate_name`](#fn_bs_libpath_validate_name) for more
#; details.
#;
#_______________________________________________________________________________
fn_bs_libpath_validate_name_hyphen() { ## cSpell:Ignore BS_LPVNH_
  BS_LPVNH_Caller=${1:?'[libpath::fn_bs_libpath_validate_name_hyphen]: Internal Error: a command name is required'}
    BS_LPVNH_Name=${2?'[libpath::fn_bs_libpath_validate_name_hyphen]: Internal Error: a variable name is required'}

  #---------------------------------------------------------
  # This command is called for many of the main commands.
  # To avoid an additional command call the test from
  # `fn_bs_libpath_validate_name` is duplicated here
  case ${BS_LPVNH_Name:-#} in
  -) : ;;
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libpath_invalid_args \
      "${BS_LPVNH_Caller}"     \
      "invalid variable name '${BS_LPVNH_Name}'"
    return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libpath_validate_name_hyphen()`

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
#; ### `fn_bs_libpath_file_mode_ls_to_chmod`
#;
#; Convert a **symbolic** file mode parsed from `ls` to a **symbolic** file mode
#; that can be used with `chmod`.
#;
#; On success, converted mode is written to `STDOUT`.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_file_mode_ls_to_chmod <CALLER> <MODE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Added to the output message.
#;
#; `MODE` \[in]
#;
#; : The mode to convert.
#; : Must be in the format: `u=???,g=???,o=???`.
#; : Valid values for each mode character are determined by
#;   the current implementation and configuration.
#;
#; _NOTES_
#; <!-- -->
#;
#; - If only allowing values from the standard, `MODE` must be of the format
#;   `u=[r-][w-][Ssx-],g=[r-][w-][Ssx-],o=[r-][w-][Ttx-]`. Some implementations
#;   allow additional characters.
#; - Any characters outside those specifically allowed are considered an error.
#; - Implementation depends on
#;   [`BS_LIBPATH_CONFIG_EXTENDED_FILE_MODE_FORMAT`](#bs_libpath_config_extended_file_mode_format).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - The requirement for `MODE` to already be in a `chmod` like format makes
#.   the code here simpler with less repetition, albeit at the expense of a more
#.   confusing interface.
#. - The standard constrains the format for extensions to the file mode as
#.   reported by `ls`, such that it makes possible to extract _some_ information
#.   from extensions. However, there is no robust way to extract _all_ the
#.   information from these extensions, meaning that information would always be
#.   lost. Therefore these are always considered errors.
#. - `chmod` requires changes to the `s`, `S`, `t`, and `T` permissions to
#.   correctly match the `ls` reported values; `s` & `t` imply `x` in
#.   addition to `s` or `t` (respectively), while `S` & `T` only imply either
#.   `s` or `t` (respectively).
#. - The `t` permission is _not_ associated with the "other" group for `chmod`,
#.   the standard allows it with no "who", or with `a`, however some
#.   implementations (e.g. Solaris) diverge from the standard and instead
#.   require no "who" or `u`. The most portable option appears to be to use no
#.   "who" for `t`. (This is also true for at least some implementation
#.   dependent permissions, e.g. `l` on Solaris.)
#
#_______________________________________________________________________________
case ${c_BS_LIBPATH_CFG__file_mode_format:-posix} in
  #_____________________________________________________________________________
  # `solaris`
  #
  # Solaris comes with multiple versions of `ls` (as with most tools), each
  # of which has specific characteristics. As of Solaris 11.4 (2023), these
  # are: `/usr/bin/ls` (default), `/usr/xpg4/bin/ls`, and `/usr/xpg6/bin/ls`.
  #
  # - All of the tools installed in `/usr/xpg?/bin/` are largely _POSIX.1_
  #   compliant and work as would be expected, but these are _not_ the default
  #   versions, and are only available in newer versions of the OS.
  # - The versions of tools installed `/usr/bin/` are legacy tools and often
  #   lack many features of more modern versions and are often somewhat
  #   different from the standard.
  #
  # Solaris provides mandatory file locking as a file mode for non-executable
  # files as a standards compliant extension.
  #
  # - For `chmod` this can be specified with the `+l` permission, but can
  #   **not** be set if either `s` or `x` are also set for the "group"
  #   permissions.
  # - For `ls` implementations, the mandatory file locking file mode is
  #   represented in the "group" portion of the mode in the same position as
  #   the `[Ssx]` values, but using different values:
  #   - `/usr/bin/ls` uses `l` (lowercase ell) to represent this permission.
  #     **This is _not_ standards compliant.**
  #   - `/usr/xpg4/bin/ls` and `/usr/xpg6/bin/ls` both use `L` to represent
  #     this permission. This **is** standards compliant.
  #
  # As there is no real way to determine which version of `ls` produced the
  # output, and therefore no way to determine which value should be expected,
  # however each version of `ls` only uses one of these values, so the code
  # here simply allows either.
  #
  #_____________________________________________________________________________
  'solaris')
    fn_bs_libpath_file_mode_ls_to_chmod() { ## cSpell:Ignore BS_LPFMLTC_
      BS_LPFMLTC_Caller=${1:?'[libpath::fn_bs_libpath_file_mode_ls_to_chmod]: Internal Error: a command name is required'}
        BS_LPFMLTC_Mode=${2:?'[libpath::fn_bs_libpath_file_mode_ls_to_chmod]: Internal Error: a mode is required'}

      case ${BS_LPFMLTC_Mode} in
      u=[r-][w-][Ssx-],g=[r-][w-][SsxLl-],o=[r-][w-][Ttx-])
          {
            printf '%s\n' "${BS_LPFMLTC_Mode}"
          } | {
            sed -e 's/s/sx/
                    s/S/s/g
                    s/[Ll]/,+l/
                    s/t/x,+t/
                    s/T/,+t/
                    s/-//g'
          } ;;

      *)  fn_bs_libpath_error      \
            "${BS_LPFMLTC_Caller}" \
            "can not convert mode to chmod format; unrecognized permission flags '${BS_LPFMLTC_Mode}'"
          return "${c_BS_LIBPATH__EX_USAGE}" ;;
      esac
    } #<: `fn_bs_libpath_file_mode_ls_to_chmod()`
  ;;

  #_____________________________________________________________________________
  # `posix`: Only allows the standard defined values.
  #_____________________________________________________________________________
  'posix')
    fn_bs_libpath_file_mode_ls_to_chmod() { ## cSpell:Ignore BS_LPFMLTC_
      BS_LPFMLTC_Caller=${1:?'[libpath::fn_bs_libpath_file_mode_ls_to_chmod]: Internal Error: a command name is required'}
        BS_LPFMLTC_Mode=${2:?'[libpath::fn_bs_libpath_file_mode_ls_to_chmod]: Internal Error: a mode is required'}

      case ${BS_LPFMLTC_Mode} in
      u=[r-][w-][Ssx-],g=[r-][w-][Ssx-],o=[r-][w-][Ttx-])
          {
            printf '%s,\n' "${BS_LPFMLTC_Mode}"
          } | {
            sed -e 's/s/sx/
                    s/S/s/g
                    s/t/x,+t/
                    s/T/,+t/
                    s/-//g'
          } ;;

      *)  fn_bs_libpath_error      \
            "${BS_LPFMLTC_Caller}" \
            "can not convert mode to chmod format; unrecognized permission flags '${BS_LPFMLTC_Mode}'"
          return "${c_BS_LIBPATH__EX_USAGE}" ;;
      esac
    } #<: `fn_bs_libpath_file_mode_ls_to_chmod()`
  ;;

  #_____________________________________________________________________________
  # Error: For additional safety only; should be impossible to trigger.
  #_____________________________________________________________________________
  *)
    BS_LIBPATH__ConfigError=;
    : "${BS_LIBPATH__ConfigError:?'[libpath]: Internal Error: unexpected value for c_BS_LIBPATH_CFG__file_mode_format.'}" ;;
esac #<: `case ${c_BS_LIBPATH_CFG__file_mode_format} in`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `c_BS_LIBPATH_sed__to_base62`
#;
#; `sed` script to convert bytes from `od` or `hexdump` into base-62.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     od -A n -t a ... | sed -e "${c_BS_LIBPATH_sed__to_base62}"
#;
#;     hexdump -v -e '..."%_u"...' ... | sed -e "${c_BS_LIBPATH_sed__to_base62}"
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - Expects US ASCII input with other values represented as multi-character
#;   names, octal-digits, or hexadecimal-digits. For example, using `-t a`
#;   with `od`, or `%_u` with `hexdump`.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The script combines all input in the pattern space; removes values longer
#;   than a single character; then removes all characters not in base-62 (this
#;   second step also removes any whitespace between values).
#; - Discarding values in this way does _not_ bias the random data (unlike
#;   the use of division/modulus would).
#; - Assumes `od` style, multi-line input (16 values per line), but will work
#;   with all input on a single line.
#;
#_______________________________________________________________________________
c_BS_LIBPATH_sed__to_base62='
:LOOP
  N
  $!b LOOP
s/[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]\{2,3\}//g
s/[^abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]//g'

fn_bs_libpath_readonly 'c_BS_LIBPATH_sed__to_base62'

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_mktemp_rand`
#;
#; Generate a sequence of base-62 characters for [`path_mktemp`](#path_mktemp).
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_mktemp_rand <COUNT>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `COUNT` \[in]
#;
#; : Number of base-62 characters to generate.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Random data is read in 256-byte chunks, doubling the chunk size on each
#;   subsequent read if `COUNT` has not yet been satisfied.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - If using `/dev/urandom` this may block till enough entropy is available.
#;   This is unavoidable, and it is not clear if this can be detected in advance
#;   on all systems. If/when this occurs is system dependent - for some systems
#;   it never occurs, for others it occurs only early in the boot process, while
#;   yet others may block whenever entropy is low (which is exactly what using
#;   `/dev/urandom` is supposed to avoid).
#;
#; _IMPLEMENTATION NOTES (`/dev/random`)_
#; <!-- ----------------------------- -->
#;
#; - `/dev/random` and `/dev/urandom` were introduced at the same time.
#;   - `/dev/random` will block unless it has sufficient entropy.
#;   - `/dev/urandom` will not normally block.
#; - On some systems `/dev/urandom` may be link to `/dev/random` and so may
#;   block in the same way as `/dev/random`.
#; - In almost all cases the correct path to use is `/dev/urandom`.
#; - Although rarer `/dev/urandom` may still block - especially early in the
#;   boot process.
#; - While `/dev/random` and `/dev/urandom` are common on many POSIX-like
#;   systems it is unclear if the associated paths that can query information
#;   about them are also available (e.g. `proc/sys/kernel/random/entropy_avail`)
#; - Reading from `/dev/urandom` and converting to base-62 can be implemented
#;   in a number of ways, however the most efficient is to simply discard bytes
#;   outside the required range. This has the advantage of not biasing the
#;   values which, without some care, would happen if using division/modulus.
#;   The process of discarding bytes can be done with a simple `sed` script,
#;   assuming the format fed into the script is suitable - both `od` and
#;   `hexdump` have such formats.
#;
#; _IMPLEMENTATION NOTES (`awk`)_
#; <!-- --------------------- -->
#;
#; Part of the goal of `mktemp` is to generate random paths that are difficult
#; for an adversary to guess to avoid a potential attack vector. This requires
#; the generation of random data that is not easily knowable. If `/dev/urandom`
#; is not available, the only real standard defined source of random data is the
#; `rand` function in `awk` - unfortunately there are a number of issues with it
#; that make it practically impossible to use to generate secure values:
#;
#; - the underlying generator is likely of poor quality;
#; - the value generated is a floating point number - the process of
#;   converting to an integer will almost certainly bias the resulting
#;   distribution (similar to the effect of the common `rand() % RANGE`);
#; - it generates identical output for every invocation of `awk`.
#;
#; Even if it were possible to fix the first two issues, the need to seed the
#; generator on every invocation breaks the security: if the seed is known (or
#; guessable) then the output will also be known, and without access to true
#; random data the seed will always be guessable to a certain extent.
#;
#; The obvious source of a seed is to use the local time - this is easy enough
#; as `awk` provides the functionality if `srand` is called with no seed.
#; However, this is not good enough as the granularity of the time is seconds,
#; which is too low to make this usable, even without security concerns (e.g.
#; running `Temp1=$(mktemp -u); Temp2=$(mktemp -u);` will periodically result
#; in the same path twice). There is no standard defined way of getting a time
#; with more useful granularity.
#;
#; From a security stand point, using the time is not much better than using
#; no seed - an adversary can easily compute, say, a minute's worth of
#; possible output values, if they also know the template used to create a
#; path, then all output from `mktemp` in that window will be one of the
#; computed values.
#;
#; One alternative is to use a PID. Generally speaking the PID a process will be
#; given is unknowable until it occurs (although it is possible to guess with
#; some degree of accuracy, the ease of this depends on the specifics of the
#; workload of an individual machine).
#;
#; [^process_identifier]: A PID, or Process Identifier, is a numerical value
#;                        that uniquely defines each process on a specific
#;                        machine at a specific time. Although a PID for a
#;                        process can be used again for a later process, there
#;                        are rules about how this occurs to ensure a
#;                        significant gap.
#;
#; While using the PID of the current process is possible, this is unhelpful in
#; practice as it is constant over the lifetime of a process and is easy to
#; determine for a specific process, leading to both usage and security issues.
#; Better is to use a PID for a _new_ process - a process created _only_ to
#; generate a seed. Since processes are continually started and stopped on any
#; working system, the precise PID of a new process is unknowable and is never
#; the same value over a relatively large window of time.
#;
#; "Unknowable" is not "unguessable" though. Any new PID is likely to be in a
#; fairly narrow range of values. For a script this range is almost always of
#; the form `($$, $$ + N]` where `N` may be as low as single digits on a lightly
#; loaded system, and even at best is unlikely to be more than 2 digits.
#;
#; Additional sources for pseudorandom data are difficult to find - there are
#; few (if any) sources that are not also going to be available to an adversary
#; making them largely useless in this context. Still, although both PID and
#; time data are not very useful alone, combining them allows us to improve
#; the randomness somewhat. It does _not_ make them secure, but it _does_
#; increase the range of possible values the final seed can have, making it
#; more difficult for an adversary attack.
#;
#; Combining multiple values to generate a seed comes with it's own problems,
#; most important of which are avoid overflow, and ensuring the final value
#; actually provides more security. For example, simply summing a PID and the
#; current time does _not_ significantly increase the security - if a PID is
#; guessable with a range `($$, $$ + N]` and a time guessable with a range
#; `[T, T + M]` the final seed is guessable in a range
#; `($$ + T, ($$ + T) + N + M]` - this is not a significant improvement as both
#; `N` and `M` are likely to be small anyway.
#;
#; A better approach is to use a product of the two values - in this case the
#; range of output values is also a product, which even for small input ranges
#; creates a much larger possible output range. The final range is still small,
#; but it is somewhat better than the alternatives.
#;
#; Unfortunately a product is at far greater risk of overflow than a sum, but
#; how much of a real world issue this might actually be is difficult to know,
#; and is complicated by the lack of detail in the standard when it comes to
#; much of `awk`.
#;
#; Given `/dev/random` has existed since the mid-nineties, and is available
#; in most (perhaps all?) POSIX-like systems, the code here is relatively
#; unlikely to be used except on esoteric platforms or in a restricted shell.
#; How big a risk the low entropy implementation is in these cases is not
#; very clear and may well be limited, but in any case, there seems little
#; scope to improve the situation much without using system specific
#; alternatives (which could be added if shown to be needed).
#;
#. Useful references:
#.
#.  - https://en.wikipedia.org/wiki//dev/random
#.  - https://en.wikipedia.org/wiki/Linear_congruential_generator               ## cSpell:Ignore LCG
#.  - https://en.wikipedia.org/wiki/Combined_linear_congruential_generator      ## cSpell:Ignore CLCG
#.
#. Other notes:
#.
#.  - The standard does not define:
#.    - requirements for the values that `srand` in `awk` should accept - it's
#.      not clear what happens to values that negative, large, or fractional.
#.    - requirements for the output of `rand` with the exception that it is
#.      a value `n` such that `0<=n<1` (i.e. no indication of how the value
#.      is to be calculated or any expectations about its randomness).
#.  - In `awk` the statement `srand(srand())` will return the current system
#.    time in seconds.
#.  - `awk` arithmetic is double precision floating point, while shell
#.    arithmetic is only guaranteed as signed long - both these types are
#.    problematic for random number computations.
#.  - Converting the value from `rand()` in `awk` into the range required for
#.    use in here is likely to bias the distribution, but in light of the
#.    issues around the seed, this is not really a concern.
#.  - Using the PID and time as seeds to two different LCG then combining
#.    via a CLCG to determine either a random number or a seed for `srand`
#.    _may_ provide greater security (not clear if this would increase the
#.    range of possible seeds beyond a simple product significantly or at all).
#.  - Storing values (e.g. an increment) as shell variables runs into problems
#.    with subshells not being able to change values in parent shells.
#.
#_______________________________________________________________________________
case ${c_BS_LIBPATH_CFG__rand_util:?'[libpath::c_BS_LIBPATH_CFG__rand_util]: Internal Error: config value not set'} in
  #_____________________________________________________________________________
  # Use `od`
  #_____________________________________________________________________________
  od)
    fn_bs_libpath_mktemp_rand() { ## cSpell:Ignore BS_LPMTR_
      BS_LPMTR_Count=${1:?'[libpath::fn_bs_libpath_mktemp_rand]: Internal Error: a count is required'}

      #-----------------------------------------------------
      # Not all bytes read will be used - many will be
      # outside base-62 and so discarded. By default 256
      # bytes are read, unless the count required is greater
      # than this in which case twice the count is read.
      #
      # 256 bytes is largely arbitrary, but is likely to be
      # far larger than count in almost all cases while also
      # likely to be relatively friendly to byte boundaries.
      #-----------------------------------------------------
      BS_LPMTR_ReadBytes=256
      if [ "${BS_LPMTR_Count}" -ge "${BS_LPMTR_ReadBytes}" ]
      then
        BS_LPMTR_ReadBytes=$(( BS_LPMTR_Count * 2 ))
      fi

      #-----------------------------------------------------
      # This loop will iterate till the buffer length is
      # long enough to satisfy the count required. In most
      # cases this will be a single iteration.
      #
      # NOTE: This `while` loop is effectively a `do..while`
      #       so the test is at the end of the loop - this
      #       avoids an unnecessary test on the first
      #       iteration.
      #-----------------------------------------------------
      BS_LPMTR_Buffer=;
      while : #<: `[ ${#BS_LPMTR_Buffer} -lt "${BS_LPMTR_Count}" ]`
      do
        #---------------------------------------------------
        # There are a few different output formats supported
        # by `od` that would work here: `-c`, `-t a`, and
        # `-t c` are all possible, however both `-c` and
        # `-t c` depend on `LC_CTYPE` making them
        # potentially problematic.
        #
        # NOTE: `-t a` causes `od` to ignore the top bit of
        #       each byte, effectively equivalent to
        #       `X % 128`. This will _not_ bias the data as
        #       128 is an exact multiple of 256.
        #---------------------------------------------------
        BS_LPMTR_Buffer="${BS_LPMTR_Buffer}$(
            {
              od \
                -v -A 'n' -t 'a'           \
                -N "${BS_LPMTR_ReadBytes}" \
                "${c_BS_LIBPATH_CFG__rand_src}"
            } | {
              sed -e "${c_BS_LIBPATH_sed__to_base62}"
            }
          )"

        if [ ${#BS_LPMTR_Buffer} -gt "${BS_LPMTR_Count}" ]
        then
          break
        fi
      done #<: `while [ ${#BS_LPMTR_Buffer} -lt "${BS_LPMTR_Count}" ]`

      #-----------------------------------------------------
      # Truncate and output the buffer
      #-----------------------------------------------------
      printf "%.${BS_LPMTR_Count}s\n" "${BS_LPMTR_Buffer}"
    } #<: `fn_bs_libpath_mktemp_rand()`
  ;;

  #_____________________________________________________________________________
  # Use `hexdump`
  #_____________________________________________________________________________
  hexdump)
    fn_bs_libpath_mktemp_rand() { ## cSpell:Ignore BS_LPMTR_
      BS_LPMTR_Count=${1:?'[libpath::fn_bs_libpath_mktemp_rand]: Internal Error: a count is required'}

      #-----------------------------------------------------
      # Not all bytes read will be used - many will be
      # outside base-62 and so discarded. By default 256
      # bytes are read, unless the count required is greater
      # than this in which case twice the count is read.
      #
      # 256 bytes is largely arbitrary, but is likely to be
      # far larger than count in almost all cases while also
      # likely to be relatively friendly to byte boundaries.
      #-----------------------------------------------------
      BS_LPMTR_ReadBytes=256
      if [ "${BS_LPMTR_Count}" -ge "${BS_LPMTR_ReadBytes}" ]
      then
        BS_LPMTR_ReadBytes=$(( BS_LPMTR_Count * 2 ))
      fi

      #-----------------------------------------------------
      # This loop will iterate till the buffer length is
      # long enough to satisfy the count required. In most
      # cases this will be a single iteration.
      #
      # NOTE: This `while` loop is effectively a `do..while`
      #       so the test is at the end of the loop - this
      #       avoids an unnecessary test on the first
      #       iteration.
      #-----------------------------------------------------
      BS_LPMTR_Buffer=;
      while : #<: `[ ${#BS_LPMTR_Buffer} -lt "${BS_LPMTR_Count}" ]`
      do
        #---------------------------------------------------
        # There are a few different output formats supported
        # by `hexdump` that would work here: `%_c`, `%_p`,
        # and `%_u` are all possible, however `%_u` most
        # closely matches both `od` output so use it.
        #
        # NOTE: For simplicity output is matched as closely
        #       to that from `od` as possible, though
        #       `hexdump` supports a much wider range of
        #       possible outputs, some of which _may_ be
        #       more efficient here.
        #---------------------------------------------------
        BS_LPMTR_Buffer="${BS_LPMTR_Buffer}$(
            {
              hexdump \
                -v -e '16/1 "%_u " 1 "\n"' \
                -n "${BS_LPMTR_ReadBytes}" \
                "${c_BS_LIBPATH_CFG__rand_src}"
            } | {
              sed -e "${c_BS_LIBPATH_sed__to_base62}"
            }
          )"

        if [ ${#BS_LPMTR_Buffer} -gt "${BS_LPMTR_Count}" ]
        then
          break
        fi
      done #<: `while [ ${#BS_LPMTR_Buffer} -lt "${BS_LPMTR_Count}" ]`

      #-----------------------------------------------------
      # Truncate and output the buffer
      #-----------------------------------------------------
      printf "%.${BS_LPMTR_Count}s\n" "${BS_LPMTR_Buffer}"
    } #<: `fn_bs_libpath_mktemp_rand()`
  ;;

  #_____________________________________________________________________________
  # Use `awk`
  #_____________________________________________________________________________
  awk)
    fn_bs_libpath_mktemp_rand() { ## cSpell:Ignore BS_LPMTR_
      BS_LPMTR_Count=${1:?'[libpath::fn_bs_libpath_mktemp_rand]: Internal Error: a count is required'}

      #-----------------------------------------------------
      # Since `awk` expects input (even when it sometimes
      # should not), and using other methods of passing data
      # to `awk` can be finicky, it's easiest just to pipe
      # it in.
      #
      # NOTE: This assumes no failure for the commands used
      #       - it is pretty unlikely that these commands
      #       would fail, but failure is always possible,
      #       however it is not clear how best to handle
      #       such a possibility.
      # NOTE: Some versions of `awk` do not process values
      #       as numerical **unless** they have had
      #       arithmetic performed upon them - hence the
      #       need for `+ 0` in some locations.
      #-----------------------------------------------------
      {
        printf '%d\n' "${BS_LPMTR_Count}"
        sh -c 'printf "%d\n" "$$"'
        date '+%S'
      } | {
        awk \
          'BEGIN{
            getline BS_LP_Count
            BS_LP_Count = BS_LP_Count + 0

            getline BS_LP_PID
            BS_LP_PID = BS_LP_PID + 0

            getline BS_LP_Seconds
            # Add 1 to seconds to avoid 0
            BS_LP_Seconds = BS_LP_Seconds + 1

            #-----------------------------------------------
            # Although `awk` supports arrays it is actually
            # easier (and possibly faster) to use a string
            # and `substr` to generate characters than to
            # use an array. (Arrays are associative and
            # require initializing one element at a time -
            # the cost of initialization and lookup is
            # likely to be greater than that of simply
            # scanning a string.)
            #-----------------------------------------------
            BS_LP_Buffer="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

            srand(BS_LP_PID * BS_LP_Seconds)

            for (charCount = 0; charCount < BS_LP_Count; charCount = charCount + 1) {
              #---------------------------------------------
              # Convert output from `rand` from 0 <= X <= 1
              # to 0 <= X <= 61.
              #
              # The `int` function in `awk` truncates the
              # value - explicitly **rounds towards zero**
              # for values greater than zero.
              #---------------------------------------------
              BS_LP_Index0 = int((rand() * 61.0) + 0.5)

              BS_LP_Random = BS_LP_Random substr(BS_LP_Buffer, BS_LP_Index0 + 1, 1)
            }

            print BS_LP_Random
          }
        '
      }
    } #<: `fn_bs_libpath_mktemp_rand()`
  ;;

  #_____________________________________________________________________________
  # Error: For additional safety only; should be impossible to trigger.
  #_____________________________________________________________________________
  *)
    BS_LIBPATH__ConfigError=;
    : "${BS_LIBPATH__ConfigError:?'[libpath]: Internal Error: unexpected value for c_BS_LIBPATH_CFG__rand_util.'}" ;;
esac #<: `case ${c_BS_LIBPATH_CFG__use_od-}:${c_BS_LIBPATH_CFG__rand_src:+1} in`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_mktemp_test`
#;
#; Test if a given path exists.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_mktemp_test <PATH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `PATH` \[in]
#;
#; : Path to test.
#;
#_______________________________________________________________________________
fn_bs_libpath_mktemp_test() { ## cSpell:Ignore BS_LP_MTT_
  BS_LP_MTT_Path=${1:?'[libpath::fn_bs_libpath_mktemp_test]: Internal Error: a path is required'}
  if test -e "${BS_LP_MTT_Path}"
  then
    return 1
  else
    return 0
  fi
} #<: `fn_bs_libpath_mktemp_test()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_mktemp_dir`
#;
#; Attempt to create a directory from a given path.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_mktemp_dir <PATH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `PATH` \[in]
#;
#; : Path to create.
#; : MUST be a directory path.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - MUST be invoked in a subshell environment.
#; - Invokes `umask 077` before attempting creation in order to match the
#;   behavior of the commonly available `mktemp` utility.
#;
#_______________________________________________________________________________
fn_bs_libpath_mktemp_dir() { ## cSpell:Ignore BS_LP_MTD_
  BS_LP_MTD_Path=${1:?'[libpath::fn_bs_libpath_mktemp_dir]: Internal Error: a path is required'}
  {
    umask 077
  } && {
    mkdir "${BS_LP_MTD_Path}"
  }
} #<: `fn_bs_libpath_mktemp_dir()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_mktemp_file`
#;
#; Attempt to create a file from a given path.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_mktemp_file <PATH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `PATH` \[in]
#;
#; : Path to create.
#; : MUST be a file path (i.e. must **not** end with
#;   `/` (`<slash>`)).
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - MUST be invoked in a subshell environment.
#; - Invokes `umask 077` before attempting creation in order to match the
#;   behavior of the commonly available `mktemp` utility.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - `printf` is not required - alternatives like `true`, `:`, etc would also
#.   work. However, `printf` is clearer in intent, and avoids issues with other
#.   commands potentially generating unexpected output.
#. - `echo` is **not** suitable as it always writes out a trailing newline.
#.
#_______________________________________________________________________________
fn_bs_libpath_mktemp_file() { ## cSpell:Ignore BS_LP_MTF_
  BS_LP_MTF_Path=${1:?'[libpath::fn_bs_libpath_mktemp_file]: Internal Error: a path is required'}
  {
    set -C
  } && {
    umask 077
  } && {
    printf '' > "${BS_LP_MTF_Path}"
  }
} #<: `fn_bs_libpath_mktemp_file()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_mktemp_fallback`
#;
#; Emulated `mktemp` implementation.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_mktemp_fallback <CALLER> <QUIET> <COMMAND> <TEMPLATE> <LOCATION> <SUFFIX>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Added to the output message.
#;
#; `QUIET` \[in]
#;
#; : Flag to indicate if errors are suppressed or not.
#; : MUST be the value `1` (`<one>`) if errors are to be
#;   suppressed; `0` (`<zero>`) otherwise.
#;   (**Value is not verified.**)
#;
#; `COMMAND` \[in]
#;
#; : The command used to generate the path.
#; : Invoked with the full path to generate as a single
#;   argument.
#; : Output is suppressed _unless_ `QUIET` is `0` (`<zero>`)
#;   _and_ a non-success status is indicated.
#;
#; `TEMPLATE` \[in]
#;
#; : Template used to generate the temporary path.
#; : MUST contain a sequence of `X` characters of length 3
#;   or more in the _final_ path segment.
#;   (**Value is not verified.**)
#;
#; `LOCATION` \[in]
#;
#; : The location for the final path.
#; : MUST be specified, but may be null.
#;
#; `SUFFIX` \[in]
#;
#; : Any suffix for the final path.
#; : MUST be specified, but may be null.
#;
#; _CAVEATS_
#; <!--  -->
#;
#; - Used internally only, so arguments are assumed correct.
#;
#; _NOTES_
#; <!-- -->
#;
#; - See [`path_mktemp`](#path_mktemp) for more information.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Any user template _may_ contain **multiple** strings of three or more `X`
#.   characters - only the _last_ of any such sequences is used (others are
#.   interpreted literally).
#. - At first glance this would appear to need an alternate version for dealing
#.   with multi-byte characters, however, this is not actually required:
#.   parameter expansion is safe provided `?` is not used and matches are
#.   delimited with single-byte characters _or_ fixed strings; for string length
#.   the value will always be bytes (not characters), however, as the only
#.   length that matters is the count of `X` characters in the template, the
#.   difference between bytes and characters will cancel out, leaving the same
#.   value in both cases.
#.
#_______________________________________________________________________________
fn_bs_libpath_mktemp_fallback() { ## cSpell:Ignore BS_LP_PMFB_
    BS_LP_PMFB_Caller=${1:?'[libpath::fn_bs_libpath_mktemp_fallback]: Internal Error: a caller is required'}
     BS_LP_PMFB_Quiet=${2:?'[libpath::fn_bs_libpath_mktemp_fallback]: Internal Error: a quiet flag is required'}
       BS_LP_PMFB_Cmd=${3:?'[libpath::fn_bs_libpath_mktemp_fallback]: Internal Error: a command is required'}
  BS_LP_PMFB_Template=${4:?'[libpath::fn_bs_libpath_mktemp_fallback]: Internal Error: a template is required'}
  BS_LP_PMFB_Location=${5?'[libpath::fn_bs_libpath_mktemp_fallback]: Internal Error: a location is required'}
    BS_LP_PMFB_Suffix=${6?'[libpath::fn_bs_libpath_mktemp_fallback]: Internal Error: a suffix is required'}

  #=========================================================
  # Process the template into a prefix and suffix - a
  # random element will be inserted between these in
  # order to generate the temporary path.
  #
  # At this point the template contains **only** the
  # final portion of the full path (i.e. no parent
  # directories) - the rest of any path has been moved
  # to the location variable.
  #=========================================================

  #---------------------------------------------------------
  # The template may contain more than one run of 'XXX',
  # to ensure using the correct sequence of 'XXX' needs
  # a little care (when using parameter expansion). In
  # particular it needs to be processed in multiple steps
  # where at first it seems like fewer steps would work.
  #---------------------------------------------------------
  BS_LP_PMFB_TemplateSuffix=${BS_LP_PMFB_Template##*XXX}
  BS_LP_PMFB_TemplatePrefix=${BS_LP_PMFB_Template%XXX*"${BS_LP_PMFB_TemplateSuffix-}"}
  case ${BS_LP_PMFB_TemplatePrefix} in
  *X)    BS_LP_PMFB_TemplateXXX=${BS_LP_PMFB_TemplatePrefix##*[!X]}
      BS_LP_PMFB_TemplatePrefix=${BS_LP_PMFB_TemplatePrefix%"${BS_LP_PMFB_TemplateXXX-}"} ;;
  esac

  #---------------------------------------------------------
  # Determine the number of random characters to use
  #---------------------------------------------------------
  BS_LP_PMFB_RandomLength=$((
      ${#BS_LP_PMFB_Template} - (
        ${#BS_LP_PMFB_TemplatePrefix} + ${#BS_LP_PMFB_TemplateSuffix}
      )
    ))

  #---------------------------------------------------------
  # Append both location and suffix to the respective
  # values to create an almost complete path.
  #---------------------------------------------------------
  BS_LP_PMFB_PathPrefix="${BS_LP_PMFB_Location:+${BS_LP_PMFB_Location%/}/}${BS_LP_PMFB_TemplatePrefix}"
  BS_LP_PMFB_PathSuffix="${BS_LP_PMFB_TemplateSuffix-}${BS_LP_PMFB_Suffix-}"

  #=========================================================
  # Since we are using base-62 for the output and there
  # are a minimum of 3 random characters, the minimum
  # number of possible permutations is 62^3 = 238328.
  # We use this as a hard maximum iterations of the loop
  # to prevent an infinite loop, though it is unlikely
  # to occur. (Note that even for a template of length 3
  # this will be unlikely to try all the combinations,
  # as some will be tried more than once.)
  #=========================================================
  BS_LP_PMFB_ErrorOutput=;
  BS_LP_PMFB_MaxAttempts=238328
  while : #<: `[ ${BS_LP_PMFB_MaxAttempts} -gt 0 ]`
  do
    #> LOOP TEST -------------------------------------------
    #> LOOP TEST AT LOOP END
    #> -----------------------------------------------------

    #-------------------------------------------------------
    # Get the random characters
    #-------------------------------------------------------
    BS_LP_PMFB_RandomString=$(
        fn_bs_libpath_mktemp_rand "${BS_LP_PMFB_RandomLength}"
      ) || return $?

    #-------------------------------------------------------
    # Construct the full path
    #-------------------------------------------------------
    BS_LP_PMFB_Path="${BS_LP_PMFB_PathPrefix-}${BS_LP_PMFB_RandomString}${BS_LP_PMFB_PathSuffix-}"

    #-------------------------------------------------------
    # Test for or create the path
    #-------------------------------------------------------
    BS_LP_PMFB_Output=;
    if BS_LP_PMFB_Output=$("${BS_LP_PMFB_Cmd}" "${BS_LP_PMFB_Path}" 2>&1)
    then
      printf '%s\n' "${BS_LP_PMFB_Path}"
      break
    else
      case ${BS_LP_PMFB_Output:+1} in
      1) BS_LP_PMFB_ErrorOutput="${BS_LP_PMFB_ErrorOutput-}${BS_LP_PMFB_Output}${c_BS_LIBPATH__newline}" ;;
      esac
    fi

    #-------------------------------------------------------
    #
    #-------------------------------------------------------
    BS_LP_PMFB_MaxAttempts=$(( BS_LP_PMFB_MaxAttempts - 1 ))

    #> LOOP TEST -------------------------------------------
    case ${BS_LP_PMFB_MaxAttempts} in 0) break ;; esac #< [ "${BS_LP_PMFB_MaxAttempts}" -gt 0 ]
    #> -----------------------------------------------------
  done #<: `while [ ${BS_LP_PMFB_MaxAttempts} -gt 0 ]`

  #=========================================================
  # Output errors if generated & enabled
  #=========================================================
  case ${BS_LP_PMFB_ErrorOutput:+1}:${BS_LP_PMFB_Quiet:-0} in
  1:0) printf '%s' "${BS_LP_PMFB_ErrorOutput}" >&2 ;;
  esac

  #=========================================================
  #
  #=========================================================
  case ${BS_LP_PMFB_MaxAttempts} in
  0)  fn_bs_libpath_error      \
        "${BS_LP_PMFB_Caller}" \
        'reached maximum number of attempts while trying to create path'
      return 1 ;;
  *)  return 0 ;;
  esac
} #<: `fn_bs_libpath_mktemp_fallback()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_mktemp`
#;
#; Helper command that provides the implementation for
#; [`path_mktemp`](#path_mktemp), [`path_mktmp`](#path_mktmp), and the
#; standalone version of the command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_mktemp
#;        'L'
#;        [--target <VARIABLE>|--output <VARIABLE>]
#;        [-q|--quiet] [-d|--directory] [-u|--dry-run]
#;        [-p <DIRECTORY>|--tmpdir[=<DIRECTORY>]] [-t]
#;        [--suffix <SUFFIX>]
#;        [--]
#;        [<TEMPLATE>]
#;
#;     fn_bs_libpath_mktemp
#;        'S'
#;        [--help] [--version]
#;        [-q|--quiet] [-d|--directory] [-u|--dry-run]
#;        [-p <DIRECTORY>|--tmpdir[=<DIRECTORY>]] [-t]
#;        [--suffix <SUFFIX>]
#;        [--]
#;        [<TEMPLATE>]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `L` \[in]
#;
#; : Run in library mode (i.e. caller is a library function).
#;
#; `S` \[in]
#;
#; : Run in standalone mode (i.e. caller is a wrapper script).
#;
#; `--help` \[in]
#;
#; : _Only accepted in standalone mode._
#; : Display the help text for the standalone command, and
#;   exit.
#;
#; `--version` \[in]
#;
#; : _Only accepted in standalone mode._
#; : Display the version text for the standalone command,
#;   and exit.
#;
#; _For all other arguments see [`path_mktemp`](#path_mktemp)._
#;
#; _NOTES_
#; <!-- -->
#;
#; - See [`path_mktemp`](#path_mktemp) for full documentation.
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - A side effect of how documentation is generated for the library makes it
#.   difficult to have documentation for both this command and the commands it
#.   is used to implement in the most useful location without duplicating it.
#. - Arguments are **always** processed by `path_mktemp` before being used with
#.   the appropriate command to generate the final path. This has a number of
#.   advantages: behavior is standard regardless of system, including the
#.   errors generated by incorrect usage; and the correct tool to use can be
#.   more easily determined. Unfortunately, this creates some inefficiencies
#.   that could otherwise be avoided, however these are limited and not likely
#.   of import.
#. - Processing the large number of argument combinations efficiently is
#.   challenging. The result is an order of processing that can seem a little
#.   odd, but is often necessary in order to be able to deal with all the
#.   possibilities while combining those that can be (for performance). In
#.   particular, error detection is often postponed till later than would
#.   otherwise be done.
#.
#_______________________________________________________________________________
fn_bs_libpath_mktemp() { ## cSpell:Ignore BS_LP_MT_
  BS_LP_MT_Mode=${1:?'[libpath::fn_bs_libpath_mktemp]: Internal Error: a mode is required'}
  shift

  #=========================================================
  # Detect if being run in "Standalone Mode"
  #=========================================================
  case ${BS_LP_MT_Mode:?} in
  'S')  BS_LP_MT_StandaloneMode=1; BS_LP_MT_Caller='mktmp'       ;;
  'L')  BS_LP_MT_StandaloneMode=0; BS_LP_MT_Caller='path_mktemp' ;;
    *)  BS_LIBPATH__ConfigError=;
        : "${BS_LIBPATH__ConfigError:?'[libpath]: Internal Error: unexpected value for BS_LP_MT_Mode.'}" ;;
  esac

  #=========================================================
  # Initialize variables
  #=========================================================
  BS_LP_MT_refTarget=; BS_LP_MT_Template=;
  BS_LP_MT_Location=;  BS_LP_MT_Suffix=;
  unset 'BS_LP_MT_refTarget' 'BS_LP_MT_Template' \
        'BS_LP_MT_Location'  'BS_LP_MT_Suffix'

  BS_LP_MT_TemplateIsLeaf=;  BS_LP_MT_DirMode=;
  BS_LP_MT_NoCreate=;        BS_LP_MT_Quiet=;

  #=========================================================
  # Process arguments
  #=========================================================
  while : #< [ $# -gt 0 ]
  do
    #> LOOP TEST --------------
    case $# in 0) break ;; esac  #< [ $# -gt 0 ]
    #> ------------------------

    case ${BS_LP_MT_StandaloneMode}:$1 in
      #.....................................................
      # HELP
      1:'--help') fn_bs_libpath_mktemp_display_help; return ;;

      #.....................................................
      # VERSION
      1:'--version') printf "%s\n" "${BS_LIBPATH_VERSION}"; return ;;

      #.....................................................
      # Target
      0:'--target='*|0:'--output='*)
        BS_LP_MT_refTarget=${1#*=}
        shift
      ;;

      0:'--target'|0:'--output')
        case ${2:+1} in
        1)  BS_LP_MT_refTarget=$2; shift; shift ;;
        0)  fn_bs_libpath_invalid_args  \
              "${BS_LP_MT_Caller}"         \
              "a value is required with '$1'"
            return "${c_BS_LIBPATH__EX_USAGE}" ;;
        esac
      ;;

      #.....................................................
      # SWITCH OPTIONS
      ?:'--quiet'    )    BS_LP_MT_Quiet=1; shift ;;        # also `-q`
      ?:'--directory')  BS_LP_MT_DirMode=1; shift ;;        # also `-d`
      ?:'--dry-run'  ) BS_LP_MT_NoCreate=1; shift ;;        # also `-u`

      #.....................................................
      # TMPDIR                                              # also `-p`
      #
      # NOTE: Empty directory permitted.
      ?:'--tmpdir='*|?:'--tmpdir')
        BS_LP_MT_Location=${1#--tmpdir}
        BS_LP_MT_Location=${BS_LP_MT_Location#=}
        BS_LP_MT_Location=${BS_LP_MT_Location:-${TMPDIR:-/tmp}}
        shift
      ;;

      #.....................................................
      # SUFFIX
      #
      # NOTE: Empty suffix permitted.
      ?:'--suffix='*)
        BS_LP_MT_Suffix=${1#*=}
        shift
      ;;

      ?:'--suffix')
        case ${2:+1} in
        1)  BS_LP_MT_Suffix=$2; shift; shift ;;
        0)  fn_bs_libpath_invalid_args  \
              "${BS_LP_MT_Caller:?}"    \
              'a value is required with --suffix'
            return "${c_BS_LIBPATH__EX_USAGE}"  ;;
        esac
      ;;

      #.....................................................
      # Process single character options (which can also be
      # combined).
      #
      ## cSpell:Ignore dpqtu
      ?:-[dpqtu]*)
        BS_LP_MT_Option=${1#-}
        while : #< [ -n "${BS_LP_MT_Option}" ]
        do
          #> LOOP TEST -----------------
          #> LOOP TEST AT LOOP END
          #> ---------------------------

          case ${BS_LP_MT_Option} in
          d*)        BS_LP_MT_DirMode=1 ;;
          q*)          BS_LP_MT_Quiet=1 ;;
          t*) BS_LP_MT_TemplateIsLeaf=1 ;;
          u*)       BS_LP_MT_NoCreate=1 ;;

          p*) BS_LP_MT_Option=${BS_LP_MT_Option#?}
              case ${BS_LP_MT_Option:+1}:${2:+1} in
              1:*)  BS_LP_MT_Location=${BS_LP_MT_Option#=} ;;
               :1)  BS_LP_MT_Location=$2; shift ;;
                *)  fn_bs_libpath_invalid_args  \
                      "${BS_LP_MT_Caller}"      \
                      "a value is required with '-p'"
                    return "${c_BS_LIBPATH__EX_USAGE}" ;;
              esac
              break ;;

          *)  fn_bs_libpath_invalid_args \
                "${BS_LP_MT_Caller}"     \
                "unrecognized option '-${BS_LP_MT_Option}'"
              return "${c_BS_LIBPATH__EX_USAGE}" ;;
          esac

          BS_LP_MT_Option=${BS_LP_MT_Option#?}

          #> LOOP TEST -------------------------------------
          case ${BS_LP_MT_Option:+1} in 1) ;; *) break ;; esac #< [ -n "${BS_LP_MT_Option}" ]
          #> -----------------------------------------------
        done #<: `while [ -n "${BS_LP_MT_Option}" ]`
        shift ;;

      #---------------------------------
      ?:--) shift; break ;;
         *)        break ;;
    esac
  done #<: `while [ $# -gt 0 ]`

  #=========================================================
  # Determine the template: if none was specified, use any
  # operand if available, otherwise use the default.
  #
  # NOTES:
  #
  # - an empty/null template is permitted at this point,
  #   and will be dealt with appropriately later
  # - if template is already set, any operands are an error
  #=========================================================
  case $#:${BS_LP_MT_Template+1} in
  0:1)  ;;
  0: )  : "${BS_LP_MT_Location:=${TMPDIR:-/tmp}}"
        BS_LP_MT_Template='tmp.XXXXXXXXXX' ;;
  1: )  BS_LP_MT_Template=$1 ;;
    *)  fn_bs_libpath_invalid_args \
          "${BS_LP_MT_Caller}"      \
          'unrecognized arguments:' "$@"
        return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac

  # Keep a copy of the input template for later error
  # messages (the template itself may be edited).
  BS_LP_MT_TemplateSrc=${BS_LP_MT_Template}

  #=========================================================
  # Verify or initialize the target variable
  #=========================================================
  case ${BS_LP_MT_refTarget+1} in
  1)  fn_bs_libpath_validate_name_hyphen \
        "${BS_LP_MT_Caller}"             \
        "${BS_LP_MT_refTarget}"          || return $? ;;
  *)  BS_LP_MT_refTarget='-'
  esac

  #=========================================================
  # Verify any suffix
  #=========================================================
  case ${BS_LP_MT_Suffix:+1}:${BS_LP_MT_Suffix-} in
  1:*/*)  fn_bs_libpath_invalid_args \
            "${BS_LP_MT_Caller}"     \
            "suffix ('${BS_LP_MT_Suffix}') must not contain any '/' characters"
          return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac

  #=========================================================
  # Process the "location", i.e. the directory in which the
  # temporary item will be created. It is an error if:
  #
  # - `-t` is specified and the template contains
  #   directory components
  # - a location is specified _and_ the template is an
  #   absolute path (i.e. starts with a `/`)
  #
  # Assuming no error, the location and the template are
  # combined into a single path and the location and
  # template are set as if:
  #     `location=$(dirname <combined>)`
  #     `template=$(basename <combined>)`
  # Doing this makes later processing of the template easier
  # as it avoids problems where the path also contains
  # multiple X characters.
  #=========================================================
  case ${BS_LP_MT_Location+L}:${BS_LP_MT_TemplateIsLeaf:-0}:${BS_LP_MT_Template-} in
    #.......................................................
    # Error: trailing `/` in template
    #
    # NOTE: Technically this could be allowable, but GNU
    #       `mktemp` disallows it, and it would fail for
    #       files anyway, so just disallow it.
    */)
      fn_bs_libpath_invalid_args \
        "${BS_LP_MT_Caller}"     \
        "template ('${BS_LP_MT_Template}') must not end with '/'"
      return "${c_BS_LIBPATH__EX_USAGE}" ;;

    #.......................................................
    # Error: `-t` and template contains directories
    L:1:*/*|:1:*/*)
      fn_bs_libpath_invalid_args \
        "${BS_LP_MT_Caller}"     \
        "template ('${BS_LP_MT_Template}') must not contain any '/' characters if '-t' is also specified"
      return "${c_BS_LIBPATH__EX_USAGE}" ;;

    #.......................................................
    # Error: location specified with absolute path template
    L:?:/*)
      fn_bs_libpath_invalid_args \
        "${BS_LP_MT_Caller}"     \
        "template ('${BS_LP_MT_Template}') must not be an absolute path if a location is also specified"
      return "${c_BS_LIBPATH__EX_USAGE}" ;;

    #.......................................................
    # Location Specified or template contains directories
    # - move directory elements from template to location
    #
    # NOTE: Because a trailing `/` (`<slash>`) is not
    #       permitted on the template, the processing here
    #       can be done in the "naive" way without it
    #       causing issues. The resulting paths will be no
    #       "cleaner" than the input, but they will be
    #       correctly split into directory and basename
    #       portions.
    L:?:*/*|:?:*/*)
      BS_LP_MT_Location="${BS_LP_MT_Location%/}/${BS_LP_MT_Template%/*}"
      BS_LP_MT_Template=${BS_LP_MT_Template##*/} ;;
  esac #<: `case ${BS_LP_MT_Location+L}:${BS_LP_MT_TemplateIsLeaf}:${BS_LP_MT_Template} in`

  #=========================================================
  # GENERATE:
  # ---------
  #
  # If `mktemp` is available prefer to use it, otherwise do
  # things manually - some versions of `mktemp` do not
  # support a suffix parameter, similarly some versions
  # require the template X's to be at the end of the
  # template - in either case do things manually. (`mktemp`
  # from BSD has both these issues.)
  #=========================================================
  case ${c_BS_LIBPATH_CFG__mktemp_util}:${BS_LP_MT_Suffix:+1}:${BS_LP_MT_Template} in
    #...................................
    # USE `mktemp`
    #...................................
    gmktemp:*:*XXX*|mktemp::*XXX)
      BS_LP_MT_Path=$(
          mktemp                                                \
                ${BS_LP_MT_Quiet:+'-q'}                          \
              ${BS_LP_MT_DirMode:+'-d'}                          \
             ${BS_LP_MT_NoCreate:+'-u'}                          \
               ${BS_LP_MT_Suffix:+"--suffix=${BS_LP_MT_Suffix}"} \
             ${BS_LP_MT_Location:+"-p${BS_LP_MT_Location}"}      \
            "${BS_LP_MT_Template}"
        ) || return $?
    ;; #<: `gmktemp:*:*XXX*|mktemp::*XXX)`

    #...................................
    # EMULATE `mktemp`
    #...................................
    *:*:*XXX*)
      case ${BS_LP_MT_NoCreate:+1}:${BS_LP_MT_DirMode:+1} in
      1:*) BS_LP_MT_Cmd=fn_bs_libpath_mktemp_test ;;
       :1) BS_LP_MT_Cmd=fn_bs_libpath_mktemp_dir  ;;
       : ) BS_LP_MT_Cmd=fn_bs_libpath_mktemp_file ;;
      esac

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      fn_bs_libpath_dbg_msg  \
        "${BS_LP_MT_Caller}" \
        "Using emulated 'mktemp'"

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      # Note that error output is not
      # captured and will be output as
      # appropriate.
      BS_LP_MT_Path=$(
          fn_bs_libpath_mktemp_fallback \
            "${BS_LP_MT_Caller}"        \
            "${BS_LP_MT_Quiet:-0}"      \
            "${BS_LP_MT_Cmd}"           \
            "${BS_LP_MT_Template}"      \
            "${BS_LP_MT_Location-}"     \
            "${BS_LP_MT_Suffix-}"
        ) || return $?
    ;; #<: `*:*:*XXX*)`

    #...................................
    # ERROR
    #...................................
    *)
      fn_bs_libpath_invalid_args \
        "${BS_LP_MT_Caller}"     \
        "template ('${BS_LP_MT_TemplateSrc}') must contain at least 3 consecutive 'X's in last component"
      return "${c_BS_LIBPATH__EX_USAGE}"
    ;; #<: `*)`
  esac #<: `case ${c_BS_LIBPATH_CFG__mktemp_util} in`

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LP_MT_refTarget} in
  -) printf '%s\n' "${BS_LP_MT_Path}" ;;
  *) eval "${BS_LP_MT_refTarget}=\${BS_LP_MT_Path}" ;;
  esac
} #<: `fn_bs_libpath_mktemp()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libpath_mktemp_display_help`
#;
#; Display help text for the standalone version of [`path_mktemp`].
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libpath_mktemp_display_help
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; NONE.
#;
#; _NOTES_
#; <!-- -->
#;
#_______________________________________________________________________________
fn_bs_libpath_mktemp_display_help() { ## cSpell:Ignore BS_LPMTDH_ SUFF
  cat <<EndOfUsageText
Usage: mktmp [OPTION]... [TEMPLATE]

Create a temporary file or directory, and print it's name.

If specified TEMPLATE must contain 3 or more consecutive "X" characters in the
last component (i.e. following any slash characters). If not specified the
default tmp.XXXXXXXXXX is used and the option --tmpdir is implied.

OPTIONS:

  -d,     --directory           Generate a directory path, not a file path.
  -u,     --dry-run             Only generate a path - do not create it.
  -q,     --quiet               Suppress errors from failures to create a path.
                                (Note that this is potentially unsafe.)
          --suffix=SUFF         Append SUFF to TEMPLATE. SUFF must not contain
                                any slash characters.
  -p DIR, --tmpdir[=DIR]        Use DIR as the location for TEMPLATE - TEMPLATE
                                must not start with a slash. If DIR is omitted,
                                TMPDIR is used if set, otherwise /tmp.
  -t                            TEMPLATE is a single path component located in
                                TMPDIR, a directory specified with -p, or in
                                /tmp. Forces TEMPLATE to contain no slash
                                characters.
          --help                Display this text and exit.
          --version             Write the library version number to STDOUT and
                                exit.

mktmp is a drop in replacement for the commonly available mktemp command -
implementations of which vary in functionality, while mktmp is written entirely
as a POSIX.1 compliant shell script and provides identical behavior across
systems.

Although POSIX compliant, mktmp uses the non-POSIX specified /dev/urandom to
provide random data whenever possible, if this is not available the safety of
the mktmp may be diminished.

For more details see mktemp(1), mktmp(1), libpath(7), shtoolkit(7).
EndOfUsageText
} #<: `fn_bs_libpath_mktemp_display_help()`

#===============================================================================
#===============================================================================
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## COMMANDS
#:
#===============================================================================
#===============================================================================

#===============================================================================
#===============================================================================
#  PATH PARSING
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_basename`
#:
#: Set a variable to the value from `basename` for a specified path, without
#: potentially losing data if the path ends `<newline>` characters.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_basename <VARIABLE> [--] <PATH> [<SUFFIX>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `VARIABLE` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#:
#: `PATH` \[in]
#:
#: : Path to process.
#:
#: `SUFFIX` \[in]
#:
#: : Suffix to remove.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     path_basename File -- "$0" ".sh"
#:
#: _NOTES_
#: <!-- -->
#:
#: - All arguments except the first are passed directly to `basename` -
#:   supported arguments and values are determined by the implementation of
#:   that utility; any non-standard options may be used.
#:
#_______________________________________________________________________________
path_basename() { ## cSpell:Ignore BS_LPB_
  #-------------------------------------
  # Arguments
  #-------------------------------------
  case $# in
  0|1)  fn_bs_libpath_expected \
          'path_basename'      \
          'an output variable' \
          'a path'             \
          'a suffix to remove (optional)'
        return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac

  BS_LPB_refBasename=$1
  shift

  #-------------------------------------
  # Validate
  #-------------------------------------
  fn_bs_libpath_validate_name \
    'path_basename'           \
    "${BS_LPB_refBasename}"   || return $?

  #-------------------------------------
  # Save
  #-------------------------------------
  BS_LPB_Basename=$(basename "$@" && echo '_') || return $?
  eval "${BS_LPB_refBasename}=\${BS_LPB_Basename%?_}"
} #<: `path_basename()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_dirname`
#:
#: Set a variable to the value from `dirname` for a specified path, without
#: potentially losing data if the path ends `<newline>` characters.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_dirname <VARIABLE> [--] <PATH>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `VARIABLE` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#:
#: `PATH` \[in]
#:
#: : Path to process.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     path_dirname Dir -- "$0"
#:
#: _NOTES_
#: <!-- -->
#:
#: - All arguments except the first are passed directly to `dirname` -
#:   supported arguments and values are determined by the implementation of
#:   that utility; any non-standard options may be used.
#:
#_______________________________________________________________________________
path_dirname() { ## cSpell:Ignore BS_LPD_
  #-------------------------------------
  # Arguments
  #-------------------------------------
  case $# in
  0|1)  fn_bs_libpath_expected \
          'path_dirname'       \
          'an output variable' \
          'a path'
        return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac

  BS_LPD_refDirname=$1
  shift

  #-------------------------------------
  # Validate
  #-------------------------------------
  fn_bs_libpath_validate_name \
    'path_dirname'            \
    "${BS_LPD_refDirname}"    || return $?

  #-------------------------------------
  # Save
  #-------------------------------------
  BS_LPD_Dirname=$(dirname "$@" && echo '_') || return $?
  eval "${BS_LPD_refDirname}=\${BS_LPD_Dirname%?_}"
} #<: `path_dirname()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_pwd`
#:
#: Set a variable to the value from `pwd`, without potentially losing data if
#: the path ends `<newline>` characters.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_pwd <VARIABLE> [<OPTIONS>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `VARIABLE` \[out:ref]
#:
#: : Variable that will contain the output.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     path_pwd CurrentDir
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - The output from `pwd` is defined in the standard in terms of the
#:   environment variable `PWD` (i.e. `pwd` is supposed to return the value
#:   stored in `PWD`). However, the value contained in `PWD` can be modified
#:   directly by scripts and so _may_ not actually contain the current path.
#:   (What occurs when assigning to `PWD` is implementation defined.) If  `PWD`
#:   is not the current directory, the output of `pwd` is _not_ specified by
#:   the standard, however, most implementations seem to do something sensible.
#:
#: _NOTES_
#: <!-- -->
#:
#: - Any arguments after the first are passed directly to `pwd` -
#:   supported arguments and values are determined by the implementation of
#:   that utility; any non-standard options may be used.
#: - Standard `pwd` supports `-L` and `-P` options, with no option being
#:   equivalent to `-L`.
#:
#_______________________________________________________________________________
path_pwd() { ## cSpell:Ignore BS_LPPWD_
  #-------------------------------------
  # Arguments
  #-------------------------------------
  case $# in
  0)  fn_bs_libpath_expected \
        'path_pwd'           \
        'an output variable'
      return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac

  BS_LPPWD_refPWD=$1
  shift

  #-------------------------------------
  # Validate
  #-------------------------------------
  fn_bs_libpath_validate_name \
    'path_pwd'                \
    "${BS_LPPWD_refPWD}"      || return $?

  #-------------------------------------
  #
  #-------------------------------------
  BS_LPPWD_PWD=$(pwd ${1+"$@"} && echo '_') || return $?
  eval "${BS_LPPWD_refPWD}=\${BS_LPPWD_PWD%?_}"
} #<: `path_pwd()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_serial`
#:
#: Get the serial for the given path.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_serial [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-L`, `--dereference`, `--follow-links` \[in]
#:
#: : If `PATH` is a symbolic link, get the information for
#:   the link target.
#: : If not specified, the information will be for the
#:   symbolic link itself.
#: : If the symbolic link is broken or inaccessible, using
#:   this option will result in an error.
#: : Must be specified before any other arguments.
#:
#: `VARIABLE` \[out:ref]
#:
#: : Variable that will contain the serial.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   serial is written to `STDOUT`.
#:
#: `PATH` \[in]
#:
#: : `PATH` to get a serial for.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Serial=$(path_serial "$File")
#:     path_serial 'Serial' "$File"
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - A ["File Serial Number"][posix_file_serial_num] is defined as: _"A per-file
#:   system unique identifier for a file."_ and can **not** uniquely identify a
#:   file for an entire system.
#:
#: _NOTES_
#: <!-- -->
#:
#: - The serial will be an unsigned integer, but has an "implementation defined"
#:   size.
#: - The value reported here is the only value guaranteed to be available in a
#:   _POSIX.1_ shell. The commonly available `stat` command is able to provide
#:   much more useful (and accurate) information, but is not standard, and
#:   varies in usage between implementations.
#:
#_______________________________________________________________________________
path_serial() { ## cSpell:Ignore BS_LPSerial_
  #=========================================================
  # Arguments
  #=========================================================

  #---------------------------------------------------------
  # Options must be first
  #---------------------------------------------------------
  BS_LPSerial_Dereference=;
  while :
  do
    case ${1-} in
    '-L'|'--dereference'|'--follow-links')
      BS_LPSerial_Dereference=1
      shift ;;

    '--') shift; break ;;

       *) break ;;
    esac #<: `case ${1-} in`
  done

  #---------------------------------------------------------
  # Other arguments follow
  #---------------------------------------------------------
  case $# in
  1)  BS_LPSerial_refSerial='-'
           BS_LPSerial_Path=$1 ;;
  2)  BS_LPSerial_refSerial=$1
           BS_LPSerial_Path=$2
      fn_bs_libpath_validate_name_hyphen \
        'path_serial'                    \
        "${BS_LPSerial_refSerial}"       || return $? ;;
  *)  fn_bs_libpath_expected                                    \
        'path_serial'                                           \
        'the option -L|--dereference|--follow-links (optional)' \
        'a variable to receive the serial (optional)'           \
        'a path'
      return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # `ls` options:
  #
  # `-d`
  #
  # : "Do not follow symbolic links named as operands unless
  #    the -H or -L options are specified."
  # : "Do not treat directories differently than other types
  #    of files."
  # : (Lists directory information rather instead of the
  #   contents.)
  #
  # `-q`
  #
  # : "Force each instance of non-printable filename
  #    characters and <tab> characters to be written as the
  #    <question-mark> ( '?' ) character."
  #
  # `-1`
  #
  # : "Force output to be one entry per line."
  #
  # `-L`
  #
  # : "Evaluate the file information and file type for all
  #    symbolic links (whether named on the command line or
  #    encountered in a file hierarchy) to be those of the
  #    file referenced by the link, and not the link itself;
  #    however, `ls` shall write the name of the link itself
  #    and not the file referenced by the link."
  # : "When -L is used with -l, write the contents of
  #    symbolic links in the long format."
  #
  # `-i`
  #
  # : "For each file, write the file's file serial number."
  # : "If the -i option is specified, the file's file serial
  #    number shall be written in the following format
  #    before any other output for the corresponding entry:""
  #
  #     "%u ", <file serial number>
  #
  #=========================================================
  BS_LPSerial_Serial=$(
      ls  -d -1 -i                           \
          ${c_BS_LIBPATH_CFG__have_ls_q:+-q} \
          ${BS_LPSerial_Dereference:+-L}     \
          --                                 \
          "${BS_LPSerial_Path}"
    ) || return $?

  # Format: "<SERIAL> ..."
  #
  # NOTE: Some implementations are not totally standards
  #       compliant (e.g. `busybox`^) - the need to trim
  #       and the use of `[ 	]` are technically not
  #       required for a standard compliant implementation.
  #
  #       ^(`busybox` aligns output using multiple spaces.)
  case ${BS_LPSerial_Serial} in
  ' '*)
    BS_LPSerial_Prefix=${BS_LPSerial_Serial%%[! 	]*}
    BS_LPSerial_Serial=${BS_LPSerial_Serial#"${BS_LPSerial_Prefix}"}
  ;;
  esac

  BS_LPSerial_Serial=${BS_LPSerial_Serial%%[ 	]*}

  #=========================================================
  # Validate:- _POSIX.1_ defines a file serial number as
  #            being a unsigned integer.
  #=========================================================
  case ${BS_LPSerial_Serial} in
  *[!0123456789]*|'')
    fn_bs_libpath_error \
      'path_serial'     \
      "invalid/unrecognized serial '${BS_LPSerial_Serial}' for '${BS_LPSerial_Path}'"
    return "${c_BS_LIBPATH__EX_NOINPUT}" ;;
  esac

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LPSerial_refSerial} in
  -) printf '%s\n' "${BS_LPSerial_Serial}"                  ;;
  *) eval "${BS_LPSerial_refSerial}=\${BS_LPSerial_Serial}" ;;
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_size`
#:
#: Get the size of given file.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_size [-L|--dereference|--follow-links] [--] [<VARIABLE>] <PATH>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-L`, `--dereference`, `--follow-links` \[in]
#:
#: : If `PATH` is a symbolic link, get the information for
#:   the link target.
#: : If not specified, the information will be for the
#:   symbolic link itself.
#: : If the symbolic link is broken or inaccessible, using
#:   this option will result in an error.
#: : Must be specified before any other arguments.
#:
#: `VARIABLE` \[out:ref]
#:
#: : Variable that will contain the size.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   size is written to `STDOUT`.
#:
#: `PATH` \[in]
#:
#: : `PATH` to get a size for.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Size=$(path_size -L "$File")
#:     path_size 'Size' "$File"
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - If `PATH` is not an ordinary file (e.g. a character special or block
#:   special file), the results are "implementation defined" and so
#:   non-portable.
#: - Size is reported as **the number of 1024 byte blocks consumed by the file**
#:   i.e. the file size will be rounded up to the nearest 1024 bytes.
#: - For some file systems or implementations, the number of blocks consumed may
#:   not match the true file size (e.g. a file system that utilizes compression
#:   may report a value significantly smaller than the size of the uncompressed
#:   data).
#: - Files of size zero bytes _may_ give non-zero output depending on both the
#:   implementation of `ls` _and_ the underlying file system.
#:
#: _NOTES_
#: <!-- -->
#:
#: - The value reported here is the only value guaranteed to be available in a
#:   _POSIX.1_ shell. The commonly available `stat` command is able to provide
#:   much more useful (and accurate) information, but is not standard, and
#:   varies in usage between implementations.
#:
#_______________________________________________________________________________
path_size() { ## cSpell:Ignore BS_LPSize_
  #=========================================================
  # Arguments
  #=========================================================

  #---------------------------------------------------------
  # Options must be first
  #---------------------------------------------------------
  BS_LPSize_Dereference=;
  while :
  do
    case ${1-} in
    '-L'|'--dereference'|'--follow-links')
      BS_LPSize_Dereference=1
      shift ;;

    '--') shift; break ;;

       *) break ;;
    esac #<: `case ${1-} in`
  done

  #---------------------------------------------------------
  # Other arguments follow
  #---------------------------------------------------------
  case $# in
  1)  BS_LPSize_refSize='-'
         BS_LPSize_Path=$1 ;;
  2)  BS_LPSize_refSize=$1
         BS_LPSize_Path=$2
      fn_bs_libpath_validate_name_hyphen \
        'path_size'                      \
        "${BS_LPSize_refSize}"           || return $? ;;
  *)  fn_bs_libpath_expected                                 \
        'path_size'                                          \
        'options -L|--dereference|--follow-links (optional)' \
        'a variable to receive the size (optional)'          \
        'a path'
      return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  # `ls` options:
  #
  # `-d`
  #
  # : "Do not follow symbolic links named as operands unless
  #    the -H or -L options are specified."
  # : "Do not treat directories differently than other types
  #    of files."
  # : (Lists directory information rather instead of the
  #   contents.)
  #
  # `-q`
  #
  # : "Force each instance of non-printable filename
  #    characters and <tab> characters to be written as the
  #    <question-mark> ( '?' ) character."
  #
  # `-1`
  #
  # : "Force output to be one entry per line."
  #
  # `-L`
  #
  # : "Evaluate the file information and file type for all
  #    symbolic links (whether named on the command line or
  #    encountered in a file hierarchy) to be those of the
  #    file referenced by the link, and not the link itself;
  #    however, `ls` shall write the name of the link itself
  #    and not the file referenced by the link."
  # : "When -L is used with -l, write the contents of
  #    symbolic links in the long format."
  #
  # `-s`
  #
  # : "Indicate the total number of file system blocks
  #    consumed by each file displayed."
  # : "If the -k option is also specified, the block size
  #    shall be 1024 bytes; otherwise, the block size is
  #    implementation-defined."
  # : "If the -s option is given, each file shall be written
  #    with the number of blocks used by the file. Along
  #    with -C, -1, -m, or -x, the number and a `<space>`
  #    shall precede the filename; with -l, -n, -g, or -o,
  #    they shall precede each line describing a file."
  #
  # `-k`
  #
  # : "Set the block size for the -s option and the
  #    per-directory block count written for the -l, -n, -s,
  #    -g, and -o options to 1024 bytes."
  #
  #=========================================================
  BS_LPSize_Size=$(
      ls  -d -1 -s -k                        \
          ${c_BS_LIBPATH_CFG__have_ls_q:+-q} \
          ${BS_LPSize_Dereference:+-L}       \
          --                                 \
          "${BS_LPSize_Path}"
    ) || return $?

  # Format: "<SIZE> <FILE>"
  #
  # NOTE: Some implementations are not totally standards
  #       compliant (e.g. `busybox`^) - the need to trim
  #       and the use of `[ 	]` are technically not
  #       required for a standard compliant implementation.
  #
  #       ^(`busybox` aligns output using multiple spaces.)
  case ${BS_LPSize_Size} in
  ' '*)
    BS_LPSize_Prefix=${BS_LPSize_Size%%[! 	]*}
      BS_LPSize_Size=${BS_LPSize_Size#"${BS_LPSize_Prefix}"}
  ;;
  esac

  BS_LPSize_Size=${BS_LPSize_Size%%[ 	]*}

  #=========================================================
  # Size must be numerical
  #=========================================================
  case ${BS_LPSize_Size} in
  *[!0123456789]*|'')
    fn_bs_libpath_error \
      'path_size'       \
      "invalid/unrecognized size '${BS_LPSize_Size}' for '${BS_LPSize_Path}'"
    return "${c_BS_LIBPATH__EX_NOINPUT}" ;;
  esac

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LPSize_refSize} in
  -) printf '%s\n' "${BS_LPSize_Size}" ;;
  *) eval "${BS_LPSize_refSize}=\${BS_LPSize_Size}" ;;
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_owner`
#:
#: Get the owner of a given path in the form `<OWNER>:<GROUP>`.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_owner [-L|--dereference|--follow-links] [-n|--name] [--] [<VARIABLE>] <PATH>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-L`, `--dereference`, `--follow-links` \[in]
#:
#: : If `PATH` is a symbolic link, get the information for
#:   the link target.
#: : If not specified, the information will be for the
#:   symbolic link itself.
#: : If the symbolic link is broken or inaccessible, using
#:   this option will result in an error.
#: : Must be specified before non-option arguments.
#:
#: `-n`, `--name` \[in]
#:
#: : Report the owner and group in name format rather than
#:   numeric format.
#: : Must be specified before non-option arguments.
#:
#: `VARIABLE` \[out:ref]
#:
#: : Variable that will contain the owner.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   owner is written to `STDOUT`.
#:
#: `PATH` \[in]
#:
#: : `PATH` to get the owner for.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Owner=$(path_owner -Ln "$File")
#:     path_owner 'Owner' "$File"
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - The owner is reported as `<UID>:<GID>` where both IDs are numeric unless
#:   the name is explicitly requested, and a name for the given numeric ID can
#:   be obtained.
#:
#_______________________________________________________________________________
path_owner() { ## cSpell:Ignore BS_LPOwner_
  #=========================================================
  # Arguments
  #=========================================================

  #---------------------------------------------------------
  # Options must be first
  #---------------------------------------------------------
  BS_LPOwner_Name=0
  BS_LPOwner_Dereference=;
  while :
  do
    case ${1-} in
    '-L'|'--dereference'|'--follow-links')
      BS_LPOwner_Dereference=1
      shift ;;

    '-n'|'--name')
      BS_LPOwner_Name=1
      shift ;;

    '-nL'|'-Ln')
      BS_LPOwner_Dereference=1
      BS_LPOwner_Name=1
      shift ;;

    '--') shift; break ;;

       *) break ;;
    esac #<: `case ${1-} in`
  done

  #---------------------------------------------------------
  # Other arguments follow
  #---------------------------------------------------------
  case $# in
  1)  BS_LPOwner_refOwner='-'
          BS_LPOwner_Path=$1 ;;
  2)  BS_LPOwner_refOwner=$1
          BS_LPOwner_Path=$2
      fn_bs_libpath_validate_name_hyphen \
        'path_owner'                     \
        "${BS_LPOwner_refOwner}"         || return $? ;;
  *)  fn_bs_libpath_expected                                               \
        'path_owner'                                                       \
        'options: -L|--dereference|--follow-links or -n|--name (optional)' \
        'a variable to receive the owner (optional)'                       \
        'a path'
      return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  # `ls` options:
  #
  # `-d`
  #
  # : "Do not follow symbolic links named as operands unless
  #    the -H or -L options are specified."
  # : "Do not treat directories differently than other types
  #    of files."
  # : (Lists directory information rather instead of the
  #   contents.)
  #
  # `-q`
  #
  # : "Force each instance of non-printable filename
  #    characters and <tab> characters to be written as the
  #    <question-mark> ( '?' ) character."
  #
  # `-1`
  #
  # : "Force output to be one entry per line."
  #
  # `-L`
  #
  # : "Evaluate the file information and file type for all
  #    symbolic links (whether named on the command line or
  #    encountered in a file hierarchy) to be those of the
  #    file referenced by the link, and not the link itself;
  #    however, `ls` shall write the name of the link itself
  #    and not the file referenced by the link."
  # : "When -L is used with -l, write the contents of
  #    symbolic links in the long format."
  #
  # `-l`
  #
  # : "Do not follow symbolic links named as operands unless
  #    the -H or -L options are specified."
  # : "Write out in long format."
  # : "Disable the -C, -m, and -x options."[^ls_c_m_x]
  #
  # `-n`
  #
  # : "Turn on the -l option, but when writing the file's
  #    owner or group, write the file's numeric UID or GID
  #    rather than the user or group name, respectively."
  # : "Disable the -C, -m, and -x options."[^ls_c_m_x]
  # : (Avoids any issues with user or group names that
  #    contain unexpected characters.)
  #
  # FORMAT:
  #   "%s %u %s %s %u %s %s\n"
  #   `<file mode>`, `<number of links>`, `<owner name>`,
  #   `<group name>`, `<size>`, `<date and time>`,
  #   `<pathname>`
  #=========================================================
  BS_LPOwner_Owner=$(
      ls  -d -1 -l -n                        \
          ${c_BS_LIBPATH_CFG__have_ls_q:+-q} \
          ${BS_LPOwner_Dereference:+-L}      \
          --                                 \
          "${BS_LPOwner_Path}"
    ) || return $?

  # Remove the trailing path (this stops the slow path below
  # being used when the path contains one of the patterns
  # tested for).
  BS_LPOwner_Owner=${BS_LPOwner_Owner%%"${BS_LPOwner_Path}"}

  # NOTE: Some implementations are not totally standards
  #       compliant (e.g. `busybox`^) - for these cases, use
  #       `sed`, which is more expensive, but more robust.
  #       For output that looks standard compliant, using
  #       parameter expansion should be all that is required
  #       and will be faster.
  #
  #       ^(`busybox` aligns output using multiple spaces.)
  case ${BS_LPOwner_Owner} in
    # For output that starts with a <space> character,
    # contains a `<tab>` character, or contains multiple
    # consecutive <space> characters use `sed` - these are
    # all technically non-standard.
    ' '*|*'	'*|*'  '*)
      BS_LPOwner_Owner=$(
          {
            printf '%s\n' "${BS_LPOwner_Owner}"
          } | {
            sed -e 's/^[ 	]*[^ 	]\{1,\}[ 	]\{1,\}[0123456789]\{1,\}[ 	]\{1,\}\([0123456789]\{1,\}\)[ 	]\{1,\}\([0123456789]\{1,\}\)[ 	]\{1,\}.*$/\1:\2/'
          }
        ) || return $?
      BS_LPOwner_OwnerID=${BS_LPOwner_Owner%:*}
      BS_LPOwner_GroupID=${BS_LPOwner_Owner#*:}
    ;;

    # Fast path if the value looks like the expected format
    *)
        # Remove `<file mode>`
        BS_LPOwner_Owner=${BS_LPOwner_Owner#* }
        # Remove `<number of links>`
        BS_LPOwner_Owner=${BS_LPOwner_Owner#* }
        # Get `<owner name>`
        BS_LPOwner_OwnerID=${BS_LPOwner_Owner%% *}
        # Remove `<owner name>`
        BS_LPOwner_Owner=${BS_LPOwner_Owner#* }
        # Get `<group name>`
        BS_LPOwner_GroupID=${BS_LPOwner_Owner%% *}
    ;;
  esac

  #=========================================================
  # Validate the information looks correct
  #=========================================================
  case ${BS_LPOwner_OwnerID}:${BS_LPOwner_GroupID} in
  *[!0123456789]*:*[!0123456789]*|*:|:*)
    fn_bs_libpath_error \
      'path_owner'      \
      "invalid/unrecognized ownership information '${BS_LPOwner_OwnerID}:${BS_LPOwner_GroupID}' for '${BS_LPOwner_Path}'"
    return "${c_BS_LIBPATH__EX_NOINPUT}" ;;
  esac

  #=========================================================
  # Convert numerical format to names if required
  #
  # NOTE: It would seem like this could be done by just
  #       omitting `-n` for `ls`, avoiding the extra steps
  #       here, however, the values permitted for user and
  #       group names vary by platform, making it difficult
  #       parse them in a robust, portable fashion. This
  #       way is easier and safer.
  #=========================================================
  case ${BS_LPOwner_Name:-0} in
    1)
      if BS_LPOwner_OwnerName=$(id -u -n "${BS_LPOwner_OwnerID}" 2>&1)
      then
        BS_LPOwner_OwnerID=${BS_LPOwner_OwnerName}
      fi
      if BS_LPOwner_GroupName=$(id -g -n "${BS_LPOwner_GroupID}" 2>&1)
      then
        BS_LPOwner_GroupID=${BS_LPOwner_GroupName}
      fi
    ;;
  esac

  BS_LPOwner_Owner="${BS_LPOwner_OwnerID}:${BS_LPOwner_GroupID}"

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LPOwner_refOwner} in
  -) printf '%s\n' "${BS_LPOwner_Owner}"                ;;
  *) eval "${BS_LPOwner_refOwner}=\${BS_LPOwner_Owner}" ;;
  esac
}

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_mode`
#:
#: Get the "mode" (i.e. the permissions) of a path (in _symbolic_ format).
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_mode [-L|--dereference|--follow-links] [-c|--chmod] [--] [<VARIABLE>] <PATH>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `-L`, `--dereference`, `--follow-links` \[in]
#:
#: : If `PATH` is a symbolic link, get the information for
#:   the link target.
#: : If not specified, the information will be for the
#:   symbolic link itself.
#: : If the symbolic link is broken or inaccessible, using
#:   this option will result in an error.
#: : Must be specified before non-option arguments.
#:
#: `-c`, `--chmod` \[in]
#:
#: : Convert the mode to the format:
#:   `u=<user mode>,g=<group mode>,o=<other mode>[,+t]`
#:   which is suitable for use with `chmod`.
#: : The resulting mode will be of variable length, without
#:   this option the mode is always exactly **9** characters.
#: : May fail with an error if non-standard mode characters
#:   are set for `PATH`.
#: : Must be specified before non-option arguments.
#:
#: `VARIABLE` \[out:ref]
#:
#: : Variable that will contain the mode.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   mode is written to `STDOUT`.
#:
#: `PATH` \[in]
#:
#: : A path to get the mode for.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     chmod "$(path_mode -Lc "$Reference")" "$Target"
#:     path_mode 'Mode' "$File"
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - How the mode is converted to `chmod` format is dependent on
#:   [`BS_LIBPATH_CONFIG_EXTENDED_FILE_MODE_FORMAT`](#bs_libpath_config_extended_file_mode_format),
#:   which will determine if non-standard mode characters result in errors.
#:
#: _NOTES_
#: <!-- -->
#:
#: - The resulting mode is _always_ in symbolic format as this is the only
#:   format that can be determined with standard defined tools. Converting this
#:   to octal format is relatively easy if required.
#: - Normally the mode output will be exactly **9** characters, while in `chmod`
#:   format it will be of variable length with a minimum of **8** characters,
#:   and a maximum of **22** characters when only using standard defined modes.
#: - Although variable in length, `chmod` format is often easier to test for
#:   specific mode values, for example, checking for the `x` mode in the
#:   default output requires checking for either `x` _or_ `s` for "user" and
#:   "group", and `x` _or_ `t` for "other", while in `chmod` format the test is
#:   just for `x` in any of the three groups.
#: - The value reported here is the only value guaranteed to be available in a
#:   _POSIX.1_ shell. The commonly available `stat` command is able to provide
#:   much more useful (and accurate) information, but is not standard, and
#:   varies in usage between implementations.
#:
#_______________________________________________________________________________
path_mode() { ## cSpell:Ignore BS_LPMode_
  #=========================================================
  # Arguments
  #=========================================================

  #---------------------------------------------------------
  # Options must be first
  #---------------------------------------------------------
  BS_LPMode_Dereference=; BS_LPMode_chmod=;
  while :
  do
    case ${1-} in
    '-L'|'--dereference'|'--follow-links')
      BS_LPMode_Dereference=1
      shift ;;

    '-c'|'--chmod')
      BS_LPMode_chmod=1
      shift ;;

    '-cL'|'-Lc')
      BS_LPMode_Dereference=1
            BS_LPMode_chmod=1
      shift ;;

    '--') shift; break ;;

       *) break ;;
    esac #<: `case ${1-} in`
  done

  #---------------------------------------------------------
  # Other arguments follow
  #---------------------------------------------------------
  case $# in
  1)  BS_LPMode_refMode='-'
         BS_LPMode_Path=$1 ;;
  2)  BS_LPMode_refMode=$1
         BS_LPMode_Path=$2
      fn_bs_libpath_validate_name_hyphen \
        'path_mode'                      \
        "${BS_LPMode_refMode}"           || return $? ;;
  *)  fn_bs_libpath_expected                                              \
        'path_mode'                                                       \
        'options: -L|--dereference|--follow-links, -c|--chmod (optional)' \
        'a variable to receive the mode (optional)'                       \
        'a path'
      return "${c_BS_LIBPATH__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  #
  # `ls` options:
  #
  # `-d`
  #
  # : "Do not follow symbolic links named as operands unless
  #    the -H or -L options are specified."
  # : "Do not treat directories differently than other types
  #    of files."
  # : (Lists directory information rather instead of the
  #   contents.)
  #
  # `-q`
  #
  # : "Force each instance of non-printable filename
  #    characters and <tab> characters to be written as the
  #    <question-mark> ( '?' ) character."
  #
  # `-1`
  #
  # : "Force output to be one entry per line."
  #
  # `-L`
  #
  # : "Evaluate the file information and file type for all
  #    symbolic links (whether named on the command line or
  #    encountered in a file hierarchy) to be those of the
  #    file referenced by the link, and not the link itself;
  #    however, `ls` shall write the name of the link itself
  #    and not the file referenced by the link."
  # : "When -L is used with -l, write the contents of
  #    symbolic links in the long format."
  #
  # `-l`
  #
  # : "Do not follow symbolic links named as operands unless
  #    the -H or -L options are specified."
  # : "Write out in long format."
  # : "Disable the -C, -m, and -x options."[^ls_c_m_x]
  #
  # `-n`
  #
  # : "Turn on the -l option, but when writing the file's
  #    owner or group, write the file's numeric UID or GID
  #    rather than the user or group name, respectively."
  # : "Disable the -C, -m, and -x options."[^ls_c_m_x]
  # : (Avoids any issues with user or group names that
  #    contain unexpected characters.)
  #
  #=========================================================
  BS_LPMode_Mode=$(
      ls  -d -1 -l -n                        \
          ${c_BS_LIBPATH_CFG__have_ls_q:+-q} \
          ${BS_LPMode_Dereference:+-L}       \
          --                                 \
          "${BS_LPMode_Path}"
    ) || return $?

  #=========================================================
  # FORMAT:
  #   "%s %u %s %s %u %s %s\n"
  #   `<file mode>`, `<number of links>`, `<owner name>`,
  #   `<group name>`, `<size>`, `<date and time>`,
  #   `<pathname>`
  #
  # where `<file mode>` is:
  #
  # > "%c%s%s%s%s", \<entry type>, \<owner permissions>,
  # > \<group permissions>, \<other permissions>,
  # > \<optional alternate access method flag>
  #
  #  -  The `<entry type>` describes the type of file
  #     (e.g. 'd' for directory) and may contain
  #     implementation specific values.
  #  -  The 3 permissions entries consist of exactly 3
  #     characters each, the first is either `r` or `-`, the
  #     second is either `w` or `-`, and the third is
  #     one of \[SsTtx-] or an implementation defined value
  #     such that uppercase characters are used for
  #     executable files, and lowercase for non-executable
  #     files.
  #  -  The final string is either empty or a single
  #     character the value of which is implementation
  #     dependent.
  #
  # In total either 10 or 11 characters are output for the
  # mode, which is followed by a space.
  #
  #=========================================================

  # NOTE: Some implementations are not totally standards
  #       compliant (e.g. `busybox`^) - the need to trim
  #       and the use of `[ 	]` are technically not
  #       required for a standard compliant implementation.
  #
  #       ^(`busybox` aligns output using multiple spaces.)
  case ${BS_LPMode_Mode} in
  ' '*|'	'*)
    BS_LPMode_Prefix=${BS_LPMode_Mode%%[! 	]*}
      BS_LPMode_Mode=${BS_LPMode_Mode#"${BS_LPMode_Prefix}"}
  ;;
  esac

  BS_LPMode_Mode=${BS_LPMode_Mode%%[ 	]*}

  case ${#BS_LPMode_Mode} in
  10) BS_LPMode_Mode=${BS_LPMode_Mode#?} ;;
  11) BS_LPMode_Mode=${BS_LPMode_Mode#?}
      BS_LPMode_Mode=${BS_LPMode_Mode%?} ;;
   *) fn_bs_libpath_error \
        'path_mode'       \
        "invalid/unrecognized mode information '${BS_LPMode_Mode}' for '${BS_LPMode_Path}'"
      return "${c_BS_LIBPATH__EX_NOINPUT}" ;;
  esac

  #=========================================================
  # Convert to a `chmod` compatible format:
  #=========================================================
  case ${BS_LPMode_chmod:-0} in
  1)  BS_LPMode_UsrMode=${BS_LPMode_Mode%??????}
      BS_LPMode_GrpMode=${BS_LPMode_Mode#???}
      BS_LPMode_GrpMode=${BS_LPMode_GrpMode%???}
      BS_LPMode_OthMode=${BS_LPMode_Mode#??????}

      BS_LPMode_Mode=$(
          fn_bs_libpath_file_mode_ls_to_chmod \
            'path_mode'                       \
            "u=${BS_LPMode_UsrMode},g=${BS_LPMode_GrpMode},o=${BS_LPMode_OthMode}"
        ) || return $? ;;
  0)  ;;
  esac

  #=========================================================
  # Save/Output
  #=========================================================
  case ${BS_LPMode_refMode} in
  -) printf '%s\n' "${BS_LPMode_Mode}"              ;;      #< OUTPUT
  *) eval "${BS_LPMode_refMode}=\${BS_LPMode_Mode}" ;;      #< SAVE
  esac
}
#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_mktemp`
#:
#: Create a temporary path.
#:
#: A drop in replacement for the `mktemp` command found on many systems, but
#: available even when `mktemp` is not and with system independent
#: functionality.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     path_mktemp
#:        [--target <VARIABLE>|--output <VARIABLE>]
#:        [-q|--quiet] [-d|--directory] [-u|--dry-run]
#:        [-p <DIRECTORY>|--tmpdir[=<DIRECTORY>]] [-t]
#:        [--suffix <SUFFIX>]
#:        [--]
#:        [<TEMPLATE>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `--target <VARIABLE>`, `--output <VARIABLE>` \[out:ref]
#:
#: : Variable that will receive the generated path.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   value is written to `STDOUT`.
#: : Current contents will be lost.
#:
#: `-q`, `--quiet` \[in]
#:
#: : Suppress any output while creating paths (even on error.)
#:
#: `-d`, `--directory` \[in]
#:
#: : Make a directory, not a file.
#:
#: `-u`, `--dry-run` \[in]
#:
#: : Do not create the path, just generate it.
#: : This is potentially unsafe.
#:
#: `-p <DIRECTORY>`, `--tmpdir[=<DIRECTORY>]` \[in]
#:
#: : The location to create the temporary item.
#: : If not specified `DIRECTORY` is set to `TMPDIR` if
#:   it is set, or `/tmp` otherwise.
#: : If specified `TEMPLATE` can _not_ be an absolute path
#:   (i.e. can not begin with `/` (`<slash>`)).
#:
#: `-t` \[in]
#:
#: : `TEMPLATE` is the final portion of a path _only_.
#: : If specified it is an error if `TEMPLATE` contains
#:   _any_ directory separators.
#: : Implies `--tmpdir`.
#:
#: `--suffix <SUFFIX>` \[in]
#:
#: : Append `SUFFIX` to the final temporary path.
#: : Can not contain any `/` (`<slash>`) characters.
#: : Note: Usage may mean `mktemp` can not be used to
#:   generate the final path.
#:
#: `TEMPLATE` \[in]
#:
#: : Template used to generate the temporary path.
#: : If not specified defaults to `tmp.XXXXXXXXXX` and
#:   `--tmpdir` is implied.
#: : Must contain a sequence of `X` characters of length 3
#:   or more in the _final_ path segment.
#: : Can contain directory separators.
#: : Valid values are modified by other arguments.
#: : Note: If the template does _not_ end in `XXX` may mean
#:  `mktemp` can not be used to generate the final path.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     path_mktemp -dup ~
#:     path_mktemp --tmpdir a.tmp.file.XXXXXXXX
#:
#: _CAVEATS_
#: <!--  -->
#:
#: - Invokes `umask 077` before any path is created. (This is in line with many
#:   `mktemp` implementations.)
#: - `path_mktemp` is subject to the same safety considerations as any
#:   implementation of `mktemp`.
#: - _Safe use of `path_mktemp` may not be possible for some use cases._ (This
#:   is also true of `mktemp`.)
#: - `path_mktemp` is implemented using either `mktemp`, `od`, `hexdump`, or
#:   `awk` depending on configuration and availability. (For `od` and `hexdump`
#:   `/dev/urandom` must also be present and readable.)
#: - When `/dev/urandom` is used for random data `path_mktemp` **may block**.
#:   Whether or not this happens is implementation and situation dependent -
#:   some implementations never block, others only early in the boot process,
#:   others will block whenever available entropy is too low (even though the
#:   point of `/dev/urandom` is meant to be to avoid this).
#: - When `awk` is used for random data `path_mktemp` **this not secure**.
#:   The random data generated is of poor quality, making the final path
#:   potentially guessable.
#: - Even if a `mktemp` command is present on a system, it may not support the
#:   options required to implement `path_mktemp` for specific option
#:   combinations and values. _In such cases `mktemp` will **not** be used_
#:   even if it is used in other cases.[^mktemp_limited]
#:
#:  [^mktemp_limited]: The BSD implementation of `mktemp`, for example, lacks
#:                     a `--suffix` option, it also behaves differently if
#:                     `<TEMPLATE>` does not end with `XXX` in that it uses
#:                     `<TEMPLATE>` _as is_ without injecting any random
#:                     characters.
#:
#: _NOTES_
#: <!-- -->
#:
#: - The configuration variables
#:   [`BS_LIBPATH_CONFIG_NO_MKTEMP`](#bs_libpath_config_no_mktemp),
#:   [`BS_LIBPATH_CONFIG_PREFER_HEXDUMP`](#bs_libpath_config_prefer_hexdump),
#:   and [`BS_LIBPATH_CONFIG_RANDOM_SOURCE`](#bs_libpath_config_random_source)
#:   help determine how `path_mktemp` operates.
#: - Although the `mktemp` command can be found on many systems, it is
#:   non-standard and varies in operation between implementations, `path_mktemp`
#:   provides identical functionality regardless of the system _even when_
#:   _`mktemp` is used to generate the final path_.
#: - Functionality is largely a match for [GNU `mktemp`][gnu_mktemp], however
#:   there are some cases where option values considered an error for
#:   `path_mktemp` are permitted by [GNU `mktemp`][gnu_mktemp] - this is a
#:   deliberate choice: while accepting these values would be feasible it would
#:   add complexity to an already complicated command and the GNU `mktemp`
#:   behavior seems somewhat odd, of questionable use, and does not seem
#:   consistent with other behavior.[^mktemp_suffix]
#: - To avoid an infinite loop, a hardcoded maximum number of attempts to
#:   generate a path is used (when `mktemp` is not used). (The maximum is
#:   `62^3`, i.e. `238328` - which represents the minimum number of available
#:   paths when using the minimum of 3 template characters represented in
#:   base-62.)
#:
#:  [^mktemp_suffix]: Of note, [GNU `mktemp`][gnu_mktemp] permits a trailing
#:                    `/` (`<slash>`) to appear in `--suffix` in some conditions
#:                    where `path_mktemp` does not.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - `path_mktemp` is implemented as a library function and also available as
#.   a standalone command. Both versions use the same code with minor variations
#.   as required for the different methods of invocation. In order to implement
#.   this easily and safely the internal command
#.   [`fn_bs_libpath_mktemp`](#fn_bs_libpath_mktemp) is used with the first
#.   argument indication the mode of operation.
#. - Both `path_mktemp` and `path_mktmp` could be written as aliases, but some
#.   shells (e.g. `bash`) don't expand aliases by default when not in
#.   "interactive" mode. It's easier just to use functions than try to deal with
#.   edge cases (although it _may_ come with some additional performance costs).
#.
#_______________________________________________________________________________
path_mktemp() { fn_bs_libpath_mktemp 'L' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `path_mktmp`
#:
#: An alias for [`path_mktemp`](#path_mktemp).
#:
#_______________________________________________________________________________
path_mktmp() { fn_bs_libpath_mktemp 'L' ${1+"$@"}; }

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
*a*) set +a; BS_LIBPATH_SOURCED=1; set -a ;;
  *)         BS_LIBPATH_SOURCED=1         ;;
esac

fn_bs_libpath_readonly 'BS_LIBPATH_SOURCED'

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
#: ## CAVEATS
#:
#: - The library attempts to account for differences between implementations
#:   (where known), however, it is not possible to do this for every case.
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
#: <!-- cSpell:Ignore coreutils -->
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: [markdown]:                  <https://daringfireball.net/projects/markdown/syntax>                                                "Markdown: Syntax \[daringfireball.net\]"
#: [commonmark]:                <https://commonmark.org/>                                                                            "CommonMark \[spec.commonmark.org\]"
#: [commonmark_spec]:           <https://spec.commonmark.org/current/>                                                               "CommonMark Spec (current) \[spec.commonmark.org\]"
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
#: <!-- ---------------------------- -->
#:
#: [posix_rand]:                <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/functions/rand.html>                   "POSIX: rand \[pubs.opengroup.org\]"
#: [posix_basename]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/basename.html>               "POSIX: basename \[pubs.opengroup.org\]"
#: [posix_dirname]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/dirname.html>                "POSIX: dirname \[pubs.opengroup.org\]"
#: [posix_file_serial_num]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_175>    "POSIX: File Serial Number \[pubs.opengroup.org\]"
#:
#: [gnu_coreutils]:             <https://www.gnu.org/software/coreutils/>                                                            "Coreutils \[gnu.org\]"
#:
#: [gnu_mktemp]:                <https://www.gnu.org/software/coreutils/manual/html_node/mktemp-invocation.html>                     "mktemp \[gnu.org\]"
#:
#: [freebsd_mktemp]:            <https://man.freebsd.org/cgi/man.cgi?mktemp(1)>                                                      "mktemp \[man.freebsd.org\]"
#: [openbsd_mktemp]:            <https://man.openbsd.org/mktemp.1>                                                                   "mktemp \[man.openbsd.org\]"
#:
################################################################################

################################################################################
################################################################################
# END
################################################################################
################################################################################
