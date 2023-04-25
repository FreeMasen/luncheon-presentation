# Headers

$slides-only$

- Provided as its own table
- Key-Value Store
  - Keys can map to multiple values
- Keys are not case-sensitive
- Accessors for last entry or all entries

$slides-only-end$

$web-only$

Since both `Request` and `Response` need to be able to parse and generate headers, this has been
split out into its own "class". This acts similar to a standard lua table however since headers can
have duplicate keys, some extra care must be taken to make sure all of the values are accessible.

For building up a new set of headers there are a few ways to add new values, the preferred way would
be to use the `append` method, which takes a key string and a value string and will add a duplicate
key-value pair to the map if needed. Since there are some cases where you also want to overwrite any
existing value, the `replace` method is provided.

Since a primary use case is parsing headers that are provided in a chunk of text there is also a
method `append_chunk` that takes a single string argument and will parse multiple headers in the
provided string.

For accessing headers, there are also 2 method due to the potential to have duplicate header keys
with different values. The first is the method `get_all` which takes the key string and returns
a list of string values, even if there is only 1 entry it will always be a list. Alternatively,
the `get_one` method will always provide the _last_ value inserted into the map.

One last thing to touch on before looking at some examples is header keys are _not case sensitive_,
Luncheon's headers type stores the keys by converting them to lower snake case and will do the same
conversion on any keys passed to `get_all` or `get_one`.

$web-only-end$

## Examples

```lua
local lunch = require "luncheon"

-- Create a new empty header map
local headers = lunch.Headers.new()
local date1 = "Date: Tue, 18 Apr 2023 10:33:00 CST"
local date2 = "Date: Mon, 17 Apr 2023 10:33:00 CST"
-- add a new Host header to the map
headers:append("Host", "0.0.0.0")
--Add 2 date headers to the map
headers:append_chunk(date1)
headers:append_chunk(date2)

-- get_one for host will return the value inserted above
assert(headers:get_one("host") == "0.0.0.0")
-- get_all will give us a list of 2 values
local dates = headers:get_all("Date")
assert(#dates == 2)

print("DATES:")
for i, value in pairs(dates) do
    print(i, value)
end
print("----")
-- get_one on a key with multiple values will always return the last value added
print(headers:get_one("date") == date2)
```
