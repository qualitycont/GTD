-- VARIABLES

GM.RoundManager = GM.RoundManger or {}
local manager = GM.RoundManager

manager.States = {
    PREPARE = 0,
    ROUND = 1
}

manager.Difficulty = { -- while this is an Enum, these are also used for multiplication so if you need to change your token calculation use this
    EASY = 0.5,
    NORMAL = 1,
    HARD = 2,
    INSANE = 3
}

-- local stuff

local tokens = tokens or GM.Config.StartTokens * manager.Difficulty[GM.Config.Difficulty] -- used up for monster spawns
local wave = wave or 1
local waveEnemies = waveEnemies or {}
local waveEnemyCount = waveEnemyCount or 0
local state = manager.States.PREPARE

local function _calculateTokens()
    local newtokens = GM.Config.StartTokens * manager.Difficulty[GM.Config.Difficulty]
    return newtokens * wave * math.Clamp(GM.Util.Deviation(), 1, 2)
end

local function _spawnEnemies(amount)
    for k, v in ipairs(waveEnemies) do
        if amount <= 0 then return true end
        if table.IsEmpty(waveEnemies) then return false end

        GM.EnemyManager.Spawn(v.key)
        table.remove(k)

        amount = amount - 1
    end
end

local function _startNextRound()
    state = manager.States.ROUND

    local nextfire = 5 + GM.Util.Deviation(10)
    local moreToSpawn = true
    while moreToSpawn do
        nextfire = 5 + GM.Util.Deviation(10)
        timer.Create("GTD_EnemySpawnTimer", nextfire, 1, function()
            if not _spawnEnemies(math.random(2,2+math.random(8))) then moreToSpawn = false end
        end)
    end
end

function manager:GenerateNextWave()
    local enemies = GM.EnemyManager.GetAll()

    while tokens > 0 do
        local enemy, key = table.Random(enemies)
        if tokens >= enemy.Tokens then
            enemy.key = key
            table.insert(waveEnemies, enemy)
            tokens = tokens - enemy.Tokens
        end
    end
end

function manager:GetState()
    return state
end

function manager:GetWaveProgress()
    local percentleft = table.Count(waveEnemies) / waveEnemyCount
    return waveEnemyCount, percentleft
end

function manager:EndRound(win)
    if timer.Exists("GTD_EnemySpawnTimer") then timer.Destroy("GTD_EnemySpawnTimer") end

    state = manager.State.Prepare

    if win then
        wave = wave + 1
        -- TODO: Add money?
    end
end

hook.Add("GTD_ReadyStateChanged", "GTD_CheckIfAllPlayersReadiedUp", function(ply, state)
    if !state then return end
    
    local plys = player.GetAll()
    local allready = true

    for k, v in ipairs(plys) do
        if !v:IsReady() or (v == ply) then allready = false
    end

    if allready then _startNextRound() end
end)

--[[
OLD CODE MADE FOR MANUAL WAVES

manager.States = {
    PREGAME = 0,
    ROUND = 1,
    PREPARE = 2,
    END = 3
}
local state = state or manager.States.PREGAME

local waves = {[0] = false}
local curwave = curwave or 0

util.AddNetworkString("td_stateupdate")
util.AddNetworkString("td_waveupdate")

-- FUNCTIONS

-- Local Utility

function _checkReady()
    local prepared = true
    for _, ply in pairs(player.GetAll()) do
        if !ply:GetNWBool("GTD_Ready") then
            prepared = false
        end
    end
    return prepared
end

-- State Managment
function manager:SetState( newstate )
    if not isnumber(newstate) then
        newstate = se-f.States[state]
    end
    if not state then return false end

    if not hook.Run("TD_SetState", newstate) then return false end
    state = newstate

    net.Start("td_stateupdate")
    net.WriteUInt(newstate, 2)
    net.Broadcast()
    return true
end

function manager:GetState()
    return state
end

-- Wave Managment

-- Starts the next wave if all players are ready
function manager:StartNextWave(force)
    if self:HasEnded() then return end

    prepared = _checkReady()
    if prepared or force then
        self:SetWave(curwave+1, force)
    end
end

-- Sets to a specific wave and starts it (if possible)
function manager:StartWave(wave, force)
    if self:SetState(self.States.ROUND) or force then
        curwave = wave
        waves[wave].OnStart(force)
        net.Start("td_waveupdate")
        net.WriteUInt(wave, 6)
        net.Broadcast()
    end
end

-- Sets to a specific wave (in PREPARE state)
function manager:SetWave(wave, force)
    if self:GetState() == self.States.ROUND then local runEnd = true end
    if self:SetState(self.States.PREPARE) or force then
        curwave = wave
        if runEnd then waves[wave].OnEnd(force) end
        net.Start("td_waveupdate")
        net.WriteUInt(wave, 6)
        net.Broadcast()
    end
end

-- Ends the wave (win: next wave, force: end on same wave no matter what)
function manager:EndWave(win, force)
    if win and !force then self:SetWave(curwave + 1) 
    else self:SetWave(curwave) end

end

function manager:HasEnded()
    return state == self.States.END
end

function manager:GetMaxWaves()
    return table.Count(waves) - 1 -- We have to subtract one because of Wave 0
end

-- Wave Registration and Actual functionality

Takes a table as an argument

Table structure:
{
    Id, --Integer, number of the wave (Defaults to  the next highest number)
    OnStart, --Function, runs when the wave starts (Parameters: force - was the wave forced to start?)
    OnEnd --Function, runs when the wave ends (Parameters: force - was the wave forced to end?)
}


function manager:RegisterWave(waveinfo)
    if not waveinfo.Id then waveinfo.Id = table.Count(waves) end
    waves[tableinfo.Id] = {OnStart = waveinfo.OnStart, OnEnd = waveinfo.OnEnd}
end

]]