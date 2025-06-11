if not game:IsLoaded() then game.Loaded:Wait() end

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoopzScriptGUI"
ScreenGui.ResetOnSpawn = false
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    pcall(function() ScreenGui.Parent = game:WaitForChild("CoreGui") end)
end

local themeColor = Color3.fromRGB(0, 170, 255)
local buttonHeight = 36
local spacing = 8

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 380)
mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🏀 Hoopz Script"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
	btn.MouseButton1Click:Connect(function() showTab(name) end)
end

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

-- Aimbot logic
local aimbotEnabled = false
local autoShoot = false

createToggle("Aimbot Enabled", "Aimbot", function(state)
	aimbotEnabled = state
end)

createToggle("Auto Shoot", "Aimbot", function(state)
	autoShoot = state
end)

createToggle("Highlight Ball", "Visuals", function(state)
	-- Future visual ESP
end)

createToggle("Auto Green Release", "Misc", function(state)
	-- Future: tune shot to green
end)

createToggle("Theme Change (Coming Soon)", "Settings", function(state)
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

showTab("Aimbot")

-- Keybind to toggle GUI
local guiVisible = true
UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		guiVisible = not guiVisible
		mainFrame.Visible = guiVisible
	end
end)

-- Auto Aimbot + Shooting loop
RS.RenderStepped:Connect(function()
	if not aimbotEnabled then return end
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local hrp = char.HumanoidRootPart
	local closestHoop, shortest = nil, math.huge

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Goal" then
			local dist = (obj.Position - hrp.Position).Magnitude
			if dist < shortest then
				shortest = dist
				closestHoop = obj
			end
		end
	end

	if closestHoop then
		hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(closestHoop.Position.X, hrp.Position.Y, closestHoop.Position.Z))

		if autoShoot then
			local shootButton = player.PlayerGui:FindFirstChild("MainGUI") and player.PlayerGui.MainGUI:FindFirstChild("ShootButton")
			if shootButton then
				mouse1click()
			end
		end
	end
end)
