return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          init_options = {
            settings = {
              lineLength = 160,
              lint = {
                extendSelect = { "I" },
              },
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = {
          "ruff_organize_imports",
          "ruff_fix",
          "ruff_format",
        },
      },
    },
  },
}
