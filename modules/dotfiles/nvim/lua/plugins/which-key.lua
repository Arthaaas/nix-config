local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 300,
})

wk.add({
  { "<leader>s", group = "Search" },
  { "<leader>f", group = "File" },
  { "<leader>q", desc = "Quit window" },
  { "<leader>w", desc = "Save file" },
  { "<leader>pv", desc = "File Explorer" },
})
