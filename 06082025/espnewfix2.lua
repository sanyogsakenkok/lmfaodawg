-- players
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPPlayerCache = {}
local ESPConnections = {}
local ESPHeartbeatConnection = nil

function CreatePlayerTag(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Tag_" .. player.Name
	billboard.Adornee = player.Character.HumanoidRootPart
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 5000
	billboard.LightInfluence = 0

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextStrokeTransparency = 0.5
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14

	label.Text = player.Name

	if player.Team then
		label.TextColor3 = player.Team.Name == "Survivor" and Color3.new(1, 1, 1)
			or player.Team.Name == "Killer" and Color3.new(1, 0, 0)
			or Color3.new(0, 0, 1)
	else
		label.TextColor3 = Color3.new(0, 0, 1)
	end

	label.Parent = billboard
	return billboard
end

function UpdatePlayerHighlight(player, highlight)
	local bp = player:FindFirstChild("Backpack")
	local scr = bp and bp:FindFirstChild("Scripts")
	local values = scr and scr:FindFirstChild("values")
	local hs = values and values:FindFirstChild("HealthState")
	if not hs or not hs:IsA("IntValue") then return end

	local value = hs.Value
	if value == 2 then
		highlight.FillColor = player.Team == LocalPlayer.Team and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	elseif value == 1 then
		highlight.FillColor = player.Team == LocalPlayer.Team and Color3.new(1, 1, 0) or Color3.new(1, 0, 0)
	elseif value == 0 then
		highlight.FillColor = player.Team == LocalPlayer.Team and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
	else
		highlight.FillColor = Color3.new(0, 0, 1)
	end
end

function AddESPToPlayer(player)
	if player == LocalPlayer then return end
	if ESPPlayerCache[player] then return end

	function applyESP()
		local character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then return end

		local highlight = Instance.new("Highlight")
		highlight.Name = "PlayerESP_Highlight_" .. player.Name
		highlight.FillTransparency = 0.3
		highlight.OutlineColor = Color3.new(0, 0, 0)
		highlight.OutlineTransparency = 1
		highlight.Parent = character

		UpdatePlayerHighlight(player, highlight)

		local tag = CreatePlayerTag(player)
		if tag then
			tag.Parent = character
		end

		ESPPlayerCache[player] = {
			Highlight = highlight,
			Billboard = tag,
		}
	end

	applyESP()

	local conn = player.CharacterAdded:Connect(function()
		task.wait(0.5)
		if ESPPlayerCache[player] then
			if ESPPlayerCache[player].Highlight then ESPPlayerCache[player].Highlight:Destroy() end
			if ESPPlayerCache[player].Billboard then ESPPlayerCache[player].Billboard:Destroy() end
		end
		applyESP()
	end)

	ESPConnections[player] = conn
	if _G.Config.skeleton then
		local function newLine()
			local line = Drawing.new("Line")
			line.Thickness = 2
			line.Color = Color3.new(1, 1, 1)
			line.Transparency = 1
			line.Visible = true
			return line
		end

		local skeleton = {
			HeadToTorso = newLine(),
			TorsoToLeftUpperArm = newLine(),
			LeftUpperArmToLeftLowerArm = newLine(),
			LeftLowerArmToLeftHand = newLine(),
			TorsoToRightUpperArm = newLine(),
			RightUpperArmToRightLowerArm = newLine(),
			RightLowerArmToRightHand = newLine(),
			TorsoToLeftUpperLeg = newLine(),
			LeftUpperLegToLeftLowerLeg = newLine(),
			LeftLowerLegToLeftFoot = newLine(),
			TorsoToRightUpperLeg = newLine(),
			RightUpperLegToRightLowerLeg = newLine(),
			RightLowerLegToRightFoot = newLine()
		}

		ESPPlayerCache[player].Skeleton = skeleton
	end
end

function EnablePlayersESP()
	for _, player in ipairs(Players:GetPlayers()) do
		AddESPToPlayer(player)
	end

	ESPConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
		task.wait(1)
		AddESPToPlayer(player)
	end)

	ESPConnections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(player)
		if ESPPlayerCache[player] then
            if ESPPlayerCache[player].Highlight then ESPPlayerCache[player].Highlight:Destroy() end
            if ESPPlayerCache[player].Billboard then ESPPlayerCache[player].Billboard:Destroy() end
            if ESPPlayerCache[player].Skeleton then
                for _, line in pairs(ESPPlayerCache[player].Skeleton) do
                    if line then line:Remove() end
                end
            end
            ESPPlayerCache[player] = nil
        end

		if ESPConnections[player] then
			ESPConnections[player]:Disconnect()
			ESPConnections[player] = nil
		end
	end)

	ESPHeartbeatConnection = RunService.Heartbeat:Connect(function()
		for player, data in pairs(ESPPlayerCache) do
			-- Проверка: если игрок или персонаж исчез — очищаем
			if not player or not player:IsDescendantOf(game) or not player.Character then
				if data.Highlight then data.Highlight:Destroy() end
				if data.Billboard then data.Billboard:Destroy() end
				if data.Skeleton then
					for _, line in pairs(data.Skeleton) do
						if line then line:Remove() end
					end
				end
				ESPPlayerCache[player] = nil
				continue
			end

			-- Обновление дистанции
			if data.Billboard and data.Billboard:FindFirstChildOfClass("TextLabel") then
				local label = data.Billboard:FindFirstChildOfClass("TextLabel")
				local character = player.Character
				local hrp = character and character:FindFirstChild("HumanoidRootPart")
				local myChar = LocalPlayer.Character
				local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

				if hrp and myHRP then
					local dist = (myHRP.Position - hrp.Position).Magnitude
					label.Text = string.format("%s [ %.1f m ]", player.Name, dist)
				end
			end

			-- Обновление цвета подсветки
			if data.Highlight then
				UpdatePlayerHighlight(player, data.Highlight)
			end

			-- Рисуем скелет
			if _G.Config.skeleton and data.Skeleton then
			local char = player.Character
			if char then
				local cam = workspace.CurrentCamera
				local function toScreen(part)
					if not part then return nil end
					local pos, visible = cam:WorldToViewportPoint(part.Position)
					return visible and Vector2.new(pos.X, pos.Y) or nil
				end

				local head = char:FindFirstChild("Head")
				local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("LowerTorso")
				local leftUpperArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
				local leftLowerArm = char:FindFirstChild("LeftLowerArm") or char:FindFirstChild("Left Forearm")
				local leftHand = char:FindFirstChild("LeftHand")
				local rightUpperArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
				local rightLowerArm = char:FindFirstChild("RightLowerArm") or char:FindFirstChild("Right Forearm")
				local rightHand = char:FindFirstChild("RightHand")
				local leftUpperLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
				local leftLowerLeg = char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("Left Leg")
				local leftFoot = char:FindFirstChild("LeftFoot")
				local rightUpperLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
				local rightLowerLeg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")
				local rightFoot = char:FindFirstChild("RightFoot")

				local skeleton = data.Skeleton

				local function drawLine(line, a, b)
					local pa = toScreen(a)
					local pb = toScreen(b)
					if pa and pb then
						line.From = pa
						line.To = pb
						line.Visible = true
					else
						line.Visible = false
					end
				end

				-- Без neck
				drawLine(skeleton.HeadToTorso, head, torso)
				drawLine(skeleton.TorsoToLeftUpperArm, torso, leftUpperArm)
				drawLine(skeleton.LeftUpperArmToLeftLowerArm, leftUpperArm, leftLowerArm)
				drawLine(skeleton.LeftLowerArmToLeftHand, leftLowerArm, leftHand)
				drawLine(skeleton.TorsoToRightUpperArm, torso, rightUpperArm)
				drawLine(skeleton.RightUpperArmToRightLowerArm, rightUpperArm, rightLowerArm)
				drawLine(skeleton.RightLowerArmToRightHand, rightLowerArm, rightHand)
				drawLine(skeleton.TorsoToLeftUpperLeg, torso, leftUpperLeg)
				drawLine(skeleton.LeftUpperLegToLeftLowerLeg, leftUpperLeg, leftLowerLeg)
				drawLine(skeleton.LeftLowerLegToLeftFoot, leftLowerLeg, leftFoot)
				drawLine(skeleton.TorsoToRightUpperLeg, torso, rightUpperLeg)
				drawLine(skeleton.RightUpperLegToRightLowerLeg, rightUpperLeg, rightLowerLeg)
				drawLine(skeleton.RightLowerLegToRightFoot, rightLowerLeg, rightFoot)
			end
		elseif data.Skeleton then
			for _, line in pairs(data.Skeleton) do
				line.Visible = false
			end
		end
		end
	end)
end

function DisablePlayersESP()
	for player, data in pairs(ESPPlayerCache) do
        if data.Highlight then data.Highlight:Destroy() end
        if data.Billboard then data.Billboard:Destroy() end
        if data.Skeleton then
            for _, line in pairs(data.Skeleton) do
                if line then
                    line:Remove()
                end
            end
        end
    end
	ESPPlayerCache = {}

	for key, conn in pairs(ESPConnections) do
		if typeof(conn) == "RBXScriptConnection" then
			conn:Disconnect()
		end
	end
	ESPConnections = {}

	if ESPHeartbeatConnection then
		ESPHeartbeatConnection:Disconnect()
		ESPHeartbeatConnection = nil
	end
end

function TogglePlayersESP(state)
	if state then
		EnablePlayersESP()
	else
		DisablePlayersESP()
	end
end

-- objects
local ESPObjects = {}
local RunService = game:GetService("RunService")

function getDistance(obj)
	local player = game.Players.LocalPlayer
	local char = player and player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return math.huge end

	local part = obj:FindFirstChildWhichIsA("BasePart", true) or obj
	if not part:IsA("BasePart") then return math.huge end

	return (hrp.Position - part.Position).Magnitude
end

function enableObjectESP(objectName, labelText, color)
	if ESPObjects[objectName] then return end
	ESPObjects[objectName] = {}

	local Workspace = game:GetService("Workspace")

	for _, obj in pairs(Workspace:GetChildren()) do
		local isMatch = false

		if objectName == "Hatch" and obj.Name == "Hatch" then
			isMatch = true

		elseif objectName == "ExitGate" and obj.Name:match("ExitGate%d") then
			local Panel = obj:FindFirstChild("Panel")
			local Progress = Panel and Panel:FindFirstChild("Progress")
			local WallMount = obj:FindFirstChild("Wall_Mount")
			if not Panel or not Progress or not WallMount then continue end

			local billboard = Instance.new("BillboardGui")
			billboard.Name = obj.Name .. "_Label"
			billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, 1, 0)
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.Enabled = false

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.TextStrokeTransparency = 0
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextColor3 = color
			textLabel.Text = Progress.Value >= 1000 and " [ Exit Gate ] " or "[ Exit Gate - " .. tostring(math.floor(Progress.Value / 10)) .. "% ]"
			textLabel.TextSize = 12
			textLabel.Parent = billboard
			billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

			table.insert(ESPObjects[objectName], billboard)

			Progress.Changed:Connect(function()
				textLabel.Text = Progress.Value >= 1000 and "[ Exit Gate ]" or "[ Exit Gate - " .. tostring(math.floor(Progress.Value / 10)) .. "% ]"
			end)

			continue

		elseif objectName == "Generator" and obj.Name:match("Generator%d") then
			local panel = obj:FindFirstChild("Panel")
			local progress = panel and panel:FindFirstChild("Progress")
			if not progress then continue end

			local billboard = Instance.new("BillboardGui")
			billboard.Name = obj.Name .. "_Label"
			billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
			billboard.Size = UDim2.new(0, 150, 0, 40)
			billboard.StudsOffset = Vector3.new(0, -2, 0)
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.Enabled = false

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 0, 25)
			textLabel.Position = UDim2.new(0, 0, 0, 12)
			textLabel.BackgroundTransparency = 1
			textLabel.TextColor3 = color
			textLabel.TextStrokeTransparency = 0
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 12
			textLabel.Text = progress.Value >= 1000 and "" or "[ Generator - " .. tostring(math.floor(progress.Value / 10)) .. "% ]"
			textLabel.Parent = billboard
			billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard
            
			table.insert(ESPObjects[objectName], billboard)

			progress.Changed:Connect(function()
				if progress.Value >= 1000 then
					textLabel.Text = ""
                    distanceLabel.Visible = false
				else
					textLabel.Text = "[ Generator - " .. tostring(math.floor(progress.Value / 10)) .. "% ]"
				end
			end)

			continue

		elseif objectName == "Window" and obj.Name:match("Window%d") then
			local windPanel = obj:FindFirstChild("Panel")
			local windBlocked = windPanel and windPanel:FindFirstChild("shadowvault")
            local Blocked = windPanel and windPanel:FindFirstChild("Blocked")
			if not windBlocked or not windBlocked:IsA("BoolValue") then continue end

			local billboard = Instance.new("BillboardGui")
			billboard.Name = obj.Name .. "_Label"
			billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, 1, 0)
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.Enabled = false

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.TextStrokeTransparency = 0
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 10
			textLabel.Parent = billboard
			billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

			table.insert(ESPObjects[objectName], billboard)

			function updateText()
				if not windBlocked.Value and not Blocked.Value then
					textLabel.Text = "[ Window ]"
					textLabel.TextColor3 = color
				else
					textLabel.Text = "[ Blocked Window ]"
					textLabel.TextColor3 = Color3.new(1, 1, 1)
                    task.wait(1)
                    if _G.Config.unblock_window == "ON" then
                        Blocked.Value = false
                        windBlocked.Value = false
                    end
				end
			end

			updateText()
            windBlocked.Changed:Connect(updateText)
            Blocked.Changed:Connect(updateText)

			continue
        elseif objectName == "Hook" and obj.Name:match("Hook%d") then
			local hkPanel = obj:FindFirstChild("Panel")
			local hkSabot = hkPanel and hkPanel:FindFirstChild("Sabotaging")
            local hkProgress = hkPanel and hkPanel:FindFirstChild("Progress")

			local billboard = Instance.new("BillboardGui")
			billboard.Name = obj.Name .. "_Label"
			billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, 1, 0)
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.Enabled = false

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.TextStrokeTransparency = 0
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 10
			textLabel.Parent = billboard
			billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

			table.insert(ESPObjects[objectName], billboard)

			function updateText()
				if hkSabot.Value ~= game:GetService("Players").LocalPlayer then
					textLabel.Text = "[ Hook ]"
					textLabel.TextColor3 = color
				else
					textLabel.Text = "[ Sabotaging - "  .. tostring(math.floor(hkProgress.Value / 10)) .. "% ]"
					textLabel.TextColor3 = Color3.new(1, 0.5, 1)
				end
			end

			updateText()
            hkSabot.Changed:Connect(updateText)

			continue
        elseif objectName == "Pallet" and obj.Name:match("Pallet%d") then
			local Panel = obj:FindFirstChild("Panel")
			local State = Panel:FindFirstChild("State")

			local billboard = Instance.new("BillboardGui")
			billboard.Name = obj.Name .. "_Label"
			billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, 1, 0)
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.Enabled = false

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.TextStrokeTransparency = 0
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 10
			textLabel.Parent = billboard
			billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

			table.insert(ESPObjects[objectName], billboard)

			function updateText()
				if State.Value == 2 then
                    textLabel.Text = ""
                    distanceLabel.Visible = false
					textLabel.TextColor3 = Color3.new(1, 1, 1)
				else
					textLabel.Text = "[ Pallet ]"
					textLabel.TextColor3 = color
				end
			end

			updateText()
			State.Changed:Connect(updateText)

			continue
        elseif obj.Name:match("Trap%d") and objectName == "Trap" then
            local panel = obj:FindFirstChild("Panel")
            local state = panel and panel:FindFirstChild("State")
			local hitbox = obj:FindFirstChild("Hitbox")
			pcall(hitbox:Destroy())

            if not state or not state:IsA("StringValue") then return end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = obj.Name .. "_Label"
            billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, -2, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.Enabled = true

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 10
            textLabel.Parent = billboard
            billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

            table.insert(ESPObjects[objectName], billboard)

            function updateText()
                if state.Value == "Armed" then
                    textLabel.Text = "[ Trapped ]"
                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                else
                    textLabel.Text = "[ Trap ]"
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                end
            end

            updateText()
            state:GetPropertyChangedSignal("Value"):Connect(updateText)

            continue
        elseif obj.Name:match("Trap") and objectName == "Trap" then
            local panel = obj:FindFirstChild("Panel")
            local hitbox = obj:FindFirstChild("Hitbox")
            hitbox:Destroy()
            local state = panel and panel:FindFirstChild("State")

            if not state or not state:IsA("StringValue") then return end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = obj.Name .. "_Label"
            billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, -2, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.Enabled = true

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 10
            textLabel.Parent = billboard
            billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

            table.insert(ESPObjects[objectName], billboard)

            function updateText()
                if state.Value == "Armed" then
                    textLabel.Text = "[ Trapped ]"
                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                else
                    textLabel.Text = "[ Trap ]"
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                end
            end

            updateText()
            state:GetPropertyChangedSignal("Value"):Connect(updateText)

            continue
        elseif objectName == "Totem" and obj.Name:match("Totem%d") then
			local Panel = obj:FindFirstChild("Panel")
			local Effect = Panel and Panel:FindFirstChild("Effect")
			if not Effect or not Effect:IsA("StringValue") then continue end

			local billboard = Instance.new("BillboardGui")
			billboard.Name = obj.Name .. "_Label"
			billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, -2, 0)
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.Enabled = false

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.TextStrokeTransparency = 0
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 10
			textLabel.Parent = billboard
			billboard.Parent = obj

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

			table.insert(ESPObjects[objectName], billboard)

			function updateText()
				if Effect.Value == "Dull" then
					textLabel.Text = "[ Totem ]"
					textLabel.TextColor3 = color
                elseif Effect.Value == "Blessing" then
                    textLabel.Text = "[ Blessing Totem ]"
					textLabel.TextColor3 = Color3.fromRGB(0, 169, 95)
				else
					textLabel.Text = "[ Cursed Totem ]"
					textLabel.TextColor3 = Color3.new(1, 1, 1)
				end
			end

			updateText()
			Effect:GetPropertyChangedSignal("Value"):Connect(updateText)

			continue
		end

		if not isMatch and obj.Name:match(objectName .. "%d") then
			isMatch = true
		end

		if isMatch then      
            local billboard = Instance.new("BillboardGui")
            billboard.Name = obj.Name .. "_Label"
            billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
            billboard.Size = UDim2.new(0, 200, 0, 60) 
            billboard.StudsOffset = Vector3.new(0, -1, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.Enabled = false

            local textLabel = Instance.new("TextLabel")
            textLabel.Text = "[ " .. labelText .. " ]"
            textLabel.Size = UDim2.new(1, 0, 0.5, 0)
            textLabel.Position = UDim2.new(0, 0, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = color
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 10
            textLabel.Parent = billboard

            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.new(1, 1, 1)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextSize = 10
            distanceLabel.Text = ""
            distanceLabel.Parent = billboard

            billboard.Parent = obj
            table.insert(ESPObjects[objectName], billboard)
        end
	end

	-- Heartbeat Distance Updater
    ESPObjects[objectName]._Connection = RunService.Heartbeat:Connect(function()
        for _, item in pairs(ESPObjects[objectName]) do
            if typeof(item) == "Instance" and item:IsA("BillboardGui") then
                local adornee = item.Adornee
                if adornee and adornee:IsA("Instance") then
                    local dist = getDistance(adornee)
                    local alwaysVisibleTypes = {
                        ["Hatch"] = true,
                        ["ExitGate"] = true,
                        ["Generator"] = true,
                        ["Totem"] = true,
                        ["Trap"] = true,
                    }
                    local isAlwaysVisible = alwaysVisibleTypes[objectName] == true

                    local fadeAlpha = 1
                    if not isAlwaysVisible then
                        fadeAlpha = math.clamp(1 - (dist / 150), 0, 1)
                    end

                    for _, child in pairs(item:GetChildren()) do
                        if child:IsA("TextLabel") then
                            child.TextTransparency = 1 - fadeAlpha
                            child.TextStrokeTransparency = 1 - fadeAlpha
                        end
                    end

                    local distanceLabel = item:FindFirstChild("DistanceLabel")
                    if distanceLabel then
                        if _G.Config.enable_ObjectsDistance then
                            distanceLabel.Text = string.format("[ %.1f m ]", dist)
                            
                            local t = math.clamp(1 - (dist / 50), 0, 1)
                            local white = Color3.new(1, 1, 1)
                            local green = Color3.new(0, 1, 0)
                            local color = white:Lerp(green, t)
                            distanceLabel.TextColor3 = color
                            
                        else
                            distanceLabel.Text = ""
                        end
                    end

                    item.Enabled = isAlwaysVisible or dist <= 150
                end
            end
        end
    end)

    game:GetService("Workspace").DescendantAdded:Connect(function(obj)
        if obj:IsA("Model") and obj.Name == "Trap" then
            task.delay(0.2, function()
                if obj:IsDescendantOf(workspace) then
                    local panel = obj:FindFirstChild("Panel")
                    local state = panel and panel:FindFirstChild("State")
					local hitbox = obj:FindFirstChild("Hitbox")
					hitbox:Destroy()

                    if not state or not state:IsA("StringValue") then return end

                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = obj.Name .. "_Label"
                    billboard.Adornee = obj:FindFirstChildWhichIsA("BasePart") or obj
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, -2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.LightInfluence = 0
                    billboard.Enabled = true

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextStrokeTransparency = 0
                    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.TextSize = 10
                    textLabel.Parent = billboard
                    billboard.Parent = obj

                    local distanceLabel = Instance.new("TextLabel")
                    distanceLabel.Name = "DistanceLabel"
                    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                    distanceLabel.BackgroundTransparency = 1
                    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
                    distanceLabel.TextStrokeTransparency = 0
                    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    distanceLabel.Font = Enum.Font.Gotham
                    distanceLabel.TextSize = 10
                    distanceLabel.Text = ""
                    distanceLabel.Parent = billboard

                    table.insert(ESPObjects[objectName], billboard)

                    function updateText()
                        if state.Value == "Armed" then
                            textLabel.Text = "[ Trapped ]"
                            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        else
                            textLabel.Text = "[ Trap ]"
                            textLabel.TextColor3 = Color3.new(1, 1, 1)
                        end
                    end

                    updateText()
                    state:GetPropertyChangedSignal("Value"):Connect(updateText)
                end
            end)
        end
    end)
end

function disableObjectESP(objectName)
	if not ESPObjects[objectName] then return end

	if ESPObjects[objectName]._Connection then
		ESPObjects[objectName]._Connection:Disconnect()
        ESPObjects[objectName]._Connection = nil
	end

	for _, obj in pairs(ESPObjects[objectName]) do
		if typeof(obj) == "Instance" and obj.Parent then
			obj:Destroy()
		end
	end

	ESPObjects[objectName] = nil
end
print('e => v1.0.5')
