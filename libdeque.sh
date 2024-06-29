#!/usr/bin/env false
# shellcheck shell=sh
# SPDX-License-Identifier: MPL-2.0
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libdeque': Simple queue, deque, and stack emulation for     *#
#*                           POSIX.1 compliant shells.                        *#
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

################################### LIBDEQUE ###################################
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
## cSpell:Ignore libdeque
################################ DOCUMENTATION #################################
#
#% % libdeque(7) BetterScripts | Simple deque, queue, and stack emulation for POSIX.1 shells.
#% % BetterScripts (better.scripts@proton.me)
#
#: <!-- #################################################################### -->
#: <!-- ############ THIS FILE WAS GENERATED FROM 'libdeque.sh' ############ -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # libdeque
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## SYNOPSIS
#:
#: _Full synopsis, description, arguments, examples and other information is_
#: _documented with each individual command._
#:
#: ---------------------------------------------------------
#:
#: _DEQUE: Double-Ended Queue_
#: <!-- ------------------ -->
#:
#: [`deque_push_front <DEQUE> <VALUE>...`](#deque_push_front)
#:
#: [`deque_pop_front <DEQUE> [<OUTPUT>]`](#deque_pop_front)
#:
#: [`deque_unshift <DEQUE> <VALUE>...`](#deque_unshift) _(alias for `deque_push_front`)_
#:
#: [`deque_shift <DEQUE> [<OUTPUT>]`](#deque_shift) _(alias for `deque_pop_front`)_
#:
#: [`deque_push_back <DEQUE> <VALUE>...`](#deque_push_back)
#:
#: [`deque_pop_back <DEQUE> [<OUTPUT>]`](#deque_pop_back)
#:
#: [`deque_push <DEQUE> <VALUE>...`](#deque_push) _(alias for `deque_push_back`)_
#:
#: [`deque_pop <DEQUE> [<OUTPUT>]`](#deque_pop) _(alias for `deque_pop_back`)_
#:
#: [`deque_peek_front <DEQUE> [<OUTPUT>]`](#deque_peek_front)
#:
#: [`deque_peek_back <DEQUE> [<OUTPUT>]`](#deque_peek_back)
#:
#: [`deque_front <DEQUE> [<OUTPUT>]`](#deque_front) _(alias for `deque_peek_front`)_
#:
#: [`deque_back <DEQUE> [<OUTPUT>]`](#deque_back) _(alias for `deque_peek_back`)_
#:
#: [`deque_size <DEQUE> [<OUTPUT>]`](#deque_size)
#:
#: [`deque_is_deque_like <DEQUE>`](#deque_is_deque_like)
#:
#: ---------------------------------------------------------
#:
#: _QUEUE: First In, First Out Queue._
#: <!-- -------------------------- -->
#:
#: [`queue_push <QUEUE> <VALUE>...`](#queue_push)
#:
#: [`queue_pop <QUEUE> [<OUTPUT>]`](#queue_pop)
#:
#: [`queue_peek <QUEUE> [<OUTPUT>]`](#queue_peek)
#:
#: [`queue_size <QUEUE> [<OUTPUT>]`](#queue_size)
#:
#: [`queue_is_queue_like <QUEUE>`](#queue_is_queue_like)
#:
#: ---------------------------------------------------------
#:
#: STACK: Last In, First Out Stack._
#: <!-- ------------------------ -->
#:
#: [`stack_push <STACK> <VALUE>...`](#stack_push)
#:
#: [`stack_pop <STACK> [<OUTPUT>]`](#stack_pop)
#:
#: [`stack_peek <STACK> [<OUTPUT>]`](#stack_peek)
#:
#: [`stack_size <STACK> [<OUTPUT>]`](#stack_size)
#:
#: [`stack_is_stack_like <STACK>`](#stack_is_stack_like)
#:
#: ---------------------------------------------------------
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## DESCRIPTION
#:
#: Provides commands to allow any _POSIX.1_ compliant shell to use a simple
#: emulated queue like data structures:
#:
#: `deque`
#:
#: : _Double-Ended_ - access to elements at both ends of the deque.
#: : _Sequential_ - elements in the middle can not be accessed directly.
#:
#: `queue`
#:
#: : _Single-Ended_ - access to elements at one end only.
#: : _First In, First Out_ - elements accessed in added order.
#: : _Sequential_ - elements in the middle can not be accessed directly.
#:
#: `stack`
#:
#: : _Single-Ended_ - access to elements at one end only.
#: : _Last In, First Out_ - elements accessed in _reversed_ order.
#: : _Sequential_ - elements in the middle can not be accessed directly.
#:
#: These structures are highly efficient, with performance that should be close
#: to the maximum possible for any data that can be processed using them. All 3
#: types have identical performance characteristics.
#:
#: For any operation requiring sequential access to a number of elements these
#: data types should be the first considered for use (before more obvious types
#: such as (emulated) arrays).
#:
#: _The types `queue` and `stack` are specializations of `deque`, so provided
#:  in the same library._
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
case ${BS_LIBDEQUE_SOURCED:+1} in 1) return ;; esac

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
#. ### `fn_bs_libdeque_readonly`
#.
#. Wrapper round `readonly`.
#.
#. Required because in its default configuration Z Shell's `readonly` causes
#. problems (due to variable scoping).
#.
#. See [`BS_LIBDEQUE_CONFIG_NO_Z_SHELL_SETOPT`](#bs_libdeque_config_no_z_shell_setopt)
#.
#. _SYNOPSIS_
#. <!-- - -->
#.
#.     fn_bs_libdeque_readonly <VAR>...
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
fn_bs_libdeque_readonly() { ## cSpell:Ignore BS_LD_Readonly_
  case ${c_BS_LIBDEQUE_CFG_USE__zsh_setopt} in
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
#: #### `BS_LIBDEQUE_CONFIG_NO_Z_SHELL_SETOPT`
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
#. - See [`fn_bs_libdeque_readonly`](#fn_bs_libdeque_readonly).
#:
case ${BS_LIBDEQUE_CONFIG_NO_Z_SHELL_SETOPT:-${BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT:-A}} in
A)  case ${ZSH_VERSION:+1} in
    1) c_BS_LIBDEQUE_CFG_USE__zsh_setopt=1 ;;
    *) c_BS_LIBDEQUE_CFG_USE__zsh_setopt=0 ;;
    esac ;;
0) c_BS_LIBDEQUE_CFG_USE__zsh_setopt=0 ;;
*) c_BS_LIBDEQUE_CFG_USE__zsh_setopt=1 ;;
esac

fn_bs_libdeque_readonly 'c_BS_LIBDEQUE_CFG_USE__zsh_setopt'

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
#: #### `BS_LIBDEQUE_CONFIG_QUIET_ERRORS`
#:
#: - Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
#: - Type:     FLAG
#: - Class:    VARIABLE
#: - Default:  _OFF_
#: - \[Enable]/Disable library error message output.
#: - _OFF_: error messages will be written to `STDERR` as:
#:   `[libdeque::<COMMAND>]: ERROR: <MESSAGE>`.
#: - _ON_: library error messages will be suppressed.
#: - The most recent error message is always available in
#:   [`BS_LIBDEQUE_LAST_ERROR`](#bs_libdeque_last_error)
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
#: #### `BS_LIBDEQUE_CONFIG_FATAL_ERRORS`
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
#:   [`BS_LIBDEQUE_CONFIG_QUIET_ERRORS`](#bs_libdeque_config_quiet_errors)).
#: - Both the library version of this option and the
#:   suite version can be modified between command
#:   invocations and will affect the next command.
#:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_CONFIG_USE_SAFER_DEQUE`
#:
#: - Type:     FLAG
#: - Class:    CONSTANT
#: - Default:  _OFF_
#: - Enable/\[Disable] the use of an internal format for
#:   `deque`, `queue`, and `stack` that is slightly safer.
#: - _OFF_: don't use the safer format, but if any value
#:   added contains text that matches the internal
#:   delimiters errors _will_ occur.
#: - _ON_: use the safer format, at the expense of some
#:   performance.
#: - The internal delimiters used to create the data
#:   structures that enable `deque`, `queue`, and `stack`
#:   types have been chosen to be highly unlikely to occur
#:   in any normal data, however it remains possible that
#:   they could be present. Setting this flag to _ON_ causes
#:   every value added to be modified such that it can no
#:   longer match the internal values, removing a possible
#:   (though unlikely) source of errors. Unfortunately this
#:   can result in lower performance, the extent of which
#:   is largely dependent on the contents of the values
#:   added.
#: - This affects all three data types; there is no
#:   available mechanism for applying this to a single type.
#: - Has a performance impact.
#:   Prefer **_OFF_** for performance.
#:
case ${BS_LIBDEQUE_CONFIG_USE_SAFER_DEQUE:-0} in
0) c_BS_LIBDEQUE_CFG_USE__SaferDeque=0 ;;
*) c_BS_LIBDEQUE_CFG_USE__SaferDeque=1 ;;
esac

fn_bs_libdeque_readonly 'c_BS_LIBDEQUE_CFG_USE__SaferDeque'

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
#: #### `BS_LIBDEQUE_VERSION_MAJOR`
#:
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_VERSION_MINOR`
#:
#: - Integer >= 0.
#: - Incremented for significant changes that do not
#:   break compatibility with previous versions.
#: - Reset to 0 when
#:   [`BS_LIBDEQUE_VERSION_MAJOR`](#bs_libdeque_version_major)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_VERSION_PATCH`
#:
#: - Integer >= 0.
#: - Incremented for minor revisions or bugfixes.
#: - Reset to 0 when
#:   [`BS_LIBDEQUE_VERSION_MINOR`](#bs_libdeque_version_minor)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_VERSION_RELEASE`
#:
#: - A string indicating a pre-release version, always
#:   null for full-release versions.
#: - Possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended).
#:
  BS_LIBDEQUE_VERSION_MAJOR=1
  BS_LIBDEQUE_VERSION_MINOR=0
  BS_LIBDEQUE_VERSION_PATCH=0
BS_LIBDEQUE_VERSION_RELEASE=;

fn_bs_libdeque_readonly 'BS_LIBDEQUE_VERSION_MAJOR'   \
                        'BS_LIBDEQUE_VERSION_MINOR'   \
                        'BS_LIBDEQUE_VERSION_PATCH'   \
                        'BS_LIBDEQUE_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_VERSION_FULL`
#:
#: - Full version combining
#:   [`BS_LIBDEQUE_VERSION_MAJOR`](#bs_libdeque_version_major),
#:   [`BS_LIBDEQUE_VERSION_MINOR`](#bs_libdeque_version_minor),
#:   and [`BS_LIBDEQUE_VERSION_PATCH`](#bs_libdeque_version_patch)
#:   as a single integer.
#: - Can be used in numerical comparisons
#: - Format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded).
#:
BS_LIBDEQUE_VERSION_FULL=$(( \
    ( (BS_LIBDEQUE_VERSION_MAJOR * 1000) + BS_LIBDEQUE_VERSION_MINOR ) * 1000 \
    + BS_LIBDEQUE_VERSION_PATCH \
  ))

fn_bs_libdeque_readonly 'BS_LIBDEQUE_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_VERSION`
#:
#: - Full version combining
#:   [`BS_LIBDEQUE_VERSION_MAJOR`](#bs_libdeque_version_major),
#:   [`BS_LIBDEQUE_VERSION_MINOR`](#bs_libdeque_version_minor),
#:   [`BS_LIBDEQUE_VERSION_PATCH`](#bs_libdeque_version_patch),
#:   and
#:   [`BS_LIBDEQUE_VERSION_RELEASE`](#bs_libdeque_version_release)
#:   as a formatted string.
#: - Format: `BetterScripts 'libdeque' vMAJOR.MINOR.PATCH[-RELEASE]`
#: - Derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#:
BS_LIBDEQUE_VERSION="$(
    printf "BetterScripts 'libdeque' v%d.%d.%d%s\n" \
           "${BS_LIBDEQUE_VERSION_MAJOR}"           \
           "${BS_LIBDEQUE_VERSION_MINOR}"           \
           "${BS_LIBDEQUE_VERSION_PATCH}"           \
           "${BS_LIBDEQUE_VERSION_RELEASE:+-${BS_LIBDEQUE_VERSION_RELEASE}}"
  )"

fn_bs_libdeque_readonly 'BS_LIBDEQUE_VERSION'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_LAST_ERROR`
#:
#: - Stores the error message of the most recent error.
#: - ONLY valid immediately following a command for which
#:   the exit status is not `0` (`<zero>`).
#: - Available even when error output is suppressed.
#:
BS_LIBDEQUE_LAST_ERROR=; #< CLEAR ON SOURCING

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_LIBDEQUE_SOURCED`
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
#. #### `c_BS_LIBDEQUE__newline`
#.
#. - Literal `\n` (`<newline>`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_LIBDEQUE__newline='
'

fn_bs_libdeque_readonly 'c_BS_LIBDEQUE__newline'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBDEQUE__Prefix`
#.
#. - The prefix added to each value stored in the internal
#.   deque.
#. - Technically it is possible for the value to contain
#.   this value, which would cause errors. This is highly
#.   unlikely, but can be avoided by enabling "safe" values
#.   with [BS_LIBDEQUE_CONFIG_USE_SAFER_DEQUE](#bs_libdeque_config_use_safer_deque)
#. - The use of both a prefix and suffix is not strictly
#.   required, but makes some code simpler. (It can be
#.   difficult to use
#.   ["Parameter Expansion"][posix_param_expansion] to
#.   remove text without both values.)
#. - It would be possible to make this different for each
#.   data type (deque, queue, or stack), which would make
#.   the types always distinct, but there seems little to
#.   gain from this.
#. - In addition to delimiting elements in the data
#.   structure, this value is used with `grep` as an easy
#.   way to determine a count of elements. Unfortunately,
#.   this means the value can not contain any
#.   `\n` (`<newline>`) characters, as this causes `grep` to
#.   issues (even with `-F`).
#. - See also
#.   [`c_BS_LIBDEQUE__Suffix`](#c_BS_LIBDEQUE__Suffix),
#.   [`c_BS_LIBDEQUE__ValuePrefix`](#c_BS_LIBDEQUE__ValuePrefix),
#.   and
#.   [`c_BS_LIBDEQUE__ValueSuffix`](#c_BS_LIBDEQUE__ValueSuffix).
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_LIBDEQUE__Suffix`
#.
#. - The suffix added to each value stored in the internal
#.   deque.
#. - For more details see
#.   [`c_BS_LIBDEQUE__Prefix`](#c_BS_LIBDEQUE__Prefix).
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_LIBDEQUE__ValuePrefix`
#.
#. - Equivalent to [c_BS_LIBDEQUE__Prefix](#c_bs_libdeque__prefix)
#.   with added `\n` (`<newline>`) characters. Although not
#.   strictly required, these add additional safety by
#.   reducing the likelihood of elements containing the
#.   prefix. It also makes the data more human readable
#.   which can be useful.
#. - This is the prefix used to create the internal
#.   structure, while [c_BS_LIBDEQUE__Prefix](#c_bs_libdeque__prefix)
#.   is used when invoking `grep`.
#. - For more details see
#.   [`c_BS_LIBDEQUE__Prefix`](#c_BS_LIBDEQUE__Prefix).
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_LIBDEQUE__ValueSuffix`
#.
#. - Equivalent to [c_BS_LIBDEQUE__Suffix](#c_bs_libdeque__suffix)
#.   with added `\n` (`<newline>`) characters.
#. - For more details see
#.   [`c_BS_LIBDEQUE__ValuePrefix`](#c_BS_LIBDEQUE__ValuePrefix),
#.   and
#.   [`c_BS_LIBDEQUE__Prefix`](#c_BS_LIBDEQUE__Prefix).
#.
c_BS_LIBDEQUE__Prefix="#>'QUEUE':ENTRY"
c_BS_LIBDEQUE__Suffix="#<'YRTNE':EUEUQ"  ## cSpell:Ignore YRTNE EUEUQ

c_BS_LIBDEQUE__ValuePrefix="${c_BS_LIBDEQUE__Prefix}${c_BS_LIBDEQUE__newline}"
c_BS_LIBDEQUE__ValueSuffix="${c_BS_LIBDEQUE__newline}${c_BS_LIBDEQUE__Suffix}${c_BS_LIBDEQUE__newline}"

fn_bs_libdeque_readonly 'c_BS_LIBDEQUE__Prefix'      \
                        'c_BS_LIBDEQUE__Suffix'      \
                        'c_BS_LIBDEQUE__ValuePrefix' \
                        'c_BS_LIBDEQUE__ValueSuffix'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_LIBDEQUE__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
c_BS_LIBDEQUE__EX_USAGE=64

fn_bs_libdeque_readonly 'c_BS_LIBDEQUE__EX_USAGE'

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
#; ### `fn_bs_libdeque_error`
#;
#; Error reporting command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libdeque_error <CALLER> <MESSAGE>...
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
#; - If [`BS_LIBDEQUE_CONFIG_QUIET_ERRORS`](#bs_libdeque_config_quiet_errors)
#;   is _OFF_ a message in the format `[libdeque::<COMMAND>]: ERROR: <MESSAGE>`
#;   is written to `STDERR`.
#; - If [`BS_LIBDEQUE_CONFIG_FATAL_ERRORS`](#bs_libdeque_config_fatal_errors)
#;   is _ON_ then an "unset variable" shell exception will be triggered using
#;   the [`${parameter:?[word]}`][posix_param_expansion] parameter expansion,
#;   where `word` is set to the error message.
#; - [`BS_LIBDEQUE_LAST_ERROR`](#bs_libdeque_last_error) will contain the
#;   `<MESSAGE>` without any additional prefix regardless of other settings.
#;
#_______________________________________________________________________________
fn_bs_libdeque_error() { ## cSpell:Ignore BS_LDE_
  BS_LDE_Caller="${1:?'[libdeque::fn_bs_libdeque_error]: Internal Error: a command name is required'}"

  BS_LIBDEQUE_LAST_ERROR=;
  case $# in
  1)  : "${2:?'[libdeque::fn_bs_libdeque_error]: Internal Error: an error message is required'}" ;;
  2)  BS_LIBDEQUE_LAST_ERROR="$2" ;;
  *)  shift
      case ${IFS-} in
      ' '*) BS_LIBDEQUE_LAST_ERROR="$*" ;;
         *) BS_LIBDEQUE_LAST_ERROR="$1"; shift
            BS_LIBDEQUE_LAST_ERROR="${BS_LIBDEQUE_LAST_ERROR}$(printf ' %s' "$@")" ;;
      esac ;; #<: `case ${IFS-} in`
  esac #<: `case $# in`

  # OUTPUT ERROR
  case ${BS_LIBDEQUE_CONFIG_QUIET_ERRORS:-${BETTER_SCRIPTS_CONFIG_QUIET_ERRORS:-0}} in
  0)  printf '[libdeque::%s]: ERROR: %s\n' \
             "${BS_LDE_Caller}"            \
             "${BS_LIBDEQUE_LAST_ERROR}"   >&2 ;;
  esac

  # ERROR EXCEPTION
  case ${BS_LIBDEQUE_CONFIG_FATAL_ERRORS:-${BETTER_SCRIPTS_CONFIG_FATAL_ERRORS:-0}} in
  0)  ;;
  *)  BS_LIBDEQUE__FatalError=;
      : "${BS_LIBDEQUE__FatalError:?"[libdeque::${BS_LDE_Caller}]: ERROR: ${BS_LIBDEQUE_LAST_ERROR}"}" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libdeque_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_libdeque_invalid_args <CALLER> <MESSAGE>...
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
fn_bs_libdeque_invalid_args() { ## cSpell:Ignore BS_LDIA_
  BS_LDIA_Caller="${1:?'[libdeque::fn_bs_libdeque_invalid_args]: Internal Error: a command name is required'}"
  shift
  fn_bs_libdeque_error "${BS_LDIA_Caller}" 'Invalid Arguments:' "$@"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libdeque_expected`
#;
#; Helper for errors reporting incorrect number of arguments.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libdeque_expected <CALLER> <EXPECTED>...
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
fn_bs_libdeque_expected() { ## cSpell:Ignore BS_LDExpected_
   BS_LDExpected_Caller="${1:?'[libdeque::fn_bs_libdeque_expected]: Internal Error: a command name is required'}"
  BS_LDExpected_Message="Invalid Arguments: expected ${2:?'[libdeque::fn_bs_libdeque_expected]: Internal Error: an expected argument is required'}"

  case $# in
  2)  ;;
  *)  shift; shift
      while : #< [ $# -gt 1 ]
      do
        #> LOOP TEST --------------
        case $# in 1) break ;; esac #< [ $# -gt 1 ]
        #> ------------------------

        BS_LDExpected_Message="${BS_LDExpected_Message}, $1"
        shift
      done #<: `while : #< [ $# -gt 1 ]`
      BS_LDExpected_Message="${BS_LDExpected_Message}, and $1";;
  esac #<: `case $# in`

  fn_bs_libdeque_invalid_args  \
    "${BS_LDExpected_Caller}"  \
    "${BS_LDExpected_Message}"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libdeque_validate_name`
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
#;     fn_bs_libdeque_validate_name <CALLER> <NAME>
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
fn_bs_libdeque_validate_name() { ## cSpell:Ignore BS_LDVN_
  BS_LDVN_Caller="${1:?'[libdeque::fn_bs_libdeque_validate_name]: Internal Error: a command name is required'}"
    BS_LDVN_Name="${2?'[libdeque::fn_bs_libdeque_validate_name]: Internal Error: a variable name is required'}"

  case ${BS_LDVN_Name:-#} in
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libdeque_invalid_args \
      "${BS_LDVN_Caller}"     \
      "invalid variable name '${BS_LDVN_Name}'"
    return "${c_BS_LIBDEQUE__EX_USAGE}" ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_libdeque_validate_name_hyphen`
#;
#; Similar to [`fn_bs_libdeque_validate_name`](#fn_bs_libdeque_validate_name)
#; but additionally allows the name to be `-` (`<hyphen>`), which implies
#; that `STDOUT` or `STDIN` should in place of the variable be used as
#; appropriate.
#;
#; See [`fn_bs_libdeque_validate_name`](#fn_bs_libdeque_validate_name) for more
#; details.
#;
#_______________________________________________________________________________
fn_bs_libdeque_validate_name_hyphen() { ## cSpell:Ignore BS_LDVNH_
  BS_LDVNH_Caller="${1:?'[libdeque::fn_bs_libdeque_validate_name_hyphen]: Internal Error: a command name is required'}"
    BS_LDVNH_Name="${2?'[libdeque::fn_bs_libdeque_validate_name_hyphen]: Internal Error: a variable name is required'}"

  #---------------------------------------------------------
  # This command is called for many of the main commands.
  # To avoid an additional command call the test from
  # `fn_bs_libdeque_validate_name` is duplicated here
  case ${BS_LDVNH_Name:-#} in
  -) : ;;
  [0123456789]*|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*)
    fn_bs_libdeque_invalid_args \
      "${BS_LDVNH_Caller}"      \
      "invalid variable name '${BS_LDVNH_Name}'"
    return "${c_BS_LIBDEQUE__EX_USAGE}" ;;
  esac
}

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
#; ### `fn_bs_libdeque_quote`
#;
#; Safely quote a value so it can, for example, be used in an `eval` command.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_libdeque_quote <VALUE>
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
fn_bs_libdeque_quote() { ## cSpell:Ignore BS_LDQ_
  {
    printf '%s\n' "${1?'[libdeque::fn_bs_libdeque_quote]: Internal Error: a value to quote is required'}"
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
            \$s/\$/'/" -
  }
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_push_impl`
#;
#; Add one or more values to one end of a deque.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     bs_fn_libdeque_push_impl <CALLER> <FLAG> <DEQUE> [<VALUE>...]
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
#; : If `1` (`<one>`) adds to the _front_ of the deque,
#;   if `0` (`<zero>`) adds to the _back_ of the deque.
#;
#; `DEQUE` \[in:ref]
#;
#; : Variable containing a deque.
#; : MUST be a valid _POSIX.1_ name.
#; : Can reference an empty deque or `unset` variable
#;   (a new deque will be created).
#; : If specified as `-` (`<hyphen>`) deque is written to
#;   `STDOUT`.
#;
#; `VALUE` \[in]
#;
#; : Can contain any arbitrary text excluding any
#;   embedded `\0` (`<NUL>`) characters.
#; : Can be null.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Each `VALUE` is added to the deque in turn, i.e. the _last_ `VALUE`
#;   specified will be the _last_ added and will be the _first_ value removed
#;   from that end of the deque.
#;
#_______________________________________________________________________________
bs_fn_libdeque_push_impl() { ## cSpell:Ignore BS_LDPushImpl_
  BS_LDPushImpl_PushFront="${1:?'[libdeque::bs_fn_libdeque_push_impl]: Internal Error: a flag is required'}"
  shift;
  BS_LDPushImpl_Caller="${1:?'[libdeque::bs_fn_libdeque_push_impl]: Internal Error: a command name is required'}"
  shift;

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in
  0)  fn_bs_libdeque_expected                    \
        "${BS_LDPushImpl_Caller}"                \
        "a ${BS_LDPushImpl_Caller%%_*} variable" \
        'zero or more values to add'
      return "${c_BS_LIBDEQUE__EX_USAGE}" ;;
  *)  BS_LDPushImpl_refDeque="$1"
      shift ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  fn_bs_libdeque_validate_name_hyphen \
    "${BS_LDPushImpl_Caller}"         \
    "${BS_LDPushImpl_refDeque}"       || return $?

  #---------------------------------------------------------
  # Unpack
  #---------------------------------------------------------
  BS_LDPushImpl_Deque=;
  eval "BS_LDPushImpl_Deque=\"\${${BS_LDPushImpl_refDeque}-}\""

  #---------------------------------------------------------
  # Push
  #
  # NOTES:
  #
  # - To try to maximize performance the loop is repeated
  #   for each of the possible combinations of settings, 
  #   this is not ideal, but should be faster.
  #
  # TODO: This might be better split into one function per
  #       combination of settings. Probably not going to
  #       do much to the performance, but worth testing.
  #---------------------------------------------------------
  case ${BS_LDPushImpl_PushFront}:${c_BS_LIBDEQUE_CFG_USE__SaferDeque} in
    # PUSH: FRONT; SAFER
    1:1)  for BS_LDPushImpl_Value
          do
            case ${BS_LDPushImpl_Value} in
            *"'"*) BS_LDPushImpl_Value="$(fn_bs_libdeque_quote "${BS_LDPushImpl_Value}")" ;;
                *) BS_LDPushImpl_Value="'${BS_LDPushImpl_Value}'"                         ;;
            esac
            BS_LDPushImpl_Deque="${c_BS_LIBDEQUE__ValuePrefix}${BS_LDPushImpl_Value}${c_BS_LIBDEQUE__ValueSuffix}${BS_LDPushImpl_Deque}"
          done ;;

    # PUSH: BACK; SAFER
    0:1)  for BS_LDPushImpl_Value
          do
            case ${BS_LDPushImpl_Value} in
            *"'"*) BS_LDPushImpl_Value="$(fn_bs_libdeque_quote "${BS_LDPushImpl_Value}")" ;;
                *) BS_LDPushImpl_Value="'${BS_LDPushImpl_Value}'"                         ;;
            esac
            BS_LDPushImpl_Deque="${BS_LDPushImpl_Deque}${c_BS_LIBDEQUE__ValuePrefix}${BS_LDPushImpl_Value}${c_BS_LIBDEQUE__ValueSuffix}"
          done ;;

    # PUSH: FRONT; NORMAL
    1:0)  for BS_LDPushImpl_Value
          do
            BS_LDPushImpl_Deque="${c_BS_LIBDEQUE__ValuePrefix}${BS_LDPushImpl_Value}${c_BS_LIBDEQUE__ValueSuffix}${BS_LDPushImpl_Deque}"
          done ;;

    # PUSH: BACK; NORMAL
    0:0)  for BS_LDPushImpl_Value
          do
            BS_LDPushImpl_Deque="${BS_LDPushImpl_Deque}${c_BS_LIBDEQUE__ValuePrefix}${BS_LDPushImpl_Value}${c_BS_LIBDEQUE__ValueSuffix}"
          done ;;
  esac

  #---------------------------------------------------------
  # Save
  #---------------------------------------------------------
  case ${BS_LDPushImpl_refDeque} in
  -) printf '%s\n' "${BS_LDPushImpl_Deque}" ;;
  *) eval "${BS_LDPushImpl_refDeque}=\"\${BS_LDPushImpl_Deque}\"" ;;
  esac
}

#_______________________________________________________________________________
#;---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_push_front`
#;
#; Shorthand for [`bs_fn_libdeque_push_impl 1 ${1+"$@"}`](#bs_fn_libdeque_push_impl)
#;
#_______________________________________________________________________________
bs_fn_libdeque_push_front() { bs_fn_libdeque_push_impl 1 ${1+"$@"};}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_push_back`
#;
#; Shorthand for [`bs_fn_libdeque_push_impl 0 ${1+"$@"}`](#bs_fn_libdeque_push_impl)
#;
#_______________________________________________________________________________
bs_fn_libdeque_push_back () { bs_fn_libdeque_push_impl 0 ${1+"$@"};}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_pop_impl`
#;
#; Remove the value at one end of a deque.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     bs_fn_libdeque_pop_impl <CALLER> <FLAG> <DEQUE> [<OUTPUT>]
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
#; : If `1` (`<one>`) removes from the _front_ of the deque,
#;   if `0` (`<zero>`) removes from the _back_ of the deque.
#;
#; `DEQUE` \[in:ref]
#;
#; : Variable containing a deque.
#; : MUST be a valid _POSIX.1_ name.
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable that will contain the element value.
#; : Any current contents will be lost.
#; : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#; : If not specified value is removed without being
#;   stored/written to any location.
#;
#; _NOTES_
#; <!-- -->
#;
#; - If `DEQUE` is empty the exit status will be `1` (`<one>`).
#;
#_______________________________________________________________________________
bs_fn_libdeque_pop_impl() { ## cSpell:Ignore BS_LDPopImpl_
  BS_LDPopImpl_PopFront="${1:?'[libdeque::bs_fn_libdeque_pop_impl]: Internal Error: a flag is required'}"
  shift
  BS_LDPopImpl_Caller="${1:?'[libdeque::bs_fn_libdeque_pop_impl]: Internal Error: a command name is required'}"
  shift

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in
  1)  BS_LDPopImpl_refDeque="$1"
      BS_LDPopImpl_refValue=;    ;;
  2)  BS_LDPopImpl_refDeque="$1"
      BS_LDPopImpl_refValue="$2"
      fn_bs_libdeque_validate_name_hyphen \
        "${BS_LDPopImpl_Caller}"          \
        "${BS_LDPopImpl_refValue}"        || return $?;;
  *)  fn_bs_libdeque_expected                   \
        "${BS_LDPopImpl_Caller}"                \
        "a ${BS_LDPopImpl_Caller%%_*} variable" \
        'an output variable (optional)'
      return "${c_BS_LIBDEQUE__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Validate
  #---------------------------------------------------------
  fn_bs_libdeque_validate_name \
    "${BS_LDPopImpl_Caller}"   \
    "${BS_LDPopImpl_refDeque}" || return $?

  #---------------------------------------------------------
  # Unpack
  #---------------------------------------------------------
  BS_LDPopImpl_Deque=;
  eval "BS_LDPopImpl_Deque=\"\${${BS_LDPopImpl_refDeque}-}\""

  #---------------------------------------------------------
  # Pop
  #
  # NOTES:
  #
  # - To try to maximize performance the loop is repeated
  #   for each of the possible combinations of settings, 
  #   this is not ideal, but should be faster.
  #
  # TODO: This might be better split into one function per
  #       combination of settings. Probably not going to
  #       do much to the performance, but worth testing.
  #---------------------------------------------------------

  # SC2295: Expansions inside ${..} need to be quoted
  #         separately, otherwise they will match as
  #         a pattern.
  # EXCEPT: There are no pattern characters in the string
  #         and some shells fail if the match is quoted
  #         (currently `posh` is known to fail - this may
  #          be due to the embedded `\n` (`<newline>`) as
  #          other uses seem ok, note that `posh` is based
  #          on `pdksh`).
  # shellcheck disable=SC2295
  {
    BS_LDPopImpl_Value=;
    case ${BS_LDPopImpl_Deque:+1}:${BS_LDPopImpl_PopFront} in
    1:1)  BS_LDPopImpl_Value="${BS_LDPopImpl_Deque%%${c_BS_LIBDEQUE__ValueSuffix}*}"
          BS_LDPopImpl_Value="${BS_LDPopImpl_Value#${c_BS_LIBDEQUE__ValuePrefix}}"

          BS_LDPopImpl_Deque="${BS_LDPopImpl_Deque#*${c_BS_LIBDEQUE__ValueSuffix}}" ;;

    1:0)  BS_LDPopImpl_Value="${BS_LDPopImpl_Deque##*${c_BS_LIBDEQUE__ValuePrefix}}"
          BS_LDPopImpl_Value="${BS_LDPopImpl_Value%${c_BS_LIBDEQUE__ValueSuffix}}"

          BS_LDPopImpl_Deque="${BS_LDPopImpl_Deque%${c_BS_LIBDEQUE__ValuePrefix}*}" ;;

    0:*)  return 1 ;;
    esac
  }

  #---------------------------------------------------------
  # Remove "safe" quotes
  #---------------------------------------------------------
  case ${BS_LDPopImpl_Value:+1}:${c_BS_LIBDEQUE_CFG_USE__SaferDeque} in
  1:1) eval "BS_LDPopImpl_Value=${BS_LDPopImpl_Value}" ;;
  esac

  #---------------------------------------------------------
  # Save
  #---------------------------------------------------------
  case ${BS_LDPopImpl_refValue} in
   -) eval "${BS_LDPopImpl_refDeque}=\"\${BS_LDPopImpl_Deque}\""
      printf '%s\n' "${BS_LDPopImpl_Value}" ;;
  ?*) eval "${BS_LDPopImpl_refDeque}=\"\${BS_LDPopImpl_Deque}\"
            ${BS_LDPopImpl_refValue}=\"\${BS_LDPopImpl_Value}\"" ;;
  esac
} #< `deque_pop()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_pop_front`
#;
#; Shorthand for [`bs_fn_libdeque_pop_impl 1 ${1+"$@"}`](#bs_fn_libdeque_pop_impl)
#;
#_______________________________________________________________________________
bs_fn_libdeque_pop_front() { bs_fn_libdeque_pop_impl 1 ${1+"$@"};}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_pop_back`
#;
#; Shorthand for [`bs_fn_libdeque_pop_impl 0 ${1+"$@"}`](#bs_fn_libdeque_pop_impl)
#;
#_______________________________________________________________________________
bs_fn_libdeque_pop_back() { bs_fn_libdeque_pop_impl 0 ${1+"$@"};}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_peek_impl`
#;
#; Peek at the value at one end of a deque without removing it.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     bs_fn_libdeque_peek_impl <CALLER> <FLAG> <DEQUE> [<OUTPUT>]
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
#; : If `1` (`<one>`) peeks at the _front_ of the deque,
#;   if `0` (`<zero>`) peeks at the _back_ of the deque.
#;
#; `DEQUE` \[in:ref]
#;
#; : Variable containing a deque.
#; : MUST be a valid _POSIX.1_ name.
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable that will contain the element value.
#; : Any current contents will be lost.
#; : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#; : If not specified, or specified as `-` (`<hyphen>`)
#;   value is written to `STDOUT`.
#;
#; _NOTES_
#; <!-- -->
#;
#; - If `DEQUE` is empty the exit status will be `1` (`<one>`).
#;
#_______________________________________________________________________________
bs_fn_libdeque_peek_impl() { ## cSpell:Ignore BS_LDPeekImpl_
  BS_LDPeekImpl_PeekFront="${1:?'[libdeque::bs_fn_libdeque_peek_impl]: Internal Error: a flag is required'}"
  shift;
  BS_LDPeekImpl_Caller="${1?'[libdeque::bs_fn_libdeque_peek_impl]: Internal Error: a command name is required'}"
  shift;

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in
  1)  BS_LDPeekImpl_refQueue="$1"
      BS_LDPeekImpl_refValue='-' ;;
  2)  BS_LDPeekImpl_refQueue="$1"
      BS_LDPeekImpl_refValue="$2"
      fn_bs_libdeque_validate_name_hyphen \
        "${BS_LDPeekImpl_Caller}"         \
        "${BS_LDPeekImpl_refValue}"       || return $?;;
  *)  fn_bs_libdeque_expected                    \
        "${BS_LDPeekImpl_Caller}"                \
        "a ${BS_LDPeekImpl_Caller%%_*} variable" \
        'an output variable (optional)'
      return "${c_BS_LIBDEQUE__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Validate
  #---------------------------------------------------------
  fn_bs_libdeque_validate_name  \
    "${BS_LDPeekImpl_Caller}"   \
    "${BS_LDPeekImpl_refQueue}" || return $?

  #---------------------------------------------------------
  # Unpack
  #---------------------------------------------------------
  BS_LDPeekImpl_Queue=;
  eval "BS_LDPeekImpl_Queue=\"\${${BS_LDPeekImpl_refQueue}-}\""

  #---------------------------------------------------------
  # Peek
  #---------------------------------------------------------
  # SC2295: Expansions inside ${..} need to be quoted
  #         separately, otherwise they will match as
  #         a pattern.
  # EXCEPT: There are no pattern characters in the string
  #         and some shells fail if the match is quoted
  #         (currently `posh` is known to fail - this may
  #          be due to the embedded `\n` (`<newline>`) as
  #          other uses seem ok, note that `posh` is based
  #          on `pdksh`).
  # shellcheck disable=SC2295
  {
    BS_LDPeekImpl_Value=;
    case ${BS_LDPeekImpl_Queue:+1}:${BS_LDPeekImpl_PeekFront} in
    1:1)  BS_LDPeekImpl_Value="${BS_LDPeekImpl_Queue%%${c_BS_LIBDEQUE__ValueSuffix}*}"
          BS_LDPeekImpl_Value="${BS_LDPeekImpl_Value#${c_BS_LIBDEQUE__ValuePrefix}}" ;;

    1:0)  BS_LDPeekImpl_Value="${BS_LDPeekImpl_Queue##*${c_BS_LIBDEQUE__ValuePrefix}}"
          BS_LDPeekImpl_Value="${BS_LDPeekImpl_Value%${c_BS_LIBDEQUE__ValueSuffix}}" ;;

    0:*)  return 1 ;;
    esac
  }

  #---------------------------------------------------------
  # Remove "safe" quotes
  #---------------------------------------------------------
  case ${BS_LDPeekImpl_Value:+1}:${c_BS_LIBDEQUE_CFG_USE__SaferDeque} in
  1:1) eval "BS_LDPeekImpl_Value=${BS_LDPeekImpl_Value}" ;;
  esac

  #---------------------------------------------------------
  # Save
  #---------------------------------------------------------
  case ${BS_LDPeekImpl_refValue} in
  -) printf '%s\n' "${BS_LDPeekImpl_Value}" ;;
  *) eval "${BS_LDPeekImpl_refValue}=\"\${BS_LDPeekImpl_Value}\"" ;;
  esac
} #< `bs_fn_libdeque_peek_impl()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_peek_front`
#;
#; Shorthand for [`bs_fn_libdeque_peek_impl 1 ${1+"$@"}`](#bs_fn_libdeque_peek_impl)
#;
#_______________________________________________________________________________
bs_fn_libdeque_peek_front() { bs_fn_libdeque_peek_impl 1 ${1+"$@"};}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_peek_back`
#;
#; Shorthand for [`bs_fn_libdeque_peek_impl 0 ${1+"$@"}`](#bs_fn_libdeque_peek_impl)
#;
#_______________________________________________________________________________
bs_fn_libdeque_peek_back() { bs_fn_libdeque_peek_impl 0 ${1+"$@"};}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_deque_size`
#;
#; Get the number of entries in a deque.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     bs_fn_libdeque_deque_size <CALLER> <DEQUE> [<OUTPUT>]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `DEQUE` \[in:ref]
#;
#; : Variable that may contain a deque.
#; : MUST be a valid _POSIX.1_ name.
#; : Can reference an empty deque or `unset` variable.
#;
#; `OUTPUT` \[out:ref]
#;
#; : Variable that will contain the size.
#; : Any current contents will be lost.
#; : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#; : If not specified, or specified as `-` (`<hyphen>`)
#;   value is written to `STDOUT`.
#;
#; _NOTES_
#; <!-- -->
#;
#; - Though it is not likely to be noticeable in most use cases, this is a
#;   relatively slow operation; it is advisable to not use this if
#;   avoidable, particularly if performance is important.
#; - An empty `DEQUE` should always be represented by an empty variable -
#;   (i.e. normal empty variable checks can be used to test for this).
#;
#_______________________________________________________________________________
bs_fn_libdeque_deque_size() { ## cSpell:Ignore BS_LDDSize_
  BS_LDDSize_Caller="${1?'[libdeque::bs_fn_libdeque_deque_size]: Internal Error: a command name is required'}"
  shift;

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in
  1)  BS_LDDSize_refDeque="$1"
       BS_LDDSize_refSize='-' ;;
  2)  BS_LDDSize_refDeque="$1"
       BS_LDDSize_refSize="$2"
      fn_bs_libdeque_validate_name_hyphen \
        "${BS_LDDSize_Caller}"            \
        "${BS_LDDSize_refSize}"           || return $?;;
  *)  fn_bs_libdeque_expected                 \
        "${BS_LDDSize_Caller}"                \
        "a ${BS_LDDSize_Caller%%_*} variable" \
        'an output variable (optional)'
      return "${c_BS_LIBDEQUE__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Validate
  #---------------------------------------------------------
  fn_bs_libdeque_validate_name \
    "${BS_LDDSize_Caller}"     \
    "${BS_LDDSize_refDeque}"   || return $?

  #---------------------------------------------------------
  # Unpack
  #---------------------------------------------------------
  BS_LDDSize_Deque=;
  eval "BS_LDDSize_Deque=\"\${${BS_LDDSize_refDeque}-}\"" || return $?

  #---------------------------------------------------------
  # Test
  #
  # NOTES:
  #
  # - Easiest way to check size is to use `grep -c` which
  #   counts the matches and look for either the value
  #   prefix or suffix values (of which there are one per
  #   entry).
  # - If the value searched for contains `\n` (`<newline>`)
  #   characters `grep` behaves differently and the count
  #   is much larger than expected (even when `-F` is used).
  #---------------------------------------------------------
  case ${BS_LDDSize_Deque:+1} in
  1)  BS_LDDSize_Size="$(
          {
            printf '%s\n' "${BS_LDDSize_Deque}"
          } | {
            grep -F -c -e "${c_BS_LIBDEQUE__Prefix}" -
          }
        )" || return $? ;;
  *)  BS_LDDSize_Size=0 ;;
  esac

  #---------------------------------------------------------
  # Save
  #---------------------------------------------------------
  case ${BS_LDDSize_refSize} in
  -) printf '%s\n' "${BS_LDDSize_Size}" ;;
  *) eval "${BS_LDDSize_refSize}=\"\${BS_LDDSize_Size}\"" ;;
  esac
} #< `bs_fn_libdeque_deque_size()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `bs_fn_libdeque_is_deque_like`
#;
#; Determine if a variable looks like it contains deque like data.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     bs_fn_libdeque_is_deque_like <CALLER> <DEQUE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `CALLER` \[in]
#;
#; : Name of the calling command.
#; : Used for any error message.
#;
#; `DEQUE` \[in:ref]
#;
#; : Variable that may contain a deque,
#;   a queue, or a stack.
#; : MUST be a valid _POSIX.1_ name.
#;
#; _NOTES_
#; <!-- -->
#;
#; - The stack and queue types are specializations of a deque and have the same
#;   internal format; it is _not_ currently possible to differentiate between
#;   the three types.
#; - An empty or unset `DEQUE` is _not_ a valid deque.
#; - Exit status will be `0` (`<zero>`) if `DEQUE` appears to be a valid stack,
#;   a queue, or deque while the exit status will be `1` (`<one>`) in all other
#;   (non-error) cases.
#;
#_______________________________________________________________________________
bs_fn_libdeque_is_deque_like() { ## cSpell:Ignore BS_LDIDL_
  BS_LDIDL_Caller="${1?'[libdeque::bs_fn_libdeque_is_deque_like]: Internal Error: a command name is required'}"
  shift;

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in
  1)  BS_LDIDL_refDeque="$1" ;;
  *)  fn_bs_libdeque_expected \
        "${BS_LDIDL_Caller}"  \
        "a ${BS_LDIDL_Caller%%_*} variable"
      return "${c_BS_LIBDEQUE__EX_USAGE}" ;;
  esac #<: `case $# in`

  #---------------------------------------------------------
  # Validate
  #---------------------------------------------------------
  fn_bs_libdeque_validate_name \
    "${BS_LDIDL_Caller}"       \
    "${BS_LDIDL_refDeque}"     || return $?

  #---------------------------------------------------------
  # Unpack
  #---------------------------------------------------------
  BS_LDIDL_Deque=;
  eval "BS_LDIDL_Deque=\"\${${BS_LDIDL_refDeque}-}\"" || return $?

  #---------------------------------------------------------
  # Test
  #---------------------------------------------------------
  case ${BS_LDIDL_Deque} in
  "${c_BS_LIBDEQUE__ValuePrefix}"*"${c_BS_LIBDEQUE__ValueSuffix}") return 0 ;;
                                                                *) return 1 ;;
  esac
} #< `bs_fn_libdeque_is_deque_like()`

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
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ### DEQUE
#:
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_push_back`
#:
#: Add one or more values to the _back_ of a deque.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_push_back <DEQUE> <VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[out:ref]
#:
#: : Variable containing a deque.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty deque or `unset` variable
#:   (a new deque will be created).
#: : If specified as `-` (`<hyphen>`) deque is written to
#:   `STDOUT`.
#:
#: `VALUE` \[in]
#:
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : Can be null.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     deque_push_back MyDeque "$@"
#:
#_______________________________________________________________________________
deque_push_back() { bs_fn_libdeque_push_back 'deque_push_back' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_pop_back`
#:
#: Remove a value from the _back_ of a deque.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_pop_back <DEQUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[in:ref]
#:
#: : Variable containing a deque.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the element value.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If specified as `-` (`<hyphen>`) value is written to,
#:   `STDOUT`
#: : If not specified value is not written to any location.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     while deque_pop_back MyDeque MyVar
#:     do
#:       ...
#:     done
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `DEQUE` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
deque_pop_back() { bs_fn_libdeque_pop_back 'deque_pop_back' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_push_front`
#:
#: Add one or more values to the _front_ of a deque.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_push_front <DEQUE> <VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[out:ref]
#:
#: : Variable containing a deque.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty deque or `unset` variable
#:   (a new deque will be created).
#: : If specified as `-` (`<hyphen>`) deque is written to
#:   `STDOUT`.
#:
#: `VALUE` \[in]
#:
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : Can be null.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     deque_push_front MyDeque "$@"
#:
#_______________________________________________________________________________
deque_push_front() { bs_fn_libdeque_push_front 'deque_push_front' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_pop_front`
#:
#: Remove a value from the _front_ of a deque.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_pop_front <DEQUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[in:ref]
#:
#: : Variable containing a deque.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the element value.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If specified as `-` (`<hyphen>`) value is written to,
#:   `STDOUT`
#: : If not specified value is not written to any location.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     while deque_pop_front MyDeque MyVar
#:     do
#:       ...
#:     done
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `DEQUE` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
deque_pop_front() { bs_fn_libdeque_pop_front 'deque_pop_front' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_push`
#:
#: Alias for [`deque_push_back`](#deque_push_back)
#:
#: ---------------------------------------------------------
#:
#: #### `deque_pop`
#:
#: Alias for [`deque_pop_back`](#deque_pop_back)
#:
#: ---------------------------------------------------------
#:
#: #### `deque_unshift`
#:
#: Alias for [`deque_push_front`](#deque_push_front)
#:
#: ---------------------------------------------------------
#:
#: #### `deque_shift`
#:
#: Alias for [`deque_pop_front`](#deque_pop_front)
#:
#_______________________________________________________________________________
deque_push   () { bs_fn_libdeque_push_back  'deque_push'    ${1+"$@"}; }
deque_pop    () { bs_fn_libdeque_pop_back   'deque_pop'     ${1+"$@"}; }
deque_unshift() { bs_fn_libdeque_push_front 'deque_unshift' ${1+"$@"}; }
deque_shift  () { bs_fn_libdeque_pop_front  'deque_shift'   ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_peek_back`
#:
#: Get the value from the _back_ of a deque without removing it.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_peek_back <DEQUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[in:ref]
#:
#: : Variable containing a deque.
#: : MUST be a valid _POSIX.1_ name.
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
#:     deque_peek_back 'MyDeque' 'MyVar'
#:     MyVar="$(deque_peek_back 'MyDeque' )"
#:     MyVar="$(deque_peek_back 'MyDeque' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `DEQUE` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
deque_peek_back() { bs_fn_libdeque_peek_back 'deque_peek_back' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_peek_front`
#:
#: Get the value from the _front_ of a deque without removing it.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_peek_front <DEQUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[in:ref]
#:
#: : Variable containing a deque.
#: : MUST be a valid _POSIX.1_ name.
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
#:     deque_peek_front 'MyDeque' 'MyVar'
#:     MyVar="$(deque_peek_front 'MyDeque' )"
#:     MyVar="$(deque_peek_front 'MyDeque' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `DEQUE` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
deque_peek_front() { bs_fn_libdeque_peek_front 'deque_peek_front' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_back`
#:
#: Alias for [`deque_peek_back`](#deque_peek_back)
#:
#: ---------------------------------------------------------
#:
#: #### `deque_front`
#:
#: Alias for [`deque_peek_front`](#deque_peek_front)
#:
#_______________________________________________________________________________
deque_back () { bs_fn_libdeque_peek_back  'deque_back'  ${1+"$@"}; }
deque_front() { bs_fn_libdeque_peek_front 'deque_front' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_size`
#:
#: Get the number of entries in a deque.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_size <DEQUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[in:ref]
#:
#: : Variable that may contain a deque.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty deque or `unset` variable.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the size.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   value is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     deque_size 'MyDeque' 'MySize'
#:     MySize="$(deque_size 'MyDeque' )"
#:     MySize="$(deque_size 'MyDeque' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Though it is not likely to be noticeable in most use cases, this is a
#:   relatively slow operation; it is advisable to not use this if
#:   avoidable, particularly if performance is important.
#: - An empty `DEQUE` should always be represented by an empty variable -
#:   (i.e. normal empty variable checks can be used to test for this).
#:
#_______________________________________________________________________________
deque_size() { bs_fn_libdeque_deque_size 'deque_size' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `deque_is_deque_like`
#:
#: Determine if a variable looks like it contains deque like data.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     deque_is_deque_like <DEQUE>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `DEQUE` \[in:ref]
#:
#: : Variable that may contain a deque.
#: : MUST be a valid _POSIX.1_ name.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if deque_is_deque_like 'Variable'; then ...; fi
#:
#: _NOTES_
#: <!-- -->
#:
#: - The stack and queue types are specializations of a deque and have the same
#:   internal format; it is _not_ possible to differentiate between the three
#:   types.
#: - An empty or unset `DEQUE` is _not_ a valid deque.
#: - Exit status will be `0` (`<zero>`) if `DEQUE` appears to be a valid stack,
#:   a queue, or deque while the exit status will be `1` (`<one>`) in all other
#:   (non-error) cases.
#:
#_______________________________________________________________________________
deque_is_deque_like() { bs_fn_libdeque_is_deque_like 'deque_is_deque_like' ${1+"$@"}; }

#===============================================================================
#===============================================================================
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ### QUEUE
#:
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `queue_push`
#:
#: Push one or more values onto a queue.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     queue_push <QUEUE> <VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `QUEUE` \[out:ref]
#:
#: : Variable containing a queue.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty queue or `unset` variable
#:   (a new queue will be created).
#: : If specified as `-` (`<hyphen>`) queue is written to
#:   `STDOUT`.
#:
#: `VALUE` \[in]
#:
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : Can be null.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     queue_push MyQueue "$@"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Each `VALUE` is pushed to the queue in turn, i.e. the _first_ `VALUE`
#:   specified will be the _first_ value popped from the resulting queue.
#:
#_______________________________________________________________________________
queue_push() { bs_fn_libdeque_push_front 'queue_push' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `queue_pop`
#:
#: Remove a value from a queue.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     queue_pop <QUEUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `QUEUE` \[in:ref]
#:
#: : Variable containing a deque.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the element value.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If specified as `-` (`<hyphen>`) value is written to,
#:   `STDOUT`
#: : If not specified value is not written to any location.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     while queue_pop MyQueue MyVar
#:     do
#:       ...
#:     done
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `QUEUE` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
queue_pop() { bs_fn_libdeque_pop_back 'queue_pop' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `queue_peek`
#:
#: Get the next value from the queue without removing it.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     queue_peek <QUEUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `QUEUE` \[in:ref]
#:
#: : Variable containing a queue.
#: : MUST be a valid _POSIX.1_ name.
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
#:     queue_peek 'MyQueue' 'MyVar'
#:     MyVar="$(queue_peek 'MyQueue' )"
#:     MyVar="$(queue_peek 'MyQueue' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `QUEUE` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
queue_peek() { bs_fn_libdeque_peek_back 'queue_peek' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `queue_size`
#:
#: Get the number of entries in a queue.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     queue_size <QUEUE> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `QUEUE` \[in:ref]
#:
#: : Variable that may contain a queue.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty queue or `unset` variable.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the size.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   value is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     queue_size 'MyQueue' 'MySize'
#:     MySize="$(queue_size 'MyQueue' )"
#:     MySize="$(queue_size 'MyQueue' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Though it is not likely to be noticeable in most use cases, this is a
#:   relatively slow operation; it is advisable to not use this if
#:   avoidable, particularly if performance is important.
#: - An empty `QUEUE` should always be represented by an empty variable -
#:   (i.e. normal empty variable checks can be used to test for this).
#:
#_______________________________________________________________________________
queue_size() { bs_fn_libdeque_deque_size 'queue_size' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `queue_is_queue_like`
#:
#: Determine if a variable looks like it contains queue like data.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     queue_is_queue_like <QUEUE>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `QUEUE` \[in:ref]
#:
#: : Variable that may contain a queue.
#: : MUST be a valid _POSIX.1_ name.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if queue_is_queue_like 'Variable'; then ...; fi
#:
#: _NOTES_
#: <!-- -->
#:
#: - A queue is a specialization of a deque and has the same internal format as
#:   both a deque and a stack; it is _not_ possible to differentiate between the
#:   three types.
#: - An empty or unset `QUEUE` is _not_ a valid queue.
#: - Exit status will be `0` (`<zero>`) if `QUEUE` appears to be a valid stack,
#:   a queue, or deque while the exit status will be `1` (`<one>`) in all other
#:   (non-error) cases.
#:
#_______________________________________________________________________________
queue_is_queue_like() { bs_fn_libdeque_is_deque_like 'queue_is_queue_like' ${1+"$@"}; }

#===============================================================================
#===============================================================================
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ### STACK
#:
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `stack_push`
#:
#: Push one or more values onto a stack.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     stack_push <STACK> <VALUE>...
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `STACK` \[out:ref]
#:
#: : Variable containing a stack.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty stack or `unset` variable
#:   (a new stack will be created).
#: : If specified as `-` (`<hyphen>`) stack is written to
#:   `STDOUT`.
#:
#: `VALUE` \[in]
#:
#: : Can contain any arbitrary text excluding any
#:   embedded `\0` (`<NUL>`) characters.
#: : Can be null.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     stack_push DirStack "$PWD"
#:     cd '/tmp'
#:     ...
#:     stack_pop DirStack OldDir
#:     cd "$OldDir"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Each `VALUE` is pushed to the stack in turn, i.e. the _last_ `VALUE`
#:   specified will be the _top_ of the resulting stack.
#:
#_______________________________________________________________________________
stack_push() { bs_fn_libdeque_push_front 'stack_push' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `stack_pop`
#:
#: Remove the value from the top of a stack.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     stack_pop <STACK> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `STACK` \[out:ref]
#:
#: : Variable containing a stack.
#: : MUST be a valid _POSIX.1_ name.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the element value.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If specified as `-` (`<hyphen>`) value is written to,
#:   `STDOUT`
#: : If not specified value is not written to any location.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     while stack_pop MyStack MyVar
#:     do
#:       ...
#:     done
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `STACK` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
stack_pop() { bs_fn_libdeque_pop_front 'stack_pop' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `stack_peek`
#:
#: Get the value from the top of the stack without removing it.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     stack_peek <STACK> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `STACK` \[in:ref]
#:
#: : Variable containing a stack.
#: : MUST be a valid _POSIX.1_ name.
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
#:     stack_peek 'MyStack' 'MyVar'
#:     MyVar="$(stack_peek 'MyStack' )"
#:     MyVar="$(stack_peek 'MyStack' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - If `STACK` is empty the exit status will be `1` (`<one>`).
#: - If value is output to `STDOUT` data _may_ be lost if the value ends with a
#:   `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
#:   from the end of output generated by commands).
#:
#_______________________________________________________________________________
stack_peek() { bs_fn_libdeque_peek_front 'stack_peek' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `stack_size`
#:
#: Get the number of entries in a stack.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     stack_size <STACK> [<OUTPUT>]
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `STACK` \[in:ref]
#:
#: : Variable that may contain a stack.
#: : MUST be a valid _POSIX.1_ name.
#: : Can reference an empty stack or `unset` variable.
#:
#: `OUTPUT` \[out:ref]
#:
#: : Variable that will contain the size.
#: : Any current contents will be lost.
#: : MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
#: : If not specified, or specified as `-` (`<hyphen>`)
#:   value is written to `STDOUT`.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     stack_size 'MyStack' 'MySize'
#:     MySize="$(stack_size 'MyStack' )"
#:     MySize="$(stack_size 'MyStack' -)"
#:
#: _NOTES_
#: <!-- -->
#:
#: - Though it is not likely to be noticeable in most use cases, this is a
#:   relatively slow operation; it is advisable to not use this if
#:   avoidable, particularly if performance is important.
#: - An empty `STACK` should always be represented by an empty variable -
#:   (i.e. normal empty variable checks can be used to test for this).
#:
#_______________________________________________________________________________
stack_size() { bs_fn_libdeque_deque_size 'stack_size' ${1+"$@"}; }

#_______________________________________________________________________________
#: ---------------------------------------------------------
#:
#: #### `stack_is_stack_like`
#:
#: Determine if a variable looks like it contains stack like data.
#:
#: _SYNOPSIS_
#: <!-- - -->
#:
#:     stack_is_stack_like <STACK>
#:
#: _ARGUMENTS_
#: <!-- -- -->
#:
#: `STACK` \[in:ref]
#:
#: : Variable that may contain a stack.
#: : MUST be a valid _POSIX.1_ name.
#:
#: _EXAMPLES_
#: <!-- - -->
#:
#:     if stack_is_stack_like 'Variable'; then ...; fi
#:
#: _NOTES_
#: <!-- -->
#:
#: - A stack is a specialization of a deque and has the same internal format as
#:   both a deque and a queue; it is _not_ possible to differentiate between the
#:   three types.
#: - An empty or unset `STACK` is _not_ a valid stack.
#: - Exit status will be `0` (`<zero>`) if `STACK` appears to be a valid stack,
#:   a queue, or deque while the exit status will be `1` (`<one>`) in all other
#:   (non-error) cases.
#:
#_______________________________________________________________________________
stack_is_stack_like() { bs_fn_libdeque_is_stack_like 'stack_is_stack_like' ${1+"$@"}; }

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
*a*) set +a; BS_LIBDEQUE_SOURCED=1; set -a ;;
  *)         BS_LIBDEQUE_SOURCED=1         ;;
esac

fn_bs_libdeque_readonly 'BS_LIBDEQUE_SOURCED'

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
#: - The data types `deque`, `queue` and `stack` are very efficient, and are
#:   likely the best choice for storing data where it only needs accessed
#:   sequentially. (This is probably true even for iterating over all values
#:   where it may seem like converting to another format (e.g. an emulated
#:   array) would be better).
#: - With the exception of commands dealing with size, _all_ commands are
#:   implemented entirely using shell builtins (i.e. require no external
#:   utilities), making them very fast.
#: - Internally all queues or stacks are specializations of deque and use the
#:   same data format; it is possible to use any of the commands with any of
#:   the types regardless of which command was used for creation. The different
#:   interfaces are provided so that specific use cases are easier to write and
#:   understand. For example, if emulating `pushd`/`popd` it makes more sense to
#:   use a stack than a deque, and using a stack makes such use easier to
#:   understand, even if the underlying type is the same.
#: - Modification of a deque, queue or stack outside of the library is _not_
#:   supported.
#: - Argument validation occurs where possible and (relatively) performant for
#:   all arguments to all commands.
#: - A deque, queue or stack can be serialized (e.g. saved to, or loaded from,
#:   a file). However, each deque is _only_ supported by the library version
#:   used to created it - the internal format for a deque _may_ change between
#:   versions without notice.
#: - While any data can be stored in the available formats, performance will
#:   scale with the size of data stored (though the specifics will depend upon
#:   the platform and environment).
#:
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## IMPLEMENTATION NOTES
#. <!-- -------------- -->
#.
#. - Commands with the prefix 'fn_bs_' and variables the prefix 'c_BS_' or
#.   'g_BS_' are for implementation of the provided commands, are subject to
#.   change or removal and are not intended for external use.
#. - Internal commands do not perform the same level of parameter validation as
#.   external commands. The caller is expected to have already validated the
#.   parameters.
#.
#. ### INTERNAL FORMAT
#. <!-- ---------- -->
#.
#. Each entry is given a prefix and suffix that should be unlikely to appear in
#. any normal data. These, then, delimit the values and can be located, and
#. manipulated using ["Parameter Expansion"][posix_param_expansion] making these
#. operations very fast (relative to invoking an external command).
#.
#. Currently all the provided types are implemented as deques, with queues and
#. stacks simply having more appropriate interfaces for those types, but
#. maintaining a deque for actual storage. In most cases this works well and
#. has few issues, however there are some places where a different structure
#. might be preferable, for example, size operations for a stack could be made
#. far faster by storing a size as part of the value prefix (this works only
#. when all access occurs at one end of the structure).
#.
#. **_Note: the internal format is subject to change._**
#.
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## CAVEATS
#:
#: _The internal structure of a `deque`, `queue`, or `stack` is subject to
#:  change without notice and should not be relied upon. In particular,
#:  currently all three types are interchangeable (e.g. a `stack` can be used
#:  with commands for a `queue`, etc.), however, this should not be assumed:
#:  types should always be used only with the commands for the specific type._
#:
#: The maximum size of any deque, queue or stack is limited by the environment
#: in which it is used, specifically they will not be able to exceed the
#: command line length limit, though other limitations may also exist.
#:
#: Note that exporting a variable containing any deque, queue or stack will
#: cause that variable to be counted against the command line length limit
#: **TWICE** (for any library operations).
#:
#: _For more details see the common suite [documentation](./README.MD#caveats)._
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## EXAMPLE
#:
#:     g_DirectoryStack=;
#:     pushd() {
#:        stack_push g_DirectoryStack "$PWD"
#:        cd "$1"
#:     }
#:     popd() {
#:        stack_pop g_DirectoryStack "PushedDirectory"
#:        cd "$PushedDirectory"
#:     }
#:
#: Note that emulation of `pushd`/`popd` in this way requires ensuring _both_
#: operations occur within the same subshell, or it will not work as expected.
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
