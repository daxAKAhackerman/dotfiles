return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- Free <A-n>/<A-p> for smart-splits navigation; ]] and [[ already
          -- jump between references.
          keys = {
            { "<a-n>", false },
            { "<a-p>", false },
          },
        },
      },
    },
  },
}
