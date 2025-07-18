--// ANAL DESTROYER SCRIPT
--// by: SanyogSuckenCock
--///////////////////////////
game.StarterGui:SetCore("SendNotification", { 
    Title = "Anal Destroyer",
    Text = "initialize...",
    Duration = 2
})
while game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("LoadScreen") do
    task.wait(0.1)
end

--// Pre-Load Config \\--
_G.Config = {
    enable_ObjectsDistance = false,
    ObjectsDistance = 150,
    survEnabled = false,
    killerEnabled = false,
    Speedhack_Crawl_value = 0,
    Speedhack_Crouch_Value = 0,
    LegitDash_Value = 55,
    Dash_Value = 20,
    enable_Speedhack = false,
    selected_Animation = "Snake It",
    mw_Type = "Backward",
    remoteIntType1 = "Players",
    remoteIntType2 = "Hooks",
    input_TargetSurvName = "FurySex",
    enabled_PalletExploit = false,
    unblock_window = false,
    autoSkillCheckEnabled = true,
    autoSkillCheckMode = "Insta"
}
local raw1 = "https://raw.githubusercontent.com/sanyogsakenkok/lmfaodawg/refs/heads/main/ahh_update/a.lua?v=" .. tostring(tick())
local raw2 = "https://raw.githubusercontent.com/sanyogsakenkok/lmfaodawg/refs/heads/main/ahh_update/b.lua.lua?v=" .. tostring(tick())
loadstring(game:HttpGet(raw1, true))()

--// Main GUI \\--
local existingGUI = game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("CustomGUI")
if existingGUI then
    existingGUI:Destroy()
end

local MainColor = Color3.fromRGB(255, 255, 255) -- white
local SecondaryColor = Color3.fromRGB(0, 162, 255) -- blue accent
local BackColor = Color3.fromRGB(0, 0, 0) -- black bg
local ExtraColor = Color3.fromRGB(60, 60, 60) -- grey for sliders etc

local gui = Instance.new("ScreenGui")
gui.Enabled = false
local mainFrame = Instance.new("Frame")
local tabButtons = Instance.new("Frame")
gui.Name = "CustomGUI"
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = BackColor
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- TOGGLE MENU
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        gui.Enabled = not gui.Enabled
        if gui.Enabled then
            game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
            game:GetService("UserInputService").MouseIconEnabled = true
        else
            game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
            game:GetService("UserInputService").MouseIconEnabled = false
        end
    end
end)

function createTabButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = BackColor
    button.BorderColor3 = ExtraColor
    button.Text = name
    button.TextColor3 = MainColor
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    local changedEvent = Instance.new("BindableEvent")
    button.MouseButton1Click:Connect(function()
        callback()
        changedEvent:Fire()
    end)
    return button, changedEvent.Event
end
tabButtons.Size = UDim2.new(0, 120, 1, 0)
tabButtons.BackgroundColor3 = BackColor
tabButtons.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabButtons

function createTabContent()
    local tab = Instance.new("ScrollingFrame")
    tab.Size = UDim2.new(1, -130, 1, -10)
    tab.Position = UDim2.new(0, 130, 0, 5)
    tab.BackgroundTransparency = 1
    tab.BorderSizePixel = 0
    tab.ScrollBarThickness = 6
    tab.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    tab.Parent = mainFrame
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = tab
    return tab
end

function createToggle(text, tp)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.TextColor3 = MainColor
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(1, -25, 0.5, -10)
    box.BackgroundColor3 = ExtraColor
    box.BorderSizePixel = 0
    box.Text = ""
    box.Parent = container
    local state = false
    if tp == true then state = tp end
    local innerBox = Instance.new("Frame")
    innerBox.Size = UDim2.new(1, -4, 1, -4)
    innerBox.Position = UDim2.new(0, 2, 0, 2)
    innerBox.BackgroundColor3 = SecondaryColor
    innerBox.Visible = state
    innerBox.Parent = box
    local changedEvent = Instance.new("BindableEvent")
    box.MouseButton1Click:Connect(function()
        state = not state
        innerBox.Visible = state
        changedEvent:Fire(state)
    end)

    return container, function() return state end, changedEvent.Event
end

function createSelector(labelText, options, defaultIndex)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.ZIndex = 999

    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextColor3 = MainColor
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, -10, 0, 25)
    dropdown.Position = UDim2.new(0, 5, 0, 25)
    dropdown.BackgroundColor3 = ExtraColor
    dropdown.BorderSizePixel = 0
    dropdown.Font = Enum.Font.SourceSans
    dropdown.TextSize = 16
    dropdown.TextColor3 = Color3.new(1,1,1)
    dropdown.Parent = container

    local currentIndex = defaultIndex or 1
    dropdown.Text = options[currentIndex]

    local menu = Instance.new("Frame")
    menu.ZIndex = 999
    menu.Size = UDim2.new(1, -10, 0, #options * 25)
    menu.Position = UDim2.new(0, 5, 0, 50)
    menu.BackgroundColor3 = ExtraColor
    menu.Visible = false
    menu.ClipsDescendants = true
    menu.Parent = container

    local changedEvent = Instance.new("BindableEvent")

    for i, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.ZIndex = 999
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
        btn.BackgroundColor3 = ExtraColor
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Text = option
        btn.Parent = menu

        btn.MouseButton1Click:Connect(function()
            currentIndex = i
            dropdown.Text = option
            menu.Visible = false
            changedEvent:Fire(option)
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)

    return container, function() return options[currentIndex] end, changedEvent.Event
end

function createSlider(labelText, min, max, defaultValue)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 45)
    container.BackgroundTransparency = 1
    local label = Instance.new("TextLabel")
    label.Text = labelText .. ": " .. tostring(defaultValue)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextColor3 = MainColor
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -10, 0, 6)
    bar.Position = UDim2.new(0, 5, 0, 30)
    bar.BackgroundColor3 = ExtraColor
    bar.BorderSizePixel = 0
    bar.Parent = container
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = SecondaryColor
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local value = defaultValue
    local changedEvent = Instance.new("BindableEvent")
    local UserInputService = game:GetService("UserInputService")
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn
            conn = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((moveInput.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    value = math.floor((min + rel * (max - min)) * 100 + 0.5) / 100
                    label.Text = labelText .. ": " .. tostring(value)
                    changedEvent:Fire(value)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                end
            end)
        end
    end)
    return container, function() return value end, changedEvent.Event
end

function createColorShower(r, g, b)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1

    local colorBox = Instance.new("Frame")
    colorBox.Name = "ColorBox"
    colorBox.Size = UDim2.new(0, 30, 0, 20)
    colorBox.Position = UDim2.new(0, 5, 0, 5)
    colorBox.BackgroundColor3 = Color3.fromRGB(r, g, b)
    colorBox.BorderColor3 = Color3.new(0, 0, 0)
    colorBox.BorderSizePixel = 1
    colorBox.Parent = container

    local label = Instance.new("TextLabel")
    label.Name = "ColorLabel"
    label.Size = UDim2.new(1, -40, 0, 20)
    label.Position = UDim2.new(0, 40, 0, 5)
    label.Text = string.format("Color Preview (%d, %d, %d)", r, g, b)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local function updateColor(newR, newG, newB)
        colorBox.BackgroundColor3 = Color3.fromRGB(newR, newG, newB)
        label.Text = string.format("Color Preview (%d, %d, %d)", newR, newG, newB)
    end

    return container, updateColor
end


local allTabs = {}
local firstTab = true

_G.CustomGUI = {
    CreateTab = function(name)
        local tab = createTabContent()
        tab.Visible = false
        table.insert(allTabs, tab)

        local button = createTabButton(name, function()
            for _, otherTab in pairs(allTabs) do
                otherTab.Visible = false
            end
            tab.Visible = true
        end)
        button.Parent = tabButtons

        if firstTab then
            tab.Visible = true
            firstTab = false
        end

        return tab
    end,
    AddToggle = createToggle,
    AddSlider = createSlider,
    AddSelector = createSelector,
    ShowColor = createColorShower
}
--// Extra GUIs \\--
function ttl(message)
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

if game:GetService("CoreGui"):FindFirstChild("MiniHeader") then
	game:GetService("CoreGui"):FindFirstChild("MiniHeader"):Destroy()
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
Title.Text = "Anal Destroyer v3.2.5"
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

--// ESP Tab \\--
local esp = _G.CustomGUI.CreateTab("ESP")
local enobjdist, enable_distobj, endistChanged = _G.CustomGUI.AddToggle("Show Object's Distance")
enobjdist.Parent = esp
local objDistance, distance, distChanged = _G.CustomGUI.AddSlider("Object's Distance Value", 50, 500, 150)
objDistance.Parent = esp
local survivors, enable_survivors, survChanged = _G.CustomGUI.AddToggle("Survivors")
survivors.Parent = esp
local killer, enable_killer, klrChanged = _G.CustomGUI.AddToggle("Killer")
killer.Parent = esp
local pallet, enable_pallet, palletChanged = _G.CustomGUI.AddToggle("Pallets")
pallet.Parent = esp
local window, enable_window, winChanged = _G.CustomGUI.AddToggle("Windows")
window.Parent = esp
local generator, enable_generator, genChanged = _G.CustomGUI.AddToggle("Generators")
generator.Parent = esp
local hook, enable_hook, hookChanged = _G.CustomGUI.AddToggle("Hooks")
hook.Parent = esp
local hatch, enable_hatch, hatchChanged = _G.CustomGUI.AddToggle("Hatch")
hatch.Parent = esp
local trap, enable_trap, trapChanged = _G.CustomGUI.AddToggle("Traps")
trap.Parent = esp
local exitgate, enable_exitgate, exitChanged = _G.CustomGUI.AddToggle("Exit Gate")
exitgate.Parent = esp
local totem, enable_totem, totemChanged = _G.CustomGUI.AddToggle("Totems")
totem.Parent = esp
local locker, enable_locker, lockerChanged = _G.CustomGUI.AddToggle("Lockers")
locker.Parent = esp
local chest, enable_chest, chestChanged = _G.CustomGUI.AddToggle("Chests")
chest.Parent = esp

--// ESP Changed Events \\--
endistChanged:Connect(function(value)
    _G.Config.enable_ObjectsDistance = value
end)
distChanged:Connect(function(value)
    _G.Config.ObjectsDistance = value
end)
--// Players \\--
local function updEsp()
    if not _G.Config.survEnabled and not _G.Config.killerEnabled then
        TogglePlayersESP(false)
    else
        TogglePlayersESP(true)
    end
end
TogglePlayersESP(true)
survChanged:Connect(function(state)
    _G.Config.survEnabled = state
    updEsp()
end)
klrChanged:Connect(function(state)
    _G.Config.killerEnabled = state
    updEsp()
end)
--// Objects \\--
palletChanged:Connect(function(state)
    if state then
        enableObjectESP("Pallet", "Pallet", Color3.fromRGB(255, 230, 0))
    else
        pcall(function() disableObjectESP("Pallet") end)
    end
end)
winChanged:Connect(function(state)
    if state then
        enableObjectESP("Window", "Window", Color3.fromRGB(255, 120, 0))
    else
        pcall(function() disableObjectESP("Window") end)
    end
end)
genChanged:Connect(function(state)
    if state then
        enableObjectESP("Generator", "Generator", Color3.fromRGB(164, 164, 255))
    else
        pcall(function() disableObjectESP("Generator") end)
    end
end)
hookChanged:Connect(function(state)
    if state then
        enableObjectESP("Hook", "Hook", Color3.fromRGB(255, 0, 147))
    else
        pcall(function() disableObjectESP("Hook") end)
    end
end)
hatchChanged:Connect(function(state)
    if state then
        enableObjectESP("Hatch", "Hatch", Color3.fromRGB(255, 255, 255))
    else
        pcall(function() disableObjectESP("Hatch") end)
    end
end)
trapChanged:Connect(function(state)
    if state then
        enableObjectESP("Trap", "Trap", Color3.fromRGB(255, 0, 0))
    else
        pcall(function() disableObjectESP("Trap") end)
    end
end)
exitChanged:Connect(function(state)
    if state then
        enableObjectESP("ExitGate", "Exit Gate", Color3.fromRGB(143, 251, 140))
    else
        pcall(function() disableObjectESP("ExitGate") end)
    end
end)
totemChanged:Connect(function(state)
    if state then
        enableObjectESP("Totem", "Totem", Color3.fromRGB(0, 169, 255))
    else
        pcall(function() disableObjectESP("Totem") end)
    end
end)
lockerChanged:Connect(function(state)
    if state then
        enableObjectESP("Hiding_Spot_", "Locker", Color3.fromRGB(255, 164, 255))
    else
        pcall(function() disableObjectESP("Hiding_Spot_") end)
    end
end)
chestChanged:Connect(function(state)
    if state then
        enableObjectESP("Chest", "Chest", Color3.fromRGB(144, 104, 255))
    else
        pcall(function() disableObjectESP("Chest") end)
    end
end)
--// Speed Hacks \\--
local speedhk = _G.CustomGUI.CreateTab("Speed Hacks")

local sphk1, craspeed, crawlspeedChanged = _G.CustomGUI.AddSlider("Crawl Speedhack Value", 0, 1000, 0)
sphk1.Parent = speedhk
local sphk2, crospeed, crouchspeedChanged = _G.CustomGUI.AddSlider("Crouch Speedhack Value", 0, 40, 0)
sphk2.Parent = speedhk
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local MatchPlayers = ReplicatedStorage:WaitForChild("Match"):WaitForChild("Players")
    local PlayerData = MatchPlayers:FindFirstChild(LocalPlayer.Name)
    local Movement = PlayerData and PlayerData:FindFirstChild("Movement")
    local speed = Movement and Movement:GetAttribute("WindowVaultSpeed")

    local fstvlt, vaultspeed, vaultspChanged = _G.CustomGUI.AddSlider("Fast Vault Speed", 0.2, 1.65, speed)
    fstvlt.Parent = speedhk

    vaultspChanged:Connect(function(value)
        pcall(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local MatchPlayers = ReplicatedStorage:WaitForChild("Match"):WaitForChild("Players")
            local PlayerData = MatchPlayers:FindFirstChild(LocalPlayer.Name)
            local Movement = PlayerData and PlayerData:FindFirstChild("Movement")
            if Movement and Movement:GetAttribute("WindowVaultSpeed") ~= nil then
                Movement:SetAttribute("WindowVaultSpeed", value)
            end
        end)
    end)
end)
local dashsp, dashspeed, dashspeedChanged = _G.CustomGUI.AddSlider("Dash-Speedhack Value", 30, 55, 55)
dashsp.Parent = speedhk
local dashdist, dashdistance, dashdistChanged = _G.CustomGUI.AddSlider("Default Dash Distance", 20, 200, 20)
dashdist.Parent = speedhk
local sphktog, hkspeed, speedhackChanged = _G.CustomGUI.AddToggle("Change Your Speed as Killer's Speed")
sphktog.Parent = speedhk

--// Speed Changed Events \\--
speedhackChanged:Connect(function(value)
    _G.Config.enable_Speedhack = value
end)
crawlspeedChanged:Connect(function(value)
    _G.Config.Speedhack_Crawl_value = value
end)
crouchspeedChanged:Connect(function(value)
    _G.Config.Speedhack_Crouch_Value = value
end)
dashspeedChanged:Connect(function(value)
    _G.Config.LegitDash_Value = value
end)
dashdistChanged:Connect(function(value)
    _G.Config.Dash_Value = value
end)

--// Exploits \\--
local exploits = _G.CustomGUI.CreateTab("Exploits")

local as, ass, skillCheckToggled = _G.CustomGUI.AddToggle("Auto SkillCheck", true)
local as1, ass1, skillCheckType = _G.CustomGUI.AddSelector("Auto SkillCheck Mode", {"Default", "Insta"}, 2)
local remint1, remote1, remintChanged = _G.CustomGUI.AddSelector("Remote Interaction Type #1", {"Players", "Hooks", "Exit Gates", "Generators"}, 1)
remint1.Parent = exploits
local remint2, remote2, remint2Changed = _G.CustomGUI.AddSelector("Remote Interaction Type #2", {"Players", "Hooks", "Exit Gates", "Generators"}, 2)
remint2.Parent = exploits
local mw, moonwalk, mwChanged = _G.CustomGUI.AddSelector("Auto Moonwalk Type", {"Backward", "Forward", "Left Side", "Right Side"}, 1)
mw.Parent = exploits
local pe, pee, exploitChanged = _G.CustomGUI.AddToggle("Pallet Exploit")
local uw, uww, windChanged = _G.CustomGUI.AddToggle("Unblock Window")
pe.Parent = exploits
uw.Parent = exploits
as.Parent = exploits
as1.Parent = exploits

skillCheckToggled:Connect(function(value)
    _G.Config.autoSkillCheckEnabled = value
end)
skillCheckType:Connect(function(value)
    _G.Config.autoSkillCheckMode = value
end)
exploitChanged:Connect(function(value)
    _G.Config.enabled_PalletExploit = value
end)
windChanged:Connect(function(value)
    _G.Config.unblock_window = value
end)
remintChanged:Connect(function(val)
    if _G.Config.remoteIntType2 == val then return end
    _G.Config.remoteIntType1 = val
end)
remint2Changed:Connect(function(val)
    if _G.Config.remoteIntType1 == val then return end
    _G.Config.remoteIntType2 = val
end)
mwChanged:Connect(function(val)
    _G.Config.mw_Type = val
end)
--// Visuals \\--
local visual = _G.CustomGUI.CreateTab("Visuals")
local anim, anims, animChanged = _G.CustomGUI.AddSelector("Animation", {"Snake It", "Get Em", "Think", "Bowshot", "Point", "Follow", "Strange Movement", "Hooked", "Picked Up", "Locker Grabbed", "Escape"}, 1)
anim.Parent = visual

local RedStain_R = 255
local RedStain_G = 255
local RedStain_B = 255
local runHearbeatColor = true
local cmzd_val = 5

local currentFOV = workspace.CurrentCamera.FieldOfView
local fov_val = currentFOV

local fov, fv, fovChanged = _G.CustomGUI.AddSlider("Field of View Value", 70, 120, currentFOV)
fov.Parent = visual
local Rstain, r, rChanged = _G.CustomGUI.AddSlider("REDSTAIN CHANGER Red Color", 0, 255, 255)
Rstain.Parent = visual
local Gstain, g, gChanged = _G.CustomGUI.AddSlider("REDSTAIN CHANGER Green Color", 0, 255, 255)
Gstain.Parent = visual
local Bstain, b, bChanged = _G.CustomGUI.AddSlider("REDSTAIN CHANGER Blue Color", 0, 255, 255)
Bstain.Parent = visual
local stainColor, updateStainColor = createColorShower(RedStain_R, RedStain_G, RedStain_B)
stainColor.Parent = visual
local rgbheart, heart, rgbheartChanged = _G.CustomGUI.AddToggle("RGB Heart", true)
rgbheart.Parent = visual
local sbz, sbzz, zoneChanged = _G.CustomGUI.AddToggle("Show Blind Zone")
local sbp, sbpp, progChanged = _G.CustomGUI.AddToggle("Show Blind Progress")
sbz.Parent = visual
sbp.Parent = visual
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = workspace

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
    if not killerName then return end
    local killerModel = Workspace:FindFirstChild(killerName)
    if killerModel then
        local flashZone = killerModel:FindFirstChild("Flash_Zone")
        if flashZone and flashZone:IsA("BasePart") then
            flashZone.Transparency = transparencyValue
        end
    end
end

zoneChanged:Connect(function(state)
    setFlashZoneTransparency(state and 0 or 1)
end)

progChanged:Connect(function(state)
    local existingGui = PlayerGui:FindFirstChild("KillerBlindStatusGui")
    if state then
        if existingGui then existingGui:Destroy() end

        local screenGui = Instance.new("ScreenGui", PlayerGui)
        screenGui.Name = "KillerBlindStatusGui"

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
            for _, plr in ipairs(Players:GetPlayers()) do
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
    else
        if existingGui then
            existingGui:Destroy()
        end
    end
end)
-- FOV Changer
fovChanged:Connect(function(fov)
    fov_val = tonumber(fov) or 70
end)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.PageUp then
		cmzd_val = math.clamp(cmzd_val + 1, 5, 10)
		game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = cmzd_val
		game:GetService("Players").LocalPlayer.CameraMinZoomDistance = cmzd_val
	elseif input.KeyCode == Enum.KeyCode.PageDown then
		cmzd_val = math.clamp(cmzd_val - 1, 5, 10)
		game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = cmzd_val
		game:GetService("Players").LocalPlayer.CameraMinZoomDistance = cmzd_val
	end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    workspace.CurrentCamera.FieldOfView = fov_val
end)

-- RGB Visuals
rChanged:Connect(function(r)
    RedStain_R = r
    updateStainColor(RedStain_R, RedStain_G, RedStain_B)
end)
gChanged:Connect(function(g)
    RedStain_G = g
    updateStainColor(RedStain_R, RedStain_G, RedStain_B)
end)
bChanged:Connect(function(b)
    RedStain_B = b
    updateStainColor(RedStain_R, RedStain_G, RedStain_B)
end)
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
rgbheartChanged:Connect(function(type)
    if type then
        runHearbeatColor = true
    else
        runHearbeatColor = false
    end
end)
animChanged:Connect(function(val)
    _G.Config.selected_Animation = val
end)
-- [HEART COLOR Changer]
task.spawn(function()
    local Heart = game:GetService("Players").LocalPlayer.PlayerGui.Heart_Beat_Handler_Screen.ViewportFrame
    if not Heart then return end
    local hue_beams = 0
    while true do
        if runHearbeatColor then
            hue_beams = (hue_beams + 0.005) % 1
            local r, g, b = hsvToRgb(hue_beams, 1, 1)
            Heart.ImageColor3 = Color3.new(r, g, b)
        else
            Heart.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
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

loadstring(game:HttpGet(raw2, true))()

-- Selector!
local Camera = workspace.CurrentCamera
local circle = Drawing.new("Circle")
circle.Visible = true
circle.Color = Color3.new(1,1,1)
circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
circle.Radius = 50
circle.Thickness = 1
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.L then
        circle.Visible = not circle.Visible
    elseif input.KeyCode == Enum.KeyCode.C then
        local closest, lowestDist = nil, math.huge
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen and (Vector2.new(screenPos.X, screenPos.Y) - circle.Position).Magnitude <= circle.Radius then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - circle.Position).Magnitude
                    if dist < lowestDist then
                        lowestDist, closest = dist, player
                    end
                end
            end
        end
        if closest then _G.Config.input_TargetSurvName = closest.Name end
    end
end)
-- Status: ALL RIGHT!
game.StarterGui:SetCore("SendNotification", { 
    Title = "Anal Destroyer",
    Text = "Script successfully Injected!",
    Duration = 5
})
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
print('fully loaded')
