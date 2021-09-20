local worker = {}

worker.workers = {}

worker.timer = 0
worker.timer_max = 0.5

worker.bg = "BLACK"
worker.fg = "WHITE"
worker.char = "*"

function worker.add_worker()
  local w = {}
  w.x = 20
  w.y = 10
  w.focus = 1 -- focus on first clam in list

  table.insert(worker.workers, w)
end

function worker.focus()
  for i,v in ipairs(worker.workers) do
    v.focus = i
  end
end

function worker.load()

end


function worker.update(dt)
  worker.timer = worker.timer + dt

  if worker.timer >= worker.timer_max then
    worker.timer = 0

    -- move workers
    for i,v in ipairs(worker.workers) do
      local focus = clam.clams[v.focus]

      if focus then

        local old_x = v.x
        local old_y = v.y

        if v.x < focus.x then
          v.x = v.x + 1
        elseif v.x > focus.x then
          v.x = v.x - 1
        end

        if v.y < focus.y then
          v.y = v.y + 1
        elseif v.y > focus.y then
          v.y = v.y - 1
        end

        for ii,vv in ipairs(worker.workers) do
          if ii ~= i then
            if v.x == vv.x and v.y == vv.y then
              -- cant move here cuz other robot is here
              v.x = old_x
              v.y = old_y
            end
          end
        end

        -- handle potential collisions
        if clam.collide(v.x, v.y, "NONE") then point:play() end

      end

    end

  end
end


function worker.draw()
  for i,v in ipairs(worker.workers) do
    -- draw worker

    r, g, b = unpack(colors[worker.bg])
    love.graphics.setColor(r, g, b, map.back)
    love.graphics.rectangle("fill", v.x*24-24, v.y*24-24, 24, 24)

    r, g, b = unpack(colors[worker.fg])
    love.graphics.setColor(r, g, b, map.back)
    love.graphics.print(worker.char, v.x*24-24, v.y*24-24)
  end
end


function worker.keypressed(key)

end


function worker.keyreleased(key)

end


return worker
