local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	-- suffix with folded lines count
	-- local suffix = (" 󰁂 %d lines"):format(endLnum - lnum)
	local last_line = vim.api.nvim_buf_get_lines(0, endLnum - 1, endLnum, false)[1] or ""
	last_line = last_line:match("^%s*(.-)%s*$")
	local suffix = (" ⮜ %d lines ➤ %s"):format(endLnum - lnum - 1, last_line)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0

	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if curWidth + chunkWidth < targetWidth then
			table.insert(newVirtText, chunk) -- keep original text
			curWidth = curWidth + chunkWidth
		else
			local truncated = truncate(chunkText, targetWidth - curWidth)
			table.insert(newVirtText, { truncated, chunk[2] })
			curWidth = curWidth + vim.fn.strdisplaywidth(truncated)
			break
		end
	end

	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	opts = {
		open_fold_hl_timeout = 400,
		provider_selector = function()
			return { "treesitter", "indent" }
		end,
		close_fold_kinds_for_ft = { default = {} },
		close_fold_current_line_for_ft = { default = false },
		fold_virt_text_handler = handler,
		enable_get_fold_virt_text = false,
		preview = {
			win_config = {
				border = "rounded",
				winblend = 12,
				winhighlight = "Normal:Normal",
				maxheight = 20,
			},
			mappings = {},
		},
	},
}
