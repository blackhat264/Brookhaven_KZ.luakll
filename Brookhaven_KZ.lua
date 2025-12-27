--==================================================
-- KZ TEAM | INTRO + HUB (SIN KEY)
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

--================= INTRO ==========================
local introGui = Instance.new("ScreenGui", game.CoreGui)

local introFrame = Instance.new("Frame", introGui)
introFrame.Size = UDim2.new(1,0,1,0)
introFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
introFrame.BackgroundTransparency = 1

local introText = Instance.new("TextLabel", introFrame)
introText.Size = UDim2.new(1,0,1,0)
introText.Text = "KZ TEAM"
introText.TextColor3 = Color3.fromRGB(0,255,140)
introText.BackgroundTransparency = 1
introText.Font = Enum.Font.GothamBlack
introText.TextSize = 60
introText.TextTransparency = 1

TweenService:Create(introFrame, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
task.wait(0.3)
TweenService:Create(introText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

task.wait(1)
for i = 1,6 do
	introText.Position = UDim2.new(0, math.random(-6,6), 0, math.random(-6,6))
	task.wait(0.05)
end
introText.Position = UDim2.new(0,0,0,0)

task.wait(0.8)
TweenService:Create(introText, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(introFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()

task.wait(0.7)
introGui:Destroy()

--================= HUB ============================
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,320)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "KZ TEAM HUB"
title.TextColor3 = Color3.fromRGB(0,255,140)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 16

local function createButton(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.85,0,0,32)
	b.Position = UDim2.new(0.075,0,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	Instance.new("UICorner", b)
	return b
end

-- SPEED
local speed = false
local speedBtn = createButton("Speed OFF", 45)
speedBtn.MouseButton1Click:Connect(function()
	speed = not speed
	humanoid.WalkSpeed = speed and 32 or 16
	speedBtn.Text = speed and "Speed ON" or "Speed OFF"
end)

-- NOCLIP
local noclip = false
local noclipBtn = createButton("Noclip OFF", 85)
RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "Noclip ON" or "Noclip OFF"
end)

-- FLY
local flying = false
local bodyGyro, bodyVelocity
local flyBtn = createButton("Fly OFF", 125)

local function startFly()
	bodyGyro = Instance.new("BodyGyro", hrp)
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)

	bodyVelocity = Instance.new("BodyVelocity", hrp)
	bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)

	RunService.RenderStepped:Connect(function()
		if flying then
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			local dir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
			bodyVelocity.Velocity = dir * 50
		end
	end)
end

local function stopFly()
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Fly ON" or "Fly OFF"
	if flying then startFly() else stopFly() end
end)

-- TELEPORT
createButton("TP Escuela", 175).MouseButton1Click:Connect(function()
	hrp.CFrame = CFrame.new(140,5,-180)
end)

createButton("TP Hospital", 215).MouseButton1Click:Connect(function()
	hrp.CFrame = CFrame.new(260,5,-60)
end)

-- RESET
local resetBtn = createButton("Reset Todo", 255)
resetBtn.BackgroundColor3 = Color3.fromRGB(90,30,30)
resetBtn.MouseButton1Click:Connect(function()
	humanoid.WalkSpeed = 16
	noclip = false
	flying = false
	stopFly()
	speedBtn.Text = "Speed OFF"
	noclipBtn.Text = "Noclip OFF"
	flyBtn.Text = "Fly OFF"
end)
