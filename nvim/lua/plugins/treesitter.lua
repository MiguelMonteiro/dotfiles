return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "rust",
          "toml",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
        },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
}
