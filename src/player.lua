local player = {}


function player.load()
  player.x = 20
  player.y = 13
  player.char = "@"
  player.bg = "WHITE"
  player.fg = "BLACK"
  player.score = 0
  player.multiplier = 1
  player.sacred = false
  player.win = false
  player.win_timer = 0
  player.win_sign = false

  player.moving = "none"
  player.move_timer = 0
  player.move_timer_max = 0.25
end


function player.update(dt)
  if player.win then
    player.win_timer = player.win_timer + dt

    if player.win_timer >= 0.5 then
      player.win_sign = not player.win_sign

      player.win_timer = 0
    end
  end

  -- continuous movement
  if player.moving ~= "none" then
    player.move_timer = player.move_timer + dt

    if player.move_timer >= player.move_timer_max then
      player.move(player.moving)

      player.move_timer = 0
    end
  end
end


function player.draw()
  -- first layer
  r, g, b = unpack(colors[player.bg])
  love.graphics.setColor(r, g, b, map.back)
  love.graphics.rectangle("fill", player.x*24-24, player.y*24-24, 24, 24)

  r, g, b = unpack(colors[player.fg])
  love.graphics.setColor(r, g, b, map.back)
  love.graphics.print(player.char, player.x*24-24, player.y*24-24)

  if map.effect then
    -- second layer
    r, g, b = unpack(colors[player.bg])
    love.graphics.setColor(r, g, b, map.front)
    love.graphics.rectangle("fill", player.x*24-24-3, player.y*24-24+3, 24, 24)

    r, g, b = unpack(colors[player.fg])
    love.graphics.setColor(r, g, b, map.front)
    love.graphics.print(player.char, player.x*24-24-3, player.y*24-24+3)
  end

  -- draw win notice if won
  if player.win then
    if player.win_sign then
      love.graphics.setColor(unpack(colors["WHITE"]))
      love.graphics.rectangle("fill", 15*24, 0, 10*24, 24)
      love.graphics.setColor(unpack(colors["BLACK"]))
      love.graphics.print("YOU WIN!!!", 15*24, 0)
    end
  end
end


function player.keypressed(key)
  if key == "a" then
    player.moving = "LEFT"
  end

  if key == "d" then
    player.moving = "RIGHT"
  end

  if key == "w" then
    player.moving = "UP"
  end

  if key == "s" then
    player.moving = "DOWN"
  end
end


function player.keyreleased(key)
  player.moving = "none"

  if player.move_timer > 0 then
    if key == "a" then
      player.move("LEFT")
    end

    if key == "d" then
      player.move("RIGHT")
    end

    if key == "w" then
      player.move("UP")
    end

    if key == "s" then
      player.move("DOWN")
    end
    player.move_timer = 0
  end
end


function player.move(dir)
  if map.collide(player.x, player.y, dir) then return end

  if clam.collide(player.x, player.y, dir) then point:play() end

  local old_x = player.x
  local old_y = player.y

  if dir == "UP" then
    player.y = player.y - 1
  end

  if dir == "DOWN" then
    player.y = player.y + 1
  end

  if dir == "LEFT" then
    player.x = player.x - 1
  end

  if dir == "RIGHT" then
    player.x = player.x + 1
  end
end


function player.set_mult(m)
  if m > player.multiplier then
    player.multiplier = m
  end
end


return player
