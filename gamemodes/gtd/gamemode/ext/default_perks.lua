local manager = GM.PerkManager

manager:Register{
    Name = "tough_skin",
    DisplayName = "Tough Skin",
    Description = [[Take -10% Damage from all sources!]],
    Modifier = manager.Modifiers.LESS_DAMAGE,
    ModifierPower = 10
}

manager:Register{
    Name = "light_armor",
    DisplayName = "Light Armour",
    Description = [[Gain 25 armor]],
    Modifier = manager.Modifiers.EXTRA_ARMOR,
    ModifierPower = 25
}

manager:Register{
    Name = "bone_piercing_rounds",
    DisplayName = "Bone Piercing Rounds",
    Description = [[Deal 50% more damage on headshots]],
    Class = "sniper",
    Level = 10,
    Modifier = manager.Modifiers.EXTRA_DAMAGE,
    ModifierPower = 0.5,
    ModifierCondition = function(ply, target, dmg)
        if target:LastHitGroup() == HITGROUP_HEAD then
            return true
        end
        return false
    end
}

manager:Register{
    Name = "arsenal_upgrade",
    DisplayName = "Arsenal Upgrade",
    Description = [[Your equipment now includes HE Grenades!
    Also, deal 10% more explosive damage]],
    Class = "trapper",
    Level = 10,
    Modifier = manager.Modifiers.EXTRA_DAMAGE,
    ModifierPower = 0.1,
    ModifierCondition = function(ply, target, dmg)
        if dmg:IsExplosionDamage() then
            return true
        end
        return false
    end,
    OnSpawn = function(ply)
        ply:Give("weapon_grenade")
    end
}

manager:Register{
    Name = "bombproof_vest",
    DisplayName = "Bomb-Proof vest",
    Description = [[Take 50% less damage from explosives!]],
    Class = "specialist",
    Level = 20,
    Modifier = manager.Modifiers.LESS_DAMAGE,
    ModifierPower = 0.5,
    ModifierCondition = function(ply, dmg)
        if dmg:IsExplosionDamage() then
            return true
        end
        return false
    end
}

manager:Register{
    Name = "rambo",
    DisplayName = "Rambo",
    Description = [[Deal 33% more damage!
    But spawn with 80 health...]],
    Class = "soldier",
    Level = 20,
    Modifier = manager.Modifiers.EXTRA_DAMAGE,
    ModifierPower = 0.33,
    OnSpawn = function(ply)
        ply:SetMaxHealth(80)
        ply:SetHealth(80)
    end
}

manager:Register{
    Name = "scrooge",
    DisplayName = "Scrooge",
    Description = [[Gain 30% More money!]],
    Level = 25,
    Modifier = manager.Modifiers.EXTRA_MONEY,
    ModifierPower = 0.30,
}

manager:Register{
    Name = "healers_luck",
    DisplayName = "Healers luck",
    Description = [[All shots have a 25% chance of missing completely!]],
    Class = "medic",
    Level = 30,
    Modifier = manager.Modifiers.LESS_DAMAGE,
    ModifierPower = 1,
    ModifierCondition = function(ply, dmg)
        local roll = math.random(1, 4)
        if roll == 4 then
            return true
        end
        return false
    end
}

manager:Register{
    Name = "portable_provider",
    DisplayName = "Portable Provider",
    Description = [[Gain 10 armor every 5 seconds!]],
    Class = "engineer",
    Level = 30,
    Modifier = manager.Modifiers.ARMOR_REGEN,
    ModifierPower = 10,
}

manager:Register{
    Name = "deus_ex_machina",
    DisplayName = "Deus ex machina",
    Description = [[Deal 80% more damage while under half health]],
    Class = "scout",
    Level = 40,
    Modifier = manager.Modifiers.EXTRA_DAMAGE,
    ModifierPower = .8,
    ModifierCondition = function(ply, target, dmg)
        if ply:Health() < ply:GetMaxHealth()/2 then
            return true
        end
        return false
    end
}

manager:Register{
    Name = "beastmode",
    DisplayName = "Beastmode",
    Description = [[Gain 10 health every 5 seconds.
    Also spawn with 20 extra max health!]],
    Class = "tank",
    Level = 40,
    Modifier = manager.Modifiers.HEALTH_REGEN,
    ModifierPower = 10,
    OnSpawn = function(ply)
        ply:SetMaxHealth(ply:GetMaxHealth()+20)
    end
}

manager:Register{
    Name = "experienced",
    DisplayName = "Experienced",
    Description = [[Gain 25% more XP!]],
    Level = 50,
    Modifier = manager.Modifiers.EXTRA_XP,
    ModifierPower = .25,
}

manager:Register{
    Name = "old_dog",
    DisplayName = "Old Dog",
    Description = [[Gain no XP
    But start with 50 extra max health]],
    Level = 100,
    Modifier = manager.Modifiers.EXTRA_XP,
    ModifierPower = -1,
    OnSpawn = function(ply)
        ply:SetMaxHealth(ply:GetMaxHealth()+50)
        ply:SetHealth(ply:GetMaxHealth()+50)
    end
}