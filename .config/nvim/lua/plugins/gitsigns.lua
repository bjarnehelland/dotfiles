return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()

    vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>", { desc = "Go to previous hunk" })
    vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>", { desc = "Go to next hunk" })
  end,
}
