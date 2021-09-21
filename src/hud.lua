local hud = {}


hud.shop = {}


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
  hud.add_shop("Times Five", 50, 1, "3", function() player.set_mult(5) end)
  hud.add_shop("Times Ten", 100, 1, "4", function() player.set_mult(10) end)
  hud.add_shop("Times MAX", 500, 1, "5", function() player.set_mult(20) end)
  hud.add_shop("Robot", 100, 10, "6", function()
    worker.add_worker()
    clam.place_random_clam()
    worker.focus()

    for i,v in ipairs(hud.shop) do
      if v.name == "Robot" then
        v.price = v.price + 200
      end
    end
  end)

  hud.add_shop("Robot Speed", 200, 5, "7", function()
    worker.timer_max = worker.timer_max / 2

    for i,v in ipairs(hud.shop) do
      if v.name == "Robot Speed" then
        v.price = v.price + 200
      end
    end
  end)

  hud.add_shop("Sacred", 10000, 1, "8", function()
    player.sacred = true
    map.show_trophy()
  end)
end


function hud.update(dt)

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
end


return hud
