-- Commands: https://github.com/Bryley/neoai.nvim#user-commands

return {
    "Bryley/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    lazy = true,
    cmd = {
        "NeoAI",
        "NeoAIOpen",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
    },
    keys = {
        { "<leader>as", desc = "summarize text" },
        { "<leader>ag", desc = "generate git message" },
    },
    config = function()
        require("neoai").setup({
            -- Options go here
            open_api_key_env = "OPENAI_API_KEY",
            register_output = {
                ["g"] = function(output)
                    return output
                end,
                ["c"] = require("neoai.utils").extract_code_snippets,
            },
            shortcuts = {
                {
                    name = "textify",
                    key = "<leader>as",
                    desc = "fix text with AI",
                    use_context = true,
                    prompt = [[
                        Please rewrite the text to make it more readable, clear,
                        concise, and fix any grammatical, punctuation, or spelling
                        errors
                    ]],
                    modes = { "v" },
                    strip_function = nil,
                },
                {
                    name = "gitcommit",
                    key = "<leader>ag",
                    desc = "generate git commit message",
                    use_context = false,
                    prompt = function()
                        return [[
                            Using the following git diff generate a consise and
                            clear git commit message, with a short title summary
                            that is 75 characters or less:
                        ]] .. vim.fn.system("git diff --cached")
                    end,
                    modes = { "n" },
                    strip_function = nil,
                },
            },
        })
    end,
}