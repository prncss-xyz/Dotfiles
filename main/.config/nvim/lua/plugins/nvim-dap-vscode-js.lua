local M = {}

function M.config()
  require('dap-vscode-js').setup {
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    adapters = {
      'pwa-node',
      'pwa-chrome',
      'pwa-msedge',
      'node-terminal',
      'pwa-extensionHost',
    }, -- which adapters to register in nvim-dap
  }
end

return M
