local player = game.Players.LocalPlayer

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "LocalPlayer",
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab("LocalPlayer", "user"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- Speedhack Group
local SpeedGroup = Tabs.Main:AddLeftGroupbox("Speedhack")
local currentWalkspeed = 16
local speedToggle = false

SpeedGroup:AddSlider("WalkSpeedSlider", {
    Text = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    
    Callback = function(Value)
        currentWalkspeed = Value
        if speedToggle and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

SpeedGroup:AddToggle("AutoSpeedToggle", {
    Text = "Auto Apply Speed",
    Default = false,
    
    Callback = function(Value)
        speedToggle = Value
        if Value then
            local connection
            connection = game:GetService("RunService").Stepped:Connect(function()
                if Library.Unloaded then
                    connection:Disconnect()
                    return
                end
                if speedToggle and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = currentWalkspeed
                end
            end)
        end
    end
})

-- JumpHack Group
local JumpGroup = Tabs.Main:AddRightGroupbox("JumpHack")
local currentJumppower = 50
local jumpToggle = false
local infJumpToggle = false
local velocityJumpToggle = false

JumpGroup:AddSlider("JumpPowerSlider", {
    Text = "JumpPower",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    
    Callback = function(Value)
        currentJumppower = Value
        if jumpToggle and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = Value
        end
    end
})

JumpGroup:AddToggle("AutoJumpToggle", {
    Text = "Auto Apply JumpPower",
    Default = false,
    
    Callback = function(Value)
        jumpToggle = Value
        if Value then
            local connection
            connection = game:GetService("RunService").Stepped:Connect(function()
                if Library.Unloaded then
                    connection:Disconnect()
                    return
                end
                if jumpToggle and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.JumpPower = currentJumppower
                end
            end)
        end
    end
})

JumpGroup:AddToggle("InfJumpToggle", {
    Text = "Infinite Jump",
    Default = false,
    
    Callback = function(Value)
        infJumpToggle = Value
        if Value then
            local connection
            connection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if infJumpToggle and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

JumpGroup:AddToggle("VelocityJumpToggle", {
    Text = "Velocity Jump",
    Default = false,
    
    Callback = function(Value)
        velocityJumpToggle = Value
        if Value then
            local connection
            connection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if velocityJumpToggle and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.Velocity = Vector3.new(
                        player.Character.HumanoidRootPart.Velocity.X,
                        100,
                        player.Character.HumanoidRootPart.Velocity.Z
                    )
                end
            end)
        end
    end
})

-- Fly Group
local FlyGroup = Tabs.Main:AddLeftGroupbox("Fly")
local flying = false
local flySpeed = 50
local bodyVelocity

FlyGroup:AddSlider("FlySpeedSlider", {
    Text = "Fly Speed",
    Default = 50,
    Min = 1,
    Max = 200,
    Rounding = 0,
    
    Callback = function(Value)
        flySpeed = Value
    end
})

FlyGroup:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    
    Callback = function(Value)
        flying = Value
        if Value then
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and root then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.Parent = root
                    
                    humanoid.PlatformStand = true
                    
                    local connection
                    connection = game:GetService("RunService").Stepped:Connect(function()
                        if Library.Unloaded or not flying or not bodyVelocity or not bodyVelocity.Parent then
                            if connection then
                                connection:Disconnect()
                            end
                            return
                        end
                        
                        local camera = workspace.CurrentCamera
                        local direction = Vector3.new()
                        
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                            direction = direction + camera.CFrame.LookVector
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                            direction = direction - camera.CFrame.LookVector
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                            direction = direction + camera.CFrame.RightVector
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                            direction = direction - camera.CFrame.RightVector
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                            direction = direction + Vector3.new(0, 1, 0)
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                            direction = direction - Vector3.new(0, 1, 0)
                        end
                        
                        if direction.Magnitude > 0 then
                            direction = direction.Unit * flySpeed
                        end
                        
                        bodyVelocity.Velocity = direction
                    end)
                end
            end
        else
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.PlatformStand = false
            end
        end
    end
})

-- Utility Group
local UtilityGroup = Tabs.Main:AddRightGroupbox("Utility")

UtilityGroup:AddToggle("AntiAfkToggle", {
    Text = "AntiAfk",
    Default = false,
    
    Callback = function(Value)
        if Value then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

-- Teleport Group
local TeleportGroup = Tabs.Main:AddLeftGroupbox("Teleport")

TeleportGroup:AddButton("Teleport to Safe Spot", function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end
end)

-- MoveTo Group
local MoveGroup = Tabs.Main:AddRightGroupbox("MoveTo")
local targetPosition = Vector3.new(0, 0, 0)

MoveGroup:AddInput("XPosition", {
    Default = "0",
    Numeric = true,
    Text = "X Position",
    Placeholder = "0",
    
    Callback = function(Value)
        targetPosition = Vector3.new(tonumber(Value) or 0, targetPosition.Y, targetPosition.Z)
    end
})

MoveGroup:AddInput("YPosition", {
    Default = "0",
    Numeric = true,
    Text = "Y Position",
    Placeholder = "0",
    
    Callback = function(Value)
        targetPosition = Vector3.new(targetPosition.X, tonumber(Value) or 0, targetPosition.Z)
    end
})

MoveGroup:AddInput("ZPosition", {
    Default = "0",
    Numeric = true,
    Text = "Z Position",
    Placeholder = "0",
    
    Callback = function(Value)
        targetPosition = Vector3.new(targetPosition.X, targetPosition.Y, tonumber(Value) or 0)
    end
})

MoveGroup:AddButton("Move to Position", function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end)

-- Settings
Tabs.Settings:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightAlt",
    NoUI = true,
    Text = "Menu keybind"
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
