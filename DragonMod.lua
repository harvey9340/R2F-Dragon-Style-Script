--[[
Dragon Style Mod
Made by harvey9340
--]]

local DragonText = "Dragon"
local DragonColor = Color3.new(0.95, 0.05, 0.1)
local DragonSequence = ColorSequence.new({ColorSequenceKeypoint.new(0, DragonColor), ColorSequenceKeypoint.new(1, DragonColor)})

local plr = game.Players.LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main
local status = plr.Status

local hasUpdatedOnce = false

local function sendNotification(text, color)
    color = color or Color3.new(1, 1, 1)
    local notify = plr.PlayerGui:FindFirstChild("Notify")
    if notify and notify:IsA("BindableEvent") then
        notify:Fire(text)
    end
end

local alreadyRunning = game.ReplicatedStorage:FindFirstChild("DragonMod_harvey9340")
if alreadyRunning then
    sendNotification("Dragon Style Mod by harvey9340 is already loaded")
    return
end

alreadyRunning = Instance.new("BoolValue")
alreadyRunning.Parent = game.ReplicatedStorage
alreadyRunning.Value = true
alreadyRunning.Name = "DragonMod_harvey9340"

sendNotification("Dragon Style Mod by harvey9340 loading...")

-- ============================================================
-- STYLE UPDATER (runs every frame)
-- ============================================================

local function UpdateStyle()
    if status.Style.Value == "Brawler" then
        game.ReplicatedStorage.Styles.Brawler.VisualName.Value = DragonText
        game.ReplicatedStorage.Styles.Brawler.Color.Value = DragonColor
        main.XP.Fill.ImageColor3 = DragonColor

        local char = plr.Character
        if char then
            if char.HumanoidRootPart:FindFirstChild("Fire_Main") then
                char.HumanoidRootPart.Fire_Main.Color = DragonSequence
                char.HumanoidRootPart.Fire_Secondary.Color = DragonSequence
                char.HumanoidRootPart.Lines1.Color = DragonSequence
                char.HumanoidRootPart.Lines2.Color = DragonSequence
                char.HumanoidRootPart.Sparks.Color = DragonSequence
            end
            if char.UpperTorso:FindFirstChild("r2f_aura_burst") then
                char.UpperTorso["r2f_aura_burst"].Lines1.Color = DragonSequence
                char.UpperTorso["r2f_aura_burst"].Lines2.Color = DragonSequence
                char.UpperTorso["r2f_aura_burst"].Flare.Color = DragonSequence
                char.UpperTorso["r2f_aura_burst"].Smoke.Color = DragonSequence
                char.UpperTorso.Evading.Color = DragonSequence
            end
        end

        -- Heat bar colors
        if DragonText == "Dragon" then
            main.Heat.Fill.ImageColor3 = Color3.fromRGB(180, 0, 0)
            main.Heat.Fill2.ImageColor3 = Color3.fromRGB(255, 66, 142)
            main.Heat.ClimaxFill.ImageColor3 = Color3.fromRGB(180, 0, 0)
            main.Heat.ClimaxFill2.ImageColor3 = Color3.fromRGB(255, 39, 86)
        end
    end

    -- Menu watermark with YOUR name
    local menu = pgui.MenuUI.Menu
    menu.Bars.Mobile_Title.Text = "Dragon Style Mod by harvey9340"
    menu.Bars.Mobile_Title.Visible = true
end

-- ============================================================
-- ONE TIME SETUP
-- ============================================================

local function UpdateStyleOnce()
    if not hasUpdatedOnce then
        hasUpdatedOnce = true
        sendNotification("Dragon Style Mod by harvey9340 loaded!", Color3.fromRGB(255, 200, 50))
    end
    DragonSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, DragonColor),
        ColorSequenceKeypoint.new(1, DragonColor)
    })
    local menu = pgui.MenuUI.Menu
    menu.Bars.Mobile_Title.Text = "Dragon Style Mod by harvey9340"
    menu.Bars.Mobile_Title.Visible = true
end

-- ============================================================
-- LOW HEALTH FLASH
-- ============================================================

local LowHealthGui = Instance.new("ScreenGui")
LowHealthGui.Name = "LowHealthEffect"
LowHealthGui.ResetOnSpawn = false
LowHealthGui.Parent = pgui

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

status.Health.Changed:Connect(function()
    local maxHealth = status.Health.MaxValue or 100
    local percent = status.Health.Value / maxHealth
    if percent <= 0.3 then
        task.spawn(startFlash)
    else
        stopFlash()
    end
end)

-- ============================================================
-- DOUBLE TAUNT = DRAGON AURA
-- ============================================================

local tauntCount = 0
local tauntTimer = nil
local auraActive = false

local function activateDragonAura()
    if auraActive then return end
    auraActive = true

    local char = plr.Character
    if char then
        local highlight = Instance.new("SelectionBox")
        highlight.Color3 = Color3.fromRGB(255, 100, 0)
        highlight.LineThickness = 0.05
        highlight.SurfaceTransparency = 0.6
        highlight.SurfaceColor3 = Color3.fromRGB(255, 60, 0)
        highlight.Adornee = char
        highlight.Parent = char

        sendNotification("🔥 DRAGON AURA ACTIVATED", Color3.fromRGB(255, 100, 0))

        task.delay(5, function()
            highlight:Destroy()
            auraActive = false
        end)
    end
end

status.Taunting.Changed:Connect(function()
    if status.Taunting.Value == true then
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

-- ============================================================
-- DEATH MESSAGE
-- ============================================================

status.Health.Changed:Connect(function()
    if status.Health.Value <= 0 then
        task.wait()
        if not plr.Character:FindFirstChild("ImaDea") then return end
        local prompts = {
            "The Dragon falls... but never stays down.",
            "Get up. Dragons don't stay on the ground.",
            "That's the Dragon of Steel?",
            "You can do better than that.",
            "Rise again, Dragon.",
        }
        sendNotification(prompts[math.random(1, #prompts)], Color3.fromRGB(200, 0, 0))
    end
end)

-- ============================================================
-- STAT NOTIFICATIONS
-- ============================================================

status.Stats.Deaths.Changed:Connect(function()
    sendNotification("deaths total: [" .. status.Stats.Deaths.Value .. "]", Color3.fromRGB(200, 0, 0))
end)

status.Level.Changed:Connect(function()
    if status.Level.Value % 5 == 0 then
        sendNotification("you are now level [" .. status.Level.Value .. "]", Color3.fromRGB(0, 200, 0))
    end
end)

-- ============================================================
-- SWITCH STYLE (press L)
-- ============================================================

game.UserInputService.InputBegan:Connect(function(key)
    if game.UserInputService:GetFocusedTextBox() == nil then
        if key.KeyCode == Enum.KeyCode.L then
            if DragonText == "Dragon" then
                DragonText = "Legend"
                DragonColor = Color3.new(0.760784, 0.898039, 1)
                sendNotification("legend style", DragonColor)
            else
                DragonText = "Dragon"
                DragonColor = Color3.new(0.95, 0.05, 0.1)
                sendNotification("dragon style", DragonColor)
            end
            UpdateStyleOnce()
        end
    end
end)

-- ============================================================
-- RENDER LOOP
-- ============================================================

game:GetService("RunService").RenderStepped:Connect(function()
    UpdateStyle()
end)

coroutine.wrap(function()
    while true do
        UpdateStyleOnce()
        task.wait(5)
    end
end)()

sendNotification("Dragon Style Mod by harvey9340 loaded!", Color3.fromRGB(255, 200, 50))
task.wait(3)
sendNotification("press [L] to switch between Dragon and Legend styles", Color3.fromRGB(255, 255, 255))-- Komaki Tiger Drop animation
game.ReplicatedStorage.Moves.TigerDrop.Anim.AnimationId = "rbxassetid://12120052426"

-- Rename Counter Hook to Komaki Tiger Drop in the menu
local menu = pgui.MenuUI.Menu
local abil = menu.Abilities.Frame.Frame.Frame
for i,z in pairs(abil.List.ListFrame:GetChildren()) do
    if z:IsA("ImageButton") then
        if z.Name == "Counter Hook" then
            z.Generic.Label.Text = "Komaki Tiger Drop (Lvl. 25)"
        elseif z.Name == "Guru Parry" then
            z.Generic.Label.Text = "Komaki Parry (Lvl. 20)"
        elseif z.Name == "Guru Knockback" then
            z.Generic.Label.Text = "Komaki Knock Back"
        elseif z.Name == "Guru Spin Counter" then
            z.Generic.Label.Text = "Komaki Fist Reversal"
        elseif z.Name == "Guru Firearm Flip" then
            z.Generic.Label.Text = "Komaki Shot Stopper"
        elseif z.Name == "Guru Dodge Shot" then
            z.Generic.Label.Text = "Komaki Evade & Strike"
        end
    end
end-- Replace Brawler M1s with Legendary Dragon animations
local moves = game.ReplicatedStorage.Moves

-- Dragon style M1 combo animations
moves["BAttack1"].Anim.AnimationId = "rbxassetid://12120045620"
moves["BAttack2"].Anim.AnimationId = "rbxassetid://12120045620"
moves["BAttack3"].Anim.AnimationId = "rbxassetid://12120045620"
moves["BAttack4"].Anim.AnimationId = "rbxassetid://12120045620"

-- Tiger Drop animation changed to Legendary Dragon style
moves["TigerDrop"].Anim.AnimationId = "rbxassetid://12120052426"

-- Finishing blow animations
moves["BStrike1"].Anim.AnimationId = "rbxassetid://8216285224"
moves["BStrike5"].Anim.AnimationId = "rbxassetid://7546691847"
moves["BStomp"].Anim.AnimationId = "rbxasse
