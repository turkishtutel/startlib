local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local FatalityLib = {}

function FatalityLib:Anim(animName)
	local upperName = string.upper(tostring(animName or "FATALITY"))
	
	local firstLetter = string.sub(upperName, 1, 1)
	local remainingLetters = string.sub(upperName, 2)

	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then return end
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	local oldGui = PlayerGui:FindFirstChild("FatalityGui")
	if oldGui then oldGui:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "FatalityGui"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local Background = Instance.new("Frame")
	Background.Name = "Overlay"
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.BackgroundColor3 = Color3.new(0, 0, 0)
	Background.BackgroundTransparency = 0.5
	Background.Parent = ScreenGui

	local AnimationContainer = Instance.new("Frame")
	AnimationContainer.Name = "AnimationContainer"
	AnimationContainer.Size = UDim2.new(0.9, 0, 0, 150)
	AnimationContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	AnimationContainer.Position = UDim2.new(0.5, 0, 1.5, 0)
	AnimationContainer.BackgroundTransparency = 1
	AnimationContainer.Parent = Background

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 40)
	UIListLayout.Parent = AnimationContainer

	local fontAsset = Font.fromName("BuilderSans", Enum.FontWeight.Heavy)
	
	local firstLetterParams = Instance.new("GetTextBoundsParams")
	firstLetterParams.Text = firstLetter
	firstLetterParams.Font = fontAsset
	firstLetterParams.Size = 120
	firstLetterParams.Width = 1000
	
	local remainingParams = Instance.new("GetTextBoundsParams")
	remainingParams.Text = remainingLetters
	remainingParams.Font = fontAsset
	remainingParams.Size = 120
	remainingParams.Width = 2000

	local _, firstLetterBounds = pcall(function() return TextService:GetTextBoundsAsync(firstLetterParams) end)
	local _, remainingBounds = pcall(function() return TextService:GetTextBoundsAsync(remainingParams) end)

	local fWidth = firstLetterBounds and firstLetterBounds.X or 90
	local remainingWidth = remainingBounds and remainingBounds.X or 450

	local function applyStyling(label)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255) 
		label.FontFace = fontAsset
		label.TextScaled = true
		label.RichText = true
		label.TextXAlignment = Enum.TextXAlignment.Center
	end

	local FLabel = Instance.new("TextLabel")
	FLabel.Name = "FirstLetterLabel"
	FLabel.Size = UDim2.new(0, fWidth, 1, 0) 
	FLabel.Text = firstLetter
	FLabel.LayoutOrder = 1
	applyStyling(FLabel)
	FLabel.Parent = AnimationContainer

	local AtalityLabel = Instance.new("TextLabel")
	AtalityLabel.Name = "RemainingLettersLabel"
	AtalityLabel.Size = UDim2.new(0, 0, 1, 0) 
	AtalityLabel.Text = remainingLetters
	AtalityLabel.TextTransparency = 1 
	AtalityLabel.LayoutOrder = 2
	applyStyling(AtalityLabel)
	AtalityLabel.Parent = AnimationContainer

	local introInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local moveUp = TweenService:Create(AnimationContainer, introInfo, {
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	moveUp:Play()
	moveUp.Completed:Wait()

	task.wait(0.6)

	local splitInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local tweenF = TweenService:Create(FLabel, splitInfo, {Size = UDim2.new(0, fWidth, 1, 0)})
	local tweenAtality = TweenService:Create(AtalityLabel, splitInfo, {
		Size = UDim2.new(0, remainingWidth, 1, 0), 
		TextTransparency = 0
	})

	tweenF:Play()
	tweenAtality:Play()

	task.wait(2.5)

	local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local fadeF = TweenService:Create(FLabel, fadeInfo, {TextTransparency = 1})
	local fadeAtality = TweenService:Create(AtalityLabel, fadeInfo, {TextTransparency = 1})
	local fadeBg = TweenService:Create(Background, fadeInfo, {BackgroundTransparency = 1})

	fadeF:Play()
	fadeAtality:Play()
	fadeBg:Play()

	fadeF.Completed:Connect(function()
		ScreenGui:Destroy()
	end)
end

return FatalityLib
