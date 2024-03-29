return {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
        or nil,
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip").filetype_extend("ruby", {"rails"})
    end,
    opts = {
        history = true,
        delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
    },
}
