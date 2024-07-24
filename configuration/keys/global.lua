local awful = require('awful')
local gears = require("gears")
local menubar = require("menubar")

require('awful.autofocus')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local altrkey = require('configuration.keys.mod').altRKey
local tabkey = require('configuration.keys.mod').tabKey
local controlkey = require('configuration.keys.mod').ctrlKey
local apps = require('configuration.apps')
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")

local function switch_to_tag(tag)
  return function()
    local screen = awful.screen.focused()
    local tag_index = tonumber(tag)
    if tag_index and screen.tags[tag_index] then
      screen.tags[tag_index]:view_only()
    end
  end
end

-- {{{ Key bindings
globalKeys = gears.table.join(
  awful.key({ modkey, }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),

  awful.key({ modkey, }, "Left", awful.tag.viewprev,
    { description = "view previous", group = "tag" }),
  awful.key({ modkey, }, "Right", awful.tag.viewnext,
    { description = "view next", group = "tag" }),

  -- Open rofi launcher
  awful.key({ 'Mod1' }, "o", function() awful.spawn('rofi -show drun -show-icons') end,
    { description = "open rofi", group = "launcher" }),

  -- Logout
  awful.key({ modkey }, "End", function() logout_popup.launch() end,
    { description = "Show logout screen", group = "custom" }),

  -- Change brightness
  awful.key({}, "XF86MonBrightnessUp", function() awful.spawn('brightnessctl set +10%') end),
  awful.key({}, "XF86MonBrightnessDown", function() awful.spawn('brightnessctl set 10%-') end),

  -- Brightness Toggle
  awful.key({ controlkey }, "F1", function()
      awful.spawn.spawn("brightnessctl set 0%")
    end,
    { description = "Min ThinkPad brightness", group = "scripts" }),

  awful.key({ controlkey }, "F2", function()
      awful.spawn.spawn("brightnessctl set 100%")
    end,
    { description = "max ThinkPad brightness", group = "scripts" }),

  -- Change volume
  awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ +10%') end),
  awful.key({}, "XF86AudioLowerVolume", function() awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ -10%') end),
  awful.key({}, "XF86AudioMute", function() awful.spawn('pamixer --toggle-mute') end),

  -- Change default sink
  awful.key({ modkey }, "#87", function()
      awful.spawn.with_shell("pactl set-default-sink alsa_output.pci-0000_00_03.0.hdmi-stereo")
    end,
    { description = "select hdmi as sink", group = "scripts" }),
  --
  awful.key({ modkey }, "#88", function()
      awful.spawn.with_shell("pactl set-default-sink bluez_output.60_C5_E6_42_F0_88.1")
    end,
    { description = "select headphones as sink", group = "scripts" }),
  awful.key({ modkey }, "#89", function()
      awful.spawn.with_shell("bluetoothctl connect 60:C5:E6:42:F0:88")
    end,
    { description = "connect to headphones", group = "scripts" }),

  awful.key({ modkey }, "7", switch_to_tag("1"),
    { description = "Switch to tag 1", group = "tag" }),
  awful.key({ modkey }, "8", switch_to_tag("2"),
    { description = "Switch to tag 2", group = "tag" }),
  awful.key({ modkey }, "9", switch_to_tag("3"),
    { description = "Switch to tag 3", group = "tag" }),
  awful.key({ modkey }, "0", switch_to_tag("4"),
    { description = "Switch to tag 4", group = "tag" }),
  awful.key({ modkey }, "-", switch_to_tag("5"),
    { description = "Switch to tag 5", group = "tag" }),

  -- Switch to tag on all screens

  awful.key({ modkey }, "1",
    function()
      for s in screen do
        local tag = screen[s].tags[1]
        if tag then
          tag:view_only()
        end
      end
    end,
    { description = "view tag #1 on all screens", group = "tag" }),

  awful.key({ modkey }, "2",
    function()
      for s in screen do
        local tag = screen[s].tags[2]
        if tag then
          tag:view_only()
        end
      end
    end,
    { description = "view tag #2 on all screens", group = "tag" }),

  awful.key({ modkey }, "3",
    function()
      for s in screen do
        local tag = screen[s].tags[3]
        if tag then
          tag:view_only()
        end
      end
    end,
    { description = "view tag #3 on all screens", group = "tag" }),

  awful.key({ modkey }, "4",
    function()
      for s in screen do
        local tag = screen[s].tags[4]
        if tag then
          tag:view_only()
        end
      end
    end,
    { description = "view tag #4 on all screens", group = "tag" }),

  awful.key({ modkey }, "5",
    function()
      for s in screen do
        local tag = screen[s].tags[5]
        if tag then
          tag:view_only()
        end
      end
    end,
    { description = "view tag #5 on all screens", group = "tag" }),

  awful.key({ modkey, "Shift" }, "Left",
    function()
      -- get current tag
      local t = client.focus and client.focus.first_tag or nil
      if t == nil then
        return
      end
      -- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
      local tag = client.focus.screen.tags[(t.index - 2) % 9 + 1]
      awful.client.movetotag(tag)
      awful.tag.viewprev()
    end,
    { description = "move client to previous tag and switch to it", group = "tag" }),
  awful.key({ modkey, "Shift" }, "Right",
    function()
      -- get current tag
      local t = client.focus and client.focus.first_tag or nil
      if t == nil then
        return
      end
      -- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
      local tag = client.focus.screen.tags[(t.index % 9) + 1]
      awful.client.movetotag(tag)
      awful.tag.viewnext()
    end,
    { description = "move client to next tag and switch to it", group = "tag" }),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag" }),

  awful.key({ altkey, }, tabkey,
    function()
      awful.client.focus.byidx(1)
    end,
    { description = "focus next by index", group = "client" }
  ),
  awful.key({ altkey, }, "`",
    function()
      awful.client.focus.byidx(-1)
    end,
    { description = "focus previous by index", group = "client" }
  ),
  -- awful.key({ modkey, }, "w", function() mymainmenu:show() end,
  --   { description = "show main menu", group = "awesome" }),

  -- Layout manipulation
  -- awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
  --   { description = "swap with next client by index", group = "client" }),
  -- awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
  --   { description = "swap with previous client by index", group = "client" }),
  awful.key({ altkey, controlkey }, "l", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  awful.key({ altkey, controlkey }, "h", function() awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey, }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client" }),

  -- Standard program
  awful.key({ modkey, }, "Return", function() awful.spawn(apps.terminal) end,
    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, }, "b", function() awful.spawn("brave") end,
    { description = "open brave", group = "launcher" }),
  awful.key({ modkey, }, "h", function() awful.spawn("chromium") end,
    { description = "open chromium", group = "launcher" }),
  awful.key({ modkey, }, "e", function() awful.spawn("thunar") end,
    { description = "open thunar", group = "launcher" }),

  awful.key({ modkey, "Control" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),

  awful.key({ modkey, controlkey }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
    { description = "select next", group = "layout" }),
  awful.key({ modkey, altkey }, "space", function() awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }),

  awful.key({ modkey, "Control" }, "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", { raise = true }
        )
      end
    end,
    { description = "restore minimized", group = "client" }),

  -- Prompt
  awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
    { description = "run prompt", group = "launcher" }),

  awful.key({ modkey }, "x",
    function()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    { description = "lua execute prompt", group = "awesome" }),
  -- Menubar
  awful.key({ modkey }, "d", function() menubar.show() end,
    { description = "show the menubar", group = "launcher" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
  local descr_view, descr_toggle, descr_move, descr_toggle_focus
  if i == 1 or i == 9 then
    descr_view = { description = 'view tag #', group = 'tag' }
    descr_toggle = { description = 'toggle tag #', group = 'tag' }
    descr_move = { description = 'move focused client to tag #', group = 'tag' }
    descr_toggle_focus = { description = 'toggle focused client on tag #', group = 'tag' }
  end
  globalKeys =
      awful.util.table.join(
        globalKeys,
        -- View tag only.
        awful.key(
          { modkey },
          '#' .. i + 9,
          function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
              tag:view_only()
            end
          end,
          descr_view
        ),
        -- Toggle tag display.
        awful.key(
          { modkey, 'Control' },
          '#' .. i + 9,
          function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
              awful.tag.viewtoggle(tag)
            end
          end,
          descr_toggle
        ),
        -- Move client to tag.
        awful.key(
          { modkey, 'Shift' },
          '#' .. i + 9,
          function()
            if _G.client.focus then
              local tag = _G.client.focus.screen.tags[i]
              if tag then
                _G.client.focus:move_to_tag(tag)
              end
            end
          end,
          descr_move
        ),
        -- Toggle tag on focused client.
        awful.key(
          { modkey, 'Control', 'Shift' },
          '#' .. i + 9,
          function()
            if _G.client.focus then
              local tag = _G.client.focus.screen.tags[i]
              if tag then
                _G.client.focus:toggle_tag(tag)
              end
            end
          end,
          descr_toggle_focus
        )
      )
end

return globalKeys
