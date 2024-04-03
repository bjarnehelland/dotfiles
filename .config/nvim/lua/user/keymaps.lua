vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>", { desc = "Sort highlighted text in visual mode" })
vim.keymap.set(
  "v",
  "<leader>rr",
  '"hy:%s/<C-r>h//g<left><left>',
  { desc = "Replace all instances of highlighted text" }
)
-- buffers
vim.keymap.set("n", "]b", "<cmd>bn<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bp<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>X", "<cmd>bd!<cr>", { desc = "Close buffer (force)" })
