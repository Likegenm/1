local Events = game.worksapce.Events
local Anxiety = Events.Anxiety
local Phone = game.workspace.Map.Phone
local Speak = Phone.Speaker
local HD1 = Speak.AnswerGuide.HoldDuration = 0
local HD2 = Speak.AnswerGuide2.HoldDuration = 0
local HD3 = Speak.FixPhone.HoldDuration = 0
local LightS = game.workspace.Map.LightSwitch
local HD4 = LightS.DownSwitch.ProximityPrompt.HoldDuration = 0
local HD5 = LightS.UpSwitch.ProximityPrompt.HoldDuration = 0
local Handle = game.workspace.Map.ClosetDoor.Handle
local HD6 = Handle.Close.HoldDuration = 0
local HD7 = Handle.Open.HoldDuration = 0
local HD = HD1 and HD2 and HD3 and HD4 and HD5 and HD6 and HD7
