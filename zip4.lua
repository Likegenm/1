game:GetService("RunService").Heartbeat:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local currentSpeed = humanoid.WalkSpeed
        
        -- Если скорость отличается от 13, фиксируем
        if currentSpeed ~= 13 then
            humanoid.WalkSpeed = 13
        end
    end
end)

-- Контроль прозрачности (исправленная версия)
game:GetService("RunService").Heartbeat:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Transparency > 0.7 then
                    part.Transparency = 0.7
                end
            end
        end
    end
end)

-- Контроль силы прыжка
game:GetService("RunService").Heartbeat:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local currentJump = humanoid.JumpPower
        
        if currentJump > 30 then
            humanoid.JumpPower = math.random(10, 30)
        elseif currentJump < 10 then
            humanoid.JumpPower = math.clamp(currentJump + 10, 10, 30)
        end
    end
end)

-- Туман (выносим из Heartbeat)
local lighting = game:GetService("Lighting")
lighting.FogStart = 0
lighting.FogEnd = 50
lighting.FogColor = Color3.new(0, 0, 0)

-- Отслеживаем изменение персонажа
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)  -- Ждем загрузки
    
    -- Сбрасываем настройки для нового персонажа
    if character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 13
        character.Humanoid.JumpPower = math.clamp(character.Humanoid.JumpPower, 10, 30)
    end
end)
