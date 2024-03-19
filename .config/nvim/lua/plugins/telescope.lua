return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kkharji/sqlite.lua",
    {
      "prochri/telescope-all-recent.nvim",
      dependencies = {
        "stevearc/dressing.nvim",
      },
      opts = {},
    },
    "ThePrimeagen/harpoon",
    { "nvim-telescope/telescope-fzf-native.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    {
      "danielfalk/smart-open.nvim",
      branch = "0.2.x",
      config = function() end,
      dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim" },
      },
    },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_config = {
          height = 0.90,
          width = 0.90,
          preview_cutoff = 0,
          horizontal = { preview_width = 0.60 },
          vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
          prompt_position = "top",
        },
        path_display = { "smart" },
        prompt_position = "top",
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim", -- add this value
        },
      },
      -- pickers = {}
      pickers = {
        buffers = {
          prompt_prefix = "󰸩 ",
        },
        commands = {
          prompt_prefix = " ",
          layout_config = {
            height = 0.63,
            width = 0.78,
          },
        },
        command_history = {
          prompt_prefix = " ",
          layout_config = {
            height = 0.63,
            width = 0.58,
          },
        },
        git_files = {
          prompt_prefix = "󰊢 ",
          show_untracked = true,
        },
        find_files = {
          prompt_prefix = " ",
          find_command = { "fd", "-H" },
        },
        live_grep = {
          prompt_prefix = "󰱽 ",
        },
        grep_string = {
          prompt_prefix = "󰱽 ",
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
        smart_open = {
          cwd_only = true,
          filename_first = true,
        },
      },
    })

    -- Enable telescope extensions, if they are installed
    require("telescope").load_extension("harpoon")
    require("telescope").load_extension("smart_open")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("ui-select")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, {
      desc = "[S]earch [H]elp",
    })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, {
      desc = "[S]earch [K]eymaps",
    })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, {
      desc = "[S]earch [F]iles",
    })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, {
      desc = "[S]earch [S]elect Telescope",
    })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, {
      desc = "[S]earch current [W]ord",
    })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, {
      desc = "[S]earch by [G]rep",
    })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, {
      desc = "[S]earch [D]iagnostics",
    })
    vim.keymap.set("n", "<leader>sr", builtin.resume, {
      desc = "[S]earch [R]esume",
    })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, {
      desc = '[S]earch Recent Files ("." for repeat)',
    })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, {
      desc = "[ ] Find existing buffers",
    })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, {
      desc = "[/] Fuzzily search in current buffer",
    })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, {
      desc = "[S]earch [/] in Open Files",
    })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({
        cwd = vim.fn.stdpath("config"),
      })
    end, {
      desc = "[S]earch [N]eovim files",
    })
  end,
}
