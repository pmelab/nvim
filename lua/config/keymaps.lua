-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
