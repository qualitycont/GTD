AddCSLuaFile("shared.lua")
include("shared.lua")

resource.AddFile("/materials/background.jpg")
resource.AddFile("/materials/hp.jpg")
resource.AddFile("/materials/armor.jpg")

function GM:PlayerSpawn(ply)
    if not ply:HasFirstSpawned() then
        player_manager.SetPlayerClass( ply, "player_td")
        ply:FirstSpawned()
    end

    player_manager.OnPlayerSpawn(ply)
    player_manager.RunClass(ply, "Spawn")

    hook.Call("PlayerLoadout", GAMEMODE, ply)
    hook.Call("PlayerSetModel", GAMEMODE, ply)
    ply:SetupHands()
end

------------------------------------------------------------------> temporary
hook.Add("PlayerSay","jsadjadasd",function(ply,txt)
	if txt == "pos" then 
		ply:ChatPrint(tostring(ply:GetPos()))
	elseif txt == "core" then 
		local ball = ents.Create("sent_ball")
		ball:SetPos(Vector(715.091125 ,79.530266, 194.512238))
		ball.type = "master"
		ball:Spawn()
	elseif txt == "spawn" then
		for i=1,1 do 
			local follower = ents.Create("base_ai")
			follower:SetPos(Vector(40.276276, 1410.253174, 175.049774))
			follower.type = "master"
			follower:Spawn()
			local follower2 = ents.Create("base_ai")
			follower2:SetPos(Vector(-421.821167 ,1066.835327, 170.773849))
			follower2.type = "master"
			follower2:Spawn()
			local follower3 = ents.Create("base_ai")
			follower3:SetPos(Vector(-290.722931 ,410.462189, 166.559189))
			follower3.type = "master"
			follower3:Spawn()
		end
	end
end)
------------------------------------------------------------------>