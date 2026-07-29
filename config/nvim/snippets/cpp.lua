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
    s("template-comp-prog", {
      t({
        "#include <bits/stdc++.h>",
        "",
        "using namespace std;",
        "",
        "int main() {",
        indent(1) .. "ios::sync_with_stdio(false);",
        indent(1) .. "cin.tie(nullptr);",
        "",
        indent(1), -- this creates a blank line after cin.tie
      }),
      i(1, ""), -- now cursor is on the line after that blank line (so two lines down from cin.tie)
      t({
          "",
          "",
        indent(1) .. "return 0;",
        "}",
      }),
    })
}
