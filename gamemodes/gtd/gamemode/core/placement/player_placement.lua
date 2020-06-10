-- Taser models/weapons/w_eq_taser.mdl
-- heavy models/weapons/w_mach_m249para.mdl
-- pistol models/weapons/w_pist_p250.mdl

-- Shared stuff

PlacementSystem = PlacementSystem or {}
PlacementSystem.Objects = PlacementSystem.Objects or GM.TowerManager.GetAll()

local function _checkForNil(val)
	if val == nil then 
		return "N/A"
	else 
		return val 
	end
end

if SERVER then
	util.AddNetworkString("GTD_PlacementSystem_StartPrePlace")
	util.AddNetworkString("GTD_PlacementSystem_CancelPrePlace")

	function PlacementSystem.PlaceBlueprint( plyPlacing, towerIndex )
		print("BP MODE: -> ", plyPlacing:Nick(), towerIndex)
		plyPlacing:ChatPrint(" Starting to place tower...")

		-- Player is now holding a blueprint
		plyPlacing:SetholdingBP( true )

		local idToTower = PlacementSystem.Objects[ towerIndex ]
		local bp = ents.Create("td_tower_base")
		bp:SetPos(plyPlacing:GetEyeTrace().HitPos)
		bp:SetAngles(plyPlacing:GetAngles())
		bp:SetModel("models/Combine_turrets/Floor_turret.mdl")
		  bp:SetOwner( plyPlacing )
		  bp:SetisBluePrint( true )
		bp:Spawn()
		bp.Think = function(_s)
			print(_s:GetOwner())
			if !_s:GetOwner() then return end
			if !_s:GetisBluePrint() then return end

			_s:SetPos( _s:GetOwner():GetEyeTrace().HitPos )
		end


	end

	net.Receive("GTD_PlacementSystem_StartPrePlace", function(len, ply)
		-- start the towerplace ( i.e blueprint )
		local towerIndex = net.ReadInt(32)
		PlacementSystem.PlaceBlueprint( ply, towerIndex )
	end)

	net.Receive("GTD_PlacementSystem_CancelPrePlace", function(len, ply) -- cee being lazy ;p
		for k, v in pairs( ents.FindByClass("td_tower_base") ) do
			if v:IsPlayer() then continue end;
			if !IsValid(v) then continue end;

			if v:GetisBluePrint() == true then
				if v:GetOwner() == ply and ply:GetholdingBP() then
					ply:SetholdingBP(false)
					v:Remove()
				end
			end
		end
	end)

else

	surface.CreateFont( "gtd:TestFont", {
		font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 33,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	-- Clientside

	local function dontdrawPlacementModels()
		for k, v in pairs ( PlacementSystem.Objects ) do
			if v.ModelObj then
				v.ModelObj:SetVisible(false)
				v.ModelhasCached = true
			end
		end
	end

	local cooldown = CurTime() + .25
	       
	local function drawPlacementModel( index, posX ) -- For caching DModel.

		local obj	 	 = PlacementSystem.Objects[ index ].ModelObj; -- create for reference.
		local m_Model    = PlacementSystem.Objects[ index ].Model;
		local m_hasCache = PlacementSystem.Objects[ index ].ModelhasCached;

		if  obj == nil then

			local m_obj = vgui.Create( "DModelPanel" )
			m_obj:SetSize( 200, 200 )
			m_obj:SetModel( PlacementSystem.Objects[ index ].Model )
			function m_obj:LayoutEntity( Entity ) return end 
			function m_obj.Entity:GetPlayerColor() return Vector (1, 0, 0) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
			
			PlacementSystem.Objects[ index ].ModelhasCached = true
			PlacementSystem.Objects[ index ].ModelObj = m_obj

			chat.AddText( index .. " was crerereated.")
	 		   
		else 
			if obj then
				if m_hasCache == true then
					obj:SetVisible(true)
					obj:SetPos(posX-50,ScrH() / 2 - (200-15) )
				end
			end
		end
	end
	   
	local function getSelectedInfo( curSelected )
		local Obj = PlacementSystem.Objects[ curSelected ]
	end

	local selected = 1
	hook.Add("HUDPaint", "GTD_Placement", function()

		if not LocalPlayer():Alive() or not IsValid(LocalPlayer():GetActiveWeapon()) or LocalPlayer():GetActiveWeapon():GetClass() != "weapon_crowbar" then 
			dontdrawPlacementModels()
			return
		end
		
		if !LocalPlayer():GetholdingBP() then

			surface.SetFont( "HudHintTextLarge" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( ScrW()/3+100, ScrH()/2 - 200) 
			surface.DrawText( "Press 'Q' or 'E' to Cycle through towers." )	

			surface.SetFont( "gtd:TestFont" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( ScrW()/3+100, ScrH()/2 - 230) 
			surface.DrawText( "Right Click to select tower." )	
		else
			surface.SetFont( "HudHintTextLarge" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( ScrW()/3+100, ScrH()/2 - 200) 
			surface.DrawText( "Press 'Q' or 'E' to Rotate." )	

			surface.SetFont( "gtd:TestFont" )
			surface.SetTextColor( 240, 0, 0 )
			surface.SetTextPos( ScrW()/3+100, ScrH()/2 - 230) 
			surface.DrawText( "Press 'R' to cancel placement." )	
		end

		if !LocalPlayer():GetholdingBP() then
			local spacing = 125
			local inInfo = false
			for k, v in pairs( PlacementSystem.Objects ) do

				local _x = ScrW()/2 + spacing * k - ((spacing)*selected)-50

				surface.SetDrawColor(255,255,255,255)
				surface.DrawOutlinedRect(  _x, ScrH()/2-50, 100, 100 )

				if k == selected then
					surface.SetDrawColor(245, 189, 31, 190)
					surface.DrawRect(_x,ScrH()/2-50, 100, 100)
				end

				surface.SetFont( "Default" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( _x, ScrH()/2-100 ) 
				surface.DrawText( k )

				surface.SetFont( "Default" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( _x, ScrH()/2-100 ) 
				surface.DrawText( k )	

				surface.SetFont( "HudHintTextLarge" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( _x, ScrH()/2-70) 
				surface.DrawText( v.Name )	

				surface.SetFont( "Default" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( _x+5, ScrH()/2 + 15) 
				surface.DrawText( "Damage: " .. _checkForNil(v.Damage) )	

				surface.SetFont( "Default" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( _x+5, ScrH()/2 +25) 
				surface.DrawText( "Firerate: " .. _checkForNil(v.FireRate) )	

				surface.SetFont( "Default" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( _x+5, ScrH()/2 +35) 
				surface.DrawText( "Health: " .. _checkForNil(v.Health) )	


				surface.SetFont( "HudHintTextLarge" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( _x, ScrH()/2+50) 
				surface.DrawText( "$" .. _checkForNil(v.Price) )	

				drawPlacementModel( k, _x )

			end

		    surface.SetDrawColor(0,0,0,90)
		    surface.DrawRect(0,0,ScrW(),ScrH())
		   else
		   	dontdrawPlacementModels()
		end

	    if cooldown > CurTime() then return end

	    if input.IsKeyDown( KEY_E ) then // cycle right
	    	-- if not blueprint then scroll
	    	-- if blueprint then rotate
	    	if !LocalPlayer():GetholdingBP() then
		    	cooldown = CurTime() + .5
		    	selected = math.Clamp(selected + 1, 1, table.Count(PlacementSystem.Objects))
		    else
		    	-- rotate current tower
		    end
	    end

	    if input.IsKeyDown( KEY_Q ) then // cycle left
	    	-- if not blueprint then scroll
	    	-- if blueprint then rotate
	    	if !LocalPlayer():GetholdingBP() then
		    	cooldown = CurTime() + .5
		    	selected = math.Clamp(selected - 1, 1, table.Count(PlacementSystem.Objects))
		    else
		    	-- rotate current tower
		    end
	    end

	    if input.IsKeyDown( KEY_R ) then // cycle left
	    	-- if not blueprint then scroll
	    	-- if blueprint then rotate
	    	if LocalPlayer():GetholdingBP() then
		    	cooldown = CurTime() + 1.5
		    	selected = math.Clamp(selected - 1, 1, table.Count(PlacementSystem.Objects))

				net.Start("GTD_PlacementSystem_CancelPrePlace")
				net.SendToServer()

				chat.AddText("Blueprint removed...")
		    end
	    end

	    -- if blueprint ignore
	    if input.IsMouseDown( MOUSE_RIGHT ) and !LocalPlayer():GetholdingBP() then
	    	cooldown = CurTime() + 1
	    	chat.AddText("Tower Selected: " .. PlacementSystem.Objects[ selected ].Name )

	    	net.Start("GTD_PlacementSystem_StartPrePlace")
	    	 net.WriteInt(selected, 32)
	    	net.SendToServer()
	    end

	end)

end
