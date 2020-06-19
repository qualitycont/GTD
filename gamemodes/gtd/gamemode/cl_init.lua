include("shared.lua")

local mat = Material("materials/background.png")
local mat2 = Material("materials/hp.png")
local mat3 = Material("materials/armor.png")

local avatar = vgui.Create("AvatarImage")
avatar:SetSize(84,84)
avatar:SetPos(100,100)

local hp = 100

local function _getWaveStateColor()
	if not GAMEMODE.RoundManager then return Color(100, 100, 100) end

	local state = GAMEMODE.RoundManager.GetState()
	if state == GAMEMODE.RoundManager.States.ROUND then return Color(230, 97, 90) end
	return Color(57, 187, 204)
end

function GM:HUDPaint()
	local w = ScrW()
	local h = ScrH()

	hp = Lerp(0.01,hp,LocalPlayer():Health())

	-- waves
	draw.RoundedBox(12,w*0.35,h*0.015,w*0.25,h*0.03,_getWaveStateColor())

	local core = ents.FindByClass("info_td_core")
	local c = table.Count(core)
	local w2 = 0.325
	for k,v in pairs(core) do 
		--if core.On then 
			draw.RoundedBox(12,w*w2,h*0.053,w*(0.293/c),h*0.022,Color(45,45,45))
			draw.RoundedBox(12,w*w2,h*0.053,w*(0.293/c),h*0.022,Color(230, 97, 90))
			w2 = ((0.3/c)*k)+0.324
		--end
	end

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(w*0.0485,h*0.883,w*0.155,h*0.05)
	surface.SetDrawColor(255,255,255)

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(w*0.0481,h*0.916,w*0.165,h*0.05)
	surface.SetDrawColor(255,255,255)

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat2)
	surface.DrawTexturedRect(w*0.064,h*0.895,(hp*w)*0.00126,h*0.024)
	surface.SetDrawColor(255,255,255)

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat3)
	surface.DrawTexturedRect(w*0.064,h*0.929,w*0.1335,h*0.024)
	surface.SetDrawColor(255,255,255)


	draw.RoundedBox(7.5, w*0.014,h*0.873,w*0.06,h*0.105, Color(167,158,165))
	avatar:SetPlayer(LocalPlayer(),84)
	avatar:SetSize(w*0.052,h*0.091)
	avatar:SetPos(w*0.018,h*0.881)

	if player_manager.GetPlayerClass(LocalPlayer()) == "player_td" then
		draw.SimpleText( LocalPlayer():GetMoney() .. "$", "HudHintTextLarge", ScrW()/2, ScrH()/10*9, Color( 50, 255, 50 ), TEXT_ALIGN_CENTER)	
		draw.SimpleText( "Level: " .. LocalPlayer():GetLevel(), "HudHintTextLarge", ScrW()/2, ScrH()/10*9+20, Color( 50, 50, 255 ), TEXT_ALIGN_CENTER)
		draw.SimpleText( LocalPlayer():GetXP() .. "/" .. LocalPlayer():GetNeededXP() .. " XP", "HudHintTextLarge", ScrW()/2, ScrH()/10*9+40, Color( 50, 50, 255 ), TEXT_ALIGN_CENTER)
	end
	
end

function GM:HUDShouldDraw(n)
	if n == "CHudHealth" or n == "CHudBattery" then 
		return false
	else
		return true
	end
end