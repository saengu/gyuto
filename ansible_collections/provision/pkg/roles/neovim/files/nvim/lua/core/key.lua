-- Module to simplify key mapping operations. It will try to register
-- shortcut keys by which-key.nvim plugin if the plugin is installed
-- otherwise use vim.keymap.set to do that.
--
-- As this key module use not not rely on which-key plugin, that means
-- it still can work without which-key plugin, it's ok to put in core module.
--
-- Inspired by https://github.com/AstroNvim/AstroNvim/blob/46d47ca291445b54e075c48c5e140908b5e3be69/lua/astronvim/utils/init.lua#L177
local M = {
  native = false,  -- Force to use vim.keymap.set
}


-- Register key mappings using similar api like which-key.register
-- execpt that the opts.mode could be a string or a list of string
-- @param mappings table: same format as which-key.register
-- @param options: same keys as which-key.register
function M.set(mappings, options)
  local util = require("core.util")
  local wk, err = util.prequire("which-key")

  if wk and not native then
    wk.register(mappings, options)
  else
    M.register(mappings, options)
  end
end


-- Map option names for vim.keymap.set function
local map_options = {
  "noremap",
  "expr",
  "silent",
  "nowait",
  "script",
  "unique",
  "prefix",
  "mode",
  "buffer",
  "preset",
  "replace_keycodes",
}


-- Remove unused keys and extract map options from key mappings
-- options from mapping will merge to and override options in opts
--
-- @param mappings table: key map settings
-- @param options table: mapping options
-- @return number indexed arguments, keymap record, mapping options
function M.preprocess(mappings, options)
  -- Remove keys only used by which-key plugin mappings spec
  if mappings.name then
    mappings.name = nil
  end

  -- Extract options from mapping, the option will be removed from mapping
  local args = {}
  local keymap = {}
  local opts = {}

  for k, v in pairs(mappings) do
    if type(k) == "number" then
      if type(v) == "table" then
        table.insert(keymap, v)
      else
        table.insert(args, v)
      end
    elseif map_options[k] then
      opts[k] = mappings[k]
    else
      keymap[k] = mappings[k]
    end
  end

  opts = vim.tbl_deep_extend('keep', opts, options)

  return args, keymap, opts
end


-- Register key mappings by vim.keymap.set api
-- Refer to https://github.com/folke/which-key.nvim/blob/fb027738340502b556c3f43051f113bcaa7e8e63/lua/which-key/mappings.lua#L86
-- @param mappings table: key map settings
-- @param options table: mapping options
function M.register(mappings, options)
  options = options or {}

  if type(mappings) ~= "table" then
    mappings = { mappings }
  end

  -- fix remap
  if options.remap then
    options.noremap = not options.remap
    options.remap = nil
  end

  -- fix buffer
  if options.buffer == 0 then
    options.buffer = vim.api.nvim_get_current_buf()
  end

  local args, keymap, opts = M.preprocess(mappings, options)

  -- If a mapping is a associate table (no number indexed keys), it contains 
  -- submappings and should parse recusively
  if #args == 0 then
    -- process any array child mappings
    for key, val in pairs(keymap) do
      local o = vim.deepcopy(opts)
      if type(key) == "string" then
        o.prefix = (opts.prefix or "") .. key
      end
      M.register(val, o)
    end
  -- If a mappings contains exactly two number indexed element, the first is cmd or
  -- callback for key map, and the second is description, it is the final mapping. 
  elseif #args == 2 then
    -- Stop condition for recusively parsing mappings.
    -- args[1] is cmd or function
    assert(type(args[1]) == "string" or type(args[1]) == "function")

    -- args[2] is desc and ignore it
    assert(type(args[2]) == "string")

    local cmd = args[1]  -- mapped cmd or function

    -- Remove mode and prefix from opts that are not valid vim.keymap.set options
    local mode = opts.mode or 'n'  -- use normal mode as default
    opts.mode = nil

    local prefix = opts.prefix
    opts.prefix = nil

    vim.keymap.set(mode, prefix, cmd, opts)
  else
    error("Incorrect mapping " .. vim.inspect(mappings) .. " " .. vim.inspect(options))
  end
end


return M
