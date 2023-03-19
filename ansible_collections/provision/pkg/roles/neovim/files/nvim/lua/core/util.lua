-- This module provides functions frequently used and not properly to
-- put in other modules. Functions in this module should not rely on
-- any other modules otherwise will encounter circular reference.

local M = {}


-- Require module without execption
-- @param m string: module name to load
-- @return module, error string
function M.prequire(m)
  local ok, val = pcall(require, m) 
  if ok then
    return val, nil -- module
  else
    return nil, val -- error message
  end
end


return M
