# Upcoming Changes

$slides-only$

PR: <https://github.com/cosock/luncheon/pull/6>

- Unify the API surface of Request and Response
  - Methods like `get_content_length` didn't match on the two types
  - Serialization methods were only provided for Builder constructed types
- Detect Chunk Encoding
  - Allows for receiving chunk encoded message
  - Allows for configuring the `iter` method on chunk encoded serialization
- Share the code that is used for anything after the first line of the type

$slides-only-end$

$web-only$

[An upcoming pull request](https://github.com/cosock/luncheon/pull/6) is hopefully merging soon that
will clean up some parts of this project. The first thing it is trying to achieve is to make the API
surface of Request and Response consistent. Previously the two types provided different method names
for `get_content_length`. Another important change here is moving the shared code into a single
shared module, previous this was manually being copied and pasted and resulted in some
inconsistencies across the implementations. This also adds support for chunk encoding for both
parsing and generating request with chunk encoding. Lastly it will provide a method of sending bytes
w/o accumlating the whole body in memory which is not currently available.

$web-only-end$
