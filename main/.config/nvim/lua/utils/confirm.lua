local M = {}

function M.confirm(message, cb, needs_confirm)
	if needs_confirm then
		vim.ui.input({ prompt = message }, function(res)
			if res == "y" then
				cb()
			end
		end)
	else
		cb()
	end
end

return M
