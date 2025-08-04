-- [FUNCTION] MoonWalk : "X" bind (legit function)
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
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
    if input.KeyCode == Enum.KeyCode.X then
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
-- [FUNCTION] Auto Wiggle
function AutoWiggle()
    while true do
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
-- [FUNCTION] Auto Skillcheck
local RunService = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")
local lp = game:GetService("Players").LocalPlayer
local gui = lp:WaitForChild("PlayerGui")
local hud = gui:WaitForChild("HUD")
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
        if skillCheck and skillCheck.Visible then

            local needle = skillCheck:FindFirstChild("Needle")
            if not needle then
                warn("[AutoSkillcheck] Needle doesnt founded")
                continue
            end

            local targetZone = getLatestZone(skillCheck, autoSkillCheckMode)
            if not targetZone then
                continue
            end
            needle.Rotation = targetZone.Rotation - 6
            pressSpace()
            repeat task.wait(0.1) until not skillCheck.Visible
            task.wait(5)
            if conn and conn.Connected then
                conn:Disconnect()
            end
        end
    end
end)
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
-- [FUNCTION] Magic Hatchet
function MagicHatchet()
    local args = {
        [1] = game:GetService("Players"):WaitForChild(_G.Config.input_TargetSurvName, 9e9);
    }

    game:GetService("ReplicatedStorage"):WaitForChild("-LockerAuras", 9e9):WaitForChild("Hatchet_Event", 9e9):FireServer(unpack(args))
end
game:GetService("UserInputService").InputBegan:Connect(function (input, gameProcessed)
    if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.RightAlt) and input.KeyCode == Enum.KeyCode.Five and not gameProcessed then
        MagicHatchet()
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
-- [FUNCTION] Grab Survivor
function GrabSurvivor()
    local args = {
        [1] = "Carry";
        [2] = "Pickup_Default";
        [3] = game:GetService("Players"):WaitForChild(_G.Config.input_TargetSurvName, 9e9);
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Server_Event", 9e9):FireServer(unpack(args))
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
-- [FUNCTION] Block All Windows
function BlockAllWindows(state)
    for _, i in pairs(workspace:GetChildren()) do
        if i.Name:match("Window%d") then
            local args = {
                [1] = {
                    ["D9v8"] = {
                        ["C21"] = workspace:WaitForChild(i.Name, 9e9):WaitForChild("Panel", 9e9):WaitForChild("shadowvault", 9e9);
                        ["C20"] = state;
                        ["C22"] = "B101";
                    };
                    ["Bbh1O"] = {
                        ["C21"] = workspace:WaitForChild(i.Name, 9e9):WaitForChild("Panel", 9e9):WaitForChild("shadowvault", 9e9);
                        ["C20"] = state;
                        ["C22"] = "B101";
                    };
                    ["Dvh1O"] = {
                        ["C21"] = workspace:WaitForChild(i.Name, 9e9):WaitForChild("Panel", 9e9):WaitForChild("shadowvault", 9e9);
                        ["C20"] = state;
                        ["C22"] = "B101";
                    };
                    ["Dbh1O"] = {
                        ["C21"] = workspace:WaitForChild(i.Name, 9e9):WaitForChild("Panel", 9e9):WaitForChild("shadowvault", 9e9);
                        ["C20"] = state;
                        ["C22"] = "B101";
                    };
                    ["Dhv8"] = {
                        ["C21"] = workspace:WaitForChild(i.Name, 9e9):WaitForChild("Panel", 9e9):WaitForChild("shadowvault", 9e9);
                        ["C20"] = state;
                        ["C22"] = "B101";
                    };
                };
            }

            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("NewPropertie", 9e9):FireServer(unpack(args))
        end
    end
end
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
-- [FUNCTION] Escape
function escape()
    local args = {
        [1] = "Open";
    }

    workspace:WaitForChild("ExitGate2", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
    local args = {
        [1] = "Open";
    }

    workspace:WaitForChild("ExitGate1", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
    task.wait(4)
    local args = {
        [1] = "Close";
    }

    workspace:WaitForChild("ExitGate2", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
    local args = {
        [1] = "Close";
    }

    workspace:WaitForChild("ExitGate1", 9e9):WaitForChild("Panel", 9e9):WaitForChild("Exit_Gate", 9e9):FireServer(unpack(args))
    teleportToExitGate(true)
end
-- [FUNCTION] Teleport to Killer
function getKillerName()
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
function teleportToKiller()
    local killerName = getKillerName()
    if not killerName then
        warn("Killer ???")
        ttl("No Killer Founded!")
        return
    end
    local killerModel = workspace:FindFirstChild(killerName)
    local character = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
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
-- [FUNCTION] Teleport to Survivors
local LocalPlayer = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local LastSurv = nil
function getSurvName()
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
function teleportToSurv()
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
-- [FUNCTION] Remote Interaction : "N" bind
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function remotePlayers()
    local args = {
        "Hook",
        "Unhook",
        game:GetService("Players"):WaitForChild(_G.Config.input_TargetSurvName).Character,
        workspace:WaitForChild("Hook4")
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Server_Event"):FireServer(unpack(args))
    local args = {
        true
    }
    game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("GlobalSurvivor"):WaitForChild("Action"):WaitForChild("Rescue"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
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
        if _G.Config.remoteIntType1 == "Rescue" then
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
        if _G.Config.remoteIntType2 == "Rescue" then
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
-- Fast TP access
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
		if input.KeyCode == Enum.KeyCode.One then
			teleportToKiller()
		elseif input.KeyCode == Enum.KeyCode.Two then
			teleportToSurv()
		elseif input.KeyCode == Enum.KeyCode.Three then
			teleportToExitGate(false)
        elseif input.KeyCode == Enum.KeyCode.Four then
			teleportToExitGate(true)
        elseif input.KeyCode == Enum.KeyCode.Five then
			teleportToHatch()
        elseif input.KeyCode == Enum.KeyCode.Six then
			teleportToTemplate()
		end
	end
end)
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
-- [FUNCTION] Self Heal
local isHealing = false
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.RightAlt) and input.KeyCode == Enum.KeyCode.Three then
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
    if not gameProcessed and not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.RightAlt) and input.KeyCode == Enum.KeyCode.Four then
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
        else
            local args = {
                [1] = _G.Config.input_TargetSurvName;
                [2] = "Stop";
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("ClientToServer", 9e9):WaitForChild("HealingEvent", 9e9):FireServer(unpack(args))
        end
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
    local offset = LookVector * 20
    local character = Player.Character or Player.CharacterAdded:Wait()
    character:PivotTo(character:GetPivot() + offset)
    task.wait(COOLDOWN)
    canDash = true
end
local function kickself()
    if not canDash or not RootPart or Humanoid.Health <= 0 then return end
    canDash = false
    playRageDashSound()
    local Camera = workspace.CurrentCamera
    local LookVector = Camera.CFrame.LookVector.Unit
    local launchVector = (LookVector * 40 + Vector3.new(0, 50, 0))
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = launchVector
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.P = 1e4
    bodyVelocity.Parent = RootPart
    task.delay(0.5, function()
        bodyVelocity:Destroy()
    end)
    task.wait(COOLDOWN)
    canDash = true
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
        if _G.Config.dash_type == "rage" then
            ragedash()
        else
            kickself()
        end
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
    BodyVelocity.Velocity = LookVector * 55
    BodyVelocity.MaxForce = Vector3.new(1e6, 0, 1e6)
    BodyVelocity.P = 1e5
    BodyVelocity.Parent = RootPart
    task.delay(0.05, function()
        BodyVelocity:Destroy()
    end)
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not _G.Config.m1_enabled then return end
	elseif input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode ~= Enum.KeyCode.F then return end
	else
		return
	end
	if isDashing then return end
	isDashing = true
	dashConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
		LegitDash()
	end)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not _G.Config.m1_enabled then return end
	elseif input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode ~= Enum.KeyCode.F then return end
	else
		return
	end
	if dashConnection then
		dashConnection:Disconnect()
		dashConnection = nil
	end
	isDashing = false
end)
-- Animations
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimationWheel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")
local WheelFrame = Instance.new("Frame")
WheelFrame.Size = UDim2.new(0, 500, 0, 500)
WheelFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
WheelFrame.BackgroundTransparency = 1
WheelFrame.Visible = false
WheelFrame.Parent = ScreenGui
local donutOuter = Instance.new("Frame")
donutOuter.Size = UDim2.new(1, 0, 1, 0)
donutOuter.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
donutOuter.BackgroundTransparency = 0.6
donutOuter.AnchorPoint = Vector2.new(0.5, 0.5)
donutOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
donutOuter.Parent = WheelFrame
donutOuter.ZIndex = 1
donutOuter.ClipsDescendants = true
local outerCorner = Instance.new("UICorner")
outerCorner.CornerRadius = UDim.new(0.5, 0)
outerCorner.Parent = donutOuter
local hole = Instance.new("Frame")
hole.Size = UDim2.new(0, 150, 0, 150)
hole.Position = UDim2.new(0.5, -75, 0.5, -75)
hole.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
hole.BackgroundTransparency = 0.7
hole.ZIndex = 2
hole.Parent = donutOuter
local holeCorner = Instance.new("UICorner")
holeCorner.CornerRadius = UDim.new(0.5, 0)
holeCorner.Parent = hole
local animations = {
	"Snake It", "Get Em", "Think", "Bowshot", "1st place", "2nd place",
	"3rd place", "Point", "Follow", "Strange Movement", "Hooked",
	"Picked Up", "Locker Grabbed", "Escape"
}
local radius = 190
local center = Vector2.new(250, 250)
local Buttons = {}
local sectorCount = #animations
function normalizeAngle(angle)
	if angle < 0 then
		return angle + 2 * math.pi
	end
	return angle
end
for i, name in ipairs(animations) do
	local angle = (2 * math.pi / sectorCount) * (i - 1) - math.pi/2
	local offset = Vector2.new(math.cos(angle), math.sin(angle)) * radius
	local pos = center + offset

	local button = Instance.new("TextLabel")
	button.Size = UDim2.new(0, 120, 0, 40)
	button.Position = UDim2.new(0, pos.X, 0, pos.Y)
	button.BackgroundTransparency = 1
	button.Text = name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.BorderSizePixel = 0
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.Name = name
	button.ZIndex = 2
	button.Parent = WheelFrame

	Buttons[i] = {
		Button = button,
		Name = name
	}
end
local function highlight(buttonToHighlight)
	for _, data in ipairs(Buttons) do
		local btn = data.Button
		if btn == buttonToHighlight then
			btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            btn.BackgroundTransparency = 0.5
		else
            btn.BackgroundTransparency = 1
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end
	end
end
local Humanoid = player.Character:WaitForChild("Humanoid")
local animTrack = nil
local function playAnim(name)
	local ids = {
		["Snake It"] = "10258272240",
		["Get Em"] = "15919624781",
		["Think"] = "121839807114786",
		["Bowshot"] = "131833227843012",
		["1st place"] = "118211011052686",
		["2nd place"] = "133419229272999",
		["3rd place"] = "83657343152240",
		["Point"] = "16520476888",
		["Follow"] = "16520472961",
		["Strange Movement"] = "17006953862",
		["Hooked"] = "18906020019",
		["Picked Up"] = "136738311253396",
		["Locker Grabbed"] = "15947959258",
		["Escape"] = "15081683831"
	}
	if animTrack then
		animTrack:Stop()
	end
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. (ids[name] or ids["Snake It"])
	animTrack = Humanoid:LoadAnimation(anim)
	animTrack.Priority = Enum.AnimationPriority.Action4
	animTrack:Play()
end
local function setCursorState(state)
	if state then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	end
end
local wheelOpen = false
local selectedButton = nil
for _, data in ipairs(Buttons) do
	data.Button.MouseEnter:Connect(function()
		selectedButton = data.Button
		highlight(selectedButton)
	end)
	data.Button.MouseLeave:Connect(function()
		selectedButton = nil
		highlight(nil)
	end)
end
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.B then
		if animTrack then
			animTrack:Stop()
			animTrack = nil
		end
		setCursorState(true)
		WheelFrame.Visible = true
		wheelOpen = true
	end
end)
UserInputService.InputEnded:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.B and wheelOpen then
		setCursorState(false)
		wheelOpen = false
		WheelFrame.Visible = false

		if selectedButton then
			playAnim(selectedButton.Name)
		end
		selectedButton = nil
	end
end)
print('#2 done')
