return {
  'windwp/nvim-autopairs',
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { 'string' }, -- it will not add a pair on that treesitter node
        javascript = { 'template_string' },
        java = false,       -- don't check treesitter on java
      }
    })

    local ts_conds = require('nvim-autopairs.ts-conds')
    local Rule = require('nvim-autopairs.rule')

    -- press % => %% only while inside a comment or string
    autopairs.add_rules({
      Rule("%", "%", "lua")
          :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
      Rule("$", "$", "lua")
          :with_pair(ts_conds.is_not_ts_node({ 'function' }))
    })
  end,
}
