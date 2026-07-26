local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function indent(level)
    level = level or 1
    local unit = vim.o.expandtab
        and string.rep(" ", vim.o.shiftwidth)
        or "\t"

    return unit:rep(level)
end

return {
    s("template-with-main", {
        t("if __name__ == '__main__':"),
        t({ "", indent() }),
        i(1),
    }),
}
