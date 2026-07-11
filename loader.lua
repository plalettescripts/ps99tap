-- PS99 Tap Heroes Internal Clicker v1.2 | plalettescripts | KEYLESS
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Config = { AutoClick = false }
local clickRemote = nil

-- Remote für Klicks finden
local function FindClickRemote()
    if clickRemote then return end
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local n = obj.Name:lower()
            -- Typische Namen für Tap/Klick Events
            if n:find("tap") or n:find("click") or n:find("hit") or n:find("damage") or n:find("boss") or n:find("chest") or n:find("treasure") then
                clickRemote = obj
                return
            end
        end
    end
    -- Fallback: erstes Remote nehmen
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            clickRemote = obj
            return
        end
    end
end

-- Alle ProximityPrompts feuern
local function FireAllPrompts()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            for _ = 1, 5 do
                fireproximityprompt(obj)
            end
        end
    end
end

-- Alle ClickDetectors feuern
local function FireAllClickDetectors()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            for _ = 1, 5 do
                fireclickdetector(obj)
            end
        end
    end
end

-- Touch interest auf alles Klickbare
local function FireTouchOnAll()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("boss") or n:find("chest") or n:find("click") or n:find("tap") or n:find("treasure") then
                firetouchinterest(hrp, obj, 0)
                firetouchinterest(hrp, obj, 1)
            end
        end
    end
end

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "PS99_Tap"
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 170, 0, 60)
Main.Position = UDim2.new(0.5, -85, 0.02, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
Title.TextColor3 = Color3.fromRGB(255, 200, 50)
Title.Text = "👆 Tap Heroes v1.2"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 12
Title.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 18)
CloseBtn.Position = UDim2.new(1, -24, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 11
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function()
    Config.AutoClick = false
    GUI:Destroy()
end)

local TogFrame = Instance.new("Frame")
TogFrame.Size = UDim2.new(1, -8, 0, 26)
TogFrame.Position = UDim2.new(0, 4, 0, 26)
TogFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
TogFrame.Parent = Main
Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 4)

local TogLabel = Instance.new("TextLabel")
TogLabel.Size = UDim2.new(0.5, 0, 1, 0)
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

local enabled = false
TogBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    Config.AutoClick = enabled
    TogLabel.Text = "Auto Click: " .. (enabled and "ON" or "OFF")
    TogBtn.BackgroundColor3 = enabled and Color3.fromRGB(255, 180, 30) or Color3.fromRGB(50, 55, 70)
end)

-- Haupt-Loop (NUR intern, KEIN Mausklick)
task.spawn(function()
    while true do
        if Config.AutoClick then
            pcall(function()
                -- Alle internen Methoden gleichzeitig
                FireAllPrompts()
                FireAllClickDetectors()
                FireTouchOnAll()
                
                -- Remote Event feuern falls gefunden
                FindClickRemote()
                if clickRemote then
                    for _ = 1, 20 do
                        clickRemote:FireServer()
                    end
                end
            end)
        end
        task.wait(0.01)
    end
end)
