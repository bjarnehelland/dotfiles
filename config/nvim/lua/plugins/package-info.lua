return {
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup({
        autostart = false,
        package_manager = "npm",
        colors = {
          outdated = "#db4b4b",
        },
        hide_up_to_date = true,
      })
    end,
    keys = {
      {
        "<leader>cpt",
        "<cmd>lua require('package-info').toggle()<cr>",
        desc = "Toggle",
      },
      {
        "<leader>cpd",
        "<cmd>lua require('package-info').delete()<cr>",
        desc = "Delete package",
      },
      {
        "<leader>cpu",
        "<cmd>lua require('package-info').update()<cr>",
        desc = "Update package",
      },
      {
        "<leader>cpi",
        "<cmd>lua require('package-info').install()<cr>",
        desc = "Install package",
      },
      {
        "<leader>cpc",
        "<cmd>lua require('package-info').change_version()<cr>",
        desc = "Change package version",
      },
    },
  },
}
