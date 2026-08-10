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

map("n", "<leader>bp", function()
	local ft = vim.bo.filetype

	if ft == "tex" then
		vim.cmd("VimtexCompile")
		return
	end

	if ft == "markdown" then
		-- local browser = os.getenv("BROWSER") or "firefox"
		-- os.execute(browser .. " --new-window")
		vim.cmd("Vivify")
		return
	end

	if ft ~= "typst" then
		return
	end

	local file = vim.fn.expand("%:p")
	local out = "/tmp/" .. vim.fn.expand("%:t:r") .. ".pdf"

	killTypstPreview()

	typstJob = vim.fn.jobstart({
		"typst",
		"watch",
		file,
		out,
	}, {
		stderr_buffered = false,
		on_stderr = function(_, data)
			if not data then
				return
			end

			local errors = {}
			local isError = false

			for _, line in ipairs(data) do
				table.insert(errors, line)
				if line:match("^error:") then
					isError = true
				end
			end

			if not isError then
				return
			end

			local tmp = "/tmp/typst_error.typ"
			local lines = {
				"= Compilation failed",
				"",
			}

			for _, line in ipairs(errors) do
				table.insert(lines, "=== `" .. line .. "`")
			end

			vim.fn.writefile(lines, tmp)
			vim.fn.system({
				"typst",
				"compile",
				tmp,
				out,
			})
		end,
	})

	zathuraJob = vim.fn.jobstart({
		"zathura",
		out,
	}, {
		detach = true,
	})
end, {
	silent = true,
	desc = "[b]uffer [p]review",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = killTypstPreview,
})
