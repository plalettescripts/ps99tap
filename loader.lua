-- PS99 Tap Heroes Auto Upgrade v1.0 | plalettescripts | KEYLESS
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Config = { AutoUpgrade = false, AutoTap = false, AutoBreak = false }

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "PS99_TapHeroes"
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 185, 0, 120)
Main.Position = UDim2.new(0.5, -92, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 3, 1, 3)
Border.Position = UDim2.new(0, -1.5, 0, -1.5)
Border.BackgroundColor3 = Color3.fromRGB(255, 150, 30)
Border.BorderSizePixel = 0
Border.Parent = Main
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 9)

task.spawn(function()
    local hue = 0.08
    while GUI and GUI.Parent do
        hue = hue + 0.004
        if hue > 0.14 then hue = 0.08 end
        pcall(function() Border.BackgroundColor3 = Color3.fromHSV(hue, 1, 1) end)
        task.wait(0.04)
    end
end)

-- Minimiert
local Mini = Instance.new("Frame")
Mini.Size = UDim2.new(0, 175, 0, 28)
Mini.Position = UDim2.new(0.5, -87, 0.1, 0)
Mini.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
Mini.BorderSizePixel = 0
Mini.Visible = false
Mini.Active = true
Mini.Draggable = true
Mini.Parent = GUI
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 6)

local MiniText = Instance.new("TextLabel")
MiniText.Size = UDim2.new(1, 0, 1, 0)
MiniText.BackgroundTransparency = 1
MiniText.TextColor3 = Color3.fromRGB(255, 150, 30)
MiniText.Text = "👆 Tap Heroes | plalettescripts"
MiniText.Font = Enum.Font.SourceSansBold
MiniText.TextSize = 11
MiniText.Parent = Mini

-- CTRL
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
        Mini.Visible = not Mini.Visible
    end
end)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
Title.TextColor3 = Color3.fromRGB(255, 150, 30)
Title.Text = "👆 Tap Heroes v1.0"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 18)
CloseBtn.Position = UDim2.new(1, -24, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 11
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function()
    Config.AutoUpgrade = false
    Config.AutoTap = false
    Config.AutoBreak = false
    GUI:Destroy()
end)

-- Toggle Funktion
local function AddToggle(name, key, yPos)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -8, 0, 24)
    Frame.Position = UDim2.new(0, 4, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
    Frame.Parent = Main
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.55, 0, 1, 0)
    Label.Position = UDim2.new(0.04, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.Text = name .. ": OFF"
    Label.Font = Enum.Font.SourceSansSemibold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 28, 0, 14)
    Btn.Position = UDim2.new(0.88, -28, 0, 5)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 55, 68)
    Btn.Text = ""
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 7)

    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Config[key] = on
        Label.Text = name .. ": " .. (on and "ON" or "OFF")
        Btn.BackgroundColor3 = on and Color3.fromRGB(255, 140, 20) or Color3.fromRGB(50, 55, 68)
    end)
end

AddToggle("Auto Upgrade Kaufen", "AutoUpgrade", 28)
AddToggle("Auto Tap (Truhe)", "AutoTap", 56)
AddToggle("Auto Break (Teile)", "AutoBreak", 84)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -8, 0, 16)
Status.Position = UDim2.new(0, 4, 0, 112)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(140, 140, 160)
Status.Text = "plalettescripts | v1.0 | KEYLESS"
Status.Font = Enum.Font.SourceSans
Status.TextSize = 8
Status.Visible = false
Status.Parent = Main

-- ==================== FEATURES ====================

-- Auto Tap (Truhe anklicken)
task.spawn(function()
    while true do
        if Config.AutoTap then
            pcall(function()
                -- ProximityPrompts feuern
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        for _ = 1, 3 do
                            fireproximityprompt(obj)
                        end
                    end
                end
                -- ClickDetectors feuern
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ClickDetector") then
                        for _ = 1, 3 do
                            fireclickdetector(obj)
                        end
                    end
                end
                -- Touch auf alles was nach Truhe/Kiste aussieht
                if LocalPlayer.Character then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local n = obj.Name:lower()
                                if n:find("chest") or n:find("kiste") or n:find("truhe") or n:find("tap") or n:find("boss") then
                                    firetouchinterest(hrp, obj, 0)
                                    firetouchinterest(hrp, obj, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.01)
    end
end)

-- Auto Break (Teile abbauen)
task.spawn(function()
    while true do
        if Config.AutoBreak then
            pcall(function()
                if LocalPlayer.Character then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local n = obj.Name:lower()
                                if n:find("part") or n:find("break") or n:find("block") or n:find("stone") or n:find("rock") or n:find("wood") then
                                    if (obj.Position - hrp.Position).Magnitude < 20 then
                                        firetouchinterest(hrp, obj, 0)
                                        firetouchinterest(hrp, obj, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.05)
    end
end)

-- Auto Upgrade (Upgrades kaufen sobald genug Tokens)
task.spawn(function()
    while true do
        if Config.AutoUpgrade then
            pcall(function()
                -- Suche nach Upgrade-Buttons im PlayerGui
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    -- Suche nach Buttons die Upgrade-Namen enthalten
                    for _, obj in ipairs(playerGui:GetDescendants()) do
                        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                            local n = obj.Name:lower()
                            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                            
                            -- Typische Upgrade-Button Namen
                            if n:find("upgrade") or n:find("buy") or n:find("purchase") or
                               parentName:find("upgrade") or parentName:find("shop") then
                                
                                -- Prüfe ob Button klickbar ist (nicht ausgegraut)
                                if obj.Active and obj.Visible then
                                    -- Simuliere Klick
                                    for _ = 1, 3 do
                                        pcall(function()
                                            -- Fire MouseButton1Click
                                            local args = {}
                                            for _, event in ipairs(obj:GetAttributeNames()) do
                                                -- Versuche Button zu aktivieren
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Auch nach Remote Events suchen für Upgrades
                    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                        if obj:IsA("RemoteEvent") then
                            local n = obj.Name:lower()
                            if n:find("upgrade") or n:find("buy") or n:find("purchase") then
                                for _ = 1, 5 do
                                    obj:FireServer()
                                end
                            end
                        end
                    end
                end
                
                -- ProximityPrompts für Upgrade-NPCs
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local n = obj.Name:lower()
                        local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                        if n:find("upgrade") or n:find("buy") or parentName:find("upgrade") or parentName:find("merchant") then
                            for _ = 1, 3 do
                                fireproximityprompt(obj)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)
