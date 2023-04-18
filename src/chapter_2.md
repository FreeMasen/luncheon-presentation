# What is Luncheon

$slides-only$

- Parses and Generates HTTP Request/Response
- Provides Request, Response, and Headers "classes"
- 2 constructors
  - ltn12 Source constructor
  - Builder-style constructor

$slides-only-end$

$web-only$

Luncheon is a lua module designed to parse and generate HTTP Requests and Responses.

It provides a Request, Response and Headers "classes" that can be constructed either by
consuming data on a socket or by calls to a series of builder methods.

When constructing with a socket we use the luasocket ltn12 source API with helpers for

$web-only-end$
