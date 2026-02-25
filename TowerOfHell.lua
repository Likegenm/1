local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

local Window = Library:CreateWindow{
    Title = "Tower of Hell",
    SubTitle = "by Likegenm",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Main = Window:CreateTab{
    Title = "Main",
    Icon = "ph-house-bold"  -- Исправлена иконка
}

-- Получаем сервисы
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Main:CreateButton{
    Title = "Win",
    Description = "Win (Smooth Tween)",
    Callback = function()  -- Исправлено "fucntion" на "function"
        -- Проверяем существование персонажа
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Ищем Finish
        local finish = game:GetService("Workspace"):FindFirstChild("tower") and 
                      game.workspace.tower:FindFirstChild("Finishes") and 
                      game.workspace.tower.Finishes:FindFirstChild("Finish")
        
        if finish then
            -- Создаем твин для плавного перемещения
            local tweenInfo = TweenInfo.new(
                1, -- Время анимации (секунды)
                Enum.EasingStyle.Quad, -- Стиль анимации
                Enum.EasingDirection.InOut, -- Направление
                0, -- Задержка
                false, -- Повторение
                0 -- Количество повторений
            )
            
            local goal = {
                CFrame = CFrame.new(finish.Position) * CFrame.new(0, 3, 0) -- Немного выше финиша
            }
            
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
            tween:Play()
            
            Library:Notify({
                Title = "Success",
                Content = "Teleporting to finish!",
                Duration = 2
            })
            
            -- Ждем завершения твина
            tween.Completed:Wait()
            
            Library:Notify({
                Title = "Success",
                Content = "You won!",
                Duration = 2
            })
        else
            Library:Notify({
                Title = "Error",
                Content = "Finish not found!",
                Duration = 3
            })
        end
    end
}

-- Добавляем кнопку с разными стилями твина для теста
Main:CreateButton{
    Title = "Win (Different Styles)",
    Description = "Try different tween styles",
    Callback = function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local finish = game:GetService("Workspace"):FindFirstChild("tower") and 
                      game.workspace.tower:FindFirstChild("Finishes") and 
                      game.workspace.tower.Finishes:FindFirstChild("Finish")
        
        if finish then
            -- Массив разных стилей анимации
            local styles = {
                Enum.EasingStyle.Linear,
                Enum.EasingStyle.Sine,
                Enum.EasingStyle.Back,
                Enum.EasingStyle.Elastic,
                Enum.EasingStyle.Bounce
            }
            
            -- Выбираем случайный стиль
            local randomStyle = styles[math.random(1, #styles)]
            
            local tweenInfo = TweenInfo.new(
                1.5, -- Время
                randomStyle, -- Случайный стиль
                Enum.EasingDirection.Out,
                0,
                false,
                0
            )
            
            local goal = {
                CFrame = CFrame.new(finish.Position) * CFrame.new(0, 3, 0)
            }
            
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
            tween:Play()
            
            Library:Notify({
                Title = "Tween Style",
                Content = "Using: " .. tostring(randomStyle),
                Duration = 2
            })
        end
    end
}
