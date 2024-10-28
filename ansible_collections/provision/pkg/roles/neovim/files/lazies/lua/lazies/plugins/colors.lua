local catppuccin = { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = {}, }

-- The default Terminal.app on macOS only support 256 color, not support termguicolors,
-- so use gruvbox-material which has a 256 color palette.
local gruvbox = { 
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000, 
	config = function(opts)
		-- refer to the author's settings:
		--   https://github.com/sainnhe/dotfiles/blob/master/.config/nvim/autoload/custom/colorscheme.vim
		vim.o.background = "dark" -- or "light" for light mode
		vim.g.gruvbox_material_background = "hard" -- hard | medium | soft
		vim.g.gruvbox_material_foreground = "mix"  -- original | mix | material
	   --vim.g.gruvbox_material_enable_italic = true
		--vim.g.gruvbox_material_disable_italic_comment = true
		vim.g.gruvbox_material_enable_italic = vim.g.vim_italicize_keywords
		vim.g.gruvbox_material_better_performance = 1
      vim.cmd.colorscheme('gruvbox-material')
	end,
}

return gruvbox
