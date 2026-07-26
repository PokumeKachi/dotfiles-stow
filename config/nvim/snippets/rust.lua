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
    s("template-fastio", {
        t({
            "use std::cell::RefCell;",
            "use std::io::{self, Read};",
            "",
            "thread_local! {",
            indent() .. "static INPUT_ITER: RefCell<std::vec::IntoIter<Vec<u8>>> = {",
            indent(2) .. "let mut bytes = Vec::new();",
            indent(2) .. "io::stdin().lock().read_to_end(&mut bytes).unwrap();",
            indent(2) .. "let tokens = bytes",
            indent(3) .. ".split(|&b| b == b' ' || b == b'\\n')",
            indent(3) .. ".filter(|s| !s.is_empty())",
            indent(3) .. ".map(|s| s.to_vec())",
            indent(3) .. ".collect::<Vec<_>>();",
            indent(2) .. "RefCell::new(tokens.into_iter())",
            indent() .. "};",
            "}",
            "",
            "macro_rules! input {",
            indent() .. "() => {{",
            indent(2) .. "INPUT_ITER.with(|iter_cell| {",
            indent(3) .. "let mut iter = iter_cell.borrow_mut();",
            indent(3) .. 'let token = iter.next().expect("not enough input");',
            indent(3) .. 'let s = std::str::from_utf8(&token).expect("invalid utf-8");',
            indent(3) .. "s",
            indent(2) .. "})",
            indent() .. "}};",
            indent() .. "($t:ty) => {{",
            indent(2) .. "INPUT_ITER.with(|iter_cell| {",
            indent(3) .. "let mut iter = iter_cell.borrow_mut();",
            indent(3) .. 'let token = iter.next().expect("not enough input");',
            indent(3) .. 'let s = std::str::from_utf8(&token).expect("invalid utf-8");',
            indent(3) .. 's.parse::<$t>().expect("parse error")',
            indent(2) .. "})",
            indent() .. "}};",
            "}",
            "",
            "fn main() {",
            indent(),
        }),
        i(1),
        t({
            "",
            "}",
        }),
    }),
}
