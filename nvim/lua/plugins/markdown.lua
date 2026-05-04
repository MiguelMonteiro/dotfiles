return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    config = function()
      require("render-markdown").setup({
        completions = { lsp = { enabled = true } },
        latex = { enabled = false },
        win_options = { conceallevel = { rendered = 2 } },
      })
      vim.keymap.set("n", "<leader>vm", function()
        require("render-markdown").toggle()
      end, { desc = "toggle markdown" })
    end,
  },
  {
    "jbyuki/nabla.nvim",
    config = function()
      vim.keymap.set("n", "<leader>ve", function()
        require("nabla").popup()
      end, { desc = "toggle equation" })

      vim.keymap.set("n", "<leader>va", function()
        require("nabla").toggle_virt()
      end, { desc = "toggle ascii math" })
    end,
  },
}
