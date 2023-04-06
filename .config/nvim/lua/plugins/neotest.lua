return {
  "nvim-neotest/neotest",
  dependencies = {
    'nvim-neotest/neotest-plenary',
    'antoinemadec/FixCursorHold.nvim',
    'haydenmeade/neotest-jest',
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-plenary"),

        require('neotest-jest')({
          jestCommand = "yarn test",
          jestConfigFile = "jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),

      },
    })

    vim.api.nvim_set_keymap("n", "<leader>tw", "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>", {})
  end,
}
