return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    config = function()
      require("blink.cmp").setup({
        keymap = { preset = "default" },
        cmdline = { completion = { menu = { auto_show = true } } },
        completion = { documentation = { auto_show = false } },
        fuzzy = { implementation = "prefer_rust" },
        signature = { enabled = true },
      })
    end,
  },
  { "rafamadriz/friendly-snippets" },
}
