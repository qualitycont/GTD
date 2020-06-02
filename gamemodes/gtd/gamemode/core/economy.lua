GM.Economy = GM.Economy or {}
local economy = GM.Economy --fingers
util.AddNetworkString("gtd_levelup")

-- utility functions

local function _cfg(value)
    return GAMEMODE.Config[value] -- Timers hate this... again
end

local function _save(ply)
    local sid = ply:SteamID64()
    sql.Query("UPDATE GTD_Data SET Level="..ply:GetLevel().." WHERE SteamID='"..sid.."'")
    sql.Query("UPDATE GTD_Data SET XP="..ply:GetXP().." WHERE SteamID='"..sid.."'")
    sql.Query("UPDATE GTD_Data SET Credits="..ply:GetCredits().." WHERE SteamID='"..sid.."'")
end

local function _data(ply)
    return sql.Query("SELECT * FROM GTD_Data WHERE SteamID = "..ply:SteamID64())[1]
end

if not sql.TableExists("GTD_Data") then
    sql.Query("CREATE TABLE GTD_Data(SteamID INTEGER PRIMARY KEY, Level INTEGER, XP INTEGER, Credits INTEGER)")
end

local function _saveAll()
    for _, ply in pairs(player.GetAll()) do
        _save(ply)
    end
end

hook.Add("PlayerLoadout", "GTD_SyncEconomy", function(ply)
    local sid = ply:SteamID64()
    if not _data(ply) then
        sql.Query("INSERT INTO GTD_Data(SteamID, Level, XP, Credits) VALUES('"..sid.."', 1, 0, 0)")
    end
    local data = _data(ply)
    PrintTable(data)

    ply:SetLevel(data.Level)
    ply:SetXP(data.XP)
    ply:SetCredits(data.Credits)
    _saveAll()
end)

hook.Add("PlayerDisconnected", "GTD_PrioritySaveDisconnected", function(ply)
    _saveAll()
end)

function economy.GainXP(ply, amount)
    local needed = ply:GetNeededXP()
    local cur = ply:GetXP()
    if cur + amount >= needed then
        local newlevel = ply:GetLevel() + 1
        net.Start("gtd_levelup")
            net.WriteUInt(newlevel, 8)
        net.Send(ply)

        ply:SetLevel(newlevel)
        ply:SetXP(cur + amount - needed)
        return
    end

    ply:SetXP(cur + amount)
    _saveAll()
end

if !timer.Exists("GTD_PeriodicXP") then
    timer.Simple(20, function()
        local time = _cfg("TimeNeededForBonus")
        timer.Create("GTD_PeriodicXP", time, 0, function()
            for _, ply in pairs(player.GetAll()) do
                ply:GainXP(_cfg("TimeBonus"))
            end
        end)
    end)
end