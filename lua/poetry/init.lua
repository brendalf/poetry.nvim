local M = {}

M.setup = function(config)
    config = config or {}

    M._config = vim.tbl_deep_extend("force", {
        update_on_change = true,
    }, config)

    vim.api.nvim_create_user_command("PoetryEnvList", require("telescope").extensions.poetry.list_venv, {})
end

M.setup()

return M
