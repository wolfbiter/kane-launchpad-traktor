---------------------------------------------------------------------------------
-- dumper()
---------------------------------------------------------------------------------

function dumper(node, depth)
    local depth = depth or 0
    if "table" == type(node) then
        for k, v in pairs(node) do
            print(string.rep('\t', depth)..k)
            dumper(v, depth + 1)
        end
    else
		if node == nil then
        	print(string.rep('\t', depth).."*nil*")
		elseif type(node) == "function" then
        	print(string.rep('\t', depth).."*function*")
		elseif type(node) == "boolean" then
        	print(string.rep('\t', depth).."*boolean*")
		else
        	print(string.rep('\t', depth)..node)
		end
    end
end

---------------------------------------------------------------------------------
-- grid()
---------------------------------------------------------------------------------

function grid(p1, p2)
	if p1 ~= nil and p2 ~= nil then
		t1, t2, p1y, p1x = string.find(p1, "(%d+),(%d)")
		t1, t2, p2y, p2x = string.find(p2, "(%d+),(%d)")

		if p1y ~= nil and p1x ~= nil and p2y ~= nil and p2x ~= nil then
			local t = {}

			for y=p1y,p2y do
				for x=p1x,p2x do
					t[#t+1] = y..","..x
				end
			end

			return t
		end
	else
		return {}
	end
end

---------------------------------------------------------------------------------
-- invert_value() - inverts a low res midi message value
---------------------------------------------------------------------------------

function invert_value(v)
	v = 127 - v
	return v
end

function invert_value_cb(d, e, v, p)
	v = 127 - v
	return v
end

---------------------------------------------------------------------------------
-- create a unique cache name for storing data
---------------------------------------------------------------------------------

function mkcachename(...)
	local n = select("#", ...)
	local c = ""

	for i=1,n do
		c = c .. select(i, ...) .. "___"
	end

	return c
end

---------------------------------------------------------------------------------
-- return table keys as a table
---------------------------------------------------------------------------------

function keys(t)
	local r = {}
	for e, _ in pairs(t) do
		table.insert(r, e)
	end
	return r
end
