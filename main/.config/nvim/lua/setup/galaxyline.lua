local gl = require("galaxyline")
local gls = gl.section
gl.short_line_list = {"LuaTree", "vista", "dbui", "goyo"}

local vim, lsp, api = vim, vim.lsp, vim.api

-- get current file name
local function modified()
  local file = vim.fn.expand("%:t")
  if vim.fn.empty(file) == 1 then
    return ""
  end
  if vim.bo.modifiable then
    if vim.bo.modified then
      return " "
    end
  end
  return ""
end
--border color 8
local warn = vim.g.terminal_color_3
local error = vim.g.terminal_color_1
local background = vim.g.terminal_color_4
local background2 = vim.g.terminal_color_6
local backgroundGoyo = vim.g.terminal_color_10
local text = vim.g.terminal_color_7

local separator = ""

local function get_nvim_lsp_diagnostic(diag_type)
  if next(lsp.buf_get_clients(0)) == nil then
    return false
  end
  local active_clients = lsp.get_active_clients()

  if active_clients then
    for _, client in ipairs(active_clients) do
      if lsp.diagnostic.get_count(api.nvim_get_current_buf(), diag_type, client.id) > 0 then
        return true
      end
    end
  end
  return false
end

local function diagnostic_errors()
  if get_nvim_lsp_diagnostic("Error") then
    return " "
  end
  return ""
end

local function diagnostic_warnings()
  if get_nvim_lsp_diagnostic("Warning") then
    return " "
  end
  return ""
end

local function readonly()
  if vim.bo.filetype == "help" then
    return ""
  end
  if vim.bo.readonly == true then
    return " "
  end
  return ""
end

local function get_current_file_name()
  local file = vim.fn.expand("%:t")
  if vim.fn.empty(file) == 1 then
    return " "
  end
  return file .. " "
end

local function lift(val)
  return function()
    return val
  end
end

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

local function current_line_tenth()
  local current_line = vim.fn.line(".")
  local total_line = vim.fn.line("$")
  if current_line == 1 then
    return "⊤ "
  elseif current_line == vim.fn.line("$") then
    return "⊥ "
  end
  local result = math.floor((current_line / total_line) * 10)
  return result .. " "
end

local function pwd()
  return vim.api.nvim_eval("b:pwd") .. " "
  --return vim.bo.pwd
end

gls.left = {
  {
    Spacer2 = {
      provider = lift " ",
      highlight = {text, background2}
    }
  },
  {
    BufferIcon = {
      provider = "BufferIcon",
      separarator_highlight = {text, background2},
      highlight = {text, background2}
    }
  },
  {
    FileIcon = {
      provider = "FileIcon",
      separarator_highlight = {text, background2},
      highlight = {text, background2}
    }
  },
  {
    FileName = {
      provider = function()
        return vim.api.nvim_eval("@%") .. " "
      end,
      separator = separator,
      separator_highlight = {background, background2},
      highlight = {text, background2}
    }
  },
  {
    Spacer3 = {
      provider = lift " ",
      highlight = {text, background}
    }
  },
  {
    Readonly = {
      provider = readonly,
      highlight = {text, background}
    }
  },
  {
    Modified = {
      provider = modified,
      highlight = {text, background}
    }
  },
  {
    DiagnosticError = {
      provider = diagnostic_errors,
      highlight = {error, background}
    }
  },
  {
    DiagnosticWarn = {
      provider = diagnostic_warnings,
      highlight = {warn, background}
    }
  }
}

gls.right = {
  --  {
  --    Pwd = {
  --      provider = pwd,
  --      highlight = {text, background}
  --    }
  --  },
  {
    Spacer4 = {
      separator = separator,
      provider = lift "",
      separator_highlight = {background2, background},
      highlight = {text, background2}
    }
  },
  {
    LineInfo = {
      provider = "LineColumn",
      separator = " ",
      separator_highlight = {background, background2},
      highlight = {text, background2}
    }
  },
  {
    Teenth = {
      provider = current_line_tenth,
      separator = " ",
      separator_highlight = {background, background2},
      highlight = {text, background2}
    }
  }
}

gls.short_line_left = {
  {
    Spacer2B = {
      provider = lift " ",
      highlight = {text, background}
    }
  },
  {
    FileIconB = {
      provider = lift "   ",
      separarator_highlight = {text, background},
      highlight = {text, background}
    }
  },
  {
    FileNameB = {
      provider = function()
        return vim.api.nvim_eval("@%") .. " "
      end,
      separator = " ",
      separator_highlight = {background, background},
      highlight = {text, background}
    }
  },
  {
    Spacer3B = {
      provider = lift " ",
      highlight = {text, background}
    }
  },
  {
    ReadonlyB = {
      provider = readonly,
      highlight = {text, background}
    }
  },
  {
    ModifiedB = {
      provider = modified,
      highlight = {text, background}
    }
  },
  {
    DiagnosticErrorB = {
      provider = diagnostic_errors,
      highlight = {error, background}
    }
  },
  {
    DiagnosticWarnB = {
      provider = diagnostic_warnings,
      highlight = {warn, background}
    }
  }
}

gls.short_line_right = {
  {
    TeenthB = {
      provider = current_line_tenth,
      separator = " ",
      separator_highlight = {background, background},
      highlight = {text, background}
    }
  }
}
local zen = {}

zen.left = {
  {
    Spacer2C = {
      provider = lift " ",
      highlight = {text, backgroundGoyo}
    }
  },
  {
    FileNameC = {
      provider = function()
        return vim.fn.expand("%:t") .. " "
      end,
      highlight = {text, backgroundGoyo}
    }
  },
  {
    DiagnosticErrorC = {
      provider = diagnostic_errors,
      highlight = {text, backgroundGoyo}
    }
  },
  {
    DiagnosticWarnC = {
      provider = diagnostic_warnings,
      highlight = {text, backgroundGoyo}
    }
  }
}
zen.right = {
  {
    TeenthC = {
      provider = current_line_tenth,
      highlight = {text, backgroundGoyo}
    }
  }
}

return zen
