return {
  "stevearc/oil.nvim",
  event = "VimEnter",
  opts = {
    default_file_explorer = true,
    -- use_default_keymaps = false,
    -- keymaps = {
    --   ["g?"] = "actions.show_help",
    --   ["<CR>"] = "actions.select",
    --   ["<C-\\>"] = "actions.select_split",
    --   ["<C-enter>"] = "actions.select_vsplit", -- this is used to navigate left
    --   ["<C-t>"] = "actions.select_tab",
    --   ["<C-p>"] = "actions.preview",
    --   ["<C-c>"] = "actions.close",
    --   ["<C-r>"] = "actions.refresh",
    --   ["-"] = "actions.parent",
    --   ["_"] = "actions.open_cwd",
    --   ["`"] = "actions.cd",
    --   ["~"] = "actions.tcd",
    --   ["gs"] = "actions.change_sort",
    --   ["gx"] = "actions.open_external",
    --   ["g."] = "actions.toggle_hidden",
    -- },
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>e",
      function()
        require("oil").toggle_float()
      end,
      mode = "n",
      desc = "File explorer",
    },
  },
}
