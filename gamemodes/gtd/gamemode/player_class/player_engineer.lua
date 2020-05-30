DEFINE_BASECLASS( "player_td" )

local PLAYER = {}

function PLAYER:Loadout()
    self.Player:Give("weapon_smg1")
    self.Player:Give("weapon_stunstick")
    self.Player:Give("weapon_fists")
end

player_manager.RegisterClass( "player_engineer", PLAYER, "player_td")