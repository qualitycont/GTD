-- VARIABLES (also making stuff easier section)

GM.RoundManager = GM.RoundManger or {}
local manager = GM.RoundManager
local manager2 = GM.EnemyManager
local util = GM.Util

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
local state = state or manager.States.PREPARE

local function _calculateTokens()
    local newtokens = GM.Config.StartTokens * manager.Difficulty[GM.Config.Difficulty]
    return newtokens * wave * math.Clamp(util.Deviation(), 1, 2)
end

local function _spawnEnemies(amount)
    for k, v in ipairs(waveEnemies) do
        if amount <= 0 then return true end
        if table.IsEmpty(waveEnemies) then return false end

        manager2.Spawn(v.key)
        table.remove(waveEnemies, k)

        amount = amount - 1
    end
end

local function _generateNextWave()
    local enemies = manager2.GetAll()

    while tokens > 0 do
        local enemy, key = table.Random(enemies)
        if tokens >= enemy.Tokens then
            enemy.key = key
            table.insert(waveEnemies, enemy)
            tokens = tokens - enemy.Tokens
        end
    end
end

local function _startNextRound()
    print("starting round...")
    if CLIENT then return end
    state = manager.States.ROUND
    _generateNextWave()
    PrintTable(waveEnemies)

    local firecooldown = 10
    print("Next fire: "..firecooldown)

    timer.Create("GTD_EnemySpawnTimer", firecooldown, 0, function()
        if not _spawnEnemies(math.random(2,2+math.random(8))) then manager.EndRound(true) end
    end)
end

function manager:GetState()
    return state
end

function manager:GetWaveProgress()
    local percentleft = table.Count(waveEnemies) / waveEnemyCount
    return waveEnemyCount, percentleft
end

function manager:EndRound(win)
    if SERVER and timer.Exists("GTD_EnemySpawnTimer") then timer.Destroy("GTD_EnemySpawnTimer") end

    state = manager.State.Prepare
    _calculateTokens()

    if win then
        wave = wave + 1
        -- TODO: Add money?
    end
end

if SERVER then

    hook.Add("GTD_ReadyStateChanged", "GTD_CheckIfAllPlayersReadiedUp", function(ply, state)
        print("recieved ready!")
        if !state then return end
        
        local plys = player.GetAll()
        local allready = true

        for k, v in ipairs(plys) do
            if !v:IsReady() and !(v == ply) then allready = false end
        end

        print(allready)
        if allready then _startNextRound() end
    end)

end