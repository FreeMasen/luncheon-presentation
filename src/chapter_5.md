# Headers

$slides-only$

- Provided as its own table
- Key-Value Store
  - Keys can map to multiple values
- Keys are not case-sensitive
- Accessors for last entry or all entries

$slides-only-end$

## Examples

```lua
local lunch = require "luncheon"

local headers = lunch.Headers.new()

headers:append("Host", "0.0.0.0")
headers:append_chunk("Date: Tue, 18 Apr 2023 10:33:00 CST")
headers:append_chunk("Date: Mon, 17 Apr 2023 10:33:00 CST")

assert(headers:get_one("host") == "0.0.0.0)
local dates = headers:get_all("Date")
assert(#dates == 2)

print("DATES:)
for i, value in pairs(dates) do
    print(i, value)
end
print("----")
```
