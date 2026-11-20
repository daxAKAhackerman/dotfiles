return {
  "folke/snacks.nvim",
  opts = {
    scroll = { enabled = false },
    picker = {
      sources = {
        files = { hidden = true, ignored = false, exclude = { ".venv", "cdk.out", "node_modules" } },
        grep = { hidden = true, ignored = false, exclude = { ".venv", "cdk.out", "node_modules" } },
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.files({ cwd = vim.uv.cwd() })
      end,
      desc = "Find Files (cwd)",
    },
  },
}
