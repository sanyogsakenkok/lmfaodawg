--// ANAL DESTROYER SCRIPT
--// by: SanyogSuckenCock
--///////////////////////////
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
    enable_Player_Speedhack = false,
    selected_Animation = "Snake It",
    mw_Type = "Backward",
    remoteIntType1 = "Players",
    remoteIntType2 = "Hooks",
    input_TargetSurvName = "FurySex",
    enabled_PalletExploit = false,
    enable_AutoWiggle = true,
    unblock_window = false,
    autoSkillCheckEnabled = true,
    autoSkillCheckMode = "Default"
}
_G.Keybind = {
    speedhack = Enum.KeyCode.Q,
    jump = Enum.KeyCode.T,
    tp_to_secret_place = nil,
    tp_to_survivor = Enum.KeyCode.Down,
    tp_to_killer = Enum.KeyCode.Up,
    break_all_pallets = nil,
    break_all_generators = nil,
    legitdash = Enum.KeyCode.F,
    dash = Enum.KeyCode.G,
    stun_yourself = nil,
    tp_to_exitgates = nil,
    tp_to_hatch = nil,
    blind_killer = Enum.KeyCode.Z,
    moonwalk = Enum.KeyCode.X,
    select_target = Enum.KeyCode.C,
    fly = Enum.KeyCode.V,
    animation = Enum.KeyCode.B,
    remote_interaction_1 = Enum.KeyCode.N,
    remote_interaction_2 = Enum.KeyCode.M,
    heal_yourself = Enum.KeyCode.Three,
    heal_other = Enum.KeyCode.Four,
    magic_hatchet = Enum.KeyCode.Five,
    open_all_lockers = nil,
    bless_all_totems = nil,
    make_sound = nil,
    hook_target = nil,
    grab_target = nil,
    pallet_exploit = Enum.KeyCode.LeftAlt
}
local raw1 = "https://raw.githubusercontent.com/sanyogsakenkok/lmfaodawg/refs/heads/main/23072025/a.lua?v=" .. tostring(tick())
local raw2 = "https://raw.githubusercontent.com/sanyogsakenkok/lmfaodawg/refs/heads/main/23072025/b.lua?v=" .. tostring(tick())
loadstring(game:HttpGet(raw1, true))()
loadstring(game:HttpGet(raw2, true))()
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
    if input.KeyCode == _G.Keybind.select_target and circle.Visible then
        local target = findTargetInCircle()
        if target then
            _G.Config.input_TargetSurvName = target.Name
        else
            warn("[SELECTOR] No one founded in Circle!")
        end
    end
end)
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
end)

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

if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MiniHeader") then
    game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MiniHeader"):Destroy()
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
Title.Text = "Anal Destroyer v3.5.0"
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

local gui = game:GetService("CoreGui"):FindFirstChild("MiniHeader")
if gui and gui:IsA("ScreenGui") then
    gui.Enabled = true
end

--// Main GUI \\--
local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = library.subs.Wait

local AnalDestroyer = library:CreateWindow({
Name = "Anal Destroyer",
Themeable = {
Info = "Enjoy your Destroy!",
Credit = false
},
Background = "",
Theme = [[{"__Designer.Colors.topGradient":"232323","__Designer.Settings.ShowHideKey":"Enum.KeyCode.Insert","__Designer.Colors.section":"B0AFB0","__Designer.Colors.hoveredOptionBottom":"2D2D2D","__Designer.Background.ImageAssetID":"rbxassetid://4427304036","__Designer.Colors.selectedOption":"373737","__Designer.Colors.unselectedOption":"282828","__Designer.Files.WorkspaceFile":"Anal Destroyer","__Designer.Colors.unhoveredOptionTop":"323232","__Designer.Colors.outerBorder":"0F0F0F","__Designer.Background.ImageColor":"FFFFFF","__Designer.Colors.tabText":"B9B9B9","__Designer.Colors.elementBorder":"141414","__Designer.Colors.sectionBackground":"232222","__Designer.Colors.innerBorder":"493F49","__Designer.Colors.background":"282828","__Designer.Colors.bottomGradient":"1D1D1D","__Designer.Background.ImageTransparency":95,"__Designer.Colors.main":"00AAFF","__Designer.Colors.otherElementText":"817F81","__Designer.Colors.hoveredOptionTop":"414141","__Designer.Colors.elementText":"939193","__Designer.Colors.unhoveredOptionBottom":"232323","__Designer.Background.UseBackgroundImage":false}]]
})

local ESPTab = AnalDestroyer:CreateTab({
    Name = "ESP"
})
local SpeedhackTab = AnalDestroyer:CreateTab({
    Name = "Speedhack"
})
local SurvExploitsTab = AnalDestroyer:CreateTab({
    Name = "Survivor"
})
local KlrExploitsTab = AnalDestroyer:CreateTab({
    Name = "Killer"
})
local MiscTab = AnalDestroyer:CreateTab({
    Name = "Misc"
})


--// ESP Tab \\--
local PlayersSection = ESPTab:CreateSection({
    Name = "Players"
})
local ObjectDistanceSection = ESPTab:CreateSection({
    Name = "Object Distance"
})
local ObjectsSection = ESPTab:CreateSection({
    Name = "Objects"
})
--// Players \\--
local function updEsp()
    if not _G.Config.survEnabled and not _G.Config.killerEnabled then
        TogglePlayersESP(false)
    else
        TogglePlayersESP(true)
    end
end
TogglePlayersESP(true)
PlayersSection:AddToggle({
    Name = "Survivors",
    Value = _G.Config.survEnabled,
    Callback = function(value)
        _G.Config.survEnabled = value
        updEsp()
    end
}).Default = _G.Config.survEnabled
PlayersSection:AddToggle({
    Name = "Killer",
    Value = _G.Config.killerEnabled,
    Callback = function(value)
        _G.Config.killerEnabled = value
        updEsp()
    end
}).Default = _G.Config.killerEnabled
--// ObjectDistance \\--
ObjectDistanceSection:AddToggle({
    Name = "Enabled",
    Value = _G.Config.enable_ObjectsDistance,
    Callback = function(value)
        _G.Config.enable_ObjectsDistance = value
    end
}).Default = _G.Config.enable_ObjectsDistance
ObjectDistanceSection:AddSlider({
    Name = "Distance",
    Value = _G.Config.ObjectsDistance,
    Callback = function(value)
        _G.Config.ObjectsDistance = value
    end,
    Min = 0,
    Max = 500,
    Decimals = 2
}).Default = _G.Config.ObjectsDistance
--// Objects \\--
ObjectsSection:AddToggle({
    Name = "Pallets",
    Value = "p_v",
    Callback = function(value)
       if value then
            enableObjectESP("Pallet", "Pallet", Color3.fromRGB(255, 230, 0))
       else
            pcall(function() disableObjectESP("Pallet") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Windows",
    Value = "w_v",
    Callback = function(value)
       if value then
            enableObjectESP("Window", "Window", Color3.fromRGB(255, 120, 0))
       else
            pcall(function() disableObjectESP("Window") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Generators",
    Value = "g_v",
    Callback = function(value)
       if value then
            enableObjectESP("Generator", "Generator", Color3.fromRGB(164, 164, 255))
       else
            pcall(function() disableObjectESP("Generator") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Hooks",
    Value = "hk_v",
    Callback = function(value)
       if value then
            enableObjectESP("Hook", "Hook", Color3.fromRGB(255, 0, 147))
       else
            pcall(function() disableObjectESP("Hook") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Hatch",
    Value = "ht_v",
    Callback = function(value)
       if value then
            enableObjectESP("Hatch", "Hatch", Color3.fromRGB(255, 255, 255))
       else
            pcall(function() disableObjectESP("Hatch") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Traps",
    Value = "tr_v",
    Callback = function(value)
       if value then
            enableObjectESP("Trap", "Trap", Color3.fromRGB(255, 0, 0))
       else
            pcall(function() disableObjectESP("Trap") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Exit Gates",
    Value = "ex_v",
    Callback = function(value)
       if value then
            enableObjectESP("ExitGate", "Exit Gate", Color3.fromRGB(143, 251, 140))
       else
            pcall(function() disableObjectESP("ExitGate") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Totems",
    Value = "tm_v",
    Callback = function(value)
       if value then
            enableObjectESP("Totem", "Totem", Color3.fromRGB(0, 169, 255))
       else
            pcall(function() disableObjectESP("Totem") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Lockers",
    Value = "lk_v",
    Callback = function(value)
       if value then
            enableObjectESP("Hiding_Spot_", "Locker", Color3.fromRGB(255, 164, 255))
       else
            pcall(function() disableObjectESP("Hiding_Spot_") end)
       end
    end
}).Default = false
ObjectsSection:AddToggle({
    Name = "Chests",
    Value = "ch_v",
    Callback = function(value)
       if value then
            enableObjectESP("Chest", "Chest", Color3.fromRGB(144, 104, 255))
       else
            pcall(function() disableObjectESP("Chest") end)
       end
    end
}).Default = false

--// SpeedHack \\--
local SpeedhackSection = SpeedhackTab:CreateSection({
    Name = "Speedhack"
})
local DashSection = SpeedhackTab:CreateSection({
    Name = "Dash",
    Side = "Right"
})
SpeedhackSection:AddToggle({
    Name = "Set Killer's Speed",
    Value = _G.Config.enable_Player_Speedhack,
    Callback = function (value)
        _G.Config.enable_Player_Speedhack = value
    end
})
SpeedhackSection:AddSlider({
    Name = "Crawl Speedhack Value",
    Value = _G.Config.Speedhack_Crawl_value,
    Callback = function(value)
        _G.Config.Speedhack_Crawl_value = value
    end,
    Min = 0,
    Max = 100,
    Decimals = 1
})
SpeedhackSection:AddSlider({
    Name = "Crouch Speedhack Value",
    Value = _G.Config.Speedhack_Crouch_Value,
    Callback = function(value)
        _G.Config.Speedhack_Crouch_Value = value
    end,
    Min = 0,
    Max = 40,
    Decimals = 1
})
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local MatchPlayers = ReplicatedStorage:WaitForChild("Match"):WaitForChild("Players")
    local PlayerData = MatchPlayers:FindFirstChild(LocalPlayer.Name)
    local Movement = PlayerData and PlayerData:FindFirstChild("Movement")
    local speed = Movement and Movement:GetAttribute("WindowVaultSpeed")
    SpeedhackSection:AddSlider({
    Name = "Fast Vault Speed",
    Value = speed,
    Callback = function(value)
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
    end,
    Min = 0.2,
    Max = 1.65,
    Decimals = 2
})
end)
DashSection:AddSlider({
    Name = "Dash-Speedhack Value",
    Value = _G.Config.LegitDash_Value,
    Callback = function(value)
        _G.Config.LegitDash_Value = value
    end,
    Min = 30,
    Max = 55,
    Decimals = 1
}).Default = _G.Config.LegitDash_Value
DashSection:AddSlider({
    Name = "Dash Distance",
    Value = _G.Config.Dash_Value,
    Callback = function(value)
        _G.Config.Dash_Value = value
    end,
    Min = 20,
    Max = 200,
    Decimals = 1
}).Default = _G.Config.Dash_Value
--// Survivor Exploits \\--
local autoSkillcheckSection = SurvExploitsTab:CreateSection({
    Name = "Auto Skillcheck"
})
local remoteInteractionSection = SurvExploitsTab:CreateSection({
    Name = "Remote Interaction"
})
local visualSection = SurvExploitsTab:CreateSection({
    Name = "Visual"
})
local TPSection = SurvExploitsTab:CreateSection({
    Name = "Teleports",
    Side = "Right"
})
local otherSurvSection = SurvExploitsTab:CreateSection({
    Name = "Other",
    Side = "Right"
})

autoSkillcheckSection:AddToggle({
    Name = "Enable",
    Value = "as_v",
    Callback = function (value)
        _G.Config.autoSkillCheckEnabled = value
    end
}).Default = _G.Config.autoSkillCheckEnabled
local skillcheckType = {"Default", "Insta"}
autoSkillcheckSection:AddDropdown({
    Name = "Auto Skillcheck Type",
    Value = skillcheckType[1],
    Callback = function (value)
        _G.Config.autoSkillCheckMode = value
    end,
    List = skillcheckType,
    Nothing = "Default"
}).Default = skillcheckType[1]

local remoteIntType = {"Players", "Hooks", "Exit Gates", "Generators"}
remoteInteractionSection:AddDropdown({
    Name = "Remote Interaction #1",
    Value = remoteIntType[1],
    Callback = function (value)
        _G.Config.remoteIntType1 = value
    end,
    List = remoteIntType,
    Nothing = "Players"
}).Default = remoteIntType[1]
remoteInteractionSection:AddDropdown({
    Name = "Remote Interaction #2",
    Value = remoteIntType[2],
    Callback = function (value) 
        _G.Config.remoteIntType2 = value
    end,
    List = remoteIntType,
    Nothing = "Hooks"
}).Default = remoteIntType[2]

TPSection:AddButton({
    Name = "Exit Gates #1",
    Callback = function ()
        local teleported = false
        teleportToExitGate(teleported)
    end
})
TPSection:AddButton({
    Name = "Exit Gates #2",
    Callback = function ()
        local teleported = true
        teleportToExitGate(teleported)
    end
})
TPSection:AddButton({
    Name = "Hatch",
    Callback = function ()
        teleportToHatch()
    end
})
TPSection:AddButton({
    Name = "Secret Place",
    Callback = function ()
        teleportToTemplate()
    end
})

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

local heartColor = Color3.fromRGB(255,255,255)
local redStainColor = Color3.fromRGB(155, 0, 0)
visualSection:AddColorpicker({
    Name = "Heart Color",
    Value = heartColor,
    Callback = function (value)
        heartColor = value
        local Heart = game:GetService("Players").LocalPlayer.PlayerGui.Heart_Beat_Handler_Screen.ViewportFrame
        if not Heart then return end
        Heart.ImageColor3 = heartColor
    end
}).Default = true
visualSection:AddColorpicker({
    Name = "Redstain Color",
    Value = redStainColor,
    Callback = function (value)
        redStainColor = value
        local Beams = workspace:FindFirstChild("Beams")
        if not Beams then return end
        for _, beam in pairs(Beams:GetChildren()) do
            if beam:IsA("BasePart") then
                beam.Color = redStainColor
            end
        end
    end
})

local moonwalkTypes = {"Backward", "Forward", "Left Side", "Right Side"}
local anims = {"Snake It", "Get Em", "Think", "Bowshot", "Point", "Follow", "Strange Movement", "Hooked", "Picked Up", "Locker Grabbed", "Escape"}
otherSurvSection:AddDropdown({
    Name = "Auto Moonwalk Type",
    Value = moonwalkTypes[1],
    Callback = function (value) 
        _G.Config.mw_Type = value
    end,
    List = moonwalkTypes,
    Nothing = "Backward"
}).Default = remoteIntType[1]
otherSurvSection:AddDropdown({
    Name = "Animation",
    Value = anims[1],
    Callback = function (value) 
        _G.Config.selected_Animation = value
    end,
    List = anims,
    Nothing = "Snake It"
}).Default = anims[1]
otherSurvSection:AddToggle({
    Name = "Auto Wiggle",
    Value = "autw_v",
    Callback = function (value)
        _G.Config.enable_AutoWiggle = value
    end
}).Default = _G.Config.enable_AutoWiggle
otherSurvSection:AddToggle({
    Name = "Pallet Exploit",
    Value = "pexp_v",
    Callback = function (value)
        _G.Config.enabled_PalletExploit = value
    end
}).Default = _G.Config.enabled_PalletExploit
otherSurvSection:AddToggle({
    Name = "Unblock Window",
    Value = "uwn_v",
    Callback = function (value)
        _G.Config.unblock_window = value
    end
}).Default = _G.Config.unblock_window
otherSurvSection:AddToggle({
    Name = "Show Blind Zone",
    Value = "sbz_v",
    Callback = function (value)
        setFlashZoneTransparency(value and 0 or 1)
    end
}).Default = false
otherSurvSection:AddToggle({
    Name = "Show Blind Progress",
    Value = "sbz_v",
    Callback = function (state)
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
    end
}).Default = false
otherSurvSection:AddButton({
    Name = "Bless All Totems",
    Callback = function ()
        BlessAllTotems()
    end
})
otherSurvSection:AddButton({
    Name = "Open All Lockers",
    Callback = function ()
        OpenAllLockers()
    end
})
otherSurvSection:AddButton({
    Name = "Make Sound",
    Callback = function ()
        SoundEffectFromYourself()
    end
})

--// Killer Exploits \\--
local sphck = KlrExploitsTab:CreateSection({
    Name = "Speedhack"
})
local expkl = KlrExploitsTab:CreateSection({
    Name = "Exploits"
})
local killerSpeedConnection = nil
local killerSpeed = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed
sphck:AddToggle({
    Name = "Enable",
    value = "klrsph_v",
    Callback = function (value)
        if value then
            killerSpeedConnection = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed ~= killerSpeed then
                    game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = killerSpeed
                end
            end)
        else
            if killerSpeedConnection then
                killerSpeedConnection:Disconnect()
                killerSpeedConnection = nil
            end
        end
    end
}).Default = false
sphck:AddSlider({
    Name = "Speed",
    Value = killerSpeed,
    Callback = function(value)
        killerSpeed = value
    end,
    Min = killerSpeed,
    Max = 200,
    Decimals = 1
})
expkl:AddButton({
    Name = "Kick All Generators",
    Callback = function ()
        KickAllGenerators()
    end
})
expkl:AddButton({
    Name = "Break All Pallets",
    Callback = function ()
        BreakAllPallets()
    end
})
expkl:AddButton({
    Name = "Stun Yourself",
    Callback = function ()
        stun()
    end
})
expkl:AddButton({
    Name = "Grab Selected Survivor",
    Callback = function ()
        GrabSurvivor()
    end
})
expkl:AddButton({
    Name = "Hook Selected Survivor",
    Callback = function ()
        HookSurvivor()
    end
})
local baw_val = false
expkl:AddToggle({
    Name = "Block All Windows",
    Value = baw_val,
    Callback = function (state)
        BlockAllWindows(state)
    end
})
--// Misc \\--
local FOVSection = MiscTab:CreateSection({
    Name = "Field of View"
})
local CheatSection = MiscTab:CreateSection({
    Name = "Cheat"
})
local KeybindsSection = MiscTab:CreateSection({
    Name = "Keybinds",
    Side = "Right"
})
local fov_val = workspace.CurrentCamera.FieldOfView
local cmzd_val = 0
FOVSection:AddSlider({
    Name = "FOV Value",
    Value = fov_val,
    Callback = function(value)
        fov_val = value
    end,
    Min = 70,
    Max = 120,
    Decimals = 1
})
FOVSection:AddButton({
    Name = "Increase Zoom",
    Callback = function ()
        cmzd_val = math.clamp(cmzd_val + 1, 5, 10)
		game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = cmzd_val
		game:GetService("Players").LocalPlayer.CameraMinZoomDistance = cmzd_val
    end
})
FOVSection:AddButton({
    Name = "Decrease Zoom",
    Callback = function ()
        cmzd_val = math.clamp(cmzd_val - 1, 5, 10)
		game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = cmzd_val
		game:GetService("Players").LocalPlayer.CameraMinZoomDistance = cmzd_val
    end
})

CheatSection:AddToggle({
    Name = "Toggle Mini HUD",
    Value = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MiniHeader").Enabled,
    Callback = function (state)
        game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MiniHeader").Enabled = state
    end
})
CheatSection:AddToggle({
    Name = "Toggle Circle",
    Value = circle.Visible,
    Callback = function (state)
        circle.Visible = state
    end
})

KeybindsSection:AddKeybind({
    Name = "Speedhack",
    Value = _G.Keybind.speedhack or nil,
    Callback = function(v) _G.Keybind.speedhack = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Jump",
    Value = _G.Keybind.jump or nil,
    Callback = function(v) _G.Keybind.jump = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Teleport to Secret Place",
    Value = _G.Keybind.tp_to_secret_place or nil,
    Callback = function(v) _G.Keybind.tp_to_secret_place = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Teleport to Survivor",
    Value = _G.Keybind.tp_to_survivor or nil,
    Callback = function(v) _G.Keybind.tp_to_survivor = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Teleport to Killer",
    Value = _G.Keybind.tp_to_killer or nil,
    Callback = function(v) _G.Keybind.tp_to_killer = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Break All Pallets",
    Value = _G.Keybind.break_all_pallets or nil,
    Callback = function(v) _G.Keybind.break_all_pallets = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Break All Generators",
    Value = _G.Keybind.break_all_generators or nil,
    Callback = function(v) _G.Keybind.break_all_generators = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Legit Dash",
    Value = _G.Keybind.legitdash or nil,
    Callback = function(v) _G.Keybind.legitdash = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Dash",
    Value = _G.Keybind.dash or nil,
    Callback = function(v) _G.Keybind.dash = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Stun Yourself",
    Value = _G.Keybind.stun_yourself or nil,
    Callback = function(v) _G.Keybind.stun_yourself = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Teleport to Exit Gates",
    Value = _G.Keybind.tp_to_exitgates or nil,
    Callback = function(v) _G.Keybind.tp_to_exitgates = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Teleport to Hatch",
    Value = _G.Keybind.tp_to_hatch or nil,
    Callback = function(v) _G.Keybind.tp_to_hatch = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Blind Killer",
    Value = _G.Keybind.blind_killer or nil,
    Callback = function(v) _G.Keybind.blind_killer = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Moonwalk",
    Value = _G.Keybind.moonwalk or nil,
    Callback = function(v) _G.Keybind.moonwalk = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Select Target",
    Value = _G.Keybind.select_target or nil,
    Callback = function(v) _G.Keybind.select_target = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Fly",
    Value = _G.Keybind.fly or nil,
    Callback = function(v) _G.Keybind.fly = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Animation",
    Value = _G.Keybind.animation or nil,
    Callback = function(v) _G.Keybind.animation = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Remote Interaction 1",
    Value = _G.Keybind.remote_interaction_1 or nil,
    Callback = function(v) _G.Keybind.remote_interaction_1 = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Remote Interaction 2",
    Value = _G.Keybind.remote_interaction_2 or nil,
    Callback = function(v) _G.Keybind.remote_interaction_2 = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Heal Yourself",
    Value = _G.Keybind.heal_yourself or nil,
    Callback = function(v) _G.Keybind.heal_yourself = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Heal Other",
    Value = _G.Keybind.heal_other or nil,
    Callback = function(v) _G.Keybind.heal_other = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Magic Hatchet",
    Value = _G.Keybind.magic_hatchet or nil,
    Callback = function(v) _G.Keybind.magic_hatchet = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Open All Lockers",
    Value = _G.Keybind.open_all_lockers or nil,
    Callback = function(v) _G.Keybind.open_all_lockers = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Bless All Totems",
    Value = _G.Keybind.bless_all_totems or nil,
    Callback = function(v) _G.Keybind.bless_all_totems = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Make Sound",
    Value = _G.Keybind.make_sound or nil,
    Callback = function(v) _G.Keybind.make_sound = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Hook Target",
    Value = _G.Keybind.hook_target or nil,
    Callback = function(v) _G.Keybind.hook_target = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Grab Target",
    Value = _G.Keybind.grab_target or nil,
    Callback = function(v) _G.Keybind.grab_target = typeof(v) == "EnumItem" and v or nil end
})

KeybindsSection:AddKeybind({
    Name = "Pallet Exploit",
    Value = _G.Keybind.pallet_exploit or nil,
    Callback = function(v) _G.Keybind.pallet_exploit = typeof(v) == "EnumItem" and v or nil end
})

game:GetService("RunService").RenderStepped:Connect(function()
    workspace.CurrentCamera.FieldOfView = fov_val
end)

-- Status: ALL RIGHT!
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
print('fully loaded')
