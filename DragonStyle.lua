--[[
Dragon Style Mod
Made by harvey9340
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ============================================================
-- WATERMARK
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonStyleMod"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 40)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "🐉 Dragon Style Mod made by harvey9340"
Label.TextColor3 = Color3.fromRGB(255, 200, 50)
Label.TextScaled = true
Label.Font = Enum.Font.GothamBold
Label.Parent = Frame

-- ============================================================
-- LOW HEALTH FLASH EFFECT
-- ============================================================

local LowHealthGui = Instance.new("ScreenGui")
LowHealthGui.Name = "LowHealthEffect"
LowHealthGui.ResetOnSpawn = false
LowHealthGui.Parent = PlayerGui

local RedFlash = Instance.new("Frame")
RedFlash.Size = UDim2.new(1, 0, 1, 0)
RedFlash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RedFlash.BackgroundTransparency = 1
RedFlash.BorderSizePixel = 0
RedFlash.Parent = LowHealthGui

local flashing = false

local function startFlash()
    if flashing then return end
    flashing = true
    while flashing do
        for i = 0, 1, 0.05 do
            if not flashing then break end
            RedFlash.BackgroundTransparency = 1 - (i * 0.6)
            task.wait(0.03)
        end
        for i = 0, 1, 0.05 do
            if not flashing then break end
            RedFlash.BackgroundTransparency = 0.4 + (i * 0.6)
            task.wait(0.03)
        end
    end
    RedFlash.BackgroundTransparency = 1
end

local function stopFlash()
    flashing = false
end

Humanoid.HealthChanged:Connect(function(health)
    local maxHealth = Humanoid.MaxHealth
    local percent = health / maxHealth
    if percent <= 0.3 then
        startFlash()
    else
        stopFlash()
    end
end)

-- ============================================================
-- DOUBLE TAUNT = DRAGON AURA EFFECT
-- ============================================================

local tauntCount = 0
local tauntTimer = nil
local auraActive = false

local function activateDragonAura()
    if auraActive then return end
    auraActive = true

    -- Orange glow around character
    local highlight = Instance.new("SelectionBox")
    highlight.Color3 = Color3.fromRGB(255, 100, 0)
    highlight.LineThickness = 0.05
    highlight.SurfaceTransparency = 0.6
    highlight.SurfaceColor3 = Color3.fromRGB(255, 60, 0)
    highlight.Adornee = Character
    highlight.Parent = Character

    -- Notification
    local AuraGui = Instance.new("ScreenGui")
    AuraGui.ResetOnSpawn = false
    AuraGui.Parent = PlayerGui

    local AuraLabel = Instance.new("TextLabel")
    AuraLabel.Size = UDim2.new(0, 300, 0, 50)
    AuraLabel.Position = UDim2.new(0.5, -150, 0.5, -25)
    AuraLabel.BackgroundTransparency = 1
    AuraLabel.Text = "🔥 DRAGON AURA ACTIVATED"
    AuraLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
    AuraLabel.TextScaled = true
    AuraLabel.Font = Enum.Font.GothamBold
    AuraLabel.Parent = AuraGui

    -- Fade out label after 2 seconds
    task.delay(2, function()
        for i = 0, 1, 0.05 do
            AuraLabel.TextTransparency = i
            task.wait(0.05)
        end
        AuraGui:Destroy()
    end)

    -- Remove aura after 5 seconds
    task.delay(5, function()
        highlight:Destroy()
        auraActive = false
    end)
end

-- Listen for taunt via status
local status = LocalPlayer:FindFirstChild("Status")
if status then
    local taunting = status:FindFirstChild("Taunting")
    if taunting then
        taunting.Changed:Connect(function()
            if taunting.Value == true then
                tauntCount = tauntCount + 1
                if tauntTimer then
                    task.cancel(tauntTimer)
                end
                if tauntCount >= 2 then
                    tauntCount = 0
                    activateDragonAura()
                else
                    tauntTimer = task.delay(3, function()
                        tauntCount = 0
                    end)
                end
            end
        end)
    end
end

-- ============================================================
-- RESPAWN HANDLER
-- ============================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    flashing = false

    Humanoid.HealthChanged:Connect(function(health)
        local percent = health / Humanoid.MaxHealth
        if percent <= 0.3 then
            startFlash()
        else
            stopFlash()
        end
    end)
end)

print("Dragon Style Mod loaded - made by harvey9340")
