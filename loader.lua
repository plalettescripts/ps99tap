-- PS99 Tap Heroes Auto Clicker v1.0 | plalettescripts | KEYLESS
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Config = { AutoClick = false, Speed = 1 }

-- Boss-Truhe finden
local function FindBossChest()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("boss") or n:find("chest") or n:find("truhe") or n:find("tap") or n:find("click") then
                if obj:IsA("BasePart") then
                    return obj
                elseif obj:IsA("Model") then
                    local part = obj:FindFirstChildOfClass("BasePart")
                    if part then return part end
                end
            end
        end
    end
    return nil
end

-- ProximityPrompt oder ClickDetector finden und feuern
local function ClickBossChest(chest)
    if not chest then return end
    
    -- ProximityPrompt
    local prompt = chest:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        for i = 1, 50 do
            prompt:InputHoldBegin()
            prompt:InputHoldEnd()
        end
        return
    end
    
    -- ClickDetector
    local click = chest:FindFirstChildOfClass("ClickDetector")
    if click then
        for i = 1, 50 do
            fireclickdetector(click)
        end
        return
    end
    
    -- Touch interest
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for i = 1, 50 do
                firetouchinterest(hrp, chest, 0)
                firetouchinterest(hrp, chest, 1)
            end
        end
    end
end

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "PS99_TapHeroes"
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 90)
Main.Position = UDim2.new(0.5, -90, 0.02, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 3, 1, 3)
Border.Position = UDim2.new(0, -1.5, 0, -1.5)
Border.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
Border.BorderSizePixel = 0
Border.Parent = Main
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 9)

task.spawn(function()
    local hue = 0.12
    while GUI and GUI.Parent do
        hue = hue + 0.005
        if hue > 0.18 then hue = 0.12 end
        pcall(function() Border.BackgroundColor3 = Color3.fromHSV(hue, 1, 1) end)
        task.wait(0.04)
    end
end)

-- Minimiert
local Mini = Instance.new("Frame")
Mini.Size = UDim2.new(0, 180, 0, 28)
Mini.Position = UDim2.new(0.5, -90, 0.02, 0)
Mini.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
Mini.BorderSizePixel = 0
Mini.Visible = false
Mini.Active = true
Mini.Draggable = true
Mini.Parent = GUI
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 6)

local MiniText = Instance.new("TextLabel")
MiniText.Size = UDim2.new(1, 0, 1, 0)
MiniText.BackgroundTransparency = 1
MiniText.TextColor3 = Color3.fromRGB(255, 200, 50)
MiniText.Text = "👆 Tap Heroes | plalettescripts"
MiniText.Font = Enum.Font.SourceSansBold
MiniText.TextSize = 11
MiniText.Parent = Mini

-- CTRL Toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
        Mini.Visible = not Mini.Visible
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
Title.TextColor3 = Color3.fromRGB(255, 200, 50)
Title.Text = "👆 Tap Heroes v1.0"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 12
Title.Parent = Main

-- Toggle
local TogFrame = Instance.new("Frame")
TogFrame.Size = UDim2.new(1, -8, 0, 28)
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
TogBtn.Position = UDim2.new(0.88, -30, 0, 6)
TogBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
TogBtn.Text = ""
TogBtn.Parent = TogFrame
Instance.new("UICorner", TogBtn).CornerRadius = UDim.new(0, 8)

-- Slider
local SliFrame = Instance.new("Frame")
SliFrame.Size = UDim2.new(1, -8, 0, 30)
SliFrame.Position = UDim2.new(0, 4, 0, 58)
SliFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
SliFrame.Parent = Main
Instance.new("UICorner", SliFrame).CornerRadius = UDim.new(0, 4)

local SliLabel = Instance.new("TextLabel")
SliLabel.Size = UDim2.new(0.55, 0, 1, 0)
SliLabel.Position = UDim2.new(0.04, 0, 0, 0)
SliLabel.BackgroundTransparency = 1
SliLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
SliLabel.Text = "Speed: 1x"
SliLabel.Font = Enum.Font.SourceSansSemibold
SliLabel.TextSize = 11
SliLabel.TextXAlignment = Enum.TextXAlignment.Left
SliLabel.Parent = SliFrame

local SliInput = Instance.new("TextBox")
SliInput.Size = UDim2.new(0.25, 0, 0, 18)
SliInput.Position = UDim2.new(0.7, 0, 0, 6)
SliInput.BackgroundColor3 = Color3.fromRGB(45, 48, 60)
SliInput.TextColor3 = Color3.fromRGB(255, 220, 150)
SliInput.Text = "1"
SliInput.Font = Enum.Font.SourceSans
SliInput.TextSize = 11
SliInput.Parent = SliFrame
Instance.new("UICorner", SliInput).CornerRadius = UDim.new(0, 4)

SliInput.FocusLost:Connect(function()
    local v = tonumber(SliInput.Text)
    if v and v >= 1 and v <= 100 then
        Config.Speed = v
        SliLabel.Text = "Speed: " .. v .. "x"
    else
        SliInput.Text = tostring(Config.Speed)
    end
end)

local enabled = false
TogBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    Config.AutoClick = enabled
    TogLabel.Text = "Auto Click: " .. (enabled and "ON" or "OFF")
    TogBtn.BackgroundColor3 = enabled and Color3.fromRGB(255, 180, 30) or Color3.fromRGB(50, 55, 70)
end)

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -8, 0, 14)
Status.Position = UDim2.new(0, 4, 0, 90)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(150, 150, 170)
Status.Text = "plalettescripts | v1.0 | KEYLESS"
Status.Font = Enum.Font.SourceSans
Status.TextSize = 9
Status.Visible = false
Status.Parent = Main

-- Auto Click Loop (Boss-Truhe direkt feuern)
task.spawn(function()
    while true do
        if Config.AutoClick then
            pcall(function()
                local chest = FindBossChest()
                if chest then
                    for i = 1, Config.Speed * 10 do
                        ClickBossChest(chest)
                    end
                end
            end)
        end
        task.wait(0.01)
    end
end)
