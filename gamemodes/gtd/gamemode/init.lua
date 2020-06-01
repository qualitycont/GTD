AddCSLuaFile("shared.lua")
include("shared.lua")

resource.AddFile("content/materials/background.png")
resource.AddFile("content/materials/hp.png")
resource.AddFile("content/materials/armor.png")

function GM:PlayerSpawn(ply)
    if not ply:HasFirstSpawned() then
        ply:FirstSpawned()
    end
    player_manager.SetPlayerClass( ply, "player_td")

    player_manager.OnPlayerSpawn(ply)
    player_manager.RunClass(ply, "Spawn")
    player_manager.RunClass(ply, "SetModel")

    hook.Call("PlayerLoadout", GAMEMODE, ply)
    hook.Call("PlayerSetModel", GAMEMODE, ply)
    ply:SetupHands()
end