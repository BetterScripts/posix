<!-- SPDX-License-Identifier: MPL-2.0 -->
<!-- ############################### LICENSE ############################### -->
<!--                                                                         -->
<!-- BetterScripts 'CONTRIBUTING.MD': Information concerning making          -->
<!--                                  contributions to the Suite.            -->
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
<!-- ####################################################################### -->

# CONTRIBUTING

Contributions are encouraged!

Submissions should be made to the primary
[_BetterScripts POSIX Suite_ repository][betterscripts_git].

## LICENSE

All contributions will be distributed with the _BetterScripts POSIX Suite_ under
the same [terms and conditions](./LICENSE.MD) as the suite itself; submitting a
contribution is an implicit acceptance of the contribution being licensed as
such.

Any contribution that can not be licensed using the same terms and conditions as
the suite itself can not be accepted.

## GUIDELINES

All contributions are expected to follow the guidelines here, which are a work
in progress and are likely to be subject to change over time.

These guidelines are _not_ absolute: where there is suitable cause a
contribution is not _necessarily_ required to strictly adhere to all guidelines.

### PORTABILITY

The _BetterScripts POSIX Suite_ aims to be portable to any environment that is
compliant with [_POSIX.1-2008_][posix] (at a minimum). Wherever possible this
means the suite is written entirely as specified by the standard. Where this is
not possible (e.g. implementation issues, performance, etc.) multiple code paths
are provided where one (or more) are narrowly targeted at a specific issue or
environment, with another code path that remains fully standards compliant and
is used where possible.

Where the [_POSIX.1-2008_ standard][posix] specifies something that is known to
be poorly supported in one or more environments, either it should be avoided
entirely or should be supported with a suitable workaround, unless it is related
to something so fundamental that supporting alternatives would hinder other
code.

For example:

- Setting `IFS` to specific values is not portable and is almost entirely
  prohibited within the suite.
- "Parameter Expansion" (i.e. `${parameter:...}`) is so fundamental that
  it is a requirement and any platform that does not deal with it correctly is
  unlikely to be supported by the suite as a whole.
- Regular expression classes (e.g. `[:alpha:]`) may not be portable, but are
  easily replaced with explicit character sets.

Where any code targets a specific implementation or environment it must:

- be self-contained;
- accurately, narrowly, target the specific use case(s);
- not significantly affect the performance for other environments.

### STYLE

All contributions must follow the same style as used in the surrounding code
or documentation, or, for new files, must follow the same style as an
appropriate existing file.

All code files should contain appropriate documentation for both future editors
and users in the appropriate formats.

Terms should follow the recommendations from
["Inclusive Naming Initiative"][inclusivenaming].

### LINTING

All files should validate cleanly with an appropriate linter, with most checks
enabled. Where a linter warning is clearly in error, it can be disabled, but
must be disabled as locally as possible and both the linter error and the
reason it is disabled must be documented.

Linters:

- shell scripts (`.sh`) use [`shellcheck`][shellcheck]
- markdown files (`.md`) use [`markdownlint`][markdownlint]

**_Generated files should also be subject to the appropriate linter._**
(However, due to the nature of generated files a fully clean validation is often
not required, and occasionally not desirable.)

### TESTING

Code files must be tested under at least 2 different implementations of **all**
tools used (those tested should be noted in a submission).

For many modern shell implementations a large number of utilities are builtin
to the shell itself, however the list of utilities for which this is the case
varies between implementations and does not normally include those utilities
which are more complex (e.g. `awk`, `grep`, `sed`, etc.). Therefore it is
often not sufficient to test under multiple shell implementations, but will in
addition requires multiple implementations of other utilities.

Tools like [`busybox`][busybox] are useful for
testing, as they offer unique implementations of many of the utilities in a
single package.

### BUGFIXES

Any code bugfixes should be made against an existing bug from the project
[bug tracker][betterscripts_issues]. If no bug exists, then one should be
created before the fix is submitted.

These fixes should also be documented in code with reference to the bug ID.

Where practicable a suitable test should be made to detect the bug in question.
Such tests should be contained in a single test file, named for the bug ID.

### NEW FUNCTIONALITY

New functionality is welcomed, however such functionality is expected to
provide a portable solution to an issue that is likely to be encountered in a
_POSIX.1_ environment by a large number of other users.

It is unlikely that domain specific functionality will be accepted.

<!-- ----------------------------------------------------------------------- -->
<!-- REFERENCES -->
<!-- ----------------------------------------------------------------------- -->

[betterscripts_git]:      <https://github.com/BetterScripts/posix>                        "BetterScripts POSIX Suite \[github.com\]"
[betterscripts_issues]:   <https://github.com/BetterScripts/posix/issues>                 "BetterScripts POSIX Suite \[github.com\]"

[posix]:                  <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>  "POSIX.1-2008 \[pubs.opengroup.org\]"

[shellcheck]:             <https://www.shellcheck.net/>                                   "shellcheck \[shellcheck.net\]"
[markdownlint]:           <https://github.com/DavidAnson/markdownlint/>                   "markdownlint \[github.com\]"

[busybox]:                <https://busybox.net/>                                          "busybox \[busybox.net\]"

[inclusivenaming]:        <https://inclusivenaming.org/>                                  "Inclusive Naming Initiative \[inclusivenaming.org\]"
