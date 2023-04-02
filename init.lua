-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local function bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup("plugins", {
    ui = {
      border = "single",
      size = { width = 0.9, height = 0.8 },
    },
  })
end

bootstrap()
require("core")
require("mapping")
