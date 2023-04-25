# Sources

## What is an LTN12 Source

$web-only$

An LTN12 source is the lua equivalent of a stream, it is a function that when call will produce
the next value in a series. One of the nicest features here is that this pattern looks very similar
to a lua iterator.

$web-only-end$

When constructing with a socket we use the luasocket ltn12 source API to make the construction a
little more flexible,
[see the details guide on ltn12](http://lua-users.org/wiki/FiltersSourcesAndSinks) for more
information on this API. For Luncheon, this looks like a function that when called with the same
arguments expected in a call to the
[luasocket TCP `receive`](https://lunarmodules.github.io/luasocket/tcp.html#receive) method.

Here is an example of what a test source might look like.

```lua
local function make_request_source()
  local head_buf = {
    "GET /a HTTP/1.1",
    "Host: 0.0.0.0:80",
    "Content-Length: 10",
    "",
  }
  local body_buf = {
    "aaaaaaaaaa",
    "",
  }
  local function inner_source(pattern)
    if #head_buf == 0 and #body_buf == 0 then
      return nil, "closed"
    end
    -- The all pattern
    if pattern == "*a" then
      -- concat all the strings remaining together
      local ret = table.concat(head_buf, "\r\n") .. table.concat(body_buf, "")
      -- set both buffers to empty
      head_buf = {}
      body_buf = {}
      return ret
    end
    if pattern == "*l" or not pattern then
      -- first try and return the first line or headers
      local maybe_ret = table.remove(head_buf, 1)
      if maybe_ret then
        return maybe_ret
      end
      -- no headers, return the body part
      return table.remove(body_buf, 1)
    end
    -- the pattern was an integer
    if #head_buf > 0 then
      return nil, "invalid pattern for headers"
    end
    local body = table.remove(body_buf, 1)
    -- the argument was too large for our remaining payload
    if not body or #body > pattern then
      return nil, "slice too large", body
    end
    -- The argument is shorter than our body, trim the remainder
    if #body < pattern then
      local rem = string.sub(body, pattern)
      table.insert(body_buf, 1, rem)
      return string.sub(1, pattern)
    end
    -- the argument was exactly the length of body!
    return body
  end
  return function(pattern)
    local ret, err = inner_source(pattern)
    print(string.format("source(%s) -> %q, %q", pattern, ret, err))
    return ret, err
  end
end
local source = make_source_request()
local chunk
-- Loop over the head_buf lines
while chunk ~= "" do
  chunk = assert(source())
end
-- Read by body chunk
chunk = assert(source())
```

Breaking this down, we first define a function called `make_request_source` which will setup a few
tables that will act as buffers for us. It then defines a function `inner_source`, that takes one
argument `pattern`, which can be either `"*a"` (read until close), `"*l"` (read next line) or an
integer indicating how many bytes to read. When called, it will remove the first element in our
`head_buff` table until that table is empty, it will then remove the first element to our
`body_buff` table until it is empty. Any calls to this function after both of the buff tables are
empty will return `nil, "closed"`. Finally it returns a function that will call `inner_source`
capturing the return value and then printing the argument and return values to the terminal.

We then assign this function to the variable `source` and loop over the return value until we find
the empty line to indicate the end of the headers. We then call it one last time to read the body.

If we were to run the above, we would get something like

```text
source(nil) -> "GET /a HTTP/1.1", nil
source(nil) -> "Host: 0.0.0.0:80", nil
source(nil) -> "Content-Length: 10", nil
source(nil) -> "", nil
source(nil) -> "aaaaaaaaaa", nil
source(nil) -> "", nil
source(10) -> nil, "closed"
```

## Examples

Luncheon provides 2 constructors for both `Request` and `Response` that will create a source for
you. These method are `tcp_source` and `udp_source`, each of these takes a luasocket (or cosock)
socket and then wraps them in a `source` for you. Below are some examples of using the `tcp_source`
constructor.

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
