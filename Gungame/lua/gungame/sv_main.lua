util.AddNetworkString("Menu")
util.AddNetworkString("Shop")
util.AddNetworkString("ClickButton1")
util.AddNetworkString("ClickButton2")
util.AddNetworkString("ClickButton3")
util.AddNetworkString("BuyButton1")
util.AddNetworkString("BuyButton2")
util.AddNetworkString("BuyButton3")
util.AddNetworkString("SelectButton1")
util.AddNetworkString("SelectButton2")
util.AddNetworkString("SelectButton3")
util.AddNetworkString("MapVotingSystem")

hook.Add("PlayerInitialSpawn", "FirstConnect", function(ply)
    util.PrecacheModel("models/captainbigbutt/vocaloid/miku_classic.mdl")
    util.PrecacheModel("models/freeman/player/left_shark.mdl")
    util.PrecacheModel("models/player/daedric.mdl")

    if (file.Exists("gungame/PlayerData_" .. ply:SteamID64() .. ".txt", "DATA")) then
        local data = file.Read("gungame/PlayerData_" .. ply:SteamID64() .. ".txt", "DATA")
        local playerData = util.JSONToTable(data)
        ply:SetNWInt("TotalFrags", playerData.TotalFrags)
        ply:SetNWInt("Points", playerData.Points)

        if (playerData.LastModel) then
            ply:SetModel(playerData.LastModel)
        end
    else
        local playerData = {
            TotalFrags = 0,
            Points = 0,
            models = {}
        }

        local data = util.TableToJSON(playerData)
        file.Write("gungame/PlayerData_" .. ply:SteamID64() .. ".txt", data)
        ply:SetNWInt("TotalFrags", 0)
        ply:SetNWInt("Points", 0)
    end

    ply.BoughtModels = ply.BoughtModels or {}
end)

hook.Add("Initialize", "CreateFolder", function()
    if (not file.Exists("gungame", "DATA")) then
        file.CreateDir("gungame")
    end

    timer.Create("SavePlayerData", 60, 0, function()
        for k, v in ipairs(player.GetAll()) do
            local playerData = {
                TotalFrags = v:GetNWInt("TotalFrags"),
                Points = v:GetNWInt("Points"),
                BoughtModels = v.BoughtModels,
                LastModel = v:GetModel(),
            }

            local data = util.TableToJSON(playerData)
            file.Write("gungame/PlayerData_" .. v:SteamID64() .. ".txt", data)
        end
    end)
end)

hook.Add("PlayerDisconnected", "SavePlayerDataDisconnect", function(ply)
    local playerData = {
        TotalFrags = ply:GetNWInt("TotalFrags"),
        Points = ply:GetNWInt("Points"),
        BoughtModels = ply.BoughtModels,
    }

    local data = util.TableToJSON(playerData)
    file.Write("gungame/PlayerData_" .. ply:SteamID64() .. ".txt", data)
end)

hook.Add("PlayerSay", "menu", function(ply, text)
    if (string.lower(text) == "!menu") then
        net.Start("Menu")
        net.Send(ply)
    end

    if (string.lower(text) == "!resetpoints") then
        ply:SetNWInt("Points", 0)
    end

    if (string.lower(text) == "!resetfrags") then
        ply:SetNWInt("TotalFrags", 0)
    end

    if (string.lower(text) == "!shop") then
        net.Start("Shop")
        net.Send(ply)
        PrintTable(ply.BoughtModels)
    end

    if (string.lower(text) == "!map") then
        net.Start("MapVotingSystem")
        net.Send(ply)
    end
end)

hook.Add("Think", "CheckRoundStart", function()
    if not gungame.Round.IsRunning and #player.GetAll() >= gungame.MinPlayerCount then
        gungame.Round.IsRunning = true
        RoundCounter = 0

        for _, ply in ipairs(gungame.Round.Players) do
            ply:SetFrags(0)
        end

        timer.Simple(5, function()
            gungame.Round.Players = player.GetAll()
            print("ROUND STARTED!")
            print("CURRENT PLAYERS:")
            RoundCounter = RoundCounter + 1

            for _, ply in ipairs(gungame.Round.Players) do
                print(ply:Nick())
                ply:UnSpectate()
                ply:Spawn()
            end
        end)
    end
end)

hook.Add("PlayerLoadout", "RemoveWeapons", function(ply)
    local IsInRound = false

    for k, rply in ipairs(gungame.Round.Players) do
        if (rply == ply) then
            IsInRound = true
            break
        end
    end

    if gungame.Round.IsRunning and IsInRound then
        ply:Give("weapon_shotgun")

        return true
    end
end)

hook.Add("PlayerSpawn", "CheckSpectate", function(ply)
    local IsInRound = false

    for k, rply in ipairs(gungame.Round.Players) do
        if (rply == ply) then
            IsInRound = true
            break
        end
    end

    if gungame.Round.IsRunning and not IsInRound or not gungame.Round.IsRunning then
        timer.Simple(0.00000001, function()
            ply:Spectate(OBS_MODE_ROAMING)
            ply:SpectateEntity(nil)
            ply:StripWeapons()
        end)
    end
end)

hook.Add("PlayerDeathThink", "CheckSpectate", function(ply)
    local IsInRound = false

    for k, rply in ipairs(gungame.Round.Players) do
        if (rply == ply) then
            IsInRound = true
            break
        end
    end

    if gungame.Round.IsRunning and not IsInRound or not gungame.Round.IsRunning then return false end
end)

hook.Add("PlayerDeath", "GetNextWeapon", function(victim, inflictor, attacker)
    local IsInRound = false

    for k, rply in ipairs(gungame.Round.Players) do
        if (rply == attacker) then
            IsInRound = true
            break
        end
    end

    if (attacker:Frags() % 2 == 0) then
        attacker:StripWeapons()
        attacker:Give(Weapontable[attacker:Frags() / 2])
    end

    if (attacker:Frags() == 17) then
        for _, ply in ipairs(gungame.Round.Players) do
            ply:StripWeapons()
            ply:PrintMessage(HUD_PRINTCENTER, attacker:Nick() .. " HAT DIE RUNDE GEWONNEN")
        end

        timer.Simple(60, function()
            gungame.Round.IsRunning = false
        end)
    end

    attacker:SetNWInt("TotalFrags", attacker:GetNWInt("TotalFrags") + 1)
    attacker:SetNWInt("Points", attacker:GetNWInt("Points") + 10)
end)

net.Receive("ClickButton1", function(len, ply)
    ply:Kill()
end)

net.Receive("ClickButton2", function(len, ply)
    ply:KillSilent()
end)

net.Receive("ClickButton3", function(len, ply)
    timer.Simple(0.00000001, function()
        ply:Spectate(OBS_MODE_ROAMING)
        ply:SpectateEntity(nil)
        ply:StripWeapons()
    end)

    timer.Simple(5, function()
        gungame.Round.IsRunning = false
    end)
end)

net.Receive("BuyButton1", function(len, ply)
    if (ply:GetNWInt("Points") >= 20) then
        ply:SetNWInt("Points", ply:GetNWInt("Points") - 20)
        table.insert(ply.BoughtModels, "models/captainbigbutt/vocaloid/miku_classic.mdl")
    else
        ply:PrintMessage(HUD_PRINTTALK, " System | DU HAST ZU WENIG PUNKTE, STRENG DICH MAL MEHR AN!")
    end

    ply:SetModel("models/captainbigbutt/vocaloid/miku_classic.mdl")
end)

net.Receive("BuyButton2", function(len, ply)
    if (ply:GetNWInt("Points") >= 60) then
        ply:SetNWInt("Points", ply:GetNWInt("Points") - 60)
        table.insert(ply.BoughtModels, "models/freeman/player/left_shark.mdl")
    else
        ply:PrintMessage(HUD_PRINTTALK, " System | DU HAST ZU WENIG PUNKTE, STRENG DICH MAL MEHR AN!")
    end

    ply:SetModel("models/freeman/player/left_shark.mdl")
end)

net.Receive("BuyButton3", function(len, ply)
    if (ply:GetNWInt("Points") >= 120) then
        ply:SetNWInt("Points", ply:GetNWInt("Points") - 120)
        table.insert(ply.BoughtModels, "models/player/daedric.mdl")
    else
        ply:PrintMessage(HUD_PRINTTALK, " System | DU HAST ZU WENIG PUNKTE, STRENG DICH MAL MEHR AN!")
    end

    ply:SetModel("models/player/daedric.mdl")
end)

net.Receive("SelectButton1", function(len, ply)
    if (table.HasValue(ply.BoughtModels, "models/captainbigbutt/vocaloid/miku_classic.mdl")) then
        ply:SetModel("models/captainbigbutt/vocaloid/miku_classic.mdl")
    end
end)

net.Receive("SelectButton2", function(len, ply)
    if (table.HasValue(ply.BoughtModels, "models/freeman/player/left_shark.mdl")) then
        ply:SetModel("models/freeman/player/left_shark.mdl")
    end
end)

net.Receive("SelectButton3", function(len, ply)
    if (table.HasValue(ply.BoughtModels, "models/player/daedric.mdl")) then
        ply:SetModel("models/player/daedric.mdl")
    end
end)