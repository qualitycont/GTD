DEFINE_BASECLASS( "player_td" )

local PLAYER = {}

function PLAYER:Loadout()
    self.Player:Give("weapon_pistol")
    self.Player:Give("weapon_stunstick")
    self.Player:Give("weapon_medkit")
    self.Player:Give("weapon_fists")
end

player_manager.RegisterClass( "player_medic", PLAYER, "player_td")