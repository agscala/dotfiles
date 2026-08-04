return {
	"ThePrimeagen/99",
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

		vim.keymap.set("v", "<leader>av", function()
			_99.visual()
		end, { desc = "99: visual" })

		vim.keymap.set("n", "<leader>ax", function()
			_99.stop_all_requests()
		end, { desc = "99: stop all requests" })

		vim.keymap.set("n", "<leader>as", function()
			_99.search()
		end, { desc = "99: search" })
	end,
}
