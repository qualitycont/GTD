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

local waves = {}
local wave = wave or 0

-- FUNCTIONS

-- State Stuff
function manager:SetState( newstate)
    if not isnumber(newstate) then
        newstate = se-f.States[state]
    end
    if not state then return false end

    if not hook.Run("TD_SetState", newstate) then return false end
    state = newstate
    return true
end

function self:GetState()
    return state
end

-- Wave Stuff
function manager:StartWave(force)
    if self:HasEnded() then return end

    local prepared = true
    for _, ply in pairs(player.GetAll()) do
        if !ply:GetNWBool("GTD_Ready") then
            prepared = false
        end
    end

    if prepared or force then
        wave = wave + 1
    end
end

function manager:SetWave(wave)
    if manager:SetState(self.States.PREPARE) then
        self.Wave = wave
    end
end

function manager:HasEnded()
    return state == self.States.END
end