-- lua/deps.lua
-- Detect missing mandatory external dependencies and offer on-demand install.
-- Mason already auto-installs the LSP servers (see plugins/mason-lspconfig.lua);
-- this covers the system-level binaries the config shells out to or relies on.

-- exe  = executable to probe
-- brew = Homebrew formula (nil if not brew-installable)
-- cmd  = explicit install argv for non-brew tools
-- label = display name (defaults to exe)
local deps = {
  { exe = "git",     brew = "git" },
  { exe = "node",    brew = "node" },     -- also provides npm (pyright/vtsls need it)
  { exe = "rg",      brew = "ripgrep" },
  { exe = "sqlite3", brew = "sqlite" },   -- sqlite.lua links libsqlite (data-viewer)
  { exe = "python3", brew = "python" },
  { exe = "ruff",    brew = "ruff" },
  { exe = "cc",      cmd = { "xcode-select", "--install" }, label = "C compiler (Xcode CLT)" },
  { exe = "zmx",     brew = "neurosnap/tap/zmx" }, -- :te terminal persistence (options.lua)
}

local function missing()
  local out = {}
  for _, d in ipairs(deps) do
    if vim.fn.executable(d.exe) == 0 then
      table.insert(out, d)
    end
  end
  return out
end

local function run(argv, label)
  vim.notify("Installing " .. label .. ": " .. table.concat(argv, " "), vim.log.levels.INFO)
  vim.fn.jobstart(argv, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify(label .. " installed.", vim.log.levels.INFO)
      else
        vim.notify(label .. " install failed (exit " .. code .. ").", vim.log.levels.ERROR)
      end
    end,
  })
end

vim.api.nvim_create_user_command("InstallDeps", function()
  local miss = missing()
  if #miss == 0 then
    vim.notify("All mandatory dependencies present.", vim.log.levels.INFO)
    return
  end

  local formulae = {}
  local specials = {}
  for _, d in ipairs(miss) do
    if d.brew then
      table.insert(formulae, d.brew)
    else
      table.insert(specials, d)
    end
  end

  if #formulae > 0 then
    if vim.fn.executable("brew") == 0 then
      vim.notify("Homebrew not found. Install it first: https://brew.sh", vim.log.levels.ERROR)
    else
      local argv = { "brew", "install" }
      vim.list_extend(argv, formulae)
      run(argv, table.concat(formulae, ", "))
    end
  end

  for _, d in ipairs(specials) do
    run(d.cmd, d.label or d.exe)
  end
end, { desc = "Install missing mandatory external dependencies" })

-- Report missing deps shortly after startup (non-blocking).
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      local miss = missing()
      if #miss == 0 then return end
      local names = {}
      for _, d in ipairs(miss) do
        table.insert(names, d.label or d.exe)
      end
      vim.notify(
        "Missing deps: " .. table.concat(names, ", ") .. "\nRun :InstallDeps to install.",
        vim.log.levels.WARN
      )
    end, 500)
  end,
})
