DEFINE_BASECLASS( "player_td" )

local PLAYER = {}

function PLAYER:Loadout()
    self.Player:Give("weapon_shotgun")
    self.Player:Give("weapon_pistol")
    self.Player:Give("weapon_slam")
    self.Player:Give("weapon_fists")
end

player_manager.RegisterClass( "player_trapper", PLAYER, "player_td")