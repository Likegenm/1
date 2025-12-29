local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = "The Field script",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Playertab = Window:AddTab('Player')

local speedgb = Playertab:AddLeftGroupbox('SpeedHack')

speedgb:AddSlider('SpeedSlider', {
    Text = 'Speed:',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
while task.wait(0.1) do
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
            end
        end
})
local flygb = Playertab:AddRightGropbox('Fly')

flygb:AddSlider('FlySlider', {
    Text = 'Fly Setting:',
    Default = 40,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
    end
})

flygb:AddToggle('FlyOn', {
    Text = 'Fly',
    Default = true,
    Tooltip = 'Toggle fly',
    Callback = function(Value)
        if Value then
                local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flyEnabled = false
local flyTween = nil

local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        local character = player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            
            local camera = workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            
            local targetVelocity = Vector3.new(0, 0, 0)
            local flySpeed = FlySlider.Value
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                targetVelocity = targetVelocity + lookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                targetVelocity = targetVelocity - lookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                targetVelocity = targetVelocity - rightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                targetVelocity = targetVelocity + rightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                targetVelocity = targetVelocity + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                targetVelocity = targetVelocity + Vector3.new(0, -1, 0)
            end
            
            if targetVelocity.Magnitude > 0 then
                targetVelocity = targetVelocity.Unit * flySpeed
            end
            
            if flyTween then
                flyTween:Cancel()
            end
            
            local tweenInfo = TweenInfo.new(
                0.1,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )
            
            flyTween = TweenService:Create(humanoidRootPart, tweenInfo, {Velocity = targetVelocity})
            flyTween:Play()
        end)
        
    else
        if flyTween then
            flyTween:Cancel()
            flyTween = nil
        end
        
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
        
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)      
    end
})
