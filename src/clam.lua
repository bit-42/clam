local clam = {}

clam.clams = {}


function clam.load()
  clam.place_random_clam()
end


function clam.update(dt)

end


function clam.draw()

end


function clam.keypressed(key)

end


function clam.keyreleased(key)

end

function clam.place_random_clam()
  local sand_block = map.get_random_sand()

  local c = {}
  c.x = sand_block.x
  c.y = sand_block.y
  c.type = "clam"
  c.bg = "YELLOW"
  c.fg = "ORANGE"
  c.char = "c"
  c.collide = false

  map.map[c.y][c.x] = c

  table.insert(clam.clams, c)
end

function clam.collide(x, y, dir)
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

  local c = nil
  local remove = nil

  for i,v in ipairs(clam.clams) do
    if v.x == x and v.y == y then
      c = v

      -- set to remove clam
      remove = i

      -- increment score
      player.score = player.score + player.multiplier

      -- sound effect
      -- TODO

      break
    end
  end

  if c == nil then
    return false
  else
    -- remove clam
    table.remove(clam.clams, remove)
    map.remove_clam(c.x, c.y)

    clam.place_random_clam()
    worker.focus()

    return true
  end
end


return clam
