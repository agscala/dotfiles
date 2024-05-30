return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
    "nvim-tree/nvim-web-devicons" -- Recommended but not required. Icons in discussion tree.
  },
  enabled = true,
  build = function () require("gitlab.server").build(true) end, -- Builds the Go binary
  config = function()
    local gitlab = require("gitlab")
    gitlab.setup({
      create_mr = {
        target = "main"
      }
    })
  end,
  keys = {
    { "glr", "<cmd>lua require('gitlab').review()<cr>", desc = "(r)eview MR" },
    { "gls", "<cmd>lua require('gitlab').summary()<cr>", desc = "MR (s)ummary" },
    { "glA", "<cmd>lua require('gitlab').approve()<cr>", desc = "(A)pprove MR" },
    { "glR", "<cmd>lua require('gitlab').revoke()<cr>", desc = "(R)evoke approval" },
    { "glc", "<cmd>lua require('gitlab').create_comment()<cr>", desc = "Create (c)omment" },
    { "glc", "<cmd>lua require('gitlab').create_multiline_comment()<cr>", desc = "Create (c)omment multiline", mode = "v" },
    { "gls", "<cmd>lua require('gitlab').create_comment_suggestion()<cr>", desc = "Create comment (s)uggestion", mode = "v" },
    { "glO", "<cmd>lua require('gitlab').create_mr()<cr>", desc = "(O)pen MR" },
    { "gln", "<cmd>lua require('gitlab').create_note()<cr>", desc = "Create (n)ote" },
    { "gld", "<cmd>lua require('gitlab').toggle_discussions()<cr>", desc = "Toggle (d)iscussion" },
    { "glaa", "<cmd>lua require('gitlab').add_assignee()<cr>", desc = "(a)ssignee (a)dd" },
    { "glad", "<cmd>lua require('gitlab').delete_assignee()<cr>", desc = "(a)ssignee (d)elete" },
    { "glla", "<cmd>lua require('gitlab').add_label()<cr>", desc = "(l)abel (a)dd" },
    { "glld", "<cmd>lua require('gitlab').delete_label()<cr>", desc = "(l)abel (d)elete" },
    { "glra", "<cmd>lua require('gitlab').add_reviewer()<cr>", desc = "(r)eviewer (a)dd" },
    { "glrd", "<cmd>lua require('gitlab').delete_reviewer()<cr>", desc = "(r)eviewer (d)elete" },
    { "glp", "<cmd>lua require('gitlab').pipeline()<cr>", desc = "(p)ipeline" },
    { "glo", "<cmd>lua require('gitlab').open_in_browser()<cr>", desc = "(o)pen in browser" },
    --vim.keymap.set("n", "glM", gitlab.merge)
    --vim.keymap.set("n", "glm", gitlab.move_to_discussion_tree_from_diagnostic)
  }
}
