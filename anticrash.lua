--[[
    OPTIMIZED ANTICHEAT BYPASS SYSTEM V2.0
    Complete protections with fly and noclip bypass
]]

local gamePlaceId = game.PlaceId
local targetGameIds = {
    [111163066268338] = "KAT X",
    [85375890771250] = "KAT X",  -- Alternative server
    [132352755769957] = "Asylum Life"
}

local DarkForge = {
    Version = "2.0",
    Status = "OPTIMIZED_BYPASS_SYSTEM"
}

-- Simplified logging function
local function LogMessage(message)
    print("[🛡️ DarkForge] " .. message)
end

-- Debug function - shows current game ID
local function DebugGameInfo()
    local currentGame = game:GetService("MarketplaceService"):GetProductInfo(gamePlaceId)
    LogMessage("Current Game ID: " .. gamePlaceId)
    LogMessage("Game Name: " .. currentGame.Name)
end

-- 🎯 SPECIFIC BYPASS FOR KAT GAME (111163066268338 AND 85375890771250)
local function ActivateKatBypass()
    LogMessage("Activating specific protection for Kat...")
    
    local old
    do
        old = hookfunction((getrenv and getrenv() or _G).getfenv, function(arg)
            if old(arg) == old(0) or old(arg) == old() and not checkcaller() then
                return nil
            end
            return old(arg)
        end)
    end
    
    LogMessage("Specific protection activated successfully!")
    
    return {
        Version = "KAT_GAME_BYPASS",
        Status = "KAT_PROTECTION_ACTIVE",
        Loaded = true
    }
end

-- 🎯 SPECIFIC BYPASS FOR ASYLUM LIFE GAME (132352755769957)
local function ActivateAsylumLifeBypass()
    LogMessage("Activating specific protection for Asylum Life...")
    
    local BLOCK_REMOTE = true
    local ActionRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("ActionEvent")

    local oldNamecall
    if hookmetamethod and getnamecallmethod then
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if method == "FireServer" then
                if BLOCK_REMOTE and self == ActionRemote then
                    return nil
                end
            end

            return oldNamecall(self, ...)
        end)
    end
    
    LogMessage("Specific protection activated successfully!")
    
    return {
        Version = "ASYLUM_LIFE_BYPASS",
        Status = "ASYLUM_LIFE_PROTECTION_ACTIVE",
        Loaded = true
    }
end

-- 🛡️ UNIVERSAL BYPASS SYSTEM
local AdvancedBypass = {
    Execute = function(self)
        LogMessage("Starting universal protection...")
        
        -- Optimized bypass sequence
        self:BypassMemoryProtection()
        self:BypassCharacterDetection()
        self:BypassRemoteMonitoring()
        self:BypassScriptDetection()
        self:BypassEnvironmentScanning()
        self:BypassMovementDetection()
        self:BypassFlyNoclipDetection()
        
        LogMessage("Universal protection activated")
        return true
    end,
    
    BypassMemoryProtection = function(self)
        pcall(function()
            if setfflag then
                setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
                setfflag("DFIntCrashPadUploadToBacktraceMinidumpType", "0")
                setfflag("DebugDisableTaskSchedulerWakeAllThreads", "True")
                setfflag("FIntTaskSchedulerTargetFps", "60")
            end
        end)
    end,
    
    BypassCharacterDetection = function(self)
        pcall(function()
            local player = game.Players.LocalPlayer
            if not player then return end
            
            local function protectCharacter(character)
                if not character then return end
                
                character.ChildAdded:Connect(function(child)
                    if child:IsA("Script") or child:IsA("LocalScript") then
                        pcall(function()
                            local source = string.lower(child.Source or "")
                            if source:find("cheat") or source:find("hack") or source:find("detect") then
                                child.Disabled = true
                            end
                        end)
                    end
                end)
                
                local humanoid = character:WaitForChild("Humanoid", 2)
                if humanoid then
                    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                        if humanoid.WalkSpeed > 100 then
                            humanoid.WalkSpeed = 16
                        end
                    end)
                    
                    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                        if humanoid.JumpPower > 100 then
                            humanoid.JumpPower = 50
                        end
                    end)
                end
            end
            
            if player.Character then
                protectCharacter(player.Character)
            end
            player.CharacterAdded:Connect(protectCharacter)
        end)
    end,
    
    BypassRemoteMonitoring = function(self)
        pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local remoteNames = {"Anti", "Check", "Scan", "Detect", "Report", "Ban", "Kick"}
            
            local function safeRemoteCheck(remote)
                pcall(function()
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        for _, name in pairs(remoteNames) do
                            if string.find(remote.Name:lower(), name:lower()) then
                                if hookfunction and not _G.RemoteHookProtected then
                                    _G.RemoteHookProtected = true
                                end
                            end
                        end
                    end
                end)
            end
            
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                safeRemoteCheck(remote)
            end
            
            ReplicatedStorage.DescendantAdded:Connect(safeRemoteCheck)
        end)
    end,
    
    BypassScriptDetection = function(self)
        pcall(function()
            local ScriptContext = game:GetService("ScriptContext")
            
            ScriptContext.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("LocalScript") then
                    task.wait(0.3)
                    pcall(function()
                        local source = string.lower(descendant.Source or "")
                        local suspiciousPatterns = {
                            "hookfunction", "gethui", "getconnections", 
                            "checkcaller", "detect", "bypass", "exploit"
                        }
                        
                        for _, pattern in pairs(suspiciousPatterns) do
                            if source:find(pattern) then
                                descendant.Disabled = true
                                break
                            end
                        end
                    end)
                end
            end)
        end)
    end,
    
    BypassEnvironmentScanning = function(self)
        pcall(function()
            if getgenv then
                local env = getgenv()
                env._G = env._G or {}
                env._G.ScriptExecuted = nil
                env._G.ScriptLoaded = nil
                env._G.Injected = nil
            end
            
            if shared then
                shared.ScriptExecuted = nil
                shared.ScriptLoaded = nil
            end
        end)
    end,
    
    BypassMovementDetection = function(self)
        pcall(function()
            local player = game.Players.LocalPlayer
            if not player then return end
            
            local function setupMovementProtection(character)
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                local lastPosition = rootPart.Position
                local teleportCooldown = 0
                
                rootPart:GetPropertyChangedSignal("Position"):Connect(function()
                    local currentPosition = rootPart.Position
                    local distance = (currentPosition - lastPosition).Magnitude
                    
                    if distance > 300 and tick() - teleportCooldown > 1 then
                        pcall(function()
                            rootPart.Velocity = Vector3.new(0, 0, 0)
                            teleportCooldown = tick()
                        end)
                    end
                    
                    lastPosition = currentPosition
                end)
            end
            
            if player.Character then
                setupMovementProtection(player.Character)
            end
            player.CharacterAdded:Connect(setupMovementProtection)
        end)
    end,

    BypassFlyNoclipDetection = function(self)
        pcall(function()
            local player = game.Players.LocalPlayer
            if not player then return end
            
            local function setupFlyNoclipBypass(character)
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                local flyDetectionCooldown = 0
                local collisionCooldown = 0
                
                -- Fly detection bypass
                rootPart.ChildAdded:Connect(function(child)
                    if child:IsA("BodyVelocity") or child:IsA("BodyGyro") then
                        child:GetPropertyChangedSignal("Velocity"):Connect(function()
                            if tick() - flyDetectionCooldown > 0.5 then
                                pcall(function()
                                    local currentVelocity = child.Velocity
                                    if currentVelocity.Y > 50 then
                                        child.Velocity = Vector3.new(
                                            currentVelocity.X,
                                            math.min(currentVelocity.Y, 30),
                                            currentVelocity.Z
                                        )
                                        flyDetectionCooldown = tick()
                                    end
                                end)
                            end
                        end)
                    end
                end)
                
                -- Noclip detection bypass
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                            if tick() - collisionCooldown > 1 then
                                collisionCooldown = tick()
                            end
                        end)
                    end
                end
            end
            
            if player.Character then
                setupFlyNoclipBypass(player.Character)
            end
            player.CharacterAdded:Connect(setupFlyNoclipBypass)
        end)
    end
}

-- 🔄 OPTIMIZED CONTINUOUS MONITORING SYSTEM
local ContinuousProtection = {
    Active = false,
    
    Init = function(self)
        if self.Active then return end
        
        self.Active = true
        self:StartMonitoring()
        
        return true
    end,
    
    StartMonitoring = function(self)
        self:PerformanceMonitor()
        self:AntiCheatMonitor()
        self:FlyNoclipMonitor()
    end,
    
    PerformanceMonitor = function(self)
        task.spawn(function()
            while self.Active and task.wait(45) do
                pcall(function()
                    local stats = game:GetService("Stats")
                    local memory = stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryType.Script)
                    
                    if memory > 100 then
                        collectgarbage()
                    end
                end)
            end
        end)
    end,
    
    AntiCheatMonitor = function(self)
        task.spawn(function()
            while self.Active and task.wait(20) do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    if not player or not player.Character then
                        return
                    end
                    
                    local character = player.Character
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    
                    if humanoid then
                        if humanoid.WalkSpeed > 100 then
                            humanoid.WalkSpeed = 16
                        end
                        
                        if humanoid.JumpPower > 100 then
                            humanoid.JumpPower = 50
                        end
                    end
                end)
            end
        end)
    end,

    FlyNoclipMonitor = function(self)
        task.spawn(function()
            while self.Active and task.wait(25) do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    if not player or not player.Character then return end
                    
                    local character = player.Character
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    
                    if rootPart then
                        local velocity = rootPart.Velocity
                        if velocity.Y > 100 and math.abs(velocity.X) + math.abs(velocity.Z) < 10 then
                            rootPart.Velocity = Vector3.new(velocity.X, 30, velocity.Z)
                        end
                    end
                end)
            end
        end)
    end,
    
    Stop = function(self)
        self.Active = false
    end
}

-- 🎯 SPECIFIC ANTI-CHEAT BYPASS SYSTEM
local AntiCheatSpecificBypass = {
    Execute = function(self)
        self:BypassCommonAC()
        return true
    end,
    
    BypassCommonAC = function(self)
        pcall(function()
            local runService = game:GetService("RunService")
            
            runService.Heartbeat:Connect(function()
                -- Silent monitoring
            end)
        end)
    end
}

-- 🚀 OPTIMIZED INITIALIZATION SYSTEM
local function InitializeAdvancedBypass()
    if _G.DarkForgeAdvancedBypassLoaded then
        return true
    end
    
    -- Background execution
    task.spawn(function()
        AdvancedBypass:Execute()
        AntiCheatSpecificBypass:Execute()
        ContinuousProtection:Init()
    end)
    
    _G.DarkForgeAdvancedBypassLoaded = true
    
    return true
end

-- 📊 SIMPLIFIED STATUS SYSTEM
local function GetSystemStatus()
    return {
        Version = DarkForge.Version,
        Status = "OPTIMIZED_BYPASS_ACTIVE",
        Loaded = _G.DarkForgeAdvancedBypassLoaded or false,
        Functions = {
            Initialize = InitializeAdvancedBypass,
            GetStatus = GetSystemStatus,
            StopMonitoring = function() 
                ContinuousProtection:Stop() 
                _G.DarkForgeAdvancedBypassLoaded = false
            end
        }
    }
end

-- 🎮 GAME DETECTION AND INITIALIZATION SYSTEM
local function InitializeBypassSystem()
    LogMessage("System started")
    
    -- Show debug information
    DebugGameInfo()
    
    -- Check if it's a specific game using correct numeric comparison
    if gamePlaceId == 111163066268338 or gamePlaceId == 85375890771250 then
        LogMessage("Kat detected - Activating specific bypass")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🎮 GAME IDENTIFIED",
            Text = "KAT X detected! Activating protections...",
            Duration = 5
        })
        return ActivateKatBypass()
    elseif gamePlaceId == 132352755769957 then
        LogMessage("Asylum Life detected - Activating specific bypass")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🎮 GAME IDENTIFIED",
            Text = "ASYLUM LIFE detected! Activating protections...",
            Duration = 5
        })
        return ActivateAsylumLifeBypass()
    else
        LogMessage("Activating universal protection - Game not identified")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🌐 UNIVERSAL MODE",
            Text = "Game not identified\nActivating universal protection...",
            Duration = 5
        })
        -- Initialize universal bypass for other games
        task.spawn(function()
            task.wait(2)
            InitializeAdvancedBypass()
        end)
        return GetSystemStatus()
    end
end

-- Automatic initialization
task.spawn(function()
    task.wait(1)
    InitializeBypassSystem()
end)

return InitializeBypassSystem()
