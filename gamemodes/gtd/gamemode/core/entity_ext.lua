local meta = getmetatable("Entity")

function meta:IsTower()
    return scripted_ents.IsBasedOn(self:GetClass(), "npc_td_tower_base")
end