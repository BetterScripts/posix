<!-- % % betterscripts-testharness(7) BetterScripts | BetterScripts POSIX Suite. -->
<!-- % % BetterScripts (better.scripts@proton.me)                            -->
<!-- ^^^^^^^^^^^^^^^^^^^^^^^^^^ `pandoc` metadata ^^^^^^^^^^^^^^^^^^^^^^^^^^ -->
<!-- SPDX-License-Identifier: MPL-2.0 -->
<!-- ############################### LICENSE ############################### -->
<!--                                                                         -->
<!-- BetterScripts 'tests/README.MD': Documentation about the BetterScripts  -->
<!--                                  POSIX Suite test harness.              -->
<!--                                                                         -->
<!-- Copyright (c) 2022 BetterScripts ( better.scripts@proton.me,            -->
<!--                                    https://github.com/BetterScripts )   -->
<!--                                                                         -->
<!-- This file is part of the BetterScripts POSIX Suite.                     -->
<!--                                                                         -->
<!-- This Source Code Form is subject to the terms of the Mozilla Public     -->
<!-- License, v. 2.0. If a copy of the MPL was not distributed with this     -->
<!-- file, You can obtain one at https://mozilla.org/MPL/2.0/.               -->
<!--                                                                         -->
<!-- ----------------------------------------------------------------------- -->
<!--                                                                         -->
<!-- ADDENDUM:                                                               -->
<!--                                                                         -->
<!-- In addition to the Mozilla Public License a copy of LICENSE.MD should   -->
<!-- have been be provided alongside this file; LICENSE.MD clarifies how the -->
<!-- Mozilla Public License v2.0 applies to this file and MAY confer         -->
<!-- additional rights.                                                      -->
<!--                                                                         -->
<!-- Should there be any apparent ambiguity (implied or otherwise) the terms -->
<!-- and conditions from the Mozilla Public License v2.0 shall apply.        -->
<!--                                                                         -->
<!-- If a copy of LICENSE.MD was not provided it can be obtained from        -->
<!-- https://github.com/BetterScripts/posix/LICENSE.MD.                      -->
<!--                                                                         -->
<!-- NOTE:                                                                   -->
<!--                                                                         -->
<!-- The Mozilla Public License v2.0 is compatible with the GNU General      -->
<!-- Public License v2.0.                                                    -->
<!--                                                                         -->
<!-- ----------------------------------------------------------------------- -->
<!-- cSpell:Ignore testharness testrunner  testwrapper                       -->
<!-- ####################################################################### -->
# TEST HARNESS

Test harness for the _BetterScripts POSIX Suite_ are written to run under the
test-harness available here.

## DESCRIPTION

The test harness consists of two files:

------------------------------------------------------------

[`testrunner.sh`](./testrunner.sh)

- The main script used to run tests.
- Can execute multiple tests under multiple shells, with
  tracking of any errors.
- Also provides simple timing options (useful for performance testing).
- Although standards compliant, _may_ require a more capable environment than
  required by _the Suite_ itself.
  - For example, `testrunner.sh` can **not** be run in a restricted environment,
    although such environments _are_ supported for `.testwrapper.sh` and any
    associated tests, along with _the Suite_ tools themselves.
- Ensures the tool being tested can be located via the `PATH` environment
  variable.
- If no specific shell is specified for testing, will innumerate _all_ known
  shells and invoke as many as found for _all_ tests. (This can take a long
  time to complete!)

------------------------------------------------------------

[`.testwrapper.sh`](./.testwrapper.sh)

- A wrapper used to load and run a specific test script.
- Provides a number of commands that tests can invoke to
  avoid a lot of needless repetition.
- **_Not intended to be invoked directly._**

------------------------------------------------------------

- Both scripts provide simple `--help` options that describe many of the
  available options and capabilities.
- All options to `testrunner.sh` are _optional_ **except** a tool to test.
  - The tool can be specified by path or by name (if it exists in one of the
    expected locations).
- Tests are located in the directory with the same name as the tool being tested
  (excluding any file suffix), but single tests can also be specified.
- For interactive terminals the following options are particularly useful:
  - `--exit` to stop tests on the first error.
  - `--color` to colorize output (where supported).

------------------------------------------------------------

_Helper scripts are provided to run all tests for each of_ the Suite _tools._

------------------------------------------------------------
------------------------------------------------------------

**_Additional documentation to be provided!_**
