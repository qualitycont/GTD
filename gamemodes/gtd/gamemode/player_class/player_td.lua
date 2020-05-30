DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

function PLAYER:SetupDataTables()
    self.Player:NetworkVar( "Int", 0, "Money" )
    self.Player:NetworkVar( "Bool", 0,"CanBuild" )
    if SERVER then
        self.Player:SetMoney(0)
        self.Player:SetCanBuild(true)
    end
end

function PLAYER:Loadout()
    self.Player:Give("weapon_fists")
end

player_manager.RegisterClass( "player_td", PLAYER, "player_default")