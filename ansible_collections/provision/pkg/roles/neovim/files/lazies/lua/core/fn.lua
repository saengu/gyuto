local M = {}

-- Using proxy-metatable and questionable Null Object pattern
-- from: https://stackoverflow.com/questions/53127647/how-to-check-if-a-table-sub-field-exist-in-lua
function M.make_safetable()
	local proto = {
		__index = function(self, key)
			local val = rawget(self, key)     -- avoid infinite recursion
			if val == nil then
				val = M.make_safetable()
				rawset(self, key, val)
			end
			return val
		end
	}
	return setmetatable({}, proto)
end

function M.iscallable(fn)
	return type(fn) == "function"
end


return M
