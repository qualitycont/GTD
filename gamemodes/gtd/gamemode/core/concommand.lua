local manager = GM.RoundManager --makes typing easier
local manager2 = GM.ClassManager --i dont need to make this easier but i still need to use it for some reason

concommand.Add("td_class", function(ply, _, args)
    if manager:GetState() == manager.States.ROUND then return end
    
    local class = args[1]

    ply:SetTDClass(class)
    if ply:Alive() then
        player_manager.RunClass(ply,"Loadout")
    end
end)

concommand.Add("td_listclasses", function(ply)
    PrintTable(manager2.GetAll())
end)

concommand.Add("td_currentclass",function(ply)
    print(ply:GetTDClass())
end)