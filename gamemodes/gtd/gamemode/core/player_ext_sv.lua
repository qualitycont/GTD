local meta = FindMetaTable("Player")

function meta:FirstSpawned()
    self:SetNWBool("GTD_FirstSpawned", true)
end

function meta:HasFirstSpawned()
    return self:GetNWBool("GTD_FirstSpawned")
end

function meta:StripClassWeapons()
    local classes = GAMEMODE.ClassManager.GetAll() -- some files dont like GM :(
    for k, v in pairs(classes) do
        for _, v2 in pairs(v.Weapons) do
            self:StripWeapon(v2)
        end
    end
end

function meta:GainXP(amount)
   GM.Economy.GainXP(self, amount) 
end