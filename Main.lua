-- ✅ Make sure the GUI works in Studio & Exploit environments
if not game:IsLoaded() then game.Loaded:Wait() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoopzScriptGUI"

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

print("[Hoopz GUI] Script loaded")

-- ✅ Theme settings
local themeColor = Color3.fromRGB(0, 170, 255)
local buttonHeight = 40
local spacing = 10

-- ✅ UI main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", mainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- ✅ Tabs & layout
local tabNames = {"Aimbot", "Visuals", "Misc", "Settings"}
local currentTab = nil
local tabButtons = {}

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

for i, tabName in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 70, 1, 0)
    tabBtn.Position = UDim2.new(0, (i - 1) * 75, 0, 0)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.BackgroundColor3 = themeColor
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabFrame

    local corner = Instance.new("UICorner", tabBtn)
    corner.CornerRadius = UDim.new(0, 6)

    tabButtons[tabName] = tabBtn
end

-- ✅ Tab content holders
local tabContents = {}
for _, name in ipairs(tabNames) do
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = mainFrame

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, spacing)

    tabContents[name] = content
end

-- ✅ Show tab function
local function showTab(name)
    for n, f in pairs(tabContents) do
        f.Visible = (n == name)
    end
    currentTab = name
end

-- ✅ Tab button connections
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

-- ✅ Button creator
local function createToggleButton(name, tab, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, buttonHeight)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Parent = tabContents[tab]

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        btn.BackgroundColor3 = toggled and themeColor or Color3.fromRGB(40, 40, 40)
        callback(toggled)
    end)
end

-- ✅ Aimbot logic placeholder (you can replace with working logic)
createToggleButton("Aimbot", "Aimbot", function(state)
    print("[Aimbot] Toggled:", state)
    -- Insert working aimbot logic here
end)

createToggleButton("Auto Shoot", "Aimbot", function(state)
    print("[Auto Shoot] Toggled:", state)
    -- Insert auto-shoot logic here
end)

-- ✅ Visuals (placeholder)
createToggleButton("Highlight Ball", "Visuals", function(state)
    print("[Visuals] Highlight Ball:", state)
end)

-- ✅ Misc (placeholder)
createToggleButton("Auto Green", "Misc", function(state)
    print("[Misc] Auto Green:", state)
end)

-- ✅ Settings (color picker placeholder)
createToggleButton("Change Theme (Not functional)", "Settings", function()
    print("[Settings] Theme change requested")
end)

-- ✅ Credits section
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -25)
credit.Text = "Made by extractly-1"
credit.TextColor3 = Color3.fromRGB(170, 170, 170)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.SourceSans
credit.TextSize = 14
credit.Parent = mainFrame

-- ✅ Show Aimbot tab by default
showTab("Aimbot")
