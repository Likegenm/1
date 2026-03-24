local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

local Window = Library:CreateWindow{
    Title = "Bedwars",
    SubTitle = "by Likegenm",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
}

local LPTab = Window:CreateTab{
	Title = "LocalPlayer",
	Icon = "zap"
}

local GTab = Window:AddTab{
  Title = "Gameplay",
  Icon = "Gun"
}

local VTab = Window:AddTab{
  Title = "Visual",
  Icon = "eye"
}

local TTab = Window:AddTab{
  Title = "Teleport",
  Icon = "door"
}

