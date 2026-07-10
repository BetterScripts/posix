#!/usr/bin/env sh
# SPDX-License-Identifier: MPL-2.0
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'testrunner': Tools to run tests on the BetterScripts POSIX  *#
#*                            Suite libraries.                                *#
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

################################## TESTRUNNER ##################################
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
#===============================================================================
## cSpell:Ignore testrunner testwrapper
################################ DOCUMENTATION #################################
#
#% % testrunner(7) BetterScripts testrunner.sh v1.1.0 | Test harness for BetterScripts  `shtoolkit`.
#% % BetterScripts (better.scripts@proton.me)
#% % July 2026
#
#: <!-- #################################################################### -->
#: <!-- ########### THIS FILE WAS GENERATED FROM 'testrunner.sh' ########### -->
#: <!-- #################################################################### -->
#: <!-- ########################### DO NOT EDIT! ########################### -->
#: <!-- #################################################################### -->
#:
#: # TESTRUNNER
#:
#
# Runs tests for BetterScripts `shtoolkit` libraries in one or more shells,
# with options to allow for some basic profiling.
#
################################################################################

############################## SHELLCHECK: GLOBAL ##############################
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
#        construct shellcheck does not correctly parse.                       #
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
#: #### `BS_TESTRUNNER_VERSION_MAJOR`
#:
#: - integer >= 1
#: - incremented when there are significant changes, or
#:   any changes break compatibility with previous
#:   versions
#:
#: ---------------------------------------------------------
#:
#: #### `BS_TESTRUNNER_VERSION_MINOR`
#:
#: - integer >= 0
#: - incremented for significant changes that do not
#:   break compatibility with previous versions
#: - reset to 0 when
#:   [`BS_TESTRUNNER_VERSION_MAJOR`](#bs_libgetargs_version_major)
#:   changes
#:
#: ---------------------------------------------------------
#:
#: #### `BS_TESTRUNNER_VERSION_PATCH`
#:
#: - integer >= 0
#: - incremented for minor revisions or bugfixes
#: - reset to 0 when
#:   [`BS_TESTRUNNER_VERSION_MINOR`](#bs_libgetargs_version_minor)
#:   changes
#:
#: ---------------------------------------------------------
#:
#: #### `BS_TESTRUNNER_VERSION_RELEASE`
#:
#: - a string indicating a pre-release version, always
#:   null for full-release versions
#: - possible values include 'alpha', 'beta', 'rc',
#:   etc, (a numerical suffix may also be appended)
#:
  BS_TESTRUNNER_VERSION_MAJOR=1;
  BS_TESTRUNNER_VERSION_MINOR=1;
  BS_TESTRUNNER_VERSION_PATCH=0;
BS_TESTRUNNER_VERSION_RELEASE=;

readonly 'BS_TESTRUNNER_VERSION_MAJOR'   \
         'BS_TESTRUNNER_VERSION_MINOR'   \
         'BS_TESTRUNNER_VERSION_PATCH'   \
         'BS_TESTRUNNER_VERSION_RELEASE'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_TESTRUNNER_VERSION_FULL`
#:
#: - full version combining
#:   [`BS_TESTRUNNER_VERSION_MAJOR`](#bs_libgetargs_version_major),
#:   [`BS_TESTRUNNER_VERSION_MINOR`](#bs_libgetargs_version_minor),
#:   and [`BS_TESTRUNNER_VERSION_PATCH`](#bs_libgetargs_version_patch)
#:   as a single integer
#: - can be used in numerical comparisons
#: - format: `MNNNPPP` where, `M` is the `MAJOR` version,
#:   `NNN` is the `MINOR` version (3 digit, zero padded),
#:   and `PPP` is the `PATCH` version (3 digit, zero padded)
#:
BS_TESTRUNNER_VERSION_FULL=$(( \
    ( (BS_TESTRUNNER_VERSION_MAJOR * 1000) + BS_TESTRUNNER_VERSION_MINOR ) * 1000 \
    + BS_TESTRUNNER_VERSION_PATCH \
  ))

readonly 'BS_TESTRUNNER_VERSION_FULL'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: ---------------------------------------------------------
#:
#: #### `BS_TESTRUNNER_VERSION`
#:
#: - full version combining
#:   [`BS_TESTRUNNER_VERSION_MAJOR`](#bs_libgetargs_version_major),
#:   [`BS_TESTRUNNER_VERSION_MINOR`](#bs_libgetargs_version_minor),
#:   [`BS_LIBARRAY_VERSION_PATCH`](#bs_libgetargs_version_patch),
#:   and
#:   [`BS_TESTRUNNER_VERSION_RELEASE`](#bs_libgetargs_version_release)
#:   as a formatted string
#: - format: `BetterScripts 'libgetargs' vMAJOR.MINOR.PATCH[-RELEASE]`
#: - derived tools MUST include unique identifying
#:   information in this value that differentiates them
#:   from the BetterScripts versions. (This information
#:   should precede the version number.)
#:
BS_TESTRUNNER_VERSION="$(
    printf "BetterScripts 'testrunner' v%d.%d.%d%s\n" \
           "${BS_TESTRUNNER_VERSION_MAJOR}"           \
           "${BS_TESTRUNNER_VERSION_MINOR}"           \
           "${BS_TESTRUNNER_VERSION_PATCH}"           \
           "${BS_TESTRUNNER_VERSION_RELEASE:+-${BS_TESTRUNNER_VERSION_RELEASE}}"
  )"

readonly 'BS_TESTRUNNER_VERSION'

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
#. #### `c_BS_TR__SystemLocale`
#.
#. - ...
#.
c_BS_TR__SystemLocale=${LC_ALL:-${LC_CTYPE:-${LANG:-}}}

readonly 'c_BS_TR__SystemLocale'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_TR__newline`
#.
#. - Literal `<newline>` (i.e. `\n`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_TR__newline='
'

readonly 'c_BS_TR__newline'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_TR__tab`
#.
#. - Literal `<tab>` (i.e. `\t`) character.
#. - Defined because it's often difficult to correctly
#.   insert this character when required.
#.
c_BS_TR__tab='	';

readonly 'c_BS_TR__tab'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_TR__tab`
#.
#. - Default IFS: `<space><tab><newline>`.
#.
c_BS_TR__IFS='
'

readonly 'c_BS_TR__IFS'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. #### `c_BS_TR__Param0`
#.
#. - Value of `$0`
#. - Required because some shells change `$0` inside
#.   functions while this can be disabled, it's easier to
#.   save `$0` here as then it's certain to contain the
#.   expected value
#.
c_BS_TR__Param0=${0:-<unknown>};

readonly 'c_BS_TR__Param0'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. <!-- ................................................ -->
#.
#. #### `c_BS_TR__EX_USAGE`
#.
#. - Exit code for use on _USAGE ERRORS_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_TR__EX_DATAERR`
#.
#. - Exit code for use when user provided _BAD DATA_.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_TR__EX_NOINPUT`
#.
#. - A file could not be read (i.e. does not exist).
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
#. ---------------------------------------------------------
#.
#. #### `c_BS_TR__EX_UNAVAILABLE`
#.
#. - A required command is unavailable or gave
#.   unexpected results.
#. - Taken from [FreeBSD `SYSEXITS(3)`][sysexits] which
#.   defines the closest thing to standard exit codes that
#.   is available.
#. - NOT _POSIX.1_ specified.
#.
      c_BS_TR__EX_USAGE=64;
    c_BS_TR__EX_DATAERR=65;  ## cSpell:Ignore DATAERR
    c_BS_TR__EX_NOINPUT=66;  ## cSpell:Ignore NOINPUT
c_BS_TR__EX_UNAVAILABLE=69;

readonly  'c_BS_TR__EX_USAGE' \
          'c_BS_TR__EX_DATAERR' \
          'c_BS_TR__EX_NOINPUT' \
          'c_BS_TR__EX_UNAVAILABLE'

#===============================================================================
#===============================================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### GLOBALS
#.
#===============================================================================
#===============================================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Settings
g_BS_TR__aWrapperArgs=;
g_BS_TR__aTestArgs=;
g_BS_TR__Locale=C
g_BS_TR__IgnoreEnv=;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Flags
g_BS_TR_CFG__ExitOnFail=0
g_BS_TR_CFG__Trace=0
g_BS_TR_CFG__Timed=0
g_BS_TR_CFG__NoBusyBox=0

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
g_BS_TR_CFG__Quiet=${BS_TESTRUNNER_CONFIG_QUIET:-0}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Paths for scripts
g_BS_TR__TestWrapper='.testwrapper.sh' ## cSpell:ignore testwrapper

#===============================================================================
#===============================================================================
#; <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#;
#; ## INTERNAL COMMANDS
#;
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_testrunner_diagnostic`
#;
#; Diagnostic reporting command.
#;
#; Specialized as `fn_bs_testrunner_error` and
#; `fn_bs_testrunner_warning` which should be used instead
#; of this.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_testrunner_diagnostic <TYPE> <MESSAGE>...
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
fn_bs_testrunner_diagnostic() { ## cSpell:Ignore BS_TR_Diag_
  BS_TR_Diag_Type=${1:?'[testrunner::fn_bs_testrunner_diagnostic]: Internal Error: a diagnostic category is required'}
  shift

  {
    case $# in
    0)  : "${1:?'[testrunner::fn_bs_testrunner_diagnostic]: Internal Error: a message is required'}" ;;
    1)  printf '[testrunner]: %s: %s\n' \
               "${BS_TR_Diag_Type}"     \
               "${1:?'[testrunner::fn_bs_testrunner_diagnostic]: Internal Error: a message is required'}"
        ;;
    *)  case ${IFS-} in
        ' '*) printf '[testrunner]: %s: %s\n' \
                     "${BS_TR_Diag_Type}"     \
                     "$*"                     ;;
           *) printf '[testrunner]: %s: %s' \
                     "${BS_TR_Diag_Type}"   \
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
#; ### `fn_bs_testrunner_error`
#;
#; Error reporting command.
#;
#; See [`fn_bs_testrunner_diagnostic`][#fn_bs_testrunner_diagnostic].
#;
#_______________________________________________________________________________
fn_bs_testrunner_error() {
  case ${g_BS_TR_CFG__Quiet:-0} in
  0|1|2) fn_bs_testrunner_diagnostic 'ERROR' ${1+"$@"} ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_testrunner_warning`
#;
#; Warning reporting command.
#;
#; See [`fn_bs_testrunner_diagnostic`][#fn_bs_testrunner_diagnostic].
#;
#_______________________________________________________________________________
fn_bs_testrunner_warning() {
  case ${g_BS_TR_CFG__Quiet:-0} in
  0|1) fn_bs_testrunner_diagnostic 'WARNING' ${1+"$@"} ;;
  esac
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_testrunner_invalid_args`
#;
#; Helper for errors reporting invalid arguments.
#;
#; Prepends 'Invalid Arguments:' to the given error message arguments to avoid
#; having to add it for every call.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_testrunner_invalid_args <MESSAGE>...
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
fn_bs_testrunner_invalid_args() { ## cSpell:Ignore BS_TRIA_
  fn_bs_testrunner_diagnostic 'ERROR' 'Invalid arguments:' ${1+"$@"}
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_testrunner_usage_error`
#;
#; Helper for errors reporting usage errors.
#;
#; Prepends 'Usage Error:' to the given error message and outputs usage text
#; once the error is displayed.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_testrunner_usage_error <MESSAGE>...
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
fn_bs_testrunner_usage_error() {
  fn_bs_testrunner_diagnostic 'USAGE ERROR' ${1+"$@"}
  fn_bs_tr_display_usage >&2
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_testrunner_print`
#;
#; ...
#;
#_______________________________________________________________________________
fn_bs_testrunner_print() {
  # SC2059: Don't use variables in the printf format string.
  #         Use printf "..%s.." "$foo".
  # EXCEPT: This is a replacement for `printf` so that output can be made
  #         quiet if desired; arguments are passed directly to `printf`.
  # shellcheck disable=SC2059
  case ${g_BS_TR_CFG__Quiet:-0} in
  0) printf "$@" ;;
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
fn_bs_tr_pwd() { ## cSpell:Ignore BS_TRPWD_
  BS_TRPWD_refPWD=${1:?'[testrunner::fn_bs_tr_pwd]: Internal Error: an output variable is required'}
  shift

  if BS_TRPWD_PWD=$(pwd ${1+"$@"} && echo '_') && test -d "${BS_TRPWD_PWD%?_}"
  then
    BS_TRPWD_PWD=${BS_TRPWD_PWD%?_}
  elif test -d "${PWD-}"
  then
    BS_TRPWD_PWD=${PWD}
  else
    BS_TRPWD_PWD=.
  fi

  eval "${BS_TRPWD_refPWD}=\"\${BS_TRPWD_PWD}\""
} #< `fn_bs_tr_pwd()`

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tr_get_dirname`
#;
#; Set a variable the directory name of a given path.
#;
#; **If the given path is NOT rooted, a root will be added using `$PWD`.**
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_tr_get_dirname <OUTPUT> <PATH>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `OUTPUT` \[out:ref]
#;
#; : variable to hold the output;
#; : MUST be a valid _POSIX.1_ name.
#;
#; `PATH` \[in]
#;
#; : path to get the directory from;
#; : a path that does not start with `/` will be
#;   interpreted relative to the present working directory
#;   (to avoid this a fake root can be added by the caller).
#;
#; _NOTES_
#; <!-- -->
#;
#; - For simplicity always assumes that `dirname` is not available or does not
#;   work correctly (per [`autoconf` platform portability][autoconf_portable]).
#; - Using this rather than a command that outputs the result to `STDOUT` avoids
#;   the edge case where a path ends in a `<newline>` (such output can easily
#;   result in errors without due care).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - This implementation does _ONLY_ what is required for this script; a more
#.   general implementation is possible, but more complicated and requires
#.   handling many more edge cases that are not relevant to usage here.
#. - the value obtained SHOULD be a "rooted" path (i.e. a path that starts with
#.   `/`), and WILL be "absolute" if `PATH` is "absolute" (i.e. contains no
#.   `..` path segments).
#.
#_______________________________________________________________________________
fn_bs_tr_get_dirname() { ## cSpell:Ignore BS_TRGD_
  BS_TRGD_refDirname=${1:?'[testrunner::fn_bs_tr_get_dirname]: Internal Error: an output variable is required'}
        BS_TRGD_Path=${2:?'[testrunner::fn_bs_tr_get_dirname]: Internal Error: a path is required'}

  #---------------------------------------------------------
  # Add a root if none is already present as it makes
  # processing simpler, however this makes the output an
  # absolute path that MAY not be what the caller intended.
  #---------------------------------------------------------
  case ${BS_TRGD_Path-} in
  [!/]*)
    BS_TRGD_PWD=;
    fn_bs_tr_pwd BS_TRGD_PWD || return $?
    BS_TRGD_Path="${BS_TRGD_PWD%/}/${BS_TRGD_Path}"
  ;;
  esac

  BS_TRGD_Dirname=$(dirname "${BS_TRGD_Path}" && echo '_') || return $?
  eval "${BS_TRGD_refDirname}=\"\${BS_TRGD_Dirname%?_}\""
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tr_get_basename`
#;
#; Set a variable the basename name of a given path.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;      fn_bs_tr_get_basename <OUTPUT> <PATH> [<SUFFIX>]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `OUTPUT` \[out:ref]
#;
#; : variable to hold the output;
#; : MUST be a valid _POSIX.1_ name.
#;
#; `PATH` \[in]
#;
#; : path to get the basename from.
#;
#; `SUFFIX` \[in]
#;
#; : a suffix to remove from the output;
#; : although this is usually an extension, it can be any
#;   value (an extension SHOULD include any preceding `.`).
#;
#; _NOTES_
#; <!-- -->
#;
#; - For simplicity always assumes that `basename` is not available or does not
#;   work correctly (per [`autoconf` platform portability][autoconf_portable]).
#; - Using this rather than a command that outputs the result to `STDOUT` avoids
#;   the edge case where a path ends in a `<newline>` (such output can easily
#;   result in errors without due care).
#;
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - This implementation does _ONLY_ what is required for this script; a more
#.   general implementation is possible, but more complicated and requires
#.   handling many more edge cases that are not relevant to usage here.
#.
#_______________________________________________________________________________
fn_bs_tr_get_basename() { ## cSpell:Ignore BS_TRGB_
  BS_TRGB_refBasename=${1:?'[testrunner::fn_bs_tr_get_basename]: Internal Error: an output variable is required'}
  shift

  BS_TRGB_Basename=$(basename "$@" && echo '_') || return $?
  eval "${BS_TRGB_refBasename}=\"\${BS_TRGB_Basename%?_}\""
}

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
#; ### `fn_bs_tr_array_value`
#;
#; Create a single array element from a given value.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_tr_array_value <VALUE>
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE`
#;
#; - value to convert into an array value
#; - can be null
#; - can contain any arbitrary text excluding any
#;   embedded `<NUL>` (i.e.  `\0`) characters
#; - MUST be a single value
#;
#; _NOTES_
#; <!-- -->
#;
#; - More details about emulated shell arrays can be found in the documentation
#;   for [`libarray.sh`](../LIBARRAY.MD)
#;
#_______________________________________________________________________________
fn_bs_tr_array_value() { ## cSpell:Ignore BS_TR_AV_
  #---------------------------------------------------------
  # It is much faster to only invoke `sed` if required
  # to escape quote characters (even when taking into
  # account the cost of testing for the quote)
  #
  # NOTE:
  # - due to quoting rules for shells '\\\\' results
  #   in a single escape in the final string
  case ${1?'[testrunner::fn_bs_tr_array_value]: An array value is required'} in
    #.......................................................
    #> `case $1 in`
    #> ------------
    #
    # Has `<apostrophe>` characters
    *"'"*)
      # Value contains `<apostrophe>` characters
      {
        printf '%s\n' "$1"
      } | {
        # `sed` script:
        # - escape all `<apostrophe>` characters
        # - add a `<apostrophe>` character to the start
        #   of the value
        # - add a `<apostrophe>` to the end of the value
        #   **and** add an escape after that (this
        #   will escape the whitespace that must
        #   follow)
        #
        # NOTE:
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
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tr_array_create`
#;
#; Create an emulated array from the given values.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_tr_array_create [<VALUE>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `VALUE` \[in]
#;
#; - can be specified multiple times
#; - can be null
#; - can contain any arbitrary text excluding any
#;   embedded `<NUL>` (i.e. `\0`) characters
#; - each value specified will become an array
#;   element
#;
#; _NOTES_
#; <!-- -->
#;
#; - More details about emulated shell arrays can be found in the documentation
#;   for [`libarray.sh`](../LIBARRAY.MD)
#;
#_______________________________________________________________________________
fn_bs_tr_array_create() { ## cSpell:Ignore BS_TR_TA_
  case $# in 0) return ;; esac #< Early out if nothing to do

  for BS_TR_TA_Value
  do
    fn_bs_tr_array_value "${BS_TR_TA_Value}" || return $?
  done
  echo ' ' #<  Trailing whitespace is required
}

#_______________________________________________________________________________
#  fn_bs_tr_shell_array_create
#  -------------------
#
# Initialize anything that has not already been set; primarily constants that
# require the use of commands to initialize and so are not initialized on
# declaration.
#
#  USAGE:
#     fn_bs_tr_shell_array_create
#
#  ARGUMENTS:
#     NONE.
#
#
#  EXAMPLES:
#     fn_bs_tr_shell_array_create
#
#_______________________________________________________________________________
fn_bs_tr_shell_array_create() { ## cSpell:Ignore BS_TRInit_
  #-------------------------------------
  #  Known shells
  #
  ## cSpell:Ignore busybox rustybox
  ## cSpell:Ignore rksh lksh
  ## cSpell:Ignore modernish
  ## cSpell:Ignore bosh jbosh pbosh
  ## cSpell:Ignore posixlycorrect
  #
  #  Omitted:
  #  - `nsh`: does not properly process command line arguments
  #
  set 'BS_DUMMY_PARAM' \
        'sh' \
        \
        'ash' \
        \
        'bosh' 'jbosh' 'pbosh' \
        \
        'bash'      'bash --posix'    \
        'bash -r'   'bash --posix -r' \
        \
        'dash' \
        \
        'ksh'     'ksh88'     'ksh93'     'ksh2020'     \
        'ksh -r'  'ksh88 -r'  'ksh93 -r'  'ksh2020 -r'  \
        'rksh'                                          \
        \
        'mksh'    'mksh -r' \
        'lksh' \
        \
        'modernish' \
        \
        'osh' \
        \
        'oksh' 'oksh -r' \
        \
        'posh' \
        \
        'qsh'  \
        \
        'rustybox sh' 'rustybox ash' \
        \
        'yash' 'yash -o posixlycorrect' \
        \
        'zsh'    'zsh --emulate sh'    \
        'zsh -r' 'zsh --emulate sh -r'
  shift

  case ${g_BS_TR_CFG__NoBusyBox:-0} in
  0)  set 'BS_DUMMY_PARAM'          \
        'busybox sh'  'busybox ash' \
        "$@"
      shift ;;
  esac

  ## cSpell:disable
  for BS_TRInit_Shell
  do
    if fn_bs_tr_cmd_is_shell "${BS_TRInit_Shell}"; then
      fn_bs_tr_array_value "${BS_TRInit_Shell}"
    fi
  done
  echo ' '
  ## cSpell:enable
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tr_locate_item`
#;
#; Attempt to locate a filesystem item using the provided paths.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_tr_locate_item <TEST> <NAME> [<PATH>...]
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; `TEST` \[in]
#;
#; : ...
#;
#; `NAME` \[in/out:ref]
#;
#; : variable containing an array;
#; : MUST be a valid _POSIX.1_ name;
#; : value must be a name or a path
#; : may be absolute, relative, or partial
#;
#; `PATH` \[in]
#;
#; : a path that may contain `NAME`
#; : searched in the provided order
#; : does not need to exist
#;
#; _NOTES_
#; <!-- -->
#;
#; - `NAME` is checked for with `test <TEST>`, if it does not exist each of the
#;   `PATH` is prepended to the path and it is checked again.
#; - If `NAME` is a "rooted" path then only the first check happens.
#; - Exit status will be `0` (`<zero>`) if and only if the `NAME` was found,
#;   in this case the variable will contain the path found.
#;
#_______________________________________________________________________________
fn_bs_tr_locate_item() { ## cSpell:Ignore BS_TR_LI_
  BS_TR_LI_Test=${1:?'[testrunner::fn_bs_tr_locate_item]: Internal Error: a test is required'}
  shift
  BS_TR_LI_refName=${1:?'[testrunner::fn_bs_tr_locate_item]: Internal Error: a script variable is required'}
  shift

  #---------------------------------------------------------
  # Unpack variable and check it's set
  #---------------------------------------------------------
  eval "BS_TR_LI_Name=\${${BS_TR_LI_refName}-}"
  case ${BS_TR_LI_Name:+1} in
  1) ;;   *)  fn_bs_testrunner_invalid_args "'${BS_TR_LI_refName}' does not contain a path"
              return "${c_BS_TR__EX_USAGE}" ;;
  esac

  #---------------------------------------------------------
  # Easy check first
  #---------------------------------------------------------
  if test "${BS_TR_LI_Test}" "${BS_TR_LI_Name}"
  then
    case ${BS_TR_LI_Name} in
    [!/]*)  fn_bs_tr_pwd BS_TR_LI_PWD || return $?
            BS_TR_LI_Name="${BS_TR_LI_PWD:+${BS_TR_LI_PWD}/}${BS_TR_LI_Name}"
            eval "${BS_TR_LI_refName}=\"\${BS_TR_LI_Name}\"" ;;
    esac
    return
  else
    # A rooted path either exists or
    # doesn't - no search can be made
    case ${BS_TR_LI_Name} in
    /*) fn_bs_testrunner_error "failed to locate '${BS_TR_LI_Name}'"
        return "${c_BS_TR__EX_NOINPUT}" ;;
    esac
  fi

  #---------------------------------------------------------
  # Need to search on the given paths
  #---------------------------------------------------------
  for BS_TR_LI_SearchDir
  do
    case ${BS_TR_LI_SearchDir:-} in
      *:*)
        BS_TR_LI_RemainingPath=":${BS_TR_LI_SearchDir%:}:"
        while test -n "${BS_TR_LI_RemainingPath}"
        do

               BS_TR_LI_TestPath="${BS_TR_LI_RemainingPath##*:}/${BS_TR_LI_Name}"
          BS_TR_LI_RemainingPath=${BS_TR_LI_RemainingPath%:*}
          if test "${BS_TR_LI_Test}" "${BS_TR_LI_TestPath}"
          then
            eval "${BS_TR_LI_refName}=\"\${BS_TR_LI_TestPath}\""
            return
          fi
        done
      ;;
      *)
        BS_TR_LI_TestPath="${BS_TR_LI_SearchDir:+${BS_TR_LI_SearchDir}/}${BS_TR_LI_Name}"
        if test "${BS_TR_LI_Test}" "${BS_TR_LI_TestPath}"
        then
          eval "${BS_TR_LI_refName}=\"\${BS_TR_LI_TestPath}\""
          return
        fi
      ;;
    esac
  done

  #---------------------------------------------------------
  # Failed to locate the file
  #---------------------------------------------------------
  fn_bs_testrunner_error "failed to locate '${BS_TR_LI_Name}'"
  return "${c_BS_TR__EX_NOINPUT}"
}

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tr_locate_file`
#;
#; Attempt to locate a file using the provided paths.
#;
#; See [`fn_bs_tr_locate_item`][#fn_bs_tr_locate_item].
#;
#_______________________________________________________________________________
fn_bs_tr_locate_file() { fn_bs_tr_locate_item '-f' ${1+"$@"}; }

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tr_locate_directory`
#;
#; Attempt to locate a directory using the provided paths.
#;
#; See [`fn_bs_tr_locate_directory`][#fn_bs_tr_locate_directory].
#;
#_______________________________________________________________________________
fn_bs_tr_locate_directory() { fn_bs_tr_locate_item '-d' ${1+"$@"}; }

#===============================================================================
#===============================================================================
#  TEST HELPERS
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#  fn_bs_tr_shell_run_test
#  -----------------
#
#  Run the test wrapper script with a given command and arguments, optionally
# writing out the command before invoking and/or timing how long the test
# takes to complete.
#
#  USAGE:
#     fn_bs_tr_shell_run_test <COMMAND> <ARGUMENT> [<ARGUMENT>...]
#
#  ARGUMENTS:
#     $1:   Command.                    (Required.)
#     $@:   Arguments.                  (Required.)
#
#     "Command":
#         - the shell to use to run the wrapper script
#         - will be subject to "Field Splitting"; may
#          contain shell specific arguments
#         - must accept a script to run as the next argument
#          followed by arguments to pass to that script
#
#     "Arguments":
#         - arguments for the wrapper script
#         - passed through unmodified
#
#  EXAMPLES:
#     fn_bs_tr_shell_run_test 'bash -r' "$@"
#
#  NOTE:
#   - wrapper script is assumed to be correctly stored in the variable
#    `g_BS_TR__TestWrapper`
#
#   - If `g_BS_TR_CFG__Trace` is set to '1' will trace the command before
#    invoking.
#_______________________________________________________________________________
fn_bs_tr_shell_run_test() { ## cSpell:Ignore BS_TRTR
  BS_TR_SR_ShellCmd=${1:?'[testrunner::fn_bs_tr_shell_run_test] A shell command is required'}
  shift

  # Even if `-i` is in effect, pass-through all standard
  # defined environment variables that are not otherwise
  # explicitly set.
  #
  ## cSpell:Ignore DATEMSK LOGNAME MSGVERB
  # SC2312: Double quote to prevent globbing and word splitting.
  # EXCEPT: It's meant to be split
  # shellcheck disable=SC2086
  set 'BS_TRM_DUMMY' \
    \
           "LANG=${g_BS_TR__Locale}" \
         "LC_ALL=${g_BS_TR__Locale}" \
     "LC_COLLATE=${g_BS_TR__Locale}" \
       "LC_CTYPE=${g_BS_TR__Locale}" \
    "LC_MESSAGES=${g_BS_TR__Locale}" \
    "LC_MONETARY=${g_BS_TR__Locale}" \
     "LC_NUMERIC=${g_BS_TR__Locale}" \
        "LC_TIME=${g_BS_TR__Locale}" \
    \
    ${BS_TR_SR_ShellCmd}             \
    "${g_BS_TR__TestWrapper}"        \
    ${1+"$@"}                        && shift

  case ${g_BS_TR__IgnoreEnv:+1} in
    1)  set \
          'env' \
          '-i'  \
          \
          ${BS_TEST_SHELL:+"COLUMNS=${BS_TEST_SHELL}"} \
          \
          ${COLUMNS:+"COLUMNS=${COLUMNS}"} \
          ${DATEMSK:+"DATEMSK=${DATEMSK}"} \
             ${HOME:+"HOME=${HOME}"}       \
            ${LINES:+"LINES=${LINES}"}     \
          ${LOGNAME:+"LOGNAME=${LOGNAME}"} \
          ${MSGVERB:+"MSGVERB=${MSGVERB}"} \
            ${SHELL:+"SHELL=${SHELL}"}     \
           ${TMPDIR:+"TMPDIR=${TMPDIR}"}   \
             ${TERM:+"TERM=${TERM}"}       \
               ${TZ:+"TZ=${TZ}"}           \
          \
          "PATH=${PATH}" \
          \
          "$@"
    ;;

    *) set 'env' "IFS=${c_BS_TR__IFS}" "$@" ;;
  esac

  # Output the command line
  case ${g_BS_TR_CFG__Trace:-0} in
  1) printf '%s\n' "$*" >&2 || true ;;
  esac

  # Run the test
  # SC2312: Consider invoking this command separately to avoid masking
  #         its return value (or use '|| true' to ignore).
  # EXCEPT: `time -p` needs to run the given command and the error code is
  #         used to determine if tested failed.
  # shellcheck disable=SC2312
  case ${g_BS_TR_CFG__Timed:-0} in
  1) time -p "$@" && echo '' ;;
  0) "$@" ;;
  esac
}

#_______________________________________________________________________________
#  fn_bs_tr_run_test_config
#  ------------------------
#
#  Run the test configuration specified by the configuration ID.
#
#  If the configuration ID is either zero (i.e. '0') or 'all', run all available
# configurations.
#
#  USAGE:
#     fn_bs_tr_run_test_config <SHELL> <TEST> <ARGUMENT>
#
#  ARGUMENTS:
#     $1:   Shell.                      (Required.)
#     $2:   Test.                       (Required.)
#     $3:   Arguments Variable.         (Required.)
#
#     "Shell":
#         - the shell to use to run the wrapper script
#         - will be subject to "Field Splitting"; may
#          contain shell specific arguments
#         - must accept a script to run as the next argument
#          followed by arguments to pass to that script
#
#     "Test":
#         - the test script to be run
#         - should be only a name, not a full path (PATH
#          should have been set to contain the file path,
#          this is to accommodate restricted shells)
#
#     "Arguments Variable":
#         - an array variable
#         - arguments for the **test** script
#         - must be specified, even if empty/null
#         - will have the argument --shell=<"Shell"> added
#
#  EXAMPLES:
#     fn_bs_tr_run_test_config 'bash -r' 'success' 'arguments'
#
#  NOTE:
#   - wrapper script is assumed to be correctly stored in the variable
#    `g_BS_TR__TestWrapper`
#
#   - The number of iterations is read from `opt_Iterations`,
#    while the configuration ID is read from `opt_ConfigID`
#_______________________________________________________________________________
fn_bs_tr_run_test_config() { ## cSpell:Ignore BS_TR_RTC
       BS_TR_RTC_Shell=${1:?'[testrunner::fn_bs_tr_run_test_config] a command to run is required'}
        BS_TR_RTC_Tool=${2:?'[testrunner::fn_bs_tr_run_test_config] a tool to run is required'}
        BS_TR_RTC_Test=${3:?'[testrunner::fn_bs_tr_run_test_config] a test to run is required'}
    BS_TR_RTC_ConfigID=${4:?'[testrunner::fn_bs_tr_run_test_config] a config to run is required'}
  BS_TR_RTC_Iterations=${5:?'[testrunner::fn_bs_tr_run_test_config] an iteration count is required'}

  set 'BS_DUMMY_PARAM'                       \
      "--tool=${BS_TR_RTC_Tool}"             \
      "--test=${BS_TR_RTC_Test}"             \
      "--iterations=${BS_TR_RTC_Iterations}"

  case ${BS_TR_RTC_ConfigID:-0} in
  0|'all') ;; *) set "$@" "--config=${BS_TR_RTC_ConfigID}"
  esac

  case ${g_BS_TR_CFG__ExitOnFail:-0} in
  1) set "$@" '--exit'
  esac

  case ${g_BS_TR__aWrapperArgs:+1} in
  1) eval "set \"\$@\" ${g_BS_TR__aWrapperArgs}"
  esac

  case ${g_BS_TR__aTestArgs:+1} in
  1) eval "set \"\$@\" '--' ${g_BS_TR__aTestArgs}"
  esac

  # Remove 'BS_DUMMY_PARAM'
  shift

  BS_TR_RTC_TestsFailed=0
  {
    fn_bs_tr_shell_run_test "${BS_TR_RTC_Shell}" "$@"
  } || {
    BS_TR_RTC_TestsFailed=$(( BS_TR_RTC_TestsFailed + $? ))
  }
  return "${BS_TR_RTC_TestsFailed}"
}

#_______________________________________________________________________________
#  fn_bs_tr_cmd_is_shell
#  ---------------------
#
#  Test if the given command appears to be a shell that is available in the
# current environment.
#
#  USAGE:
#     fn_bs_tr_cmd_is_shell <COMMAND>
#
#  ARGUMENTS:
#     $1:   Command.                    (Required.)
#
#     "Command":
#         - the command to test
#         - will be subject to "Field Splitting"; may
#          contain shell specific arguments
#         - must accept input from a pipe (i.e. standard
#          input)
#
#  EXAMPLES:
#     if fn_bs_tr_cmd_is_shell 'bash -r'; then ...
#
#  IMPLEMENTATION NOTE:
#   - There is no good way to test if a command exists that is supported in all
#    cases and in all shells. Even many shells that are relatively modern or
#    actively updated do not support some of the standard supplied ways of
#    checking this. Even if there was such a test there is no way of
#    determining if the given command is actually a shell (or just a command
#    that happens to have the same name). Instead, this command tries to run
#    a small script via a pipe with the given command, if the output is as
#    expected, the command is deemed to be a shell, otherwise it is not.
#_______________________________________________________________________________
fn_bs_tr_cmd_is_shell() { ## cSpell:Ignore BS_TRCIS_
  case $(
      (
        $1 -c  'if [ "X" = "X" ]
                then
                  echo "Hello World"
                fi' || true

      ) 2>&1
    ) in
  'Hello World') return 0 ;;
              *) return 1 ;;
  esac
}

#===============================================================================
#===============================================================================
#
#===============================================================================
#===============================================================================

#_______________________________________________________________________________
#  fn_bs_tr_main
#  -------------
#
#  Script main function.
#
#  USAGE:
#     fn_bs_tr_main [<ARGUMENT>...]
#
#  ARGUMENTS:
#     $@:   Script Arguments.           (Optional.)
#
#     "Script Arguments":
#         - arguments passed to the script
#
#  EXAMPLES:
#     fn_bs_tr_main ${1+"$@"}
#_______________________________________________________________________________
fn_bs_tr_main() { ## cSpell:Ignore BS_TRM_
  #---------------------------------------------------------
  #  Ensure some options are set correctly
  #---------------------------------------------------------
  case $- in *u*) ;; *) set -u ;; esac #< `nounset`:  Error on unset variables
  case $- in *f*)       set +f ;; esac #< `noglob`:   Enable pathname expansion

  #---------------------------------------------------------
  #  For this script use the POSIX locale - this may be
  #  overridden for tests with the `--locale` option
  #---------------------------------------------------------
  for BS_TR_refLocaleVar in       \
      'LANG'        'LC_ALL'      \
      'LC_CTYPE'    'LC_COLLATE'  \
      'LC_MONETARY' 'LC_NUMERIC'  \
      'LC_MESSAGES'
  do
    eval "${BS_TR_refLocaleVar}=C
          export '${BS_TR_refLocaleVar}'"
  done

  #---------------------------------------------------------
  # Unset GNU specific locale variables - these should _not_
  # be an issue, but some reports suggest that LANGUAGE at
  # least _may_ override other `LC_*` variables
  #---------------------------------------------------------
  for BS_TR_refLocaleVar in                 \
      'LANGUAGE'        'LC_TIME'           \
      'LC_ADDRESS'      'LC_IDENTIFICATION' \
      'LC_MEASUREMENT'  'LC_NAME'           \
      'LC_PAPER'        'LC_TELEPHONE'
  do
    eval "case \${${BS_TR_refLocaleVar}+1} in
          1) unset ${BS_TR_refLocaleVar} ;;
          esac"
  done

  #---------------------------------------------------------
  # Initialize local variables
  #---------------------------------------------------------
  opt_Tool=;     opt_TestDir=;
  opt_TestName=; opt_aShells=;
  opt_ConfigID=; opt_PlatformConfigID=;

  opt_Locale=; unset opt_Locale

  #---------------------------------------------------------
  # Get the directory of this script
  #---------------------------------------------------------
  BS_TR_Main_TestRunnerDir=;
  {
    fn_bs_tr_get_dirname         \
      'BS_TR_Main_TestRunnerDir' \
      "${c_BS_TR__Param0}"
  } || {
    BS_TR_Main_TestRunnerDir=${c_BS_TR__Param0%/*}
  }

  #---------------------------------------------------------
  # Get the path to the test wrapper script
  #---------------------------------------------------------
  fn_bs_tr_locate_file            \
    'g_BS_TR__TestWrapper'        \
    "${BS_TR_Main_TestRunnerDir}" || return $?

  #---------------------------------------------------------
  # Process command line arguments...
  #---------------------------------------------------------
  while [ $# -gt 0 ]
  do
    case $1 in
      #.................................
      # End of arguments
      '--')
        shift
        if [ $# -gt 0 ]
        then
          g_BS_TR__aTestArgs="${g_BS_TR__aTestArgs-}$(fn_bs_tr_array_create "$@")"
        fi
        break
      ;;

      #.................................
      # Help
      '--help'|'-h')
        fn_bs_tr_display_usage
        return ;;

      #.................................
      # Version
      '--version'|'-v')
        printf '%s\n' "${BS_TESTRUNNER_VERSION}"
        return ;;

      #.................................
      # Timed
      '--time'|'--timed'|'--profile')
        g_BS_TR_CFG__Timed=1
        g_BS_TR__aWrapperArgs="${g_BS_TR__aWrapperArgs-}$(fn_bs_tr_array_create '--no-assert')"
      ;;

      #.................................
      # Flag arguments
                '--quiet') g_BS_TR_CFG__Quiet=$(( ${g_BS_TR_CFG__Quiet:-0} + 1 )) ;;
             '--no-quiet') g_BS_TR_CFG__Quiet=$(( ${g_BS_TR_CFG__Quiet:-1} - 1 )) ;;
                '--trace') g_BS_TR_CFG__Trace=$(( ${g_BS_TR_CFG__Trace:-0} + 1 )) ;;
             '--no-trace') g_BS_TR_CFG__Trace=$(( ${g_BS_TR_CFG__Trace:-1} - 1 )) ;;
                 '--exit') g_BS_TR_CFG__ExitOnFail=1 ;;
              '--no-exit') g_BS_TR_CFG__ExitOnFail=0 ;;
           '--ignore-env') g_BS_TR__IgnoreEnv=1      ;;
        '--no-ignore-env') g_BS_TR__IgnoreEnv=;      ;;
           '--no-busybox') g_BS_TR_CFG__NoBusyBox=1  ;;

      #.................................
      # locale
      '--locale='*) opt_Locale=${1#-*=} ;;
      '--locale'  ) opt_Locale=; ;;

      #.................................
      # Pass-through arguments
      '--color'|'--no-color'|'--colour'|'--no-colour'|'--no-assert'|'--assert'|'--test-platform-config'|'--no-test-platform-config')
        g_BS_TR__aWrapperArgs="${g_BS_TR__aWrapperArgs-}$(fn_bs_tr_array_create "$1")" ;;

      #.................................
      # Tool name/path (REQUIRED.)
      '--tool='*|'-t='*)
        case ${opt_Tool:+1} in
        1)  fn_bs_testrunner_usage_error '"--tool|-t" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_Tool=${1#-*=}
        case ${opt_Tool:+1} in
        1) ;; *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
                  return "${c_BS_TR__EX_USAGE}" ;;
        esac
      ;;

      '-t'[!=]*)
        case ${opt_Tool:+1} in
        1)  fn_bs_testrunner_usage_error '"--tool|-t" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_Tool=${1#-?} ;;

      '--tool'|'-t')
        case ${2:+1} in
        1)  case ${opt_Tool:+1} in
            1)  fn_bs_testrunner_usage_error '"--tool|-t" can only be specified once'
                return "${c_BS_TR__EX_USAGE}" ;;
            esac
            opt_Tool=$2
            shift ;;
        *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
            return "${c_BS_TR__EX_USAGE}" ;;
        esac ;;

      #.................................
      # Test name/path
      '--test='*|'-u='*)
        case ${opt_TestName:+1} in
        1)  fn_bs_testrunner_usage_error '"--test|-u" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_TestName=${1#-*=}
        case ${opt_TestName:+1} in
        1) ;; *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
                  return "${c_BS_TR__EX_USAGE}" ;;
        esac
      ;;

      '-u'[!=]*)
        case ${opt_TestName:+1} in
        1)  fn_bs_testrunner_usage_error '"--test|-u" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_TestName=${1#-?} ;;

      '--test'|'-u')
        case ${2:+1} in
        1)  case ${opt_TestName:+1} in
            1)  fn_bs_testrunner_usage_error '"--test|-u" can only be specified once'
                return "${c_BS_TR__EX_USAGE}" ;;
            esac
            opt_TestName=$2
            shift ;;
        *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
            return "${c_BS_TR__EX_USAGE}" ;;
        esac ;;

      #.................................
      # Test directory
      '--test-dir='*|'-d='*)
        case ${opt_TestDir:+1} in
        1)  fn_bs_testrunner_usage_error '"--test-dir|-d" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_TestDir=${1#-*=}
        case ${opt_TestDir:+1} in
        1) ;; *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
                  return "${c_BS_TR__EX_USAGE}" ;;
        esac
      ;;

      '-d'[!=]*)
        case ${opt_TestDir:+1} in
        1)  fn_bs_testrunner_usage_error '"--test-dir|-d" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_TestDir=${1#-?} ;;

      '--test-dir'|'-d')
        case ${2:+1} in
        1)  case ${opt_TestDir:+1} in
            1)  fn_bs_testrunner_usage_error '"--test-dir|-d" can only be specified once'
                return "${c_BS_TR__EX_USAGE}" ;;
            esac
            opt_TestDir=$2
            shift ;;
        *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
            return "${c_BS_TR__EX_USAGE}" ;;
        esac ;;

      #.................................
      # Config number
      '--config-id='*|'--config='*|'-c='*)
        case ${opt_ConfigID:+1} in
        1)  fn_bs_testrunner_usage_error '"--config-id|-c" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_ConfigID=${1#-*=}
        case ${opt_ConfigID:+1} in
        1) ;; *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
                  return "${c_BS_TR__EX_USAGE}" ;;
        esac
      ;;

      '-c'[!=]*)
        case ${opt_ConfigID:+1} in
        1)  fn_bs_testrunner_usage_error '"--config-id|-c" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_ConfigID=${1#-?} ;;

      '--config-id'|'--config'|'-c')
        case ${2:+1} in
        1)  case ${opt_ConfigID:+1} in
            1)  fn_bs_testrunner_usage_error '"--config-id|-c" can only be specified once'
                return "${c_BS_TR__EX_USAGE}" ;;
            esac
            opt_ConfigID=$2
            shift ;;
        *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
            return "${c_BS_TR__EX_USAGE}" ;;
        esac ;;

      #.................................
      # Config number
      '--platform-config-id='*|'--platform-config='*|'-p='*)
        case ${opt_PlatformConfigID:+1} in
        1)  fn_bs_testrunner_usage_error '"--config-id|-c" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_PlatformConfigID=${1#-*=}
        case ${opt_PlatformConfigID:+1} in
        1) ;; *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
                  return "${c_BS_TR__EX_USAGE}" ;;
        esac
      ;;

      '-p'[!=]*)
        case ${opt_PlatformConfigID:+1} in
        1)  fn_bs_testrunner_usage_error '"--config-id|-c" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_PlatformConfigID=${1#-?} ;;

      '--platform-config-id'|'--platform-config'|'-p')
        case ${2:+1} in
        1)  case ${opt_PlatformConfigID:+1} in
            1)  fn_bs_testrunner_usage_error '"--config-id|-c" can only be specified once'
                return "${c_BS_TR__EX_USAGE}" ;;
            esac
            opt_PlatformConfigID=$2
            shift ;;
        *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
            return "${c_BS_TR__EX_USAGE}" ;;
        esac ;;

      #.................................
      # Iteration count
      '--iterations='*|'-i='*)
        case ${opt_Iterations:+1} in
        1)  fn_bs_testrunner_usage_error '"--iterations|-i" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_Iterations=${1#-*=}
        case ${opt_Iterations:+1} in
        1) ;; *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
                  return "${c_BS_TR__EX_USAGE}" ;;
        esac
      ;;

      '-i'[!=]*)
        case ${opt_Iterations:+1} in
        1)  fn_bs_testrunner_usage_error '"--iterations|-i" can only be specified once'
            return "${c_BS_TR__EX_USAGE}" ;;
        esac
        opt_Iterations=${1#-?} ;;

      '--iterations'|'-i')
        case ${2:+1} in
        1)  case ${opt_Iterations:+1} in
            1)  fn_bs_testrunner_usage_error '"--iterations|-i" can only be specified once'
                return "${c_BS_TR__EX_USAGE}" ;;
            esac
            opt_Iterations=$2
            shift ;;
        *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
            return "${c_BS_TR__EX_USAGE}" ;;
        esac ;;

      #.................................
      # Shell command
      '--shell='?*|'-s='?*)
        opt_aShells="${opt_aShells-}$(fn_bs_tr_array_create "${1#-*=}")" ;;

      '-s'[!=]*)
        opt_aShells="${opt_aShells-}$(fn_bs_tr_array_create "${1#-*=}")" ;;

      '--shell='|'-s=')
        fn_bs_testrunner_usage_error "a value is required with '$1'"
        return "${c_BS_TR__EX_USAGE}" ;;

      '--shell'|'-s')
        case ${2:+1} in
        1)  opt_aShells="${opt_aShells-}$(fn_bs_tr_array_create "$2")"
            shift ;;
        *)  fn_bs_testrunner_usage_error "a value is required with '$1'"
            return "${c_BS_TR__EX_USAGE}" ;;
        esac ;;

      #.....................................................
      # Unmatched
      *)  fn_bs_testrunner_usage_error "unrecognized argument '$1' (test arguments must follow a '--' argument)"
          return "${c_BS_TR__EX_USAGE}" ;;
    esac
    shift
  done

  #---------------------------------------------------------
  # Validate & process arguments
  #---------------------------------------------------------

  #.....................................
  # Tool to test
  #.....................................
  case ${opt_Tool:+1} in
  1) ;; *)  fn_bs_testrunner_usage_error 'no tool specified'
            return "${c_BS_TR__EX_USAGE}" ;;
  esac

  fn_bs_tr_locate_file                               \
    'opt_Tool'                                       \
    "${BS_TR_Main_TestRunnerDir:-.}/.."              \
    ${BETTER_SCRIPTS_PATH:+"${BETTER_SCRIPTS_PATH}"} \
    ${PATH:+"${PATH}"}                               || return $?

  BS_TR_Main_ToolDir=;
  fn_bs_tr_get_dirname   \
    'BS_TR_Main_ToolDir' \
    "${opt_Tool}"        || return $?

  BS_TR_Main_ToolFile=;
  fn_bs_tr_get_basename   \
    'BS_TR_Main_ToolFile' \
    "${opt_Tool}"         || return $?

  #.....................................
  # Directory Containing Test(s)
  #.....................................
  BS_TR_Main_TestDir=;
  case ${opt_TestDir:+1} in
  1)  BS_TR_Main_TestDir=${opt_TestDir} ;;
  *)  case ${opt_TestName-} in
      */*)  fn_bs_tr_get_dirname   \
              'BS_TR_Main_TestDir' \
              "${opt_TestName}"    || return $?
            fn_bs_tr_get_basename \
              'opt_TestName'      \
              "${opt_TestName}"   || return $? ;;
        *)  BS_TR_Main_TestDir=${BS_TR_Main_ToolFile%.sh} ;;
      esac ;;
  esac

  fn_bs_tr_pwd BS_TR_Main_PWD || BS_TR_Main_PWD=;

  fn_bs_tr_locate_directory                \
    'BS_TR_Main_TestDir'                   \
    "${BS_TR_Main_TestRunnerDir}"          \
    ${BS_TR_Main_PWD:+"${BS_TR_Main_PWD}"} || return $?

  #.....................................
  # Determine what shells to use
  #.....................................
  BS_TRM_aShells=;
  case ${opt_aShells:+1} in
  1)  eval "set 'BS_DUMMY_PARAM' ${opt_aShells}" && shift
      for BS_TRM_Shell
      do
        fn_bs_tr_cmd_is_shell "${BS_TRM_Shell}" || {
          fn_bs_testrunner_usage_error "command '${BS_TRM_Shell}' does not appear to be a shell"
          return "${c_BS_TR__EX_USAGE}"
        }
        BS_TRM_aShells="${BS_TRM_aShells-}$(fn_bs_tr_array_create "${BS_TRM_Shell}")"
      done ;;
  *)  BS_TRM_aShells=$(fn_bs_tr_shell_array_create) ;;
  esac

  #.....................................
  # Config ID
  #.....................................
  : "${opt_ConfigID:=all}"
  case ${opt_ConfigID} in
  'all') ;;
  *[!0123456789]*)
    fn_bs_testrunner_usage_error "invalid config ID '${opt_ConfigID}'"
    return "${c_BS_TR__EX_USAGE}" ;;
  esac

  : "${opt_PlatformConfigID:=0}"
  case ${opt_PlatformConfigID} in
  *[!0123456789]*)
    fn_bs_testrunner_usage_error "invalid config ID '${opt_PlatformConfigID}'"
    return "${c_BS_TR__EX_USAGE}" ;;
  esac

  #.....................................
  # Iterations
  #.....................................
  case ${g_BS_TR_CFG__Timed:-0} in
  1) : "${opt_Iterations:=8}" ;;
  0) : "${opt_Iterations:=1}" ;;
  esac

  case ${opt_Iterations} in
  *[!0123456789]*)
    fn_bs_testrunner_usage_error "invalid config ID '${opt_Iterations}'"
    return "${c_BS_TR__EX_USAGE}" ;;
  esac

  #.....................................
  # No quiet if tracing
  #.....................................
  case ${g_BS_TR_CFG__Trace:-0} in 1) g_BS_TR_CFG__Quiet=0 ;; esac

  #.....................................
  # Find a locale if needed - if no
  # locale was specified, use the first
  # `UTF8` locale available.
  #.....................................
  case ${opt_Locale+SET}:${opt_Locale:+NZ} in
    SET:)
      case ${c_BS_TR__SystemLocale-} in
        *[Uu][Tt][Ff]8*|*[Uu][Tt][Ff]-8*)
          opt_Locale=${c_BS_TR__SystemLocale}
        ;;

        *)
            opt_Locale=$(
                {
                  locale -a 2>&1
                } | {
                  sed -n -e '
                    /[Uu][Tt][Ff]-\{0,1\}8/{
                      p
                      q
                    }'
                }
              ) ;;
      esac

      case ${opt_Locale:+1} in
      1)  g_BS_TR__Locale=${opt_Locale} ;;
      *)  fn_bs_testrunner_warning "Disabling '--locale' option: could not find a suitable locale"
          opt_Locale=; unset opt_Locale ;;
      esac
    ;;

    SET:NZ)
      g_BS_TR__Locale=${opt_Locale}
    ;;
  esac

  #---------------------------------------------------------
  #  ADD DIRECTORIES TO PATH
  #
  #  Restricted shells generally do not permit the use of
  # full paths for execution or sourcing, to work around
  # this requires that the files needed are all available
  # on the search path, so do that for all shells (since
  # it works for unrestricted shells too).
  #
  #  NOTE: There is a potential issue here: if `ToolDir` or
  #       `TestDir` contain any executable files that are
  #       named the same as any command invoked they will
  #       be invoked instead. This is deemed unlikely and
  #       for running tests not likely to be something that
  #       is of large concern.
  #---------------------------------------------------------
  PATH="${BS_TR_Main_ToolDir}:${BS_TR_Main_TestDir}${PATH:+:${PATH#:}}"
  export PATH

  #---------------------------------------------------------
  # Set positional parameters to shells to be used
  #---------------------------------------------------------
  eval "set 'BS_TRM_DUMMY' ${BS_TRM_aShells}" && shift

  case $# in
  0)  fn_bs_testrunner_usage_error 'failed to find any valid shells'
      return "${c_BS_TR__EX_NOINPUT}" ;;
  esac

  #---------------------------------------------------------
  # RUN TEST(S)
  #---------------------------------------------------------
  BS_TRM_Shells=;
  BS_TRM_SkippedShellInfo=; BS_TRM_FailedShellInfo=;
  BS_TRM_SkippedTotal=0;    BS_TRM_FailedTotal=0;
  BS_TRM_TestsRun=0
  for BS_TEST_SHELL
  do
    #...................................
    # Export so tests can query
    #...................................
    export BS_TEST_SHELL

    #...................................
    # Add to the list of shells used
    #...................................
    BS_TRM_Shells="${BS_TRM_Shells:+${BS_TRM_Shells}, }'${BS_TEST_SHELL}'"

    #...................................
    # Header
    #...................................
    fn_bs_testrunner_print 'RUNNING TESTS (using %s)\n' "${BS_TEST_SHELL}"
    fn_bs_testrunner_print '==========================\n'
    fn_bs_testrunner_print '\n'

    #...................................
    # Run test(s)
    #...................................
    BS_TRM_ShellFailedCount=0
    case ${opt_TestName:+1} in
      #-------------------------------
      # Single Test from argument
      #-------------------------------
      1)  BS_TRM_TestsRun=$(( BS_TRM_TestsRun + 1 ))
          fn_bs_tr_run_test_config   \
            "${BS_TEST_SHELL}"       \
            "${BS_TR_Main_ToolFile}" \
            "${opt_TestName}"        \
            "${opt_ConfigID}"        \
            "${opt_Iterations}"      || BS_TRM_ShellFailedCount=$? ;;

      #-------------------------------
      # All Tests from directory
      #-------------------------------
      *)
          for BS_TRM_TestFile in "${BS_TR_Main_TestDir}"/*
          do
            fn_bs_tr_get_basename  \
              'BS_TRM_TestFile'    \
              "${BS_TRM_TestFile}" || return $?

            case ${opt_Locale:+1}:${BS_TRM_TestFile} in
            ':'*'.locale') continue ;;
            esac

            {
              BS_TRM_TestsRun=$(( BS_TRM_TestsRun + 1 ))
              fn_bs_tr_run_test_config   \
                "${BS_TEST_SHELL}"       \
                "${BS_TR_Main_ToolFile}" \
                "${BS_TRM_TestFile}"     \
                "${opt_ConfigID}"        \
                "${opt_Iterations}"
            } || {
              BS_TRM_ShellFailedCount=$(( BS_TRM_ShellFailedCount + $? ))
            }

            case ${g_BS_TR_CFG__ExitOnFail:-0}:${BS_TRM_ShellFailedCount} in
            0:*|*:0) ;; *) break ;;
            esac
          done ;;
    esac #< `case ${opt_TestName:+1} in`

    #...................................
    # Keep a note of failures
    #...................................
    case ${BS_TRM_ShellFailedCount} in
    0)  ;;
    *)  BS_TRM_FailedShellInfo="${BS_TRM_FailedShellInfo-}${BS_TEST_SHELL} (${BS_TRM_ShellFailedCount}), "
            BS_TRM_FailedTotal=$(( BS_TRM_FailedTotal + BS_TRM_ShellFailedCount ))
        case ${g_BS_TR_CFG__ExitOnFail:-0} in
        0) ;; *) break ;;
        esac ;;
    esac
  done #< `for BS_TEST_SHELL`

  #---------------------------------------------------------
  # Output Results
  #---------------------------------------------------------
  BS_TRM_ShellsTested=$(( $# - BS_TRM_SkippedTotal ))

  case ${BS_TRM_ShellsTested:-0} in
  0) ;;
  *) BS_TRM_TestsRun=$(( BS_TRM_TestsRun / BS_TRM_ShellsTested )) ;;
  esac

  printf  "'%s' TESTS COMPLETE: USED %d TESTS FILE(S) WITH %d SHELL(S) [%s]\n" \
          "${BS_TR_Main_ToolFile}"    \
          "${BS_TRM_TestsRun:-0}"     \
          "${BS_TRM_ShellsTested:-0}" \
          "${BS_TRM_Shells}"

  case ${BS_TRM_SkippedShellInfo:+1} in
  1)  printf '    *WARNING* SKIPPED TESTS FOR SHELL(S): %s\n' \
             "${BS_TRM_SkippedShellInfo%,?}" ;;
  esac

  BS_TRM_ExitStatus=0
  case ${BS_TRM_FailedShellInfo:+1}:${BS_TRM_TestsRun:-0} in
  1:*)
    if test 255 -gt "${BS_TRM_FailedTotal}"; then
      printf  '    %d TESTS FAILED: %s\n'    \
              "${BS_TRM_FailedTotal}"        \
              "${BS_TRM_FailedShellInfo%,?}"
      BS_TRM_ExitStatus=${BS_TRM_FailedTotal}
    else
      printf  '    AT LEAST %d TESTS FAILED: %s\n' \
              "${BS_TRM_FailedTotal}"              \
              "${BS_TRM_FailedShellInfo%,?}"
      BS_TRM_ExitStatus=255
    fi

    case "${BS_TRM_FailedShellInfo}" in
    *'busybox'*)
      printf 'NOTE: busybox failures may be false negatives (see documentation for more information), use --no-busybox to omit this shell\n'
    ;;
    esac ;;
  :0) echo '    *WARNING* NO TESTS RUN!' ;;
   *) echo '    ALL TESTS SUCCEEDED' ;;
  esac

  #---------------------------------------------------------
  # Finished
  #---------------------------------------------------------
  return "${BS_TRM_ExitStatus}"
}

################################################################################
################################################################################
# USAGE
################################################################################
################################################################################

#_______________________________________________________________________________
#; ---------------------------------------------------------
#;
#; ### `fn_bs_tr_display_usage`
#;
#; Display script usage information.
#;
#; _SYNOPSIS_
#; <!-- - -->
#;
#;     fn_bs_tr_display_usage
#;
#; _ARGUMENTS_
#; <!-- -- -->
#;
#; NONE.
#;
#_______________________________________________________________________________
fn_bs_tr_display_usage() { ## cSpell:Ignore BS_TR_DU_ risation TOOLNAME colour
  BS_TR_DU_Name=;
  {
    fn_bs_tr_get_basename 'BS_TR_DU_Name' "${c_BS_TR__Param0}"
  } || BS_TR_DU_Name=${c_BS_TR__Param0##*/}

  cat <<EndOfUsageText
Usage:
    ${BS_TR_DU_Name} --tool <TOOL> [OPTION...] [-- [TEST_ARG]]

Run tests for a library from the BetterScripts shtoolkit.

Main Options:
-------------
  -t, --tool <TOOL>               The library tool to test. Either the name of
                                  a library or a path to a specific file.
                                  (Required)

  -d, --test-dir <DIR>            A directory containing tests.
                                  (Default: directory named <TOOLNAME> in same
                                            directory as ${BS_TR_DU_Name})

  -u, --test <TEST>               A test to invoke. Either a name (relative to
                                  the test directory) or a full path.
                                  (Default: invoke all in test directory)

  -c, --config-id <ID>            A configuration to test. Either a numerical
                                  ID representing a single test configuration
                                  as specified in the test file, or the value
                                  zero (i.e. '0') or 'all' to run all
                                  configurations available. Configuration IDs
                                  start at 1.
                                  (Default: 'all')

  -i, --iterations <COUNT>        The number of times to run each test (useful
                                  for profiling).
                                  (Default: '8' if profiling, '1' otherwise)

  -s, --shell <SHELL>             A shell command to run tests with. Can contain
                                  arguments, but must be quoted as a single
                                  value (e.g. 'bash --posix'). Can be specified
                                  multiple times, each will be run.
                                  (Default: any shell found from the list of
                                            known shells)

Other Options:
--------------
      --locale[=<LOCALE>]         Run the tests using the given locale. If a
                                  locale is not specified, uses the first UTF8
                                  locale available. Test files with the suffix
                                  '.locale' will be ignored unless this option
                                  is specified.
                                  (Default: Use the POSIX locale.)

      --[no-]ignore-env           Run tests using 'env -i' (i.e. ignore the
                                  current environment). Note, some environment
                                  variables will always be set explicitly
                                  regardless of this setting.
                                  (Default: Environment is passed through.)

      --no-busybox                Omit busybox from the list of known shells to
                                  check: awk in busybox appears to be
                                  significantly problematic in some versions,
                                  with frequent segmentation faults. Does not
                                  apply to shells specified manually with
                                  --shell.
                                  (Default: Use all known shells.)

      --[no-]quiet                Suppress most output. (Intended for use with
                                  --time).

      --[no-]trace                Display shell commands before executing.

      --time                      Run the tests under 'time -p' (for profiling).
                                  Implies '--no-assert'.

  -h, --help                      Display this text and exit.
  -v, --version                   Display version text and exit.

testwrapper Options:
--------------------

      --[no-]color/--[no-]colour  Use output colo[u]risation if possible.

      --[no-]assert               Disable test asserts, for most test this will
                                  only run the command being tested and omit
                                  any tests on the results. Useful for profiling
                                  and debugging.

      --[no-]test-platform-config Enable testing of platform workarounds.
                                  Intended for developers and not end users.

These options are not used directly by ${BS_TR_DU_Name}, but are forwarded to
'testwrapper'.

Option Aliases:
---------------
      --timed                     Alias for --time.
      --profile                   Alias for --time.

      --config                    Alias for --config-id.

Note:
-----

The arguments --tool and --test can be specified as either full paths or names.

When specified as names the files are searched for based on the default
structure of the BetterScripts repository with the location of ${BS_TR_DU_Name}
used as a starting point. If the environment variable BETTER_SCRIPTS_PATH is
set, the locations it specifies are searched first.

For the test directory, if nothing can be found in any of the other locations
the current working directory is searched.

--

Efforts have been taken to ensure that ${BS_TR_DU_Name} can be run in as limited
an environment as possible, however it may require a more standard compliant
implementation than those of the tests it invokes. Failure of ${BS_TR_DU_Name}
to correctly invoke tests is *not* an indication that the BetterScripts POSIX
Suite can not be used.

EndOfUsageText
}

################################################################################
################################################################################
#  ENTRY POINT
################################################################################
################################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Run...
case $# in
0) fn_bs_tr_main      ;;
*) fn_bs_tr_main "$@" ;;
esac

############################ DOCUMENTATION CONTINUED ###########################
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## VERSIONS
#.
#. v1.1.0       - \[NEW] Added `osh` as an automatically recognized shell.
#.              - \[NEW] Added `--locale` to allow running tests under
#.                alternative locales.
#.              - \[NEW] Added `--[no-]ignore-env` to allow ignoring current
#.                environment.
#.              - \[NEW] `busybox` can now be omitted via `--no-busybox` -
#.                `busybox` v0.36.0 has significant issues with `awk` that
#.                result in segmentation faults in many circumstances.
#.                Additionally, `busybox` is massively configurable and is
#.                often distributed in configurations that will fail tests
#.                while `defconfig` will pass.
#.              - \[NEW] Added additional statistics to final output.
#.              - \[FIXED] Corrected help text.
#.              - \[CHANGED] GNU locale environment variables are now _unset_
#.                rather than being set to a specific value.
#.              - \[CHANGED] Test now always run via `env`.
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
