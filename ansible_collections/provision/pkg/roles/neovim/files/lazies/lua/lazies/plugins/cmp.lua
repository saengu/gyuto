local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "onsails/lspkind-nvim", -- vscode-like pictograms
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      dependencies = {"rafamadriz/friendly-snippets"}, -- Snippets collection
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end
    },
    "saadparwaiz1/cmp_luasnip",
  },
}

function M.config()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local types = require("luasnip.util.types")
  local lspkind = require("lspkind")

  -- Display virtual text to indicate snippet has more nodes
  luasnip.config.setup({
    ext_opts = {
      [types.choiceNode] = {
        active = {virt_text = {{"⇥", "GruvboxRed"}}}
      },
      [types.insertNode] = {
        active = {virt_text = {{"⇥", "GruvboxBlue"}}}
      }
    }
  })

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({select = true}),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, {"i", "s"}),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      {name = "nvim_lsp"},
      {name = "luasnip"},
      {name = "buffer"},
      {name = "path"},
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text", -- show only symbol annotations
        maxwidth = {
          menu = 50, -- leading text (labelDetails)
          abbr = 50, -- actual suggestion item
        },
        ellipsis_char = "...",
        show_labelDetails = true,
      }),
    },
  })
end

return M
