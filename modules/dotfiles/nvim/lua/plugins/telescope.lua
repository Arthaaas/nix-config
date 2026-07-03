require("telescope").setup({})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search Buffers" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })

