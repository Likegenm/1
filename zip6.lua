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
        local speed = Value
      local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newCharacter) 
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

RunService.Heartbeat:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local mv = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            mv = mv + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            mv = mv - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            mv = mv - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            mv = mv + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector
        end
        if mv.Magnitude > 0 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(
                mv.Unit.X * speed,
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity.Y,
                mv.Unit.Z * speed
            )
        end
    end
end)
        end
})
