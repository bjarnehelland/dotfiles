return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "prochri/telescope-all-recent.nvim",
      dependencies = {
        "kkharji/sqlite.lua",
      },
      opts = {},
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "debugloop/telescope-undo.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        file_ignore_patterns = { ".git/", "node_modules" },
        layout_config = {
          prompt_position = "top",
        },
        path_display = { "truncate " },
        prompt_position = "top",
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<c-d>"] = actions.delete_buffer,
          },
        },
      },
      pickers = {
        buffers = {
          prompt_prefix = "󰸩 ",
        },
        commands = {
          prompt_prefix = " ",
        },
        command_history = {
          prompt_prefix = " ",
        },
        git_files = {
          prompt_prefix = "󰊢 ",
          show_untracked = true,
        },
        find_files = {
          prompt_prefix = " ",
        },
        live_grep = {
          prompt_prefix = "󰱽 ",
        },
        grep_string = {
          prompt_prefix = "󰱽 ",
        },
      },
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          }, -- telescope-undo.nvim config, see below
        },
        -- other extensions:
        -- file_browser = { ... }
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("undo")
    telescope.load_extension("harpoon")
  end,
  keys = {
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>sg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
    { "<leader>sz", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>ss", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
    { "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Old files" },
    { "<leader>sb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>st", "<cmd>Telescope tags<cr>", desc = "Tags" },
    { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo history" },
  },
}
