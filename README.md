# Poetry.nvim

A Neovim plugin to manage poetry python virtual environments.

The goal of this tool is to easily allow users to change between environments, especially when working with Git Worktrees.

## How to use

This plugin creates a command called `PoetryEnvList` that opens a telescope window with all the configured virtual environments.

- To activate just press `Enter`.
- To delete just press `<c-d>`.

## Installation

[Neovim 0.7](https://github.com/neovim/neovim/releases/tag/v0.7.0) or higher is required for `poetry.nvim` to work.

Using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  "brendalf/poetry.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "linux-cultist/venv-selector.nvim" },
  config = function()
    require("poetry").setup()
  end,
  keys = {
    {
      "<Leader>p",
      "<cmd>PoetryEnvList<CR>",
      desc = "List poetry environments",
    },
  },
}
```

The `linux-cultist/venv-selector.nvim` dependency is temporally just to reuse the activate venv function.

## Contributing

All contributions are welcome! Just open a pull request.

Please look at the [Issues](https://github.com/brendalf/poetry.nvim/issues) page to see the current backlog, suggestions, and bugs to work.

## License

Distributed under the same terms as Neovim itself.
