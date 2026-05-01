--[[
Dragon Style Mod
Made by harvey9340
--]]

--[[
    Dragon Style
    Made by harvey9340
    Version 1.0
--]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

print("Dragon Style by harvey9340 - Loading...")

-- Create GUI Menu
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Author = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

ScreenGui.Name = "DragonStyleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dragon Style"
Title.TextColor3 = Color3.fromRGB(255, 80, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

Author.Size = UDim2.new(1, 0, 0.3, 0)
Author.Position = UDim2.new(0, 0, 0.4, 0)
Author.BackgroundTransparency = 1
Author.Text = "Made by harvey9340"
Author.TextColor3 = Color3.fromRGB(255, 255, 255)
Author.TextScaled = true
Author.Font = Enum.Font.Gotham
Author.Parent = Frame

CloseButton.Size = UDim2.new(0.4, 0, 0.25, 0)
CloseButton.Position = UDim2.new(0.3, 0, 0.7, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextScaled = true
CloseButton.Parent = Frame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Dragon Style by harvey9340 - Loaded!")
