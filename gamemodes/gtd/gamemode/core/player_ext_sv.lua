local meta = FindMetaTable("Player")

function meta:FirstSpawned()
    self:SetNWBool("GTD_FirstSpawned", true)
end

function meta:HasFirstSpawned()
    return self:GetNWBool("GTD_FirstSpawned")
end