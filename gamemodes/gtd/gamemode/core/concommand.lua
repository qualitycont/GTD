concommand.Add("td_class", function(ply, _, args)
    if GAMEMODE.RoundManager:GetState() == GAMEMODE.RoundManager.States.ROUND then return end
    
    local class = args[1]

    ply:SetTDClass(class)
    ply:StripClassWeapons()
    if ply:Alive() then
        player_manager.RunClass(ply,"Loadout")
    end
end)

concommand.Add("td_perk", function(ply, _, args)
    local key = args[1]
    local slot = args[2]
    if not key or not slot then return end

    ply:EquipPerk(key,slot)
end)

concommand.Add("td_listclasses", function(ply)
    PrintTable(GAMEMODE.ClassManager.GetAll())
end)


concommand.Add("td_currentclass",function(ply)
    print(ply:GetTDClass())
end)

concommand.Add("td_currentperks",function(ply)
    PrintTable(ply:GetEquippedPerks())
end)

concommand.Add("td_toggleready", function(ply)
    ply:ToggleReady()
end)
