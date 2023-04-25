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
    print(string.format("source(%s) -> %q, %q", pattern, ret, err):gsub("\r", "\\r"):gsub("\n", "\\n"))
    return ret, err
  end
end
local lunch = require "luncheon"
local req = lunch.Request.source(make_request_source())

print(req:get_body())
-- local chunk = ""
-- local source = make_request_source()
-- while chunk do
--   chunk = source()
-- end
