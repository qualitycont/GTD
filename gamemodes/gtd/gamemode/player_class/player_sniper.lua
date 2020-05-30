DEFINE_BASECLASS( "player_td" )

local PLAYER = {}

function PLAYER:Loadout()
    self.Player:Give("weapon_crossbow")
    self.Player:Give("weapon_pistol")
    self.Player:Give("weapon_fists")
end

player_manager.RegisterClass( "player_sniper", PLAYER, "player_td")