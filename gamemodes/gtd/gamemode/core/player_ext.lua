local meta = FindMetaTable("Player")

function meta:Ready()
    self:SetNWBool("GTD_Ready", true)
end

function meta:UnReady()
    self:SetNWBool("GTD_Ready", false)
end

function meta:ToggleReady()
    self:SetNWBool("GTD_Ready", !self:GeNWBool("GTD_Ready"))
end