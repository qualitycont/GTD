AddCSLuaFile("shared.lua")
include("shared.lua")

function GM:PlayerSpawn(ply)
    if not ply:HasFirstSpawned() then
        player_manager.SetPlayerClass( ply, "player_td")
        ply:FirstSpawned()
    end
end