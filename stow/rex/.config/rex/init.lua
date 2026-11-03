-- Rex config. Stock defaults plus a few actions and key bindings.

-- Cmd+W closes the focused pane, but never the session's last pane.
rex.action{
  name  = "safe_close",
  title = "Close (Keep Session)",
  description = "Close the focused pane unless it is the last one in the session.",
  run = function(ctx, args)
    local res, err = rex.session.list_blocks{}
    if err ~= nil then error(err, 0) end
    local placed = 0
    for _, b in ipairs(res.blocks) do
      if b.placement == "placed" then placed = placed + 1 end
    end
    if placed > 1 then
      rex.client.queue("client.close")
    else
      rex.log("info", "safe_close: last pane, not closing session")
    end
  end,
}

rex.bind("cmd+w", "safe_close")

-- The focused pane's shell cwd. The shell is the outermost process with a
-- cwd, so a pane running Claude still reports where its shell sits.
local function focused_cwd(ctx)
  if ctx.block_id == nil then return nil end
  local p = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  if p == nil then return nil end
  local cwd
  local chain = { p.foreground }
  for _, a in ipairs(p.ancestors or {}) do table.insert(chain, a) end
  for _, proc in ipairs(chain) do
    if proc ~= nil and proc.cwd ~= nil then cwd = proc.cwd end
  end
  return cwd
end

-- Run command in a floating pane over the current tab, from the focused
-- pane's cwd. The pane closes when the command exits.
local function popup(ctx, label, command, bounds)
  local _, err = rex.session.new_layer{
    bounds = bounds,
    focus  = true,
    layout = rex.layout.block{
      flavor  = "com.superlogical.terminal.shell",
      label   = label,
      options = { command = command, cwd = focused_cwd(ctx) },
    },
  }
  if err ~= nil then error(err, 0) end
end

-- Cmd+K opens the s launcher (~/.config/bin/s). Starting in the focused cwd
-- makes its worktree list the current repo's, and REX_CLIENT makes it switch
-- sessions in this app.
rex.action{
  name  = "launcher",
  title = "Open Project…",
  keywords = "project worktree session zoxide",
  run = function(ctx, args)
    local command = { os.getenv("HOME") .. "/.config/bin/s" }
    if ctx.client_id ~= nil then
      command = { "env", "REX_CLIENT=" .. ctx.client_id, command[1] }
    end
    popup(ctx, "s", command, { 0.1, 0.1, 0.8, 0.75 })
  end,
}

rex.bind("cmd+k", "launcher")

-- Cmd+G opens lazygit on the focused pane's repo, as in Herdr. This replaces
-- Rex's default Cmd+G (Find Next).
rex.action{
  name  = "lazygit",
  title = "Open lazygit",
  keywords = "git",
  run = function(ctx, args)
    popup(ctx, "lazygit", { "lazygit" }, { 0.05, 0.05, 0.9, 0.9 })
  end,
}

rex.bind("cmd+g", "lazygit")
