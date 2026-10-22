return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true, ignored = false, exclude = { ".venv", "cdk.out", "node_modules" } },
          grep = { hidden = true, ignored = false, exclude = { ".venv", "cdk.out", "node_modules" } },
          explorer = { hidden = true, ignored = true },
        },
      },
    },
  },
}
