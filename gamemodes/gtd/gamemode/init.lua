AddCSLuaFile("shared.lua")
include("shared.lua")

function GM:PlayerSpawn(ply)
    if not ply:HasFirstSpawned() then
        player_manager.SetPlayerClass( ply, "player_td")
        ply:FirstSpawned()
    end

    ply:SetupHands()

    player_manager.OnPlayerSpawn(ply)
    player_manager.RunClass(ply, "Spawn")

    hook.Call("PlayerLoadout", GAMEMODE, ply)
    hook.Call("PlayerSetModel", GAMEMODE, ply)
end