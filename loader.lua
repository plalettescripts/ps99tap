-- PS99 Tap Heroes Auto Upgrade v1.4 | plalettescripts | KEYLESS
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local Config = { AutoUpgrade = false }

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "PS99_TapHeroes"
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 190, 0, 70)
Main.Position = UDim2.new(0.5, -95, 0.02, 0)
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
Title.Text = "👆 Tap Heroes v1.4"
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
Status.TextColor3 = Color3.fromRGB(140, 160, 140)
Status.Text = "plalettescripts | v1.4 | KEYLESS"
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

-- Nur Upgrades im geöffneten Fenster anklicken (KEIN Egg Upgrade)
task.spawn(function()
    while true do
        if Config.AutoUpgrade then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if not playerGui then return end
                
                local bought = 0
                
                for _, obj in ipairs(playerGui:GetDescendants()) do
                    if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                        local text = ""
                        if obj:IsA("TextButton") then text = obj.Text:lower() end
                        local name = obj.Name:lower()
                        local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                        local parentParentName = obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name:lower() or ""
                        
                        -- ALLES was nach Egg klingt ÜBERSPRINGEN
                        if text:find("egg") or name:find("egg") or parentName:find("egg") or parentParentName:find("egg") then
                            -- skip
                        else
                            -- Upgrade-Buttons erkennen
                            local isUpgrade = false
                            if name:find("upgrade") or name:find("buy") or name:find("purchase") then isUpgrade = true end
                            if text:find("upgrade") or text:find("buy") or text:find("kauf") then isUpgrade = true end
                            if parentName:find("upgrade") or parentName:find("shop") then isUpgrade = true end
                            if parentParentName:find("upgrade") or parentParentName:find("shop") then isUpgrade = true end
                            
                            if isUpgrade and obj.Visible and obj.Active then
                                pcall(function()
                                    for _ = 1, 3 do
                                        firesignal(obj.MouseButton1Click)
                                        firesignal(obj.Activated)
                                    end
                                    bought = bought + 1
                                end)
                            end
                        end
                    end
                end
                
                if bought > 0 then
                    Status.Text = "Gekauft: " .. bought
                else
                    Status.Text = "Warte auf Tokens..."
                end
            end)
        end
        task.wait(0.3)
    end
end)
