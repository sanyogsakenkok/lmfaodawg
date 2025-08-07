local function ttl(message)
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local existingErrorGui = playerGui:FindFirstChild("TitleOverlay")

    if existingErrorGui then
        existingErrorGui:Destroy()
    end
    -- title start
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TitleOverlay"
    screenGui.DisplayOrder = 99999
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.Text = message
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 50
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = screenGui
    task.wait(3)
    screenGui:Destroy()
    -- title end
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local oldGui = PlayerGui:FindFirstChild("KillerInfoGui")
if oldGui then
    oldGui:Destroy()
end
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillerInfoGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = PlayerGui
local label = Instance.new("TextLabel")
label.Name = "InfoLabel"
label.Size = UDim2.new(1, 0, 0, 60)
label.Position = UDim2.new(0, 0, 0.1, 0)
label.BackgroundTransparency = 1
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSansBold
label.TextStrokeTransparency = 0.5
label.TextStrokeColor3 = Color3.new(0, 0, 0)
label.Text = "Loading..."
label.ZIndex = 10
label.Parent = screenGui
local killerPlayer = nil
for _, player in pairs(Players:GetPlayers()) do
    if player:GetAttribute("Team") == "Killer" then
        killerPlayer = player
        break
    end
end
if killerPlayer and killerPlayer:FindFirstChild("Data") then
    local data = killerPlayer.Data
    local killerName = killerPlayer.Name
    local killerType = data:FindFirstChild("Killer") and data.Killer.Value or "Unknown"
    local addon1 = "None"
    local addon2 = "None"
    local addonsFolder = data:FindFirstChild("Addons") and data.Addons:FindFirstChild("Killer")
    if addonsFolder then
        local slot1 = addonsFolder:FindFirstChild("Slot1")
        local slot2 = addonsFolder:FindFirstChild("Slot2")
        if slot1 and slot1.Value ~= "" then addon1 = slot1.Value end
        if slot2 and slot2.Value ~= "" then addon2 = slot2.Value end
    end
    local perksText = "None"
    local perks = {}
    local perksFolder = data:FindFirstChild("Perks") and data.Perks:FindFirstChild("Killer")
    if perksFolder then
        for _, perk in ipairs(perksFolder:GetChildren()) do
            if perk:IsA("IntValue") and perk.Value > 0 then
                table.insert(perks, perk.Name .. "(" .. perk.Value .. ")")
            end
        end
        if #perks > 0 then
            perksText = table.concat(perks, ", ")
        end
    end
    label.Text = string.format("%s(%s) - %s, %s\n%s", killerName, killerType, addon1, addon2, perksText)
else
    label.Text = "Killer not found"
end
if not _G.request then
    error("no request accepted(you maybe banned)")
end
local allright = false
local loaded = false
game.StarterGui:SetCore("SendNotification", { 
    Title = "Anal Destroyer",
    Text = "initialize...",
    Duration = 2
})
while game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("LoadScreen") do
    task.wait(0.1)
end
local oldGui = PlayerGui:FindFirstChild("KillerInfoGui")
if oldGui then
    oldGui:Destroy()
end
loaded = true
task.spawn(function ()
    while true do
        if loaded then
            task.wait(6)
            if not allright then
                ttl("Script started with some errors!")
                game.StarterGui:SetCore("SendNotification", { 
                    Title = "Error Debug",
                    Text = "Errors was found while starting script! Check console (F9)",
                    Duration = 5
                })
            end
            break
        end
        task.wait()
    end
end)
-- CFG
_G.Config = {
	skeleton = false,
	autoWiggleType = "Normal",
	players = false,
    input_TargetSurvName = "FurySex",
    enable_ObjectsDistance = false,
    unblock_window = "OFF",
    remoteIntType1 = "Rescue",
    remoteIntType2 = "Hooks",
	enabled_PalletExploit = false,
	dash_type = "rage",
	m1_enabled = false,
	mw_Type = "Backward",
	kick_fw = 40,
	kick_up = 35
} 
local FieldOfView_Value = 95
local RedStain_R = 1
local RedStain_G = 1
local RedStain_B = 1
-----------------------
-- ESP
-----------------------
local esp_link = "https://raw.githubusercontent.com/sanyogsakenkok/lmfaodawg/refs/heads/main/06082025/espnewfix2.lua?v=" .. tostring(tick())
local func_link = "https://raw.githubusercontent.com/sanyogsakenkok/lmfaodawg/refs/heads/main/06082025/funcnew.lua?v=" .. tostring(tick())

loadstring(game:HttpGet(esp_link, true))()
loadstring(game:HttpGet(func_link, true))()
----------------------------
-- Selector!
local Camera = workspace.CurrentCamera
local circle = Drawing.new("Circle")
circle.Visible = true
circle.Color = Color3.new(1,1,1)
circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
circle.Radius = 50
circle.Thickness = 1
local function findTargetInCircle()
    local closestPlayer, smallestDistance = nil, circle.Radius
    local localPlayer = game:GetService("Players").LocalPlayer
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoidRootPart then
                local screenPosition, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - circle.Position).Magnitude
                    
                    if distance <= circle.Radius and distance < smallestDistance then
                        smallestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C then
        local target = findTargetInCircle()
        if target then
            _G.Config.input_TargetSurvName = target.Name
        else
            warn("[SELECTOR] No one founded in Circle!")
        end
    end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

if game:GetService("CoreGui"):FindFirstChild("AnalDestroyerGUI") then
	game:GetService("CoreGui"):FindFirstChild("AnalDestroyerGUI"):Destroy()
end
if game:GetService("CoreGui"):FindFirstChild("MiniHeader") then
	game:GetService("CoreGui"):FindFirstChild("MiniHeader"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniHeader"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(0, 260, 0, 80)
HeaderFrame.Position = UDim2.new(1, -270, 0, 10)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
HeaderFrame.BackgroundTransparency = 0.3
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "Anal Destroyer v4.0.3"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = HeaderFrame
Title.TextColor3 = Color3.fromRGB(0, 153, 255)

local Underline = Instance.new("Frame")
Underline.Size = UDim2.new(0.9, 0, 0, 2)
Underline.Position = UDim2.new(0.05, 0, 0, 30)
Underline.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
Underline.BorderSizePixel = 0
Underline.Parent = HeaderFrame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -20, 0, 20)
Subtitle.Position = UDim2.new(0, 10, 0, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "« Destroy DBR or Make it Fun! »"
Subtitle.TextColor3 = Color3.new(1, 1, 1)
Subtitle.Font = Enum.Font.SourceSans
Subtitle.TextSize = 16
Subtitle.TextXAlignment = Enum.TextXAlignment.Center
Subtitle.Parent = HeaderFrame

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, -20, 0, 20)
TargetLabel.Position = UDim2.new(0, 10, 0, 57)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target: FurySex"
TargetLabel.TextColor3 = Color3.new(1, 1, 1)
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.TextSize = 14
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = HeaderFrame

game:GetService("RunService").RenderStepped:Connect(function()
	if _G.Config.input_TargetSurvName then
		TargetLabel.Text = "Target: " .. _G.Config.input_TargetSurvName
	else
		TargetLabel.Text = "Target: FurySex"
	end
end)

local TweenService = game:GetService("TweenService")
local BLUE_COLOR = Color3.fromRGB(0, 153, 255)
local INACTIVE_TAB_COLOR = Color3.fromRGB(40, 40, 40)
local HOVER_TAB_COLOR = Color3.fromRGB(60, 60, 60)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnalDestroyerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "Anal Destroyer v4.0.3"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.TextColor3 = BLUE_COLOR
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Панель вкладок
local Tabs = {"ESP", "Functions", "Misc", "Console"}
local CurrentTab = "ESP"
local TabButtons = {}
local TabContentFrames = {}

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.Parent = MainFrame
local function tweenTabColor(button, targetColor)
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = targetColor})
    tween:Play()
end
local function updateTabHighlights()
    for tabName, button in pairs(TabButtons) do
        if tabName == CurrentTab then
            tweenTabColor(button, BLUE_COLOR)
            button.TextColor3 = Color3.new(1, 1, 1)
        else
            tweenTabColor(button, INACTIVE_TAB_COLOR)
            button.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end
for i, name in ipairs(Tabs) do
    local Button = Instance.new("TextButton")
    Button.Name = name.."Tab"
    Button.Text = name
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Position = UDim2.new(0, 0, 0, (i - 1) * 45)
    Button.BackgroundColor3 = INACTIVE_TAB_COLOR
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 18
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    Button.MouseEnter:Connect(function()
        if CurrentTab ~= name then
            tweenTabColor(Button, HOVER_TAB_COLOR)
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if CurrentTab ~= name then
            tweenTabColor(Button, INACTIVE_TAB_COLOR)
        end
    end)

    Button.MouseButton1Click:Connect(function()
        CurrentTab = name
        updateTabHighlights()
        for tab, frame in pairs(TabContentFrames) do
            frame.Visible = (tab == name)
        end
    end)
    
    TabButtons[name] = Button
end

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -50)
ContentFrame.Position = UDim2.new(0, 120, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.Parent = MainFrame

updateTabHighlights()

--------------------------
-- ESP
--------------------------
local ESPFrame = Instance.new("Frame")
ESPFrame.Size = UDim2.new(1, 0, 1, 0)
ESPFrame.BackgroundTransparency = 1
ESPFrame.Visible = true
ESPFrame.Parent = ContentFrame
TabContentFrames["ESP"] = ESPFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Scroll.ClipsDescendants = true
Scroll.Parent = ESPFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Scroll

local ESPFunctions = {
    { Name = "Objects Distance" },
	{ Name = "Players" },
	{ Name = "Skeleton" },
    { Name = "Generators" },
	{ Name = "Pallets" },
	{ Name = "Windows" },
    { Name = "Traps" },
	{ Name = "Hatch" },
	{ Name = "Exit Gates" },
	{ Name = "Hooks" },
	{ Name = "Chests" },
	{ Name = "Totems" },
	{ Name = "Lockers" },
}

for _, func in ipairs(ESPFunctions) do
	local functionName = func.Name
	local safeKey = functionName:gsub(" ", "")
	local enabled = false

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -10, 0, 30)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = _
	Row.Parent = Scroll

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = functionName
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.Font = Enum.Font.SourceSans
	Label.TextSize = 18
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Toggle = Instance.new("TextButton")
	Toggle.Size = UDim2.new(0, 60, 0, 30)
	Toggle.Position = UDim2.new(1, -70, 0, 0)
	Toggle.AnchorPoint = Vector2.new(1, 0)
	Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	Toggle.Text = "OFF"
	Toggle.TextColor3 = Color3.new(1, 1, 1)
	Toggle.Font = Enum.Font.SourceSansBold
	Toggle.TextSize = 16
	Toggle.Parent = Row

	Toggle.MouseButton1Click:Connect(function()
		enabled = not enabled
		Toggle.Text = enabled and "ON" or "OFF"
		Toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 153, 255) or Color3.fromRGB(80, 80, 80)
        if functionName == "Players" then
            TogglePlayersESP(enabled)
			_G.Config.players = enabled
        end

        if functionName == "Objects Distance" then
            _G.Config.enable_ObjectsDistance = enabled
        end
		if functionName == "Skeleton" then
			if enabled then
				_G.Config.skeleton = true
			else
				_G.Config.skeleton = false
				if _G.Config.players then
					TogglePlayersESP(false)
					TogglePlayersESP(true)
				end
			end
		end
        if functionName == "Traps" then
            if enabled then
                enableObjectESP("Trap", "Trap", Color3.fromRGB(255, 0, 0))
            else
                disableObjectESP("Trap")
            end
        end
        if functionName == "Pallets" then
			if enabled then
				enableObjectESP("Pallet", "Pallet", Color3.fromRGB(255, 230, 0))
			else
				disableObjectESP("Pallet")
			end
		end
        if functionName == "Windows" then
			if enabled then
				enableObjectESP("Window", "Window", Color3.fromRGB(255, 120, 0))
			else
				disableObjectESP("Window")
			end
		end
		if functionName == "Hatch" then
            if enabled then
                enableObjectESP("Hatch", "Hatch", Color3.new(1, 1, 1))
            else
                disableObjectESP("Hatch")
            end
        end

        if functionName == "Exit Gates" then
            if enabled then
                enableObjectESP("ExitGate", "Exit Gate", Color3.fromRGB(143, 251, 140))
            else
                disableObjectESP("ExitGate")
            end
        end

        if functionName == "Hooks" then
            if enabled then
                enableObjectESP("Hook", "Hook", Color3.fromRGB(255, 0, 147))
            else
                disableObjectESP("Hook")
            end
        end

        if functionName == "Chests" then
            if enabled then
                enableObjectESP("Chest", "Chest", Color3.fromRGB(144, 104, 255))
            else
                disableObjectESP("Chest")
            end
        end

        if functionName == "Totems" then
            if enabled then
                enableObjectESP("Totem", "Totem", Color3.fromRGB(0, 169, 255))
            else
                disableObjectESP("Totem")
            end
        end

        if functionName == "Lockers" then
            if enabled then
                enableObjectESP("Hiding_Spot_", "Locker", Color3.fromRGB(255, 164, 255))
            else
                disableObjectESP("Hiding_Spot_")
            end
        end

        if functionName == "Generators" then
            if enabled then
                enableObjectESP("Generator", "Generator", Color3.fromRGB(164, 164, 255))
            else
                disableObjectESP("Generator")
            end
        end
	end)
end

--------------------------
-- ВКЛАДКА: Functions
--------------------------
local FunctionsFrame = Instance.new("Frame")
FunctionsFrame.Size = UDim2.new(1, 0, 1, 0)
FunctionsFrame.BackgroundTransparency = 1
FunctionsFrame.Visible = false
FunctionsFrame.Parent = ContentFrame
TabContentFrames["Functions"] = FunctionsFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Scroll.ClipsDescendants = true
Scroll.Parent = FunctionsFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

local layoutOrder = 0
local function CreateHeader(text)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -10, 0, 30)
	header.BackgroundTransparency = 1
	header.Text = "   " .. text
	header.TextColor3 = Color3.fromRGB(100, 170, 255)
	header.Font = Enum.Font.SourceSansBold
	header.TextSize = 20
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.LayoutOrder = layoutOrder
	layoutOrder += 1
	header.Parent = Scroll

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -10, 0, 2)
	line.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	line.BorderSizePixel = 0
	line.LayoutOrder = layoutOrder
	layoutOrder += 1
	line.Parent = Scroll
end
local function CreateNumberInput(name, default)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -10, 0, 30)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = layoutOrder
	layoutOrder += 1
	Row.Parent = Scroll

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = name
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.Font = Enum.Font.SourceSans
	Label.TextSize = 18
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Box = Instance.new("TextBox")
	Box.Size = UDim2.new(0, 120, 0, 30)
	Box.Position = UDim2.new(1, -130, 0, 0)
	Box.AnchorPoint = Vector2.new(1, 0)
	Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Box.TextColor3 = Color3.new(1, 1, 1)
	Box.Text = tostring(default)
	Box.ClearTextOnFocus = false
	Box.Font = Enum.Font.SourceSans
	Box.TextSize = 18
	Box.TextXAlignment = Enum.TextXAlignment.Center
	Box.Parent = Row

	Box.FocusLost:Connect(function()
		local num = tonumber(Box.Text:match("%d+"))
		if num then
			Box.Text = tostring(num)
			if variableSetters[name] then
				variableSetters[name](num)
			end
		else
			Box.Text = tostring(default)
		end
	end)
end

-- Переключатели и селекты
local ToggleSelectFunctions = {
	{ Name = "Pallet Exploit", Options = {"ON", "OFF"}, Default = "OFF" },
	{ Name = "Auto Wiggle Type", Options = {"Normal", "Insta" }, Default = "Normal" },
    { Name = "Remote Interaction #1", Options = {"Rescue", "Exit Gates", "Hooks", "Generators"}, Default = "Rescue" },
    { Name = "Remote Interaction #2", Options = {"Rescue", "Exit Gates", "Hooks", "Generators"}, Default = "Hooks" },
    { Name = "Unblock Window", Options = {"ON", "OFF"}, Default = "OFF" },
    { Name = "Block All Windows", Options = {"ON", "OFF"}, Default = "OFF" },
	{ Name = "Show Blind Progress", Options = { "ON", "OFF" }, Default = "OFF" },
	{ Name = "Show Blind Zone", Options = { "ON", "OFF" }, Default = "OFF" }
}

local function CreateToggleSelect(func)
	local functionName = func.Name
	local options = func.Options
	local default = func.Default or options[1]
	local safeKey = functionName:gsub(" ", "")

	local currentIndex = table.find(options, default) or 1

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -10, 0, 30)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = layoutOrder
	layoutOrder += 1
	Row.Parent = Scroll

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = functionName
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.Font = Enum.Font.SourceSans
	Label.TextSize = 18
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0, 120, 0, 30)
	Button.Position = UDim2.new(1, -130, 0, 0)
	Button.AnchorPoint = Vector2.new(1, 0)
	Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Font = Enum.Font.SourceSansBold
	Button.TextSize = 16
	Button.Text = options[currentIndex]
	Button.Parent = Row

    -- WAI WAN ZECAND
    local Players = game:GetService("Players")
    local function getKillerPlayerName()
        for _, player in pairs(Players:GetPlayers()) do
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local scriptsFolder = backpack:FindFirstChild("Scripts")
                if scriptsFolder then
                    local killerValue = scriptsFolder:FindFirstChild("Killer")
                    if killerValue and killerValue.Value == true then
                        return player.Name
                    end
                end
            end
        end
        return nil
    end
    local function setFlashZoneTransparency(transparencyValue)
        local killerName = getKillerPlayerName()
        if killerName then
            local killerModel = workspace:FindFirstChild(killerName)
            if killerModel then
                local flashZone = killerModel:FindFirstChild("Flash_Zone")
                if flashZone and flashZone:IsA("BasePart") then
                    flashZone.Transparency = transparencyValue
                end
            end
        end
    end
    -- THANKZ CHELIGG

	Button.MouseButton1Click:Connect(function()
		currentIndex += 1
		if currentIndex > #options then
			currentIndex = 1
		end
		local selected = options[currentIndex]
		Button.Text = selected
		if safeKey == "ShowBlindZone" then
			if selected == "ON" then
                setFlashZoneTransparency(0)
			else
				setFlashZoneTransparency(1)
			end
		elseif safeKey == "RemoteInteraction#1" then
			_G.Config.remoteIntType1 = selected
		elseif safeKey == "RemoteInteraction#2" then
			_G.Config.remoteIntType2 = selected
		elseif safeKey == "AutoWiggleType" then
			_G.Config.autoWiggleType = selected
        elseif safeKey == "UnblockWindow" then
            _G.Config.unblock_window = selected
		elseif safeKey == "BlockAllWindows" then
			if selected == "ON" then
				BlockAllWindows(true)
			else
				BlockAllWindows(false)
			end
		elseif safeKey == "PalletExploit" then
			if selected == "ON" then
				_G.Config.enabled_PalletExploit = true	
			else
				_G.Config.enabled_PalletExploit = false
			end
		elseif safeKey == "ShowBlindProgress" then
			if selected == "ON" then
				local Players = game:GetService("Players")
				local player = Players.LocalPlayer
				local playerGui = player:WaitForChild("PlayerGui")
				local existingGui = playerGui:FindFirstChild("KillerBlindStatusGui")
				if existingGui then
					existingGui:Destroy()
				end
				local RunService = game:GetService("RunService")
				local screenGui = Instance.new("ScreenGui")
				screenGui.Name = "KillerBlindStatusGui"
				screenGui.Parent = playerGui
				local mainFrame = Instance.new("Frame", screenGui)
				mainFrame.Size = UDim2.new(0, 200, 0, 60)
				mainFrame.Position = UDim2.new(0.5, 0, 0, 10)
				mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				mainFrame.BackgroundTransparency = 0.3
				mainFrame.BorderSizePixel = 0
				mainFrame.AnchorPoint = Vector2.new(0.5, 0)
				mainFrame.Visible = false
				local label = Instance.new("TextLabel", mainFrame)
				label.Size = UDim2.new(1, 0, 0, 20)
				label.Position = UDim2.new(0, 0, 0, 0)
				label.BackgroundTransparency = 1
				label.Text = "Killer's Blind Status:"
				label.TextColor3 = Color3.new(1, 1, 1)
				label.Font = Enum.Font.SourceSansBold
				label.TextSize = 18
				local barBg = Instance.new("Frame", mainFrame)
				barBg.Size = UDim2.new(1, -20, 0, 20)
				barBg.Position = UDim2.new(0, 10, 0, 30)
				barBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				barBg.BorderSizePixel = 0
				barBg.AnchorPoint = Vector2.new(0, 0)
				local barFill = Instance.new("Frame", barBg)
				barFill.Size = UDim2.new(0, 0, 1, 0)
				barFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
				barFill.BorderSizePixel = 0
				local percentText = Instance.new("TextLabel", barBg)
				percentText.Size = UDim2.new(1, 0, 1, 0)
				percentText.BackgroundTransparency = 1
				percentText.TextColor3 = Color3.new(1, 1, 1)
				percentText.Font = Enum.Font.SourceSansBold
				percentText.TextSize = 14
				percentText.Text = "0%"
				percentText.TextStrokeTransparency = 0.5
				percentText.TextStrokeColor3 = Color3.new(0, 0, 0)
				local function updateStatus()
					local players = Players:GetPlayers()
					for _, plr in ipairs(players) do
						local backpack = plr:FindFirstChild("Backpack")
						if backpack then
							local scriptsFolder = backpack:FindFirstChild("Scripts")
							if scriptsFolder then
								local killerValue = scriptsFolder:FindFirstChild("Killer")
								if killerValue and killerValue.Value == true then
									local blindScript = scriptsFolder:FindFirstChild("BlindScript")
									if blindScript then
										local brightnessValue = blindScript:FindFirstChild("Brightness")
										if brightnessValue and brightnessValue:IsA("StringValue") then
											local brightnessNum = tonumber(brightnessValue.Value) or 0
											brightnessNum = math.clamp(brightnessNum, 0, 100)
											mainFrame.Visible = true
											barFill.Size = UDim2.new(brightnessNum / 100, 0, 1, 0)
											percentText.Text = math.floor(brightnessNum) .. "%"
											return
										end
									end
								end
							end
						end
					end
					mainFrame.Visible = false
				end

				RunService.Heartbeat:Connect(updateStatus)
			elseif selected == "OFF" then
				local Players = game:GetService("Players")
				local player = Players.LocalPlayer
				local playerGui = player:WaitForChild("PlayerGui")
				local existingGui = playerGui:FindFirstChild("KillerBlindStatusGui")
				if existingGui then
					existingGui:Destroy()
				end
			end
		end
	end)
end
CreateHeader("Remote Interactions")
for _, func in ipairs(ToggleSelectFunctions) do
	if func.Name == "Remote Interaction #1" or func.Name == "Remote Interaction #2" then
		CreateToggleSelect(func)
	end
end
CreateHeader("Environment Exploits")
for _, func in ipairs(ToggleSelectFunctions) do
    if func.Name == "Unblock Window" or func.Name == "Block All Windows" or func.Name == "Pallet Exploit" or func.Name == "Auto Wiggle Type" then
        CreateToggleSelect(func)
    end
end
CreateHeader("Flashlight")
for _, func in ipairs(ToggleSelectFunctions) do
	if func.Name == "Show Blind Progress" or func.Name == "Show Blind Zone" then
		CreateToggleSelect(func)
	end
end
--------------------------
-- Misc
--------------------------
local MiscFrame = Instance.new("Frame")
MiscFrame.Size = UDim2.new(1, 0, 1, 0)
MiscFrame.BackgroundTransparency = 1
MiscFrame.Visible = false
MiscFrame.Parent = ContentFrame
TabContentFrames["Misc"] = MiscFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Scroll.ClipsDescendants = true
Scroll.Parent = MiscFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

local layoutOrder = 0

local InputHeader = Instance.new("TextLabel")
InputHeader.Size = UDim2.new(1, -10, 0, 30)
InputHeader.BackgroundTransparency = 1
InputHeader.Text = "   REDSTAIN CHANGER"
InputHeader.TextColor3 = Color3.fromRGB(100, 170, 255)
InputHeader.Font = Enum.Font.SourceSansBold
InputHeader.TextSize = 20
InputHeader.TextXAlignment = Enum.TextXAlignment.Left
InputHeader.LayoutOrder = 2
layoutOrder += 1
InputHeader.Parent = Scroll

do
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 40)
    Row.BackgroundTransparency = 1
    Row.LayoutOrder = _
    Row.Parent = Scroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 80, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "FOV"
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -160, 0, 10)
    Slider.Position = UDim2.new(0, 100, 0.5, -5)
    Slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Slider.BorderSizePixel = 0
    Slider.Parent = Row

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((FieldOfView_Value - 70)/50, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Fill.BorderSizePixel = 0
    Fill.Parent = Slider

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 1, 0)
    ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(FieldOfView_Value)
    ValueLabel.TextColor3 = Color3.new(1, 1, 1)
    ValueLabel.Font = Enum.Font.SourceSans
    ValueLabel.TextSize = 18
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Row

    local dragging = false
    local UIS = game:GetService("UserInputService")
	local camera = workspace.CurrentCamera

    local function updateSlider(x)
		local relX = math.clamp((x - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
		local value = math.floor(70 + (relX * 50) + 0.5)
		Fill.Size = UDim2.new(relX, 0, 1, 0)
		ValueLabel.Text = tostring(value)
		FieldOfView_Value = value
	end
	game:GetService("RunService").RenderStepped:Connect(function()
		if camera and camera.FieldOfView ~= FieldOfView_Value then
			camera.FieldOfView = FieldOfView_Value
		end
	end)

    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end
-- Vault Speed 
do
	local VaultSpeed_Value = 0.5
	pcall(function()
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local MatchPlayers = ReplicatedStorage:WaitForChild("Match"):WaitForChild("Players")
		local PlayerData = MatchPlayers:FindFirstChild(LocalPlayer.Name)
		local Movement = PlayerData and PlayerData:FindFirstChild("Movement")
		local speed = Movement and Movement:GetAttribute("WindowVaultSpeed")
		if speed then
			VaultSpeed_Value = speed
		end
	end)

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -10, 0, 40)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = layoutOrder
	layoutOrder += 1
	Row.Parent = Scroll

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 120, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = "Vault Speed"
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.Font = Enum.Font.SourceSans
	Label.TextSize = 18
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Slider = Instance.new("Frame")
	Slider.Size = UDim2.new(1, -180, 0, 10)
	Slider.Position = UDim2.new(0, 130, 0.5, -5)
	Slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	Slider.BorderSizePixel = 0
	Slider.Parent = Row

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new((VaultSpeed_Value - 0.1)/1.55, 0, 1, 0)
	Fill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
	Fill.BorderSizePixel = 0
	Fill.Parent = Slider

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(0, 50, 1, 0)
	ValueLabel.Position = UDim2.new(1, -50, 0, 0)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Text = string.format("%.2f", VaultSpeed_Value)
	ValueLabel.TextColor3 = Color3.new(1, 1, 1)
	ValueLabel.Font = Enum.Font.SourceSans
	ValueLabel.TextSize = 18
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = Row

	local dragging = false
	local UIS = game:GetService("UserInputService")

	local function updateVaultSpeed(x)
		local relX = math.clamp((x - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
		local value = 0.1 + relX * 1.55
		VaultSpeed_Value = tonumber(string.format("%.2f", value))
		Fill.Size = UDim2.new(relX, 0, 1, 0)
		ValueLabel.Text = string.format("%.2f", VaultSpeed_Value)
		pcall(function()
			local Players = game:GetService("Players")
			local LocalPlayer = Players.LocalPlayer
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local MatchPlayers = ReplicatedStorage:WaitForChild("Match"):WaitForChild("Players")
			local PlayerData = MatchPlayers:FindFirstChild(LocalPlayer.Name)
			local Movement = PlayerData and PlayerData:FindFirstChild("Movement")
			if Movement and Movement:GetAttribute("WindowVaultSpeed") ~= nil then
				Movement:SetAttribute("WindowVaultSpeed", VaultSpeed_Value)
			end
		end)
	end

	Slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateVaultSpeed(input.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateVaultSpeed(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end
-- RGB Color Picker
do
	local defaultR, defaultG, defaultB = 255, 255, 255
	RedStain_R, RedStain_G, RedStain_B = defaultR, defaultG, defaultB

	local Preview

	local function UpdatePreview()
		if Preview then
			local color = Color3.fromRGB(RedStain_R, RedStain_G, RedStain_B)
			Preview.BackgroundColor3 = color
		end
	end

	local function CreateSlider(name, default, onChanged)
		local Frame = Instance.new("Frame")
		Frame.Size = UDim2.new(1, -10, 0, 40)
		Frame.BackgroundTransparency = 1
		Frame.LayoutOrder = layoutOrder
		layoutOrder += 1

		local Label = Instance.new("TextLabel")
		Label.Size = UDim2.new(0, 30, 1, 0)
		Label.Position = UDim2.new(0, 10, 0, 0)
		Label.BackgroundTransparency = 1
		Label.Text = name
		Label.TextColor3 = Color3.new(1, 1, 1)
		Label.Font = Enum.Font.SourceSans
		Label.TextSize = 18
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = Frame

		local Slider = Instance.new("Frame")
		Slider.Size = UDim2.new(1, -80, 0, 10)
		Slider.Position = UDim2.new(0, 45, 0.5, -5)
		Slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		Slider.BorderSizePixel = 0
		Slider.Parent = Frame

		local Fill = Instance.new("Frame")
		Fill.Size = UDim2.new(default / 255, 0, 1, 0)
		Fill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		Fill.BorderSizePixel = 0
		Fill.Parent = Slider

		local ValueLabel = Instance.new("TextLabel")
		ValueLabel.Size = UDim2.new(0, 40, 1, 0)
		ValueLabel.Position = UDim2.new(1, -40, 0, 0)
		ValueLabel.BackgroundTransparency = 1
		ValueLabel.Text = tostring(default)
		ValueLabel.TextColor3 = Color3.new(1, 1, 1)
		ValueLabel.Font = Enum.Font.SourceSans
		ValueLabel.TextSize = 18
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
		ValueLabel.Parent = Frame

		local dragging = false
		local function updateInput(x)
			local relX = math.clamp((x - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
			local value = math.floor(relX * 255 + 0.5)
			Fill.Size = UDim2.new(relX, 0, 1, 0)
			ValueLabel.Text = tostring(value)
			onChanged(value)
			UpdatePreview()
		end

		Slider.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				updateInput(input.Position.X)
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				updateInput(input.Position.X)
			end
		end)

		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		return Frame
	end

	local RSlider = CreateSlider("R", defaultR, function(val)
		RedStain_R = val
	end)
	RSlider.Parent = Scroll

	local GSlider = CreateSlider("G", defaultG, function(val)
		RedStain_G = val
	end)
	GSlider.Parent = Scroll

	local BSlider = CreateSlider("B", defaultB, function(val)
		RedStain_B = val
	end)
	BSlider.Parent = Scroll

	Preview = Instance.new("Frame")
	Preview.Size = UDim2.new(1, -10, 0, 40)
	Preview.BackgroundColor3 = Color3.fromRGB(defaultR, defaultG, defaultB)
	Preview.BorderColor3 = Color3.new(0, 0, 0)
	Preview.BorderSizePixel = 1
	Preview.LayoutOrder = layoutOrder
	layoutOrder += 1
	Preview.Parent = Scroll
end
--------------------------
-- КОНСОЛЬ
--------------------------
local ConsoleFrame = Instance.new("Frame")
ConsoleFrame.Size = UDim2.new(1, 0, 1, 0)
ConsoleFrame.BackgroundTransparency = 1
ConsoleFrame.Visible = false
ConsoleFrame.Parent = ContentFrame
TabContentFrames["Console"] = ConsoleFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Scroll.ClipsDescendants = true
Scroll.Parent = ConsoleFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

local layoutOrder = 0

local function CreateConsoleInput(name, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -10, 0, 30)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = layoutOrder
	layoutOrder += 1
	Row.Parent = Scroll

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.3, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = name or "Command"
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.Font = Enum.Font.SourceSans
	Label.TextSize = 18
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Box = Instance.new("TextBox")
	Box.Size = UDim2.new(0, 200, 0, 30)
	Box.Position = UDim2.new(1, -140, 0, 0)
	Box.AnchorPoint = Vector2.new(1, 0)
	Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Box.TextColor3 = Color3.new(1, 1, 1)
	Box.Text = ""
	Box.ClearTextOnFocus = false
	Box.Font = Enum.Font.SourceSans
	Box.TextSize = 18
	Box.TextXAlignment = Enum.TextXAlignment.Left
	Box.PlaceholderText = "enter command..."
	Box.Parent = Row

	local Execute = Instance.new("TextButton")
	Execute.Size = UDim2.new(0, 60, 0, 30)
	Execute.Position = UDim2.new(1, -70, 0, 0)
	Execute.AnchorPoint = Vector2.new(1, 0)
	Execute.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	Execute.Text = "Execute"
	Execute.TextColor3 = Color3.new(1, 1, 1)
	Execute.Font = Enum.Font.SourceSansBold
	Execute.TextSize = 16
	Execute.Parent = Row

	Execute.MouseButton1Click:Connect(function()
		local input = Box.Text
		if input ~= "" then
			local args = {}
			for word in input:gmatch("%S+") do
				table.insert(args, word)
			end
			local command = args[1]
			table.remove(args, 1)
			if callback then
				callback(command, unpack(args))
			end
		end
	end)
end
CreateConsoleInput("Command", function(command, ...)
	print("executing:", command)
	local args = {...}
	for i, arg in ipairs(args) do
		print("arg" .. i .. ":", arg)
	end
	if command == "openalllockers" or command == "oal" then
		local amount = tonumber(args[1])
		local sleep = tonumber(args[2])
        local i = 0
		if amount > 0 and sleep > 0.09 then
			while i < amount do
				i += 1
				OpenAllLockers()
				task.wait(sleep)
			end
		end
    elseif command == "tp" then
        local arg = tostring(args[1])
        local arg2 = tostring(args[2])
        if arg == "template" or arg == "secretplace" or arg == "place" or arg == "secret" or arg == "sp" then
            teleportToTemplate()
        elseif arg == "hatch" or arg == "ht" then
            teleportToHatch()
        elseif arg == "exitgate" or arg == "exit" or arg == "gate" or arg == "gates" then
            if arg2 == "true" or arg2 == "t" or arg2 == "1" then
                teleportToExitGate(true)
			elseif arg2 == "false" or arg2 == "f" or arg2 == "2" then
                teleportToExitGate(false)
			else
				ttl("Wrong arg2:", arg2)
				warn("[CONSOLE] Unknown arg2 '" .. arg2 .. "' in command '" .. command .. "' with arg1 '" .. arg .. "'!")
            end
        elseif arg == "killer" or arg == "klr" or arg == "enemy" or arg == "gay" then
            teleportToKiller()
        elseif arg == "survivor" or arg == "surv" or arg == "srv" or arg == "allie" or arg == "god" then
            teleportToSurv()
		else
			ttl("Wrong arg1:", arg)
			warn("[CONSOLE] Unknown arg '" .. arg .. "' in command '" .. command .. "'!")
        end
    elseif command == "blessalltotems" or command == "bat" then
        BlessAllTotems()
	elseif command == "grabsurvivor" or command == "grab" or command == "gs" then
		GrabSurvivor()
	elseif command == "hooksurvivor" or command == "hook" or command == "hk" then
		HookSurvivor()
	elseif command == "kickallgenerators" or command == "kickallgens" or command == "kag" then
		KickAllGenerators()
	elseif command == "escape" then
		escape()
	elseif command == "breakallpallets" or command == "bap" then
		BreakAllPallets()
	elseif command == "moonwalk" or command == "mw" then
		local type = tostring(args[1])
		if type == "backward" or type == "bw" then
			_G.Config.mw_Type = "Backward"
		elseif type == "forward" or type == "fw" then
			_G.Config.mw_Type = "Forward"
		elseif type == "leftside" or type == "left" or type == "ls" then
			_G.Config.mw_Type = "Left Side"
		elseif type == "rightside" or type == "right" or type == "rs" then
			_G.Config.mw_Type = "Right Side"
		else
			ttl("Wrong arg1:", arg)
			warn("[CONSOLE] Unknown arg '" .. arg .. "' in command '" .. command .. "'!")
		end
	elseif command == "dashtype" or command == "dash" then
		local arg = tonumber(args[2])
		local arg2 = tonumber(args[3])
		local type = tostring(args[1])
		if type == "rage" then
			_G.Config.dash_type = "rage"
		elseif type == "kick" then
			_G.Config.dash_type = "kick"
			_G.Config.kick_fw = 40
			_G.Config.kick_up = 35
			 pcall(function()
                if arg ~= nil and arg < 41 then
                    _G.Config.kick_fw = arg
                end
                if arg2 ~= nil then
                    _G.Config.kick_up = arg2
                end
            end)
		else
			ttl("Wrong arg1:", arg)
			warn("[CONSOLE] Unknown arg '" .. arg .. "' in command '" .. command .. "'!")
		end
	elseif command == "m1" then
		_G.Config.m1_enabled = not _G.Config.m1_enabled
		ttl(command .. " = " .. _G.Config.m1_enabled)
	elseif command == "dosound" or command == "ds" then
		local sound = tostring(args[1])
		local volume = tonumber(args[2])
		local amount = tonumber(args[3])
		local sleep = tonumber(args[4])
		local i = 0
		if sound ~= nil and volume ~= nil and amount ~= nil and sleep ~= nil and volume > 0 and amount > 0 and sleep > 0.09 then
			while i < amount do
				i += 1
				DoSound(sound, volume)
				task.wait(sleep)
			end
		else
			ttl("DoSound crashed!")
			warn("[CONSOLE] DoSound cannot work with args. sound: '" .. sound .. "', volume: '" .. volume .. "', amount: '" .. amount .. "', sleep: '" .. sleep .. "'!")
		end
	else
		ttl("Unknown command!")
		warn("[CONSOLE] Unknown command '" .. command .. "'! Check list of commands in our Discord.")
	end
end)
--------------------------
-- ФУНКЦИИ
--------------------------
local function hsvToRgb(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q end
    return r, g, b
end
-- [HEART COLOR Changer]
task.spawn(function()
    local Heart = game:GetService("Players").LocalPlayer.PlayerGui.Heart_Beat_Handler_Screen.ViewportFrame
    if not Heart then return end
    local hue_beams = 0
    while true do
        hue_beams = (hue_beams + 0.005) % 1
        local r, g, b = hsvToRgb(hue_beams, 1, 1)
        Heart.ImageColor3 = Color3.new(r, g, b)
        task.wait(0.05)
    end
end)
-- [REDSTAIN Changer]
task.spawn(function()
    local Beams = workspace:FindFirstChild("Beams")
    if not Beams then return end
    local hue_beams = 0
    while true do
        if RedStain_R == 255 and RedStain_G == 255 and RedStain_B == 255 then
            hue_beams = (hue_beams + 0.005) % 1
            local r, g, b = hsvToRgb(hue_beams, 1, 1)
            for _, beam in pairs(Beams:GetChildren()) do
                if beam:IsA("BasePart") then
                    beam.Color = Color3.new(r, g, b)
                end
            end
        else
            for _, beam in pairs(Beams:GetChildren()) do
                if beam:IsA("BasePart") then
                    beam.Color = Color3.fromRGB(RedStain_R, RedStain_G, RedStain_B)
                end
            end
        end
        task.wait(0.05)
    end
end)
--------------------------
-- КЛАВИША INSERT
--------------------------
local cursorVisible = false
local function setCursorState(state)
    cursorVisible = state
    if cursorVisible then
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        game:GetService("UserInputService").MouseIconEnabled = true
    else
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
        game:GetService("UserInputService").MouseIconEnabled = false
    end
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        setCursorState(MainFrame.Visible)
    end
end)

game.StarterGui:SetCore("SendNotification", { 
    Title = "Anal Destroyer",
    Text = "Script successfully Injected!",
    Duration = 5
})
allright = true
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://7405939280" -- Sound ID
sound.Volume = 5
sound.Parent = gui
sound:Play()
task.delay(5, function()
    gui:Destroy()
end)
print('fully loaded (fix 111 & main) ')
