return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        toml = { "prettier" },
        sh = { "shfmt" },
        markdown = { "prettier" },
        bib = { "bibtex-tidy" },
        -- "_" is for filetypes without any other formatters
        ["_"] = {
          "trim_whitespace",
          "trim_newlines",
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    require("conform").formatters.shfmt = {
      prepend_args = { "--indent=2", "--case-indent" },
    }

    require("conform").formatters.stylua = {
      prepend_args = { "--indent-type=Spaces", "--indent-width=2" },
    }

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.keymap.set("n", "<leader>lc", "<cmd>ConformInfo<cr>", { desc = "conform (formatter) info" })
    vim.keymap.set("n", "<leader>lf", function()
      require("conform").format()
    end, { desc = "format" })
  end,
}
