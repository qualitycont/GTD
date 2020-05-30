local manager = GM.RoundManager --makes typing easier

concommand.Add("td_class", function(ply, _, args)
    if not manager:GetState() == manager.States.ROUND then return end
    
    local class = args[1]

    player_manager.SetPlayerClass(ply, "player_"..class)
    if ply:Alive() then
        player_manager.RunClass(ply,"Loadout")
    end
end)