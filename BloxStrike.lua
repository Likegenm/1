--[[
## LocalPlayer
# Infjump
Name = InfJumps
через велосити и регулятор прыжка

# Speedhack
уведосление через StarterGui что функция не сделана тк Bypass AC не настроен на такое

# Fly
как и со спидхаком

# AntiFall
local antiFallEnabled = true
local RAY_DISTANCE = 50

game:GetService("RunService").Heartbeat:Connect(function()
    if not antiFallEnabled then return end
    
    local char = game.Players.LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local velocityY = hrp.Velocity.Y
            
            if velocityY < -20 then
                local rayOrigin = hrp.Position
                local rayDirection = Vector3.new(0, -RAY_DISTANCE, 0)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {char}
                
                local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if raycastResult then
                    local distanceToGround = (rayOrigin - raycastResult.Position).Y
                    
                    if distanceToGround > 0 and distanceToGround <= 5 then
                        antiFallEnabled = false
                        
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                        hrp.Position = Vector3.new(hrp.Position.X, raycastResult.Position.Y + 5, hrp.Position.Z)
                        
                        task.wait(0.01)
                        
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                        antiFallEnabled = true
                    end
                end
            end
        end
    end
end)

 # Spin
spawn(function()
    while true do
        game:GetService("RunService").Heartbeat:Wait()
        local char = game.Players.LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(360), 0)
            end
        end
    end
end)
и регулятор

# Noclip
game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
