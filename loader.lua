-- PS99 Tap Heroes Auto Clicker v1.1 | plalettescripts | KEYLESS
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Config = { AutoClick = false, Speed = 1 }

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "PS99_TapHeroes"
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 80)
Main.Position = UDim2.new(0.5, -90, 0.02, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
Title.TextColor3 = Color3.fromRGB(255, 200, 50)
Title.Text = "👆 Tap Heroes v1.1"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 12
Title.Parent = Main

local TogFrame = Instance.new("Frame")
TogFrame.Size = UDim2.new(1, -8, 0, 26)
TogFrame.Position = UDim2.new(0, 4, 0, 26)
TogFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
TogFrame.Parent = Main
Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 4)

local TogLabel = Instance.new("TextLabel")
TogLabel.Size = UDim2.new(0.6, 0, 1, 0)
TogLabel.Position = UDim2.new(0.04, 0, 0, 0)
TogLabel.BackgroundTransparency = 1
TogLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
TogLabel.Text = "Auto Click: OFF"
TogLabel.Font = Enum.Font.SourceSansSemibold
TogLabel.TextSize = 11
TogLabel.TextXAlignment = Enum.TextXAlignment.Left
TogLabel.Parent = TogFrame

local TogBtn = Instance.new("TextButton")
TogBtn.Size = UDim2.new(0, 30, 0, 16)
TogBtn.Position = UDim2.new(0.88, -30, 0, 5)
TogBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
TogBtn.Text = ""
TogBtn.Parent = TogFrame
Instance.new("UICorner", TogBtn).CornerRadius = UDim.new(0, 8)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -8, 0, 18)
Status.Position = UDim2.new(0, 4, 0, 56)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(150, 150, 170)
Status.Text = "plalettescripts | v1.1 | KEYLESS"
Status.Font = Enum.Font.SourceSans
Status.TextSize = 9
Status.Parent = Main

local enabled = false
TogBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    Config.AutoClick = enabled
    TogLabel.Text = "Auto Click: " .. (enabled and "ON" or "OFF")
    TogBtn.BackgroundColor3 = enabled and Color3.fromRGB(255, 180, 30) or Color3.fromRGB(50, 55, 70)
end)

-- Simuliert echten Mausklick auf eine Position
local function ClickAt(position)
    local v2 = Vector2.new(position.X, position.Y)
    
    -- Mausbewegung simulieren
    mousemoverel(0, 0) -- Reset
    
    -- Klick simulieren
    mouse1press()
    task.wait(0.001)
    mouse1release()
end

-- Findet klickbare Objekte und klickt sie
local function FindAndClick()
    local mouse = LocalPlayer:GetMouse()
    
    -- Direkt auf die Bildschirmmitte klicken (wo die Truhe meist ist)
    mouse1press()
    task.wait(0.001)
    mouse1release()
    
    -- Auch ProximityPrompts in Reichweite feuern
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            for i = 1, 10 do
                fireproximityprompt(obj)
            end
        end
    end
    
    -- ClickDetectors feuern
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            for i = 1, 10 do
                fireclickdetector(obj)
            end
        end
    end
end

-- Haupt-Loop
task.spawn(function()
    while true do
        if Config.AutoClick then
            pcall(function()
                -- 50 Klicks pro Frame
                for i = 1, 50 do
                    FindAndClick()
                end
            end)
        end
        task.wait(0.001)
    end
end)
