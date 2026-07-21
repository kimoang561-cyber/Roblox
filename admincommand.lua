--[[
DARK AI GEN 5 - ROOBLOX ADMIN COMMAND (MOBILE SUPPORT + UI TOGGLE)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- ===== BYPASS SYSTEM =====
local function Bypass()
    local function bypassAccount()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "AccountAge") then
                v.AccountAge = 999999
                v.IsPremium = true
                v.MembershipType = Enum.MembershipType.Premium
            end
        end
    end
    
    local function bypassRemotes()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "Parent") and rawget(v, "Name") == "RemoteEvent" then
                if rawget(v, "OnServerEvent") then
                    rawget(v, "FireServer")(v, "BYPASSED")
                end
            end
        end
    end
    
    local function bypassPing()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "Network") then
                rawget(v, "Network").Ping = 0
            end
        end
    end
    
    bypassAccount()
    bypassRemotes()
    bypassPing()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end

-- ===== ANIMATIONS =====
local function CreateAnimation(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function GlowEffect(part)
    local glow = Instance.new("SelectionBox")
    glow.Adornee = part
    glow.Color3 = Color3.new(1, 0, 0)
    glow.LineThickness = 0.1
    glow.Transparency = 0.5
    glow.Parent = part
    
    local tween = CreateAnimation(glow, {Transparency = 0}, 0.5)
    tween:Play()
    tween:Wait()
    
    local tween2 = CreateAnimation(glow, {Transparency = 0.5}, 0.5)
    tween2:Play()
    tween2:Wait()
    glow:Destroy()
end

local function CreateExplosion(position, size)
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = size
    explosion.BlastPressure = 1000000
    explosion.ExplosionType = Enum.ExplosionType.NoCraters
    explosion.Fire = true
    explosion.Parent = workspace
    
    for i = 1, 50 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = position + Vector3.new(math.random(-10,10), math.random(-10,10), math.random(-10,10))
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.new("Bright red")
        part.Anchored = true
        part.CanCollide = false
        part.Parent = workspace
        local tween = CreateAnimation(part, {Size = Vector3.new(0,0,0)}, 1)
        tween:Play()
        game:GetService("Debris"):AddItem(part, 1)
    end
end

local function CreateTornado(position)
    for i = 1, 30 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 2, 2)
        part.Position = position + Vector3.new(math.sin(i) * 10, i * 2, math.cos(i) * 10)
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.new("Bright blue")
        part.Anchored = true
        part.CanCollide = false
        part.Parent = workspace
        local tween = CreateAnimation(part, {Position = position + Vector3.new(0, 50, 0)}, 2)
        tween:Play()
        game:GetService("Debris"):AddItem(part, 2)
    end
end

-- ===== COMMANDS =====
local function AllPlayersToMe(player)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPos = character.HumanoidRootPart.Position
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherChar = otherPlayer.Character
            if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                local root = otherChar.HumanoidRootPart
                local startPos = root.Position
                local endPos = rootPos + Vector3.new(0, 5, 0)
                for i = 1, 10 do
                    local tween = CreateAnimation(root, {Position = startPos:Lerp(endPos, i/10)}, 0.1)
                    tween:Play()
                    tween:Wait()
                end
                root.Position = endPos
                GlowEffect(root)
                otherPlayer:SendNotification("KAMU DITARIK!", "Lu kena command All Players To Me!", 3)
            end
        end
    end
    player:SendNotification("BERHASIL!", "Semua pemain ke lu!", 3)
end

local function ExplodePlayer(player, targetPlayer)
    if not targetPlayer then
        player:SendNotification("ERROR!", "Pilih pemain target!", 3)
        return
    end
    local targetChar = targetPlayer.Character
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        player:SendNotification("ERROR!", "Target gak ada!", 3)
        return
    end
    local root = targetChar.HumanoidRootPart
    CreateExplosion(root.Position, 30)
    for _, part in pairs(targetChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Bright red")
            local tween = CreateAnimation(part, {Size = part.Size * 2}, 0.5)
            tween:Play()
        end
    end
    targetPlayer:SendNotification("LEDAKAN!", "Lu kena Explode Player!", 3)
    player:SendNotification("BERHASIL!", "Player " .. targetPlayer.Name .. " meledak!", 3)
end

local function TornadoAllPlayers(player)
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local char = otherPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                CreateTornado(root.Position)
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                    local tween = CreateAnimation(root, {Position = root.Position + Vector3.new(0, 20, 0)}, 1)
                    tween:Play()
                    for i = 1, 10 do
                        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(36), 0)
                        wait(0.1)
                    end
                end
                otherPlayer:SendNotification("TORNADO!", "Lu kehantam tornado!", 3)
            end
        end
    end
    player:SendNotification("BERHASIL!", "Tornado semua pemain aktif!", 3)
end

local function RefreshPlayer(player, targetPlayer)
    if not targetPlayer then
        player:SendNotification("ERROR!", "Pilih pemain target!", 3)
        return
    end
    local char = targetPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 100
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        local tween = CreateAnimation(root, {Position = Vector3.new(0, 10, 0)}, 0.5)
        tween:Play()
    end
    targetPlayer:SendNotification("REFRESH!", "Karakter lu di-refresh!", 3)
    player:SendNotification("BERHASIL!", "Player " .. targetPlayer.Name .. " di-refresh!", 3)
end

-- ===== TOGGLE UI =====
local UIVisible = true

local function ToggleUI(player)
    local gui = player.PlayerGui:FindFirstChild("DarkAIPanel")
    if gui then
        UIVisible = not UIVisible
        gui.Enabled = UIVisible
        if UIVisible then
            player:SendNotification("UI DIBUKA!", "Panel admin aktif lagi!", 3)
        else
            player:SendNotification("UI DITUTUP!", "Panel admin disembunyiin!", 3)
        end
    end
end

-- ===== GUI =====
function CreateCommandGUI(player)
    local existing = player.PlayerGui:FindFirstChild("DarkAIPanel")
    if existing then existing:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DarkAIPanel"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.Enabled = true
    screenGui.ResetOnSpawn = false  -- Biar ga ilang pas respawn
    
    -- FRAME UTAMA (BESARIN Dikit biar mobile gampang di pencet)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 450, 0, 400)
    frame.Position = UDim2.new(0.5, -225, 0.5, -200)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local tween = CreateAnimation(frame, {BackgroundTransparency = 0.05}, 0.5)
    tween:Play()
    
    -- TITLE
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ DARK AI ADMIN ⚡"
    title.TextColor3 = Color3.new(1, 0, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- ===== BUTTON ALL PLAYERS TO ME =====
    local btn1 = Instance.new("TextButton")
    btn1.Size = UDim2.new(0.9, 0, 0, 50)
    btn1.Position = UDim2.new(0.05, 0, 0.15, 0)
    btn1.BackgroundColor3 = Color3.new(0.3, 0, 0)
    btn1.Text = "👥 ALL PLAYERS TO ME"
    btn1.TextColor3 = Color3.new(1, 1, 1)
    btn1.Font = Enum.Font.GothamBold
    btn1.TextScaled = true
    btn1.Parent = frame
    btn1.MouseButton1Click:Connect(function()
        AllPlayersToMe(player)
    end)
    -- MOBILE SUPPORT (Touch)
    btn1.TouchTap:Connect(function()
        AllPlayersToMe(player)
    end)
    
    -- ===== BUTTON EXPLODE PLAYER =====
    local btn2 = Instance.new("TextButton")
    btn2.Size = UDim2.new(0.9, 0, 0, 50)
    btn2.Position = UDim2.new(0.05, 0, 0.30, 0)
    btn2.BackgroundColor3 = Color3.new(0.3, 0, 0)
    btn2.Text = "💥 EXPLODE PLAYER"
    btn2.TextColor3 = Color3.new(1, 1, 1)
    btn2.Font = Enum.Font.GothamBold
    btn2.TextScaled = true
    btn2.Parent = frame
    btn2.MouseButton1Click:Connect(function()
        local targetName = player:SendInput("Masukkan nama target:")
        if targetName then
            local target = Players:FindFirstChild(targetName)
            if target then ExplodePlayer(player, target)
            else player:SendNotification("ERROR!", "Player gak ditemukan!", 3) end
        end
    end)
    btn2.TouchTap:Connect(function()
        local targetName = player:SendInput("Masukkan nama target:")
        if targetName then
            local target = Players:FindFirstChild(targetName)
            if target then ExplodePlayer(player, target)
            else player:SendNotification("ERROR!", "Player gak ditemukan!", 3) end
        end
    end)
    
    -- ===== BUTTON TORNADO ALL PLAYERS =====
    local btn3 = Instance.new("TextButton")
    btn3.Size = UDim2.new(0.9, 0, 0, 50)
    btn3.Position = UDim2.new(0.05, 0, 0.45, 0)
    btn3.BackgroundColor3 = Color3.new(0.3, 0, 0)
    btn3.Text = "🌪️ TORNADO ALL"
    btn3.TextColor3 = Color3.new(1, 1, 1)
    btn3.Font = Enum.Font.GothamBold
    btn3.TextScaled = true
    btn3.Parent = frame
    btn3.MouseButton1Click:Connect(function()
        TornadoAllPlayers(player)
    end)
    btn3.TouchTap:Connect(function()
        TornadoAllPlayers(player)
    end)
    
    -- ===== BUTTON REFRESH PLAYER =====
    local btn4 = Instance.new("TextButton")
    btn4.Size = UDim2.new(0.9, 0, 0, 50)
    btn4.Position = UDim2.new(0.05, 0, 0.60, 0)
    btn4.BackgroundColor3 = Color3.new(0.3, 0, 0)
    btn4.Text = "🔄 REFRESH PLAYER"
    btn4.TextColor3 = Color3.new(1, 1, 1)
    btn4.Font = Enum.Font.GothamBold
    btn4.TextScaled = true
    btn4.Parent = frame
    btn4.MouseButton1Click:Connect(function()
        local targetName = player:SendInput("Masukkan nama target:")
        if targetName then
            local target = Players:FindFirstChild(targetName)
            if target then RefreshPlayer(player, target)
            else player:SendNotification("ERROR!", "Player gak ditemukan!", 3) end
        end
    end)
    btn4.TouchTap:Connect(function()
        local targetName = player:SendInput("Masukkan nama target:")
        if targetName then
            local target = Players:FindFirstChild(targetName)
            if target then RefreshPlayer(player, target)
            else player:SendNotification("ERROR!", "Player gak ditemukan!", 3) end
        end
    end)
    
    -- ===== PANEL DRAG (MOBILE FRIENDLY) =====
    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- ===== TOGGLE BUTTON (DI DALAM PANEL) =====
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 40)
    toggleBtn.Position = UDim2.new(0.75, 0, 0, 0)
    toggleBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    toggleBtn.Text = "◻"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextScaled = true
    toggleBtn.Parent = frame
    toggleBtn.MouseButton1Click:Connect(function()
        ToggleUI(player)
    end)
    toggleBtn.TouchTap:Connect(function()
        ToggleUI(player)
    end)
    
    -- ===== CLOSE BUTTON (X) =====
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(0.88, 0, 0, 0)
    closeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextScaled = true
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function()
        ToggleUI(player)
    end)
    closeBtn.TouchTap:Connect(function()
        ToggleUI(player)
    end)
    
    -- ===== CHAT COMMANDS (TETAP ADA) =====
    player.Chatted:Connect(function(msg)
        if msg:lower() == "/ui" or msg:lower() == "/panel" then
            ToggleUI(player)
        elseif msg:lower() == "/help" then
            player:SendNotification("COMMANDS!", "/ui - Toggle panel | /reset - Reset efek", 5)
        elseif msg:lower() == "/reset" then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Part") and v.Material == Enum.Material.Neon then
                    v:Destroy()
                end
            end
            player:SendNotification("RESET!", "Semua efek dibersihin!", 3)
        end
    end)
end

-- ===== SETUP PLAYER =====
local function SetupPlayer(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        local oldGui = player.PlayerGui:FindFirstChild("DarkAIPanel")
        if oldGui then oldGui:Destroy() end
        CreateCommandGUI(player)
        player:SendNotification("⚡ DARK AI ACTIVE!", "Klik ◻ di panel buat toggle!", 5)
    end)
end

-- ===== AUTO EXECUTE =====
Bypass()

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        SetupPlayer(player)
    end)
    if player.Character then
        SetupPlayer(player)
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        SetupPlayer(player)
    end
end

print("⚡ DARK AI FULL LOADED! MOBILE SUPPORT + UI TOGGLE READY! 🔥")
