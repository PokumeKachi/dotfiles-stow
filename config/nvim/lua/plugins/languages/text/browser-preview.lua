local map = require("utils.keymap").map

local typstJob
local zathuraJob

local function killTypstPreview()
	if typstJob then
		vim.fn.jobstop(typstJob)
	end
	if zathuraJob then
		vim.fn.jobstop(zathuraJob)
	end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = killTypstPreview,
})

map("n", "<leader>bp", function()
	local ft = vim.bo.filetype

	if ft == "tex" then
		vim.cmd("VimtexCompile")
	end

	if ft == "markdown" then
		vim.cmd("Vivify")
	end

	if ft == "typst" then
		vim.cmd("TypstPreview")
		-- local file = vim.fn.expand("%:p")
		-- local out = "/tmp/" .. vim.fn.expand("%:t:r") .. ".pdf"
		--
		-- killTypstPreview()
		--
		-- typstJob = vim.fn.jobstart({
		-- 	"typst",
		-- 	"watch",
		-- 	file,
		-- 	out,
		-- }, {
		-- 	stderr_buffered = false,
		-- 	on_stderr = function(_, data)
		-- 		if not data then
		-- 			return
		-- 		end
		--
		-- 		local errors = {}
		-- 		local isError = false
		--
		-- 		for _, line in ipairs(data) do
		-- 			table.insert(errors, line)
		-- 			if line:match("^error:") then
		-- 				isError = true
		-- 			end
		-- 		end
		--
		-- 		if not isError then
		-- 			return
		-- 		end
		--
		-- 		local tmp = "/tmp/typst_error.typ"
		-- 		local lines = {
		-- 			"= Compilation failed",
		-- 			"",
		-- 		}
		--
		-- 		for _, line in ipairs(errors) do
		-- 			table.insert(lines, "=== `" .. line .. "`")
		-- 		end
		--
		-- 		vim.fn.writefile(lines, tmp)
		-- 		vim.fn.system({
		-- 			"typst",
		-- 			"compile",
		-- 			tmp,
		-- 			out,
		-- 		})
		-- 	end,
		-- })
		--
		-- zathuraJob = vim.fn.jobstart({
		-- 	"zathura",
		-- 	out,
		-- }, {
		-- 	detach = true,
		-- })
	end
end, {
	desc = "Preview Buffer",
})

return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {},
	},
	{
		"lervag/vimtex",
		ft = "tex",
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "general"
			vim.g.vimtex_view_general_viewer = "zathura"
			-- vim.g.vimtex_view_general_options = "./build/%s"

			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				out_dir = ".artifacts",
				continuous = 1,
				executable = "latexmk",
				options = {
					"-pdf",
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
					"-halt-on-error",
				},
			}

			-- vim.g.vimtex_compiler_method = "tectonic"
			--
			-- vim.g.vimtex_compiler_tectonic = {
			-- 	build_dir = "build",
			-- 	continuous = 0, -- MUST be 0
			-- 	executable = "tectonic",
			-- 	options = {
			-- 		"--synctex",
			-- 		"--keep-logs",
			-- 		"--keep-intermediates",
			-- 	},
			-- }

			vim.g.vimtex_compiler_silent = 1
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_syntax_enabled = 0
		end,
	},
	{
		"jannis-baum/vivify.vim",
	},
}
