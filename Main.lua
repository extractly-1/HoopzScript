local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomCheatUI"
gui.ResetOnSpawn = false

-- Theme Colors
local themes = {
	Dark = {
		main = Color3.fromRGB(35, 35, 35),
		tab = Color3.fromRGB(50, 50, 50),
		active = Color3.fromRGB(70, 130, 180),
		page = Color3.fromRGB(45, 45, 45),
		text = Color3.fromRGB(255, 255, 255)
	},
	Light = {
		main = Color3.fromRGB(235, 235, 235),
		tab = Color3.fromRGB(200, 200, 200),
		active = Color3.fromRGB(100, 150, 250),
		page = Color3.fromRGB(215, 215, 215),
		text = Color3.fromRGB(20, 20, 20)
	},
	Custom = {
		main = Color3.fromRGB(40, 0, 80),
		tab = Color3.fromRGB(60, 0, 100),
		active = Color3.fromRGB(120, 60, 200),
		page = Color3.fromRGB(80, 0, 120),
		text = Color3.fromRGB(255, 255, 255)
	}
}

local currentTheme = "Dark"

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 480, 0, 420)
main.Position = UDim2.new(0.5, -240, 0.5, -210)
main.BackgroundColor3 = themes[currentTheme].main
main.BorderSizePixel = 0
main.Active = true
main.Draggable = false

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- Drop Shadow
local shadow = Instance.new("ImageLabel", main)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "🏀 Hoopz Pro GUI"
title.BackgroundColor3 = themes[currentTheme].tab
title.TextColor3 = themes[currentTheme].text
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Name = "DragBar"
title.Active = true

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 10)

-- Drag Script
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Tabs
local tabNames = {"Aimbot", "Reach", "ESP", "Misc", "Credits", "Settings"}
local tabs = {}
local pages = {}

for i, name in ipairs(tabNames) do
	local tab = Instance.new("TextButton", main)
	tab.Size = UDim2.new(0, 75, 0, 30)
	tab.Position = UDim2.new(0, 10 + ((i - 1) * 80), 0, 50)
	tab.BackgroundColor3 = themes[currentTheme].tab
	tab.TextColor3 = themes[currentTheme].text
	tab.Font = Enum.Font.Gotham
	tab.TextSize = 14
	tab.Text = name
	tab.AutoButtonColor = false

	local tabCorner = Instance.new("UICorner", tab)
	tabCorner.CornerRadius = UDim.new(0, 6)

	tabs[name] = tab
end

-- Pages
for _, name in ipairs(tabNames) do
	local page = Instance.new("Frame", main)
	page.Size = UDim2.new(1, -20, 1, -100)
	page.Position = UDim2.new(0, 10, 0, 90)
	page.BackgroundColor3 = themes[currentTheme].page
	page.Visible = false
	page.Name = name .. "Page"

	local corner = Instance.new("UICorner", page)
	corner.CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel", page)
	label.Size = UDim2.new(1, 0, 0, 30)
	label.Position = UDim2.new(0, 0, 0, 10)
	label.Text = name == "Credits" and "📌 Made by YOURNAME | For Hoopz" or "⚙️ " .. name .. " settings coming soon..."
	label.TextColor3 = themes[currentTheme].text
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 18

	pages[name] = page
end

-- Settings: Theme Switcher
local settingsPage = pages["Settings"]
local dropdown = Instance.new("TextButton", settingsPage)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Size = UDim2.new(0, 200, 0, 30)
dropdown.Text = "🎨 Theme: Dark"
dropdown.BackgroundColor3 = themes[currentTheme].tab
dropdown.TextColor3 = themes[currentTheme].text
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 16

local dropdownCorner = Instance.new("UICorner", dropdown)
dropdownCorner.CornerRadius = UDim.new(0, 6)

local themeOptions = {"Dark", "Light", "Custom"}
local currentOption = 1

dropdown.MouseButton1Click:Connect(function()
	currentOption = currentOption % #themeOptions + 1
	currentTheme = themeOptions[currentOption]
	dropdown.Text = "🎨 Theme: " .. currentTheme

	-- Apply Theme
	main.BackgroundColor3 = themes[currentTheme].main
	title.TextColor3 = themes[currentTheme].text
	title.BackgroundColor3 = themes[currentTheme].tab

	for _, tab in pairs(tabs) do
		tab.BackgroundColor3 = themes[currentTheme].tab
		tab.TextColor3 = themes[currentTheme].text
	end

	for name, page in pairs(pages) do
		page.BackgroundColor3 = themes[currentTheme].page
		local label = page:FindFirstChildOfClass("TextLabel")
		if label then
			label.TextColor3 = themes[currentTheme].text
		end
	end
end)

-- Tab Switching
local function showTab(name)
	for n, page in pairs(pages) do
		page.Visible = false
		tabs[n].BackgroundColor3 = themes[currentTheme].tab
	end
	pages[name].Visible = true
	tabs[name].BackgroundColor3 = themes[currentTheme].active
end

for name, btn in pairs(tabs) do
	btn.MouseButton1Click:Connect(function()
		showTab(name)
	end)
end

-- Default tab
showTab("Aimbot")

-- Aimbot Toggle Button
local aimbotEnabled = false

local toggleAimbot = Instance.new("TextButton", pages["Aimbot"])
toggleAimbot.Size = UDim2.new(0, 200, 0, 30)
toggleAimbot.Position = UDim2.new(0, 10, 0, 40)
toggleAimbot.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAimbot.Font = Enum.Font.Gotham
toggleAimbot.TextSize = 16
toggleAimbot.Text = "Aimbot: OFF"

toggleAimbot.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	toggleAimbot.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
	toggleAimbot.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
end)

task.spawn(function()
	while true do
		if aimbotEnabled then
			local player = game.Players.LocalPlayer
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local root = char.HumanoidRootPart
				local closestHoop
				local shortestDistance = math.huge

				for _, obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("BasePart") and obj.Name:lower():find("hoop") then
						local dist = (obj.Position - root.Position).Magnitude
						if dist < shortestDistance then
							shortestDistance = dist
							closestHoop = obj
						end
					end
				end

				if closestHoop then
					local look = (closestHoop.Position - root.Position).Unit
					root.CFrame = CFrame.new(root.Position, root.Position + look)
				end
			end
		end
		task.wait(0.2)
	end
end)
