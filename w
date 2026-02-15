--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

--// Function to get the Value label
local function GetValueLabel()
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
	if PlayerGui then
		local HUD = PlayerGui:FindFirstChild("HUD")
		if HUD then
			local BottomLeft = HUD:FindFirstChild("BottomLeft")
			if BottomLeft then
				local TradeTokens = BottomLeft:FindFirstChild("TradeTokens")
				if TradeTokens then
					return TradeTokens:FindFirstChild("Value")
				end
			end
		end
	end
	return nil
end

--// SETTINGS
local MAX_NUMBER = 999999 -- maximum allowed number

--// Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 180)
Frame.Position = UDim2.new(0.5, -175, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

-- Gradient for cool theme
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,105,180)), -- pink
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(147,112,219)), -- purple
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,206,209)) -- cyan
})
UIGradient.Rotation = 45
UIGradient.Parent = Frame

--// Title text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Token Generator 🤑"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = Frame

-- TextBox for number input
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0.25, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.25, 0)
TextBox.PlaceholderText = "Enter Amount..."
TextBox.Text = ""
TextBox.TextScaled = true
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
TextBox.BorderSizePixel = 0
TextBox.Parent = Frame

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 10)
TextBoxCorner.Parent = TextBox

-- Button to apply the number
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.5, 0, 0.2, 0)
Button.Position = UDim2.new(0.25, 0, 0.55, 0)
Button.BackgroundColor3 = Color3.fromRGB(75,0,130)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.TextScaled = true
Button.Text = "Generate"
Button.Font = Enum.Font.GothamBold
Button.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = Button

-- Hover effect
Button.MouseEnter:Connect(function()
	Button.BackgroundColor3 = Color3.fromRGB(120,0,200)
end)
Button.MouseLeave:Connect(function()
	Button.BackgroundColor3 = Color3.fromRGB(75,0,130)
end)

-- Credit text below button
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0.15, 0)
Credit.Position = UDim2.new(0, 0, 0.8, 0)
Credit.Text = "Made by Viral Hub Scripts"
Credit.TextColor3 = Color3.fromRGB(200,200,200)
Credit.TextScaled = true
Credit.Font = Enum.Font.Gotham
Credit.BackgroundTransparency = 1
Credit.Parent = Frame

--// Function to apply number (adds instead of replacing)
local function ApplyNumber()
	local number = tonumber(TextBox.Text)
	if number then
		if number < 0 then
			number = 0
		end

		local valueLabel = GetValueLabel()
		if valueLabel then
			-- Get current value (convert text to number safely)
			local currentValue = tonumber(valueLabel.Text) or 0

			-- Add new number
			local newValue = currentValue + number

			-- Cap at MAX_NUMBER
			if newValue > MAX_NUMBER then
				newValue = MAX_NUMBER
			end

			-- Update label
			valueLabel.Text = tostring(newValue)
		end

		TextBox.Text = "" -- clear input
	else
		TextBox.Text = "" -- clear invalid input
	end
end

-- Connect button click
Button.MouseButton1Click:Connect(ApplyNumber)

--// Make the UI draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
