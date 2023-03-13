local M = {}


-- Require module without execption
-- @param m string: module name to load
-- @return module, string
function M.prequire(m)
  local ok, val = pcall(require, m) 
  if ok then
    return val, nil -- module
  else
    return nil, val -- error message
  end
end


return M
