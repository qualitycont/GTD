local meta = FindMetaTable("Player")

function meta:FirstSpawned()
    self:SetNWBool("GTD_FirstSpawned", true)
end

function meta:HasFirstSpawned()
    return self:GetNWBool("GTD_FirstSpawned")
end

function meta:Ready()
    self:SetNWBool("GTD_Ready", true)
end

function meta:UnReady()
    self:SetNWBool("GTD_Ready", false)
end

function meta:ToggleReady()
    self:SetNWBool("GTD_Ready", !self:GeNWBool("GTD_Ready"))
end