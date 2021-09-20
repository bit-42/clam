local map = {}

local tick_timer = 0
local tick_timer_max = 1

map.effect = false

if map.effect then
  map.back = 0.9
  map.front = 0.2
else
  map.back = 1
  map.front = 1
end

function map.load()
  map.map = {}

  for y=1, 25 do
    if not map.map[y] then map.map[y] = {} end

    for x=1, 40 do
      local char = " "
      local bg = "BLUE-D"
      local fg = "BLUE-L"
      local type = "water"
      local collide = true

      -- determine if should place sand
      -- should place if x,y coordinates are within 10 characters of middle
      local distance = distance(x, y, 21, 13)

      if distance <= 9 then
        -- SAND
        bg = "YELLOW"
        fg = "WHITE"
        type = "sand"
        collide = false
      elseif distance <= 11 then
        local r = math.random(1, 5)

        if r < 2 then
          bg = "BLUE-D"
          fg = "BLUE-L"
          type = "water"
          collide = false
        else
          bg = "YELLOW"
          fg = "WHITE"
          type = "sand"
          collide = false
        end
      end

      local which = math.random(0, 9)

      if which > 7 then
        -- ACCENT
        char = "."
      else
        char = " "
      end

      local block = {}
      block.char = char
      block.bg = bg
      block.fg = fg
      block.type = type
      block.collide = collide
      block.x = x
      block.y = y

      map.map[y][x] = block
    end
  end

  -- make trophy
  local t = {}
  t.char = "T"
  t.bg = "BROWN"
  t.fg = "GREEN-L"
  t.type = "trophy"
  t.collide = false
  t.x = 38
  t.y = 10

  map.map[10][38] = t
end

function map.update(dt)
  tick_timer = tick_timer + dt

  if tick_timer >= tick_timer_max then
    tick_timer = 0

    for y=1, 25 do
      for x=1, 40 do
        local block = map.map[y][x]

        if block.type == "water" then
          local flicker = math.random(1, 10)

          if flicker == 1 then
            block.char = "."
          else
            block.char = " "
          end
        end
      end

    end
  end
end

function map.draw()
  -- First Layer
  for y=1, 25 do
    for x=1, 40 do
      local XX = x*24-24
      local YY = y*24-24

      local block = map.map[y][x]

      -- draw background
      r,g,b = unpack(colors[block.bg])
      a = map.back

      love.graphics.setColor(r, g, b, a)
      love.graphics.rectangle("fill", XX, YY, 24, 24)

      -- draw char

      r,g,b = unpack(colors[block.fg])
      a = map.back
      love.graphics.setColor(r, g, b, a)
      love.graphics.print(block.char, XX, YY)

    end
  end

  if map.effect then
    -- Second Layer
    for y=1, 25 do
      for x=1, 40 do
        local XX = x*24-24
        local YY = y*24-24

        local block = map.map[y][x]

        -- draw background
        r,g,b = unpack(colors[block.bg])
        a = map.front

        love.graphics.setColor(r, g, b, a)
        love.graphics.rectangle("fill", XX-3, YY+3, 24, 24)

        -- draw char

        r,g,b = unpack(colors[block.fg])
        a = map.front
        love.graphics.setColor(r, g, b, a)
        love.graphics.print(block.char, XX-3, YY+3)

      end
    end
  end

end

function map.collide(x, y, dir)
  if dir == "UP" then
    y = y - 1
  end

  if dir == "DOWN" then
    y = y + 1
  end

  if dir == "LEFT" then
    x = x - 1
  end

  if dir == "RIGHT" then
    x = x + 1
  end

  if not map.map[y] then
    return true
  end

  if not map.map[y][x] then
    return true
  end

  local block = map.map[y][x]

  if block.type == "trophy" then
    player.win = true
    player.multiplier = 100
  end

  if player.sacred then
    return false
  else
    return block.collide
  end
end

function map.get_random_sand()
  while true do
    local x = math.random(1, 40)
    local y = math.random(1, 25)

    local block = map.map[y][x]

    if block.collide == false and block.type == "sand" then
      local found = false
      for i,v in ipairs(worker.workers) do
        if x == v.x and y == v.y then
          found = true
        end
      end

      if not found then
        return block
      end
    end
  end
end

function map.remove_clam(x, y)
  local block = map.map[y][x]

  if block.type == "clam" then
    block.type = "sand"
    block.bg = "YELLOW"
    block.fg = "WHITE"
    block.char = math.random(1, 10) == 1 and "." or " "
  end
end

return map
