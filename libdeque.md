<!-- #################################################################### -->
<!-- ############ THIS FILE WAS GENERATED FROM 'libdeque.sh' ############ -->
<!-- #################################################################### -->
<!-- ########################### DO NOT EDIT! ########################### -->
<!-- #################################################################### -->

# libdeque

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## SYNOPSIS

_Full synopsis, description, arguments, examples and other information is
 documented with each individual command._

---------------------------------------------------------

`deque` - _Double-Ended Queue_
<!-- ------------------ -->

[`deque_push_front <DEQUE> <VALUE>...`](#deque_push_front)

[`deque_pop_front <DEQUE> [<OUTPUT>]`](#deque_pop_front)

[`deque_unshift <DEQUE> <VALUE>...`](#deque_unshift) _(alias for `deque_push_front`)_

[`deque_shift <DEQUE> [<OUTPUT>]`](#deque_shift) _(alias for `deque_pop_front`)_

[`deque_push_back <DEQUE> <VALUE>...`](#deque_push_back)

[`deque_pop_back <DEQUE> [<OUTPUT>]`](#deque_pop_back)

[`deque_push <DEQUE> <VALUE>...`](#deque_push) _(alias for `deque_push_back`)_

[`deque_pop <DEQUE> [<OUTPUT>]`](#deque_pop) _(alias for `deque_pop_back`)_

[`deque_peek_front <DEQUE> [<OUTPUT>]`](#deque_peek_front)

[`deque_peek_back <DEQUE> [<OUTPUT>]`](#deque_peek_back)

[`deque_front <DEQUE> [<OUTPUT>]`](#deque_front) _(alias for `deque_peek_front`)_

[`deque_back <DEQUE> [<OUTPUT>]`](#deque_back) _(alias for `deque_peek_back`)_

[`deque_size <DEQUE> [<OUTPUT>]`](#deque_size)

[`deque_is_deque_like <DEQUE>`](#deque_is_deque_like)

---------------------------------------------------------

`queue` - First In, First Out Queue._
<!-- ---------------------------- -->

[`queue_push <QUEUE> <VALUE>...`](#queue_push)

[`queue_pop <QUEUE> [<OUTPUT>]`](#queue_pop)

[`queue_peek <QUEUE> [<OUTPUT>]`](#queue_peek)

[`queue_size <QUEUE> [<OUTPUT>]`](#queue_size)

[`queue_is_queue_like <QUEUE>`](#queue_is_queue_like)

---------------------------------------------------------

`stack` - Last In, First Out Stack._
<!-- --------------------------- -->

[`stack_push <STACK> <VALUE>...`](#stack_push)

[`stack_pop <STACK> [<OUTPUT>]`](#stack_pop)

[`stack_peek <STACK> [<OUTPUT>]`](#stack_peek)

[`stack_size <STACK> [<OUTPUT>]`](#stack_size)

[`stack_is_stack_like <STACK>`](#stack_is_stack_like)

---------------------------------------------------------

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## DESCRIPTION

Provides commands to allow any _POSIX.1_ compliant shell to use a simple
emulated queue like data structures:

`deque`

- _Double-Ended_ - access to elements at both ends of the deque.
- _Sequential_ - elements in the middle can not be accessed directly.

`queue`

- _Single-Ended_ - access to elements at one end only.
- _First In, First Out_ - elements accessed in added order.
- _Sequential_ - elements in the middle can not be accessed directly.

`stack`

- _Single-Ended_ - access to elements at one end only.
- _Last In, First Out_ - elements accessed in _reversed_ order.
- _Sequential_ - elements in the middle can not be accessed directly.

These structures are highly efficient, with performance that should be close
to the maximum possible for any data that can be processed using them. All 3
types have identical performance characteristics.

For any operation requiring sequential access to a number of elements these
data types should be the first considered for use (before more obvious types
such as (emulated) arrays).

_The types `queue` and `stack` are specializations of `deque`, so provided
 in the same library._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## EXIT STATUS

- For all commands the exit status will be `0` (`<zero>`) if, and only if,
  the command was completed successfully.
- For any command which is intended to perform a test, an exit status of
  `1` (`<one>`) indicates "false", while `0` (`<zero>`) indicates "true".
- An exit status that is NOT `0` (`<zero>`) from an external command will
  be propagated to the caller where relevant (and possible).
- For any usage error (e.g. an unsupported variable name), the `EX_USAGE`
  error code from [FreeBSD `SYSEXITS(3)`][sysexits] is used.
- Configuration SHOULD NOT change the value of any exit status.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## ENVIRONMENT

A number of environment variables affect the library, these are split into
variables that instruct the library to work-around specific platform issues,
and variables that convey user preferences. Variables that enable platform
specific work-arounds will be automatically set if needed, but can also be
set manually to force specific configurations.

In additional to these, there are a number of variables that are set by the
library to convey information outside of command invocation.

If unset, some variables will take an initial value from a _BetterScripts_
_POSIX Suite_ wide variable, these allow the same configuration to be used by
all libraries in the suite.

After the library has been sourced, external commands must not set library
environment variables that are classified as CONSTANT. Variables may use
the `readonly` command to enforce this.

**_If not otherwise specified, an `<unset>` variable is equivalent to the_**
**_default value._**

_For more details see the common suite [documentation](./README.MD#environment)._

<!-- ------------------------------------------------ -->

### PLATFORM CONFIGURATION

---------------------------------------------------------

#### `BS_LIBDEQUE_CONFIG_NO_Z_SHELL_SETOPT`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_Z_SHELL_SETOPT`](./README.MD#better_scripts_config_no_z_shell_setopt)
- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using `setopt` in _Z Shell_ to ensure
  _POSIX.1_ like behavior.
- Automatically enabled if _Z Shell_ is detected.
- Any use of `setopt` is scoped as tightly as possible
  and SHOULD not affect other commands.

---------------------------------------------------------

#### `BS_LIBDEQUE_CONFIG_NO_GREP_F`

- Suite:    [`BETTER_SCRIPTS_CONFIG_NO_GREP_F`](./README.MD#better_scripts_config_no_grep_f)
- Type:     FLAG
- Class:    CONSTANT
- Default:  \<automatic>
- \[Disable]/Enable using the non-standard `fgrep`
  instead of `grep -F`.
- _OFF_: Use `grep -F`.
- _ON_: Use `fgrep`.
- While `grep -F` is standard, it is not always available
  but in the cases it is not `fgrep` often is and
  provides the required functionality.

<!-- ------------------------------------------------ -->

### USER PREFERENCE

---------------------------------------------------------

#### `BS_LIBDEQUE_CONFIG_QUIET_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_QUIET_ERRORS`](./README.MD#better_scripts_config_quiet_errors)
- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- \[Enable]/Disable library error message output.
- _OFF_: error messages will be written to `STDERR` as:
  `[libdeque::<COMMAND>]: ERROR: <MESSAGE>`.
- _ON_: library error messages will be suppressed.
- The most recent error message is always available in
  [`BS_LIBDEQUE_LAST_ERROR`](#bs_libdeque_last_error)
  even when error output is suppressed.
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.
- Does NOT affect errors from non-library commands, which
  _may_ still produce output.

---------------------------------------------------------

#### `BS_LIBDEQUE_CONFIG_FATAL_ERRORS`

- Suite:    [`BETTER_SCRIPTS_CONFIG_FATAL_ERRORS`](./README.MD#better_scripts_config_fatal_errors)
- Type:     FLAG
- Class:    VARIABLE
- Default:  _OFF_
- Enable/\[Disable] causing library errors to terminate
  the current (sub-)shell.
- _OFF_: errors stop any further processing, and cause a
  non-zero exit status, but do not cause an exception.
- _ON_: any library error will cause an "unset variable"
  shell exception using the
  [`${parameter:?[word]}`][posix_param_expansion]
  parameter expansion, where `word` is set to an error
  message that _should_ be displayed by the shell (this
  message is NOT suppressed by
  [`BS_LIBDEQUE_CONFIG_QUIET_ERRORS`](#bs_libdeque_config_quiet_errors)).
- Both the library version of this option and the
  suite version can be modified between command
  invocations and will affect the next command.

---------------------------------------------------------

#### `BS_LIBDEQUE_CONFIG_USE_SAFER_DEQUE`

- Type:     FLAG
- Class:    CONSTANT
- Default:  _OFF_
- Enable/\[Disable] the use of an internal format for
  `deque`, `queue`, and `stack` that is slightly safer.
- _OFF_: don't use the safer format, but if any value
  added contains text that matches the internal
  delimiters errors _will_ occur.
- _ON_: use the safer format, at the expense of some
  performance.
- The internal delimiters used to create the data
  structures that enable `deque`, `queue`, and `stack`
  types have been chosen to be highly unlikely to occur
  in any normal data, however it remains possible that
  they could be present. Setting this flag to _ON_ causes
  every value added to be modified such that it can no
  longer match the internal values, removing a possible
  (though unlikely) source of errors. Unfortunately this
  can result in lower performance, the extent of which
  is largely dependent on the contents of the values
  added.
- This affects all three data types; there is no
  available mechanism for applying this to a single type.
- Has a performance impact.
  Prefer **_OFF_** for performance.

<!-- ------------------------------------------------ -->

### INFORMATIONAL

Variables that convey library information.

---------------------------------------------------------

#### `BS_LIBDEQUE_VERSION_MAJOR`

- Integer >= 1.
- Incremented when there are significant changes, or
  any changes break compatibility with previous
  versions.

---------------------------------------------------------

#### `BS_LIBDEQUE_VERSION_MINOR`

- Integer >= 0.
- Incremented for significant changes that do not
  break compatibility with previous versions.
- Reset to 0 when
  [`BS_LIBDEQUE_VERSION_MAJOR`](#bs_libdeque_version_major)
  changes.

---------------------------------------------------------

#### `BS_LIBDEQUE_VERSION_PATCH`

- Integer >= 0.
- Incremented for minor revisions or bugfixes.
- Reset to 0 when
  [`BS_LIBDEQUE_VERSION_MINOR`](#bs_libdeque_version_minor)
  changes.

---------------------------------------------------------

#### `BS_LIBDEQUE_VERSION_RELEASE`

- A string indicating a pre-release version, always
  null for full-release versions.
- Possible values include 'alpha', 'beta', 'rc',
  etc, (a numerical suffix may also be appended).

---------------------------------------------------------

#### `BS_LIBDEQUE_VERSION_FULL`

- Full version combining
  [`BS_LIBDEQUE_VERSION_MAJOR`](#bs_libdeque_version_major),
  [`BS_LIBDEQUE_VERSION_MINOR`](#bs_libdeque_version_minor),
  and [`BS_LIBDEQUE_VERSION_PATCH`](#bs_libdeque_version_patch)
  as a single integer.
- Can be used in numerical comparisons
- Format: `MNNNPPP` where, `M` is the `MAJOR` version,
  `NNN` is the `MINOR` version (3 digit, zero padded),
  and `PPP` is the `PATCH` version (3 digit, zero padded).

---------------------------------------------------------

#### `BS_LIBDEQUE_VERSION`

- Full version combining
  [`BS_LIBDEQUE_VERSION_MAJOR`](#bs_libdeque_version_major),
  [`BS_LIBDEQUE_VERSION_MINOR`](#bs_libdeque_version_minor),
  [`BS_LIBDEQUE_VERSION_PATCH`](#bs_libdeque_version_patch),
  and
  [`BS_LIBDEQUE_VERSION_RELEASE`](#bs_libdeque_version_release)
  as a formatted string.
- Format: `BetterScripts 'libdeque' vMAJOR.MINOR.PATCH[-RELEASE]`
- Derived tools MUST include unique identifying
  information in this value that differentiates them
  from the BetterScripts versions. (This information
  should precede the version number.)

---------------------------------------------------------

#### `BS_LIBDEQUE_LAST_ERROR`

- Stores the error message of the most recent error.
- ONLY valid immediately following a command for which
  the exit status is not `0` (`<zero>`).
- Available even when error output is suppressed.

---------------------------------------------------------

#### `BS_LIBDEQUE_SOURCED`

- Set (and non-null) once the library has been sourced.
- Dependant scripts can query if this variable is set to
  determine if this file has been sourced.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## COMMANDS

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

### DEQUE

---------------------------------------------------------

#### `deque_push_back`

Add one or more values to the _back_ of a deque.

_SYNOPSIS_
<!-- - -->

    deque_push_back <DEQUE> <VALUE>...

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[out:ref]

- Variable containing a deque.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty deque or `unset` variable
  (a new deque will be created).
- If specified as `-` (`<hyphen>`) deque is written to
  `STDOUT`.

`VALUE` \[in]

- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- Can be null.

_EXAMPLES_
<!-- - -->

    deque_push_back MyDeque "$@"

---------------------------------------------------------

#### `deque_pop_back`

Remove a value from the _back_ of a deque.

_SYNOPSIS_
<!-- - -->

    deque_pop_back <DEQUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[in:ref]

- Variable containing a deque.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If specified as `-` (`<hyphen>`) value is written to,
  `STDOUT`
- If not specified value is not written to any location.

_EXAMPLES_
<!-- - -->

    while deque_pop_back MyDeque MyVar
    do
      ...
    done

_NOTES_
<!-- -->

- If `DEQUE` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `deque_push_front`

Add one or more values to the _front_ of a deque.

_SYNOPSIS_
<!-- - -->

    deque_push_front <DEQUE> <VALUE>...

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[out:ref]

- Variable containing a deque.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty deque or `unset` variable
  (a new deque will be created).
- If specified as `-` (`<hyphen>`) deque is written to
  `STDOUT`.

`VALUE` \[in]

- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- Can be null.

_EXAMPLES_
<!-- - -->

    deque_push_front MyDeque "$@"

---------------------------------------------------------

#### `deque_pop_front`

Remove a value from the _front_ of a deque.

_SYNOPSIS_
<!-- - -->

    deque_pop_front <DEQUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[in:ref]

- Variable containing a deque.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If specified as `-` (`<hyphen>`) value is written to,
  `STDOUT`
- If not specified value is not written to any location.

_EXAMPLES_
<!-- - -->

    while deque_pop_front MyDeque MyVar
    do
      ...
    done

_NOTES_
<!-- -->

- If `DEQUE` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `deque_push`

Alias for [`deque_push_back`](#deque_push_back)

---------------------------------------------------------

#### `deque_pop`

Alias for [`deque_pop_back`](#deque_pop_back)

---------------------------------------------------------

#### `deque_unshift`

Alias for [`deque_push_front`](#deque_push_front)

---------------------------------------------------------

#### `deque_shift`

Alias for [`deque_pop_front`](#deque_pop_front)

---------------------------------------------------------

#### `deque_peek_back`

Get the value from the _back_ of a deque without removing it.

_SYNOPSIS_
<!-- - -->

    deque_peek_back <DEQUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[in:ref]

- Variable containing a deque.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    deque_peek_back 'MyDeque' 'MyVar'
    MyVar="$(deque_peek_back 'MyDeque' )"
    MyVar="$(deque_peek_back 'MyDeque' -)"

_NOTES_
<!-- -->

- If `DEQUE` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `deque_peek_front`

Get the value from the _front_ of a deque without removing it.

_SYNOPSIS_
<!-- - -->

    deque_peek_front <DEQUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[in:ref]

- Variable containing a deque.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    deque_peek_front 'MyDeque' 'MyVar'
    MyVar="$(deque_peek_front 'MyDeque' )"
    MyVar="$(deque_peek_front 'MyDeque' -)"

_NOTES_
<!-- -->

- If `DEQUE` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `deque_back`

Alias for [`deque_peek_back`](#deque_peek_back)

---------------------------------------------------------

#### `deque_front`

Alias for [`deque_peek_front`](#deque_peek_front)

---------------------------------------------------------

#### `deque_size`

Get the number of entries in a deque.

_SYNOPSIS_
<!-- - -->

    deque_size <DEQUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[in:ref]

- Variable that may contain a deque.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty deque or `unset` variable.

`OUTPUT` \[out:ref]

- Variable that will contain the size.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    deque_size 'MyDeque' 'MySize'
    MySize="$(deque_size 'MyDeque' )"
    MySize="$(deque_size 'MyDeque' -)"

_NOTES_
<!-- -->

- Though it is not likely to be noticeable in most use cases, this is a
  relatively slow operation; it is advisable to not use this if
  avoidable, particularly if performance is important.
- An empty `DEQUE` should always be represented by an empty variable -
  (i.e. normal empty variable checks can be used to test for this).

---------------------------------------------------------

#### `deque_is_deque_like`

Determine if a variable looks like it contains deque like data.

_SYNOPSIS_
<!-- - -->

    deque_is_deque_like <DEQUE>

_ARGUMENTS_
<!-- -- -->

`DEQUE` \[in:ref]

- Variable that may contain a deque.
- MUST be a valid _POSIX.1_ name.

_EXAMPLES_
<!-- - -->

    if deque_is_deque_like 'Variable'; then ...; fi

_NOTES_
<!-- -->

- The stack and queue types are specializations of a deque and have the same
  internal format; it is _not_ possible to differentiate between the three
  types.
- An empty or unset `DEQUE` is _not_ a valid deque.
- Exit status will be `0` (`<zero>`) if `DEQUE` appears to be a valid stack,
  a queue, or deque while the exit status will be `1` (`<one>`) in all other
  (non-error) cases.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

### QUEUE

---------------------------------------------------------

#### `queue_push`

Push one or more values onto a queue.

_SYNOPSIS_
<!-- - -->

    queue_push <QUEUE> <VALUE>...

_ARGUMENTS_
<!-- -- -->

`QUEUE` \[out:ref]

- Variable containing a queue.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty queue or `unset` variable
  (a new queue will be created).
- If specified as `-` (`<hyphen>`) queue is written to
  `STDOUT`.

`VALUE` \[in]

- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- Can be null.

_EXAMPLES_
<!-- - -->

    queue_push MyQueue "$@"

_NOTES_
<!-- -->

- Each `VALUE` is pushed to the queue in turn, i.e. the _first_ `VALUE`
  specified will be the _first_ value popped from the resulting queue.

---------------------------------------------------------

#### `queue_pop`

Remove a value from a queue.

_SYNOPSIS_
<!-- - -->

    queue_pop <QUEUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`QUEUE` \[in:ref]

- Variable containing a deque.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If specified as `-` (`<hyphen>`) value is written to,
  `STDOUT`
- If not specified value is not written to any location.

_EXAMPLES_
<!-- - -->

    while queue_pop MyQueue MyVar
    do
      ...
    done

_NOTES_
<!-- -->

- If `QUEUE` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `queue_peek`

Get the next value from the queue without removing it.

_SYNOPSIS_
<!-- - -->

    queue_peek <QUEUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`QUEUE` \[in:ref]

- Variable containing a queue.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    queue_peek 'MyQueue' 'MyVar'
    MyVar="$(queue_peek 'MyQueue' )"
    MyVar="$(queue_peek 'MyQueue' -)"

_NOTES_
<!-- -->

- If `QUEUE` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `queue_size`

Get the number of entries in a queue.

_SYNOPSIS_
<!-- - -->

    queue_size <QUEUE> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`QUEUE` \[in:ref]

- Variable that may contain a queue.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty queue or `unset` variable.

`OUTPUT` \[out:ref]

- Variable that will contain the size.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    queue_size 'MyQueue' 'MySize'
    MySize="$(queue_size 'MyQueue' )"
    MySize="$(queue_size 'MyQueue' -)"

_NOTES_
<!-- -->

- Though it is not likely to be noticeable in most use cases, this is a
  relatively slow operation; it is advisable to not use this if
  avoidable, particularly if performance is important.
- An empty `QUEUE` should always be represented by an empty variable -
  (i.e. normal empty variable checks can be used to test for this).

---------------------------------------------------------

#### `queue_is_queue_like`

Determine if a variable looks like it contains queue like data.

_SYNOPSIS_
<!-- - -->

    queue_is_queue_like <QUEUE>

_ARGUMENTS_
<!-- -- -->

`QUEUE` \[in:ref]

- Variable that may contain a queue.
- MUST be a valid _POSIX.1_ name.

_EXAMPLES_
<!-- - -->

    if queue_is_queue_like 'Variable'; then ...; fi

_NOTES_
<!-- -->

- A queue is a specialization of a deque and has the same internal format as
  both a deque and a stack; it is _not_ possible to differentiate between the
  three types.
- An empty or unset `QUEUE` is _not_ a valid queue.
- Exit status will be `0` (`<zero>`) if `QUEUE` appears to be a valid stack,
  a queue, or deque while the exit status will be `1` (`<one>`) in all other
  (non-error) cases.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

### STACK

---------------------------------------------------------

#### `stack_push`

Push one or more values onto a stack.

_SYNOPSIS_
<!-- - -->

    stack_push <STACK> <VALUE>...

_ARGUMENTS_
<!-- -- -->

`STACK` \[out:ref]

- Variable containing a stack.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty stack or `unset` variable
  (a new stack will be created).
- If specified as `-` (`<hyphen>`) stack is written to
  `STDOUT`.

`VALUE` \[in]

- Can contain any arbitrary text excluding any
  embedded `\0` (`<NUL>`) characters.
- Can be null.

_EXAMPLES_
<!-- - -->

    stack_push DirStack "$PWD"
    cd '/tmp'
    ...
    stack_pop DirStack OldDir
    cd "$OldDir"

_NOTES_
<!-- -->

- Each `VALUE` is pushed to the stack in turn, i.e. the _last_ `VALUE`
  specified will be the _top_ of the resulting stack.

---------------------------------------------------------

#### `stack_pop`

Remove the value from the top of a stack.

_SYNOPSIS_
<!-- - -->

    stack_pop <STACK> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`STACK` \[out:ref]

- Variable containing a stack.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If specified as `-` (`<hyphen>`) value is written to,
  `STDOUT`
- If not specified value is not written to any location.

_EXAMPLES_
<!-- - -->

    while stack_pop MyStack MyVar
    do
      ...
    done

_NOTES_
<!-- -->

- If `STACK` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `stack_peek`

Get the value from the top of the stack without removing it.

_SYNOPSIS_
<!-- - -->

    stack_peek <STACK> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`STACK` \[in:ref]

- Variable containing a stack.
- MUST be a valid _POSIX.1_ name.

`OUTPUT` \[out:ref]

- Variable that will contain the element value.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    stack_peek 'MyStack' 'MyVar'
    MyVar="$(stack_peek 'MyStack' )"
    MyVar="$(stack_peek 'MyStack' -)"

_NOTES_
<!-- -->

- If `STACK` is empty the exit status will be `1` (`<one>`).
- If value is output to `STDOUT` data _may_ be lost if the value ends with a
  `\n` (`<newline>`) (_POSIX.1_ rules state that newlines should be removed
  from the end of output generated by commands).

---------------------------------------------------------

#### `stack_size`

Get the number of entries in a stack.

_SYNOPSIS_
<!-- - -->

    stack_size <STACK> [<OUTPUT>]

_ARGUMENTS_
<!-- -- -->

`STACK` \[in:ref]

- Variable that may contain a stack.
- MUST be a valid _POSIX.1_ name.
- Can reference an empty stack or `unset` variable.

`OUTPUT` \[out:ref]

- Variable that will contain the size.
- Any current contents will be lost.
- MUST be a valid _POSIX.1_ name or a `-` (`<hyphen>`).
- If not specified, or specified as `-` (`<hyphen>`)
  value is written to `STDOUT`.

_EXAMPLES_
<!-- - -->

    stack_size 'MyStack' 'MySize'
    MySize="$(stack_size 'MyStack' )"
    MySize="$(stack_size 'MyStack' -)"

_NOTES_
<!-- -->

- Though it is not likely to be noticeable in most use cases, this is a
  relatively slow operation; it is advisable to not use this if
  avoidable, particularly if performance is important.
- An empty `STACK` should always be represented by an empty variable -
  (i.e. normal empty variable checks can be used to test for this).

---------------------------------------------------------

#### `stack_is_stack_like`

Determine if a variable looks like it contains stack like data.

_SYNOPSIS_
<!-- - -->

    stack_is_stack_like <STACK>

_ARGUMENTS_
<!-- -- -->

`STACK` \[in:ref]

- Variable that may contain a stack.
- MUST be a valid _POSIX.1_ name.

_EXAMPLES_
<!-- - -->

    if stack_is_stack_like 'Variable'; then ...; fi

_NOTES_
<!-- -->

- A stack is a specialization of a deque and has the same internal format as
  both a deque and a queue; it is _not_ possible to differentiate between the
  three types.
- An empty or unset `STACK` is _not_ a valid stack.
- Exit status will be `0` (`<zero>`) if `STACK` appears to be a valid stack,
  a queue, or deque while the exit status will be `1` (`<one>`) in all other
  (non-error) cases.

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

## NOTES

- The data types `deque`, `queue` and `stack` are very efficient, and are
  likely the best choice for storing data where it only needs accessed
  sequentially. (This is probably true even for iterating over all values
  where it may seem like converting to another format (e.g. an emulated
  array) would be better).
- With the exception of commands dealing with size, _all_ commands are
  implemented entirely using shell builtins (i.e. require no external
  utilities), making them very fast.
- Internally all queues or stacks are specializations of deque and use the
  same data format; it is possible to use any of the commands with any of
  the types regardless of which command was used for creation. The different
  interfaces are provided so that specific use cases are easier to write and
  understand. For example, if emulating `pushd`/`popd` it makes more sense to
  use a stack than a deque, and using a stack makes such use easier to
  understand, even if the underlying type is the same.
- Modification of a deque, queue or stack outside of the library is _not_
  supported.
- Argument validation occurs where possible and (relatively) performant for
  all arguments to all commands.
- A deque, queue or stack can be serialized (e.g. saved to, or loaded from,
  a file). However, each deque is _only_ supported by the library version
  used to created it - the internal format for a deque _may_ change between
  versions without notice.
- While any data can be stored in the available formats, performance will
  scale with the size of data stored (though the specifics will depend upon
  the platform and environment).

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## CAVEATS

_The internal structure of a `deque`, `queue`, or `stack` is subject to
 change without notice and should not be relied upon. In particular,
 currently all three types are interchangeable (e.g. a `stack` can be used
 with commands for a `queue`, etc.), however, this should not be assumed:
 types should always be used only with the commands for the specific type._

The maximum size of any deque, queue or stack is limited by the environment
in which it is used, specifically they will not be able to exceed the
command line length limit, though other limitations may also exist.

Note that exporting a variable containing any deque, queue or stack will
cause that variable to be counted against the command line length limit
**TWICE** (for any library operations).

_For more details see the common suite [documentation](./README.MD#caveats)._

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

## EXAMPLE

    g_DirectoryStack=;
    pushd() {
       stack_push g_DirectoryStack "$PWD"
       cd "$1"
    }
    popd() {
       stack_pop g_DirectoryStack "PushedDirectory"
       cd "$PushedDirectory"
    }

Note that emulation of `pushd`/`popd` in this way requires ensuring _both_
operations occur within the same subshell, or it will not work as expected.

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- REFERENCES -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

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

