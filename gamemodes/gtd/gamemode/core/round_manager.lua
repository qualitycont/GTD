-- VARIABLES

GM.RoundManager = GM.RoundManger or {}
local manager = GM.RoundManager

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

--[[
    Takes a table as an argument

    Table structure:
    {
        Id, --Integer, number of the wave (Defaults to  the next highest number)
        OnStart, --Function, runs when the wave starts (Parameters: force - was the wave forced to start?)
        OnEnd --Function, runs when the wave ends (Parameters: force - was the wave forced to end?)
    }
]]

function manager:RegisterWave(waveinfo)
    if not waveinfo.Id then waveinfo.Id = table.Count(waves) end
    waves[tableinfo.Id] = {OnStart = waveinfo.OnStart, OnEnd = waveinfo.OnEnd}
end