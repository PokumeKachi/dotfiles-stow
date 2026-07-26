local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local function indent(level)
    level = level or 1
    local unit = vim.o.expandtab and string.rep(" ", vim.o.shiftwidth) or "\t"
    return unit:rep(level)
end

local base = {
    "PHONY_TARGETS := git flake-develop",
    ".PHONY: $(PHONY_TARGETS)",
    "",
    "all:",
    indent() .. "@printf '%s\\n' $(PHONY_TARGETS) | fzf | xargs -r make",
}

return {
    s("template", { t(base) }),
}
