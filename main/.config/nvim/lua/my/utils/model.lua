local M = {}

local util = require 'model.util'
local scopes = require 'model.core.scopes'
local provider = require 'model.core.provider'
local input = require 'model.core.input'
local model = require 'model'
local chat = require 'model.core.chat'

-- "model.core.scopes" >>>
local function get_global_user()
  return require('model.core.scopes').user
end

local function get_global_plugin()
  return require('model.core.scopes').plugin
end

local function get_buffer_user(nr)
  return vim.b[nr or 0].model_prompts_user or {}
end

local function get_buffer_plugin(nr)
  return vim.b[nr or 0].model_prompts_plugin or {}
end

local function plugin_prompt_names(plugin_prompts)
  local names = {}
  for plugin, prompts in pairs(plugin_prompts) do
    for prompt in pairs(prompts) do
      table.insert(names, namespace_prompt_plugin(prompt, plugin))
    end
  end
  return names
end

---Gets all prompt names available in the current buffer
---@return string[] names prompt names, plugins are namespaced
local function get_prompt_names()
  local global_user = {}
  for name in util.module.autopairs(get_global_user()) do
    table.insert(global_user, name)
  end

  -- FIXME these can shadow
  return vim.tbl_map(
    function(name)
      return name:gsub(' ', '\\ ')
    end,
    vim.tbl_flatten {
      vim.tbl_keys(get_buffer_user()),
      global_user,
      plugin_prompt_names(get_buffer_plugin()),
      plugin_prompt_names(get_global_plugin()),
    }
  )
end
-- <<< "model.core.scopes"

local function run_prompt(prompt_name, wants_visual_selection)
  local prompt = scopes.get_prompt(prompt_name)
  provider.request_completion(prompt, {}, wants_visual_selection)
end

local function get_chats()
  local chats = model.opts.chats
  if chats == nil then
    return {}
  end

  local chat_names = {}

  for name in util.module.autopairs(chats) do
    local name_ = name:gsub(' ', '\\ ')
    table.insert(chat_names, name_)
  end

  return chat_names
end

local function is_buffer_empty_and_unnamed()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local buffer_name = vim.api.nvim_buf_get_name(0)
  return #lines == 1 and lines[1] == '' and buffer_name == ''
end

local function create_buffer(text)
  if not is_buffer_empty_and_unnamed() then
    vim.cmd.vnew()
  end

  vim.o.ft = 'mchat'
  vim.cmd.syntax { 'sync', 'fromstart' }

  local lines = vim.fn.split(text, '\n')
  ---@cast lines string[]

  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end

local function run_chat(chat_name, wants_visual_selection)
  local args = ''

  local chat_prompt = assert(
    vim.tbl_get(model.opts, 'chats', chat_name),
    'Chat prompt "' .. chat_name .. '" not found in setup({chats = {..}})'
  )

  local input_context =
    input.get_input_context(input.get_source(wants_visual_selection), args)

  if vim.o.ft == 'mchat' then
    -- copy current messages to a new built buffer with target settings

    local current = chat.parse(vim.api.nvim_buf_get_lines(0, 0, -1, false))

    local target = chat.build_contents(chat_prompt, input_context)

    if args == '-' then -- if args is `-`, use the current system instruction
      target.config.system = current.contents.config.system
    elseif args ~= '' then -- if args is not empty, use that as system instruction
      target.config.system = args
    end

    create_buffer(chat.to_string({
      config = target.config,
      messages = current.contents.messages,
    }, chat_name))
  else
    local chat_contents = chat.build_contents(chat_prompt, input_context)
    if args ~= '' then
      chat_contents.config.system = args
    end

    create_buffer(chat.to_string(chat_contents, chat_name))
  end
end

function M.all(wants_visual_selection)
  local prompts = get_prompt_names()
  local chats = get_chats()
  local choices = (vim.iter { prompts, chats }):flatten():totable()
  vim.ui.select(choices, {}, function(choice)
    if not choice then
      return
    end
    if vim.tbl_contains(prompts, choice) then
      run_prompt(choice, wants_visual_selection)
      return
    end
    if vim.tbl_contains(chats, choice) then
      run_chat(choice, wants_visual_selection)
      return
    end
    assert(false, 'error!')
  end)
end

return M
