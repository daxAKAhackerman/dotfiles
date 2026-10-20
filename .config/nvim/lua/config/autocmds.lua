-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatically rename the tmux window to the project root

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if not vim.env.TMUX then
      return
    end

    local root = LazyVim.root()
    if not root or root == "" then
      root = vim.fn.getcwd()
    end

    local name = "LazyVim: " .. vim.fn.fnamemodify(root, ":t")
    if name == "" then
      return
    end

    vim.fn.system({
      "tmux",
      "rename-window",
      name,
    })

    vim.fn.system({
      "tmux",
      "split-window",
      "-v",
      "-l",
      "30%",
      "-d",
    })

    vim.fn.system({
      "tmux",
      "resize-pane",
      "-Z",
    })
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if not vim.env.TMUX then
      return
    end

    vim.fn.system({
      "tmux",
      "set-option",
      "automatic-rename",
      "on",
    })

    vim.fn.system({
      "tmux",
      "kill-pane",
      "-a",
    })
  end,
})
