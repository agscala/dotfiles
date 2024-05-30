return {
    'LionC/nest.nvim',
    config = function()
        local nest = require('nest')
        nest.applyKeymaps {
            -- { '<leader>',
            -- { 'w',
            -- { 'a', "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>" },
            -- { 'r', "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>" },
            -- { 'l', "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>" },
            -- },
            -- },

            -- LSP stuff
            { '<leader>D',  "<cmd>lua vim.lsp.buf.type_definition()<CR>" },
            { 'rn',         "<cmd>lua vim.lsp.buf.rename()<CR>" },
            { 'gD',         "<Cmd>lua vim.lsp.buf.declaration()<CR>" },
            { 'gd',         "<Cmd>lua vim.lsp.buf.definition()<CR>" },
            { 'ga',         "<Cmd>lua vim.lsp.buf.code_action()<CR>" },
            { 'gi',         "<Cmd>lua vim.lsp.buf.implementation()<CR>" },
            { 'gr',         "<Cmd>lua vim.lsp.buf.references()<CR>" },
            { 'K',          "<cmd>lua vim.lsp.buf.hover()<CR>" },
            { '<C-k>',      "<cmd>lua vim.lsp.buf.signature_help()<CR>" },
            { '[d',         "<cmd>lua vim.diagnostic.goto_prev({float = false})<CR>" },
            { ']d',         "<cmd>lua vim.diagnostic.goto_next({float = false})<CR>" },
            -- { '<Leader>e', "<cmd>lua vim.diagnostic.open_float()<CR>" },
            --{ '<Leader>e',  "<cmd>lua require('lsp_lines').toggle()<CR>" },
            { '<Leader>q',  "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>" },
            --{ '<Leader>fm', "<Cmd>Neoformat<CR>" },
            --{ '<Leader>fm', "<cmd>lua vim.lsp.buf.format()<CR>" },
            { '<leader>', {
                { 't', { -- telescope pickers
                    { 'u', ":UndotreeToggle<CR>" }
                } },
                { 'f',
                    { -- telescope pickers
                        { 't', ":NvimTreeFindFileToggle<CR>",                           { noremap = true, silent = true } },
                        { 'u', ":UndotreeToggle<CR>" },
                        { 'f', "<Cmd>lua require('telescope.builtin').find_files()<CR>" },
                        { 's', "<Cmd>lua require('telescope.builtin').live_grep()<CR>" },
                        { 'b', "<Cmd>lua require('telescope.builtin').buffers()<CR>" },
                        { 'h', "<Cmd>lua require('telescope.builtin').help_tags()<CR>" },
                        { 'o', "<Cmd>lua require('telescope.builtin').oldfiles()<CR>" },
                        { 'e', "<Cmd>lua require('telescope.builtin').symbols() <CR>" },
                        { 'r', "<Cmd>lua require('telescope.builtin').resume() <CR>" }
                    } },
                { 'g', { -- git stuff
                    { 'm', "<Cmd>GitMessenger<CR>" }, { 'b', "<Cmd>Git blame<CR>" },
                    { 's', "<Cmd>Git<CR>" }
                } }
            } },
            {
                mode = 'i',
                {
                    { '<C-e>', "<Cmd>lua require'telescope.builtin'.symbols() <CR>" } }
            }
        }
    end,
}
