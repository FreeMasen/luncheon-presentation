# Builders

$web-only$

The second constructor provided by Luncheon is the Builder. This allows for constructing requests
or responses in memory to be serialized.

$web-only-end$

$slides-only$

- Allow Constructing values in memory
- Typically used with the serialization helpers to send

$web-only-end$

## Examples

```lua
---server.lua
local lunch = require "luncheon"
local socket = require "socket"
local sock = socket.tcp()
assert(sock:bind('0.0.0.0', 8080))
assert(sock:listen())

local incoming = assert(sock:accept())

-- receive a request
local body = string.rep("a", 100)
local resp = lunch.Response.new(200)
    :set_content_length(100)
    :add_header("x-some-custom-header", "custom header value")
    :append_body(body)
for chunk in resp:iter() do
    print("chunk:", chunk)
end
```

```lua
-- client.lua
local lunch = require "luncheon"
local socket = require "socket"
local sock = socket.tcp()
assert(sock:connect('0.0.0.0', 8080))
local req = lunch.Request.new("GET", "/a")
    :set_content_length(10)
    :add_header("host", "0.0.0.0:8080")
    :append_body(string.rep("a", 10))
sock:send(req:serialize())
```

$slides-only$

- `iter` is a way to iterate over each of the chunks of a request
- `serialize` is a way to convert the whole object into a string

$slides-only-end$

$web-only$

In the above examples, the Response is constructed using the builder methods and then use the `iter`
method to print out each chunk of the request to the terminal. A chunk in this context will be a
line for the first line and the headers, after that it will depend on the encoding.

The Request is constructed using the builder methods and then uses the `serialize` method to convert
it to a string and then passes the whole thing off to `sock:send`.

$web-only-end$
