local M = {}

---plugin init
---@class opt
---@field timeout integer timeout for ending
---@param opts opt
function M.setup(opts)
	opts = opts or {}

	---@type integer timeout
	local timeout = opts.timeout or (60 * 1000)

	---@type boolean check plugin status
	local isActive = true

	local timer = vim.uv.new_timer()
	local function clock()
		if timer ~= nil then
			timer:stop()
			timer:start(timeout, 0, function()
				vim.notify("timeout", vim.log.levels.ERROR)
				isActive = false
			end)
		end
	end
	vim.api.nvim_create_user_command("DangerStart", function()
		clock()
		vim.api.nvim_buf_attach(0, false, {
			on_lines = function()
				if isActive then
					clock()
				end
			end,
		})
	end, {})

	vim.api.nvim_create_user_command("DangerStop", function()
		if timer ~= nil then
			timer:stop()
			isActive = false
			vim.notify("DangerStop", vim.log.levels.INFO)
		end
	end, {})
end

return M
