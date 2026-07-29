-- A plugin that changes all line numbers into base-5
-- , making them easier to reach with only the left hand

local function generate_labels(max_digit, max_length)
    local labels = {}

    for len = 1, max_length do
        local function dfs(prefix, depth)
            if depth == len then
                labels[#labels + 1] = prefix
                return
            end
            for d = 1, max_digit do
                dfs(prefix .. d, depth + 1)
            end
        end
        dfs("", 0)
    end

    return labels
end

return {
	"mluders/comfy-line-numbers.nvim",
    lazy = false,
    opts = {
        labels = generate_labels(5, 3),
        up_key = "k",
        down_key = "j",

        -- Line numbers will be completely hidden for the following file/buffer types
        hidden_file_types = { "undotree" },
        hidden_buffer_types = { "nofile" },
    },
}
