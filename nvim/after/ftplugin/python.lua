local status_ok, dap_python = pcall(require, "dap-python")
if not status_ok then
  return
end

dap_python.setup("uv")
