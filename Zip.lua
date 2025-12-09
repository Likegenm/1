local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsGUI"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0, 10, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Scripts GUI"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local scriptsFrame = Instance.new("ScrollingFrame")
scriptsFrame.Size = UDim2.new(0.9, 0, 0, 250)
scriptsFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
scriptsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scriptsFrame.BorderSizePixel = 0
scriptsFrame.ScrollBarThickness = 6
scriptsFrame.Parent = mainFrame

local function createButton(text, position, scriptUrl)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.95, 0, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = scriptsFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)
    
    return button
end

local scripts = {
    {name = "1: Fly", url = "https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Fly.lua"},
    {name = "2: InfJump", url = "https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Infjump.lua"},
    {name = "3: JumpHack", url = "https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Jump.lua"},
    {name = "4: Float", url = "https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/float.lua"},
    {name = "5: StealHelper", url = "https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/STealHelper.lua"},
    {name = "6: AntiHit", url = "https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/AntiHit.lua"}
}

for i, scriptData in ipairs(scripts) do
    createButton(scriptData.name, UDim2.new(0.025, 0, 0, (i-1) * 45), scriptData.url)
end

scriptsFrame.CanvasSize = UDim2.new(0, 0, 0, #scripts * 45)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 80, 0, 30)
closeButton.Position = UDim2.new(0.5, -40, 0.9, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "Close"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
