local lunch = require "luncheon"

local headers = lunch.Headers.new()
local date1 = "Date: Tue, 18 Apr 2023 10:33:00 CST"
local date2 = "Date: Mon, 17 Apr 2023 10:33:00 CST"
headers:append("Host", "0.0.0.0")
headers:append_chunk(date1)
headers:append_chunk(date2)

assert(headers:get_one("host") == "0.0.0.0")
local dates = headers:get_all("Date")
assert(#dates == 2)

print("DATES:")
for i, value in pairs(dates) do
    print(i, value)
end
print(headers:get_one("date") == date2)
print("----")
