local hud = {}


hud.shop = {}

hud.message = ""
hud.message_showing = false
hud.message_timer = 0
hud.messages = {}

function hud.add_message(text, start_time, end_time)
  local msg = {}

  msg.text = text
  msg.start_time = start_time
  msg.end_time = end_time

  table.insert(hud.messages, msg)
end

function hud.add_shop(name, price, uses, key, callback)
  local item = {}
  item.name = name
  item.price = price
  item.uses = uses
  item.used = 0
  item.callback = callback
  item.key = key

  table.insert(hud.shop, item)
end


function hud.load()
  hud.add_shop("Times Two", 10, 1, "1", function() player.set_mult(2) end)
  hud.add_shop("Times Tres", 20, 1, "2", function() player.set_mult(3) end)
  hud.add_shop("Times Five", 30, 1, "3", function() player.set_mult(5) end)
  hud.add_shop("Times Ten", 40, 1, "4", function() player.set_mult(10) end)
  hud.add_shop("Times MAX", 100, 1, "5", function() player.set_mult(20) end)
  hud.add_shop("Robot", 100, 10, "6", function()
    worker.add_worker()
    clam.place_random_clam()
    worker.focus()

    for i,v in ipairs(hud.shop) do
      if v.name == "Robot" then
        v.price = v.price + 100
      end
    end
  end)

  hud.add_shop("Robot Speed", 100, 1, "7", function()
    worker.timer_max = worker.timer_max / 3

    for i,v in ipairs(hud.shop) do
      if v.name == "Robot Speed" then
        v.price = v.price + 100
      end
    end
  end)

  hud.add_shop("Sacred", 1000, 1, "8", function()
    player.sacred = true
    map.show_trophy()
  end)

  -- add first message
  hud.add_message("An island?", 0, 5)
  hud.add_message("I need to find The Clam...", 10, 15)
end


function hud.update(dt)
  -- show central messages
  hud.message_timer = hud.message_timer + dt
end


function hud.draw()
  -- draw score
  r, g, b = unpack(colors["BLACK"])
  love.graphics.setColor(r, g, b, map.back)
  love.graphics.rectangle("fill", 960-24*8, 0, 24*8, 24)

  local score = player.score
  local score_str = string.format("%08d", score)

  r, g, b = unpack(colors["WHITE"])
  love.graphics.setColor(r, g, b, map.back)
  love.graphics.print(score_str, 960-24*8, 0)

  -- draw multiplier
  local mult = player.multiplier
  local mult_s = "Mult x%s"
  local mult_str = string.format(mult_s, mult)

  r, g, b = unpack(colors["BLACK"])
  love.graphics.setColor(r, g, b, map.back)
  love.graphics.rectangle("fill", 0, 0, 24*#mult_str, 24)

  r, g, b = unpack(colors["WHITE"])
  love.graphics.setColor(r, g, b, map.back)
  love.graphics.print(mult_str, 0, 0)

  local current_x = 0
  -- show shop items
  for i,v in ipairs(hud.shop) do
    if player.score >= v.price and v.used < v.uses then
      local line = "(" .. v.key .. ")" .. v.name .. " $" .. v.price .. " "
      local width = #line * 24

      local x = current_x
      local y = 576

      current_x = current_x + width

      -- draw bg
      love.graphics.setColor(unpack(colors["BLACK"]))
      love.graphics.rectangle("fill", x, y, width, 24)


      -- draw text
      love.graphics.setColor(unpack(colors["WHITE"]))
      love.graphics.print(line, x, y)
    end
  end

  -- draw message
  for i,v in ipairs(hud.messages) do
    if hud.message_timer > v.start_time and hud.message_timer < v.end_time then
      local txt = v.text
      local w = #txt * 24

      -- draw bg
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("fill", 900/2-12-(#txt*24)/2, 600/2-12, w, 24)

      -- draw text
      love.graphics.setColor(unpack(colors["WHITE"]))
      love.graphics.print(txt,900/2-12-(#txt*24)/2, 600/2-12)
    end
  end
end


function hud.keypressed(key)

end


function hud.keyreleased(key)
  for i,v in ipairs(hud.shop) do
    if key == v.key then
      -- buy item
      if player.score >= v.price then
        if v.used < v.uses then
          v.used = v.used + 1
          player.score = player.score - v.price
          v.callback()

          -- play shop sound
          buy:stop()
          buy:play()
        end
      end
    end
  end


  -- debug
  if key == "f1" then
    map.effect = not map.effect

    if map.effect then
      map.back = 0.9
      map.front = 0.2
    else
      map.back = 1
      map.front = 1
    end
  end

  -- DEBUG
  if key == "f2" then
    player.score = 100000
  end
end


return hud
