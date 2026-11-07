--- LocalScript --
video : https://youtu.be/9Hp8AHkx6HQ



local player = game.Players.LocalPlayer
local promptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera
---------------------------------------------- change the names that suit ur studio
local gui = script.Parent
local frame = gui:WaitForChild("MainFrame")
local label = frame:WaitForChild("NPCNameLabel")
local btn1 = frame:WaitForChild("Option1")
local btn2 = frame:WaitForChild("Option2")
----------------------------------------------

local originalCameraCFrame
local currentPrompt -- Variable that 

-- Typing effect-
local function typeWrite(target, message)
	target.Text = ""
	for i = 1, utf8.len(message) do 
		target.Text = string.sub(message, 1, utf8.offset(message, i + 1) - 1)
		task.wait(0.03)
	end
end

-- start the dialogue
local function startDialogue(npc)
	-- camera anchor
	local head = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
	if not head then return end

	-- hide the prompt
	currentPrompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
	if currentPrompt then
		currentPrompt.Enabled = false
	end

	frame.Visible = true
	btn1.Visible = true
	btn2.Visible = true

	-- tweening
	camera.CameraType = Enum.CameraType.Scriptable
	local targetCFrame = CFrame.new(head.Position + (head.CFrame.LookVector * 7) + Vector3.new(1, 1, 1), head.Position)

	local cameraTween = TweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		CFrame = targetCFrame
	})
	cameraTween:Play()
---------change the options!-------
	typeWrite(label, "1")
	btn1.Text = "option1"
	btn2.Text = "option2"
end

-- finish the dialogue
local function closeDialogue(finalMsg)
	btn1.Visible = false
	btn2.Visible = false
	typeWrite(label, finalMsg)

	task.wait(1)

	--  camera 
	camera.CameraType = Enum.CameraType.Custom
	frame.Visible = false

	--  visible the dialogue 
	if currentPrompt then
		currentPrompt.Enabled = true
		currentPrompt = nil
	end
end

-- connect event
promptService.PromptTriggered:Connect(function(prompt, playerWhoTriggered)
	if playerWhoTriggered == player and prompt.Name == "ProximityPrompt" then
		local npcModel = prompt:FindFirstAncestor("NPC")
		if npcModel then
			startDialogue(npcModel)
		end
	end
end)
----------- change the NPC's answer!! -------
btn1.MouseButton1Click:Connect(function() 
	closeDialogue("answer that if u pick option 1") 
end)

btn2.MouseButton1Click:Connect(function() 
	closeDialogue("answer that if u pick option2") 
end)

-- ahh it for default state
frame.Visible = false
