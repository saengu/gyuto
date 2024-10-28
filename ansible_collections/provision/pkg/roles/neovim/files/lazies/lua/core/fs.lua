
local M = {}

---@param modname string 
---@return string Path of module relative to stdpath("config")
function M.find_root(modname)
	modname = modname:gsub("%.", "/")
	local path = vim.fn.stdpath("config") .. "/lua/" .. modname

	-- module exists as file
	local filepath = path .. ".lua"
	local stat = vim.uv.fs_stat(filepath)
	if stat and stat.type == "file" then
		return filepath
	end

	-- module exists as directory
	local stat = vim.uv.fs_stat(path)
	if not stat or stat.type ~= "directory" then
		return nil
	end
	return path 
end


-- Copy from https://github.com/folke/lazy.nvim/blob/main/lua/lazy/core/util.lua#L286
--
---@alias FileType "file"|"directory"|"link"
---@param path string
---@param fn fun(path: string, name:string, type:FileType):boolean?
function M.ls(path, fn)
  local handle = vim.uv.fs_scandir(path)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    local fname = path .. "/" .. name

    -- HACK: type is not always returned due to a bug in luv,
    -- so fecth it with fs_stat instead when needed.
    -- see https://github.com/folke/lazy.nvim/issues/306
    if fn(fname, name, t or vim.uv.fs_stat(fname).type) == false then
      break
    end
  end
end


-- Borrow from https://github.com/folke/lazy.nvim/blob/main/lua/lazy/core/util.lua#L308
--
---@param modname string
---@param fn fun(modname:string, modpath:string)
function M.lsmod(modname, fn)
  local root = M.find_root(modname)
  if not root then
    return
  end

  if root:sub(-4) == ".lua" then
    fn(modname, root)
    if not vim.uv.fs_stat(root) then
      return
    end
  end

  M.ls(root, function(path, name, type)
    if name == "init.lua" then
      fn(modname, path)
    elseif (type == "file" or type == "link") and name:sub(-4) == ".lua" then
      fn(modname .. "." .. name:sub(1, -5), path)
    elseif type == "directory" and vim.uv.fs_stat(path .. "/init.lua") then
      fn(modname .. "." .. name, path .. "/init.lua")
    end
  end)
end

---@param modname string
function M.load_submods(modname)
	local mods = {}
	local name = modname:match("%.(%w+)$")

	M.lsmod(modname, function(submodname, path)

		-- only support directory module
		if (name .. ".lua") == path:sub(-#name-4) then
			return
		end

		-- ignore init file in module directory
		if path:sub(-7) == "init.lua" then
			return
		end

		local ok, mod = pcall(require, submodname)
		if ok then 
		   local name = submodname:match("%.(%w+)$")
			mods[name] = mod
		end

   end)

	return mods
end


return M
