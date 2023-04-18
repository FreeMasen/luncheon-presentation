# Sources

## What is an LTN12 Source

$web-only$

An LTN12 source is the lua equivalent of a stream, it is a function that when call will produce
the next value in a series. One of the nicest features here is that this pattern looks very similar
to a lua iterator.

$web-only-end$

For more details on LTN12, see the
[Lua Socket docs](https://lunarmodules.github.io/luasocket/ltn12.html)

```lua
-- LTN12 Example

--- Create a source that will return an ever increasing string of 'a'
--- each call will provide a string 1 letter longer than the previous
local function create_source()
    local some_state = 0;
    return function()
        some_state = some_state + 1
        return string.rep("a", some_state)
    end
end

for chunk in create_source() do
    print(chunk)
    if #chunk > 100 then
        break
    end
end
```

## Examples

```lua
-- server.lua
local lunch = require "luncheon"
local socket = require "socket"
local sock = socket.tcp()
assert(sock:bind('0.0.0.0', 8080))
assert(sock:listen())
local incoming = assert(sock:accept())

local req = lunch.Request.tcp_source(incoming)
print('url', req.url.path)
print('method', req.method)
print('body', req:get_body())

-- send reply and close the sockets...
```

```lua
-- client.lua
local lunch = require "luncheon"
local socket = require "socket"
local sock = socket.tcp()
assert(sock:connect('0.0.0.0', 8080))

-- send request to server...

local resp = lunch.Response.tcp_source(sock)
print('status', req.status)
for header in resp:get_headers():inter() do
    print("header", header)
end
print('body', req:get_body())
sock:close()
```

$web-only$

In the above examples, you can see that both a request and response are generated with the
`tcp_source` constructor. These constructors will read the first line from the source and then
lazily provide access to the rest of the request. In the response example, there is a call to
`get_headers`, until we call that for the first time, only the first line has been read from the
socket. This avoids eagerly reading the whole request body in the event that it is very large.

$web-only-end$

$slides-only$

- Source constructors are lazy
  - They only read 1 line until `get_headers` or `get_body` is called
- The components first line are provided as properties on the table
  - `status` or `method`

$web-only-end$
