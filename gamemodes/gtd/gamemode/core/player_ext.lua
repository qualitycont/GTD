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

function meta:GetNeededXP()
    return ply:GetLevel() * GAMEMODE.Config["XPNeededMultipler"] * GAMEMODE.Config["BaseXPNeeded"]
end

function meta:HasMoney(amount)
    return self:GetMoney() >= amount
end

function meta:HasCredits(amount)
    return self:GetCredits() >= amount
end

function meta:IsLevel(amount)
    return self:GetLevel() >= mount
end