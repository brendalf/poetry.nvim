local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local venv = require("venv-selector.venv")

local run_command = function(command)
    local output = utils.get_os_command_output(command)
    return output
end

local get_venv = function(prompt_bufnr)
    local selection = action_state.get_selected_entry(prompt_bufnr)
    return selection[1]
end

local get_venv_name = function(venv_full_path)
    local output = run_command({ "basename", venv_full_path })
    return output[1]
end

local ask_to_confirm_deletion = function()
    return vim.fn.input("Delete virtual environment? [y/n]: ")
end

local confirm_deletion = function()
    local confirmed = ask_to_confirm_deletion()

    if string.sub(string.lower(confirmed), 0, 1) == "y" then
        return true
    end

    print("Didn't delete virtual environment")
    return false
end

local delete_venv = function(prompt_bufnr)
    if not confirm_deletion() then
        return
    end

    local venv_selected = get_venv(prompt_bufnr)
    local venv_name = get_venv_name(venv_selected)

    actions.close(prompt_bufnr)

    if venv_name ~= nil then
        local output = run_command({ "poetry", "env", "remove", venv_name })
        vim.notify(output[1])
    end
end

local switch_venv = function(prompt_bufnr)
    local venv_selected = get_venv(prompt_bufnr)

    actions.close(prompt_bufnr)

    if venv_selected ~= nil then
        venv.set_venv_and_system_paths({ value = venv_selected })
        vim.env.VIRTUAL_ENV = venv_selected
    end
end

local list_venv = function(opts)
    opts = opts or {}

    local output = run_command({ "poetry", "env", "list", "--full-path" })

    pickers
        .new(opts or {}, {
            prompt_title = "Poetry Virtual Environments",
            finder = finders.new_table({
                results = output,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(_, map)
                action_set.select:replace(switch_venv)

                map("i", "<c-d>", delete_venv)
                map("n", "<c-d>", delete_venv)

                return true
            end,
        })
        :find()
end

return require("telescope").register_extension({
    exports = {
        list_venv = list_venv,
    },
})
