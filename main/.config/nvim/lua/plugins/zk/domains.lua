local M = {}

local base = '/home/prncss/Personal/zk/'

local function get_domains()
  local start = base:len() + 1
  local dirs
  require('plenary').job
    :new({
      command = 'fd',
      args = { '--type', 'directory', '--absolute-path', '.', base },
      on_exit = function(j, _)
        dirs = j:result()
      end,
    })
    :sync()
  local hrefs_by_domain = {}
  for _, dir in ipairs(dirs) do
    local domain = dir:match('/([A-Z].*)/', start)
    if domain then
      hrefs_by_domain[domain] = hrefs_by_domain[domain] or {}
      table.insert(hrefs_by_domain[domain], dir:sub(start))
    end
  end
  local domains = {}
  for name, hrefs in pairs(hrefs_by_domain) do
    if hrefs[2] then
      table.insert(domains, {
        name = name,
        hrefs = hrefs,
      })
    end
  end
  return domains
end

local function format_item_domain(domain)
  return domain.name
end

function M.setup()
  require('neo-tree.sources.zk.lib.queries').domains = {
    desc = 'Domains',
    input = function(_, _, cb)
      local domains = get_domains()
      vim.ui.select(
        domains,
        { prompt = 'Domain', format_item = format_item_domain },
        function(domain)
          if domain then
            cb {
              desc = 'Domain ' .. domain.name,
              query = {
                hrefs = domain.hrefs,
              },
            }
          end
        end
      )
    end,
  }
end

return M
