return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last Test",
      },
      {
        "<leader>tL",
        function()
          require("neotest").run.run_last({ strategy = "dap" })
        end,
        desc = "Debug Last Test",
      },
      -- {
      --   "<leader>tw",
      --   "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
      --   desc = "Run Watch",
      -- },
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
      table.insert(opts.adapters, require("neotest-vitest"))
      -- table.insert(opts.adapters, require("jfpedroza/neotest-elixir"))
      -- table.insert(opts.adapters, require("markemmons/neotest-deno"))
    end,
  },
}
