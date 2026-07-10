#!/usr/bin/env false
# SPDX-License-Identifier: MPL-2.0
## cSpell:Ignore libmap shtoolkit
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libmap': Associative array emulation for POSIX.1 compliant  *#
#*                         shells.                                            *#
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

################################### LIBMAP ###################################
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
#% % libmap(7) BetterScripts libmap v1.0.0 | Associative array emulation for POSIX.1 shells.
#% % BetterScripts (better.scripts@proton.me)
#% % July 2026
#
#: <!-- #################################################################### -->
#: <!-- ############# THIS FILE WAS GENERATED FROM 'libmap.sh' ############# -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # `libmap.sh`
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## SYNOPSIS
#:
#: _Full synopsis, description, arguments, examples and other information is_
#: _documented with each individual command._
#:
#: [`map_new <MAP> --key|-k <KEY> --value|-v <VALUE>...`](#map_new)
#:
#: [`map_add <MAP> --key|-k <KEY> --value|-v <VALUE>...`](#map_add)
#:
#: [`map_set <MAP> --key|-k <KEY> --value|-v <VALUE>...`](#map_set)
#:
#: [`map_get <MAP> <KEY> [<OUTPUT>]`](#map_get)
#:
#: [`map_contains <MAP> <KEY>`](#map_contains)
#:
#: [`map_delete <MAP> <KEY>...`](#map_delete)
#:
#: [`map_size <MAP> [<OUTPUT>]`](#map_size)
#:
#: [`map_foreach <MAP> <COMMAND> [<ARGUMENT>...]`](#map_foreach)
#:
#: [`map_keys <MAP> [<OUTPUT>]`](#map_keys)
#:
#: [`map_values <MAP> [<OUTPUT>]`](#map_values)
#:
#: [`map_is_map <MAP>`](#map_is_map)
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## DESCRIPTION
#:
#: Provides commands to allow any _POSIX.1_ compliant shell to use emulated
#: associative arrays (aka a _map_, _hash_, _dictionary_, or _symbol table_).
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
case ${BS_LIBMAP_SOURCED:+1} in 1) return ;; esac

#===============================================================================
#===============================================================================
# DEFAULTS
#===============================================================================
#===============================================================================
: "${BS_LIBMAP_DEBUG:=${BS_DEBUG:-${DEBUG:-0}}}"
: "${BS_LIBMAP_CONFIG_DEBUG:=${BS_LIBMAP_DEBUG:-0}}"
: "${BS_LIBMAP_DEBUG_FD:=${BS_DEBUG_FD:-2}}"

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
#. ### `fn_bs_libmap_readonly`
#.
#. Wrapper round `readonly`.
#.
#. Required because in its default configuration Z Shell's `readonly` causes
#. problems (due to variable scoping).
#.
#. See [`BS_LIBMAP_CONFIG_NO_Z_SHELL_SETOPT`](#bs_libmap_config_no_z_shell_setopt)
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libmap_readonly <VAR>...
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
fn_bs_libmap_readonly() { ## cSpell:Ignore BS_LM_readonly_
  case ${c_BS_LIBMAP_CFG__use_zsh_setopt} in
  1) setopt 'LOCAL_OPTIONS' 'POSIX_BUILTINS' ;;
  esac
  readonly "$@" || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libmap_dbg_printf_to_fd`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      fn_bs_libmap_dbg_printf_to_fd <ARGS>...
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
#.   [`BS_LIBMAP_DEBUG_FD`](#bs_libmap_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libmap_dbg_printf_to_fd() { ## cSpell:Ignore BS_LM_DPTFD_
  # SC2059: Don't use variables in the printf format string.
  #         Use printf "..%s.." "$foo".
  # EXCEPT: This is a printf wrapper.
  # SC2086: Double quote to prevent globbing and word
  #+        splitting.
  # EXCEPT: Quoting changes the meaning (under POSIX rules
  #+        the descriptor will be considered a file)
  # shellcheck disable=SC2059,SC2086
  case ${BS_LIBMAP_DEBUG_FD:-2} in
  [123456789]) printf "$@" >&  ${BS_LIBMAP_DEBUG_FD}      ;;
         '&'*) printf "$@" >&  ${BS_LIBMAP_DEBUG_FD#'&'}  ;;
            *) printf "$@" >> "${BS_LIBMAP_DEBUG_FD#'>'}" ;;
  esac || true
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libmap_dbg_msg`
#.
#. Debug output command.
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.      fn_bs_libmap_dbg_msg <CALLER> <MESSAGE>...
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
#.   [`BS_LIBMAP_DEBUG_FD`](#bs_libmap_debug_fd).
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Avoids using `$*` since `IFS` may not be set appropriately.
#. - Written for simplicity and not performance.
#.
#_______________________________________________________________________________
fn_bs_libmap_dbg_msg() { ## cSpell:Ignore BS_LM_DM_
  case ${BS_LIBMAP_DEBUG:-0} in 0) return ;; esac

  BS_LM_DM_Caller=$1
  shift

  fn_bs_libmap_dbg_printf_to_fd                \
    "[libmap::${BS_LM_DM_Caller}]: DEBUG:%s\n" \
    "$(printf ' %s' "$@")"
}

#_______________________________________________________________________________
#. ---------------------------------------------------------
#.
#. ### `fn_bs_libmap_config_constant`
#.
#. Helper to set configuration variables and report the set value when in
#. debug mode.
#.
#. In non-debug mode, identical to
#. [`fn_bs_libmap_readonly`](#fn_bs_libmap_readonly).
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libmap_config_constant <VAR>...
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
#. - Output is in form `[libmap::config]: DEBUG: <NAME>: <VALUE>` where
#.   `NAME` is the constant name and `VALUE` its value.
#. - Output is written to the file descriptor stored in
#.   [`BS_LIBMAP_DEBUG_FD`](#bs_libmap_debug_fd).
#.
#_______________________________________________________________________________
fn_bs_libmap_config_constant() { ## cSpell:Ignore BS_LM_CFGCST_
  case ${BS_LIBMAP_CONFIG_DEBUG:-0} in
  0)  ;;
  *)  for BS_LM_CFGCST_Name
      do
        eval "BS_LM_CFGCST_Value=\${${BS_LM_CFGCST_Name}-}" || BS_LM_CFGCST_Value=;
        fn_bs_libmap_dbg_printf_to_fd              \
          "[libmap::config]: DEBUG: %s: %s\n"      \
          "${BS_LM_CFGCST_Name#c_BS_LIBMAP_CFG__}" \
          "${BS_LM_CFGCST_Value}"                  || true
      done ;;
  esac

  case ${c_BS_LIBMAP_CFG__use_zsh_setopt} in
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
#: #### `BS_LIBMAP_CONFIG_NO_Z_SHELL_SETOPT`
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
#. - See [`fn_bs_libmap_readonly`](#fn_bs_libmap_readonly).
#. - **MUST BE SET BEFORE FIRST CALL TO `fn_...readonly`**
#:
case ${BS_LIBMAP_CONFIG_NO_Z_SHELL_SETOPT:-${BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT:-A}} in
[AD]) case ${ZSH_VERSION:+1} in
      1) c_BS_LIBMAP_CFG__use_zsh_setopt=1 ;;
      *) c_BS_LIBMAP_CFG__use_zsh_setopt=0 ;;
      esac ;;
   0) c_BS_LIBMAP_CFG__use_zsh_setopt=0 ;;
   *) c_BS_LIBMAP_CFG__use_zsh_setopt=1 ;;
esac

fn_bs_libmap_config_constant 'c_BS_LIBMAP_CFG__use_zsh_setopt'

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
#: #### `BS_LIBMAP_VERSION_MAJOR`
#:
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_VERSION_MINOR`
#:
#: - Integer >= 0.
#: - Incremented for significant changes that do not
#:   break compatibility with previous versions.
#: - Reset to 0 when
#:   [`BS_LIBMAP_VERSION_MAJOR`](#bs_libmap_version_major)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_VERSION_PATCH`
#:
#: - Integer >= 0.
#: - Incremented for minor revisions or bugfixes.
#: - Reset to 0 when
#:   [`BS_LIBMAP_VERSION_MINOR`](#bs_libmap_version_minor)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_VERSION_RELEASE`
#:
#: - A string indicating a pre-release version, always
#:   null for full-release versions.
#: - Possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended).
#:
  BS_LIBMAP_VERSION_MAJOR=1
  BS_LIBMAP_VERSION_MINOR=0
  BS_LIBMAP_VERSION_PATCH=0
BS_LIBMAP_VERSION_RELEASE=;

fn_bs_libmap_readonly 'BS_LIBMAP_VERSION_MAJOR'   \
                      'BS_LIBMAP_VERSION_MINOR'   \
                      'BS_LIBMAP_VERSION_PATCH'   \
                      'BS_LIBMAP_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_VERSION_FULL`
#:
#: - Full version combining
#:   [`BS_LIBMAP_VERSION_MAJOR`](#bs_libmap_version_major),
#:   [`BS_LIBMAP_VERSION_MINOR`](#bs_libmap_version_minor),
#:   and [`BS_LIBMAP_VERSION_PATCH`](#bs_libmap_version_patch)
#:   as a single integer.
#: - Can be used in numerical comparisons
#: - Format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded).
#:
BS_LIBMAP_VERSION_FULL=$(( \
    ( (BS_LIBMAP_VERSION_MAJOR * 1000) + BS_LIBMAP_VERSION_MINOR ) * 1000 \
    + BS_LIBMAP_VERSION_PATCH \
  ))

fn_bs_libmap_readonly 'BS_LIBMAP_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_VERSION`
#:
#: - Full version combining
#:   [`BS_LIBMAP_VERSION_MAJOR`](#bs_libmap_version_major),
#:   [`BS_LIBMAP_VERSION_MINOR`](#bs_libmap_version_minor),
#:   [`BS_LIBMAP_VERSION_PATCH`](#bs_libmap_version_patch),
#:   and
#:   [`BS_LIBMAP_VERSION_RELEASE`](#bs_libmap_version_release)
#:   as a formatted string.
#: - Format: `BetterScripts 'libmap' vMAJOR.MINOR.PATCH[-RELEASE]`
#: - Derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#:
BS_LIBMAP_VERSION=$(
    printf "BetterScripts 'libmap' v%d.%d.%d%s\n" \
           "${BS_LIBMAP_VERSION_MAJOR}"           \
           "${BS_LIBMAP_VERSION_MINOR}"           \
           "${BS_LIBMAP_VERSION_PATCH}"           \
           "${BS_LIBMAP_VERSION_RELEASE:+-${BS_LIBMAP_VERSION_RELEASE}}"
  )

fn_bs_libmap_readonly 'BS_LIBMAP_VERSION'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_MAP_FORMAT_VERSION`
#:
#: - Version of the internal data format for a map.
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#: - Only a map with this version is supported for any
#:   command.
#:
BS_LIBMAP_MAP_FORMAT_VERSION=5

fn_bs_libmap_readonly 'BS_LIBMAP_MAP_FORMAT_VERSION'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_LAST_ERROR`
#:
#: - Stores the error message of the most recent error.
#: - ONLY valid immediately following a command for which
#:   the exit status is not `0` (`<zero>`).
#: - Available even when error output is suppressed.
#:
BS_LIBMAP_LAST_ERROR=; #< CLEAR ON SOURCING

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBMAP_SOURCED`
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
#: #### `BS_LIBMAP_CONFIG_QUIET_ERRORS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
#: - Type:     _FLAG_
#: - Class:    _VARIABLE_
#: - Default:  _OFF_
#: - \[Enable]/Disable library error message output.
#: - _OFF_: error messages will be written to `STDERR` as:
#:   `[libmap::<COMMAND>]: ERROR: <MESSAGE>`.
#: - _ON_: library error messages will be suppressed.
#: - The most recent error message is always available in
#:   [`BS_LIBMAP_LAST_ERROR`](#bs_libmap_last_error)
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
#: #### `BS_LIBMAP_CONFIG_FATAL_ERRORS`
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
#:   [`BS_LIBMAP_CONFIG_QUIET_ERRORS`](#bs_libmap_config_quiet_errors)).
#: - Both the library version of this option and the
#:   suite version can be modified between command
#:   invocations and will affect the next command.
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
#. #### `c_BS_LIBMAP__newline`
#.
#. - Literal `\n` (`<newline>`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_LIBMAP__newline='
'

fn_bs_libmap_readonly 'c_BS_LIBMAP__newline'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBMAP__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_LIBMAP__EX_DATAERR`
#.
#. - Exit code for use when user provided _BAD DATA_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
  c_BS_LIBMAP__EX_USAGE=64
c_BS_LIBMAP__EX_DATAERR=65

fn_bs_libmap_readonly 'c_BS_LIBMAP__EX_USAGE' \
                      'c_BS_LIBMAP__EX_DATAERR'

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
#; ### `fn_bs_libmap_error`
#;
#; Error reporting command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libmap_error <CALLER> <MESSAGE>...
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
#; - If [`BS_LIBMAP_CONFIG_QUIET_ERRORS`](#bs_libmap_config_quiet_errors)
#;   is _OFF_ a message in the format `[libmap::<COMMAND>]: ERROR: <MESSAGE>`
#;   is written to `STDERR`.
#; - If [`BS_LIBMAP_CONFIG_FATAL_ERRORS`](#bs_libmap_config_fatal_errors)
#;   is _ON_ then an "unset variable" shell exception will be triggered using
#;   the [`${parameter:?[word]}`][posix_param_expansion] parameter expansion,
#;   where `word` is set to the error message.
#; - [`BS_LIBMAP_LAST_ERROR`](#bs_libmap_last_error) will contain the
#;   `<MESSAGE>` without any additional prefix regardless of other settings.
#;
#_______________________________________________________________________________
fn_bs_libmap_error() { ## cSpell:Ignore BS_LME_
  BS_LME_Caller=${1:?'[libmap::fn_bs_libmap_error]: Internal Error: a command name is required'}

  BS_LIBMAP_LAST_ERROR=;
  case $# in
  1)  : "${2:?'[libmap::fn_bs_libmap_error]: Internal Error: an error message is required'}" ;;
  2)  BS_LIBMAP_LAST_ERROR=$2 ;;
  *)  shift
      # NOTE: unset `IFS` == default `IFS`
      #       null  `IFS` == null  `IFS`
      case ${IFS-' '} in
      ' '*) BS_LIBMAP_LAST_ERROR=$* ;;
         *) BS_LIBMAP_LAST_ERROR=$(printf '%s ' "$@")
            BS_LIBMAP_LAST_ERROR=${BS_LIBMAP_LAST_ERROR% } ;;
      esac ;; #<: `case ${IFS-' '} in`
  esac #<: `case $# in`

  # OUTPUT ERROR
  case ${BS_LIBMAP_CONFIG_QUIET_ERRORS:-${BETTER_SCRIPTS_CONFIG_QUIET_ERRORS:-0}} in
  0)  printf '[libmap::%s]: ERROR: %s\n' \
             "${BS_LME_Caller}"          \
             "${BS_LIBMAP_LAST_ERROR}"   >&2 ;;
  esac

  # ERROR EXCEPTION
  case ${BS_LIBMAP_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in
  0)  ;;
  *)  BS_LIBMAP__FatalError=;
      BS_LIBMAP__ErrorMessage="[libmap::${BS_LME_Caller}]: ERROR: ${BS_LIBMAP_LAST_ERROR}"
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
      1)  eval 'BS_LIBMAP__ErrorMessage=${(qq)BS_LIBMAP__ErrorMessage}'
          eval ": \"\${BS_LIBMAP__FatalError:?${BS_LIBMAP__ErrorMessage}}\"" ;;
      *) : "${BS_LIBMAP__FatalError:?${BS_LIBMAP__ErrorMessage}}" ;;
      esac ;;
  esac
} #<: `fn_bs_libmap_error()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libmap_invalid_args <CALLER> <MESSAGE>...
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
fn_bs_libmap_invalid_args() { ## cSpell:Ignore BS_LMIA_
  BS_LMIA_Caller=${1:?'[libmap::fn_bs_libmap_invalid_args]: Internal Error: a command name is required'}
  shift
  fn_bs_libmap_error "${BS_LMIA_Caller}" 'Invalid Arguments:' "$@"
} #<: `fn_bs_libmap_invalid_args()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap_expected`
#;
#; Helper for errors reporting incorrect number of arguments.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap_expected <CALLER> <EXPECTED>...
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
fn_bs_libmap_expected() { ## cSpell:Ignore BS_LMExpected_
  BS_LMExpected_Caller=${1:?'[libmap::fn_bs_libmap_expected]: Internal Error: a caller is required'}
  shift
  BS_LMExpected_Message=${1:?'[libmap::fn_bs_libmap_expected]: Internal Error: an expected argument is required'}
  shift

  #=========================================================
  #
  #=========================================================
  while : #<: `[ $# -gt 1 ]`
  do
    case $# in
    0)  break ;;
    1)  BS_LMExpected_Message="${BS_LMExpected_Message}, and $1"
        break ;;
    *)  BS_LMExpected_Message="${BS_LMExpected_Message}, $1"
        shift ;;
    esac
  done #<: `while [ $# -gt 1 ]`

  #=========================================================
  #
  #=========================================================
  fn_bs_libmap_error          \
    "${BS_LMExpected_Caller}" \
    "Invalid Arguments: expected ${BS_LMExpected_Message}"
} #<: `fn_bs_libmap_expected()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap_validate_name`
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
#;     fn_bs_libmap_validate_name <CALLER> <NAME>
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
fn_bs_libmap_validate_name() { ## cSpell:Ignore BS_LMVN_
  BS_LMVN_Caller=${1:?'[libmap::fn_bs_libmap_validate_name]: Internal Error: a command name is required'}
    BS_LMVN_Name=${2?'[libmap::fn_bs_libmap_validate_name]: Internal Error: a variable name is required'}

  case ${BS_LMVN_Name:-#} in
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libmap_invalid_args \
      "${BS_LMVN_Caller}"     \
      "invalid variable name '${BS_LMVN_Name}'"
    return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libmap_validate_name()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap_validate_name_hyphen`
#;
#; Similar to [`fn_bs_libmap_validate_name`](#fn_bs_libmap_validate_name)
#; but additionally allows the name to be `-` (`<hyphen>`), which implies
#; that `STDOUT` or `STDIN` should in place of the variable be used as
#; appropriate.
#;
#; See [`fn_bs_libmap_validate_name`](#fn_bs_libmap_validate_name) for more
#; details.
#;
#_______________________________________________________________________________
fn_bs_libmap_validate_name_hyphen() { ## cSpell:Ignore BS_LMVNH_
  BS_LMVNH_Caller=${1:?'[libmap::fn_bs_libmap_validate_name_hyphen]: Internal Error: a command name is required'}
    BS_LMVNH_Name=${2?'[libmap::fn_bs_libmap_validate_name_hyphen]: Internal Error: a variable name is required'}

  #---------------------------------------------------------
  # This command is called for many of the main commands.
  # To avoid an additional command call the test from
  # `fn_bs_libmap_validate_name` is duplicated here
  case ${BS_LMVNH_Name:-#} in
  -) : ;;
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libmap_invalid_args \
      "${BS_LMVNH_Caller}"      \
      "invalid variable name '${BS_LMVNH_Name}'"
    return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac
} #<: `fn_bs_libmap_validate_name_hyphen()`

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## GLOBALS
#.
#. To avoid the need for multiple `eval` expressions or replicating code that
#. processes the internal data structure of a map, much of the map processing
#. operates on global variables that are set on entry to a primary command.
#.
#===============================================================================
#===============================================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `g_BS_LIBMAP__map`
#.
#. - The current map data, _without_ the header.
#. - Initialized by
#.   [`fn_bs_libmap__g_map__load`](#fn_bs_libmap__g_map__reset),
#.   and
#.   [`fn_bs_libmap__g_map__load`](#fn_bs_libmap__g_map__load),
#.   one of which MUST be called before use.
#. - Use
#.   [`fn_bs_libmap__g_map__save`](#fn_bs_libmap__g_map__save)
#.   to save to a specified variable (with correct header).
#.
g_BS_LIBMAP__map=;
unset 'g_BS_LIBMAP__map'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `g_BS_LIBMAP__map__Count`
#.
#. - Count of map entries in
#.   [`g_BS_LIBMAP__map`](#g_BS_LIBMAP__map).
#. - Read from the header of the currently loaded map.
#.
#. ---------------------------------------------------------
#.
#. #### `g_BS_LIBMAP__map__DelIDs`
#.
#. - List of currently deleted IDs for the map in
#.   [`g_BS_LIBMAP__map`](#g_BS_LIBMAP__map).
#. - Read from the header of the currently loaded map.
#.
 g_BS_LIBMAP__map__Count=;
g_BS_LIBMAP__map__DelIDs=;
unset 'g_BS_LIBMAP__map__Count'  \
      'g_BS_LIBMAP__map__DelIDs'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `g_BS_LIBMAP__map__idx`
#.
#. - Contains the _index_ from the most recently looked-up
#.   map entry from
#.   [`g_BS_LIBMAP__map`](#g_BS_LIBMAP__map).
#. - Populated by
#.   [`fn_bs_libmap__g_map__lookup`](#fn_bs_libmap__g_map__lookup).
#. - Should NOT be assigned except via lookup or to reset
#.   the value.
#.
#. ---------------------------------------------------------
#.
#. #### `g_BS_LIBMAP__map__key`
#.
#. - Contains the _key_ from the most recently looked-up
#.   map entry from
#.   [`g_BS_LIBMAP__map`](#g_BS_LIBMAP__map).
#. - Populated by
#.   [`fn_bs_libmap__g_map__lookup`](#fn_bs_libmap__g_map__lookup).
#. - Should NOT be assigned except via lookup or to reset
#.   the value.
#.
#. ---------------------------------------------------------
#.
#. #### `g_BS_LIBMAP__map__val`
#.
#. - Contains the _value_ from the most recently looked-up
#.   map entry from
#.   [`g_BS_LIBMAP__map`](#g_BS_LIBMAP__map).
#. - Populated by
#.   [`fn_bs_libmap__g_map__lookup`](#fn_bs_libmap__g_map__lookup).
#. - Should NOT be assigned except via lookup or to reset
#.   the value.
#. - Will be explicitly unset for any hidden entries in the
#.   map.
#.
g_BS_LIBMAP__map__idx=;
g_BS_LIBMAP__map__key=;
g_BS_LIBMAP__map__val=;
unset 'g_BS_LIBMAP__map__idx' \
      'g_BS_LIBMAP__map__key' \
      'g_BS_LIBMAP__map__val'

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
#; ### `fn_bs_libmap_quote`
#;
#; Safely quote a value so it can be used in an `eval` command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap_quote <VALUE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE` \[in]
#;
#; : Value to quoted.
#; : Can be null.
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#; : MUST be a single value.
#;
#_______________________________________________________________________________
fn_bs_libmap_quote() { ## cSpell:Ignore BS_LMQ_
  BS_LMQ_String=${1?'[libmap::fn_bs_libmap_quote]: Internal Error: a string is required'}

  {
    printf '%s\n' "${BS_LMQ_String}"
  } | {
    # `sed` script:
    # - escape all `<apostrophe>` characters
    # - add a `<apostrophe>` character to the start
    #   of the value
    # - add a `<apostrophe>` to the end of the value
    #
    # NOTES:
    #
    # - the order here is important; the first action
    #   has to occur before either of the others!
    sed -e "s/'/'\\\\''/g
            1s/^/'/
            \$s/\$/'/"
  }
}

#===============================================================================
#===============================================================================
#; <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#;
#; ## INTERNAL HELPER COMMANDS: `g_map`
#;
#; Most map processing happens on library specific global variables, while this
#; is far from ideal, the alternatives are either repetition of code or to use
#; a large number of sub-shells and/or `eval` expressions. The former is not
#; easy to maintain, especially when the internal format of a map is so
#; specific, while the latter has significant performance implications.
#;
#; Using global variables for map processing _should_ be safe - it should not be
#; possible for these variables to be used simultaneously by different
#; processes (even those using the library at the same time should have
#; different copies of the variables).
#;
#; In most cases processing of the global variables occurs _only_ in the
#; commands in this section, however this is not universally true.
#;
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap__g_map__reset`
#;
#; Reset the global map variables.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap__g_map__reset <CALLER>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#_______________________________________________________________________________
fn_bs_libmap__g_map__reset() { ## cSpell:Ignore BS_LMgMR_
  BS_LMgMR_Caller=${1:?'[libmap::fn_bs_libmap__g_map__reset]: Internal Error: a command name is required'}

  g_BS_LIBMAP__map=;
  g_BS_LIBMAP__map__Count=0
  g_BS_LIBMAP__map__DelIDs=;

  g_BS_LIBMAP__map__idx=;
  g_BS_LIBMAP__map__key=;
  g_BS_LIBMAP__map__val=;
  unset 'g_BS_LIBMAP__map__val'
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap__g_map__load`
#;
#; Unpack a map and populate the relevant global variables.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap__g_map__load <CALLER> <MAP>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `MAP` \[in:ref]
#;
#; : Variable containing a map.
#; : MUST be a valid _POSIX.1_ name.
#; : Can reference an empty map or `unset` variable
#;   (a new map will be created).
#; : If specified as `-` (`<hyphen>`) map is written to
#;   `STDOUT`.
#;
#_______________________________________________________________________________
fn_bs_libmap__g_map__load() { ## cSpell:Ignore BS_LMgML_
  BS_LMgML_Caller=${1:?'[libmap::fn_bs_libmap__g_map__load]: Internal Error: a command name is required'}
  BS_LMgML_refMap=${2:?'[libmap::fn_bs_libmap__g_map__load]: Internal Error: a map variable is required'}

  #---------------------------------------------------------
  # Reset
  #---------------------------------------------------------
  fn_bs_libmap__g_map__reset "${BS_LMgML_Caller}"

  #---------------------------------------------------------
  # Unpack
  #---------------------------------------------------------
  case ${BS_LMgML_refMap} in
  -) ;; *) eval "g_BS_LIBMAP__map=\${${BS_LMgML_refMap}}" || return $? ;;
  esac

  #---------------------------------------------------------
  # Read Header:
  #
  #     #>HEADER
  #     #>VER:<VERSION>:REV<#           ## cSpell:Ignore REV
  #     #>NUM:<COUNT>:MUN<#             ## cSpell:Ignore MUN
  #     #>DEL:[,<INDEX>,...]:LED<#      ## cSpell:Ignore LED
  #     #<REDAEH                        ## cSpell:Ignore REDAEH
  #---------------------------------------------------------
  case ${g_BS_LIBMAP__map:+1} in
  1)  BS_LMgML_Header=${g_BS_LIBMAP__map%%?[#]"<REDAEH"*}
      BS_LMgML_Header=${BS_LMgML_Header#[#]">HEADER"?}

      case ${BS_LMgML_Header} in
      *"#>VER:${BS_LIBMAP_MAP_FORMAT_VERSION}:REV<#"*) ;;
      *)  fn_bs_libmap_invalid_args \
            "${BS_LMgML_Caller}"    \
            'invalid or outdated map format'
          return "${c_BS_LIBMAP__EX_DATAERR}";;
      esac

      g_BS_LIBMAP__map__Count=${BS_LMgML_Header#*[#]">NUM:"}
      g_BS_LIBMAP__map__Count=${g_BS_LIBMAP__map__Count%":MUN<"[#]*}

      g_BS_LIBMAP__map__DelIDs=${BS_LMgML_Header#*[#]">DEL:"}
      g_BS_LIBMAP__map__DelIDs=${g_BS_LIBMAP__map__DelIDs%":LED<"[#]*}

      g_BS_LIBMAP__map=${g_BS_LIBMAP__map#*[#]"<REDAEH"?} ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap__g_map__save`
#;
#; Save the current global map to the specified variable.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap__g_map__save <CALLER> <MAP>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `MAP` \[out:ref]
#;
#; : Variable to receive the map.
#; : MUST be a valid _POSIX.1_ name.
#; : Contents of specified variable will be lost.
#; : If specified as `-` (`<hyphen>`) map is written to
#;   `STDOUT`.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Does NOT reset the current global variables.
#;
#_______________________________________________________________________________
fn_bs_libmap__g_map__save() { ## cSpell:Ignore BS_LMgMS_
  BS_LMgMS_Caller=${1:?'[libmap::fn_bs_libmap__g_map__save]: Internal Error: a command name is required'}
  BS_LMgMS_refMap=${2:?'[libmap::fn_bs_libmap__g_map__save]: Internal Error: a map variable is required'}

  #---------------------------------------------------------
  # Write Header
  #---------------------------------------------------------
  g_BS_LIBMAP__map="#>HEADER
#>VER:${BS_LIBMAP_MAP_FORMAT_VERSION}:REV<#
#>NUM:${g_BS_LIBMAP__map__Count:-0}:MUN<#
#>DEL:${g_BS_LIBMAP__map__DelIDs}:LED<#
#<REDAEH
${g_BS_LIBMAP__map}"

  #---------------------------------------------------------
  # Save
  #---------------------------------------------------------
  case ${BS_LMgMS_refMap} in
  -) printf '%s\n' "${g_BS_LIBMAP__map}" ;;                 #< OUTPUT
  *) eval "${BS_LMgMS_refMap}=\${g_BS_LIBMAP__map}" ;;      #< SAVE
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap__g_map__lookup`
#;
#; Lookup a value in a map.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap__g_map__lookup <CALLER> <MAP> <MODE> <LOOKUP>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `MAP` \[in]
#;
#; : Map content to search - passed by value, e.g.
#;   `${g_BS_LIBMAP__map}`, NOT a variable name.
#;
#; `MODE` \[in]
#;
#; : The value `KEY` if `LOOKUP` is a key.
#; : The value `IDX` if `LOOKUP` is an index.
#; : Any other value will result in no match
#;   regardless of the value of `LOOKUP`.
#;
#; `LOOKUP` \[in]
#;
#; : Value to lookup.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Sets global variables to the values associated with `LOOKUP` if found,
#;   otherwise these will be null/unset as appropriate.
#; - Exit status will be `0` (`<zero>`) if `LOOKUP` was found; `1` (`<one>`) if
#;   `LOOKUP` was _not_ found.
#;
#_______________________________________________________________________________
fn_bs_libmap__g_map__lookup() { ## cSpell:Ignore BS_LMgML_
  BS_LMgML_Caller=${1:?'[libmap::fn_bs_libmap__g_map__lookup]: Internal Error: a command name is required'}
     BS_LMgML_Map=${2?'[libmap::fn_bs_libmap__g_map__lookup]: Internal Error: a map is required'}
    BS_LMgML_Mode=${3:?'[libmap::fn_bs_libmap__g_map__lookup]: Internal Error: a mode is required'}
  BS_LMgML_Lookup=${4:?'[libmap::fn_bs_libmap__g_map__lookup]: Internal Error: a lookup value is required'}

  eval '
    case ${BS_LMgML_Mode}:${BS_LMgML_Lookup} in
    '"${BS_LMgML_Map}"'
    *)  g_BS_LIBMAP__map__idx=; g_BS_LIBMAP__map__key=;
        g_BS_LIBMAP__map__val=; unset g_BS_LIBMAP__map__val;
        return 1 ;;
    esac
  '
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap__g_map__add`
#;
#; Add an entry to the current global map.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap__g_map__add <CALLER> <KEY> <VALUE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `KEY` \[in]
#;
#; : The key of the entry in the map.
#; : MUST be correctly quoted.
#; : MUST NOT be null.
#;
#; `VALUE` \[in]
#;
#; : The value of the entry in the map.
#; : MUST be correctly quoted.
#; : May be null.
#;
#_______________________________________________________________________________
fn_bs_libmap__g_map__add() { ## cSpell:Ignore BS_LMgMA_
  BS_LMgMA_Caller=${1:?'[libmap::fn_bs_libmap__g_map__add]: Internal Error: a command name is required'}
     BS_LMgMA_Key=${2:?'[libmap::fn_bs_libmap__g_map__add]: Internal Error: a map key is required'}
   BS_LMgMA_Value=${3?'[libmap::fn_bs_libmap__g_map__add]: Internal Error: a map value is required'}

  case ${g_BS_LIBMAP__map__DelIDs-} in
    *[0123456789]*)
      BS_LMgMA_Index=${g_BS_LIBMAP__map__DelIDs#,}
      BS_LMgMA_Index=${BS_LMgMA_Index%%,*}
      g_BS_LIBMAP__map__DelIDs=${g_BS_LIBMAP__map__DelIDs#",${BS_LMgMA_Index},"}
      case ${g_BS_LIBMAP__map__DelIDs:+1} in
      1) g_BS_LIBMAP__map__DelIDs=",${g_BS_LIBMAP__map__DelIDs}" ;;
      esac
    ;;

    *)
      BS_LMgMA_Index=${g_BS_LIBMAP__map__Count:-0}
    ;;
  esac

  g_BS_LIBMAP__map__Count=$(( g_BS_LIBMAP__map__Count  + 1 ))

  g_BS_LIBMAP__map="#> IDX:'${BS_LMgMA_Index}
KEY:${BS_LMgMA_Key}|IDX:${BS_LMgMA_Index})
  g_BS_LIBMAP__map__idx=${BS_LMgMA_Index};
  g_BS_LIBMAP__map__key=${BS_LMgMA_Key};
  g_BS_LIBMAP__map__val=${BS_LMgMA_Value};
;;
#< IDX:'${BS_LMgMA_Index}
${g_BS_LIBMAP__map}"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap__g_map__delete`
#;
#; Remove an entry from the current global map.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap__g_map__delete <CALLER> <INDEX>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `INDEX` \[in]
#;
#; : Index of the entry to delete.
#; : MUST be numeric.
#;
#; _NOTES_
#; <!-- -->
#;
#; - `INDEX` can be determined via map lookup for a specific key.
#; - It is NOT an error if `INDEX` does not exist in the current map.
#;
#_______________________________________________________________________________
fn_bs_libmap__g_map__delete() { ## cSpell:Ignore BS_LMgMD_
  BS_LMgMD_Caller=${1:?'[libmap::fn_bs_libmap__g_map__delete]: Internal Error: a command name is required'}
   BS_LMgMD_Index=${2:?'[libmap::fn_bs_libmap__g_map__delete]: Internal Error: a map index is required'}

  BS_LMgMD_Prefix=${g_BS_LIBMAP__map%%"#> IDX:'${BS_LMgMD_Index}${c_BS_LIBMAP__newline}"*}
  BS_LMgMD_Suffix=${g_BS_LIBMAP__map##*"${c_BS_LIBMAP__newline}#< IDX:'${BS_LMgMD_Index}${c_BS_LIBMAP__newline}"}

  g_BS_LIBMAP__map=${BS_LMgMD_Prefix}${BS_LMgMD_Suffix}

  g_BS_LIBMAP__map__DelIDs="${g_BS_LIBMAP__map__DelIDs%,},${BS_LMgMD_Index},"

  g_BS_LIBMAP__map__Count=$(( g_BS_LIBMAP__map__Count - 1 ))
}

#===============================================================================
#===============================================================================
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## INTERNAL HELPER COMMANDS: other
#.
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap_new_entry`
#;
#; Add an entry to the current global map.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap_new_entry <CALLER> <ENTRY>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `ENTRY` \[in]
#;
#; : A map entry in the form `KEY=VALUE`
#;
#_______________________________________________________________________________
fn_bs_libmap_new_entry() { ## cSpell:Ignore BS_LM_NE_
  BS_LM_NE_Caller=${1:?'[libmap::fn_bs_libmap_new_entry]: Internal Error: a command name is required'}
   BS_LM_NE_Entry=${2:?'[libmap::fn_bs_libmap_new_entry]: Internal Error: an entry is required'}

  #=========================================================
  # Unpack
  #=========================================================
  case ${BS_LM_NE_Entry} in
    *?=*)
        BS_LM_NE_Key=${BS_LM_NE_Entry%%=*}
      BS_LM_NE_Value=${BS_LM_NE_Entry#*=}
    ;; #<: `*=*)`

    *)
      fn_bs_libmap_invalid_args \
        "${BS_LM_NE_Caller}"    \
        "invalid format for map entry: ${BS_LM_NE_Entry}"
      return "${c_BS_LIBMAP__EX_USAGE}"
    ;; #<: `*)`
  esac #<: `case $1 in`

  #=========================================================
  # Quote
  #=========================================================
  case ${BS_LM_NE_Key} in
  *"'"*) BS_LM_NE_Key=$(fn_bs_libmap_quote "${BS_LM_NE_Key}") || return $? ;;
      *) BS_LM_NE_Key="'${BS_LM_NE_Key}'"
  esac
  case ${BS_LM_NE_Value} in
  *"'"*) BS_LM_NE_Value=$(fn_bs_libmap_quote "${BS_LM_NE_Value}") || return $? ;;
      *) BS_LM_NE_Value="'${BS_LM_NE_Value}'"
  esac

  #=========================================================
  # Add
  #=========================================================
  fn_bs_libmap__g_map__add \
    "${BS_LM_NE_Caller}"   \
    "${BS_LM_NE_Key}"      \
    "${BS_LM_NE_Value}"    || return $?
} #<: `fn_bs_libmap_new_entry()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap_add_set_entries`
#;
#; Set the value for a given key for the current global map, adding the entry
#; if the key does not exist.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap_add_set_entries <CALLER> <MODE> --key|-k <KEY> --value|-v <VALUE>...
#;
#;     fn_bs_libmap_add_set_entries <CALLER> <MODE> <KEY> <VALUE>...
#;
#;     fn_bs_libmap_add_set_entries <CALLER> <MODE> <KEY>=<VALUE>...
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
#; : One of `set` or `add`.
#; : If specified as `set` the entry will be searched for
#;   before adding, otherwise the entry will always be
#;   added.
#;
#; `KEY` \[in]
#;
#; : Can contain any arbitrary text excluding
#;   any embedded `\0` (`<NUL>`) characters.
#; : MUST be followed by a `VALUE`.
#; : MUST NOT be null.
#; : Can be specified multiple times.
#;
#; `VALUE` \[in]
#;
#; : Can contain any arbitrary text excluding
#;   any embedded `\0` (`<NUL>`) characters.
#; : MUST be preceded by a `KEY`.
#; : Can be null.
#; : Can be specified multiple times.
#;
#; _CAVEATS_
#; <!-- - -->
#;
#; - Argument forms can be mixed, but a `KEY` and a `VALUE` MUST be paired.
#; - The use of `--key|-k` is _required_ if `KEY` contains an `=` (`<equals>`)
#;   character, otherwise all forms are equivalent.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Provides the common functionality of [`map_new`](#map_new),
#;  [`map_add`](#map_add), and [`map_set`](#map_set)
#;
#_______________________________________________________________________________
fn_bs_libmap_add_set_entries() { ## cSpell:Ignore BS_LM_ASE_
  BS_LM_ASE_Caller=${1:?'[libmap::fn_bs_libmap_add_set_entries]: Internal Error: a command name is required'}
  shift
  BS_LM_ASE_Mode=${1:?'[libmap::fn_bs_libmap_add_set_entries]: Internal Error: a mode is required'}
  shift

  #=========================================================
  #
  #=========================================================
  while : #<: `[ $# -gt 0 ]`
  do
    #> LOOP TEST -----------------------
    case $# in 0) break ;; esac #<: `[ $# -gt 0 ]`
    #> ---------------------------------

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BS_LM_ASE_Key=; BS_LM_ASE_Value=;
    unset BS_LM_ASE_Value

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case $1 in
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      -k|--key)
        case ${2+1} in
        1)  BS_LM_ASE_Key=${2} ;;
        *)  fn_bs_libmap_invalid_args \
              "${BS_LM_ASE_Caller}"   \
              "no key provided with $1"
            return "${c_BS_LIBMAP__EX_USAGE}" ;;
        esac
        shift; shift
      ;; #<: `-k|--key`

      #.................................
      -k*)
        BS_LM_ASE_Key=${1#-k}
        BS_LM_ASE_Key=${BS_LM_ASE_Key#=}
        shift
      ;; #<: `-k*`

      #.................................
      --key=*)
        BS_LM_ASE_Key=${1#-*=}
        shift
      ;; #<: `--key=*`

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      *=*)
          BS_LM_ASE_Key=${1%%=*}
        BS_LM_ASE_Value=${1#*=}
        shift
      ;; #<: `*=*)`

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      *)
        BS_LM_ASE_Key=${1}
        case ${2+1} in
        1)  BS_LM_ASE_Value=${2} ;;
        *)  fn_bs_libmap_invalid_args \
              "${BS_LM_ASE_Caller}"   \
              "invalid format for map entry: $1"
            return "${c_BS_LIBMAP__EX_USAGE}" ;;
        esac
        shift; shift
      ;; #<: `*)`
    esac #<: `case $1 in`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${BS_LM_ASE_Key:+1}:${BS_LM_ASE_Value+1}:$# in
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      1:1:*) ;;

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      :*)
        fn_bs_libmap_invalid_args \
          "${BS_LM_ASE_Caller}"   \
          "null keys are not permitted"
        return "${c_BS_LIBMAP__EX_USAGE}"
      ;; #<: `:*)`

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      1::0)
        fn_bs_libmap_invalid_args \
          "${BS_LM_ASE_Caller}"   \
          "no value provided for key ${BS_LM_ASE_Key}"
        return "${c_BS_LIBMAP__EX_USAGE}"
      ;; #<: `1::0)`

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      1::*)
        case $1 in
          #.................................................
          #
          #.................................................
          -v|--value)
            case ${2+1} in
            1)  BS_LM_ASE_Value=${2} ;;
            *)  fn_bs_libmap_invalid_args \
                  "${BS_LM_ASE_Caller}"   \
                  "no value provided with $1"
                return "${c_BS_LIBMAP__EX_USAGE}" ;;
            esac
            shift; shift
          ;; #<: `-v|--value)`

          #.............................
          -v*)
            BS_LM_ASE_Value=${1#-v}
            BS_LM_ASE_Value=${BS_LM_ASE_Value#=}
            shift
          ;; #<: `-v*)`

          #.............................
          --value=*)
            BS_LM_ASE_Value=${1#-*=}
            shift
          ;; #<: `--value=*)`

          #.................................................
          #
          #.................................................
          *)
            fn_bs_libmap_invalid_args \
              "${BS_LM_ASE_Caller}"   \
              "invalid format for map value: $1"
            return "${c_BS_LIBMAP__EX_USAGE}"
          ;; #<: `*)`
        esac #<: `case $1 in`
      ;; #<: `1::*)`
    esac #<: `case ${BS_LM_ASE_Key:+1}:${BS_LM_ASE_Value+1}:$# in`

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Delete
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${BS_LM_ASE_Mode}:${g_BS_LIBMAP__map:+1} in
    set:1)
      if  fn_bs_libmap__g_map__lookup \
            "${BS_LM_ASE_Caller}"     \
            "${g_BS_LIBMAP__map}"     \
            'KEY'                     \
            "${BS_LM_ASE_Key}"
      then
        fn_bs_libmap__g_map__delete  \
          "${BS_LM_ASE_Caller}"      \
          "${g_BS_LIBMAP__map__idx}" || return $?
      fi ;;
    esac

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Quote
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${BS_LM_ASE_Key} in
    *"'"*) BS_LM_ASE_Key=$(fn_bs_libmap_quote "${BS_LM_ASE_Key}") || return $? ;;
        *) BS_LM_ASE_Key="'${BS_LM_ASE_Key}'"
    esac
    case ${BS_LM_ASE_Value} in
    *"'"*) BS_LM_ASE_Value=$(fn_bs_libmap_quote "${BS_LM_ASE_Value}") || return $? ;;
        *) BS_LM_ASE_Value="'${BS_LM_ASE_Value}'"
    esac

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Add/Set
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fn_bs_libmap__g_map__add \
      "${BS_LM_ASE_Caller}"  \
      "${BS_LM_ASE_Key}"     \
      "${BS_LM_ASE_Value}"   || return $?
  done #<: `while [ $# -gt 0 ]`
} #<: `fn_bs_libmap_add_set_entries()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libmap_keys_or_values`
#;
#; Generate an array of keys or values from the given map.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libmap_keys_or_values <CALLER> <TYPE> <MAP>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `TYPE` \[in]
#;
#; : The value `keys` to retrieve keys;
#;   the value `values` to retrieve values.
#; : NOT validated.
#;
#; `MAP` \[in:ref]
#;
#; : Variable that contains a valid map.
#; : MUST be a valid _POSIX.1_ name.
#;
#_______________________________________________________________________________
fn_bs_libmap_keys_or_values() { ## cSpell:Ignore BS_LMKOV_
       BS_LMKOV_Caller=${1:?'[libmap::fn_bs_libmap_keys_or_values]: Internal Error: a command name is required'}
  BS_LMKOV_KeyOrValues=${2:?'[libmap::fn_bs_libmap_keys_or_values]: Internal Error: a flag variable is required'}
       BS_LMKOV_refMap=${3:?'[libmap::fn_bs_libmap_keys_or_values]: Internal Error: a map variable is required'}

  #=========================================================
  # Load
  #=========================================================
  fn_bs_libmap__g_map__load \
    "${BS_LMKOV_Caller}"    \
    "${BS_LMKOV_refMap}"    || return $?

  #=========================================================
  # Early out if empty map
  #=========================================================
  case ${g_BS_LIBMAP__map__Count:-0} in 0) return ;; esac

  #=========================================================
  # This loop iterates until a lookup fails - skipping any
  # indices known to not exist means the first failure is
  # then end of the map.
  #
  # The need to check for known invalid indices means the
  # loop test can not easily be in the `while` condition
  # itself, so it resides _inside_ the loop.
  #=========================================================
  BS_LMKOV_Cur=0
  while : #< fn_bs_libmap__g_map__lookup ... "${BS_LMKOV_Cur}"
  do
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Having the increment here avoids needing to repeat it
    # in multiple locations making the logic simpler, but
    # requires an additional variable
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BS_LMKOV_Idx=${BS_LMKOV_Cur}
    BS_LMKOV_Cur=$(( BS_LMKOV_Cur + 1 ))

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # The map contains a list of currently invalid indices,
    # which are simply skipped here.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${g_BS_LIBMAP__map__DelIDs:-} in
    *,"${BS_LMKOV_Idx}",*) continue ;;
    esac

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # If the lookup succeeds process it, otherwise terminate
    # the loop.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if  fn_bs_libmap__g_map__lookup \
          "${BS_LMKOV_Caller}"      \
          "${g_BS_LIBMAP__map}"     \
          'IDX'                     \
          "${BS_LMKOV_Idx}"
    then
      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      case ${BS_LMKOV_KeyOrValues} in
        'keys') BS_LMKOV_SaveVal=${g_BS_LIBMAP__map__key} ;;
      'values') BS_LMKOV_SaveVal=${g_BS_LIBMAP__map__val} ;;
      esac

      #-----------------------------------------------------
      #
      #-----------------------------------------------------
      case ${BS_LMKOV_SaveVal} in
      *"'"*) fn_bs_libmap_quote   "${BS_LMKOV_SaveVal}" ;;
          *) printf "'%s' \\\\\n" "${BS_LMKOV_SaveVal}" ;;
      esac
    else
      #-----------------------------------------------------
      # Exit status of a failed lookup is `1` - otherwise an
      # error occurred and this should be reported.
      #-----------------------------------------------------
      BS_LMKOV_ExitStatus=$?
      case ${BS_LMKOV_ExitStatus} in
      1) break ;;
      *) return ${BS_LMKOV_ExitStatus} ;;
      esac
    fi
  done #<: `while fn_bs_libmap__g_map__lookup ... "${BS_LMKOV_Cur}"`

  #=========================================================
  #
  #=========================================================
  echo ' ' #<  Trailing whitespace is required
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
#: ### `map_new`
#:
#: Create a new map from the given arguments _or_ a map written to `STDOUT`
#: with values from `STDIN`.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     ... | map_new
#:
#:     map_new <MAP> --key|-k <KEY> --value|-v <VALUE>...
#:
#:     map_new <MAP> <KEY> <VALUE>...
#:
#:     map_new <MAP> <KEY>=<VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[out:ref]
#:
#: : Variable that will contain the new map.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name.
#: : If specified as `-` (`<hyphen>`) map
#:   is written to `STDOUT`.
#:
#: `KEY` \[in]
#:
#: : Can contain any arbitrary text excluding
#:   any embedded `\0` (`<NUL>`) characters.
#: : MUST be followed by a `VALUE`.
#: : MUST NOT be null.
#: : Can be specified multiple times.
#:
#: `VALUE` \[in]
#:
#: : Can contain any arbitrary text excluding
#:   any embedded `\0` (`<NUL>`) characters.
#: : MUST be preceded by a `KEY`.
#: : Can be null.
#: : Can be specified multiple times.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Map=$(my_command | map_new)
#:     map_new 'Map' 'Key1=Value One' 'Key2=Value Two'
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - Argument forms can be mixed, but a `KEY` and a `VALUE` MUST be paired.
#: - The use of `--key|-k` is _required_ if `KEY` contains an `=` (`<equals>`)
#:   character, otherwise all forms are equivalent.
#: - When given no arguments, will read map values from `STDIN`; if this is
#:   erroneously used without `STDIN` directed into the command this will block
#:   indefinitely.
#: - Input via `STDIN` requires a single entry per line in the form
#:   `<KEY>=<VALUE>`.
#:
#: _NOTES_
#: <!-- -->
#:
#: - An `ENTRY` specified as `"'Key1'='Value One'"` will have quotes included in
#:   the values stored, i.e. `KEY` will be `'Key1'` while `VALUE` will be
#:   `'Value One'`.
#: - Although it is possible to store any value in a map, large values (e.g.
#:   file contents) may cause issues with performance or may be impossible due
#:   to [limitations](#caveats) of the current environment.
#: - When used with arguments, is identical to [`map_add`](#map_add), but
#:   discards any existing values in `MAP`.
#: - `map_new`, [`map_add`](#map_add), and [`map_set`](#map_set) can all be
#:   used interchangeably in some circumstances. Where performance is concerned
#:   `map_new > map_add > map_set`, but the difference is unlikely to be of
#:   concern for most use cases (and may very well not even be measurable).
#:
#_______________________________________________________________________________
map_new() { ## cSpell:Ignore BS_LM_New_
  case $# in
    0)
      #-----------------------------------------------------
      # Reset
      #-----------------------------------------------------
      fn_bs_libmap__g_map__reset \
        'map_new'                || return $?

      {
        #---------------------------------------------------
        # Escape all <backslash> characters to stop `read`
        # changing them (instead each will be simply '\' in
        # the output).
        #
        # Then add a single (non-whitespace) character
        # after the line to avoid whitespace being trimmed
        # by `read`.
        #---------------------------------------------------
        sed -e 's/\\/\\\\/g
                s/$/_/'
      } | {
        #---------------------------------------------------
        #
        #---------------------------------------------------
        BS_LM_New_Entry=; unset 'BS_LM_New_Entry'

        #---------------------------------------------------
        # Add
        #
        # SC2162: read without -r will mangle backslashes.
        # EXCEPT: That is dealt with by `sed`.
        # shellcheck disable=SC2162
        #---------------------------------------------------
        while read 'BS_LM_New_Entry'
        do
          fn_bs_libmap_new_entry   \
            'map_new'              \
            "${BS_LM_New_Entry%_}" || return $?

          unset 'BS_LM_New_Entry'
        done

        #---------------------------------------------------
        #
        #---------------------------------------------------
        case ${BS_LM_New_Entry:+1} in
        1)  fn_bs_libmap_new_entry   \
              'map_new'              \
              "${BS_LM_New_Entry%_}" || return $? ;;
        esac

        #---------------------------------------------------
        # Save
        #---------------------------------------------------
        fn_bs_libmap__g_map__save \
          'map_new'               \
          '-'                     || return $?
      }
    ;;

    *)
      #-----------------------------------------------------
      # Get map variable
      #-----------------------------------------------------
      BS_LM_New_refMap=$1
      shift

      #-----------------------------------------------------
      # Validate
      #-----------------------------------------------------
      fn_bs_libmap_validate_name_hyphen \
        'map_new'                       \
        "${BS_LM_New_refMap}"           || return $?

      #-----------------------------------------------------
      # Reset
      #-----------------------------------------------------
      fn_bs_libmap__g_map__reset \
        'map_new'                || return $?

      #-----------------------------------------------------
      # Add
      #-----------------------------------------------------
      fn_bs_libmap_add_set_entries \
        'map_new'                  \
        'new'                      \
        ${1+"$@"}                  || return $?

      #-----------------------------------------------------
      # Save
      #-----------------------------------------------------
      fn_bs_libmap__g_map__save \
        'map_new'               \
        "${BS_LM_New_refMap}"
    ;;
  esac
} #<: `map_new()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_add`
#:
#: Add one or more values to a map. Equivalent to [`map_new`](#map_new)
#: _except_ any existing map values are retained.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_add <MAP> --key|-k <KEY> --value|-v <VALUE>...
#:
#:     map_add <MAP> <KEY> <VALUE>...
#:
#:     map_add <MAP> <KEY>=<VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: As for [`map_new`](#map_new), with the exception that values can NOT be
#: specified via `STDIN`, _and_ any existing map values are retained.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Map=$(map_add - 'A key for a map' 'A value associated with the key')
#:     map_add 'Map' --key="$FilePath" -v "$(cat $FilePath)"
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - Using this command for entries that already exist will hide the existing
#:   entries such that they can never be retrieved (or removed!) from the map.
#: - As for [`map_new`](#map_new).
#:
#: _NOTES_
#: <!-- -->
#:
#: - As for [`map_new`](#map_new).
#:
#_______________________________________________________________________________
map_add() { ## cSpell:Ignore BS_LM_Add_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  0)  fn_bs_libmap_expected \
        'map_add'           \
        'a map variable'    \
        'zero or more keys with values'
      return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Get map
  #---------------------------------------------------------
  BS_LM_Add_refMap=$1
  shift

  #---------------------------------------------------------
  # Validate
  #---------------------------------------------------------
  fn_bs_libmap_validate_name_hyphen \
    'map_add'                       \
    "${BS_LM_Add_refMap}"           || return $?

  #---------------------------------------------------------
  # Load
  #---------------------------------------------------------
  fn_bs_libmap__g_map__load \
    'map_add'               \
    "${BS_LM_Add_refMap}"   || return $?

  #---------------------------------------------------------
  # Add
  #---------------------------------------------------------
  fn_bs_libmap_add_set_entries \
    'map_add'                  \
    'add'                      \
    ${1+"$@"}                  || return $?

  #---------------------------------------------------------
  # Save
  #---------------------------------------------------------
  fn_bs_libmap__g_map__save \
    'map_add'               \
    "${BS_LM_Add_refMap}"
} #<: `map_add()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_set`
#:
#: Update the value associated with an existing map entry, adding it if it does
#: not exist.
#:
#: If the entry does not exist, this is equivalent to [`map_add`](#map_add).
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_set <MAP> --key|-k <KEY> --value|-v <VALUE>...
#:
#:     map_set <MAP> <KEY> <VALUE>...
#:
#:     map_set <MAP> <KEY>=<VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: As for [`map_add`](#map_add), except `MAP` can not be `-` (`<hyphen>`).
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Map=$(map_set - 'A key for a map' 'A value associated with the key')
#:     map_set 'Map' --key="$FilePath" -v "$(cat $FilePath)"
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - As for [`map_add`](#map_add).
#:
#: _NOTES_
#: <!-- -->
#:
#: - `MAP` can not be specified as `-` (`<hyphen>`), i.e. input can not be taken
#:   from `STDIN`, and output can not be sent to `STDOUT`.
#: - As for [`map_add`](#map_add).
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Setting a map entry is implemented as a delete followed by an add.
#.
#_______________________________________________________________________________
map_set() { ## cSpell:Ignore BS_LM_Set_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  0|1)  fn_bs_libmap_expected \
          'map_set'           \
          'a map variable'    \
          'one or more keys with values'
        return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Get map
  #---------------------------------------------------------
  BS_LM_Set_refMap=$1
  shift

  #---------------------------------------------------------
  # Validate
  #---------------------------------------------------------
  fn_bs_libmap_validate_name \
    'map_set'                \
    "${BS_LM_Set_refMap}"    || return $?

  #---------------------------------------------------------
  # Load
  #---------------------------------------------------------
  fn_bs_libmap__g_map__load \
    'map_set'               \
    "${BS_LM_Set_refMap}"   || return $?

  #---------------------------------------------------------
  # Set
  #---------------------------------------------------------
  fn_bs_libmap_add_set_entries \
    'map_set'                  \
    'set'                      \
    ${1+"$@"}                  || return $?

  #---------------------------------------------------------
  # Save
  #---------------------------------------------------------
  fn_bs_libmap__g_map__save \
    'map_set'               \
    "${BS_LM_Set_refMap}"
} #<: `map_set()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_get`
#:
#: Lookup a map value.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_get <MAP> <KEY> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[in:ref]
#:
#: : Variable containing a map.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `KEY` \[in]
#:
#: : Can contain any arbitrary text excluding
#:   any embedded `\0` (`<NUL>`) characters.
#: : Must NOT be null.
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
#:     if map_get 'Map' 'A map key' 'ValueVar'; then ... fi
#:     ValueVar=$(map_get 'Map' 'A map key')
#:     ValueVar=$(map_get 'Map' 'A map key' -)
#:
#: _NOTES_
#: <!-- -->
#:
#: - On success the exit code will be `0` (`<zero>`) if the `KEY` exists and
#:   `1` (`<one>`) if it does not.
#: - `OUTPUT` is only modified if `KEY` is found.
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#: - If `OUTPUT` is not required, [`map_contains`](#map_contains) is faster for
#:   checking if a `KEY` exists, though the difference is likely to be
#:   relatively small.
#:
#_______________________________________________________________________________
map_get() { ## cSpell:Ignore BS_LMMG_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  2)  BS_LMMG_refMap=$1
         BS_LMMG_Key=$2
      BS_LMMG_refVal='-' ;;

  3)  BS_LMMG_refMap=$1
         BS_LMMG_Key=$2
      BS_LMMG_refVal=$3
      fn_bs_libmap_validate_name_hyphen \
        'map_get'                       \
        "${BS_LMMG_refVal}"             || return $? ;;

  *)  fn_bs_libmap_expected \
        'map_get'           \
        'a map variable'    \
        'a key'             \
        'an output variable (optional)'
      return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libmap_validate_name \
    'map_get'                \
    "${BS_LMMG_refMap}"      || return $?

  #=========================================================
  # Load
  #=========================================================
  fn_bs_libmap__g_map__load \
    'map_get'               \
    "${BS_LMMG_refMap}"     || return $?

  #=========================================================
  # Early out if empty map
  #=========================================================
  case ${g_BS_LIBMAP__map__Count:-0} in 0) return 1 ;; esac

  #=========================================================
  # Lookup
  #=========================================================
  fn_bs_libmap__g_map__lookup \
    'map_get'                 \
    "${g_BS_LIBMAP__map}"     \
    'KEY'                     \
    "${BS_LMMG_Key}"          || return $?

  #=========================================================
  # Save
  #=========================================================
  case ${BS_LMMG_refVal} in
  -) printf '%s\n' "${g_BS_LIBMAP__map__val-}" ;;           #< OUTPUT
  *) eval "${BS_LMMG_refVal}=\${g_BS_LIBMAP__map__val-}" ;; #< SAVE
  esac
} #<: `map_get()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_contains`
#:
#: Check if a map contains a key.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_contains <MAP> <KEY>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[in:ref]
#:
#: : Variable containing a map.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `KEY` \[in]
#:
#: : Can contain any arbitrary text excluding
#:   any embedded `\0` (`<NUL>`) characters.
#: : Must NOT be null.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if map_contains 'Map' 'A map key'; then ... fi
#:
#: _NOTES_
#: <!-- -->
#:
#: - `map_contains` is faster than [`map_get`](#map_get) when testing if `KEY`
#:   exists (when the value is not required), but the difference is likely to
#:   be relatively small.
#:
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - TODO: Pattern Matching lookups. (These may be difficult to add with good
#.   performance, but could be implemented using key arrays and array search.)
#.
#_______________________________________________________________________________
map_contains() { ## cSpell:Ignore BS_LMMC_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  0|1)  fn_bs_libmap_expected \
          'map_contains'      \
          'a map variable'    \
          'a key'
        return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  BS_LMMC_refMap=$1
     BS_LMMC_Key=$2

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libmap_validate_name \
    'map_contains'           \
    "${BS_LMMC_refMap}"      || return $?

  #=========================================================
  # Load
  #
  # NOTE: While it is possible to do the check on the map
  #       without first loading it, loading also provides
  #       checks on the map structure and the likely
  #       savings from skipping it are likely negligible.
  #=========================================================
  fn_bs_libmap__g_map__load \
    'map_contains'          \
    "${BS_LMMC_refMap}"     || return $?

  #=========================================================
  # Early out if empty map
  #=========================================================
  case ${g_BS_LIBMAP__map__Count:-0} in 0) return 1 ;; esac

  #=========================================================
  # Safe Quote
  #=========================================================
  case ${BS_LMMC_Key} in
  *"'"*) BS_LMMC_Key=$(fn_bs_libmap_quote "${BS_LMMC_Key}") || return $? ;;
      *) BS_LMMC_Key="'${BS_LMMC_Key}'"
  esac

  #=========================================================
  # Lookup
  #=========================================================
  case ${g_BS_LIBMAP__map} in
  *"KEY:${BS_LMMC_Key}"*) return 0 ;;
                       *) return 1 ;;
  esac
} #<: `map_contains()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_delete`
#:
#: Remove a map entry.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_delete <MAP> <KEY>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[out:ref]
#:
#: : Variable containing a map.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `KEY` \[in]
#:
#: : Can contain any arbitrary text excluding
#:   any embedded `\0` (`<NUL>`) characters.
#: : Must NOT be null.
#: : Can be specified multiple times.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     map_delete 'Map' 'A map key'
#:
#: _NOTES_
#: <!-- -->
#:
#: - Any `KEY` which is not in `MAP` is skipped. This is not considered an
#:   error.
#:
#_______________________________________________________________________________
map_delete() { ## cSpell:Ignore BS_LMMD_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  0|1)  fn_bs_libmap_expected \
          'map_delete'        \
          'a map variable'    \
          'one or more keys'
        return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  BS_LMMD_refMap=$1
  shift

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libmap_validate_name \
    'map_delete'             \
    "${BS_LMMD_refMap}"      || return $?

  #=========================================================
  # Load
  #=========================================================
  fn_bs_libmap__g_map__load \
    'map_delete'            \
    "${BS_LMMD_refMap}"     || return $?

  #=========================================================
  # Early out if nothing to do
  #=========================================================
  case ${g_BS_LIBMAP__map__Count:-0} in 0) return ;; esac

  #=========================================================
  # Delete
  #=========================================================
  for BS_LMMD_Key
  do
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Lookup
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fn_bs_libmap__g_map__lookup \
      'map_delete'              \
      "${g_BS_LIBMAP__map}"     \
      'KEY'                     \
      "${BS_LMMD_Key}"          || continue

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Delete
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fn_bs_libmap__g_map__delete  \
      'map_delete'               \
      "${g_BS_LIBMAP__map__idx}" || return $?
  done #<: `for BS_LMMD_Key`

  #=========================================================
  # Save
  #=========================================================
  fn_bs_libmap__g_map__save \
    'map_delete'            \
    "${BS_LMMD_refMap}"
} #<: `map_delete()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_size`
#:
#: Get the number of entries in a map.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_size <MAP> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[in:ref]
#:
#: : Variable containing a map.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty map or `unset` variable.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the map size.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   size is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     Size=$(map_size 'Map')
#:     Size=$(map_size 'Map' -)
#:     map_size 'Map' 'Size'
#:
#_______________________________________________________________________________
map_size() { ## cSpell:Ignore BS_LM_Size_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  1)  BS_LM_Size_refMap=$1
      fn_bs_libmap_validate_name \
        'map_size'               \
        "${BS_LM_Size_refMap}"   || return $?
      BS_LM_Size_refSize='-' ;;

  2)  BS_LM_Size_refMap=$1
      fn_bs_libmap_validate_name \
        'map_size'               \
        "${BS_LM_Size_refMap}"   || return $?

      BS_LM_Size_refSize=$2
      fn_bs_libmap_validate_name_hyphen \
        'map_size'                      \
        "${BS_LM_Size_refSize}"         || return $? ;;

  *)  fn_bs_libmap_expected \
        'map_size'          \
        'a map variable'    \
        'an output variable (optional)'
      return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Load
  #=========================================================
  fn_bs_libmap__g_map__load \
    'map_size'              \
    "${BS_LM_Size_refMap}"  || return $?

  #=========================================================
  #
  #=========================================================
  case ${BS_LM_Size_refSize} in
  -) printf '%d\n' "${g_BS_LIBMAP__map__Count:-0}"               ;; #< OUTPUT
  *) eval "${BS_LM_Size_refSize}=\${g_BS_LIBMAP__map__Count:-0}" ;; #< SAVE
  esac
} #<: `map_size()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_foreach`
#:
#: Invoke a given command for each map entry.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_foreach <MAP> <COMMAND> [<ARGUMENTS>...]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[in:ref]
#:
#: : Variable that contains a map.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `COMMAND` \[in]
#:
#: : Command to invoke for each map entry.
#:
#: `ARGUMENTS` \[in]
#:
#: : Arguments passed to `COMMAND`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     map_foreach MAP printf 'Key: %s; Value: %s\n'
#:
#: _CAVEATS_
#: <!-- - -->
#:
#: - `COMMAND` may invoke other map commands, but changes to `MAP` will NOT
#:   affect `map_foreach` (e.g. an entry added to `MAP` via `COMMAND` will
#:   NOT be iterated by `map_foreach` - similarly for deleted or edited
#:   entries).
#: - If `COMMAND` invokes `map_foreach` it **MUST** be inside a subshell local
#:   to `COMMAND`.
#:
#: _NOTES_
#: <!-- -->
#:
#: - `COMMAND` is invoked with the the map key and value as the final two
#:   arguments.
#: - Iteration is stopped if `COMMAND` results in a non-zero exit code. This
#:   code will be used as the exit code for `map_foreach`.
#: - The order entries are iterated in is deterministic _but_ may not match the
#:   order they were added.
#:
#_______________________________________________________________________________
map_foreach() { ## cSpell:Ignore BS_LMFE_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  0|1)  fn_bs_libmap_expected \
          'map_foreach'       \
          'a map variable'    \
          'a command'         \
          'command arguments (optional)'
        return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac

  BS_LMFE_refMap=$1
  shift

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libmap_validate_name \
    'map_foreach'            \
    "${BS_LMFE_refMap}"      || return $?

  #=========================================================
  # Load
  #=========================================================
  fn_bs_libmap__g_map__load \
    'map_foreach'           \
    "${BS_LMFE_refMap}"     || return $?

  #=========================================================
  # Early out if nothing to do
  #=========================================================
  case ${g_BS_LIBMAP__map__Count:-0} in 0) return ;; esac

  #=========================================================
  # Using alternative storage for the map allows the user
  # command to call other map commands without problems.
  #=========================================================
     BS_LMFE_Map=${g_BS_LIBMAP__map}
  BS_LMFE_DelIDs=${g_BS_LIBMAP__map__DelIDs}

  #=========================================================
  #
  #=========================================================
  fn_bs_libmap__g_map__reset 'map_foreach' || return $?

  #=========================================================
  # This loop iterates until a lookup fails - skipping any
  # indices known to not exist means the first failure is
  # then end of the map.
  #
  # The need to check for known invalid indices means the
  # loop test can not easily be in the `while` condition
  # itself, so it resides _inside_ the loop.
  #=========================================================
  BS_LMFE_Cur=0
  while : #< fn_bs_libmap__g_map__lookup ... "${BS_LMFE_Cur}"
  do
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Having the increment here avoids needing to repeat it
    # in multiple locations making the logic simpler, but
    # requires an additional variable
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BS_LMFE_Idx=${BS_LMFE_Cur}
    BS_LMFE_Cur=$(( BS_LMFE_Cur + 1 ))

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # The map contains a list of currently invalid indices,
    # which are simply skipped here.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    case ${BS_LMFE_DelIDs:-} in
    *,"${BS_LMFE_Idx}",*) continue ;;
    esac

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # If the lookup succeeds process it, otherwise terminate
    # the loop.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if  fn_bs_libmap__g_map__lookup \
          'map_foreach'             \
          "${BS_LMFE_Map}"          \
          'IDX'                     \
          "${BS_LMFE_Idx}"
    then
      "$@" "${g_BS_LIBMAP__map__key}" "${g_BS_LIBMAP__map__val}" || return $?
    else
      #-----------------------------------------------------
      # Exit status of a failed lookup is `1` - otherwise an
      # error occurred and this should be reported.
      #-----------------------------------------------------
      BS_LMFE_ExitStatus=$?
      case ${BS_LMFE_ExitStatus} in
      1) break ;;
      *) return ${BS_LMFE_ExitStatus} ;;
      esac
    fi
  done #<: `while fn_bs_libmap__g_map__lookup ... "${BS_LMFE_Cur}"`
} #<: `map_foreach()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_keys`
#:
#: Get an array of all keys in a map.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_keys <MAP> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[in:ref]
#:
#: : Variable that contains a map.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the keys.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   the keys are written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     map_keys Map Keys
#:     eval "set -- $Keys"
#:     for Key; do print '%s\n' "$Key"; done
#:
#: _NOTES_
#: <!-- -->
#:
#: - The order of values is deterministic but may not match the order they were
#:   added.
#: - The resulting array can be manipulated using the `libarray.sh` library
#:   (also part of the `shtoolkit`).
#:
#_______________________________________________________________________________
map_keys() { ## cSpell:Ignore BS_LMMK_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  1)   BS_LMMK_refMap=$1
      BS_LMMK_refKeys='-' ;;
  2)   BS_LMMK_refMap=$1
      BS_LMMK_refKeys=$2
      fn_bs_libmap_validate_name_hyphen \
        'map_keys'                      \
        "${BS_LMMK_refKeys}"            || return $? ;;
  *)  fn_bs_libmap_expected \
        'map_keys'          \
        'a map variable'    \
        'a variable to hold the keys (optional)'
      return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libmap_validate_name \
    'map_keys'               \
    "${BS_LMMK_refMap}"      || return $?

  #=========================================================
  #
  #=========================================================
  BS_LMMK_Keys=$(
      fn_bs_libmap_keys_or_values \
        'map_keys'                \
        'keys'                    \
        "${BS_LMMK_refMap}"
    ) || return $?

  #=========================================================
  #
  #=========================================================
  case ${BS_LMMK_refKeys} in
  -) printf '%s\n' "${BS_LMMK_Keys}" ;;             #< OUTPUT
  *) eval "${BS_LMMK_refKeys}=\${BS_LMMK_Keys}" ;;  #< SAVE
  esac
} #<: `map_keys()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_values`
#:
#: Get an array of all values in a map.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_values <MAP> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[in:ref]
#:
#: : Variable containing a map.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the keys.
#: : MUST be a valid _POSIX.1_ name.
#: : Any current contents will be lost.
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   the keys are written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     map_values Map Values
#:     eval "set -- $Values"
#:     for Val; do print '%s\n' "$Val"; done
#:
#: _NOTES_
#: <!-- -->
#:
#: - The order of values is deterministic but may not match the order they were
#:   added.
#: - The resulting array can be manipulated using the `libarray.sh` library
#:   (also part of the `shtoolkit`).
#:
#_______________________________________________________________________________
map_values() { ## cSpell:Ignore BS_LMMV_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  1)     BS_LMMV_refMap=$1
      BS_LMMV_refValues='-' ;;
  2)     BS_LMMV_refMap=$1
      BS_LMMV_refValues=$2
      fn_bs_libmap_validate_name_hyphen \
        'map_values'                    \
        "${BS_LMMV_refValues}"          || return $? ;;
  *)  fn_bs_libmap_expected \
        'map_values'        \
        'a map variable'    \
        'a variable to hold the values (optional)'
      return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac #<: `case $# in`

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libmap_validate_name \
    'map_values'             \
    "${BS_LMMV_refMap}"      || return $?

  #=========================================================
  #
  #=========================================================
  BS_LMMV_Values=$(
      fn_bs_libmap_keys_or_values \
        'map_values'              \
        'values'                  \
        "${BS_LMMV_refMap}"
    ) || return $?

  #=========================================================
  #
  #=========================================================
  case ${BS_LMMV_refValues} in
  -) printf '%s\n' "${BS_LMMV_Values}" ;;               #< OUTPUT
  *) eval "${BS_LMMV_refValues}=\${BS_LMMV_Values}" ;;  #< SAVE
  esac
} #<: `map_values()`

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: ### `map_is_map`
#:
#: Determine if a variable looks like it contains map like data.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     map_is_map <MAP>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `MAP` \[in:ref]
#:
#: : Variable that may contain a map.
#: : MUST be a valid _POSIX.1_ name.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if map_is_map 'Var'; then ...; fi
#:
#: _NOTES_
#: <!-- -->
#:
#: - An empty or unset `MAP` is _not_ a valid map.
#: - Exit status will be `0` (`<zero>`) if `MAP` appears to be a valid map,
#:   while the exit status will be `1` (`<one>`) in all other (non-error) cases.
#:
#_______________________________________________________________________________
map_is_map() { ## cSpell:Ignore BS_LMMIM_
  #=========================================================
  # Argument Processing
  #=========================================================
  case $# in
  1)  BS_LMMIM_refMap=$1 ;;
  *)  fn_bs_libmap_expected \
        'map_is_map'        \
        'a map variable'
      return "${c_BS_LIBMAP__EX_USAGE}" ;;
  esac

  #=========================================================
  # Validate
  #=========================================================
  fn_bs_libmap_validate_name \
    'map_is_map'             \
    "${BS_LMMIM_refMap}"     || return $?

  #=========================================================
  # Unpack
  #=========================================================
  eval "BS_LMMIM_Map=\${${BS_LMMIM_refMap}-}" || return $?

  #=========================================================
  # Check Header:
  #
  #     #>HEADER
  #     #>VER:<VERSION>:REV<#
  #     #>NUM:<COUNT>:MUN<#
  #     #>DEL:[,<INDEX>,...]:LED<#
  #     #<REDAEH                        ## cSpell:Ignore REDAEH
  #=========================================================
  case ${BS_LMMIM_Map-} in
  "#>HEADER${c_BS_LIBMAP__newline}#>VER:${BS_LIBMAP_MAP_FORMAT_VERSION}:REV<#"*'#<REDAEH'*)
    return 0 ;;

  *)
    return 1 ;;
  esac
} #<: `map_is_map()`

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
*a*) set +a; BS_LIBMAP_SOURCED=1; set -a ;;
  *)         BS_LIBMAP_SOURCED=1         ;;
esac

fn_bs_libmap_readonly 'BS_LIBMAP_SOURCED'

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
#: - Modification of a map outside of the library is not supported.
#: - Argument validation occurs where possible and (relatively) performant for
#:   all arguments to all commands.
#: - Maps can be serialized (e.g. saved to, or loaded from, a file). The
#:   [`BS_LIBMAP_MAP_FORMAT_VERSION`](#bs_libmap_map_format_version) value
#:   determines if a library is able to process a given map and _may_ change
#:   between library versions.
#:
#: <!-- ------------------------------------------------ -->
#:
#. ## IMPLEMENTATION NOTES
#. <!-- -------------- -->
#.
#. ### INTERNAL FORMAT
#. <!-- ---------- -->
#.
#. A map is stored as a partial `case` statement with some additional data
#. which is required to properly support all the required operations.
#.
#. The **current** internal format is:
#.
#.     <HEADER>
#.     <ENTRY>
#.     ...
#.     <ENTRY>
#.
#. #### ENTRY
#. <!-- -- -->
#.
#.     #> IDX:'<INDEX>
#.     KEY:<KEY>|IDX:<INDEX>)
#.       g_BS_LIBMAP__map__idx=<INDEX>;
#.       g_BS_LIBMAP__map__key=<KEY>;
#.     [ g_BS_LIBMAP__map__val=<VALUE>; ]
#.     ;;
#.     #< IDX:'<INDEX>
#.
#. `<INDEX>`
#.
#. : A unique numerical value associated with `<KEY>`.
#.
#. `<KEY>` and `<VALUE>`
#.
#. : Are, respectively the map key and value.
#. : Quoted using `'` (`<apostrophe>`) characters (with any
#.   internal `'` (`<apostrophe>`) characters escaped).
#.
#. - Using `KEY:<KEY>` and `IDX:<INDEX>` for the `case` match makes it
#.   impossible to create a map key that can match when it should not.
#. - The use of quotes in `#> IDX:'<INDEX>` and `#< IDX:'<INDEX>` make these
#.   sequences that are not possible to appear elsewhere making them unique.
#. - The use of `<INDEX>` makes some operations simpler: since a `<KEY>` may
#.   contain arbitrary text it is difficult to correctly match when trying to
#.   process the map to, for example, remove an entry.
#.
#. #### HEADER
#. <!-- -- -->
#.
#.     #>HEADER
#.     #>VER:<VERSION>:REV<#
#.     #>NUM:<COUNT>:MUN<#
#.     #>DEL:[,<INDEX>,...]:LED<#
#.     #<REDAEH
#.
#. The format of the header was chosen to allow for easy parsing using parameter
#. expansion _and_ for this parsing to be easy to understand. Earlier formats
#. for this did not account for the latter which resulted in parsing that was
#. more complicated to follow and took more time to understand despite being
#. fundamentally identical.
#.
#. `<INDEX>`
#.
#. : A unique numerical value associated
#.   with a map key in the current map.
#.
#. `#>VER:<VERSION>:REV<#`
#.
#. : A version number used to ensure the map
#.   seems valid and is not in an old format.
#.
#. `#>NUM:<COUNT>:MUN<#`
#.
#. : The count of current entries.
#.
#. `#>DEL:[,<INDEX>,...]:LED<#`
#.
#. : A `,` (`<comma>`) delimited list of
#.   the indices previously deleted.
#.
#. Technically, a functional map can be created without the need for any of this
#. data - however, there are some operations that would be difficult, or more
#. costly if this data was not stored.
#.
#. **_Note: the internal format of a map is subject to change._**
#.
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## CAVEATS
#:
#: - The library attempts to account for differences between implementations
#:   (where known), however, it is not possible to do this for every case.
#: - The maximum size of any map is limited by the environment in which it is
#:   used. Of particular note is that exceeding the command line length limit
#:   will cause maps to be unusable in many (platform dependent)
#:   circumstances, though other limitations will also exist. Note that
#:   exporting a variable containing an map will cause that variable to be
#:   counted against the command line length limit **TWICE** if the map is
#:   also used with a command.
#: - The internal structure of a map is subject to change without notice and
#:   should not be relied upon.
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
