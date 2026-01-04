local Events = game:GetService("Workspace"):FindFirstChild("Events")
local Anxiety = Events.Anxiety
local AnxietyAmount = Events.AnxietyAmount
local Awareness = Events.AwarenessValue and Events.IntruderAwareness
local IntruderPos = game:GetService("Workspace").Values.intruderPos
local PlrAnim = game:GetService("Players").LocalPlayer.Character.Animate
local CamMovement = game:GetService("Players").LocalPlayer.Character.RealisticCameraMovement
local StupidBook = game:GetService("Workspace").Book
local function InteractClick()
  game.workspace.Map.Speaker.AnswerGuide.HoldDuration = 0
  game.workspace.Map.Speaker.AnswerGuide2.HoldDuration = 0
  game.workspace.Map.Speaker.FixPhone.HoldDuration = 0
  game.workspace.Map.LightSwitch.DownSwitch.ProximityPrompt.HoldDuration = 0
  game.workspace.Map.LightSwitch.UpSwitch.ProximityPrompt.HoldDuration = 0
  game.workspace.Map.ClosetDoor.Handle.Close.HoldDuration = 0
  game.workspace.Map.ClosetDoor.Handle.Open.HoldDuration = 0
end

local function NVision()
  local Players = game:GetService("Players")
  local Lighting = game:GetService("Lighting")
  local LocalPlayer = Players.LocalPlayer
  local Camera = workspace.CurrentCamera
  local nightVision = Instance.new("ColorCorrectionEffect")
  nightVision.Name = "GreenNightVision"
  nightVision.Parent = Lighting
  nightVision.TintColor = Color3.fromRGB(100, 255, 100)
  nightVision.Brightness = 0.1
  nightVision.Contrast = 0.5
  nightVision.Saturation = 0.3
  nightVision.Enabled = true
  Lighting.Ambient = Color3.fromRGB(50, 100, 50)
  Lighting.Brightness = 2
  Lighting.OutdoorAmbient = Color3.fromRGB(50, 100, 50)
end

local function MakeNightmare()
  game:GetService("Workspace"):FindFirstChild("Values").isNightmareMode.Value = true
  game:GetService("Workspace"):FindFirstChild("Values").isEasyMode.Value = false
  StupidBook:Destroy()
end

local function NoAnim()
  PlrAnim:Destroy
  game:GetService("Players").LocalPlayer.Character.Idle:Destroy
end

local function AntiDeath()
  game:GetService("Players").LocalPlayer.Character.IsDead:Destroy()
end

local function AntiAnxiety()
  Anxiety:Destroy()
  AnxietyAmount:Destroy()
end

local function AntiAwarness()
  Events.IntruderAwareness:Destroy()
  Events.AwarenessValue:Destroy()
end
