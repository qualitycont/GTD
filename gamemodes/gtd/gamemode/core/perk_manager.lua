GM.PerkManager = GM.PerkManager or {}
local manager = GM.PerkManager -- why am i even saying this anymore
local perks = {}

manager.Modifiers = {
    EXTRA_DAMAGE = 0, -- Extra damage dealt, power = % of damage
    EXTRA_HEALTH = 1, -- Extra HP you spawn with, power = amount of health
    EXTRA_ARMOR = 2, -- Extra armour you spawn with, power = amount of armour
    LESS_DAMAGE = 3, -- Less damage taken, power = % of damage
    EXTRA_MONEY_GAIN = 4, -- Overall extra money gain, power = % of money
    EXTRA_XP_GAIN = 5, -- Overall extra XP gain, power = % of money
    EXTRA_SPEED = 6, -- Overall extra Speed gain, power = amount of speed
    EXTRA_TOWER_DAMAGE = 7, -- Extra Damage your towers deals (or heals incase of support towers), amount = % of extra tower damage
    EXTRA_TOWER_HEALTH = 8, -- Extra HP your towers spawn with, amount = % of extra tower health
    ARMOR_REGEN = 9, -- Armour regenerated every 5 seconds, power = amount of armour
    HEALTH_REGEN = 10, -- Health regenerated every 5 seconds, power = amount of health
}

function manager:Register(info)
    if not info.Name then return end
    local name = string.lower(info.Name)

    info.DisplayName = info.DisplayName or info.Name
    info.Description = info.Description or [[NO description set!]]
    info.Level = info.Level or 0
    info.Class = info.Class or ""
    info.Modifier = info.Modifier or -1
    info.ModifierPower = info.ModiferPower or 0
    info.ModifierCondition = info.ModifierCondition or function(ply, ...) return true end
    info.OnSpawn = info.OnSpawn or function(ply) end
    info.OnDeath = info.OnDeath or function(ply,inf,atk) end
    info.OnEquip = info.OnEquip or function(ply) end

    perks[name] = {
        DisplayName = info.DisplayName,
        Description = info.Description,
        Level = info.Level,
        Class = info.Class,
        Modifer = info.Modifier,
        ModifierPower = info.ModifierPower,
        ModifierCondition = info.ModifierCondition,
        OnSpawn = info.OnSpawn,
        OnDeath = info.OnDeath,
        OnEquip = info.OnEquip
    }
end

function manager:GetAll()
    return perks
end

if SERVER then

    hook.Add("PlayerSpawn", "GTD_Perk_Spawn", function(ply)
        for _, perk in pairs(ply:GetEquippedPerks()) do
            if perk.Modifier == manager.Modifiers.EXTRA_HEALTH then
                local hp = ply:GetMaxHealth()
                if not perk.ModifierCondition(atk, hp) then break end
                ply:SetMaxHealth(hp + perk.ModifierPower)
            elseif perk.Modifier == manager.Modifiers.EXTRA_ARMOR then
                local armor = ply:Armor()
                if not perk.ModifierCondition(atk, armor) then break end
                ply:SetArmor(armor + perk.ModifierPower)
            elseif perk.Modifier == manager.Modifiers.EXTRA_SPEED then
                local walkspeed = ply:GetWalkSpeed()
                local runspeed = ply:GetRunSpeed()

                if not perk.ModifierCondition(atk, walkspeed, runspeed) then break end

                ply:SetWalkSpeed(walkspeed + perk.ModifierPower)
                ply:SetRunSpeed(runspeed + perk.ModifierPower)
                ply:SetMaxSpeed(runspeed + perk.ModifierPower)
            end

            perk.OnSpawn(ply)
        end
    end)

    hook.Add("PlayerDeath", "GTD_Perk_Death", function(ply, inf, atk)
        for _, perk in pairs(ply:GetEquippedPerks()) do
            perk.OnDeath(ply, inf, atk)
        end
    end)

    hook.Add("EntityTakeDamage", "GTD_Perk_Damage_Modifiers", function(target, dmg)
        local atk = dmg:GetAttacker()

        local scale = 1

        if atk:IsPlayer() then
            for _, perk in pairs(atk:GetEquippedPerks()) do
                if perk.Modifier == manager.Modifiers.EXTRA_DAMAGE then
                    if not perk.ModifierCondition(atk, target, dmg) then continue end
                    scale = scale * (perk.ModifierPower+1)
                end
            end
        end

        if target:IsPlayer() then
            for _, perk in pairs(atk:GetEquippedPerks()) do
                if perk.Modifier == manager.Modifiers.LESS_DAMAGE then
                    if not perk.ModifierCondition(target, dmg) then continue end
                    scale = scale * (1-perk.ModifierPower)
                end
            end
        end

        dmg:ScaleDamage(scale)
    end)

    hook.Add("GTD_XPGained", "GTD_Perk_XP", function(ply, amount)
        for _, perk in pairs(ply:GetEquippedPerks()) do
            if perk.Modifier == manager.Modifiers.EXTRA_XP_GAIN then
                if not perk.ModifierCondition(atk, amount) then continue end
                amount = amount * (perk.ModifierPower + 1)
            end
        end
        return amount
    end)

    hook.Add("GTD_MoneyGained", "GTD_Perk_Money", function(ply, amount)
        for _, perk in pairs(ply:GetEquippedPerks()) do
            if perk.Modifier == manager.Modifiers.EXTRA_MONEY_GAIN then
                if not perk.ModifierCondition(atk, amount) then continue end
                amount = amount * (perk.ModifierPower + 1)
            end
        end
        return amount
    end)

    if not timer.Exists("GTD_Perk_Regen") then
        timer.Create("GTD_Perk_Regen", 5, 0, function()
            for _, ply in pairs(player.GetAll()) do
                for _, perk in pairs(ply:GetEquippedPerks()) do
                    if perk.Modifier == manager.Modifiers.ARMOR_REGEN then
                        if not perk.ModifierCondition(atk, ply:Armor()) then continue end
                        ply:SetArmor(ply:Armor() + perk.ModifierPower)
                    elseif perk.Modifier == manager.Modifiers.HEALTH_REGEN then
                        if not perk.ModifierCondition(atk, ply:Health()) then continue end
                        ply:SetHealth(ply:Health() + perk.ModifierPower)
                    end
                end
            end
        end)
    end

end