local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SIA 51",
   LoadingTitle = "by Likegenm + Vicinly",
   LoadingSubtitle = "Helper Library: RedStar",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Pornhub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   }
})

local Tab = Window:CreateTab("Main", 4483362458) 
_G.Tab = Tab

local Bypass = Tab:CreateSection("Bypasser")

local BypassButton = Bypass:CreateButton({
   Name = "Bypass AntiCheat",
   Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/PartScripts/refs/heads/main/RedStar.lua"))()
   end,
})  
