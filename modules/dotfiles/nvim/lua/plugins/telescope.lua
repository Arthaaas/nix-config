require("telescope").setup({})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Serch Files" })
vim.keymap.set("n", "<leader>")
