-- source:
-- https://gitlab.com/bloxiebird/linux-awesomewm-modular-starter-kit/

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
local home = os.getenv("HOME")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(home .. "/.config/awesome/themes/mine/theme.lua")

-- Init all modules (You can add/remove active modules here)
require("modules.auto-start")
require("modules.sloppy-focus")
require("modules.set-wallpaper")

-- Setup UI Elements
require('ui')

-- Setup all configurations
require('configuration.tags')
require('configuration.client')
require('configuration.init')
_G.root.keys(require('configuration.keys.global'))
_G.root.buttons(require('configuration.mouse.desktop'))

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- my settings

globalkeys = gears.table.join()

-- Other keybindings...
local modkey = require('configuration.keys.mod').modKey
-- Switch all screens to tag 1
awful.key({ modkey }, "2", function()
    for s in awful.screen do
      local tag = s.tags[2] -- Get tag 1
      if tag then
        tag:view_only()     -- View the tag on this screen
      end
    end
  end,
  { description = "view tag 2 on all screens", group = "tag" })
