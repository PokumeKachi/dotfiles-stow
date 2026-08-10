local M = {}

-- Helper to get caller info for debugging
local function get_caller_info()
	local info = debug.getinfo(4, "Sl") -- 3 = caller of keymap() / buf_keymap()
	if not info then
		return "unknown", 0
	end
	local source = info.source:gsub("^@", ""):gsub("^.*lua/", "")
	return source, info.currentline or 0
end

-- Warn if mapping has no action (shows exact file/line)
local function warn_if_no_action(rhs, opts)
	if rhs == nil and (opts == nil or opts.callback == nil) then
		local file, line = get_caller_info()
		vim.notify(
			string.format("Keymap with no action at %s:%d", file, line),
			vim.log.levels.WARN,
			{ title = "Keymap" }
		)
		return 1
	end
end

local KEYMAP_DEFAULTS = {
	silent = true,
	noremap = true,
}

-- 🔧 Global mappings
function M.map(modes, lhs, rhs, opts)
	if type(rhs) == "table" then
		opts = rhs
		rhs = nil
	end
	opts = opts or {}

	if warn_if_no_action(rhs, opts) then
		return
	end

	vim.keymap.set(modes, lhs, rhs, vim.tbl_extend("force", KEYMAP_DEFAULTS, opts))
end

-- 🔧 Buffer-local mappings
function M.buf_map(bufnr, mode, lhs, rhs, opts)
	if type(rhs) == "table" then
		opts = rhs
		rhs = nil
	end
	opts = opts or {}

	if warn_if_no_action(rhs, opts) then
		return
	end

	local buf_defaults = vim.tbl_extend("force", KEYMAP_DEFAULTS, { buffer = bufnr })
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", buf_defaults, opts))
end

local LAZY_KEYMAP_DEFAULTS = {
	desc = "REF HE FORGOT TO RENAME TS",
	mode = { "n" },
	noremap = true,
	silent = true,
}

function M.lazy_map(modes, lhs, rhs, opts)
	if type(rhs) == "table" then
		opts = rhs
		rhs = nil
	end
	opts = opts or {}

	if warn_if_no_action(rhs, opts) then
		return
	end

	if modes ~= nil then
		if type(modes) == "string" then
			modes = { modes }
		end
		opts.mode = modes
	end

	return vim.tbl_extend("force", {
		lhs,
		rhs,
	}, vim.tbl_extend("force", LAZY_KEYMAP_DEFAULTS, opts))
end

return M
