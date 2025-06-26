local openai = require 'model.providers.openai'
local gemini = require 'model.providers.gemini'

-- utils
local util = require 'model.util'
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

M.ask_replace = {
  provider = gemini,
  mode = mode.REPLACE,
  builder = function(input)
    vim.ui.input({ prompt = 'Instruction: ' }, function(instruction)
      return {
        contents = {
          {
            role = 'user',
            parts = {
              {
                text = string.format(
                  [[Regarding the following text, %s. Text: %s]],
                  instruction,
                  input
                ),
              },
            },
          },
        },
      }
    end)
  end,
}

M.commit = {
  provider = gemini,
  mode = mode.INSERT,

  builder = function()
    local git_diff = vim.fn.system { 'git', 'diff', '--staged' }
    if not git_diff:match '^diff' then
      error('Git error:\n' .. git_diff)
    end
    return {
      contents = {
        {
          role = 'user',
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
  builder = function(input)
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
  builder = function(input)
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
          parts = { { text = 'Summarize the following text:\n\n' .. input } },
        },
      },
    }
  end,
}

M.bullets = {
  provider = gemini,
  mode = mode.APPEND,
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
          parts = {
            {
              text = 'Summarize in bullet points. If you need to group into multiple lists, identity each list with a markdown header.\n\n Text:\n'
                .. input,
            },
          },
        },
      },
    }
  end,
}

M.tests = {
  provider = gemini,
  mode = mode.APPEND,
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
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

M.review_tmp = {
  provider = gemini,
  mode = mode.APPEND,
  builder = function(input, context)
    local selection = context.selection
    assert(selection, 'No selection')
    local first = selection.start.row
    local last = selection.stop.row
    local lines = vim.split(input, '\n')
    local res = ''
    for i, line in ipairs(lines) do
      local row = first + i - 1
      res = res .. row .. ' ' .. line
      if row < last then
        res = res .. '\n'
      end
    end

    return {
      contents = {
        {
          role = 'user',
          parts = {
            {
              text = string.format(
                [[
You must identify any readability issues in the code snippet.
Some readability issues to consider:
- Unclear naming
- Unclear purpose
- Redundant or obvious comments
- Lack of comments
- Long or complex one liners
- Too much nesting
- Long variable names
- Inconsistent naming and code style.
- Code repetition
You may identify additional problems. The user submits a small section of code from a larger file.
Only list lines with readability issues, in the format line=<num>: <issue and proposed solution>
Your commentary must fit on a single line.

Code:
04 public class Logic {
05     public static void main(String[] args) {
06         Scanner sc = new Scanner(System.in);
07         int n = sc.nextInt();
08         int[] arr = new int[n];
09         for (int i = 0; i < n; i++) {
10             arr[i] = sc.nextInt();
11         }
12         int[] dp = new int[n];
13         dp[0] = arr[0];
14         dp[1] = Math.max(arr[0], arr[1]);
15         for (int i = 2; i < n; i++) {
16             dp[i] = Math.max(dp[i - 1], dp[i - 2] + arr[i]);
17         }
18         System.out.println(dp[n - 1]);
19     }
20 }
Result:
line=4: The class name 'Logic' is too generic. A more meaningful name could be 'DynamicProgramming'
line=6: The variable name 'sc' is unclear. A more meaningful name could be 'scanner'.
line=7: The variable name 'n' is unclear. A more meaningful name could be 'arraySize' or 'numElements'.
line=8: The variable name 'arr' unclear. A more descriptive name could be 'inputArray' or 'elementValues'.
line=12: The variable name 'dp' is unclear. A more informative name could be 'maxSum' or 'optimalSolution'.
line=13: There are no comments explaining the meaning of the 'dp' array values and how they relate to the problem statement.
line=15: There are no comments explaining the logic and purpose of the for loop

Code:
673 for (let i: number = 0; i < l; i++) {
674       let notAddr: boolean = false;
675       // non standard input
676       if (items[i].scriptSig && !items[i].addr) {
677         items[i].addr = 'Unparsed address [' + u++ + ']';
678         items[i].notAddr = true;
679         notAddr = true;
680       }
681
682       // non standard output
683       if (items[i].scriptPubKey && !items[i].scriptPubKey.addresses) {
684         items[i].scriptPubKey.addresses = ['Unparsed address [' + u++ + ']'];
Result:
line=673: The variable name 'i' and 'l' are unclear and easily confused with other characters like '1'. More meaningful names could be 'index' and 'length' respectively.
line=674: The variable name 'notAddr' is unclear and a double negative. An alternative could be 'hasUnparsedAddress'.
line=676: The comment "non standard input" is not very informative. It could be more descriptive, e.g., "Check for non standard input address"
line=682: The comment "non standard output" is not very informative. It could be more descriptive, e.g., "Check for non standard output address"
line=683: The variable name 'items' might be more informative if changed to 'transactions' or 'txItems'.
line=684: The array element 'Unparsed address [' + u++ + ']' could use a more descriptive comment, e.g., "Assign a unique identifier to non standard output addresses"
line=684: The variable name 'u' is unclear. A more meaningful name could be 'unparsedAddressCount' or 'unparsedAddressId'.

Code:
%s
Result:]],
                res
              ),
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
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
  builder = function(input)
    return {
      contents = {
        {
          role = 'user',
          parts = { { text = 'Correct this to standard French:\n\n' .. input } },
        },
      },
    }
  end,
}

return M
