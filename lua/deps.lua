-- lua/deps.lua
-- Detect missing mandatory external dependencies and offer on-demand install.
-- Mason already auto-installs the LSP servers (see plugins/mason-lspconfig.lua);
-- this covers the system-level binaries the config shells out to or relies on.
--
-- Package manager: Homebrew or apt, whichever is on PATH (checked, not
-- OS-sniffed, so WSL Ubuntu with apt-get just works).

-- exe  = executable to probe
-- brew = Homebrew formula (nil if not brew-installable)
-- apt  = apt package (nil if not apt-installable)
-- cmd  = explicit install argv (mac-only fallback, e.g. xcode-select)
-- note = shown when there's no known auto-install for the current pm
-- label = display name (defaults to exe)
local deps = {
  { exe = "git",     brew = "git",     apt = "git" },
  { exe = "node",    brew = "node",    apt = "nodejs" },  -- npm: bundled w/ brew node; apt may need a separate "npm" package
  { exe = "rg",      brew = "ripgrep", apt = "ripgrep" },
  { exe = "sqlite3", brew = "sqlite",  apt = "sqlite3" }, -- sqlite.lua links libsqlite (data-viewer)
  { exe = "python3", brew = "python",  apt = "python3" },
  { exe = "ruff",    brew = "ruff",    note = "no apt package; see https://docs.astral.sh/ruff/installation/" },
  { exe = "cc",      cmd = { "xcode-select", "--install" }, apt = "build-essential",
    label = "C compiler (Xcode CLT / build-essential)" },
  { exe = "zmx",     brew = "neurosnap/tap/zmx",
    note = "no apt package; see https://github.com/neurosnap/zmx#installation" }, -- :te terminal persistence (options.lua)
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

-- Homebrew or apt-get, whichever is on PATH.
local function package_manager()
  if vim.fn.executable("brew") == 1 then
    return "brew"
  elseif vim.fn.executable("apt-get") == 1 then
    return "apt"
  end
  return nil
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

-- apt needs sudo, which needs a real tty for the password prompt, so this
-- runs in a terminal split instead of a background jobstart like brew does.
local function run_apt(pkgs)
  vim.cmd("botright split | terminal sudo apt-get install -y " .. table.concat(pkgs, " "))
end

vim.api.nvim_create_user_command("InstallDeps", function()
  local miss = missing()
  if #miss == 0 then
    vim.notify("All mandatory dependencies present.", vim.log.levels.INFO)
    return
  end

  local pm = package_manager()
  local pkgs = {}
  local customs = {}
  local manual = {}

  for _, d in ipairs(miss) do
    local pkg = pm == "brew" and d.brew or (pm == "apt" and d.apt)
    if pkg then
      table.insert(pkgs, pkg)
    elseif d.cmd and pm == "brew" then
      table.insert(customs, d)
    else
      table.insert(manual, d)
    end
  end

  if pm == nil then
    vim.notify("No supported package manager found (brew or apt-get).", vim.log.levels.ERROR)
  elseif #pkgs > 0 then
    if pm == "brew" then
      local argv = { "brew", "install" }
      vim.list_extend(argv, pkgs)
      run(argv, table.concat(pkgs, ", "))
    else
      run_apt(pkgs)
    end
  end

  for _, d in ipairs(customs) do
    run(d.cmd, d.label or d.exe)
  end

  if #manual > 0 then
    local lines = {}
    for _, d in ipairs(manual) do
      table.insert(lines, (d.label or d.exe) .. (d.note and (": " .. d.note) or ""))
    end
    vim.notify("No auto-install available for:\n" .. table.concat(lines, "\n"), vim.log.levels.WARN)
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
