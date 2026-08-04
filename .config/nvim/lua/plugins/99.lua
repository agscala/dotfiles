return {
	"ThePrimeagen/99",
	keys = {
		{ "<leader>av", function() require("99").visual() end, mode = "v", desc = "99: visual" },
		{ "<leader>ax", function() require("99").stop_all_requests() end, mode = "n", desc = "99: stop all requests" },
		{ "<leader>as", function() require("99").search() end, mode = "n", desc = "99: search" },
	},
	config = function()
		local _99 = require("99")

		-- For logging that is to a file if you wish to trace through requests
		local cwd = vim.uv.cwd()
		local basename = vim.fs.basename(cwd)
		_99.setup({
			-- provider = _99.Providers.ClaudeCodeProvider,  -- default: OpenCodeProvider
			logger = {
				level = _99.DEBUG,
				path = "/tmp/" .. basename .. ".99.debug",
				print_on_error = true,
			},
			tmp_dir = "./tmp",

			--- Completions: #rules and @files in the prompt buffer
			completion = {
				custom_rules = {
					"scratch/custom_rules/",
				},
				files = {},
				source = "native", -- "native" (default), "cmp", or "blink"
			},

			md_files = {
				"AGENT.md",
			},
		})

	end,
}
