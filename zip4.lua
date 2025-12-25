local maxHorizontalSpeed = 13

game:GetService("RunService").Heartbeat:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local vel = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
        local horizontalVel = Vector3.new(vel.X, 0, vel.Z)
        
        if horizontalVel.Magnitude > maxHorizontalSpeed then
            local scale = maxHorizontalSpeed / horizontalVel.Magnitude
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(
                vel.X * scale,
                vel.Y,  -- Вертикальную скорость не трогаем
                vel.Z * scale
            )
        end
    end
end)

local minHorizontalSpeed = 13

game:GetService("RunService").Heartbeat:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local vel = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
        local horizontalVel = Vector3.new(vel.X, 0, vel.Z)
        
        if horizontalVel.Magnitude < minHorizontalSpeed then
            local scale = minxHorizontalSpeed / horizontalVel.Magnitude
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(
                vel.X * scale,
                vel.Y,  
                vel.Z * scale
            )
        end
    end
end)



if 13 < game.Players.LocalPlayer.Character.Humanoid.WalkSpeed then
  while task.wait(0.1) do
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 13
  end
end

if 13 > game.Players.LocalPlayer.Character.Humanoid.WalkSpeed then
  while task.wait(0.1) do
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 13
  end
end
