-- PS99 Tap Heroes Auto Upgrade v1.1 | plalettescripts | KEYLESS
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Config = { AutoUpgrade = false }

-- Upgrade-Teil finden (die Maschine/der NPC wo man Upgrades kauft)
local function FindUpgradePart()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("upgrade") or n:find("shop") or n:find("buy") or n:find("merchant") then
                if obj:IsA("BasePart") then
                    return obj
                elseif obj:IsA("Model") then
                    local part = obj:FindFirstChildOfClass("BasePart") or obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                    if part then return part end
                end
            end
        end
    end
    return nil
end

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "PS99_TapHeroes"
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 70)
Main.Position = UDim2.new(0.5, -90, 0.02, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
Title.TextColor3 = Color3.fromRGB(255, 150, 30)
Title.Text = "👆 Tap Heroes v1.1"
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
    Config.AutoUpgrade = false
    GUI:Destroy()
end)

local TogFrame = Instance.new("Frame")
TogFrame.Size = UDim2.new(1, -8, 0, 26)
TogFrame.Position = UDim2.new(0, 4, 0, 26)
TogFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
TogFrame.Parent = Main
Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 4)

local TogLabel = Instance.new("TextLabel")
TogLabel.Size = UDim2.new(0.6, 0, 1, 0)
TogLabel.Position = UDim2.new(0.04, 0, 0, 0)
TogLabel.BackgroundTransparency = 1
TogLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
TogLabel.Text = "Auto Upgrade: OFF"
TogLabel.Font = Enum.Font.SourceSansSemibold
TogLabel.TextSize = 11
TogLabel.TextXAlignment = Enum.TextXAlignment.Left
TogLabel.Parent = TogFrame

local TogBtn = Instance.new("TextButton")
TogBtn.Size = UDim2.new(0, 30, 0, 16)
TogBtn.Position = UDim2.new(0.88, -30, 0, 5)
TogBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 68)
TogBtn.Text = ""
TogBtn.Parent = TogFrame
Instance.new("UICorner", TogBtn).CornerRadius = UDim.new(0, 7)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -8, 0, 14)
Status.Position = UDim2.new(0, 4, 0, 55)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(140, 140, 160)
Status.Text = "plalettescripts | v1.1 | KEYLESS"
Status.Font = Enum.Font.SourceSans
Status.TextSize = 9
Status.Parent = Main

local enabled = false
TogBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    Config.AutoUpgrade = enabled
    TogLabel.Text = "Auto Upgrade: " .. (enabled and "ON" or "OFF")
    TogBtn.BackgroundColor3 = enabled and Color3.fromRGB(255, 150, 30) or Color3.fromRGB(50, 55, 68)
end)

-- Auto Upgrade (nur zum Upgrade-Ding laufen und klicken)
task.spawn(function()
    while true do
        if Config.AutoUpgrade and LocalPlayer.Character then
            pcall(function()
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end
                
                local upgradePart = FindUpgradePart()
                
                if upgradePart then
                    local dist = (upgradePart.Position - hrp.Position).Magnitude
                    
                    if dist > 8 then
                        -- Zum Upgrade-Teil laufen
                        hum.WalkSpeed = 60
                        hum:MoveTo(upgradePart.Position)
                        Status.Text = "Laufe zu Upgrade... " .. math.floor(dist) .. "m"
                        
                        -- Warten bis nah genug
                        local waited = 0
                        repeat
                            task.wait(0.1)
                            waited = waited + 0.1
                            if not Config.AutoUpgrade then break end
                        until (upgradePart.Position - hrp.Position).Magnitude < 8 or waited > 5
                    end
                    
                    if (upgradePart.Position - hrp.Position).Magnitude < 8 then
                        Status.Text = "Kaufe Upgrade..."
                        
                        -- ProximityPrompt suchen und aktivieren
                        local prompt = upgradePart:FindFirstChildOfClass("ProximityPrompt")
                        if not prompt and upgradePart.Parent then
                            prompt = upgradePart.Parent:FindFirstChildOfClass("ProximityPrompt")
                        end
                        if prompt then
                            for _ = 1, 3 do
                                fireproximityprompt(prompt)
                            end
                        end
                        
                        -- Touch interest
                        firetouchinterest(hrp, upgradePart, 0)
                        firetouchinterest(hrp, upgradePart, 1)
                        
                        task.wait(0.5)
                    end
                else
                    Status.Text = "Kein Upgrade gefunden"
                    task.wait(2)
                end
            end)
        end
        task.wait(0.5)
    end
end)
