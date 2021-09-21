local sound = {}

sound.waves = {}
sound.waves[1] = love.audio.newSource("assets/waves/wave-1.wav", "static")
sound.waves[2] = love.audio.newSource("assets/waves/wave-2.wav", "static")
sound.waves[3] = love.audio.newSource("assets/waves/wave-3.wav", "static")
sound.waves[4] = love.audio.newSource("assets/waves/wave-4.wav", "static")

-- set volume for waves
for i,v in ipairs(sound.waves) do
  v:setVolume(0.3)
end

sound.wave_timer = 0
sound.wave_timer_min = 2
sound.wave_timer_max = 8
sound.wave_timer_current = math.random(sound.wave_timer_min, sound.wave_timer_max)

function sound.load()

end


function sound.update(dt)
  sound.wave_timer = sound.wave_timer + dt

  if sound.wave_timer >= sound.wave_timer_current then
    sound.wave_timer = 0
    sound.wave_timer_current = math.random(sound.wave_timer_min, sound.wave_timer_max)

    local which = math.random(1, 4)

    sound.waves[which]:play()
  end
end


function sound.draw()

end


function sound.keypressed(key)

end


function sound.keyreleased(key)

end


return sound
