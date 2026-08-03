local filetype = vim.filetype

-- .arb is a JSON-based localization file format

filetype.add({
    extension = {
        arb = "json",
    },
})
