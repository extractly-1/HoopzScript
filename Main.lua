

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoopzScriptGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    pcall(function()
        ScreenGui.Parent = game:WaitForChild("CoreGui")
    end)
end

local themeColor = Color3.fromRGB(0, 170, 255)
local buttonHeight = 36
local spacing = 8

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 400)
mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🏀 Hoopz Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = mainFrame

local tabNames = {"Aimbot", "Visuals", "Misc", "Settings"}
local tabButtons, tabContents = {}, {}

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 80, 1, 0)
    tabBtn.Position = UDim2.new(0, 10 + ((i - 1) * 85), 0, 0)
    tabBtn.BackgroundColor3 = themeColor
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 14
    tabBtn.Text = name
    tabBtn.Parent = tabFrame
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = tabBtn
end

for _, name in ipairs(tabNames) do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -110)
    page.Position = UDim2.new(0, 10, 0, 90)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, spacing)
    layout.Parent = page

    tabContents[name] = page
end

local function showTab(name)
    for n, f in pairs(tabContents) do
        f.Visible = (n == name)
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

local toggles = {}
local function createToggle(name, tab, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, buttonHeight)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    btn.Parent = tabContents[tab]
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        btn.BackgroundColor3 = toggled and themeColor or Color3.fromRGB(45, 45, 45)
        callback(toggled)
    end)
    toggles[name] = function() return toggled end
end

createToggle("Aimbot Enabled", "Aimbot", function(state)
    if state then
        StartLocking()
    else
        StopLocking()
    end
end)

createToggle("ESP Ball", "Visuals", function(state)
    print("ESP Enabled")
end)

createToggle("Auto Green Release", "Misc", function(state)
    print("Green release toggled")
end)

createToggle("Theme Changer (soon)", "Settings", function(state) end)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 24)
credit.Position = UDim2.new(0, 0, 1, -26)
credit.Text = "Made by extractly-1"
credit.TextColor3 = Color3.fromRGB(150, 150, 150)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.Parent = mainFrame

local guiVisible = true
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        mainFrame.Visible = guiVisible
    end
end)

local isMobile = UIS.TouchEnabled
local Player = LP
local connection
local isLocking = false

local function PlayerHasBall()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:FindFirstChild("Basketball") ~= nil
end

local function GetClosestGoal()
    local closest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Swish" and obj.Parent:FindFirstChildOfClass("TouchTransmitter") then
            local torso = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if torso then
                local d = (torso.Position - obj.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = obj
                end
            end
        end
    end
    return closest and closest.Parent or nil
end

function StartLocking()
    if isLocking then return end
    isLocking = true
    connection = RS.RenderStepped:Connect(function()
        local closestGoal = GetClosestGoal()
        if closestGoal then
            local head = Player.Character and Player.Character:FindFirstChild("Head")
            if head then
                local target = closestGoal.Position + Vector3.new(0, 40, 0)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target)
            end
        end
    end)
end

function StopLocking()
    if not isLocking then return end
    isLocking = false
    if connection then connection:Disconnect() connection = nil end
end

local char = Player.Character or Player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
humanoid.Jumping:Connect(function()
    if toggles["Aimbot Enabled"] and toggles["Aimbot Enabled"]() and PlayerHasBall() then
        StartLocking()
    end
end)
humanoid.StateChanged:Connect(function(_, state)
    if state == Enum.HumanoidStateType.Landed then
        StopLocking()
    end
end)

showTab("Aimbot")
