local map = require("utils.keymap").lazy_map

local function zk()
    return require("zk")
end

local function zk_api()
    return require("zk.api")
end

local function pickNotes(param1, param2)
	zk().pick_notes(param1 or {}, param2 or {}, function(selection)
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

return {
	"zk-org/zk-nvim",
	config = function()
		require("zk").setup({
			picker = "snacks_picker",

			lsp = {
				config = {
					name = "zk",
					cmd = { "zk", "lsp" },
					filetypes = { "markdown", "typst" },
				},

				auto_attach = {
					enabled = true,
				},
			},
		})
	end,
    keys = {
        map({ "n", "x" }, "<leader>zk", "<nop>", { desc = "Zk Commands" }),
        map("n", "<leader>zkp", "<nop>", { desc = "Picker" }),
        map({ "n", "x" }, "<leader>zkn", "<nop>", { desc = "Create New" }),

        map("n", "<leader>zknn", "<cmd>ZkNew<CR>", {
            desc = "New Note",
        }),

        map("x", "<leader>zknn", "<cmd>ZkNewFromTitleSelection<CR>", {
            desc = "New Note (Named From Selection)",
        }),

        map("n", "<leader>zknl", function()
            zk_api().index()
            vim.cmd("ZkInsertLink")
        end, {
            desc = "New Link",
        }),

        map("x", "<leader>zknl", "<cmd>'<,'>ZkInsertLinkAtSelection<CR>", {
            desc = "New Link (Named From Selection)",
        }),

        map("n", "<leader>zkpn", function()
            zk().index()
            pickNotes()
        end, {
            desc = "Pick By Note Name",
        }),

        map("n", "<leader>zkpt", function()
            zk().index()
            zk().pick_tags({}, {}, function(selection)
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
        }),

        map("n", "<leader>zkl", "<cmd>ZkLinks<CR>", {
            desc = "View Links",
        }),

        map("n", "<leader>zkb", "<cmd>ZkBacklinks<CR>", {
            desc = "View Backlinks",
        }),
    },
}
