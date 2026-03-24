local godot_fts = { "godot", "godot_resource", "gdshader" }

vim.api.nvim_create_user_command("GodotRun", function()
  local dap = require("dap")
  dap.run({
    type = "godot",
    request = "launch",
    name = "Launch scene",
    project = vim.fn.expand("%:p:h"),
    launch_scene = true,
  })
end, {})

for _, ft in ipairs(godot_fts) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.keymap.set("n", "<F5>", "<Cmd>GodotRun<CR>", { buffer = true })
    end,
  })
end
