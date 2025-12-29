local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:createWindow({
    Title = "Magic Tulevo script",
    Author = "Likegenm
    Folder = "AxmedHub",
    Icon = "code",
    IconSize = 22*2,
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "UI",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        
        Color = ColorSequence.new(
            Color3.fromHex("#ff0000"), 
            Color3.fromHex("#ffa500")
            Color3.fromHex("#ffff00")
            Color3.fromHex("#008000")
            Color3.fromHex("#42aaff")
            Color3.fromHex("#0000ff")
            Color3.fromHex("#8b00ff")
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
  
KeySystem = {
        Title = "bot check",
        Note = "Key: 1234",
        KeyValidator = function(EnteredKey)
            if EnteredKey == "1234" then
                createPopup()
                return true
            end
            return false
            return EnteredKey == "1234"
        end
    }
    })

    Window:Tag({
        Title = "1.0.0",
        Icon = "github",
        Color = Color3.fromHex("#ffff00"),
        Border = true,
    })
