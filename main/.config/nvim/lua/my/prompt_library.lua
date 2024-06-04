local openai = require 'model.providers.openai'
local gemini = require 'model.providers.gemini'

local llama2 = require 'model.format.llama2'

-- prompt helpers
local extract = require 'model.prompts.extract'
local consult = require 'model.prompts.consult'

-- utils
local util = require 'model.util'
local async = require 'model.util.async'
local prompts = require 'model.util.prompts'
local mode = require('model').mode

local function code_replace_fewshot(input, context)
  local surrounding_text = prompts.limit_before_after(context, 30)

  local content = 'The code:\n```\n'
    .. surrounding_text.before
    .. '<@@>'
    .. surrounding_text.after
    .. '\n```\n'

  if context.selection then -- we only use input if we have a visual selection
    content = content .. '\n\nExisting text at <@@>:\n```' .. input .. '```\n'
  end

  if #context.args > 0 then
    content = content .. '\nInstruction: ' .. context.args
  end

  local messages = {
    {
      role = 'user',
      content = content,
    },
  }

  return {
    instruction = 'You are an expert programmer. You are given a snippet of code which includes the symbol <@@>. Complete the correct code that should replace the <@@> symbol given the content. Only respond with the code that should replace the symbol <@@>. If you include any other code, the program will fail to compile and the user will be very sad.',
    fewshot = {
      {
        role = 'user',
        content = 'The code:\n```\nfunction greet(name) { console.log("Hello " <@@>) }\n```\n\nExisting text at <@@>: `+ nme`',
      },
      {
        role = 'assistant',
        content = '+ name',
      },
    },
    messages = messages,
  }
end

---@type table<string, Prompt>
local M = {}

M.commit = {
  provider = gemini,
  mode = mode.INSERT,
  builder = function(input, context)
    local git_diff = vim.fn.system { 'git', 'diff', '--staged' }
    if not git_diff:match '^diff' then
      error('Git error:\n' .. git_diff)
    end
    return {
      contents = {
        {
          parts = {
            {
              text = 'Write a terse commit message according to the Conventional Commits specification. Try to stay below 80 characters total. Staged git diff: ```\n'
                .. git_diff
                .. '\n```',
            },
          },
        },
      },
    }
  end,
}

M.default_llama = {
  provider = openai,
  system = 'You are a helpful assistant',
  params = {
    model = 'llama3-70b-8192',
  },
  options = {
    url = 'https://api.groq.com/openai/v1/',
    authorization = 'Bearer ' .. util.env 'GROQ_API_KEY',
  },
  mode = mode.INSERT,
  builder = function(input, context)
    return {
      messages = {
        {
          role = 'user',
          content = input,
        },
      },
    }
  end,
}

M.summarize_llama = {
  provider = openai,
  system = 'You are a helpful assistant',
  params = {
    model = 'llama3-70b-8192',
  },
  options = {
    url = 'https://api.groq.com/openai/v1/',
    authorization = 'Bearer ' .. util.env 'GROQ_API_KEY',
  },
  mode = mode.INSERT,
  builder = function(input, context)
    return {
      messages = {
        {
          role = 'user',
          content = 'Summarize the following text:\n\n' .. input,
        },
      },
    }
  end,
}

M.summarize = {
  provider = gemini,
  mode = mode.INSERT,
  builder = function(input, context)
    return {
      contents = {
        { parts = { { text = 'Summarize the following text:\n\n' .. input } } },
      },
    }
  end,
}

M.bullets = {
  provider = gemini,
  mode = mode.APPEND,
  builder = function(input, context)
    return {
      prompt = {
        text = 'Summarize in bullet points the following text:\n\n' .. input,
      },
    }
  end,
}

M.tests = {
  provider = gemini,
  mode = mode.APPEND,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = {
            {
              text = 'Implement tests for the following code:\n\n' .. input,
            },
          },
        },
      },
    }
  end,
}

M.optimize = {
  provider = gemini,
  mode = mode.REPLACE,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = {
            {
              text = 'Optimize the following code:\n\n' .. input,
            },
          },
        },
      },
    }
  end,
}

M.decompose = {
  provider = gemini,
  mode = mode.INSERT,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = {
            {
              text = 'Decompose a task into subtasks. Format your answer in bullet points. This is the task:\n\n'
                .. input,
            },
          },
        },
      },
    }
  end,
}

M.keywords = {
  provider = gemini,
  mode = mode.INSERT,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = {
            {
              text = 'Extract at most 5 main keywords from the text. Format your answer in bullet. This is the text:\n\n'
                .. input,
            },
          },
        },
      },
    }
  end,
}

M.translate_en = {
  provider = gemini,
  mode = mode.INSERT,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = {
            { text = 'Translate this into English:\n\n' .. input },
          },
        },
      },
    }
  end,
}

M.translate_fr = {
  provider = gemini,
  mode = mode.INSERT,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = {
            { text = 'Translate this into French:\n\n' .. input },
          },
        },
      },
    }
  end,
}

M.correct_en = {
  provider = gemini,
  mode = mode.REPLACE,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = {
            { text = 'Correct this to standard English:\n\n' .. input },
          },
        },
      },
    }
  end,
}

M.correct_fr = {
  provider = gemini,
  mode = mode.REPLACE,
  builder = function(input, context)
    return {
      contents = {
        {
          parts = { { text = 'Correct this to standard French:\n\n' .. input } },
        },
      },
    }
  end,
}

return M
