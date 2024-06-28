#!/usr/bin/env sh
# SPDX-License-Identifier: MPL-2.0
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'libarray' Test Runner: Run all 'libarray' tests.            *#
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

################################################################################
## cSpell:Ignore testrunner testwrapper libarray
################################################################################

#===============================================================================
#===============================================================================
# Set PATH
#===============================================================================
#===============================================================================
case ${BETTER_SCRIPTS_PATH:+1} in
1)  PATH="${BETTER_SCRIPTS_PATH}:${PATH:+:${PATH#:}}"
    export PATH ;;
esac

#===============================================================================
#===============================================================================
# Try to locate the runner script
#===============================================================================
#===============================================================================
BS_TEST_RUNNER__Script=;
case $(testrunner.sh --version 2>&1) in
"BetterScripts 'testrunner' "*)
  BS_TEST_RUNNER__Script='testrunner.sh'
;;

*)  for BS_TEST_RUNNER_Directory in '.' "$(pwd)" "${0%/*}"
    do
      test -d "${BS_TEST_RUNNER_Directory}" || continue

      if test -x "${BS_TEST_RUNNER_Directory}/testrunner.sh"; then
        BS_TEST_RUNNER__Script="${BS_TEST_RUNNER_Directory}/testrunner.sh"
        break
      elif test -x "${BS_TEST_RUNNER_Directory}/tests/testrunner.sh"; then
        BS_TEST_RUNNER__Script="${BS_TEST_RUNNER_Directory}/tests/testrunner.sh"
        break
    fi
    done ;;
esac

: "${BS_TEST_RUNNER__Script:=testrunner.sh}"

#===============================================================================
#===============================================================================
# Add color for terminals
#===============================================================================
#===============================================================================
if test -t 1 && test -t 2; then
  case $* in
  *color*|*colour*) ;; ## cSpell:Ignore colour
                 *) set -- --color ${1+"$@"} ;;
  esac
fi

#===============================================================================
#===============================================================================
# Run the script
#===============================================================================
#===============================================================================
exec "${BS_TEST_RUNNER__Script}" --tool 'libarray.sh' ${1+"$@"}

################################################################################
# END
################################################################################
