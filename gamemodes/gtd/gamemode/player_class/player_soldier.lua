DEFINE_BASECLASS( "player_td" )

local PLAYER = {}

function PLAYER:Loadout()
    self.Player:Give("weapon_ar2")
    self.Player:Give("weapon_357")
    self.Player:Give("weapon_fists")
end

player_manager.RegisterClass( "player_soldier", PLAYER, "player_td")