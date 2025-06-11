if not game:IsLoaded() then game.Loaded:Wait() end

local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoopzScriptGUI"
ScreenGui.ResetOnSpawn = false

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

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 380)
mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🏀 Hoopz Script"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = mainFrame

-- Tabs
local tabNames = {"Aimbot", "Visuals", "Misc", "Settings"}
local tabButtons = {}
local tabContents = {}

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

-- Create Pages
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

-- Show tab function
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

-- Create toggle buttons
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
end

-- Add toggles to each tab (hook these up later)
createToggle("Aimbot Enabled", "Aimbot", function(state)
	print("[Aimbot] Toggled:", state)
end)

createToggle("Auto Shoot", "Aimbot", function(state)
	print("[Auto Shoot] Toggled:", state)
end)

createToggle("Highlight Ball", "Visuals", function(state)
	print("[Visuals] Highlight:", state)
end)

createToggle("Auto Green Release", "Misc", function(state)
	print("[Misc] Auto Green:", state)
end)

createToggle("Theme Change (Coming Soon)", "Settings", function(state)
	print("[Settings] Theme toggle:", state)
end)

-- Credits
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 24)
credit.Position = UDim2.new(0, 0, 1, -26)
credit.Text = "Made by extractly-1"
credit.TextColor3 = Color3.fromRGB(150, 150, 150)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.Parent = mainFrame

-- Show default tab
showTab("Aimbot")

-- GUI toggle keybind
local guiVisible = true
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		guiVisible = not guiVisible
		mainFrame.Visible = guiVisible
	end
end)
