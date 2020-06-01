
-- Taser models/weapons/w_eq_taser.mdl
-- heavy models/weapons/w_mach_m249para.mdl
-- pistol models/weapons/w_pist_p250.mdl

local Objects = Objects or { 
	[1] = {
		Name = "Pistol Tower",
		Model = "models/weapons/w_shot_xm1014.mdl",
		Price = 100,
		Damage = 1,
		FireRate = .5,
		Health = 30
	},
	[2] = {
		Name = "Shotgun Tower",
		Model = "models/weapons/w_shot_xm1014.mdl",
		Price = 350,
		Damage = 6,
		FireRate = 1.5,
		Health = 130
	},
	[3] = {
		Name = "Sniper Tower",
		Model = "models/weapons/w_snip_scout.mdl",
		Price = 750,
		Damage = 13,
		FireRate = 3,
		Health = 90
	}
}

local function dontdrawPlacementModels()

	for k, v in pairs ( Objects ) do
		if v.ModelObj then
			v.ModelObj:SetVisible( false )
		end
	end
end

local function drawPlacementModel( index, posX ) -- For caching DModel.


	if !Objects[ index ].ModelhasCached then

		--local m_obj 	 = Objects[ index ].ModelObj -- create for reference.
		--local m_Model    = Objects[ index ].Model
		--local m_hasCache = Objects[ index ].ModelhasCached

		m_obj = vgui.Create( "DModelPanel" )
		m_obj:SetSize( 200, 200 )
		m_obj:SetModel( Objects[ index ].Model )
		function m_obj:LayoutEntity( Entity ) return end 
		function m_obj.Entity:GetPlayerColor() return Vector (1, 0, 0) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
		
		Objects[ index ].ModelhasCached = true
		Objects[ index ].ModelObj = m_obj

		chat.AddText( index .. " cached!")
	else

		local m_obj 	 = Objects[ index ].ModelObj; -- create for reference.
		local m_Model    = Objects[ index ].Model;
		local m_hasCache = Objects[ index ].ModelhasCached;

		m_obj:SetPos(posX-50,ScrH() / 2 - (200-15) )
		m_obj:SetVisible(true)
	end
end

local function getSelectedInfo( curSelected )
	local Obj = Objects[ curSelected ]
	chat.AddText( Obj.Name )
end



local selected = 1
local cooldown = CurTime() + .25
hook.Add("HUDPaint", "cee:td:placement", function()

	if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_crowbar" then 
		dontdrawPlacementModels()
		return 
	end;

	surface.SetFont( "GModToolSubtitle" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( ScrW()/6, ScrH()/2+325) 
	surface.DrawText( "Press 'Q' or 'E' to Cycle through towers." )	


	local spacing = 125
	local inInfo = false
	for k, v in pairs( Objects ) do

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
		surface.DrawText( "Damage: " .. v.Damage )	

		surface.SetFont( "Default" )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( _x+5, ScrH()/2 +25) 
		surface.DrawText( "Firerate: " .. v.FireRate )	

		surface.SetFont( "Default" )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( _x+5, ScrH()/2 +35) 
		surface.DrawText( "Health: " .. v.Health )	


		surface.SetFont( "HudHintTextLarge" )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( _x, ScrH()/2+50) 
		surface.DrawText( "$" .. v.Price )	

		drawPlacementModel( k, _x )

	end

    surface.SetDrawColor(0,0,0,190)
    surface.DrawRect(0,0,ScrW(),ScrH())

    if cooldown > CurTime() then return end

    if input.IsKeyDown( KEY_E ) then // cycle right
    	cooldown = CurTime() + .3
    	selected = selected +1
    	chat.AddText("yay")
    end

    if input.IsKeyDown( KEY_Q ) then // cycle left
    	cooldown = CurTime() + .3
    	selected = selected -1
    	chat.AddText("yay")
    end

end)