# HTTP Primer

$web-only$

This book will discuss how Luncheon provides helpers for serializing and deserializing HTTP Request
and Response types. As an introduction, this chapter will provide a brief overview of the anatomy of
an HTTP request/response.

Both a request and response are encoded as text, the structure of that text starts with the first
line. For a request, this will be encoded as `<method> <path> <version>` where `method` is a string
(typically `GET`, `POST`, `PUT`, or `DELETE`), `path` is a string representing the url path and
finally `version` will be `HTTP/<version>` where the version can be `1.0` or `1.1`, the latter being
the most common (note: HTTP/2 exists but is essentially a break version change). For a response,
this will be encoded as `<version> <status-code> <status-message>` where `version` is the same as a
a request, `status-code` is a 3 digit number and the `status-message` is a string associated with
the `status-code`. The new line character for this first line will always be `\r\n`.

After the first line, we have a series of header lines, these are almost always
`<header-name>: <header-value>` followed by `\r\n`. The headers end when we encounter an empty line
using the `\r\n` as its new line character.

After the headers we move onto the body which is essentially a blob of bytes that can be encoded in
a few different ways. We aren't going to cover all that here but the most basic request/response
body would just be encoded as a string.

$web-only-end$

$slides-only$

- First Line
  - Request: `<method> <path> <version>`
  - Response: `<version> <status-code> <status-message>`
- Headers
  - `<name>: <value>`
- Body
  - Blob of bytes

$slides-only-end$

## Examples

### Request

```text
GET /a HTTP/1.1\r\n
Host: 0.0.0.0:80\r\n
Content-Length: 10\r\n
\r\n
aaaaaaaaaa
```

### Response

```text
HTTP/1.1 200 Ok\r\n
Content-Length: 10\r\n
Content-Type: text/plain\r\n
\r\n
aaaaaaaaaa
```

For more information see
[Mozilla's overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Messages)
