local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.g.__buf_dedupe_in_progress then return end
    vim.g.__buf_dedupe_in_progress = true

    local opened_buf = vim.api.nvim_get_current_buf()
    local opened_win = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= opened_win and vim.api.nvim_win_get_buf(win) == opened_buf then
        -- get the alternate buffer *for the opened window*
        local alt_buf
        vim.api.nvim_win_call(opened_win, function()
          alt_buf = vim.fn.bufnr("#")
        end)

        -- focus the already-visible window
        vim.api.nvim_set_current_win(win)

        -- if the opened window has a usable alternate, show it; otherwise close it
        if alt_buf and alt_buf > 0 and vim.api.nvim_buf_is_valid(alt_buf) and vim.api.nvim_buf_is_loaded(alt_buf) then
          vim.api.nvim_win_set_buf(opened_win, alt_buf)
        else
          vim.api.nvim_win_close(opened_win, true)
        end

        vim.g.__buf_dedupe_in_progress = false
        return
      end
    end

    vim.g.__buf_dedupe_in_progress = false
  end,
})

autocmd("TermOpen", {
	callback = function()
		vim.opt_local.relativenumber = true
		vim.schedule(function()
			vim.cmd("startinsert")
		end)
	end,
})

autocmd("BufDelete", {
	callback = function(args)
		local deleted_buf = args.buf
		local buf_name = vim.api.nvim_buf_get_name(deleted_buf)

		if buf_name == "" then
			return
		end

		local buf_dir = vim.fn.fnamemodify(buf_name, ":p:h")

		if vim.fn.isdirectory(buf_dir) == 0 then
			return
		end

		vim.schedule(function()
			local listed = vim.tbl_filter(function(b)
				return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].buftype == ""
			end, vim.api.nvim_list_bufs())

			if #listed == 0 and buf_dir ~= "" then
				vim.cmd("cd " .. vim.fn.fnameescape(buf_dir))
			end
		end)
	end,
	group = vim.api.nvim_create_augroup("OilOnLastBufDelete", { clear = true }),
})

autocmd("VimEnter", {
	callback = function()
		local args = vim.fn.argv()

		if #args == 0 then
			vim.schedule(function()
				require("oil").open(vim.loop.cwd())
			end)
			return
		end

		for _, path in ipairs(args) do
			local stat = vim.loop.fs_stat(path)
			if stat and stat.type == "directory" then
				vim.schedule(function()
					require("oil").open(path)
				end)
				-- break  -- open only the first directory
			end
		end
	end,
})

autocmd("BufEnter", {
	callback = function()
		-- local buf = vim.api.nvim_get_current_buf()
		-- local bufname = vim.api.nvim_buf_get_name(buf)

		-- if vim.fn.isdirectory(bufname) == 1 then
		-- 	vim.notify("check 1")
		--
		-- 	vim.schedule(function()
		-- 		require("oil").open(bufname)
		-- 	end)
		-- elseif vim.bo.filetype == "" and bufname == "" and vim.bo.buflisted then
		-- 	vim.notify("check 2")
		--
		-- 	local opts = { "buftype", "filetype", "buflisted", "bufhidden", "modified" }
		-- 	local prev_dir = vim.fn.expand("#:p:h")
		-- 	local dir = (vim.fn.isdirectory(prev_dir) == 1) and prev_dir or vim.loop.cwd()
		--
		-- 	vim.schedule(function()
		-- 		require("oil").open(dir)
		-- 	end)
		-- end

		-- if bufname ~= "" and vim.api.nvim_buf_is_loaded(buf) then
		-- 	-- delete_empty_buffers(buf)
		-- 	vim.api.nvim_buf_delete(buf, { force = true })
		-- end
	end,
	group = vim.api.nvim_create_augroup("OilAutoOpen", { clear = true }),
})

autocmd("CursorHold", {
	buffer = 0,
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en"

		-- vim.b.cmp_enabled = false

		vim.opt_local.completefunc = ""
		vim.opt_local.omnifunc = ""
		vim.opt_local.spell = false
		vim.b.copilot_enabled = false
		-- require("blink.cmp").setup.buffer { enabled = false }

		local pairs = require("mini.pairs")
		pairs.map_buf(0, "i", "*", { action = "open", pair = "**" })
	end,
})

autocmd("BufNewFile", {
	pattern = "*.rs",
	callback = function()
		local lines = {
			"use std::cell::RefCell;",
			"use std::io::{self, Read};",
			"",
			"thread_local! {",
			"    static INPUT_ITER: RefCell<std::vec::IntoIter<Vec<u8>>> = {",
			"        let mut bytes = Vec::new();",
			"        io::stdin().lock().read_to_end(&mut bytes).unwrap();",
			"        let tokens = bytes",
			"            .split(|&b| b == b' ' || b == b'\\n')",
			"            .filter(|s| !s.is_empty())",
			"            .map(|s| s.to_vec())",
			"            .collect::<Vec<_>>();",
			"        RefCell::new(tokens.into_iter())",
			"    };",
			"}",
			"",
			"macro_rules! input {",
			"    () => {{",
			"        INPUT_ITER.with(|iter_cell| {",
			"            let mut iter = iter_cell.borrow_mut();",
			'            let token = iter.next().expect("not enough input");',
			'            let s = std::str::from_utf8(&token).expect("invalid utf-8");',
			"            s",
			"        })",
			"    }};",
			"    ($t:ty) => {{",
			"        INPUT_ITER.with(|iter_cell| {",
			"            let mut iter = iter_cell.borrow_mut();",
			'            let token = iter.next().expect("not enough input");',
			'            let s = std::str::from_utf8(&token).expect("invalid utf-8");',
			'            s.parse::<$t>().expect("parse error")',
			"        })",
			"    }};",
			"}",
			"",
			"fn main() {",
			"",
			"}",
		}
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end,
})

autocmd("BufNewFile", {
	pattern = "Makefile",
	callback = function()
		local lines = {
			"PHONY_TARGETS := git flake-develop",
			".PHONY: $(PHONY_TARGETS)",
			"",
			"all:",
			"\t@printf '%s\\n' $(PHONY_TARGETS) | fzf | xargs -r make",
			"",
			"flake-develop:",
			"\t@bash -c '\\",
			"\t\th=$$(nix hash path ./flake.nix); \\",
			'\t\tif [ "$$FLAKE_HASH" != "$$h" ]; then \\',
			"\t\t\tFLAKE_HASH=$$h exec nix develop; \\",
			"\t\t\texit 1;\\",
			"\t\telse \\",
			'\t\t\techo "FLAKE_HASH=$$FLAKE_HASH OK"; \\',
			"\t\tfi'",
			"",
			"git:",
			"\tgitui",
		}
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end,
})

autocmd("FileType", {
	pattern = { "text", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

autocmd("FileType", {
	pattern = "dart",
	callback = function()
		vim.opt_local.softtabstop = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})
