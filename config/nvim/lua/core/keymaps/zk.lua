local map = require('utils.keymap').map

map({"n", "x"}, "<leader>zk", "<nop>", { desc = "Zk Commands" })
map("n", "<leader>zkp", "<nop>", { desc = "Picker" })
map({"n", "x"}, "<leader>zkn", "<nop>", { desc = "Create New" })

map("n", "<leader>zknn", ":ZkNew<CR>", {
	desc = "New Note",
})

map("x", "<leader>zknn", ":ZkNewFromTitleSelection<CR>", {
	desc = "New Note (Named From Selection)",
})

map("n", "<leader>zknl", function()
	ZkApi.index()
	vim.cmd("ZkInsertLink")
end, {
	desc = "Insert Link",
})

map("x", "<leader>zknl", ":'<,'>ZkInsertLinkAtSelection<CR>", {
	desc = "Insert Link (Named From Selection)",
})

local function pickNotes(param1, param2)
	Zk.pick_notes(param1 or {}, param2 or {}, function(selection)
		if not selection then
			return
		end

		for _, note in ipairs(selection) do
			local buf = vim.fn.bufadd(note.absPath)
			vim.fn.bufload(buf)
			vim.bo[buf].buflisted = true
			vim.api.nvim_open_win(buf, true, {
				split = "right",
			})
		end
	end)
end

map("n", "<leader>zkpn", function()
	Zk.index()
	pickNotes()
end, {
	desc = "Pick By Note Name",
})

map("n", "<leader>zkpt", function()
	Zk.index()
	Zk.pick_tags({}, {}, function(selection)
		if not selection then
			return
		end

		local tags = {}

		for _, tag in pairs(selection) do
			table.insert(tags, tag.name)
		end

		pickNotes({
			tags = tags,
		})
	end)
end, {
	desc = "Pick By Tag",
})

map("n", "<leader>zkl", ":ZkLinks<CR>", {
	desc = "View Links",
})

map("n", "<leader>zkb", ":ZkBacklinks<CR>", {
	desc = "View Backlinks",
})
