GM.Economy = GM.Economy or {}
local economy = GM.Economy --fingers

-- utility functions

local function _readJSONFile(path)
    local content = file.Read(path)
    return util.JSONToTable(content)
end

local function _writeTableFile(input, path)
    local write = util.TableToJSON(input)
    file.Write(path, input)
end

local function _cfg(value)
    return GM.Config[value]
end

local function _saveEconomyData()
    _writeTableFile(economyData, "gtd/economy.txt")
end

local economyData = economyData or {}
if economyData == {} then
    economyData = _readJSONFile("gtd/economy.txt")
end

hook.Add("PlayerSpawn", "GTD_SyncEconomy", function(ply)
    if !ply:HasFirstSpawned() then
        local sid = ply:SteamID64()

        if not economyData[sid] then
            economyData[sid] = {
                Level = 1,
                XP = 0,
                Credits = 0
            }
        end
        _saveEconomyData()

        local data = economyData[sid]

        ply:SetLevel(data.Level)
        ply:SetXP(data.XP)
        ply:SetCredits(data.Credits)
    end
end)

function economy.GainXP(ply, amount)
    local needed = ply:GetNeededXP()
    local cur = ply:GetXP()
    if cur + amount >= needed then
        ply:SetLevel(ply:GetLevel() + 1)
        ply:SetXP(cur + amount - needed)
        return
    end

    ply:SetXP(cur + amount)
end

if !timer.Exists("GTD_PeriodicXP") then
    timer.Create("GTD_PeriodicXP", 300, 0, function()
        for _, ply in pairs(player.GetAll()) do
            ply:GainXP(_cfg("TimeBonus"))
        end
    end)
end