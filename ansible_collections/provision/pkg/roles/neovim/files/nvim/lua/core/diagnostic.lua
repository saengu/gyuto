--------------------------------------------------
--
-- Setup UI style of diagnostic related elements
--
--------------------------------------------------
local icons = require("core.icons")

local Diagnostic = {}


function Diagnostic:new()
  return setmetatable({}, { __index = self })
end


-- Set diagnostic sign by name
function Diagnostic:define_sign(name, icon)
  local sign_name = 'DiagnosticSign' .. name
  vim.fn.sign_define(
    sign_name,
    { text = icon, texthl = sign_name, numhl = sign_name }
  )
end


-- Custom diagnostic to unicode glyph to be more strikingly
function Diagnostic:custom_signs()
  for name, icon in pairs(icons.diagnostics) do
    self:define_sign(name, icon)
  end
end


function Diagnostic:setup()
  self:custom_signs()

  -- Change the prefix symbol of error diagnostic message ('■') to dog glyph 
  vim.diagnostic.config({
    virtual_text = {
      prefix = '󰩃 ', -- Dog glyph is widechar (two bytes) and prefix contains a tailing whitespace
    },
  })

  -- Make left most sign column same backgroud as line number column.
  vim.cmd("hi! link SignColumn LineNr")
end


return Diagnostic:new()

