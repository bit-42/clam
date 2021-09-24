map = require("src.map")
player = require("src.player")
clam = require("src.clam")
hud = require("src.hud")
worker = require("src.worker")
sound = require("src.sound")

function distance (x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

colors = {}

colors["BLUE-D"] = {53/255, 40/255, 121/255}
colors["BLUE-L"] = {108/255, 94/255, 181/255}
colors["GREEN-D"] = {88/255, 141/255, 67/255}
colors["GREEN-L"] = {154/255, 210/255, 132/255}
colors["YELLOW"] = {238/255, 238/255, 119/255}
colors["ORANGE"] = {221/255, 136/255, 85/255}
colors["BROWN"] = {102/255, 68/255, 0}
colors["WHITE"] = {1, 1, 1}
colors["BLACK"] = {0, 0, 0}

song = love.audio.newSource("assets/calm.ogg", "stream")
song:setLooping(true)
song:play()

point = love.audio.newSource("assets/point.ogg", "static")
point:setVolume(0.2)

buy = love.audio.newSource("assets/shop.ogg", "static")
buy:setVolume(0.2)

function love.load()
  local font = love.graphics.newFont("assets/bescii.ttf", 24)
  love.graphics.setFont(font)

  map.load()
  player.load()
  clam.load()
  hud.load()
  worker.load()
end


function love.update(dt)
  map.update(dt)
  player.update(dt)
  clam.update(dt)
  worker.update(dt)
  sound.update(dt)
  hud.update(dt)
end


function love.draw()
  map.draw()
  player.draw()
  -- clam.draw()
  worker.draw()
  hud.draw()
end


function love.keypressed(key)
  player.keypressed(key)
end


function love.keyreleased(key)
  player.keyreleased(key)
  hud.keyreleased(key)
end
