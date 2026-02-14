local M = {}

M.safe_buffer_close = function()
	local current = vim.api.nvim_get_current_buf()
	local buffers = vim.tbl_filter(function(b)
		return vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) ~= ""
	end, vim.api.nvim_list_bufs())

	if #buffers > 1 then
		vim.cmd("bp")
		vim.cmd("bd " .. current)
	else
		vim.cmd("enew")
	end
end

return M
