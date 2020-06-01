
-- Taser models/weapons/w_eq_taser.mdl
-- heavy models/weapons/w_mach_m249para.mdl
-- pistol models/weapons/w_pist_p250.mdl


PlacementSystem = {}

if PlacementSystem.Objects then return end
PlacementSystem.Objects = PlacementSystem.Objects or {
	[1] = {
		Name = "Pistol Tower",
		Model = "models/weapons/w_eq_taser.mdl",
		Damage = 3,
		FireRate = 0.6,
		Health = 100,
		Price = 120
	},
	[2] = {
		Name = "Pistol Tower",
		Model = "models/weapons/w_eq_taser.mdl",
		Damage = 3,
		FireRate = 0.6,
		Health = 100,
		Price = 120
	},
	[3] = {
		Name = "Pistol Tower",
		Model = "models/weapons/w_eq_taser.mdl",
		Damage = 3,
		FireRate = 0.6,
		Health = 100,
		Price = 120
	},
	[4] = {
		Name = "Pistol Tower",
		Model = "models/weapons/w_eq_taser.mdl",
		Damage = 3,
		FireRate = 0.6,
		Health = 100,
		Price = 120
	},
	[5] = {
		Name = "cee is gay",
		Model = "models/weapons/w_eq_taser.mdl",
		Damage = 3,
		FireRate = 0.6,
		Health = 100,
		Price = 120
	}

}
 
local function dontdrawPlacementModels()

	for k, v in pairs ( PlacementSystem.Objects ) do
		if v.ModelObj then
			v.ModelObj:SetVisible(false)
		end
	end
end

local cooldown = CurTime() + .25
       
local function drawPlacementModel( index, posX ) -- For caching DModel.

	--if CurTime() > cooldown then return end
	if  PlacementSystem.Objects[ index ].ModelhasCached == nil then

		local m_obj = vgui.Create( "DModelPanel" )
		m_obj:SetSize( 200, 200 )
		m_obj:SetModel( PlacementSystem.Objects[ index ].Model )
		m_obj.m_parent = index
		function m_obj:LayoutEntity( Entity ) return end 
		function m_obj.Entity:GetPlayerColor() return Vector (1, 0, 0) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
		
		PlacementSystem.Objects[ index ].ModelhasCached = true
		PlacementSystem.Objects[ index ].ModelObj = m_obj
 		
	else
  
		local obj	 = PlacementSystem.Objects[ index ].ModelObj; -- create for reference.
		local m_Model    = PlacementSystem.Objects[ index ].Model;
		local m_hasCache = PlacementSystem.Objects[ index ].ModelhasCached;
		if obj then
			obj:SetPos(posX-50,ScrH() / 2 - (200-15) )
			obj:SetVisible(true)
		end
	end
end

local function getSelectedInfo( curSelected )
	local Obj = PlacementSystem.Objects[ curSelected ]
end

local selected = 1
hook.Add("HUDPaint", "GTD_Placement", function()

	if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_crowbar" then 
		dontdrawPlacementModels()
		return 
	end;

	surface.SetFont( "HudHintTextLarge" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( ScrW()/6, ScrH()/2+325) 
	surface.DrawText( "Press 'Q' or 'E' to Cycle through towers." )	


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
    	selected = math.Clamp(selected + 1, 1, table.Count(PlacementSystem.Objects))
    end

    if input.IsKeyDown( KEY_Q ) then // cycle left
    	cooldown = CurTime() + .3
    	selected = math.Clamp(selected - 1, 1, table.Count(PlacementSystem.Objects))
    end

end)