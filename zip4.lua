game:GetService("RunService").Heartbeat:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local currentSpeed = humanoid.WalkSpeed
        
        -- Если скорость отличается от 13, фиксируем
        if currentSpeed ~= 13 then
            humanoid.WalkSpeed = math.random(12, 14)
        end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local currentJump = humanoid.JumpPower
        
        if currentJump > 40 then
            humanoid.JumpPower = math.random(45, 49)
        elseif currentJump < 10 then
            humanoid.JumpPower = 45
        end
    end
end)

-- Туман (выносим из Heartbeat)
local lighting = game:GetService("Lighting")
lighting.FogStart = 0
lighting.FogEnd = 50
lighting.FogColor = Color3.new(0, 0, 0)

-- Замедление ВСЕЙ музыки в игре в 3 раза
for _, sound in pairs(game:GetDescendants()) do
    if sound:IsA("Sound") then
        sound.PlaybackSpeed = 1/3  -- В 3 раза медленнее
    end
end

-- Отслеживаем новые звуки
game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Sound") then
        task.wait()  -- Даем звуку загрузиться
        descendant.PlaybackSpeed = 1/3
    end
end)

-- Или для конкретного звука
local workspaceMusic = workspace:FindFirstChildOfClass("Sound")
if workspaceMusic then
    workspaceMusic.PlaybackSpeed = 1/3
end


local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Удаляем все анимации при спавне персонажа
local function removeAnimations(character)
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Удаляем все треки анимаций
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
                track:Destroy()
            end
            
            -- Отключаем загрузку новых анимаций
            humanoid.AnimationPlayed:Connect(function(animationTrack)
                animationTrack:Stop()
                animationTrack:Destroy()
            end)
        end
    end
end

-- При текущем персонаже
removeAnimations(player.Character)

-- При смене персонажа
player.CharacterAdded:Connect(removeAnimations)

-- Отключаем анимации у других игроков
for _, otherPlayer in pairs(Players:GetPlayers()) do
    if otherPlayer ~= player then
        otherPlayer.CharacterAdded:Connect(removeAnimations)
        if otherPlayer.Character then
            removeAnimations(otherPlayer.Character)
        end
    end
end


game.workspace.Gravity = math.random(200, 250)
