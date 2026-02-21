-- lua/core/buf_dedupe.lua
-- Strict buffer deduplication: no normal buffer appears in more than one window.
-- When a duplicate would occur, we switch focus to the existing window and restore
-- the current window to its previous buffer (or a safe alternative).

local api = vim.api
local fn = vim.fn
local aug = api.nvim_create_augroup("BufDedupeStrict", { clear = true })

-- Core state
local buf_to_win = {}      -- buffer -> canonical window
local win_to_buf = {}      -- window -> buffer currently assigned
local in_progress = {}     -- buffer -> true while being handled
local history = {}         -- circular buffer of recent events
local MAX_HISTORY = 200

-- Helper: add a message to the history ring
local function log(msg)
    table.insert(history, { time = os.time(), msg = msg })
    if #history > MAX_HISTORY then
        table.remove(history, 1)
    end
end

-- Check if a buffer/window should be excluded from deduplication
local function is_special(buf, win)
    if not api.nvim_buf_is_valid(buf) then return true end
    if win and not api.nvim_win_is_valid(win) then return true end
    if vim.bo[buf].filetype == "oil" then return true end
    if vim.bo[buf].buftype == "terminal" then return true end
    if win and vim.w[win].snacks_main == true then return true end
    return false
end

-- Clear all references to a window
local function clear_win(win)
    if not win then return end
    local buf = win_to_buf[win]
    win_to_buf[win] = nil
    if buf and buf_to_win[buf] == win then
        buf_to_win[buf] = nil
    end
end

-- Clear all references to a buffer
local function clear_buf(buf)
    if not buf then return end
    buf_to_win[buf] = nil
    for w, b in pairs(win_to_buf) do
        if b == buf then win_to_buf[w] = nil end
    end
    in_progress[buf] = nil
end

-- Set a canonical mapping between buffer and window
local function set_mapping(buf, win)
    if not (api.nvim_buf_is_valid(buf) and api.nvim_win_is_valid(win)) then
        return
    end
    -- Remove old mapping for this buffer if it existed
    local old_win = buf_to_win[buf]
    if old_win and old_win ~= win and api.nvim_win_is_valid(old_win) then
        -- The old canonical window still exists; we are moving the mapping.
        -- We'll keep the new one and let the old window get a new buffer later.
    end
    buf_to_win[buf] = win
    win_to_buf[win] = buf
end

-- Find another window that already shows this buffer (excluding current_win)
local function find_other_window_with_buffer(buf, current_win)
    for _, win in ipairs(api.nvim_list_wins()) do
        if win ~= current_win and api.nvim_win_is_valid(win) then
            if api.nvim_win_get_buf(win) == buf then
                return win
            end
        end
    end
    return nil
end

-- Find a "safe" alternative buffer for a window (prefer the window's alternate buffer,
-- otherwise any listed normal buffer, otherwise nil)
local function get_alternative_buffer(win, exclude_buf)
    -- Try the window's alternate buffer (#)
    local alt = fn.bufnr("#")
    if alt > 0 and api.nvim_buf_is_valid(alt) and vim.bo[alt].buflisted and vim.bo[alt].buftype == "" and alt ~= exclude_buf then
        return alt
    end
    -- Fallback: first listed normal buffer that is not excluded
    for _, b in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].buftype == "" and b ~= exclude_buf then
            return b
        end
    end
    return nil
end

-- Main handler: called on WinEnter / BufWinEnter
local function on_enter()
    vim.schedule(function()
        local current_win = api.nvim_get_current_win()
        if not api.nvim_win_is_valid(current_win) then return end
        local current_buf = api.nvim_get_current_buf()
        if not api.nvim_buf_is_valid(current_buf) then return end

        -- Special buffers are left untouched; just record the mapping.
        if is_special(current_buf, current_win) then
            set_mapping(current_buf, current_win)
            return
        end

        -- Avoid re-entrant handling for this buffer
        if in_progress[current_buf] then return end
        in_progress[current_buf] = true

        log(string.format("enter win=%d buf=%d", current_win, current_buf))

        -- Check if this buffer is already visible in another window
        local other_win = find_other_window_with_buffer(current_buf, current_win)
        if other_win then
            -- Duplicate detected: we want to focus the other window and restore this window
            log(string.format("duplicate buf=%d in win=%d and win=%d", current_buf, current_win, other_win))

            -- 1. Restore this window to its previous buffer (or a safe alternative)
            local alt_buf = get_alternative_buffer(current_win, current_buf)
            if alt_buf then
                local ok = pcall(api.nvim_win_set_buf, current_win, alt_buf)
                if ok then
                    set_mapping(alt_buf, current_win)
                    log(string.format("restored win=%d to alt buf=%d", current_win, alt_buf))
                else
                    log(string.format("failed to restore win=%d to alt buf=%d", current_win, alt_buf))
                end
            else
                -- No alternative buffer: open oil in this window (safe default)
                local ok, oil = pcall(require, "oil")
                if ok and oil.open then
                    pcall(api.nvim_set_current_win, current_win)
                    pcall(oil.open)
                    -- oil.open will likely create a new buffer; we'll let the next event handle mapping.
                    log(string.format("opened oil in win=%d (no alt buf)", current_win))
                else
                    -- Last resort: just keep the buffer (duplicate) but log error.
                    log(string.format("ERROR: no alt buf and oil not available, duplicate remains in win=%d", current_win))
                end
            end

            -- 2. Focus the other window that already had the buffer
            if api.nvim_win_is_valid(other_win) then
                pcall(api.nvim_set_current_win, other_win)
                log(string.format("focused win=%d (original holder of buf=%d)", other_win, current_buf))
                -- Ensure mapping for the buffer points to other_win now
                set_mapping(current_buf, other_win)
            else
                log(string.format("other_win=%d became invalid", other_win))
            end
        else
            -- No duplicate: just record this window as the canonical one for this buffer
            set_mapping(current_buf, current_win)
            log(string.format("set canonical win=%d for buf=%d", current_win, current_buf))
        end

        in_progress[current_buf] = nil
    end)
end

-- Cleanup when a window is closed
api.nvim_create_autocmd("WinClosed", {
    group = aug,
    callback = function(ev)
        local win = tonumber(ev.match)
        if not win then return end
        local buf = fn.winbufnr(win)  -- still works after close
        clear_win(win)
        if buf and buf ~= -1 then
            -- If this buffer now has no windows and is listed, delete it (optional)
            if fn.buflisted(buf) == 1 and #fn.win_findbuf(buf) == 0 then
                vim.schedule(function()
                    pcall(require("bufdelete").bufdelete, buf)
                end)
            end
            clear_buf(buf)
        end
        log(string.format("winclosed win=%d buf=%s", win, tostring(buf)))
    end,
})

-- Cleanup when a buffer is deleted
api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = aug,
    callback = function(ev)
        clear_buf(ev.buf)
        log(string.format("bufdeleted buf=%d", ev.buf))
    end,
})

-- Attach main handlers
api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = aug,
    callback = on_enter,
})

-- TabNewEntered: open oil if the new tab has an empty normal buffer
api.nvim_create_autocmd("TabNewEntered", {
    group = aug,
    callback = function()
        local buf = api.nvim_get_current_buf()
        if vim.bo[buf].buftype == "" then
            local ok, oil = pcall(require, "oil")
            if ok and oil.open then
                pcall(oil.open)
            end
        end
    end,
})

-- Terminal settings
api.nvim_create_autocmd("TermOpen", {
    group = aug,
    callback = function()
        vim.opt_local.relativenumber = true
        vim.schedule(function() pcall(api.nvim_command, "startinsert") end)
    end,
})

-- Debugging command: print current state and recent history
api.nvim_create_user_command("BufDedupeState", function()
    print("=== buf_to_win ===")
    for b, w in pairs(buf_to_win) do
        print(string.format("  buf %d -> win %d", b, w))
    end
    print("=== win_to_buf ===")
    for w, b in pairs(win_to_buf) do
        print(string.format("  win %d -> buf %d", w, b))
    end
    print("=== Recent History (last 30) ===")
    local start = math.max(1, #history - 29)
    for i = start, #history do
        local e = history[i]
        print(os.date("%H:%M:%S", e.time), e.msg)
    end
end, {})

-- Return internal tables for testing/debugging if needed
return {
    _buf_to_win = buf_to_win,
    _win_to_buf = win_to_buf,
    _history = history,
}
