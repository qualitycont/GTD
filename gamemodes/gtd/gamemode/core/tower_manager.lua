GM.TowerManager = GM.TowerManager or {}
local manager = GM.TowerManager -- you know
local towertypes = {} -- WARNING, due to the placement code, this uses numbers as keys, you will have to find out the correct one yourself

manager.Modifiers = {
    GROUND_ONLY = 0,
    AIR_ONLY = 1,
    TARGETS_TOWERS = 2,
    NO_DAMAGE = 3,
}

function manager:Register( info )
    if not info.Name then return end
    local name = string.lower(info.Name)
    if self:GetByName(name) then return end

    info.Model = info.Model or "models/weapons/w_pist_fiveseven.mdl"
    info.Price = info.Price or 100

    info.Damage = info.Damage or 1
    info.FireRate = info.FireRate or .5
    info.Health = info.Health or 50
    info.Range = info.Range or 500

    info.RequiredClass = info.RequiredClass or ""
    info.RequiredLevel = info.RequiredLevel or ""
    info.CanBuy = info.CanBuy or function(ply) end
    info.Modifiers = info.Modifiers or {}

    towertypes[table.Count(towertypes) + 1] = {
        Name = info.Name,
        Model = info.Model,
        Price = info.Price,
        Damage = info.Damage,
        FireRate = info.FireRage,
        Health = info.Health,
        Range = info.Range,
        RequiredClass = info.RequiredClass,
        RequiredLevel = info.RequredLevel,
        CanBuy = info.CanBuy,
        Modifiers = info.Modifiers
    }
end

function manager:GetAll()
    return towertypes
end

function manager:GetByName(key)
    for _, v in ipairs(towertypes) do
        if v.Name == key then return v end
    end
end