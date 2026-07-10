local treesitter = require("nvim-treesitter")

local ensure_installed = {
  "bash",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

treesitter.setup()

if vim.fn.executable("tree-sitter") == 1 then
  local installed = treesitter.get_installed("parsers")
  local missing = vim.tbl_filter(function(parser)
    return not vim.list_contains(installed, parser)
  end, ensure_installed)

  if #missing > 0 then
    treesitter.install(missing, { max_jobs = 4 })
  end
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Start Tree-sitter highlighting",
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
