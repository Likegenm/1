local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Likegenm",
    Footer = "v1.0(Blade Ball)",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local MainTab = Window:AddTab("Legit", "lock")
local AP = MainTab:AddLeftGroupbox("AutoParry")

AP:AddLabel("AutoParry: Chance, ON/OFF")

local chanceSlider = AP:AddSlider("Chance", {
    Text = "Parry Chance %",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0
})

local autoParryToggle = AP:AddToggle("Enable", {
    Text = "Auto Parry",
    Default = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local enabled = false
local chance = 100

-- Обновляем значения при изменении
autoParryToggle:OnChanged(function(value)
    enabled = value
end)

chanceSlider:OnChanged(function(value)
    chance = value
end)

RunService.Heartbeat:Connect(function()
    if not enabled then return end
    if not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local ballsFolder = workspace:FindFirstChild("Balls") 
    if not ballsFolder then return end
    
    for _, ball in pairs(ballsFolder:GetChildren()) do
        if ball:IsA("BasePart") then
            local distance = (ball.Position - hrp.Position).Magnitude
            
            if distance <= 25 then
                local random = math.random(1, 100)
                
                if random <= chance then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end
            end
        end
    end
end)
