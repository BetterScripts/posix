# SPDX-License-Identifier: MPL-2.0
#################################### LICENSE ###################################
#******************************************************************************#
#*                                                                            *#
#* BetterScripts 'Makefile': Generate/Install BetterScript POSIX Suite        *#
#*                           Libraries and Documentation.                     *#
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

################################### MAKEFILE ###################################
## cSpell:IgnoreRegExp [A-Z]+FLAGS install[a-z]+
## cSpell:IgnoreRegExp install[a-z]+
#:
#: # MAKEFILE
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## SYNOPSIS
#:
#:     make [<OVERRIDES>] <target>
#:
#:     make help
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## DESCRIPTION
#:
#: _BetterScripts POSIX Suite_ makefile that provides operations for installing
#: and documentation generation for all suite library files.
#:
#: Although written in _POSIX.1_ standard `make`, this file follows many of the
#: conventions of other projects (at least in terms of the available targets and
#: overridable macros). Distributors should be familiar with the general usage,
#: although some changes have been necessary in order to avoid any non-standard
#: code.
#:
#: <!-- ------------------------------------------------ -->
#:
#: ### Install
#:
#: Libraries and documentation can be installed in specified directories (by
#: default these are system wide).
#:
#: Libraries are intended to be sourced by other scripts and not executed
#: directly (any exceptions to this will be noted with the library
#: documentation). For this usage the
#: [standard says:][posix_dot]
#:
#: > If file does not contain a \<slash>, the shell shall use the search path
#: > specified by PATH to find the directory containing file. Unlike normal
#: > command search, however, the file searched for by the dot utility need
#: > not be executable.
#:
#: Therefore although installed libraries are normally installed to a system
#: binary directory, they are made non-executable for all users.
#:
#: Some libraries are also available as executable versions. These **are**
#: installed with executable permissions.
#:
#: Documentation is installed as markdown in the system documentation directory
#: and `man` pages, which are placed in the directory appropriate for the
#: category of each file.
#:
#: <!-- ------------------------------------------------ -->
#:
#: ### Documentation Generation
#:
#: Most library documentation is written as comments in the library files
#: themselves, this can be extracted to standalone files and processed into
#: more user friendly formats. The main documentation format is `markdown`
#: however if [`pandoc`][pandoc] is available it is also possible to generate
#: `man` pages. (`pandoc` can also be used to generate other documentation
#: formats, but these are not directly supported here.)
#:
#: The main _BetterScripts POSIX Suite_ repository contains the latest version
#: of the documentation as generated from the library files, however these can
#: be replaced with versions generated from this makefile if desired.
#:
################################ DOCUMENTATION #################################

################################################################################
################################################################################
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## INITIALIZATION
#.
################################################################################
################################################################################

#. - Ensure _POSIX_ mode.
.POSIX:

#. - Delete predefined suffixes.
.SUFFIXES:

################################################################################
################################################################################
#.
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## USER CONFIG
#:
#: - Macros that can modify output or allow for platform specific overrides.
#: - Unset macros are commented out to avoid accidental blank characters being
#:   inserted - in some places blank characters will make a difference (these
#:   characters should never appear in a standard compliant implementation, but
#:   such behavior is not guaranteed).
#: - Many of the macros used are those defined by the
#:   [_GNU Makefile Conventions_][gnu_makefile_conventions] - as these are
#:   widely used and are familiar to many.
#:
################################################################################
################################################################################

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### `DOC_LEVEL`
#:
#: - Verbosity of documentation: higher values include
#:   additional information.
#: - Valid Values: '1' or '2'.
#: - Default is 1.
#: - Changes to `DOC_LEVEL` will NOT cause documentation to
#:   be regenerated _unless_ the source files have also
#:   changed.
#: - Some source files may produce the same output for
#:   different values of `DOC_LEVEL`.
#:
#===========================================================
DOC_LEVEL = 1

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### COMMANDS
#:
#: - Command macros and arguments.
#: - Allow overriding of commands that may need platform
#:   specific versions or usage. (Only the most basic
#:   commands should be used without macros).
#: - Follows conventions from
#:   [_GNU Utilities in Makefiles_][gnu_utilities_in_makefiles]
#:   and
#:   [_GNU Command Variables_][gnu_command_variables].
#:
#===========================================================

#-----------------------------------------------------------
#: ---------------------------------------------------------
#:
#: [`pandoc`][pandoc] - used to generate `man` documentation
#:
#: - `PANDOC` - main command
#: - `PANDOCFLAGS` - common arguments
#: - `PANDOCMANFLAGS` - arguments used when
#:   `--to man` is used
#:
#-----------------------------------------------------------
PANDOC			= pandoc
PANDOCFLAGS 	= --quiet --standalone
PANDOCMANFLAGS  = --shift-heading-level-by=1

#-----------------------------------------------------------
#: ---------------------------------------------------------
#:
#: `sed` - used to generate all documentation
#:
#: - `SED` - main command
#: - `SEDFLAGS` - common arguments
#:
#-----------------------------------------------------------
SED			= sed
#SEDFLAGS	=

#-----------------------------------------------------------
#: ---------------------------------------------------------
#:
#: `chmod` - used to set mode for installed files
#:
#: - `CHMOD` - main command
#: - `CHMODFLAGS` - common arguments
#: - The mode is always specified as octal
#:   with a leading `0` (`<zero>`).
#: - ONLY used to set _file_ modes when installing.
#: - If the (non-standard) `install` command is used for the
#:   `INSTALL` macro, the `CHMOD` macro MAY be set to a
#:   no-op provided the correct mode is set using the `-m`
#:   argument to `install`.
#:
#-----------------------------------------------------------
CHMOD		= chmod
#CHMODFLAGS	=

#-----------------------------------------------------------
#: ---------------------------------------------------------
#:
#: `mkdir` - used to create missing installation directories
#:
#: - `MKDIR` - main command
#: - `MKDIRFLAGS` - common arguments
#: - The system default ownership and mode will be used for
#:   any created paths (unless otherwise specified with
#:   `MKDIRFLAGS`).
#: - Any command and arguments specified MUST be equivalent
#:   to invoking `mkdir -p` as specified by the _POSIX.1_
#:   standard.
#: - If MKDIR is empty `mkdir -p` is emulated by iterating
#:   over the path and using `mkdir` on each missing path
#:   segment, however it is likely this will not handle
#:   edge cases well.
#. - See `_cmd__MKPATH` for emulation.
#:
#-----------------------------------------------------------
#MKDIR			=
MKDIRFLAGS		= -p

#-----------------------------------------------------------
#: ---------------------------------------------------------
#:
#: `install` - command used to install files
#:
#: - `INSTALL` - main command
#: - `INSTALL_PROGRAM` - command for program files
#: - `INSTALL_DATA` - command for data files
#: - In most uses `INSTALL_PROGRAM` would install files to
#:   a binary directory and set them as executable, however
#:   the libraries installed by this file are explicitly
#:   made non-executable.
#: - The non-standard command `install` can be used for
#:   the `INSTALL` macro - this is the normal default for
#:   this macro (in other projects), the normal default for
#:   `INSTALL_DATA` then uses the `-m 644` arguments.
#:
#-----------------------------------------------------------
INSTALL			= cp -f
INSTALL_PROGRAM	= $(INSTALL)
INSTALL_DATA	= $(INSTALL)

#-----------------------------------------------------------
#: ---------------------------------------------------------
#:
#: `TESTFLAGS` - flags passed to each test when invoked
#:
#: - See the library test files for available arguments.
#:
#-----------------------------------------------------------
#TESTFLAGS	=

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### DIRECTORY VARIABLES
#:
#: - Install path macros.
#: - Allow overriding of target paths for all installed
#:   files.
#: - Follows conventions from
#:   [_GNU Directory-Variables_][gnu_directory_variables]
#:   and
#:   [_GNU DESTDIR_][gnu_destdir].
#:
## cSpell:Ignore bindir datarootdir docdir mandir DESTDIR
#===========================================================

#-----------------------------------------------------------
#: _COMMON_
#: <!-- -->
#:
#: `DESTDIR`
#:
#: : common prefix for ALL target paths. (See
#:   [_GNU DESTDIR_][gnu_destdir].)
#:
#-----------------------------------------------------------
#DESTDIR	=

#-----------------------------------------------------------
#: _BINARY/LIBRARY_
#: <!-- ------- -->
#:
#: `prefix`
#:
#: : root directory for installs.
#:
#: `exec_prefix`
#:
#: : root directory for binary files.
#:
#: `bindir`
#:
#: : final directory for binary files.
#:
#-----------------------------------------------------------
prefix		= /usr/local
exec_prefix	= $(prefix)
bindir		= $(exec_prefix)/bin

#-----------------------------------------------------------
#: _DATA/DOCUMENTATION_
#: <!-- ----------- -->
#:
#: `datarootdir`
#:
#: : root directory for data files.
#:
#: `docdir`
#:
#: : final directory for documentation files.
#:
#: `mandir`
#:
#: : root directory for `man` files.
#:
#: Each `man` category has two macros, of the form
#: `man1dir` and `man1ext` for the numbers 1 through 8,
#: where:
#:
#: `man<N>dir`
#:
#: : final directory for `man` files for category `<N>`
#:
#: `man<N>ext`
#:
#: : final extension for `man` files for category `<N>`
#:
#: The local `man` files will use simple numerical
#: extensions that match the file category, but will use
#: the specified extension for any installed file.
#:
#-----------------------------------------------------------
datarootdir	= $(prefix)/share

docdir		= $(datarootdir)/doc/betterscripts

mandir		= $(datarootdir)/man

man1dir		= $(mandir)/man1
man1ext		= .1
man2dir		= $(mandir)/man2
man2ext		= .2
man3dir		= $(mandir)/man3
man3ext		= .3
man4dir		= $(mandir)/man4
man4ext		= .4
man5dir		= $(mandir)/man5
man5ext		= .5
man6dir		= $(mandir)/man6
man6ext		= .6
man7dir		= $(mandir)/man7
man7ext		= .7
man8dir		= $(mandir)/man8
man8ext		= .8

################################################################################
################################################################################
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## INTERNAL MACROS
#.
#. - All internal macros have a prefix consisting of one or
#.   more `_` (`<underscore>`) characters.
#. - SHOULD NOT be overridden outside of this file.
#.
################################################################################
################################################################################

#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### FILE LISTS
#.
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. `__list__LIBRARY_FILES`
#. <!-- -------------- -->
#.
#. : All library files, installed to `bindir`.
#. : Library files are explicitly **not** executable.
#. : Also sources for document generation.
#.
#. `__list__BINARY_FILES`
#. <!-- -------------- -->
#.
#. : All binary files, installed to `bindir`.
#. : Unlike the library files, these are made executable.
#.
#. `__list__MAN_FILES`
#. <!-- ---------- -->
#.
#. : Local name for all man files.
#. : Installed to `man<N>dir` with extension `man<N>ext`
#.   depending on the category of the `man` page.
#.
#. `__list__MD_FILES`
#. <!-- ------ -->
#.
#. : Markdown documentation files.
#. : MAY be generated from `__list__LIBRARY_FILES` or
#.   used as is.
#.
#. `__list__TESTS`
#. <!-- ------ -->
#.
#. : List of test files that can be run;
#. : Only used when explicitly invoked using the `test` or
#.   `check` targets.
#.
## cSpell:Ignore libgetargs getargs getarg libarray libdeque
## cSpell:Ignore libarray
## cSpell:Ignore libdeque
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
__list__LIBRARY_FILES	= libgetargs.sh	libarray.sh	\
						  libdeque.sh
__list__BINARY_FILES	= getarg

__list__MAN_FILES		= $(__list__LIBRARY_FILES:.sh=.7) \
						  betterscripts.7 getarg.1

__list__MD_FILES		= $(__list__LIBRARY_FILES:.sh=.md) \
						  README.MD getarg.md

__list__TESTS			= tests/test_libgetargs.sh \
						  tests/test_libarray.sh \
						  tests/test_libdeque.sh

#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### CHARACTER HELPERS
#.
#. It is very difficult to safely and portably use some
#. characters in a makefile, these macros can be used to
#. work around some of the issues.
#.
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. `_set_shell__char_NUMBER_SIGN`
#. <!-- ------------------- -->
#.
#. : Sets the shell variable `_char_NUMBER_SIGN` to the
#.   `#` (`<number-sign>`) character;
#. : This macro can be expanded _in the same command_ as
#.   a command where the `#` character is required, which
#.   can then be accessed by the command through the shell
#.   variable;
#. : The `#` (`<number-sign>`) character is the comment
#.   character for makefiles and the usage of it in macros
#.   can NOT be done portably, while the usage in rules IS
#.   possible, it requires some care;
#. : Where this macro is expanded, care needs to be taken
#.   to ensure the expansion will be part of the same `make`
#.   command as any accesses to the shell variable -
#.   otherwise the variable will be empty.
#.
#> |_NUMBER_SIGN:#|
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_set_shell__char_NUMBER_SIGN	= _char_NUMBER_SIGN="$$(sed -n -s 's/^.> |_NUMBER_SIGN:\(.\)|$$/\1/p' Makefile)"

#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### REGULAR EXPRESSIONS
#.
#. ["Basic Regular Expressions" (_BRE_)][posix_bre] for
#. matching documentation to extract from various files.
#.
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. `_bre__DOC_LVL`
#. <!-- ------ -->
#.
#. : A _BRE_ that matches documentation prefixes based on
#.   the value of `DOC_LEVEL`;
#. : `DOC_LEVEL` MUST be valid for this to work as intended
#.   (if it is not exactly one of the supported values the
#.   extracted documentation will likely be useless);
#. : The `__validate__DOC_LEVEL` can be used to validate
#.   `DOC_LEVEL` in places `_bre__DOC_LVL` is to be used.
#.
#. _NOTES_
#. <!-- -->
#.
#. - Trailing blank characters WILL cause errors
#. - `DOC_LEVEL` values supported here are 1, 2, and 3,
#.   however only 1 and 2 are supported elsewhere. (Level 3
#.   is intended for internal usage.)
#. - Standard `make` is very restrictive, so doing something
#.   like this needs something that is a bit of a hack and
#.   somewhat fragile.
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
__bre__DOC_LVL_1	= $(DOC_LEVEL:1=:)
__bre__DOC_LVL_2	= $(__bre__DOC_LVL_1:2=:;)
 _bre__DOC_LVL		= $(__bre__DOC_LVL_2:3=:;.)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. `_bre__<SRC>_<TGT>_DOC_PREFIX|SUFFIX`
#. <!-- ---------------------------- -->
#.
#. : A number of _BRE_ macros that match the prefix and
#.   any suffix required when extracting documentation from
#.   the source format `<SRC>` for the target format;
#. : A prefix is required for all source formats, but only
#.   some formats need a suffix;
#. : Prefixes match ALL preceding blank characters, while
#.   suffixes match ALL succeeding blank characters;
#. : A single blank character is required after a PREFIX and
#.   before a SUFFIX.
#.
#. `_bre__SH_MD_DOC_PREFIX`
#. <!-- --------------- -->
#.
#. : Source is a shell script;
#. : Target is a markdown file;
#. : REQUIRES the `_set_shell__char_NUMBER_SIGN` macro be
#.   expanded _before_ the _BRE_ is used;
#. : REQUIRES shell variable expansion (i.e. can NOT be
#.   used in a string quoted with `'` (`<apostrophe>`))
#.
#. `_bre__SH_MAN_DOC_PREFIX`
#. <!-- ---------------- -->
#.
#. : Source is a shell script;
#. : Target is a `man` page.
#. : REQUIRES the `_set_shell__char_NUMBER_SIGN` macro be
#.   expanded _before_ the _BRE_ is used;
#. : REQUIRES shell variable expansion (i.e. can NOT be
#.   used in a string quoted with `'` (`<apostrophe>`))
#.
#. `_bre__MD_MAN_DOC_PREFIX`
#. <!-- ---------------- -->
#.
#. : Source is a markdown file;
#. : Target is a `man` page.
#.
#. `_bre__MD_MAN_DOC_SUFFIX`
#. <!-- ---------------- -->
#.
#. : Source is a markdown file;
#. : Target is a `man` page.
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_bre__SH_MD_DOC_PREFIX		= [ \t]*$${_char_NUMBER_SIGN:?}[$(_bre__DOC_LVL)][ \t]\{0,1\}
_bre__SH_MAN_DOC_PREFIX		= [ \t]*$${_char_NUMBER_SIGN:?}[$(_bre__DOC_LVL)%][ \t]\{0,1\}
_bre__MD_MAN_DOC_PREFIX		= [ \t]*<!--[ \t]\{1,\}[%][ \t]\{0,1\}
_bre__MD_MAN_DOC_SUFFIX		= [ \t]\{1,\}-->[ \t]*

#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### COMMAND MACROS
#.
#. Since multiple targets need the same operations, it's
#. more convenient to make some commands into macros.
#.
#. _NOTES_
#. <!-- -->
#.
#. - Each macro specifies where any input/output is
#.   expected, care MUST be taken to ensure these are
#.   correctly set in all cases when the macro is used.
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Unfortunately there is no way to pass values to a
#.   `make` macro (in standard `make`), limiting the
#.   usefulness of command macros. There are a few possible
#.   solutions:
#.   - command arguments can be specified as values
#.     following the macro use:
#.     `$(CHMOD) $(CHMODFLAGS) 0644 <FILE>`
#.   - command arguments can be specified as known `make`
#.     macros, e.g. the special macros `$<`, `$*`, etc
#.   - the macro can require it is expanded in a `make`
#.     target command that is part of a longer shell
#.     command, so arguments can be stored in known shell
#.     variables
#.   - occasionally a `make` target can be used in place of
#.     a macro, allowing the special macros `$<`, `$*`, etc
#.     to be abused as more general arguments
#.   none of these is ideal and all are somewhat fragile,
#.   but without moving functionality to an external script,
#.   or requiring a more capable version of `make` these are
#.   the only options.
#. - Care needs taken when creating macros as they can be
#.   expanded in almost any location. The liberal use of
#.   `;` (`<semicolon>`) separators is necessary, especially
#.   for multi-line macros which will be interpreted by the
#.   shell as they will be seen as a single line. However,
#.   a trailing `;` (`<semicolon>`) in a macro can lead to
#.   the shell receiving the token `;;` (i.e., the `case`
#.   separator), which will lead to errors.
#.
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. _MACROS_
#. <!-- -->
#.
#. ---------------------------------------------------------
#.
#. `_cmd__SH_TO_MD`
#. <!-- ------- -->
#.
#. Generate a markdown file from a shell script.
#.
#. _SOURCE_
#. <!-- -->
#.
#. `$<` (i.e. the `make` target input file)
#.
#. _TARGET_
#. <!-- -->
#.
#. `$@` (i.e. the `make` target output file)
#.
#. _NOTES_
#. <!-- -->
#.
#. - Document generator: extracts lines from a file where
#.   comments are delimited by `#`.
#. - Intended to be used for "Inference Rules" where source
#.   is a shell script and target is a markdown file.
#. - Output is edited to better match basic markdown.
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Standard `make` only defines `$<` usage in
#.   "Inference Rules", usage in other locations is
#.   non-portable.
#. - `sed` script:
#.   - delete lines that DON'T match the markdown doc prefix
#.   - remove the markdown doc prefix
#.   - if the line contains a definition list convert it to
#.     a unnumbered list (this uses two matches to account
#.     for spaces that need preserved)
#.     - definition lists are useful in `man` output, but
#.       not widely supported for markdown
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_cmd__SH_TO_MD	= \
	{ \
	  echo "Generating ${@F} from ${<F}"; \
	  $(_set_shell__char_NUMBER_SIGN); \
	  $(SED) \
	    $(SEDFLAGS) \
	    -e " /^$(_bre__SH_MD_DOC_PREFIX)/!d; \
	        s/^$(_bre__SH_MD_DOC_PREFIX)//;  \
	         /^[ \t]*:[ \t]/{ \
	          s/^:\([ \t]\)/-\1/; \
	          s/^\([ \t]\{1,\}\):\([ \t]\)/\1-\2/; \
	        }" \
	    "$<" > "$@"; \
	}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. `_cmd__SH_TO_MAN`
#. <!-- -------- -->
#.
#. Generate a `man` page file from a shell script.
#.
#. _SOURCE_
#. <!-- -->
#.
#. `$<` (i.e. the `make` target input file)
#.
#. _TARGET_
#. <!-- -->
#.
#. `$@` (i.e. the `make` target output file)
#.
#. _NOTES_
#. <!-- -->
#.
#. - Document generator: extracts lines from a file where
#.   comments are delimited by `#`
#. - Intended to be used for "Inference Rules" where source
#.   is a shell script and target is a `man` file.
#. - Extracted data is converted from markdown to `man`
#.   via [`pandoc`][pandoc].
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Standard `make` only defines `$<` usage in
#.   "Inference Rules", usage in other locations is
#.   non-portable.
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_cmd__SH_TO_MAN	= \
	{ \
	  echo "Generating ${@F} from ${<F}"; \
	  $(_set_shell__char_NUMBER_SIGN); \
	  { \
	    $(SED) \
	      $(SEDFLAGS) \
	      -n \
	      -e "s/^$(_bre__SH_MAN_DOC_PREFIX)//p;" \
	      "$<"; \
	  } | { \
	    $(PANDOC) \
	      $(PANDOCFLAGS) \
	      $(PANDOCMANFLAGS) \
	      --from markdown \
	      --to man \
	      -o "$@"; \
	  }; \
	}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. `_cmd__MD_TO_MAN`
#. <!-- -------- -->
#.
#. Generate a `man` page file from a markdown file.
#.
#. _SOURCE_
#. <!-- -->
#.
#. `$<` (i.e. the `make` target input file)
#.
#. _TARGET_
#. <!-- -->
#.
#. `$@` (i.e. the `make` target output file)
#.
#. _NOTES_
#. <!-- -->
#.
#. - Document generator: extracts lines from a file where
#.   comments are contained between `<!--` and `-->`
#. - Intended to be used for "Inference Rules" where source
#.   is a markdown file and target is a `man` file. (The
#.   standard says `$<` can ONLY be used in
#.   "Inference Rules")
#. - Extracted data is converted from markdown to `man`
#.   via [`pandoc`][pandoc].
#. - The markdown file can contain specially formatted
#.   comments which will be seen by `pandoc` as normal
#.   markdown, allowing `man` specific details included in
#.   the markdown which is normally hidden. (This is useful,
#.   for example, to set `pandoc` metadata.)
#. - This command is intended for documents with are in
#.   markdown format to begin with and not those that were
#.   extracted from script files. Applying `_cmd__SH_TO_MD`
#.   followed by `_cmd__MD_TO_MAN` does NOT necessarily
#.   produce the same as applying `_cmd__SH_TO_MAN`
#.   - having slightly different formats  makes the source
#.     documents more easily human parsable without
#.     extraction and is a little more efficient.
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_cmd__MD_TO_MAN	= \
	{ \
	  echo "Generating ${@F} from ${<F}"; \
	  { \
	    $(SED) \
	      $(SEDFLAGS) \
	      -e 's/^$(_bre__MD_MAN_DOC_PREFIX)\(.*\)$(_bre__MD_MAN_DOC_SUFFIX)$$/\1/' \
	      "$<"; \
	  } | { \
	    $(PANDOC) \
	      $(PANDOCFLAGS) \
	      $(PANDOCMANFLAGS) \
	      --from markdown \
	      --to man \
	      -o "$@"; \
	  }; \
	}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ---------------------------------------------------------
#.
#. `_cmd__MKPATH`
#. <!-- ----- -->
#.
#. `mkdir -p` for all platforms.
#.
#. _SOURCE_
#. <!-- -->
#.
#. `_MKPATH_PATH` (i.e. the shell variable _MKPATH_PATH)
#.
#. _NOTES_
#. <!-- -->
#.
#. - `mkdir -p` is useful but less portable than it should
#.   be, unfortunately simply avoiding it means requiring
#.   users ensure most paths already exist which is,
#.   at best, tiresome.
#. - If a platform has a suitable `mkdir` command then the
#.   user can set the `MKDIR` macro and it will be used,
#.   otherwise `mkdir -p` will be emulated.
#. - For any platform that lacks `mkdir -p` and where
#.   emulation fails, a script can be written that can be
#.   invoked using the `MKDIR` macro. The GNU project has
#.   such a script named [`mkinstalldirs`][automake_aux_bin]
#.   which should be suitable for most use cases.
#.
#. _IMPLEMENTATION NOTES_
#. <!-- ------------- -->
#.
#. - Emulated `mkdir -p` works by extracting each directory
#.   portion from the start of the path in turn and creating
#.   any that don't exist
#.   - for most "normal" paths this emulated version should
#.     work much as `mkdir -p`, however, some paths may
#.     not work as expected (e.g. no attempt is made to
#.     deal with circular references)
#.   - because `make` can be run in parallel it is possible
#.     that creating a non-existing directory will fail
#.     because a parallel job created it between the test
#.     and the attempt to create it in the current job, to
#.     avoid this appearing as a `make` error, a failure
#.     to create a directory is not considered an error
#.     unless the directory still does not exist
#.   - the mode for created directories is the system
#.     default, it is never set explicitly
#.
## cSpell:Ignore MKPATH
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_cmd__MKPATH = \
	{ \
	  _MKDIR=$(MKDIR); \
	  case $${_MKDIR:+1} in \
	  1)  $(MKDIR) $(MKDIRFLAGS) "$${_MKPATH_PATH}" ;; \
	  *)  case $${_MKPATH_PATH} in \
	      /*) _MKPATH_PARTIAL=/; \
	             _MKPATH_PATH="$$(expr "$${_MKPATH_PATH}" : '/\{1,\}\(.*\)$$')" ;; \
	      *) _MKPATH_PARTIAL=; ;; \
	      esac; \
	      \
	      _MKPATH_PATH="$${_MKPATH_PATH%/}/"; \
	      \
	      while : ; \
	      do \
	        case $${_MKPATH_PATH} in \
	          '') break ;; \
	        */?*) _MKPATH_SEGMENT="$${_MKPATH_PATH%%/*}"; \
	                 _MKPATH_PATH="$$(expr "$${_MKPATH_PATH}" : '[^/]*/\(.*\)$$')" ;; \
	           *) _MKPATH_SEGMENT="$${_MKPATH_PATH}"; _MKPATH_PATH=; ;; \
	        esac; \
	        \
	        case $${_MKPATH_SEGMENT:-/} in [/.]) continue ;; esac; \
	        \
	        _MKPATH_PARTIAL="$${_MKPATH_PARTIAL:-}$${_MKPATH_SEGMENT}/"; \
	        \
	        if test -d "$${_MKPATH_PARTIAL}"; then continue; fi; \
	        \
	        if mkdir "$${_MKPATH_PARTIAL}"; then \
	          continue; \
	        else \
	          test -d "$${_MKPATH_PARTIAL}"; \
	        fi; \
	      done \
	    ;; \
	  esac; \
	}

################################################################################
################################################################################
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## TARGETS
#:
################################################################################
################################################################################

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### USAGE INFO
#:
#===========================================================

#-----------------------------------------------------------
#: `help`
#:
#: : Write usage information to `STDOUT`.
#: : Used as default target if none is specified.
#: : MUST be first target in file.
#:
#-----------------------------------------------------------
help:
	@echo 'Targets'
	@echo '-------'
	@echo ''
	@echo '  md, markdown      Generate `markdown` format documentation.'
	@echo '  man               Generate `man` format documentation.'
	@echo '  doc               Generate documentation in all formats.'
	@echo ''
	@echo '  [un]installmd     Uninstall/Install `markdown` documentation.'
	@echo '  [un]installman    Uninstall/Install `man` documentation.'
	@echo '  [un]installdoc    Uninstall/Install all documentation.'
	@echo ''
	@echo '  [un]installlib    Uninstall/Install library files.'
	@echo '  [un]installbin    Uninstall/Install binary files.'
	@echo '                    (Also uninstalls/installs library files as'
	@echo '                     these are required by the binary files.)'
	@echo ''
	@echo '  [un]install       Uninstall/Install everything.'
	@echo ''
	@echo '  check, test       Run available tests for all libraries.'
	@echo '                    (Macro TESTFLAGS can be used.)'
	@echo ''
	@echo 'Macros'
	@echo '------'
	@echo ''
	@echo 'Configuration macros:'
	@echo ''
	@echo '  DOC_LEVEL          Allows editing the level of documentation'
	@echo '                     extracted, valid values are 1 or 2.'
	@echo '                     (Only relevant to document generation.)'
	@echo ''
	@echo 'Info'
	@echo '----'
	@echo ''
	@echo 'Installation requires only very basic utilities (e.g. `cp`, `mkdir`,'
	@echo 'etc.) while document generation requires more advanced utilities'
	@echo '(e.g. `sed`), in addition, the generation of `man` pages requires'
	@echo '`pandoc`.'
	@echo ''
	@echo 'In most cases up-to-date documentation should already be present'
	@echo 'as part of the distribution.'
	@echo ''
	@echo 'This makefile loosely follows the GNU Makefile Conventions, with most'
	@echo 'of the relevant macros and targets available: macros include'
	@echo '`DESTDIR`, `prefix`, `exec_prefix`, `bindir,`datarootdir`, `docdir`,'
	@echo '`mandir`, while targets include `installdirs` and `installdocdirs`.'
	@echo '(The `INSTALL` macro is provided, but by default invokes `cp -f` and'
	@echo 'does not require the `install` utility.)'
	@echo ''

# Never output commands from help
.SILENT: help

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### DOCUMENTATION GENERATION
#:
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: `md`
#:
#: : Aliased as `markdown`.
#: : Generate documentation in markdown format as required.
#: : See also [`DOC_LEVEL`](#doc_level).
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md	markdown:	__validate__DOC_LEVEL	$(__list__MD_FILES)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: `man`
#:
#: : Aliased as `markdown`.
#: : Generate documentation in `man` format as required.
#: : See also [`DOC_LEVEL`](#doc_level).
#: : Requires [`pandoc`][pandoc]
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
man:	__validate__DOC_LEVEL	$(__list__MAN_FILES)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: `doc`
#:
#: : Generate all documentation.
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doc:	md	man

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### INSTALLATION
#:
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: _DIRECTORIES_
#: <!-- ---- -->
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#: `installbindirs`
#:
#: : Create all missing library installation directories.
#:
#-----------------------------------------------------------
installbindirs:
	@_MKPATH_PATH="$(DESTDIR)$(bindir)"; $(_cmd__MKPATH)

#-----------------------------------------------------------
#: `installlibdirs`
#:
#: : Alias for `installbindirs` (since libraries are
#:   installed in binary directories).
#:
#-----------------------------------------------------------
installlibdirs:	installbindirs

#-----------------------------------------------------------
#: `installmddirs`
#:
#: : Create all missing markdown documentation
#:   installation directories.
#:
#-----------------------------------------------------------
installmddirs:
	@_MKPATH_PATH="$(DESTDIR)$(docdir)"; $(_cmd__MKPATH)

#-----------------------------------------------------------
#: `installmandirs`
#:
#: : Create all missing `man` documentation
#:   installation directories.
#:
#-----------------------------------------------------------
installmandirs:
	@_MKPATH_PATH="$(DESTDIR)$(mandir)"; $(_cmd__MKPATH)

#-----------------------------------------------------------
#: `installdocdirs`
#:
#: : Create all missing documentation
#:   installation directories.
#:
#-----------------------------------------------------------
installdocdirs:	installmddirs	installmandirs

#-----------------------------------------------------------
#: `installdirs`
#:
#: : Create all missing documentation and library
#:   installation directories.
#:
#-----------------------------------------------------------
installdirs: 	installbindirs	installlibdirs	installdocdirs

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: _LIBRARIES_
#: <!-- -- -->
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#: `installlib`
#:
#: : Install library files.
#: : Creates missing directories as required.
#:
#-----------------------------------------------------------
installlib:	installlibdirs	$(__list__LIBRARY_FILES)
	@for _install_SOURCE in $(__list__LIBRARY_FILES); \
	 do \
	   _install_TARGET="$(DESTDIR)$(bindir)/$$(expr "_/$${_install_SOURCE}" : '.*/\([^/]*\)$$')"; \
	   echo "Installing $${_install_TARGET:?}"; \
	   _MKPATH_PATH="$${_install_TARGET%/*}"; $(_cmd__MKPATH); \
	   $(INSTALL_DATA) "$${_install_SOURCE:?}" "$${_install_TARGET:?}"; \
	   test -h "$${_install_TARGET:?}" || $(CHMOD) $(CHMODFLAGS) '0644' "$${_install_TARGET:?}"; \
	 done; \

#-----------------------------------------------------------
#: `installbin`
#:
#: : Install binary files.
#: : Creates missing directories as required.
#: : Binary files require library files, so they are also
#:   installed.
#:
#-----------------------------------------------------------
installbin:	installlib	installbindirs	$(__list__BINARY_FILES)
	@for _install_SOURCE in $(__list__BINARY_FILES); \
	 do \
	   _install_TARGET="$(DESTDIR)$(bindir)/$$(expr "_/$${_install_SOURCE}" : '.*/\([^/]*\)$$')"; \
	   echo "Installing $${_install_TARGET:?}"; \
	   _MKPATH_PATH="$${_install_TARGET%/*}"; $(_cmd__MKPATH); \
	   $(INSTALL_PROGRAM) "$${_install_SOURCE:?}" "$${_install_TARGET:?}"; \
	   test -h "$${_install_TARGET:?}" || $(CHMOD) $(CHMODFLAGS) '0755' "$${_install_TARGET:?}"; \
	 done

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: _DOCUMENTATION_
#: <!-- ------ -->
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#: `installmd`
#:
#: : Install markdown documentation files.
#: : Creates missing directories as required.
#: : Generates files as required.
#:
#-----------------------------------------------------------
installmd:		installmddirs	md
	@for _install_SOURCE in $(__list__MD_FILES); do \
	   _install_TARGET="$(DESTDIR)$(docdir)/$$(expr "_/$${_install_SOURCE}" : '.*/\([^/]*\)$$')"; \
	   echo "Installing $${_install_TARGET:?}"; \
	   _MKPATH_PATH="$${_install_TARGET%/*}"; $(_cmd__MKPATH); \
	   $(INSTALL_DATA) "$${_install_SOURCE:?}" "$${_install_TARGET:?}"; \
	   test -h "$${_install_TARGET:?}" || $(CHMOD) $(CHMODFLAGS) 0644 "$${_install_TARGET:?}"; \
	 done

#-----------------------------------------------------------
#: `installman`
#:
#: : Install `man` documentation files.
#: : Creates missing directories as required.
#: : Generates files as required.
#:
#-----------------------------------------------------------
installman:	installmandirs	man
	@for _install_SOURCE in $(__list__MAN_FILES); \
	 do \
	   _install_TARGET="$$(expr "_/$${_install_SOURCE}" : '.*/\([^/]*\)$$')"; \
	   case $${_install_TARGET:?} in \
	   *'.1') _install_TARGET="$(DESTDIR)$(man1dir)/$${_install_TARGET%.1}$(man1ext)" ;; \
	   *'.2') _install_TARGET="$(DESTDIR)$(man2dir)/$${_install_TARGET%.2}$(man2ext)" ;; \
	   *'.3') _install_TARGET="$(DESTDIR)$(man3dir)/$${_install_TARGET%.3}$(man3ext)" ;; \
	   *'.4') _install_TARGET="$(DESTDIR)$(man4dir)/$${_install_TARGET%.4}$(man4ext)" ;; \
	   *'.5') _install_TARGET="$(DESTDIR)$(man5dir)/$${_install_TARGET%.5}$(man5ext)" ;; \
	   *'.6') _install_TARGET="$(DESTDIR)$(man6dir)/$${_install_TARGET%.6}$(man6ext)" ;; \
	   *'.7') _install_TARGET="$(DESTDIR)$(man7dir)/$${_install_TARGET%.7}$(man7ext)" ;; \
	   *'.8') _install_TARGET="$(DESTDIR)$(man8dir)/$${_install_TARGET%.8}$(man8ext)" ;; \
	       *) echo "Unrecognized man page file name $${_install_TARGET:?}"; false ;; \
	   esac; \
	   echo "Installing $${_install_TARGET:?}"; \
	   _MKPATH_PATH="$${_install_TARGET%/*}"; $(_cmd__MKPATH); \
	   $(INSTALL_DATA) "$${_install_SOURCE:?}" "$${_install_TARGET:?}"; \
	   test -h "$${_install_TARGET:?}" || $(CHMOD) $(CHMODFLAGS) 0644 "$${_install_TARGET:?}"; \
	 done

#-----------------------------------------------------------
#: `installdoc`
#:
#: : Install all documentation files.
#:
#-----------------------------------------------------------
installdoc:	installmd	installman

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: _COMMON_
#: <!-- -->
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#: `install`
#:
#: : Install everything.
#:
#-----------------------------------------------------------
install:	installbin	installlib	installdoc

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### UNINSTALLATION
#:
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: _LIBRARIES_
#: <!-- -- -->
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#: `uninstalllib`
#:
#: : Uninstall any installed library files.
#:
#-----------------------------------------------------------
uninstalllib:
	@for _LIB_FILE in $(__list__LIBRARY_FILES); \
	 do \
	   _uninstall_PATH="$(DESTDIR)$(bindir)/$$(expr "_/$${_LIB_FILE}" : '.*/\([^/]*\)$$')"; \
	   if test -f "$${_uninstall_PATH}"; then \
	     echo "Uninstalling $${_uninstall_PATH}"; \
	     rm "$${_uninstall_PATH}"; \
	   fi; \
	 done

#-----------------------------------------------------------
#: `uninstallbin`
#:
#: : Uninstall any installed binary files.
#: : Also uninstalls library files because the target
#:   `installbin` installs these files.
#:
#-----------------------------------------------------------
uninstallbin:	uninstalllib
	@for _BIN_FILE in $(__list__BINARY_FILES); \
	 do \
	   _uninstall_PATH="$(DESTDIR)$(bindir)/$$(expr "_/$${_BIN_FILE}" : '.*/\([^/]*\)$$')"; \
	   if test -f "$${_uninstall_PATH}"; then \
	     echo "Uninstalling $${_uninstall_PATH}"; \
	     rm "$${_uninstall_PATH}"; \
	   fi; \
	 done

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: _DOCUMENTATION_
#: <!-- ------ -->
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#: `uninstallmd`
#:
#: : Uninstall all installed markdown documentation files.
#:
#-----------------------------------------------------------
uninstallmd:
	@for _MD_FILE in $(__list__MD_FILES); do \
	   _uninstall_PATH="$(DESTDIR)$(docdir)/$$(expr "_/$${_MD_FILE}" : '.*/\([^/]*\)$$')"; \
	   if test -f "$${_uninstall_PATH}"; then \
	     echo "Uninstalling $${_uninstall_PATH}"; \
	     rm "$${_uninstall_PATH}"; \
	   fi; \
	 done
	-@if test -d "$(DESTDIR)$(docdir)"; then \
	    rmdir "$(DESTDIR)$(docdir)"; \
	  fi

#-----------------------------------------------------------
#: `uninstallman`
#:
#: : Uninstall all installed `man` documentation files.
#:
#-----------------------------------------------------------
uninstallman:
	@for _MAN_FILE in $(__list__MAN_FILES); \
	 do \
	   _uninstall_PATH="$$(expr "_/$${_MAN_FILE}" : '.*/\([^/]*\)$$')"; \
	   case $${_uninstall_PATH:?} in \
	   *'.1') _uninstall_PATH="$(DESTDIR)$(man1dir)/$${_uninstall_PATH%.1}$(man1ext)" ;; \
	   *'.2') _uninstall_PATH="$(DESTDIR)$(man2dir)/$${_uninstall_PATH%.2}$(man2ext)" ;; \
	   *'.3') _uninstall_PATH="$(DESTDIR)$(man3dir)/$${_uninstall_PATH%.3}$(man3ext)" ;; \
	   *'.4') _uninstall_PATH="$(DESTDIR)$(man4dir)/$${_uninstall_PATH%.4}$(man4ext)" ;; \
	   *'.5') _uninstall_PATH="$(DESTDIR)$(man5dir)/$${_uninstall_PATH%.5}$(man5ext)" ;; \
	   *'.6') _uninstall_PATH="$(DESTDIR)$(man6dir)/$${_uninstall_PATH%.6}$(man6ext)" ;; \
	   *'.7') _uninstall_PATH="$(DESTDIR)$(man7dir)/$${_uninstall_PATH%.7}$(man7ext)" ;; \
	   *'.8') _uninstall_PATH="$(DESTDIR)$(man8dir)/$${_uninstall_PATH%.8}$(man8ext)" ;; \
	       *) echo "Unrecognized man page file name $${_uninstall_PATH:?}"; false ;; \
	   esac; \
	   if test -f "$${_uninstall_PATH}"; then \
	     echo "Uninstalling $${_uninstall_PATH}"; \
	     rm "$${_uninstall_PATH}"; \
	   fi; \
	 done

#-----------------------------------------------------------
#: `uninstalldoc`
#:
#: : Uninstall all installed documentation files.
#:
#-----------------------------------------------------------
uninstalldoc:	uninstallmd	uninstallman

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#: _COMMON_
#: <!-- -->
#:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#: `uninstall`
#:
#: : Uninstall all installed files.
#:
#-----------------------------------------------------------
uninstall:	uninstallbin	uninstalllib	uninstalldoc

#===========================================================
#: <!-- ------------------------------------------------ -->
#:
#: ### TEST
#:
#===========================================================

#-----------------------------------------------------------
#: `check`
#:
#: : Aliased as `test`
#: : Run all library test files.
#: : Does not require libraries are installed.
#:
#-----------------------------------------------------------
check test:
	@for _TEST in $(__list__TESTS); do $(SHELL) "$${_TEST:?}" $(TESTFLAGS); done

#===========================================================
#. <!-- ------------------------------------------------ -->
#.
#. ### INTERNAL TARGETS
#.
#. None of these targets should be invoked directly.
#.
#===========================================================

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. `__validate__DOC_LEVEL`
#.
#. : Cause `make` to fail if DOC_LEVEL is not a valid value.
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
__validate__DOC_LEVEL:
	+@case $(DOC_LEVEL) in \
	  [12]) : ;; \
	     *) echo "***Error*** Invalid DOC_LEVEL ($(DOC_LEVEL)), valid values are 1 or 2"; \
	        false ;; \
	  esac

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. `getarg.md`/`getarg.1`
#.
#. : Binary file documentation special targets.
#. : Required since the binary file has no suffix.
#. : Man page target is required because the source used
#.   needs to be the binary file (as it contains special
#.   man page only documentation).
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Markdown
getarg.md: getarg
	@$(_cmd__SH_TO_MD)

# Man Page
getarg.1: getarg
	@$(_cmd__SH_TO_MAN)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. `betterscripts.7`
#.
#. : Common documentation special target.
#. : If the source file and target file do not have the same
#.   name (excluding directory and extension) an explicit
#.   `make` target is the only way to process the file while
#.   retaining the up-to-date checks `make` does and also
#.   allowing `make -t` to work as expected.
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
betterscripts.7: README.MD
	@$(_cmd__MD_TO_MAN)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. _INFERENCE RULES_
#. <!-- -------- -->
#.
#. Document generation is performed almost entirely using a
#. number of double-suffix inference rules.
#.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-----------------------------------------------------------
#. `.sh.md`/`.sh.MD`
#.
#. : Shell script to a markdown file.
#.
#-----------------------------------------------------------
.sh.md:
	@$(_cmd__SH_TO_MD)

.sh.MD:
	@$(_cmd__SH_TO_MD)

# Register the inference suffixes
.SUFFIXES: .sh .md .MD

#-----------------------------------------------------------
#. `.md.1`/`.md.2`/.../`.md.8`
#. `.MD.1`/`.MD.2`/.../`.MD.8`
#.
#. : Markdown file to a `man` page file.
#. : Every `man` file belongs to one of 8 categories and
#.   as a numerical extension that specifies the category,
#.   therefore there are 8 inference rules for converting
#.   a file from `md` to a `man` page.
#.
#-----------------------------------------------------------
.md.1:
	@$(_cmd__MD_TO_MAN)

.MD.1:
	@$(_cmd__MD_TO_MAN)

.md.2:
	@$(_cmd__MD_TO_MAN)

.MD.2:
	@$(_cmd__MD_TO_MAN)

.md.3:
	@$(_cmd__MD_TO_MAN)

.MD.3:
	@$(_cmd__MD_TO_MAN)

.md.4:
	@$(_cmd__MD_TO_MAN)

.MD.4:
	@$(_cmd__MD_TO_MAN)

.md.5:
	@$(_cmd__MD_TO_MAN)

.MD.5:
	@$(_cmd__MD_TO_MAN)

.md.6:
	@$(_cmd__MD_TO_MAN)

.MD.6:
	@$(_cmd__MD_TO_MAN)

.md.7:
	@$(_cmd__MD_TO_MAN)

.MD.7:
	@$(_cmd__MD_TO_MAN)

.md.8:
	@$(_cmd__MD_TO_MAN)

.MD.8:
	@$(_cmd__MD_TO_MAN)

# Register the inference suffixes
.SUFFIXES: .md .MD .1 .2 .3 .4 .5 .6 .7 .8

#-----------------------------------------------------------
#. `.sh.1`/`.sh.2`/.../`.sh.8`
#.
#. : Shell script to a `man` page file.
#. : Every `man` file belongs to one of 8 categories and
#.   as a numerical extension that specifies the category,
#.   therefore there are 8 inference rules for converting
#.   a file from `sh` to a `man` page.
#.
#-----------------------------------------------------------
.sh.1:
	@$(_cmd__SH_TO_MAN)

.sh.2:
	@$(_cmd__SH_TO_MAN)

.sh.3:
	@$(_cmd__SH_TO_MAN)

.sh.4:
	@$(_cmd__SH_TO_MAN)

.sh.5:
	@$(_cmd__SH_TO_MAN)

.sh.6:
	@$(_cmd__SH_TO_MAN)

.sh.7:
	@$(_cmd__SH_TO_MAN)

.sh.8:
	@$(_cmd__SH_TO_MAN)

# Register the inference suffixes
.SUFFIXES: .sh .1 .2 .3 .4 .5 .6 .7 .8

################################################################################
################################################################################

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
#: - [_GNU Makefile Conventions_][gnu_makefile_conventions]
#:   - although not a true standard, these conventions are widely used, familiar
#:     to many, and have been created over decades of usage to support the most
#:     common use cases.
#:   - the conventions MAY not be followed closely in all cases
#:     - they are defined are specifically meant for usage by GNU utilities
#:       meaning some assumptions may be made (e.g. access to GNU versions
#:       of some commands)
#:     - this file is unusual in operation (e.g. libraries are installed in
#:       a binary path, but made non-executable)
#:     - the GNU conventions require non-standard `make` in places (e.g. the
#:       use of `-` (`<hyphen>`) in target names)
#:
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: ## NOTES
#:
#: - Documentation extracted from the library files may be different for
#:   different target formats, this is by design as it creates better output
#:   for the different formats supported.
#: - As far as possible this file complies with
#:   [standard `make`](https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/make.html)
#:   however, the standard is written as a "lowest common denominator" of
#:   existing `make` implementations and has significant limitations.
#: - To aid users, this file follows some non-standard, but common conventions
#:   regarding usage. However, in some cases these have been modified slightly
#:   as the conventions require non-standard code.
#: - Internal macros and targets all start with  `_` (`<underscore>`) as a
#:   prefix, these SHOULD not be overridden.
#: - Quoting and escaping in `make` is confusing and difficult to do robustly
#:   when user defined values may be involved. Quote characters are particularly
#:   challenging and are assumed NOT to appear in any paths.
#:
#. <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#.
#. ## IMPLEMENTATION NOTES
#.
#. - `make` commands are invoked as if passed to a shell, when a command
#.   includes an escaped line break this is passed to the shell as is, i.e.
#.   the shell sees an escaped line break: in most cases this means the use
#.   `;` (`<semicolon>`) MUST be used liberally. However, care must be taken
#.   with macro expansion as a macro with a trailing `;` (`<semicolon>`) may
#.   cause the shell to receive `;;` which is the `case` separator token and
#.   is an error outside of that use case.
#. - Use of the shell parameter expansions `${parameter#[word]}` and
#.   `${parameter##[word]}` is not portable in `make` files because the `#`
#.   (`<number-sign>`) character is often interpreted as a `make` comment and
#.   while some implementations allow escaping `#` it is not universal. There
#.   are workarounds to permit the `#` character, however for use in shell
#.   parameter expansions it is easier to simply use `expr` instead. The other
#.   shell parameter expansions are not affected by this.
#.   - `expr` is not a "drop-in" replacement for parameter expansion, for
#.     example a non-matching regular expression will result in a failure exit
#.     status and likely an empty output.
#. - The GNU project provides some useful resources for ensuring makefiles are
#.   portable and have familiar usage for as many people as possible, most
#.   notably ["Portable Make"][automake_portable_make], and
#.   ["Makefile Conventions"][gnu_makefile_conventions].
#.
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#: <!-- REFERENCES -->
#: <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
#:
#: [posix]:                     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition>                                       "POSIX.1-2008 \[pubs.opengroup.org\]"
#: [posix_2017]:                <https://pubs.opengroup.org/onlinepubs/9699919799>                                                   "POSIX.1-2017 \[pubs.opengroup.org\]"
#: [posix_bre]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03>     "Basic Regular Expression \[pubs.opengroup.org\]"
#: [posix_ere]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_04>     "Extended Regular Expression \[pubs.opengroup.org\]"
#: [posix_re_bracket_exp]:      <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap09.html#tag_09_03_05>  "RE Bracket Expression \[pubs.opengroup.org\]"
#: [posix_utility_conventions]: <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap12.html>               "POSIX: Utility Conventions \[pubs.opengroup.org\]"
#: [posix_variable]:            <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/basedefs/V1_chap03.html#tag_03_230>    "Definitions: Name \[pubs.opengroup.org\]"
#: [posix_param_expansion]:     <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#tag_18_06_02> "Parameter Expansion \[pubs.opengroup.org\]"
#: [posix_getopts]:             <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html>                "getopts \[pubs.opengroup.org\]"
#: [posix_dot]:                 <https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/V3_chap02.html#dot>          "Special Built-In Utilities: dot \[pubs.opengroup.org\]"
#:
#: [gnu_makefile_conventions]:   <https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html>                            "GNU Makefile Conventions \[gnu.org\]"
#: [gnu_utilities_in_makefiles]: <https://www.gnu.org/prep/standards/html_node/Utilities-in-Makefiles.html>                          "GNU Utilities in Makefiles \[gnu.org\]"
#: [gnu_command_variables]:      <https://www.gnu.org/prep/standards/html_node/Command-Variables.html>                               "GNU Command Variables \[gnu.org\]"
#: [gnu_directory_variables]:    <https://www.gnu.org/prep/standards/html_node/Directory-Variables.html>                             "GNU Directory Variables \[gnu.org\]"
#: [gnu_destdir]:                <https://www.gnu.org/prep/standards/html_node/DESTDIR.html>                                         "GNU DESTDIR \[gnu.org\]"
#:
#: [automake_portable_make]:     <https://www.gnu.org/software/autoconf/manual/html_node/Portable-Make.html>                         "autoconf: Portable Make \[gnu.org\]"
#: [automake_aux_bin]:           <https://www.gnu.org/software/automake/manual/html_node/Auxiliary-Programs.html>                    "automake: Programs automake might require \[gnu.org\]"
#:
#: [pandoc]:                     <https://pandoc.org/>                                                                               "Pandoc \[pandoc.org\]"
#:
#: [man_page]:                   <https://wikipedia.org/wiki/Man_page>                                                               "man page \[wikipedia.org\]"
#:
###############################################################################

################################################################################
################################################################################
# END
################################################################################
################################################################################
