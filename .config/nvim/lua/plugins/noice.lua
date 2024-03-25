return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  event = "VeryLazy",
  opts = {
    presets = { inc_rename = true },
    views = {
      cmdline_popup = {
        position = {
          row = 7,
          col = "55%",
        },
      },
      cmdline_popupmenu = {
        position = {
          row = 7,
          col = "55%",
        },
      },
    },
  },
}
