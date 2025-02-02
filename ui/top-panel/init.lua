local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

configuration = require('configuration.config')
require('widgets.top-panel')

local TopPanel = function(s)
  -- Wiboxes are much more flexible than wibars simply for the fact that there are no defaults, however if you'd rather have the ease of a wibar you can replace this with the original wibar code
  local panel =
      wibox(
        {
          ontop = true,
          screen = s,
          height = configuration.toppanel_height,
          width = s.geometry.width,
          x = s.geometry.x,
          y = s.geometry.y,
          stretch = false,
          bg = beautiful.background,
          fg = beautiful.fg_normal,
          struts = {
            top = configuration.toppanel_height
          }
        }
      )

  panel:struts(
    {
      top = configuration.toppanel_height
    }
  )
  --

  panel:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      -- mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    {             -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      volume_widget {
        widget_type = 'arc'
      },
      wibox.widget.systray(),
      mytextclock,
      s.mylayoutbox,
    },
  }


  return panel
end

return TopPanel
