local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Murino Horror",
    SubTitle = "by Likegenm + Vicinly",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift 
})

local LocalPlayerTab = Window:AddTab({ Title = "LocalPlayer", Icon = "user" })
local GameTab = Window:AddTab({ Title = "Game", Icon = "sword" })
local VisualTab = Window:AddTab({ Title = "Visual", Icon = "eye" })
local CreditsTab = Window:AddTab({ Title = "Credits", Icon = "info" })

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local speedEnabled = false
local originalSpeed = humanoid.WalkSpeed
local flyEnabled = false
local noclipEnabled = false
local infiniteJumpEnabled = false
local bodyVelocity = nil
local longJumpEnabled = false
local originalJumpPower = humanoid.JumpPower
local originalHipHeight = humanoid.HipHeight
local antiBunnyEnabled = false
local lastJumpTime = 0

LocalPlayerTab:AddSlider("Speed", {
    Title = "Speed",
    Description = "Change walk speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        if speedEnabled then
            humanoid.WalkSpeed = value
        end
    end
})

LocalPlayerTab:AddToggle("SpeedToggle", {
    Title = "Enable Speed",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        if value then
            originalSpeed = humanoid.WalkSpeed
            local slider = LocalPlayerTab:GetSlider("Speed")
            humanoid.WalkSpeed = slider.Value
        else
            humanoid.WalkSpeed = originalSpeed
        end
    end
})

LocalPlayerTab:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        infiniteJumpEnabled = value
        if value then
            local UIS = game:GetService("UserInputService")
            UIS.JumpRequest:Connect(function()
                if infiniteJumpEnabled then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

LocalPlayerTab:AddSlider("LongJump", {
    Title = "Long Jump Power",
    Description = "Set jump power",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        if longJumpEnabled then
            humanoid.JumpPower = value
        end
    end
})

LocalPlayerTab:AddToggle("LongJumpToggle", {
    Title = "Long Jump",
    Default = false,
    Callback = function(value)
        longJumpEnabled = value
        if value then
            originalJumpPower = humanoid.JumpPower
            local slider = LocalPlayerTab:GetSlider("LongJump")
            humanoid.JumpPower = slider.Value
        else
            humanoid.JumpPower = originalJumpPower
        end
    end
})

LocalPlayerTab:AddSlider("HipHeight", {
    Title = "Hip Height",
    Description = "Change hip height",
    Default = 0,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(value)
        humanoid.HipHeight = value
    end
})

LocalPlayerTab:AddToggle("HipHeightToggle", {
    Title = "Enable Hip Height",
    Default = false,
    Callback = function(value)
        if value then
            originalHipHeight = humanoid.HipHeight
            local slider = LocalPlayerTab:GetSlider("HipHeight")
            humanoid.HipHeight = slider.Value
        else
            humanoid.HipHeight = originalHipHeight
        end
    end
})

LocalPlayerTab:AddToggle("Fly", {
    Title = "Fly",
    Default = false,
    Callback = function(value)
        flyEnabled = value
        if value then
            local flySpeed = 50
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart
            
            local flyConnection
            flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if flyEnabled then
                    local camera = workspace.CurrentCamera
                    local forward = camera.CFrame.LookVector
                    local right = camera.CFrame.RightVector
                    local up = camera.CFrame.UpVector
                    
                    local move = Vector3.new(0, 0, 0)
                    local UIS = game:GetService("UserInputService")
                    
                    if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + right end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - right end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + up end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up end
                    
                    if move.Magnitude > 0 then
                        move = move.Unit * flySpeed
                    end
                    
                    bodyVelocity.Velocity = move
                    humanoid.PlatformStand = true
                else
                    if bodyVelocity then bodyVelocity:Destroy() end
                    humanoid.PlatformStand = false
                    if flyConnection then flyConnection:Disconnect() end
                end
            end)
        else
            if bodyVelocity then bodyVelocity:Destroy() end
            humanoid.PlatformStand = false
        end
    end
})

LocalPlayerTab:AddToggle("Noclip", {
    Title = "Noclip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        if value then
            local noclipConnection
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if noclipEnabled then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                else
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                    if noclipConnection then noclipConnection:Disconnect() end
                end
            end)
        end
    end
})

GameTab:AddToggle("AntiBunny", {
    Title = "Anti Bunny",
    Description = "Prevent bunny",
    Default = false,
    Callback = function(value)
        antiBunnyEnabled = value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if antiBunnyEnabled then
        local currentTime = tick()
        if currentTime - lastJumpTime < 0.5 then
            humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
            return
        end
        lastJumpTime = currentTime
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T then
        local mouse = player:GetMouse()
        local targetPos = mouse.Hit.p
        local rayOrigin = targetPos + Vector3.new(0, 10, 0)
        local rayDirection = Vector3.new(0, -20, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if raycastResult then
            rootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, humanoid.HipHeight + 2, 0))
        else
            rootPart.CFrame = CFrame.new(targetPos)
        end
    end
end)
