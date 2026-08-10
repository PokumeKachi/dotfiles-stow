local map = require("utils.keymap").map

local function map_all_cases(modes, keys, action, opts)
	local function case_combinations(str)
		if #str == 0 then
			return {
				"",
			}
		end
		local rest = case_combinations(str:sub(2))
		local c = str:sub(1, 1)
		local t = {}
		for _, r in ipairs(rest) do
			table.insert(t, c:lower() .. r)
			table.insert(t, c:upper() .. r)
		end
		return t
	end

	opts = opts or {
		noremap = true,
		silent = true,
	}

	if type(modes) ~= "table" then
		modes = {
			modes,
		}
	end

	for _, mode in ipairs(modes) do
		for _, variant in ipairs(case_combinations(keys)) do
			map(mode, variant, action, opts)
		end
	end
end



map("n", "<esc>", "<cmd>nohlsearch<cr>")
map_all_cases({ "i" }, "jk", "<C-\\><C-n>")
