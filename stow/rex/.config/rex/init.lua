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

-- Cmd+K opens the s launcher (~/.config/bin/s) in a floating pane over the
-- current tab. It starts in the focused shell's cwd so its worktree list is
-- the current repo's, and targets this app when it switches sessions.
rex.action{
  name  = "launcher",
  title = "Open Project…",
  keywords = "project worktree session zoxide",
  run = function(ctx, args)
    local cwd
    if ctx.block_id ~= nil then
      local p = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
      if p ~= nil then
        local chain = { p.foreground }
        for _, a in ipairs(p.ancestors or {}) do table.insert(chain, a) end
        for _, proc in ipairs(chain) do
          if proc ~= nil and proc.cwd ~= nil then cwd = proc.cwd end
        end
      end
    end

    local command = { os.getenv("HOME") .. "/.config/bin/s" }
    if ctx.client_id ~= nil then
      command = { "env", "REX_CLIENT=" .. ctx.client_id, command[1] }
    end

    local _, err = rex.session.new_layer{
      bounds = { 0.1, 0.1, 0.8, 0.75 },
      focus  = true,
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        label   = "s",
        options = { command = command, cwd = cwd },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}

rex.bind("cmd+k", "launcher")
