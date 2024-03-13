return {
  "folke/noice.nvim",
  opts = {
    cmdline = {
      format = {
        search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
      },
    },
  },
}
