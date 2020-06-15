GM.EnemyManager = GM.EnemyManager or {}
local manager = GM.EnemyManager -- yes my fingers exist
local enemytypes = {}

manager.Size = {
    SMALL = 0,
    MEDIUM = 1,
    LARGE = 2,
    HUGE = 3
}

manager.Type = {
    GROUND = 0,
    AIR = 1
}

manager.Modifier = {
    IGNORE_PLAYERS = 0,
    NO_SLOWDOWN = 1
}

function manager:Register(info)
    if not info.Name then return end
    local name = string.lower(info.Name)
    if not info.Class or enemytypes[name] then return end

    info.Tokens = info.Tokens or 10

    info.Health = info.Health or 100
    info.Speed = info.Speed or 250

    info.Type = info.Type or self.Type.GROUND
    info.Size = info.Size or self.Size.MEDIUM
    info.Spawn = info.Spawn or false
    
    info.Modifier = info.Modifier or {}

    enemytypes[name] = {
        Health = info.Health,
        Tokens = info.Tokens,
        Speed = info.Speed,
        Type = info.Type,
        Size = info.Size,
        Spawn = info.Spawn,
        Modifier = info.Modifier
    }
end

function manager:GetAll()
    return enemytypes
end

function manager:Spawn(name)
    name = string.lower(name)
    if not enemytypes[name] then return false end
    local info = enemytypes[name]
    local spawnpos
    local found

    if info.Spawn then
        found = ents.FindByName(info.Spawn)
        if found then
            spawnpos = table.Random(found):GetPos()
        end
    end

    if not spawnpos then
        found = ents.FindByClass("info_td_enemy_spawn")
        if not found then return false end
        filtered = {}
        for k, v in pairs(found) do
            if v.size == info.Size and v.type == info.Type then
                filtered[k] = v
            end
        end
        
        spawnpos = table.Random(filtered):GetPos()
    end

    if not spawnpos then return false end
    local tospawn = ents.Create(name)
    tospawn:SetMaxHealth(info.Health)
    tospawn:SetHealth(info.Health)
    if tospawn then
        tospawn:Spawn()
        tospawn:SetPos(spawnpos)
        return true
    end
end