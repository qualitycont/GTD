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
    return self:GetLevel() * GAMEMODE.Config["XPNeededMultipler"] * GAMEMODE.Config["BaseXPNeeded"]
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

function meta:GetEquippedPerks()
    equipped = {}

    local nwvars = self:GetNWVarTable()
    local perks = GAMEMODE.PerkManager.GetAll()
    for k, v in pairs(nwvars) do
        if string.StartWith(k, "GTD_Perk_") then
            local perk = perks[v]
            perk.Name = v
            equipped[tonumber(string.sub(k,10))] = perk
        end
    end

    return equipped
end

function meta:HasPerkEquipped(key)
    local nwvars = self:GetNWVarTable()
    for k, v in pairs(nwvars) do
        if string.StartWith(k, "GTD_Perk_") then
            if v == key then return true end
        end
    end

    return false
end

function meta:CanUseSlot(slot)
    local amount = GAMEMODE.Config.PerkSlots
    slot = tonumber(slot)
    if not isnumber(slot) or slot < 1 or slot > amount then return false end
    if GAMEMODE.Config.PerkSlotRequirements[slot] and self:GetLevel() < GAMEMODE.Config.PerkSlotRequirements[slot] then return false end
    return true
end

function meta:EquipPerk(key, slot)
    local perk = GAMEMODE.PerkManager.GetAll()[key]
    if not istable(perk) then return end

    if self:HasPerkEquipped(key) then return false end
    if !self:CanUseSlot(slot) then return false end
    if self:GetLevel() < perk.Level then return false end
    if perk.Class != "" and self:GetTDClass() != perk.Class then return false end

    self:SetNWString("GTD_Perk_"..slot,key)
    perk.OnEquip(self)
end