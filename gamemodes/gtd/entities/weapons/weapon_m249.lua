AddCSLuaFile()
DEFINE_BASECLASS( "weapon_csbasegun" )

CSParseWeaponInfo( SWEP , [[WeaponData
{
	"MaxPlayerSpeed"		"220" 
	"WeaponType"			"Machinegun"
	"FullAuto"				1
	"WeaponPrice"			"5750"
	"WeaponArmorRatio"		"1.6"
	"CrosshairMinDistance"		"6"
	"CrosshairDeltaDistance"	"3"
	"Team"				"ANY"
	"BuiltRightHanded"		"1"
	"PlayerAnimationExtension"	"m249"
	"MuzzleFlashScale"		"1.5"
	"MuzzleFlashStyle"		"CS_MUZZLEFLASH_X"
	"CanEquipWithShield" 		"0"

	
	// Weapon characteristics:
	"Penetration"			"2"
	"Damage"			"35"
	"Range"				"8192"
	"RangeModifier"			"0.97"
	"Bullets"			"1"
	"CycleTime"			"0.08"
	"AccuracyDivisor"		"175"
	"AccuracyOffset"		"0.4"
	"MaxInaccuracy"			"0.9"
	"TimeToIdle"			"1.6"
	"IdleInterval"			"20"
	
	// New accuracy model parameters
	"Spread"					0.00200
	"InaccuracyCrouch"			0.00763
	"InaccuracyStand"			0.01017
	"InaccuracyJump"			0.70830
	"InaccuracyLand"			0.14166
	"InaccuracyLadder"			0.13281
	"InaccuracyFire"			0.00427
	"InaccuracyMove"			0.10618
								 
	"RecoveryTimeCrouch"		0.55920
	"RecoveryTimeStand"			0.78288
	
	// Weapon data is loaded by both the Game and Client DLLs.
	"printname"			"M249"
	"viewmodel"			"models/weapons/v_mach_m249para.mdl"
	"playermodel"			"models/weapons/w_mach_m249para.mdl"
	
	"anim_prefix"			"anim"
	"bucket"			"0"
	"bucket_position"		"0"

	"clip_size"			"100"
	
	"primary_ammo"			"BULLET_PLAYER_556MM_BOX"
	"secondary_ammo"		"None"

	"weight"			"25"
	"item_flags"			"0"

	// Sounds for the weapon. There is a max of 16 sounds per category (i.e. max 16 "single_shot" sounds)
	SoundData
	{
		//"reload"			"Default.Reload"
		//"empty"				"Default.ClipEmpty_Rifle"
		"single_shot"		"Weapon_M249.Single"
		special3			Default.Zoom
	}

	// Weapon Sprite data is loaded by the Client DLL.
	TextureData
	{
		"weapon"
		{
				"font"		"CSweaponsSmall"
				"character"	"Z"
		}
		"weapon_s"
		{	
				"font"		"CSweapons"
				"character"	"Z"
		}
		"ammo"
		{
				"font"		"CSTypeDeath"
				"character"		"N"
		}
		"crosshair"
		{
				"file"		"sprites/crosshairs"
				"x"			"0"
				"y"			"48"
				"width"		"24"
				"height"	"24"
		}
		"autoaim"
		{
				"file"		"sprites/crosshairs"
				"x"			"0"
				"y"			"48"
				"width"		"24"
				"height"	"24"
		}
	}
	ModelBounds
	{
		Viewmodel
		{
			Mins	"-8 -8 -15"
			Maxs	"30 5 0"
		}
		World
		{
			Mins	"-4 -8 -6"
			Maxs	"31 8 10"
		}
	}
}]] )

SWEP.Spawnable = true

function SWEP:Initialize()
	BaseClass.Initialize( self )
	self:SetHoldType( "ar2" )
	self:SetWeaponID( CS_WEAPON_M249 )
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryAttack() > CurTime() then return end
	
	--Jvs: valve sure is good at pulling values out of their ass
	
	if not self:GetOwner():OnGround() then
		self:GunFire( 0.045 + 0.5 * self:GetAccuracy() )
	elseif self:GetOwner():GetAbsVelocity():Length2D() > 140 then
		self:GunFire( 0.045 + 0.095 * self:GetAccuracy() )
	else
		self:GunFire( 0.03 * self:GetAccuracy() )
	end
end

function SWEP:GunFire( spread )
	
	if not self:BaseGunFire( spread, self:GetWeaponInfo().CycleTime, true ) then
		return
	end
	
	if self:GetOwner():GetAbsVelocity():Length2D() > 5 then
		self:KickBack( 1.1, 0.5, 0.3, 0.06, 4, 3, 8)
	elseif not self:GetOwner():OnGround() then
		self:KickBack( 1.8, 0.65, 0.45, 0.125, 5, 3.5, 8 )
	elseif self:GetOwner():Crouching() then
		self:KickBack( 0.75, 0.325, 0.25, 0.025, 3.5, 2.5, 9 )
	else
		self:KickBack( 0.8, 0.35, 0.3, 0.03, 3.75, 3, 9 )
	end
end