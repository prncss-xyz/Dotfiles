local M = {}

function M.delete()
  local bufnr = vim.api.nvim_get_current_buf()
  local bt = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  if bt ~= '' then
    return
  end
  require('bufdelete').bufdelete(0, true)
end

function M.edit_most_recent_file()
  require('plenary').job
    :new({
      command = 'sh',
      args = {
        '-c',
        [[fd . -t f -x stat -f "%m %N" | sort -rn | head -1 | cut -f2- -d" "]],
      },
      on_exit = function(j, _)
        local filename = j:result()[1]
        if filename then
          vim.defer_fn(function()
            vim.cmd.edit(filename)
          end, 0)
        end
      end,
    })
    :start()
end

function M.toggle()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local jumplist = unpack(vim.fn.getjumplist())
  local rank = 1
  while true do
    rank = rank + 1
    local jump = jumplist[rank]
    if not jump then
      return
    end
    local bufnr = jumplist[rank].bufnr
    if bufnr ~= current_bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_set_current_buf(bufnr)
      return
    end
  end
end

function M.project_files()
  local ok = pcall(require('telescope.builtin').git_files)
  if ok then
    return
  end
  require('telescope.builtin').find_files()
end

return M
