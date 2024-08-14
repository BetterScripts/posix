#!/usr/bin/env false
# SPDX-License-Identifier: MPL-2.0
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts '.testwrapper': Wrapper for BetterScripts POSIX Suite        *#
#*                               library tests, providing common              *#
#*                               functionality.                               *#
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

################################## TESTWRAPPER #################################
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
## cSpell:Ignore testrunner testwrapper
################################ DOCUMENTATION #################################
#
#% % testwrapper(7) BetterScripts | Test wrapper for BetterScripts POSIX Suite.
#% % BetterScripts (better.scripts@proton.me)
#
#: <!-- #################################################################### -->
#: <!-- ########### THIS FILE WAS GENERATED FROM 'testwrapper.sh' ########## -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # TESTWRAPPER
#:
#:
#  Provides test function helpers and runs individual tests.
#
#  Not intended to be invoked directly; use `testrunner.sh`
#
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
# EXCEPT: Triggered in numerous places where the value **is** used, but in a   #
#+        construct shellcheck does not correctly parse.                       #
# shellcheck disable=SC2034                                                    #
#                                                                              #
################################################################################

#===============================================================================
#===============================================================================
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## ENVIRONMENT
#:
#===============================================================================
#===============================================================================

#===========================================================
#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### INFORMATIONAL
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
#: #### `BS_TESTWRAPPER_VERSION_MAJOR`
#:
#: - Integer >= 1.
#: - Incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_TESTWRAPPER_VERSION_MINOR`
#:
#: - Integer >= 0.
#: - Incremented for significant changes that do not
#:   break compatibility with previous versions.
#: - Reset to 0 when
#:   [`BS_TESTWRAPPER_VERSION_MAJOR`](#bs_libgetargs_version_major)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_TESTWRAPPER_VERSION_PATCH`
#:
#: - Integer >= 0.
#: - Incremented for minor revisions or bugfixes.
#: - Reset to 0 when
#:   [`BS_TESTWRAPPER_VERSION_MINOR`](#bs_libgetargs_version_minor)
#:   changes.
#:
#: ---------------------------------------------------------
#:
#: #### `BS_TESTWRAPPER_VERSION_RELEASE`
#:
#: - A string indicating a pre-release version, always
#:   null for full-release versions.
#: - Possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended).
#:
  BS_TESTWRAPPER_VERSION_MAJOR=1
  BS_TESTWRAPPER_VERSION_MINOR=0
  BS_TESTWRAPPER_VERSION_PATCH=0
BS_TESTWRAPPER_VERSION_RELEASE=

readonly  'BS_TESTWRAPPER_VERSION_MAJOR'   \
          'BS_TESTWRAPPER_VERSION_MINOR'   \
          'BS_TESTWRAPPER_VERSION_PATCH'   \
          'BS_TESTWRAPPER_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_TESTWRAPPER_VERSION_FULL`
#:
#: - full version combining
#:   [`BS_TESTWRAPPER_VERSION_MAJOR`](#bs_libgetargs_version_major),
#:   [`BS_TESTWRAPPER_VERSION_MINOR`](#bs_libgetargs_version_minor),
#:   and [`BS_TESTWRAPPER_VERSION_PATCH`](#bs_libgetargs_version_patch)
#:   as a single integer
#: - can be used in numerical comparisons
#: - format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded)
#:
BS_TESTWRAPPER_VERSION_FULL=$(( \
    ( (BS_TESTWRAPPER_VERSION_MAJOR * 1000) + BS_TESTWRAPPER_VERSION_MINOR ) * 1000 \
    + BS_TESTWRAPPER_VERSION_PATCH \
  ))

readonly 'BS_TESTWRAPPER_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_TESTWRAPPER_VERSION`
#:
#: - full version combining
#:   [`BS_TESTWRAPPER_VERSION_MAJOR`](#bs_libgetargs_version_major),
#:   [`BS_TESTWRAPPER_VERSION_MINOR`](#bs_libgetargs_version_minor),
#:   [`BS_LIBARRAY_VERSION_PATCH`](#bs_libgetargs_version_patch),
#:   and
#:   [`BS_TESTWRAPPER_VERSION_RELEASE`](#bs_libgetargs_version_release)
#:   as a formatted string
#: - format: `BetterScripts 'libgetargs' vMAJOR.MINOR.PATCH[-RELEASE]`
#: - derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#:
BS_TESTWRAPPER_VERSION="$(
    printf "BetterScripts 'testwrapper' v%d.%d.%d%s\n" \
           "${BS_TESTWRAPPER_VERSION_MAJOR}"           \
           "${BS_TESTWRAPPER_VERSION_MINOR}"           \
           "${BS_TESTWRAPPER_VERSION_PATCH}"           \
           "${BS_TESTWRAPPER_VERSION_RELEASE:+-${BS_TESTWRAPPER_VERSION_RELEASE}}"
  )"

readonly 'BS_TESTWRAPPER_VERSION'

#===========================================================
#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### INTERNAL CONSTANTS
#.
#===========================================================
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. #### `c_BS_TW__Param0`
#.
#. - Value of `$0`.
#. - Required because some shells change `$0` inside
#.   functions while this can be disabled, it's easier to
#.   save `$0` here as then it's certain to contain the
#.   expected value.
#.
c_BS_TW__Param0="${0:-<unknown>}";

readonly 'c_BS_TW__Param0'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_TW__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_TW__EX_DATAERR`
#.
#. - Exit code for use when user provided _BAD DATA_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_TW__EX_NOINPUT`
#.
#. - A file could not be read (i.e. does not exist).
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
  c_BS_TW__EX_USAGE=64
c_BS_TW__EX_DATAERR=65  ## cSpell:Ignore DATAERR
c_BS_TW__EX_NOINPUT=66  ## cSpell:Ignore NOINPUT

readonly  'c_BS_TW__EX_USAGE'   \
          'c_BS_TW__EX_DATAERR' \
          'c_BS_TW__EX_NOINPUT'

#===============================================================================
#===============================================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### GLOBALS
#.
#===============================================================================
#===============================================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Current indent of output
g_BS_TESTWRAPPER_Indent=;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Test & Tool scripts
g_BS_TESTWRAPPER__Tool=;
g_BS_TESTWRAPPER__Test=;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  ID used for output
g_BS_TESTWRAPPER__ID="${c_BS_TW__Param0##*/}"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Number of iterations to run
g_BS_TESTWRAPPER_Iterations=;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
     g_BS_TW_CFG__Quiet="${BS_TESTWRAPPER_CONFIG_QUIET:-0}"
     g_BS_TW_CFG__Trace=0
g_BS_TW_CFG__ExitOnFail=0
    g_BS_TW_CFG__Assert=1

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Colo[u]r output helpers
  g_BS_TW_CFG__Color=0
   g_BS_TW_CFG__sgr0=;   ## cSpell:Ignore sgr
g_BS_TW_CFG__setfGRN=;   ## cSpell:Ignore setf
g_BS_TW_CFG__setfRED=;

#===============================================================================
#===============================================================================
#  USAGE FUNCTION
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#  fn_bs_tw_display_usage
#  ----------------------
#
#  Display script usage and help
#
#  ARGUMENTS:
#    NONE.
#_______________________________________________________________________________
fn_bs_tw_display_usage() { ## cSpell:Ignore BS_TWDU_ risation sourcable colour
  BS_TWDU_Name="${c_BS_TW__Param0##*/}";

  cat <<EndOfUsageText
Usage:
    ${BS_TWDU_Name} --tool <TOOL> --test <TEST> [OPTION...] [-- [TEST_ARG]]

NOT INTENDED TO BE INVOKED DIRECTLY; USE testrunner.sh

Run the tests from <TEST> for the tool <TOOL>.

Provides common boiler-plate and utility commands for <TEST> and outputs
basic progress and status information.

Main Options:
-------------
  -t, --tool <TOOL>               The library tool to test.  Must be sourcable.
                                  (Required)

  -u, --test <TEST>               A test to invoke. Must be sourcable.
                                  (Required)

  -c, --config-id <ID>            A configuration to test. Must be a config ID
                                  available for <TEST>. IDs are numeric and
                                  continuous from 1 to number of configurations
                                  for <TEST>.
                                  (Default: Test all configurations)

  -i, --iterations <COUNT>        The number of times to run each test (useful
                                  for profiling).
                                  (Default: 1)

  -s, --shell <SHELL>             The shell command used to invoke the script.
                                  (Currently unused.)

Other Options:
--------------
      --color/--colour            Use output colo[u]risation. Only enabled if
                                  both standard output and standard error are
                                  terminals.

      --no-assert                 Disable test asserts, for most test this will
                                  only run the command being tested and omit
                                  any tests on the results. Useful for profiling
                                  and debugging.

      --config-count              Display the number of available configurations
                                  for <TEST> and exit.

  -h, --help                      Display this text and exit.
  -v, --version                   Display version text and exit.

Option Aliases:
---------------
      --config                    Alias for --config-id.

Note:
-----

The scripts <TOOL> and <TEST> must be sourcable; if not specified as paths they
must either be present in the current directory or be found via PATH.

No modification to the environment is made; the environment of the invoking
command is the environment used.

EndOfUsageText
}

#===============================================================================
#===============================================================================
#  DIAGNOSTIC HELPERS
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tw_diagnostic`
#;
#; Diagnostic reporting command.
#;
#; Specialized as `fn_bs_tw_error` and
#; `fn_bs_tw_warning` which should be used instead
#; of this.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_tw_diagnostic <TYPE> <MESSAGE>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `TYPE` \[in]
#;
#; : diagnostic category, e.g. 'ERROR'.
#;
#; `MESSAGE` \[in]
#;
#; : diagnostic message;
#; : multiple message values may be specified and
#;   will be joined into a single string delimited
#;   by `<space>` characters.
#;
#_______________________________________________________________________________
fn_bs_tw_diagnostic() { ## cSpell:Ignore BS_TWDiag_
  BS_TWDiag_Type="${1:?'[testwrapper::fn_bs_tw_diagnostic]: Internal Error: a diagnostic category is required'}"
  shift

  {
    case $# in
    0)  : "${1:?'[testwrapper::fn_bs_tw_diagnostic]: Internal Error: a message is required'}" ;;
    1)  printf '[%s]: %s: %s\n'           \
               "${g_BS_TESTWRAPPER__ID}"  \
               "${BS_TWDiag_Type}"        \
               "${1:?'[testwrapper::fn_bs_tw_diagnostic]: Internal Error: a message is required'}"
        ;;
    *)  case ${IFS-} in
        ' '*) printf '[%s]: %s: %s\n'          \
                     "${g_BS_TESTWRAPPER__ID}" \
                     "${BS_TWDiag_Type}"       \
                     "$*"                      ;;
           *) printf '[%s]: %s: %s'            \
                     "${g_BS_TESTWRAPPER__ID}" \
                     "${BS_TWDiag_Type}"       \
                     "$1"
              shift
              printf ' %s' "$@"
              echo '' ;;
        esac ;; #<: `case ${IFS-} in`
    esac #<: `case $# in`
  } >&2
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tw_error`
#;
#; Error reporting command.
#;
#; See [`fn_bs_tw_diagnostic`][#fn_bs_tw_diagnostic].
#;
#_______________________________________________________________________________
fn_bs_tw_error() { ## cSpell:Ignore BS_TWError_
  case ${g_BS_TW_CFG__Quiet:-0} in
  0|1|2) fn_bs_tw_diagnostic 'ERROR' ${1+"$@"} ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tw_warning`
#;
#; Warning reporting command.
#;
#; See [`fn_bs_tw_diagnostic`][#fn_bs_tw_diagnostic].
#;
#_______________________________________________________________________________
fn_bs_tw_warning() { ## cSpell:Ignore BS_TWWarning_
  case ${g_BS_TW_CFG__Quiet:-0} in
  0|1) fn_bs_tw_diagnostic 'WARNING' ${1+"$@"} ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tw_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_tw_invalid_args <MESSAGE>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `MESSAGE` \[in]
#;
#; : error message;
#; : multiple message values may be specified and
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
fn_bs_tw_invalid_args() { ## cSpell:Ignore BS_TWIA_
  fn_bs_tw_diagnostic 'ERROR' 'Invalid arguments:' ${1+"$@"}
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tw_usage_error`
#;
#; Helper for errors reporting usage errors.
#;
#; Prepends 'Usage Error:' to the given error message and outputs usage text
#; once the error is displayed.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_tw_usage_error <MESSAGE>...
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `MESSAGE` \[in]
#;
#; : error message;
#; : multiple message values may be specified and
#;   will be joined into a single string delimited
#;   by `<space>` characters.
#;
#_______________________________________________________________________________
fn_bs_tw_usage_error() { ## cSpell:Ignore BS_TWUE_
  fn_bs_tw_diagnostic 'USAGE ERROR' ${1+"$@"}
  fn_bs_tw_display_usage >&2
}




#===============================================================================
#===============================================================================
#  OUTPUT HELPERS
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#  fn_bs_tw_indent_inc
#  -------------------
#
#_______________________________________________________________________________
fn_bs_tw_indent_inc() { g_BS_TESTWRAPPER_Indent="${g_BS_TESTWRAPPER_Indent%?}- "; }

#_______________________________________________________________________________
#  fn_bs_tw_indent_dec
#  -------------------
#
#_______________________________________________________________________________
fn_bs_tw_indent_dec() { g_BS_TESTWRAPPER_Indent="${g_BS_TESTWRAPPER_Indent%??} "; }

#_______________________________________________________________________________
#  fn_bs_tw_printf_indent
#  ----------------------
#
#_______________________________________________________________________________
fn_bs_tw_printf_indent() { ## cSpell:Ignore BS_TWPI_
  BS_TWPI_format="${1:?'[testwrapper::fn_bs_tw_printf_indent]: Internal Error: a print format is required'}"
  shift

  case $# in
  0) set 'BS_TW_DUMMY_PARAM' "${g_BS_TESTWRAPPER_Indent-}"      ;;
  *) set 'BS_TW_DUMMY_PARAM' "${g_BS_TESTWRAPPER_Indent-}" "$@" ;;
  esac
  shift

  # SC2059: Don't use variables in the printf format
  #+        string. Use printf "..%s.." "$foo".
  # EXCEPT: This is a wrapper round `printf`
  # shellcheck disable=SC2059
  printf "%s${BS_TWPI_format}" "$@"
}

#_______________________________________________________________________________
#  fn_bs_tw_print_color
#  --------------------
#
#_______________________________________________________________________________
fn_bs_tw_print_color() { ## cSpell:Ignore BS_TWPC_
  BS_TWPC_Color="${1?'[testwrapper::fn_bs_tw_print_color]: Internal Error: a color is required'}"
  shift

  case $#:${g_BS_TW_CFG__Color:-0} in
  0:*)  ;;
  *:0)  printf '%s' "$@" ;;
  *:1)  printf '%s' "${BS_TWPC_Color-}" "$@" "${g_BS_TW_CFG__sgr0-}" ;;
  esac
}

#_______________________________________________________________________________
#  fn_bs_tw_print_green
#  --------------------
#
#_______________________________________________________________________________
fn_bs_tw_print_red() { fn_bs_tw_print_color "${g_BS_TW_CFG__setfRED-}" ${1+"$@"}; }
fn_bs_tw_print_grn() { fn_bs_tw_print_color "${g_BS_TW_CFG__setfGRN-}" ${1+"$@"}; }

#===============================================================================
#===============================================================================
#
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#  fn_bs_tw_escape_glob
#  --------------------
#
#_______________________________________________________________________________
fn_bs_tw_escape_glob() { ## cSpell:Ignore BS_TWEG_
  BS_TWEG_refGlob="${1:?'[testwrapper::fn_bs_tw_escape_glob]: Internal Error: a glob variable is required'}"

  eval "BS_TWEG_Glob=\"\${${BS_TWEG_refGlob}-}\""

  #  Avoid escaping if possible (the performance advantage
  #+ is worth it)
  case ${BS_TWEG_Glob} in
  *[!-*?[_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\\]*)
    #  Escape the pattern
    #
    #  NOTE:
    #   - the set of characters NOT escaped is
    #+    deliberately very limited; there is no
    #+    performance gain from using a larger set and
    #+    there is more potential for unsafe characters
    #+    to be missed
    #
    #   - there are two sequences that need special
    #+    attention: the character ']', and the sequence
    #+    '[!'; both are difficult to exclude from the
    #+    `sed` escape sequence. The easiest solution is
    #+    to let them get escaped, then unescape them
    #+    immediately afterwards.
    BS_TWEG_Glob="$(
        {
          printf '%s\n' "${BS_TWEG_Glob}"
        } | {
          sed -e 's/[^-*?[_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\\]/\\&/g
                  s/\\]/]/g
                  s/\[\\!/[!/g'
        }
      )"

    eval "${BS_TWEG_refGlob}=\"\${BS_TWEG_Glob}\"" ;;
  esac
}

#===============================================================================
#===============================================================================
#  FUNCTIONS FOR TEST SCRIPTS
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#  test_assert
#  -----------
#
#_______________________________________________________________________________
test_assert() { ## cSpell:Ignore BS_TWTA_ notlike
  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${g_BS_TW_CFG__Assert} in 0) return ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${1-} in
  '--line'    |'-l'     ) BS_TWTA_AssertInfo=" (@ ${2-})"     ; shift ; shift ;;
  '--line='*  |'-l='*   ) BS_TWTA_AssertInfo=" (@ ${1#-*=})"  ; shift         ;;
               '-l'[!=]*) BS_TWTA_AssertInfo=" (@ ${1#-?})"   ; shift         ;;
                    '@'*) BS_TWTA_AssertInfo=" (@ ${1#?})"    ; shift         ;;

  '--info'    |'-i'     ) BS_TWTA_AssertInfo=" (${2-})"       ; shift ; shift ;;
  '--info='*  |'-i='*   ) BS_TWTA_AssertInfo=" (${1#-*=})"    ; shift         ;;
               '-i'[!=]*) BS_TWTA_AssertInfo=" (${1#-?})"     ; shift         ;;
                    '#'*) BS_TWTA_AssertInfo=" (${1#?})"      ; shift         ;;

                       *) BS_TWTA_AssertInfo=; ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${1-} in --) shift ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  # NOTE: additional operators do not handle complex expressions
  ec_test_assert=0
  case $#:${2-} in
  3:'-like')
    BS_TWTA_Value="$1"
    BS_TWTA_Glob="$3"
    fn_bs_tw_escape_glob 'BS_TWTA_Glob' || return $?
    eval "case \${BS_TWTA_Value} in
          ${BS_TWTA_Glob:-''}) ec_test_assert=0 ;;
                            *) ec_test_assert=1 ;;
          esac" ;;

  3:'-notlike')
    BS_TWTA_Value="$1"
    BS_TWTA_Glob="$3"
    fn_bs_tw_escape_glob 'BS_TWTA_Glob' || return $?
    eval "case \${BS_TWTA_Value} in
          ${BS_TWTA_Glob:-''}) ec_test_assert=1 ;;
                            *) ec_test_assert=0 ;;
          esac" ;;

  *) test "$@" || ec_test_assert=1 ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${ec_test_assert} in
  0)  return 0 ;;
  1)  {
        printf 'Test Assert Failed%s: [' "${BS_TWTA_AssertInfo-}"
        printf ' "%s"' "$@"
        echo ']'
      } >&2
      return 1 ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  return ${ec_test_assert}
}

#_______________________________________________________________________________
#  test_assert_command
#  -------------------
#
#_______________________________________________________________________________
test_assert_command() { ## cSpell:Ignore BS_TWTAC_
  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${g_BS_TW_CFG__Assert} in 0) return ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${1-} in
  '--line'    |'-l'     ) BS_TWTAC_AssertInfo=" (@ ${2-})"    ; shift ; shift ;;
  '--line='*  |'-l='*   ) BS_TWTAC_AssertInfo=" (@ ${1#-*=})" ; shift         ;;
               '-l'[!=]*) BS_TWTAC_AssertInfo=" (@ ${1#-?})"  ; shift         ;;
                    '@'*) BS_TWTAC_AssertInfo=" (@ ${1#?})"   ; shift         ;;

  '--info'    |'-i'     ) BS_TWTAC_AssertInfo=" (${2-})"      ; shift ; shift ;;
  '--info='*  |'-i='*   ) BS_TWTAC_AssertInfo=" (${1#-*=})"   ; shift         ;;
               '-i'[!=]*) BS_TWTAC_AssertInfo=" (${1#-?})"    ; shift         ;;
                    '#'*) BS_TWTAC_AssertInfo=" (${1#?})"     ; shift         ;;

                       *) BS_TWTAC_AssertInfo=''                              ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${1-} in --) shift ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  "$@" || {
    ec_test_assert_command=$?
    {
      printf 'Test Assert Failed%s: ' "${BS_TWTA_AssertInfo-}"
      printf ' "%s"' "$@"
      echo
    } >&2
    return ${ec_test_assert_command}
  }
}

#_______________________________________________________________________________
#  test_run_expect_success
#  -----------------------
#
#_______________________________________________________________________________
test_run_expect_success() { ## cSpell:ignore BS_TRES_
  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in 0) return ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  BS_TRES_AssertInfo=; BS_TRES_refOutput=;
  while : #< [ $# -gt 0 ]
  do
    #: LOOP TEST --------------
    case $# in 0) break ;; esac #< [ $# -gt 0 ]
    #: ------------------------

    case ${1-} in
    '--output'  |'-o'     ) BS_TRES_refOutput="${2-}"         ; shift ;;
    '--output='*|'-o='*   ) BS_TRES_refOutput="${1#-*=}"              ;;
                 '-o'[!=]*) BS_TRES_refOutput="${1#-?}"               ;;

    '--line'    |'-l'     ) BS_TRES_AssertInfo=" (@ ${2-}"    ; shift ;;
    '--line='*  |'-l='*   ) BS_TRES_AssertInfo=" (@ ${1#-*=}"         ;;
                 '-l'[!=]*) BS_TRES_AssertInfo=" (@ ${1#-?}"          ;;
                      '@'*) BS_TRES_AssertInfo=" (@ ${1#?})"          ;;

    '--info'    |'-i'     ) BS_TRES_AssertInfo=" (${2-})"     ; shift ;;
    '--info='*  |'-i='*   ) BS_TRES_AssertInfo=" (${1#-*=})"          ;;
                 '-i'[!=]*) BS_TRES_AssertInfo=" (${1#-?})"           ;;
                      '#'*) BS_TRES_AssertInfo=" (${1#?})"            ;;

    --) shift; break ;;
     *) break ;;
    esac
    shift
  done

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  ec_test_run_expect_success=0
  case ${BS_TRES_refOutput:+1} in
  1)  BS_TRES_Output="$("$@" 2>&1)" || {
        ec_test_run_expect_success=$?
        case ${BS_TRES_Output:+1} in
        1) printf '%s\n' "${BS_TRES_Output}" >&2 ;;
        esac
      }
      eval "${BS_TRES_refOutput}=\"\${BS_TRES_Output-}\"" ;;
  *)  "$@" || ec_test_run_expect_success=$? ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${ec_test_run_expect_success} in
  0)  return 0 ;;
  *)  {
        printf 'Test Command%s: "' "${BS_TRES_AssertInfo-}"
        printf '%s ' "$@"
        echo   '" returned exit FAILURE, expected SUCCESS.'
      } >&2
      return "${ec_test_run_expect_success}" ;;
  esac
}

#_______________________________________________________________________________
#  test_run_expect_failure
#  -----------------------
#
#  Run a command and report an error if it DOES return a success code
#_______________________________________________________________________________
test_run_expect_failure() { ## cSpell:ignore BS_TREF_
  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case $# in 0) return ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  BS_TREF_AssertInfo=; BS_TREF_refOutput=;
  while : #< [ $# -gt 0 ]
  do
    #: LOOP TEST --------------
    case $# in 0) break ;; esac #< [ $# -gt 0 ]
    #: ------------------------

    case ${1-} in
    '--output'  |'-o'     )  BS_TREF_refOutput="${2-}"          ; shift ;;
    '--output='*|'-o='*   )  BS_TREF_refOutput="${1#-*=}"               ;;
                 '-o'[!=]*)  BS_TREF_refOutput="${1#-?}"                ;;

    '--line'    |'-l'     ) BS_TREF_AssertInfo=" (@ ${2-})"     ; shift ;;
    '--line='*  |'-l='*   ) BS_TREF_AssertInfo=" (@ ${1#-*=})"          ;;
                 '-l'[!=]*) BS_TREF_AssertInfo=" (@ ${1#-?})"           ;;
                      '@'*) BS_TRES_AssertInfo=" (@ ${1#?})"            ;;

    '--info'    |'-i'     ) BS_TREF_AssertInfo=" (${2-})"       ; shift ;;
    '--info='*  |'-i='*   ) BS_TREF_AssertInfo=" (${1#-*=})"            ;;
                 '-i'[!=]*) BS_TREF_AssertInfo=" (${1#-?})"             ;;
                      '#'*) BS_TRES_AssertInfo=" (${1#?})"              ;;

    --) shift; break ;;
     *) break ;;
    esac
    shift
  done

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  ec_test_run_expect_failure=0
  case ${BS_TREF_refOutput:+1} in
  1)  BS_TREF_Output="$("$@" 2>&1)" || ec_test_run_expect_failure=$?
      case ${BS_TREF_Output:+1} in
      1)  case ${ec_test_run_expect_failure} in
          0) printf '%s\n' "${BS_TREF_Output}" >&2 ;;
          esac
          eval "${BS_TREF_refOutput}=\"\${BS_TREF_Output-}\"" ;;
      esac ;;
  *) "$@" || ec_test_run_expect_failure=$? ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${ec_test_run_expect_failure} in
  0)  {
        printf 'Test Command%s: "' "${BS_TRES_AssertInfo-}"
        printf '%s ' "$@"
        echo   '" returned exit SUCCESS, expected FAILURE.'
      } >&2
      return 1 ;;
  *)  return 0 ;;
  esac
}

#_______________________________________________________________________________
#  test_run_unit
#  -------------
#
#  Run a single test and report & record the outcome
#_______________________________________________________________________________
test_run_unit() { ## cSpell:Ignore BS_TRU_
  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  BS_TRU_Name=;
  case ${1-} in
  '--name'  |'--unit'  |'-n'  |'-u'  ) BS_TRU_Name="${2-}"    ; shift ; shift ;;
  '--name='*|'--unit='*|'-n='*|'-u='*) BS_TRU_Name="${1#-*=}" ; shift         ;;
  '-n'[!=]* |'-u'[!=]*               ) BS_TRU_Name="${1#-?}"  ; shift         ;;
  esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  case ${1-} in --) shift ;; esac

  #---------------------------------------------------------
  #
  #---------------------------------------------------------
  fn_bs_tw_printf_indent '%s......' "${BS_TRU_Name:-<unknown>}"

  # Run test (output captured)
  if BS_TRU_Output="$("$@" 2>&1)"; then
    i_BS_TESTWRAPPER_BatchSuccessCount=$(( i_BS_TESTWRAPPER_BatchSuccessCount + 1 ))
    fn_bs_tw_print_grn 'SUCCESS'
  else
    i_BS_TESTWRAPPER_BatchFailureCount=$(( i_BS_TESTWRAPPER_BatchFailureCount + 1 ))
    fn_bs_tw_print_red 'FAILURE'
  fi

  #---------------------------------------------------------
  # Print any output
  #---------------------------------------------------------
  case ${BS_TRU_Output:+1} in 1) printf ' (Output: %s)' "${BS_TRU_Output}" ;; esac

  #---------------------------------------------------------
  # Add a newline
  #---------------------------------------------------------
  echo
}

#_______________________________________________________________________________
#  test_print_config_info
#  --------------------
#_______________________________________________________________________________
test_print_config_info() { ## cSpell:Ignore BS_TPH_
  case $# in 0) return ;; esac

  for BS_TPH_Header
  do
    fn_bs_tw_printf_indent '%s\n' "${BS_TPH_Header}" || true
  done
}

#===============================================================================
#===============================================================================
#
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#
#_______________________________________________________________________________
fn_bs_tw_run_config() { ## cSpell:Ignore BS_TWRB_
  #---------------------------------------------------------
  BS_TWRB_refBatchFailureCount="${1:?'[testwrapper::fn_bs_tw_run_config] Internal error: a failure count variable is required'}"
  shift
  #---------------------------------------------------------

  #---------------------------------------------------------
  #  Print header
  fn_bs_tw_printf_indent 'RUNNING CONFIGURATION %d:\n' "$1"
  #---------------------------------------------------------

  set 'BS_TW_DUMMY_PARAM' "${g_BS_TESTWRAPPER__Tool}" "$@" && shift

  #---------------------------------------------------------
  #  Run test
  fn_bs_tw_indent_inc
  {
    #  Run test batch iteration(s)
    i_BS_TESTWRAPPER_BatchSuccessCount=0; i_BS_TESTWRAPPER_BatchFailureCount=0
    case ${g_BS_TESTWRAPPER_Iterations} in
    1)  {
          test_run_config "$@"
        } || {
          fn_bs_tw_error "unexpected exit status '$?' from 'test_run_config'" "$@"
        }
        echo ;;
    *)  BS_TRB_Iteration=1
        while : #< [ "${BS_TRB_Iteration}" -le "${g_BS_TESTWRAPPER_Iterations}" ]
        do
          #: LOOP TEST --------------
          case $(( g_BS_TESTWRAPPER_Iterations - BS_TRB_Iteration )) in -*) break ;; esac #< [ "${BS_TRB_Iteration}" -le "${g_BS_TESTWRAPPER_Iterations}" ]
          #: ------------------------

          fn_bs_tw_printf_indent  \
            'RUN: %d of %d\n'     \
            "${BS_TRB_Iteration}" \
            "${g_BS_TESTWRAPPER_Iterations}"

          {
            test_run_config "$@"
          } || {
            ec_test_run_config=$?
            fn_bs_tw_error "unexpected exit status '$?' from 'test_run_config'" "$@"
          }

          echo
          BS_TRB_Iteration=$(( BS_TRB_Iteration + 1 ))
        done ;;
    esac
  }
  fn_bs_tw_indent_dec
  #---------------------------------------------------------


  #---------------------------------------------------------
  eval "${BS_TWRB_refBatchFailureCount}=\"\${i_BS_TESTWRAPPER_BatchFailureCount}\""
}

#===============================================================================
#===============================================================================
#  ENTRY POINT
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#  fn_bs_tw_main
#  -------------
#
#  Script main function.
#
#  USAGE:
#     fn_bs_tw_main [<ARGUMENT>...]
#
#  ARGUMENTS:
#     $@:   Script Arguments.           (Optional.)
#
#     "Script Arguments":
#         - arguments passed to the script
#
#  EXAMPLES:
#     fn_bs_tw_main ${1+"$@"}
#_______________________________________________________________________________
fn_bs_tw_main() { ## cSpell:Ignore BS_TWM_
  #---------------------------------------------------------
  #  Initialize Variables
  opt_ConfigID=;
  opt_GetConfigCount=0;

  #---------------------------------------------------------
  #  Process command line arguments
  while : #< [ $# -gt 0 ]
  do
    #: LOOP TEST --------------
    case $# in 0) break ;; esac #< [ $# -gt 0 ]
    #: ------------------------

    case $1 in
      #.................................
      # End of arguments
      '--')
        shift
        break ;;

      #.................................
      # Version
      '--version'|'-v')
        printf '%s\n' "${BS_TESTWRAPPER_VERSION}"
        return ;;

      #.................................
      # Help
      '--help'|'-h')
        fn_bs_tw_display_usage
        return ;;

      #.................................
      # Flags
          '--quiet') g_BS_TW_CFG__Quiet=$(( ${g_BS_TW_CFG__Quiet:-0} + 1 )) ;;
       '--no-quiet') g_BS_TW_CFG__Quiet=$(( ${g_BS_TW_CFG__Quiet:-1} - 1 )) ;;
          '--trace') g_BS_TW_CFG__Trace=$(( ${g_BS_TW_CFG__Trace:-0} + 1 )) ;;
       '--no-trace') g_BS_TW_CFG__Trace=$(( ${g_BS_TW_CFG__Trace:-1} - 1 )) ;;
           '--exit') g_BS_TW_CFG__ExitOnFail=1 ;;
        '--no-exit') g_BS_TW_CFG__ExitOnFail=0 ;;
         '--assert') g_BS_TW_CFG__Assert=1 ;;
      '--no-assert') g_BS_TW_CFG__Assert=0 ;;

      '--config-count') opt_GetConfigCount=1 ;;

         '--color'|   '--colour') g_BS_TW_CFG__Color=1 ;;
      '--no-color'|'--no-colour') g_BS_TW_CFG__Color=0 ;;

      #.....................................................
      #  Tool name/path (REQUIRED.)
      '--tool='*|'-t='*)
        case ${g_BS_TESTWRAPPER__Tool:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        g_BS_TESTWRAPPER__Tool="${1#-*=}"
        case ${g_BS_TESTWRAPPER__Tool:+1} in
        1) ;; *) fn_bs_lga_invalid_args "a value is required with '$1'"
                 return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      '-t'[!=]*)
        case ${g_BS_TESTWRAPPER__Tool:+1} in
        1)  fn_bs_tw_usage_error "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        g_BS_TESTWRAPPER__Tool="${1#-?}" ;;

      '--tool'|'-t')
        case ${g_BS_TESTWRAPPER__Tool:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        case ${2:+1} in
        1)  g_BS_TESTWRAPPER__Tool="$2"
            shift ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      #.....................................................
      #  TEST File (REQUIRED.)
      '--test='*|'-u='*)
        case ${g_BS_TESTWRAPPER__Test:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        g_BS_TESTWRAPPER__Test="${1#-*=}"
        case ${g_BS_TESTWRAPPER__Test:+1} in
        1) ;; *) fn_bs_lga_invalid_args "a value is required with '$1'"
                 return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      '-u'[!=]*)
        case ${g_BS_TESTWRAPPER__Test:+1} in
        1)  fn_bs_tw_usage_error "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        g_BS_TESTWRAPPER__Test="${1#-?}" ;;

      '--test'|'-u')
        case ${g_BS_TESTWRAPPER__Test:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        case ${2:+1} in
        1)  g_BS_TESTWRAPPER__Test="$2"
            shift ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      #.....................................................
      #  Config ID
      '--config-id='*|'--config='*|'-c='*)
        case ${opt_ConfigID:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        opt_ConfigID="${1#-*=}"
        case ${opt_ConfigID:+1} in
        1) ;; *) fn_bs_lga_invalid_args "a value is required with '$1'"
                 return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      '-c'[!=]*)
        case ${opt_ConfigID:+1} in
        1)  fn_bs_tw_usage_error "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        opt_ConfigID="${1#-?}" ;;

      '--config-id'|'--config'|'-c')
        case ${opt_ConfigID:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        case ${2:+1} in
        1)  opt_ConfigID="$2"
            shift ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      #.....................................................
      #  Iteration count
      '--iterations='*|'-i='*)
        case ${g_BS_TESTWRAPPER_Iterations:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        g_BS_TESTWRAPPER_Iterations="${1#-*=}"
        case ${g_BS_TESTWRAPPER_Iterations:+1} in
        1) ;; *) fn_bs_lga_invalid_args "a value is required with '$1'"
                 return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      '-i'[!=]*)
        case ${g_BS_TESTWRAPPER_Iterations:+1} in
        1)  fn_bs_tw_usage_error "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        g_BS_TESTWRAPPER_Iterations="${1#-?}" ;;

      '--iterations'|'-i')
        case ${g_BS_TESTWRAPPER_Iterations:+1} in
        1)  fn_bs_tw_invalid_args "'${1%%=*}' specified multiple times"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac
        case ${2:+1} in
        1)  g_BS_TESTWRAPPER_Iterations="$2"
            shift ;;
        *)  fn_bs_lga_invalid_args "a value is required with '$1'"
            return "${c_BS_TW__EX_USAGE}" ;;
        esac ;;

      #.....................................................
      #  Unmatched
      *)  fn_bs_tw_usage_error "unrecognized argument '$1' (test arguments must follow a '--' argument)"
          return "${c_BS_TW__EX_USAGE}" ;;
    esac
    shift
  done

  #---------------------------------------------------------
  #
  case ${g_BS_TW_CFG__Color:-0} in ## cSpell:Ignore setaf
  1)  if test -t 1 && test -t 2 && BS_TWInit_sgr0="$(tput 'sgr0' 2>&1)"; then
        g_BS_TW_CFG__sgr0="${BS_TWInit_sgr0}"
        {
          {
            g_BS_TW_CFG__setfGRN="$(tput 'setaf' 2 2>&1)"
          } && {
            g_BS_TW_CFG__setfRED="$(tput 'setaf' 1 2>&1)"
          }
        } || {
          {
            g_BS_TW_CFG__setfGRN="$(tput 'setf' 2 2>&1)"
          } && {
            g_BS_TW_CFG__setfRED="$(tput 'setf' 4 2>&1)"
          }
        } || {
            g_BS_TW_CFG__Color=0
          g_BS_TW_CFG__setfGRN=;
          g_BS_TW_CFG__setfRED=;
             g_BS_TW_CFG__sgr0=;
        }
      fi ;;
  esac

  #=========================================================
  #  Validate arguments
  #=========================================================

  #---------------------------------------------------------
  # Test & Tool
  case ${g_BS_TESTWRAPPER__Tool:+T}${g_BS_TESTWRAPPER__Test:+U} in
  TU) ;;
  T*) fn_bs_tw_usage_error 'no tool specified'
      return "${c_BS_TW__EX_USAGE}" ;;
   *) fn_bs_tw_usage_error 'no test specified'
      return "${c_BS_TW__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # ConfigID
  case ${opt_ConfigID:+1}${opt_ConfigID-} in
  1*[!0123456789]*)
    fn_bs_tw_usage_error "invalid config ID '${opt_ConfigID}'"
    return "${c_BS_TW__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Iterations
  case ${g_BS_TESTWRAPPER_Iterations:+1}${g_BS_TESTWRAPPER_Iterations-} in
  1*[!0123456789]*)
    fn_bs_tw_usage_error "invalid iteration count '${g_BS_TESTWRAPPER_Iterations}'"
    return "${c_BS_TW__EX_USAGE}" ;;
  *) : "${g_BS_TESTWRAPPER_Iterations:=1}" ;;
  esac

  #=========================================================
  #=========================================================
  # Source TEST file
  # shellcheck source=/dev/null
  #=========================================================
  #=========================================================
  . "${g_BS_TESTWRAPPER__Test}" || return "${c_BS_TW__EX_NOINPUT}"

  #---------------------------------------------------------
  # Validate TEST file
  case ${BS_TEST_CONFIG_COUNT:+S}${BS_TEST_CONFIG_COUNT-} in
  S*[!0123456789]*)
    fn_bs_tw_error "Invalid test '${g_BS_TESTWRAPPER__Test}', invalid config count '${BS_TEST_CONFIG_COUNT}'."
    return "${c_BS_TW__EX_DATAERR}" ;;
  S0)
    fn_bs_tw_warning "SKIPPING '${BS_TWM_TestName}'; Test has no configurations."
    return ;;
  S?*) ;;
  *)
    fn_bs_tw_error "Invalid test '${g_BS_TESTWRAPPER__Test}', 'BS_TEST_CONFIG_COUNT' not set."
    return "${c_BS_TW__EX_DATAERR}" ;;
  esac

  #=========================================================
  # Deal with request for "Config Count"
  #=========================================================
  case ${opt_GetConfigCount:-0} in
  1) printf '%d\n' "${BS_TEST_CONFIG_COUNT}"; return ;;
  esac

  #=========================================================
  #  Determine a test name
  #=========================================================
  g_BS_TESTWRAPPER__ID="${g_BS_TESTWRAPPER__Tool##*/}:${g_BS_TESTWRAPPER__Test##*/}"
  BS_TWM_TestName="${BS_TEST_NAME:-${g_BS_TESTWRAPPER__ID}}"

  #=========================================================
  #  Process and validate configuration ID
  #=========================================================
  BS_TWM_ConfigID_Current=; BS_TWM_ConfigID_Last=;
  case ${opt_ConfigID:+1} in
  1)  case $(( BS_TEST_CONFIG_COUNT - opt_ConfigID )) in
      -*) fn_bs_tw_usage_error "configuration ID '${opt_ConfigID}' out of range (configuration count '${BS_TEST_CONFIG_COUNT}')"
          return "${c_BS_TW__EX_USAGE}" ;;
      esac
      BS_TWM_ConfigID_Current="${opt_ConfigID}"
         BS_TWM_ConfigID_Last="${opt_ConfigID}"
              BS_TWM_TestName="${BS_TWM_TestName} [Config ${opt_ConfigID}]" ;;
  *)  BS_TWM_ConfigID_Current=1
         BS_TWM_ConfigID_Last="${BS_TEST_CONFIG_COUNT}" ;;
  esac

  #=========================================================
  #=========================================================
  case $# in
  0) set 'BS_TW_DUMMY_PARAM' '--' && shift ;;
  *) case $1 in --) ;; *) set 'BS_TW_DUMMY_PARAM' '--' "$@" && shift ;; esac ;;
  esac

  #=========================================================
  #=========================================================
  fn_bs_tw_indent_inc
  {
    #-------------------------------------------------------
    #-------------------------------------------------------
    #  HEADER
    fn_bs_tw_printf_indent 'RUNNING "%s"\n\n' "${BS_TWM_TestName}"

    #-------------------------------------------------------
    #-------------------------------------------------------
    #  RUN THE TESTS
    fn_bs_tw_indent_inc
    {
      BS_TWM_TotalFailureCount=0
      while : #< [ "${BS_TWM_ConfigID_Current}" -le "${BS_TWM_ConfigID_Last}" ]
      do
        #: LOOP TEST ---------------------
        case $(( BS_TWM_ConfigID_Last - BS_TWM_ConfigID_Current )) in -*) break ;; esac
        #: -------------------------------

        (
          BS_TWM_CFG_ConfigFailureCount=0
          fn_bs_tw_run_config               \
            'BS_TWM_CFG_ConfigFailureCount' \
            "${BS_TWM_ConfigID_Current}"    \
            "$@"
          exit "${BS_TWM_CFG_ConfigFailureCount}"
        ) || {
          BS_TWM_TotalFailureCount=$(( BS_TWM_TotalFailureCount + $? ))
        }

        case ${g_BS_TW_CFG__ExitOnFail:-0}:${BS_TWM_TotalFailureCount} in
        0:*|*:0) ;; *) break ;;
        esac

        BS_TWM_ConfigID_Current=$(( BS_TWM_ConfigID_Current + 1 ))
      done
    }
    fn_bs_tw_indent_dec

    #-------------------------------------------------------
    #-------------------------------------------------------
    #  FOOTER
    fn_bs_tw_printf_indent 'Results for "%s": ' "${BS_TWM_TestName}"
    case ${BS_TWM_TotalFailureCount} in
    0) fn_bs_tw_print_grn 'ALL TESTS SUCCEEDED' ;;
    *) fn_bs_tw_print_red "${BS_TWM_TotalFailureCount} TEST(S) FAILED" >&2 ;;
    esac
    echo ''
  }
  fn_bs_tw_indent_dec

  #=========================================================
  #=========================================================
  echo ''
  echo '------------------------------------------------------------'
  echo ''

  #=========================================================
  #=========================================================
  case $(( 255 - ${BS_TWM_TotalFailureCount:-0} )) in
  -*) return 255 ;;
   *) return "${BS_TWM_TotalFailureCount:-0}" ;;
  esac
}

################################################################################
#  Entry Point
################################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Run...
case $# in
0) fn_bs_tw_main      ;;
*) fn_bs_tw_main "$@" ;;
esac

################################################################################
################################################################################
# END
################################################################################
################################################################################
