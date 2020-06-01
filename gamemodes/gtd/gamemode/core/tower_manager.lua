GM.TowerManger = GM.TowerManger or {}
local manager = GM.TowerManger -- you know
local towertypes = {}

manager.Modifiers = {
    GROUND_ONLY = 0,
    AIR_ONLY = 1,
    TARGETS_TOWERS = 2,
    NO_DAMAGE = 3,
}

function manager:Register( info )
    if not info.Name then return end
    local name = string.lower(info.Name)
    if towertypes[name] then return end

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

    towertypes[name] = {
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