return {
  {
    "smart-splits-nvim/smart-splits.nvim",
    version = "^3.0.0",
    lazy = false,
    dependencies = {
      {
        "smart-splits-nvim/backend-tmux",
        main = "smart-splits-backend-tmux",
      },
    },
    opts = {
      mux = {
        backend = "smart-splits-backend-tmux",
      },
    },
    keys = {
      {
        "<A-n>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Navigate left",
      },
      {
        "<A-u>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Navigate up",
      },
      {
        "<A-i>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Navigate right",
      },
      {
        "<A-e>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Navigate down",
      },
    },
  },
}
