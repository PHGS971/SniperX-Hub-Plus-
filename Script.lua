local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local originalSizes = {}
local hitboxExpanded = false
local currentExpansionSize = 10
local currentSpeed = 16
local currentJump = 50
local isFlying = false
local bodyVelocity = nil

local autoTpLoop = false
local espEnabled = false
local infiniteJumpEnabled = false
local noClipEnabled = false
local autoLookEnabled = false
local speedHackEnabled = false
local autoWalkEnabled = false
local autoClickEnabled = false

local autoTpConnection = nil
local espConnection = nil
local infiniteJumpConnection = nil
local noClipConnection = nil
local speedHackConnection = nil
local autoLookConnection = nil
local autoWalkConnection = nil
local autoClickConnection = nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "SnîperX Hub Plus! v1.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
scrollFrame.Parent = mainFrame

local textBoxLabel = Instance.new("TextLabel")
textBoxLabel.Size = UDim2.new(1, -20, 0, 25)
textBoxLabel.Position = UDim2.new(0, 10, 0, 20)
textBoxLabel.BackgroundTransparency = 1
textBoxLabel.Text = "Tamanho da Hitbox:"
textBoxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
textBoxLabel.TextScaled = true
textBoxLabel.Font = Enum.Font.Gotham
textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
textBoxLabel.Parent = scrollFrame

local textBox = Instance.new("TextBox")
textBox.Name = "HitboxSizeBox"
textBox.Size = UDim2.new(1, -20, 0, 35)
textBox.Position = UDim2.new(0, 10, 0, 50)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.BorderSizePixel = 0
textBox.Text = "10"
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextScaled = true
textBox.Font = Enum.Font.Gotham
textBox.PlaceholderText = "Digite o tamanho da hitbox..."
textBox.Parent = scrollFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 4)
textBoxCorner.Parent = textBox

local function createButton(name, text, position, color, parent)
local button = Instance.new("TextButton")
button.Name = name
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = position
button.BackgroundColor3 = color
button.BorderSizePixel = 0
button.Text = text
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamSemibold
button.Parent = parent

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = button

button.MouseEnter:Connect(function()
button.BackgroundColor3 = Color3.new(color.R + 0.1, color.G + 0.1, color.B + 0.1)
end)

button.MouseLeave:Connect(function()
button.BackgroundColor3 = color
end)

return button
end

local expandButton = createButton(
"ExpandHitbox",
"Expandir Hitbox",
UDim2.new(0, 10, 0, 100),
Color3.fromRGB(0, 150, 0),
scrollFrame
)

local resetButton = createButton(
"ResetHitbox",
"Resetar Hitbox",
UDim2.new(0, 10, 0, 150),
Color3.fromRGB(150, 0, 0),
scrollFrame
)

local visibleButton = createButton(
"MakeVisible",
"Tornar RootParts Visíveis",
UDim2.new(0, 10, 0, 200),
Color3.fromRGB(0, 100, 150),
scrollFrame
)

local invisibleButton = createButton(
"MakeInvisible",
"Tornar RootParts Invisíveis",
UDim2.new(0, 10, 0, 250),
Color3.fromRGB(100, 0, 150),
scrollFrame
)

local movementLabel = Instance.new("TextLabel")
movementLabel.Size = UDim2.new(1, -20, 0, 25)
movementLabel.Position = UDim2.new(0, 10, 0, 300)
movementLabel.BackgroundTransparency = 1
movementLabel.Text = "MOVIMENTO"
movementLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
movementLabel.TextScaled = true
movementLabel.Font = Enum.Font.GothamBold
movementLabel.Parent = scrollFrame

local speedPlusButton = createButton(
"SpeedPlus",
"Speed +1 (Atual: 16)",
UDim2.new(0, 10, 0, 330),
Color3.fromRGB(0, 120, 180),
scrollFrame
)

local speedMinusButton = createButton(
"SpeedMinus",
"Speed -1 (Atual: 16)",
UDim2.new(0, 10, 0, 380),
Color3.fromRGB(180, 120, 0),
scrollFrame
)

local jumpPlusButton = createButton(
"JumpPlus",
"Jump +5 (Atual: 50)",
UDim2.new(0, 10, 0, 430),
Color3.fromRGB(120, 180, 0),
scrollFrame
)

local jumpMinusButton = createButton(
"JumpMinus",
"Jump -5 (Atual: 50)",
UDim2.new(0, 10, 0, 480),
Color3.fromRGB(180, 0, 120),
scrollFrame
)

local tpNearestButton = createButton(
"TpNearest",
"TP Jogador Mais Próximo",
UDim2.new(0, 10, 0, 530),
Color3.fromRGB(150, 50, 150),
scrollFrame
)

local togglesLabel = Instance.new("TextLabel")
togglesLabel.Size = UDim2.new(1, -20, 0, 25)
togglesLabel.Position = UDim2.new(0, 10, 0, 580)
togglesLabel.BackgroundTransparency = 1
togglesLabel.Text = "TOGGLES"
togglesLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
togglesLabel.TextScaled = true
togglesLabel.Font = Enum.Font.GothamBold
togglesLabel.Parent = scrollFrame

local autoTpToggle = createButton(
"AutoTpToggle",
"Auto TP Loop: OFF",
UDim2.new(0, 10, 0, 610),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local espToggle = createButton(
"EspToggle",
"ESP Players: OFF",
UDim2.new(0, 10, 0, 660),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local infiniteJumpToggle = createButton(
"InfiniteJumpToggle",
"Infinite Jump: OFF",
UDim2.new(0, 10, 0, 710),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local noClipToggle = createButton(
"NoClipToggle",
"NoClip: OFF",
UDim2.new(0, 10, 0, 760),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local speedHackToggle = createButton(
"SpeedHackToggle",
"Speed Hack: OFF",
UDim2.new(0, 10, 0, 810),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local autoLookToggle = createButton(
"AutoLookToggle",
"Auto Look: OFF",
UDim2.new(0, 10, 0, 860),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local autoWalkToggle = createButton(
"AutoWalkToggle",
"Auto Walk: OFF",
UDim2.new(0, 10, 0, 910),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local autoClickToggle = createButton(
"AutoClickToggle",
"Auto Click: OFF",
UDim2.new(0, 10, 0, 960),
Color3.fromRGB(100, 100, 100),
scrollFrame
)

local function saveOriginalSizes()
originalSizes = {}
for _, otherPlayer in pairs(Players:GetPlayers()) do
if otherPlayer ~= player and otherPlayer.Character then
local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
originalSizes[otherPlayer.UserId] = hrp.Size
end
end
end
end

local function expandHitboxes(size)
currentExpansionSize = size

for _, otherPlayer in pairs(Players:GetPlayers()) do
if otherPlayer ~= player and otherPlayer.Character then
local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
if not originalSizes[otherPlayer.UserId] then
originalSizes[otherPlayer.UserId] = hrp.Size
end

hrp.Size = Vector3.new(size, size, size)
hrp.Transparency = 0.8
hrp.CanCollide = false

if hrp:FindFirstChildOfClass("SpecialMesh") then
hrp:FindFirstChildOfClass("SpecialMesh"):Destroy()
end
end
end
end

hitboxExpanded = true
expandButton.Text = "Hitbox Expandida (" .. size .. ")"
expandButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
end

local function resetHitboxes()
for _, otherPlayer in pairs(Players:GetPlayers()) do
if otherPlayer ~= player and otherPlayer.Character then
local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp and originalSizes[otherPlayer.UserId] then
hrp.Size = originalSizes[otherPlayer.UserId]
hrp.Transparency = 1
hrp.CanCollide = false
end
end
end

hitboxExpanded = false
expandButton.Text = "Expandir Hitbox"
expandButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
originalSizes = {}
end

local function setRootPartsVisibility(visible)
for _, otherPlayer in pairs(Players:GetPlayers()) do
if otherPlayer.Character then
local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
if visible then
hrp.Transparency = 0.5
hrp.BrickColor = BrickColor.new("Bright red")
else
if not hitboxExpanded then
hrp.Transparency = 1
end
hrp.Transparency = 1
hrp.BrickColor = BrickColor.new("Medium stone grey")
end
end
end
end
end

local function adjustSpeed(amount)
if player.Character and player.Character:FindFirstChild("Humanoid") then
currentSpeed = math.max(0, currentSpeed + amount)
player.Character.Humanoid.WalkSpeed = currentSpeed
speedPlusButton.Text = "Speed +1 (Atual: " .. currentSpeed .. ")"
speedMinusButton.Text = "Speed -1 (Atual: " .. currentSpeed .. ")"
end
end

local function adjustJump(amount)
if player.Character and player.Character:FindFirstChild("Humanoid") then
currentJump = math.max(0, currentJump + amount)
player.Character.Humanoid.JumpPower = currentJump
jumpPlusButton.Text = "Jump +5 (Atual: " .. currentJump .. ")"
jumpMinusButton.Text = "Jump -5 (Atual: " .. currentJump .. ")"
end
end

local function findNearestPlayer()
if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
return nil
end

local playerPos = player.Character.HumanoidRootPart.Position
local nearestPlayer = nil
local shortestDistance = math.huge

for _, otherPlayer in pairs(Players:GetPlayers()) do
if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
local distance = (otherPlayer.Character.HumanoidRootPart.Position - playerPos).Magnitude
if distance < shortestDistance then
shortestDistance = distance
nearestPlayer = otherPlayer
end
end
end

return nearestPlayer, shortestDistance
end

local function teleportToNearestPlayer()
local nearestPlayer, distance = findNearestPlayer()
if nearestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))

tpNearestButton.Text = "TP para " .. nearestPlayer.Name
wait(2)
tpNearestButton.Text = "TP Jogador Mais Próximo"
end
end

local function toggleAutoTp()
autoTpLoop = not autoTpLoop

if autoTpLoop then
autoTpToggle.Text = "Auto TP Loop: ON"
autoTpToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

autoTpConnection = RunService.Heartbeat:Connect(function()
if autoTpLoop then
local nearestPlayer = findNearestPlayer()
if nearestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
end
end
end)
else
autoTpToggle.Text = "Auto TP Loop: OFF"
autoTpToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
if autoTpConnection then
autoTpConnection:Disconnect()
end
end
end

local function toggleESP()
espEnabled = not espEnabled

if espEnabled then
espToggle.Text = "ESP Players: ON"
espToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

espConnection = RunService.Heartbeat:Connect(function()
for _, otherPlayer in pairs(Players:GetPlayers()) do
if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
local hrp = otherPlayer.Character.HumanoidRootPart

if not hrp:FindFirstChild("ESPHighlight") then
local highlight = Instance.new("Highlight")
highlight.Name = "ESPHighlight"
highlight.Adornee = hrp
highlight.FillColor = Color3.fromRGB(255, 0, 0)
highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 0.5
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent = hrp
end
end
end
end)
else
espToggle.Text = "ESP Players: OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
if espConnection then
espConnection:Disconnect()
end

for _, otherPlayer in pairs(Players:GetPlayers()) do
if otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
local highlight = otherPlayer.Character.HumanoidRootPart:FindFirstChild("ESPHighlight")
if highlight then
highlight:Destroy()
end
end
end
end
end

local function toggleInfiniteJump()
	infiniteJumpEnabled = not infiniteJumpEnabled

	if infiniteJumpEnabled then
		infiniteJumpToggle.Text = "Infinite Jump: ON"
		infiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

		infiniteJumpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end

			local isJumpInput = 
				input.KeyCode == Enum.KeyCode.Space or
				input.UserInputType == Enum.UserInputType.Touch

			if isJumpInput then
				local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end)
	else
		infiniteJumpToggle.Text = "Infinite Jump: OFF"
		infiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

		if infiniteJumpConnection then
			infiniteJumpConnection:Disconnect()
			--infiniteJumpConnection = nil
		end
	end
end

local function toggleNoClip()
noClipEnabled = not noClipEnabled

if noClipEnabled then
noClipToggle.Text = "NoClip: ON"
noClipToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

noClipConnection = RunService.Stepped:Connect(function()
if player.Character then
for _, part in pairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end)
else
noClipToggle.Text = "NoClip: OFF"
noClipToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
if noClipConnection then
noClipConnection:Disconnect()
end

if player.Character then
for _, part in pairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.CanCollide = true
end
end
end
end
end

local function toggleSpeedHack()
speedHackEnabled = not speedHackEnabled

if speedHackEnabled then
speedHackToggle.Text = "Speed Hack: ON"
speedHackToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

speedHackConnection = RunService.Heartbeat:Connect(function()
if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = 100
end
end)
else
speedHackToggle.Text = "Speed Hack: OFF"
speedHackToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
if speedHackConnection then
speedHackConnection:Disconnect()
end

if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = currentSpeed
end
end
end

local function toggleAutoLook()
	autoLookEnabled = not autoLookEnabled

	if autoLookEnabled then
		autoLookToggle.Text = "Auto Look: ON"
		autoLookToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

		autoLookConnection = RunService.Heartbeat:Connect(function()
			if autoLookEnabled then
				local nearestPlayer = findNearestPlayer()
				if nearestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local playerPos = player.Character.HumanoidRootPart.Position
					local targetPos = nearestPlayer.Character.HumanoidRootPart.Position

					-- ignora a altura do alvo
					targetPos = Vector3.new(targetPos.X, playerPos.Y, targetPos.Z)

					player.Character.HumanoidRootPart.CFrame = CFrame.new(playerPos, targetPos)
				end
			end
		end)
	else
		autoLookToggle.Text = "Auto Look: OFF"
		autoLookToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

		if autoLookConnection then
			autoLookConnection:Disconnect()
			autoLookConnection = nil
		end
	end
end

local path = nil
local autoWalkTask = nil

local function followPath(humanoid, waypoints)
	local currentWaypointIndex = 2

	while autoWalkEnabled and currentWaypointIndex <= #waypoints do
		local waypoint = waypoints[currentWaypointIndex]
		humanoid:MoveTo(waypoint.Position)

		local reached = humanoid.MoveToFinished:Wait()

		if not reached or not autoWalkEnabled then
			break
		end

		currentWaypointIndex += 1
	end
end

local function computeAndFollowPath()
	local character = player.Character
	local humanoid = character and character:FindFirstChild("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	local target = findNearestPlayer()

	if not humanoid or not hrp or not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local startPos = hrp.Position
	local endPos = target.Character.HumanoidRootPart.Position

	path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentCanClimb = true
	})

	path:ComputeAsync(startPos, endPos)

	if path.Status == Enum.PathStatus.Complete then
		local waypoints = path:GetWaypoints()
		followPath(humanoid, waypoints)
	end
end

local function toggleAutoWalk()
	autoWalkEnabled = not autoWalkEnabled

	if autoWalkEnabled then
		autoWalkToggle.Text = "Auto Walk: ON"
		autoWalkToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

		autoWalkTask = task.spawn(function()
			while autoWalkEnabled do
				computeAndFollowPath()
				task.wait(0.001)
			end
		end)
	else
		autoWalkToggle.Text = "Auto Walk: OFF"
		autoWalkToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

		if autoWalkTask then
			autoWalkTask = nil
		end

		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid:Move(Vector3.zero, false)
		end
	end
end

local function toggleAutoClick()
autoClickEnabled = not autoClickEnabled

if autoClickEnabled then
autoClickToggle.Text = "Auto Click: ON"
autoClickToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

autoClickConnection = RunService.Heartbeat:Connect(function()
if autoClickEnabled then
local VirtualUser = game:GetService("VirtualUser")
VirtualUser:CaptureController()
VirtualUser:ClickButton1(0, 0)

wait(0.001)
end
end)
else
autoClickToggle.Text = "Auto Click: OFF"
autoClickToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
if autoClickConnection then
autoClickConnection:Disconnect()
end
end
end

expandButton.MouseButton1Click:Connect(function()
local sizeText = textBox.Text
local size = tonumber(sizeText)

if size and size > 0 and size <= 1000 then
if not hitboxExpanded then
saveOriginalSizes()
expandHitboxes(size)
else
resetHitboxes()
end
else
textBox.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
wait(0.5)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end
end)

resetButton.MouseButton1Click:Connect(function()
resetHitboxes()
end)

visibleButton.MouseButton1Click:Connect(function()
setRootPartsVisibility(true)
end)

invisibleButton.MouseButton1Click:Connect(function()
setRootPartsVisibility(false)
end)

speedPlusButton.MouseButton1Click:Connect(function()
adjustSpeed(1)
end)

speedMinusButton.MouseButton1Click:Connect(function()
adjustSpeed(-1)
end)

jumpPlusButton.MouseButton1Click:Connect(function()
adjustJump(5)
end)

jumpMinusButton.MouseButton1Click:Connect(function()
adjustJump(-5)
end)

tpNearestButton.MouseButton1Click:Connect(function()
spawn(function()
teleportToNearestPlayer()
end)
end)

autoTpToggle.MouseButton1Click:Connect(function()
toggleAutoTp()
end)

espToggle.MouseButton1Click:Connect(function()
toggleESP()
end)

infiniteJumpToggle.MouseButton1Click:Connect(function()
toggleInfiniteJump()
end)

noClipToggle.MouseButton1Click:Connect(function()
toggleNoClip()
end)

speedHackToggle.MouseButton1Click:Connect(function()
toggleSpeedHack()
end)

autoLookToggle.MouseButton1Click:Connect(function()
toggleAutoLook()
end)

autoWalkToggle.MouseButton1Click:Connect(function()
toggleAutoWalk()
end)

autoClickToggle.MouseButton1Click:Connect(function()
toggleAutoClick()
end)

player.CharacterAdded:Connect(function(character)
wait(1)
if character:FindFirstChild("Humanoid") then
character.Humanoid.WalkSpeed = currentSpeed
character.Humanoid.JumpPower = currentJump
end
end)

Players.PlayerAdded:Connect(function(newPlayer)
newPlayer.CharacterAdded:Connect(function(character)
if hitboxExpanded then
wait(1)
local hrp = character:FindFirstChild("HumanoidRootPart")
if hrp and newPlayer ~= player then
originalSizes[newPlayer.UserId] = hrp.Size
hrp.Size = Vector3.new(currentExpansionSize, currentExpansionSize, currentExpansionSize)
hrp.Transparency = 0.8
hrp.CanCollide = false
end
end
end)
end)

local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
local delta = input.Position - dragStart
mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleLabel.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = mainFrame.Position

input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)

titleLabel.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
if dragging then
updateInput(input)
end
end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
screenGui.Enabled = not screenGui.Enabled
end
end)
