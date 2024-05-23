<!-- #################################################################### -->
<!-- ############### THIS FILE WAS GENERATED FROM 'getarg' ############## -->
<!-- #################################################################### -->
<!-- ########################### DO NOT EDIT! ########################### -->
<!-- #################################################################### -->

# GETARGS

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## SYNOPSIS

    MyArgs="$(getarg <SPECIFICATION>... [--] <ARGUMENT>...)"
    ...
    eval "$MyArgs"

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

Command argument processing for scripts and script functions.

Parses all `<ARGUMENT>`s according to the configuration from `<SPECIFICATION>`.

The command 'getarg' is a wrapper script that allows 'libgetargs' to be
invoked directly.

[Documentation for 'libgetargs' applies](./libgetargs.md) (and is not
replicated here).

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## STANDARDS

- [_POSIX.1-2008_][posix]
  - also known as:
    - _The Open Group Base Specifications Issue 7_
    - _IEEE Std 1003.1-2008_
    - _The Single UNIX Specification Version 4 (SUSv4)_
  - the more recent
    [_POSIX.1-2017_][posix_2017]
    is functionally identical to _POSIX.1-2008_, but incorporates some errata
- [FreeBSD SYSEXITS(3)][sysexits]
  - while not truly standard, these are used by many projects
- [Semantic Versioning v2.0.0][semver]

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- -------------------------------------------------------------------- -->
<!-- REFERENCES -->
<!-- -------------------------------------------------------------------- -->

[markdown]:                  <https://daringfireball.net/projects/markdown/syntax>                                                "Markdown: Syntax [daringfireball.net]"
[commonmark]:                <https://commonmark.org/>                                                                            "CommonMark [spec.commonmark.org]"
[commonmark_spec]:           <https://spec.commonmark.org/current/>                                                               "CommonMark Spec (current) [spec.commonmark.org]"

[posix]:                     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                       "POSIX.1-2008 \[pubs.opengroup.org\]"
[posix_2017]:                <https://pubs.opengroup.org/onlinepubs/9699919799>                                                   "POSIX.1-2017 \[pubs.opengroup.org\]"
[posix_bre]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>     "Basic Regular Expression \[pubs.opengroup.org\]"
[posix_ere]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>     "Extended Regular Expression \[pubs.opengroup.org\]"
[posix_re_bracket_exp]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03_05>  "RE Bracket Expression \[pubs.opengroup.org\]"
[posix_param_expansion]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02> "Parameter Expansion \[pubs.opengroup.org\]"
[posix_getopts]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html>                "getopts \[pubs.opengroup.org\]"
[posix_utility_conventions]: <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap12.html>               "POSIX: Utility Conventions \[pubs.opengroup.org\]"
[posix_variable]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_230>    "Definitions: Name \[pubs.opengroup.org\]"

[sysexits]:                  <https://www.freebsd.org/cgi/man.cgi?sysexits(3)>                                                    "FreeBSD SYSEXITS(3) \[freebsd.org\]"
[semver]:                    <https://semver.org/>                                                                                "Semantic Versioning \[semver.org\]"

[util_linux]:                <https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/about/>                              "util-linux (about) \[git.kernel.org\]"

[pandoc]:                    <https://pandoc.org/>                                                                                "Pandoc \[pandoc.org\]"

[man_page]:                  <https://wikipedia.org/wiki/Man_page>                                                                "man page \[wikipedia.org\]"

[autoconf_portable]:         <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>           "autoconf: Portable Shell Programming \[gnu.org\]"

