--// [!] FUNCTIONS \\--
-- [FUNCTION] Auto Skillcheck
local RunService = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")
local lp = game:GetService("Players").LocalPlayer
local gui = lp:WaitForChild("PlayerGui")
local hud = gui:WaitForChild("HUD")

local autoSkillCheckMode = "Great"
local function pressSpace()
    vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function getLatestZone(skillCheck, mode)
    local folder = skillCheck:FindFirstChild(mode:upper())
    if not folder then
        warn("[DEBUG] No such folder: " .. mode:upper())
        return nil
    end

    local zones = folder:GetChildren()
    local candidates = {}

    for _, obj in ipairs(zones) do
        if obj:IsA("ImageLabel") and obj.Name == mode .. "Zone" then
            table.insert(candidates, obj)
        end
    end

    if #candidates == 0 then
        warn("[DEBUG] No such " .. mode .. "Zone")
        return nil
    end

    return candidates[#candidates]
end

task.spawn(function()
    while true do
        task.wait(0.1)

        local skillCheck = hud:FindFirstChild("SkillCheck")
        if _G.Config.autoSkillCheckEnabled and skillCheck and skillCheck.Visible then

            local needle = skillCheck:FindFirstChild("Needle")
            if not needle then
                warn("[AutoSkillcheck] Needle doesnt founded")
                continue
            end

            local targetZone = getLatestZone(skillCheck, autoSkillCheckMode)
            if not targetZone then
                continue
            end

            if _G.Config.autoSkillCheckMode == "Insta" then
                needle.Rotation = targetZone.Rotation - 6
                pressSpace()
                repeat task.wait(0.1) until not skillCheck.Visible
            else
                local triggered = false
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    if not skillCheck.Visible then
                        conn:Disconnect()
                        return
                    end

                    local needleRot = needle.Rotation
                    local zoneRot = targetZone.Rotation

                    if not triggered and needleRot >= zoneRot - 6 then
                        triggered = true
                        pressSpace()
                        conn:Disconnect()
                    end
                end)

                task.wait(5)
                if conn and conn.Connected then
                    conn:Disconnect()
                end
            end
        end
    end
end)
-- [FUNCTION] Break All Pallets
function BreakAllPallets()
    for _, i in pairs(workspace:GetChildren()) do
        if i.Name:match("Pallet%d") then
            local args = {
                [1] = "Pallet";
                [2] = "Killer_Kick";
                [3] = workspace:WaitForChild(i.Name, 9e9);
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Server_Event", 9e9):FireServer(unpack(args))       
        end
    end
end
-- [FUNCTION] Hook Target
function HookSurvivor()
    local args = {
        [1] = "Hook";
        [2] = "Hook";
        [3] = workspace:WaitForChild(_G.Config.input_TargetSurvName, 9e9);
        [4] = workspace:WaitForChild("Hook1", 9e9);
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Server_Event", 9e9):FireServer(unpack(args))
end
-- [FUNCTION] Grab Survivor
function GrabSurvivor()
    local args = {
        [1] = "Carry";
        [2] = "Pickup_Default";
        [3] = game:GetService("Players"):WaitForChild(_G.Config.input_TargetSurvName, 9e9);
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Server_Event", 9e9):FireServer(unpack(args))
end
-- [FUNCTION] Magic Hit(TRAPPER ONLY)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Five then
        local args = {
            [1] = true;
        }

        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalKiller", 9e9):WaitForChild("Action", 9e9):WaitForChild("BasicAttack", 9e9):WaitForChild("CollisionEvent", 9e9):FireServer(unpack(args))
        local args = {
            [1] = "rbxassetid://5527373079";
            [2] = "Lunge";
            [3] = 3;
        }

        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalKiller", 9e9):WaitForChild("Action", 9e9):WaitForChild("BasicAttack", 9e9):WaitForChild("RemoteEvent2", 9e9):FireServer(unpack(args))
        local args = {
            [1] = "rbxassetid://1848527922";
            [2] = "Swing";
            [3] = 2;
        }

        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalKiller", 9e9):WaitForChild("Action", 9e9):WaitForChild("BasicAttack", 9e9):WaitForChild("RemoteEvent2", 9e9):FireServer(unpack(args))
        local args = {
            [1] = "Start_Hit";
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Swing", 9e9):FireServer(unpack(args))
        local args = {
            [1] = workspace:WaitForChild(game:GetService("Players").LocalPlayer.Name, 9e9):WaitForChild("Trapper", 9e9):WaitForChild("Handle", 9e9):WaitForChild("LungeSound", 9e9);
        }

        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalKiller", 9e9):WaitForChild("Action", 9e9):WaitForChild("BasicAttack", 9e9):WaitForChild("RemoteEvent", 9e9):FireServer(unpack(args))
        local args = {
            [1] = "Hit";
            [2] = workspace:WaitForChild(_G.Config.input_TargetSurvName, 9e9):WaitForChild("HumanoidRootPart", 9e9);
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Swing", 9e9):FireServer(unpack(args))
        local args = {
            [1] = workspace:WaitForChild(game:GetService("Players").LocalPlayer.Name, 9e9):WaitForChild("Trapper", 9e9):WaitForChild("Handle", 9e9):WaitForChild("SwingSound", 9e9);
        }

        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalKiller", 9e9):WaitForChild("Action", 9e9):WaitForChild("BasicAttack", 9e9):WaitForChild("RemoteEvent", 9e9):FireServer(unpack(args))
        local args = {
            [1] = "Stop_Hit";
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Swing", 9e9):FireServer(unpack(args))
        local args = {
            [1] = false;
        }

        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalKiller", 9e9):WaitForChild("Action", 9e9):WaitForChild("BasicAttack", 9e9):WaitForChild("CollisionEvent", 9e9):FireServer(unpack(args))

    end
end)
-- [FUNCTION] Kick All Generators
function KickAllGenerators()
    for _, gen in pairs(workspace:GetChildren()) do
        if gen.Name:match("Generator%d") then
            local args = {
                [1] = "Generator";
                [2] = "Killer_Kick";
                [3] = workspace:WaitForChild(gen.Name, 9e9);
                [4] = workspace:WaitForChild(gen.Name, 9e9):WaitForChild("Workspots", 9e9):WaitForChild("Back", 9e9);
            }
                
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Server_Event", 9e9):FireServer(unpack(args))
        end
    end
end
-- [FUNCTION] Sound Effect from You
function SoundEffectFromYourself()
    local function getKiller()
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
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
        local klr = getKiller()
        local args = {
            [1] = workspace:FindFirstChild(game:GetService("Players").LocalPlayer.Name).HumanoidRootPart.CFrame;
            [2] = 5;
            [3] = "Default";
            [4] = game:GetService("Players"):WaitForChild(klr, 9e9);
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Notification", 9e9):FireServer(unpack(args))
end
-- [FUNCTION] Pallet Exploit
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftAlt and _G.Config.enabled_PalletExploit then
        for _, pallet in pairs(workspace:GetChildren()) do
            if pallet.Name:match("Pallet%d") then
                local firstPort = pallet:FindFirstChild("FirstPort")
                local secondPort = pallet:FindFirstChild("SecondPort")
                local state = pallet.Panel.State
                if firstPort or secondPort then
                    if state.Value == 1 then
                        local closestPort = nil
                        local minDistance = math.huge
                        if firstPort then
                            local distance = (humanoidRootPart.Position - firstPort.Position).Magnitude
                            if distance <= 15 and distance < minDistance then
                                minDistance = distance
                                closestPort = firstPort
                            end
                        end
                        if secondPort then
                            local distance = (humanoidRootPart.Position - secondPort.Position).Magnitude
                            if distance <= 15 and distance < minDistance then
                                minDistance = distance
                                closestPort = secondPort
                            end
                        end
                        if closestPort then
                            local args = {
                                [1] = pallet,
                                [2] = closestPort,
                                [3] = "Vault",
                                [4] = true
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PalletAction"):FireServer(unpack(args))
                            break
                        end
                    else
                        local closestPort = nil
                        local minDistance = math.huge
                        if firstPort then
                            local distance = (humanoidRootPart.Position - firstPort.Position).Magnitude
                            if distance <= 15 and distance < minDistance then
                                minDistance = distance
                                closestPort = secondPort
                            end
                        end
                        if secondPort then
                            local distance = (humanoidRootPart.Position - secondPort.Position).Magnitude
                            if distance <= 15 and distance < minDistance then
                                minDistance = distance
                                closestPort = firstPort
                            end
                        end
                        if closestPort then
                            local args = {
                                [1] = pallet,
                                [2] = closestPort,
                                [3] = "Drop"
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PalletAction"):FireServer(unpack(args))
                            break
                        end
                    end
                end
            end
        end
    end
end)
-- [FUNCTION] Bless All Totems
function BlessAllTotems()
    for _, totem in pairs(workspace:GetChildren()) do
            if totem.Name:match("Totem%d") then
                local args = {
                    [1] = workspace:WaitForChild(totem.Name, 9e9);
                    [2] = {
                        [1] = "HealingAid";
                        [2] = "FreshAir";
                        [3] = "InTheShadows";
                    };
                    [3] = "Connect";
                }
                game:GetService("ReplicatedStorage"):WaitForChild("-LockerAuras", 9e9):WaitForChild("Boon_Handler", 9e9):FireServer(unpack(args))
            end
        end
end
-- [FUNCTION] Open All Lockers
function OpenAllLockers()
    for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name:match("Hiding_Spot_%d") then
                local args = {
                    [1] = "Locker";
                    [2] = "Survivor_Fast_Exit";
                    [3] = workspace:WaitForChild(obj.Name, 9e9);
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Server_Event", 9e9):FireServer(unpack(args))
            end
        end
end
-- [FUNCTION] Self Heal
local isHealing = false
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Three then
        local lcplr = game:GetService("Players").LocalPlayer
        isHealing = not isHealing
        if isHealing then
            local args = {
                [1] = lcplr.Name;
                [2] = "Start";
                [3] = {
                    ["IsMending"] = false;
                    ["SelfHealing"] = true;
                };
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("ClientToServer", 9e9):WaitForChild("HealingEvent", 9e9):FireServer(unpack(args))

            task.spawn(function ()
                local values = game:GetService("Players").LocalPlayer.Backpack.Scripts.values
                local valueRN = values.HealthState.Value
                while true do
                    task.wait(0.1)
                    if values.HealthState.Value ~= valueRN then
                        isHealing = not isHealing
                        local args = {
                            [1] = lcplr.Name;
                            [2] = "Stop";
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("ClientToServer", 9e9):WaitForChild("HealingEvent", 9e9):FireServer(unpack(args))
                        break
                    end
                end
            end)
        else
            local args = {
                [1] = lcplr.Name;
                [2] = "Stop";
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("ClientToServer", 9e9):WaitForChild("HealingEvent", 9e9):FireServer(unpack(args))
        end
    end
end)

-- [FUNCTION] Heal Selected Player
local isHealingSomeone = false
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Four then
        isHealingSomeone = not isHealingSomeone
        if isHealingSomeone then
            local args = {
                [1] = _G.Config.input_TargetSurvName;
                [2] = "Start";
                [3] = {
                    ["IsMending"] = false;
                    ["SelfHealing"] = false;
                };
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("ClientToServer", 9e9):WaitForChild("HealingEvent", 9e9):FireServer(unpack(args))
            
            task.spawn(function ()
                local trgt = _G.Config.input_TargetSurvName
                local values = game:GetService("Players"):FindFirstChild(trgt).Backpack.Scripts.values
                if not values then
                    ttl("Critical error while healing someone")
                    warn("[HEAL SOMEONE] player doesnt founded or 'Backpack.Scripts.values' doesnt founded!")
                end
                while true do
                    task.wait(0.1)
                    if values.HealthState.Value ~= valueRN then
                        isHealingSomeone = not isHealingSomeone
                        local args = {
                            [1] = _G.Config.input_TargetSurvName;
                            [2] = "Stop";
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("ClientToServer", 9e9):WaitForChild("HealingEvent", 9e9):FireServer(unpack(args))
                        break
                    end
                end
            end)
        else
            local args = {
                [1] = _G.Config.input_TargetSurvName;
                [2] = "Stop";
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("ClientToServer", 9e9):WaitForChild("HealingEvent", 9e9):FireServer(unpack(args))
        end
    end
end)
-- [FUNCTION] Auto Wiggle 
function AutoWiggle()
    while _G.Config.enable_AutoWiggle do
        local function getKillerName()
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    local scriptsFolder = backpack:FindFirstChild("Scripts")
                    if scriptsFolder then
                        local killerFlag = scriptsFolder:FindFirstChild("Killer")
                        if killerFlag and killerFlag:IsA("BoolValue") and killerFlag.Value == true then
                            return player.Name
                        end
                    end
                end
            end
            return nil
        end
        local klrnm = getKillerName()
        local args = {
            [1] = "Wiggle",
            [2] = game:GetService("Players"):WaitForChild(klrnm, 9e9)
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Server_Event", 9e9):FireServer(unpack(args))
        task.wait(0.1)
    end
end
task.spawn(AutoWiggle)
-- [FUNCTION] Stun
function stun()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local lpValues = LocalPlayer.Backpack.Scripts.values

    local stunned = lpValues:FindFirstChild("Stunned")
    local isStunned = stunned.Value
    if isStunned then
        stunned.Value = false
        isStunned = false
    else
        stunned.Value = true
        isStunned = true
    end
end
-- [FUNCTION] Blind Killer : "Z" bind
local function getKillerName()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local scriptsFolder = backpack:FindFirstChild("Scripts")
            if scriptsFolder then
                local killerFlag = scriptsFolder:FindFirstChild("Killer")
                if killerFlag and killerFlag:IsA("BoolValue") and killerFlag.Value == true then
                    return player.Name
                end
            end
        end
    end
    return nil
end
local function blindklr(status)
    local klr = getKillerName()
    if status == "start" then
        local args = {
            [1] = "StartBlinding";
            [2] = workspace:WaitForChild(klr, 9e9):WaitForChild("Flash_Zone", 9e9);
        }
        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalSurvivor", 9e9):WaitForChild("Action", 9e9):WaitForChild("UseItem", 9e9):WaitForChild("Flashlight", 9e9):WaitForChild("Flashlight", 9e9):FireServer(unpack(args))
    else
        local args = {
            [1] = "StopBlinding";
        }
        game:GetService("Players").LocalPlayer:WaitForChild("Backpack", 9e9):WaitForChild("Scripts", 9e9):WaitForChild("GlobalSurvivor", 9e9):WaitForChild("Action", 9e9):WaitForChild("UseItem", 9e9):WaitForChild("Flashlight", 9e9):WaitForChild("Flashlight", 9e9):FireServer(unpack(args))
    end
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
        blindklr("start")
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
        blindklr("stop")
    end
end)
-- [FUNCTION] Teleport to Secret Place
function teleportToTemplate()
    local Player = game:GetService("Players").LocalPlayer
    local character = Player.Character or Player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    local tmp = workspace:FindFirstChild("SurvivorTemplate2")
    local try = nil
    if not tmp then
        try = workspace:FindFirstChild("Survivor_Template3")
        if not try then
            tmp = workspace:FindFirstChild("Sarcophagus")
        else
            tmp = workspace:FindFirstChild("Survivor_Template3")
        end
    end
    if root and tmp and tmp:IsA("Model") and tmp:FindFirstChild("PrimaryPart") then
        root.CFrame = tmp.PrimaryPart.CFrame + Vector3.new(2, 0, 2)
    elseif tmp and tmp:IsA("Model") then
        tmp.PrimaryPart = tmp:FindFirstChildWhichIsA("BasePart")
        if tmp.PrimaryPart then
            root.CFrame = tmp.PrimaryPart.CFrame + Vector3.new(2, 0, 2)
        else
            warn("Template -> BasePart?")
        end
    else
        warn("Template != model?")
    end
end
-- [FUNCTION] Teleport to Hatch
function teleportToHatch()
    local Player = game:GetService("Players").LocalPlayer
    local character = Player.Character or Player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    local hatch = workspace:FindFirstChild("Hatch")
    if root and hatch and hatch:IsA("Model") and hatch:FindFirstChild("PrimaryPart") then
        root.CFrame = hatch.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
    elseif hatch and hatch:IsA("Model") then
        hatch.PrimaryPart = hatch:FindFirstChildWhichIsA("BasePart")
        if hatch.PrimaryPart then
            root.CFrame = hatch.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
        else
            warn("Hatch -> BasePart ???")
        end
    else
        warn("Hatch -> Model ???")
    end
end
-- [FUNCTION] Teleport to ExitGates
function teleportToExitGate(teleported)
    local Player = game:GetService("Players").LocalPlayer
    local character = Player.Character or Player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    local eg1 = workspace:FindFirstChild("ExitGate1")
    local eg2 = workspace:FindFirstChild("ExitGate2")
    local esc1 = eg1.Escape_Trigger
    local esc2 = eg2.Escape_Trigger
    if root and eg1 and eg1:IsA("Model") and esc1 and eg2 and eg2:IsA("Model") and esc2 then
        if not teleported then
            root.CFrame = esc1.CFrame + Vector3.new(0, 0, 0)
        else
            root.CFrame = esc2.CFrame + Vector3.new(0, 0, 0)
        end
    else
        warn("ExitGate != model?")
    end
end
-- [FUNCTION] Teleport to Killer : "Up Arrow" bind
local function getKillerName()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local scriptsFolder = backpack:FindFirstChild("Scripts")
            if scriptsFolder then
                local killerFlag = scriptsFolder:FindFirstChild("Killer")
                if killerFlag and killerFlag:IsA("BoolValue") and killerFlag.Value == true then
                    return player.Name
                end
            end
        end
    end
    return nil
end
local function teleportToKiller()
    local killerName = getKillerName()
    if not killerName then
        warn("Killer ???")
        ttl("No Killer Founded!")
        return
    end
    local killerModel = workspace:FindFirstChild(killerName)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if killerModel and killerModel:IsA("Model") and root then
        local killerRoot = killerModel:FindFirstChild("HumanoidRootPart") or killerModel:FindFirstChildWhichIsA("BasePart")
        if killerRoot then
            root.CFrame = killerRoot.CFrame + Vector3.new(0, 0, -2)
        else
            warn("Killer -> HumanoidRootPart ???")
            ttl("Error while TP to Killer: #1")
        end
    else
        warn("Killer -> Workspace ???")
        ttl("Error while TP to Killer: #2")
    end
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Up then
        teleportToKiller()
    end
end)
-- [FUNCTION] Fly : "V" bind (ultra rage function)
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local FlySpeed = 35
local FlyActive = false
local BodyVelocity = nil
local function ToggleFly()
    FlyActive = not FlyActive
    if FlyActive then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.P = 1000
        BodyVelocity.Parent = HumanoidRootPart
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end
local function HandleFlyInput()
    if not FlyActive or not HumanoidRootPart or not BodyVelocity then
        return
    end
    local Camera = workspace.CurrentCamera
    local LookVector = Camera.CFrame.LookVector
    local RightVector = Camera.CFrame.RightVector
    local Direction = Vector3.new(0, 0, 0)
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
        Direction = Direction + LookVector
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
        Direction = Direction - LookVector
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
        Direction = Direction - RightVector
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
        Direction = Direction + RightVector
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
        Direction = Direction + Vector3.new(0, 1, 0)
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
        Direction = Direction + Vector3.new(0, -1, 0)
    end
    if Direction.Magnitude > 0 then
        Direction = Direction.Unit * FlySpeed
    end
    BodyVelocity.Velocity = Direction
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        ToggleFly()
    end
end)
game:GetService("RunService").Heartbeat:Connect(HandleFlyInput)
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    if FlyActive then
        ToggleFly()
        task.wait(0.1)
        ToggleFly()
    end
end)
-- [FUNCTION] Jump : "T" bind (funny function)
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local jumpForce = 40 -- Your jump force value
local canJump = true
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local jumpCD = 0.5
    if input.KeyCode == Enum.KeyCode.T then
        if not canJump then return end
        canJump = false
        humanoidRootPart.Velocity = Vector3.new(0, jumpForce, 0)
        task.wait(jumpCD)
        canJump = true
    end
end)
-- [FUNCTION] Rage Dash : "G" bind (rage function)
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local COOLDOWN = 0
local canDash = true
local rageDashSound = Instance.new("Sound")
rageDashSound.SoundId = "rbxassetid://7106310368"
rageDashSound.Volume = 3
rageDashSound.Parent = RootPart
local function playRageDashSound()
    if rageDashSound.IsPlaying then
        rageDashSound.TimePosition = 0
    else
        rageDashSound:Play()
    end
end
local function ragedash()
    if not canDash or not RootPart or Humanoid.Health <= 0 then return end
    canDash = false
    playRageDashSound()
    local Camera = workspace.CurrentCamera
    local LookVector = Camera.CFrame.LookVector * Vector3.new(1, 0, 1).Unit
    local offset = LookVector * tonumber(_G.Config.Dash_Value)
    local character = Player.Character or Player.CharacterAdded:Wait()
    character:PivotTo(character:GetPivot() + offset)
    task.wait(COOLDOWN)
    canDash = true
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
        ragedash()
    end
end)
-- [FUNCTION] Legit Dash : "F" bind (legit/rage function)
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local isDashing = false
local dashConnection = nil
local function LegitDash()
    local Character = Player.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not RootPart or Humanoid.Health <= 0 then return end
    local LookVector = RootPart.CFrame.LookVector * Vector3.new(1, 0, 1).Unit
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = LookVector * _G.Config.LegitDash_Value
    BodyVelocity.MaxForce = Vector3.new(1e6, 0, 1e6)
    BodyVelocity.P = 1e5
    BodyVelocity.Parent = RootPart
    task.delay(0.05, function()
        BodyVelocity:Destroy()
    end)
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
        if isDashing then return end
        isDashing = true
        dashConnection = RunService.Heartbeat:Connect(function(dt)
            LegitDash()
        end)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if dashConnection then
            dashConnection:Disconnect()
            dashConnection = nil
        end
        isDashing = false
    end
end)
-- [FUNCTION] MoonWalk : "X" bind (legit function)
local Player = game:GetService("Players").LocalPlayer

local RunService = game:GetService("RunService")
local MOONWALK_KEY = Enum.KeyCode.X
local WIGGLE_AMOUNT = 0.23
local WIGGLE_SPEED = 32
local MOONWALK_SPEED_MULTIPLIER = 1.0
local MoonwalkActive = false
local OriginalWalkSpeed = 16
local OriginalAutoRotate = true 
local WiggleAngle = 0
local function ToggleMoonwalk()
    MoonwalkActive = not MoonwalkActive
    if MoonwalkActive then
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            OriginalWalkSpeed = Player.Character.Humanoid.WalkSpeed
            OriginalAutoRotate = Player.Character.Humanoid.AutoRotate 
            Player.Character.Humanoid.WalkSpeed = OriginalWalkSpeed * MOONWALK_SPEED_MULTIPLIER
            Player.Character.Humanoid.AutoRotate = false
        end
    else
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = OriginalWalkSpeed
            Player.Character.Humanoid.AutoRotate = OriginalAutoRotate
        end
    end
end
RunService.Heartbeat:Connect(function(dt)
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if MoonwalkActive then
        local camera = workspace.CurrentCamera
        if camera then
            WiggleAngle = WiggleAngle + dt * WIGGLE_SPEED
            local wiggleOffset = math.sin(WiggleAngle) * WIGGLE_AMOUNT
            local cameraLook = camera.CFrame.LookVector
            local targetAngle
            if _G.Config.mw_Type == "Backward" then
                targetAngle = math.atan2(cameraLook.X, cameraLook.Z) + math.pi + wiggleOffset
                humanoid:Move(-cameraLook)
            elseif _G.Config.mw_Type == "Forward" then
                targetAngle = math.atan2(cameraLook.X, cameraLook.Z) + wiggleOffset
                humanoid:Move(cameraLook)
            elseif _G.Config.mw_Type == "Left Side" then
                targetAngle = math.atan2(cameraLook.X, cameraLook.Z) + math.pi / 2 + wiggleOffset
                local sideLook = Vector3.new(-cameraLook.Z, 0, cameraLook.X).Unit
                humanoid:Move(sideLook)
            elseif _G.Config.mw_Type == "Right Side" then
                targetAngle = math.atan2(cameraLook.X, cameraLook.Z) - math.pi / 2 + wiggleOffset
                local sideLook = Vector3.new(cameraLook.Z, 0, -cameraLook.X).Unit
                humanoid:Move(sideLook)
            end
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(
                Player.Character.HumanoidRootPart.Position
            ) * CFrame.Angles(0, targetAngle, 0)
        end
    end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == MOONWALK_KEY then
        ToggleMoonwalk()
    end
end)
Player.CharacterAdded:Connect(function(character)
    MoonwalkActive = false
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.AutoRotate = OriginalAutoRotate
    end
end)
-- [FUNCTION] Speedhack
local connection
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
        local player = game:GetService("Players").LocalPlayer
        local movement = game:GetService("ReplicatedStorage").Match.Players[player.Name].Movement
        
        if connection then
            connection:Disconnect()
            connection = nil
            movement:SetAttribute("Speed", movement:GetAttribute("DefaultSpeed"))
            ttl("Speedhack: OFF")
            return
        end

        ttl("Speedhack: ON")
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not player.Character then return end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            local values = player:FindFirstChild("Backpack") and player.Backpack.Scripts.values
            if not values then return end

            local newSpeed = movement:GetAttribute("DefaultSpeed")
            
            if values.HealthState and values.HealthState.Value == 0 and _G.Config.Speedhack_Crawl_value ~= 0 then
                newSpeed = newSpeed + _G.Config.Speedhack_Crawl_value
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character:FindFirstChildOfClass("Humanoid").WalkSpeed = newSpeed
                end
            elseif values.Crouching and values.Crouching.Value and _G.Config.Speedhack_Crouch_Value ~= 0 then
                newSpeed = newSpeed + _G.Config.Speedhack_Crouch_Value
            elseif _G.Config.enable_Player_Speedhack then
                for _, killer in pairs(game:GetService("Players"):GetPlayers()) do
                    if killer.Backpack and killer.Backpack.Scripts and killer.Backpack.Scripts.Killer and killer.Backpack.Scripts.Killer.Value and workspace[killer.Name]:FindFirstChild("Humanoid") then
                        movement:SetAttribute("SpeedMultiplier", 1)
                        newSpeed = workspace[killer.Name].Humanoid.WalkSpeed
                        break
                    end
                end
            else
                movement:SetAttribute("Speed", movement:GetAttribute("DefaultSpeed"))
            end
            
            movement:SetAttribute("Speed", newSpeed)
        end)
    end
end)
-- [FUNCTION] Teleport to Survivors : "DownArrow" bind
local LocalPlayer = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local LastSurv = nil
local function getSurvName()
    if _G.Config.input_TargetSurvName then
        local targetChar = workspace:FindFirstChild(_G.Config.input_TargetSurvName)
        if targetChar and targetChar:IsA("Model") then
            return _G.Config.input_TargetSurvName
        else
            warn("input_TargetSurvName -> workspace ??? tptosurvs")
            ttl("Survivor not Found!")
            _G.Config.input_TargetSurvName = nil
        end
    end
    local potentialTargets = {}
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer and (not LastSurv or player.Name ~= LastSurv) then
            local killerFlag = player:FindFirstChild("Backpack") and
                            player.Backpack:FindFirstChild("Scripts") and
                            player.Backpack.Scripts:FindFirstChild("Killer")
            
            if killerFlag and killerFlag:IsA("BoolValue") and not killerFlag.Value then
                table.insert(potentialTargets, player.Name)
            end
        end
    end
    if #potentialTargets > 0 then
        local selected = potentialTargets[math.random(1, #potentialTargets)]
        LastSurv = selected
        return selected
    end
    
    return nil
end
local function teleportToSurv()
    local survName = getSurvName()
    if not survName then
        local otherSurvivorsExist = false
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= LocalPlayer then
                local killerFlag = player:FindFirstChild("Backpack") and
                                player.Backpack:FindFirstChild("Scripts") and
                                player.Backpack.Scripts:FindFirstChild("Killer")
                if killerFlag and killerFlag:IsA("BoolValue") and not killerFlag.Value then
                    otherSurvivorsExist = true
                    break
                end
            end
        end
        if not otherSurvivorsExist then
            print("no such survs")
            ttl("No Such Survivors Found!")
        else
            warn("survs??? tp to surv")
            ttl("Critical Error while TP to Survivor: #1")
        end
        return
    end
    local survModel = workspace:FindFirstChild(survName)
    if not survModel or not survModel:IsA("Model") then
        warn("player model ??? tp to surv")
        ttl("Error while TP to Survivor: #1")
        return
    end
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 2)
    if not root then
        warn("error: cant tp; tp to surv")
        ttl("Critical Error while TP to Survivor: #2")
        return
    end
    local survRoot = survModel:FindFirstChild("HumanoidRootPart") or 
                    survModel:FindFirstChildWhichIsA("BasePart") or
                    survModel:WaitForChild("HumanoidRootPart", 2)
    if survRoot then
        local offset = CFrame.new(-2, 0, 0)
        root.CFrame = survRoot.CFrame * offset
        print("succes:", survName)
    else
        warn("error: cant tp to him; tp to surv")
        ttl("Critical Error while TP to Survivor: #3")
    end
end
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Down then
        teleportToSurv()
    end
end)
-- [FUNCTION] Remote Interaction : "N" bind
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function remotePlayers()
    local Players = game:GetService("Players")
    local Char = getCharacter()
    local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local targetChar = workspace:FindFirstChild(_G.Config.input_TargetSurvName)
    if not targetChar then
        warn("workspace ??? remoteplayers")
        ttl("No Target!")
        return
    end

    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        warn("HumanoidRootPart ??? remoteplayers")
        ttl("Critical Error while Doing Interaction: #1")
        return
    end
    local targetPlayer = Players:FindFirstChild(_G.Config.input_TargetSurvName)
    if not targetPlayer then
        warn("player ??? remoteplayers")
        ttl("No Target!")
        return
    end
    local hookedValue = targetPlayer:FindFirstChild("Backpack") 
        and targetPlayer.Backpack:FindFirstChild("Scripts") 
        and targetPlayer.Backpack.Scripts:FindFirstChild("values") 
        and targetPlayer.Backpack.Scripts.values:FindFirstChild("Hooked")

    local isHooked = hookedValue and hookedValue.Value
    local survHook = nil

    if isHooked then
        for _, hook in pairs(workspace:GetChildren()) do
            if hook:IsA("Model") and hook.Name:match("Hook%d") then
                local plr = hook.Panel.Player
                if plr.Value == _G.Config.input_TargetSurvName then
                    survHook = hook.Trigger
                end
            end
        end
        if survHook == nil then
            warn('error: survHook is nil')
            ttl("Critical Error: survHook#1")
        else
            local originalCFrame = survHook.CFrame
            survHook.CFrame = HRP.CFrame + Vector3.new(0, 0, 2)
            task.wait(1.0)
            survHook.CFrame = originalCFrame
        end
    end
end
-- EXIT GATE INTERACTION
local openingExit = false
local function remoteExitGate()
    openingExit = not openingExit
    if openingExit then
        local args = {
            [1] = "Open";
        }

        workspace:WaitForChild("ExitGate2", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
        local args = {
            [1] = "Open";
        }

        workspace:WaitForChild("ExitGate1", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
    else
        local args = {
            [1] = "Close";
        }

        workspace:WaitForChild("ExitGate2", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
        local args = {
            [1] = "Close";
        }

        workspace:WaitForChild("ExitGate1", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
    end
end
-- HOOKS INTERACTION
local sabotaging = false
local function remoteHooks()
    sabotaging = not sabotaging
    for _, hk in pairs(workspace:GetChildren()) do
        if hk.Name:match("Hook%d") then
            local target = hk.Name
            if sabotaging then
                local args = {
                    [1] = {
                        ["D9v8"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C20"] = game:GetService("Players").LocalPlayer;
                            ["C22"] = "O101";
                        };
                        ["Bbh1O"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C20"] = game:GetService("Players").LocalPlayer;
                            ["C22"] = "O101";
                        };
                        ["Dvh1O"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C20"] = game:GetService("Players").LocalPlayer;
                            ["C22"] = "O101";
                        };
                        ["Dbh1O"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C20"] = game:GetService("Players").LocalPlayer;
                            ["C22"] = "O101";
                        };
                        ["Dhv8"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C20"] = game:GetService("Players").LocalPlayer;
                            ["C22"] = "O101";
                        };
                    };
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("NewPropertie", 9e9):FireServer(unpack(args))
            else
                local args = {
                    [1] = {
                        ["D9v8"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C22"] = "O101";
                        };
                        ["Bbh1O"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C22"] = "O101";
                        };
                        ["Dvh1O"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C22"] = "O101";
                        };
                        ["Dbh1O"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C22"] = "O101";
                        };
                        ["Dhv8"] = {
                            ["C21"] = workspace:WaitForChild(target, 9e9):WaitForChild("Panel", 9e9):WaitForChild("Sabotaging", 9e9);
                            ["C22"] = "O101";
                        };
                    };
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("NewPropertie", 9e9):FireServer(unpack(args))
            end
        end
    end 
end
-- REMOTE GENERATOR
local function getGenerator()
    local highestProgress = -1
    local bestSpot = nil
    for _, gen in pairs(workspace:GetChildren()) do
        if gen.Name:match("Generator") and gen:FindFirstChild("Panel") and gen:FindFirstChild("CollisionBox") then
            local panel = gen.Panel
            local progress = panel:FindFirstChild("Progress")
            local workspots = gen:FindFirstChild("Workspots")
            if progress and progress:IsA("NumberValue") and progress.Value < 1000 and workspots then
                for _, sideName in ipairs({"Front", "Back", "Left", "Right"}) do
                    local part = workspots:FindFirstChild(sideName)
                    if part and part:IsA("BasePart") then
                        local deactivated = part:FindFirstChild("Deactivated")
                        local ocuped = part:FindFirstChild("Ocuped")
                        local ocupant = part:FindFirstChild("Ocupant")
                        local ocupedDeactivated = ocuped and ocuped:FindFirstChild("Deactivated")
                        local isDeactivated = deactivated and deactivated.Value
                        local isOcuped = ocuped and ocuped.Value
                        local isOcupedDeactivated = ocupedDeactivated and ocupedDeactivated.Value
                        local isOcupantBusy = ocupant and ocupant.Value ~= ""
                        if not isDeactivated and not isOcuped and not isOcupedDeactivated and not isOcupantBusy then
                            if progress.Value > highestProgress then
                                highestProgress = progress.Value
                                bestSpot = part
                            end
                        end
                    end
                end
            end
        end
    end
    return bestSpot
end
local function remoteRepair()
    local Char = getCharacter()
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local targetPart = getGenerator()
    if targetPart == nil then
        warn("gen found error: target part is nil!")
        ttl("Gen Found Error!")
    end
    local originalCFrame = HRP.CFrame
    if not targetPart then
        warn("No suitable generator found (maybe all occupied?)")
        ttl("No Suitable Generators Found!")
        return
    end
    HRP.CFrame = targetPart.CFrame + Vector3.new(0, 0, 0)
    local clickDetected = false
    local connection

    connection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            clickDetected = true
            connection:Disconnect()
        end
    end)
    local timer = 0
    while not clickDetected and timer < 5 do
        task.wait(0.05)
        timer += 0.05
    end
    task.wait(0.1)
    HRP.CFrame = originalCFrame
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        if _G.Config.remoteIntType1 == "Players" then
            remotePlayers()
        elseif _G.Config.remoteIntType1 == "Exit Gates" then
            remoteExitGate()
        elseif _G.Config.remoteIntType1 == "Hooks" then
            remoteHooks()
        elseif _G.Config.remoteIntType1 == "Generators" then
            remoteRepair()
        end
    end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        if _G.Config.remoteIntType2 == "Players" then
            remotePlayers()
        elseif _G.Config.remoteIntType2 == "Exit Gates" then
            remoteExitGate()
        elseif _G.Config.remoteIntType2 == "Hooks" then
            remoteHooks()
        elseif _G.Config.remoteIntType2 == "Generators" then
            remoteRepair()
        end
    end
end)
-- Animations
local Humanoid = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")
local played = false
local animTrack = nil
local animationId = "1"
local function playOverrideAnimation(animationId, play)
    if _G.Config.selected_Animation == "Snake It" then
        animationId = "10258272240"
    elseif _G.Config.selected_Animation == "Get Em" then
        animationId = "15919624781"
    elseif _G.Config.selected_Animation == "Think" then
        animationId = "121839807114786"
    elseif _G.Config.selected_Animation == "Bowshot" then
        animationId = "131833227843012"
    elseif _G.Config.selected_Animation == "1st place" then
        animationId = "118211011052686"
    elseif _G.Config.selected_Animation == "2nd place" then
        animationId = "133419229272999"
    elseif _G.Config.selected_Animation == "3rd place" then
        animationId = "83657343152240"
    elseif _G.Config.selected_Animation == "Point" then
        animationId = "16520476888"
    elseif _G.Config.selected_Animation == "Follow" then
        animationId = "16520472961"
    elseif _G.Config.selected_Animation == "Strange Movement" then
        animationId = "17006953862" 
    elseif _G.Config.selected_Animation == "Hooked" then
        animationId = "18906020019"
    elseif _G.Config.selected_Animation == "Picked Up" then
        animationId = "136738311253396"
    elseif _G.Config.selected_Animation == "Locker Grabbed" then
        animationId = "15947959258"
    elseif _G.Config.selected_Animation == "Escape" then
        animationId = "15081683831"
    else
        animationId = "10258272240"
    end
    if play then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://"..animationId
        animTrack = Humanoid:LoadAnimation(anim)
        animTrack.Priority = Enum.AnimationPriority.Action4
        animTrack.Name = "OverrideAnimation"
        animTrack:Play()
    elseif animTrack then
        animTrack:Stop()
        animTrack = nil
    end
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.B and not gameProcessed then
        played = not played
        playOverrideAnimation(animationId, played)
    end
end)
print('b - done')
