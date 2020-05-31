AddCSLuaFile()
DEFINE_BASECLASS( "weapon_csbase" )

CSParseWeaponInfo( SWEP , [[WeaponData
{
	"MaxPlayerSpeed"		"250"
	"WeaponType"			"Knife"
	"WeaponPrice"			"0"
	"WeaponArmorRatio"		"1.7"
	"CrosshairMinDistance"		"7"
	"CrosshairDeltaDistance"	"3"
	"Team"				"ANY"
	"BuiltRightHanded"		"1"
	"PlayerAnimationExtension"	"knife"
	"MuzzleFlashScale"		"0"
	"MuzzleFlashStyle"		"CS_MUZZLEFLASH_NONE"
	"CanEquipWithShield"		"1"
	
	
	// Weapon characteristics:
	"Penetration"			"1"
	"Damage"			"50"
	"Range"				"4096"
	"RangeModifier"			"0.99"
	"Bullets"			"1"
	
	// Weapon data is loaded by both the Game and Client DLLs.
	"printname"			"Combat Knife"
	"viewmodel"			"models/weapons/v_knife_t.mdl"
	"playermodel"			"models/weapons/w_knife_t.mdl"
	"shieldviewmodel"		"models/weapons/v_shield_knife_r.mdl"
	"anim_prefix"			"anim"
	"bucket"			"2"
	"bucket_position"		"1"

	"clip_size"			"-1"
	"default_clip"			"1"
	"primary_ammo"			"None"
	"secondary_ammo"		"None"

	"weight"			"0"
	"item_flags"			"0"

	// Sounds for the weapon. There is a max of 16 sounds per category (i.e. max 16 "single_shot" sounds)
	SoundData
	{
		"reload"			"Default.Reload"
		"empty"				"Default.ClipEmpty_Rifle"
		"single_shot"		"Weapon_DEagle.Single"
	}

	// Weapon Sprite data is loaded by the Client DLL.
	TextureData
	{
		"weapon"
		{
				"font"		"CSweaponsSmall"
				"character"	"J"
		}
		"weapon_s"
		{	
				"font"		"CSweapons"
				"character"	"J"
		}
		"ammo"
		{
				"file"		"sprites/a_icons1"
				"x"			"55"
				"y"			"60"
				"width"		"73"
				"height"	"15"
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
			Mins	"-2 -16 -15"
			Maxs	"18 11 5"
		}
		World
		{
			Mins	"-2 -5 -5"
			Maxs	"10 4 11"
		}
	}
}]])

SWEP.Spawnable = true

SWEP.HeadHullMins = Vector( -16, -16, -18 )
SWEP.HeadHullMaxs = Vector( 16, 16, 18 )

local function FindHullIntersection( vecSrc, tr, mins, maxs, pEntity )
	local	i, j, k
	local	distance
	local 	minmaxs = {mins, maxs}
	local	tmpTrace
	local	vecHullEnd = tr.HitPos
	
	distance = 1e6

	vecHullEnd = vecSrc + ( ( vecHullEnd - vecSrc ) * 2 )
	tmpTrace = util.TraceLine { start = vecSrc, endpos = vecHullEnd, mask = MASK_SOLID, filter = pEntity }
	
	if tmpTrace.Fraction < 1 then
		tr = tmpTrace
		return
	end

	for i = 0 , 1 do
		for j = 0 , 1 do
			for k = 0 , 1 do
				local	vecEnd = Vector()
				vecEnd.x = vecHullEnd.x + minmaxs[i].x
				vecEnd.y = vecHullEnd.y + minmaxs[j].y
				vecEnd.z = vecHullEnd.z + minmaxs[k].z

				tmpTrace = util.TraceLine { start = vecSrc, endpos = vecEnd, mask = MASK_SOLID, filter = pEntity }
				if tmpTrace.Fraction < 1 then
					local thisDistance = ( tmpTrace.HitPos - vecSrc ):Length()
					if thisDistance < distance then
						tr = tmpTrace
						distance = thisDistance
					end
				end
			end
		end
	end
	
	return tr
end


function SWEP:Initialize()
	self:SetClip1( -1 )
	BaseClass.Initialize( self )
	self:SetHoldType( "knife" )
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables( self )
	self:NetworkVar( "Float" , 5 , "SmackTime" )
	self:NetworkVar( "Entity" , 0 , "HitEntity" )
	self:NetworkVar( "Bool" , 4 , "IsStab" )
end

function SWEP:Deploy()
	self:EmitSound( "Weapon_Knife.Deploy" )
	self:SetSmackTime( -1 )
	return BaseClass.Deploy( self )
end

function SWEP:Holster()
	self:SetNextPrimaryAttack( CurTime() + 5 )
	return true
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryAttack() > CurTime() then return end
	
	self:SwingOrStab( false )
end

function SWEP:SecondaryAttack()
	if self:GetNextPrimaryAttack() > CurTime() then return end
	
	self:SwingOrStab( true )
end

function SWEP:Think()
	
	if self:GetSmackTime() > -1 and CurTime() > self:GetSmackTime() then
		self:Smack()
		self:SetSmackTime( -1 )
	end
	
	BaseClass.Think( self )
end

function SWEP:SwingOrStab( bStab )
	self:GetOwner():LagCompensation( true )
	local pPlayer = self:GetOwner()
	
	local fRange = bStab and 32 or 48 -- knife range
	
	local vForward 	= pPlayer:GetAimVector()
	local vecSrc	= pPlayer:EyePos()
	local vecEnd	= vecSrc + vForward * fRange

	local tr = util.TraceLine { start = vecSrc, endpos = vecEnd, mask = MASK_SOLID, filter = pPlayer }

	if tr.Fraction >= 1 then
		tr = util.TraceHull { start = vecSrc, endpos = vecEnd, mins = head_hull_mins, maxs = head_hull_maxs, MASK_SOLID, filter = pPlayer }
		if tr.Fraction < 1 then
			-- Calculate the point of intersection of the line (or hull) and the object we hit
			-- This is and approximation of the "best" intersection
			local pHit = tr.Entity
			
			if not IsValid( pHit ) then
				tr = FindHullIntersection( vecSrc, tr, pPlayer:OBBMins(), pPlayer:OBBMaxs() , pPlayer )
			end
			
			vecEnd = tr.HitPos	-- This is the point on the actual surface (the hull could have hit space)
		end
	end

	local bDidHit = tr.Fraction < 1 and not tr.HitSky

	local bFirstSwing = ( self:GetNextPrimaryAttack() + 0.4 ) < CurTime()

	local fPrimDelay, fSecDelay

	if bStab then
		fPrimDelay = bDidHit and 1.1 or 1
		
	else -- swing
		fPrimDelay = bDidHit and 0.5 or 0.4
	end
	
	fSecDelay = fPrimDelay
	
	self:SendWeaponAnim( bDidHit and ACT_VM_PRIMARYATTACK or ACT_VM_MISSCENTER )
	pPlayer:DoAttackEvent()

	self:SetNextPrimaryAttack( CurTime() + fPrimDelay )
	self:SetNextSecondaryAttack( CurTime() + fSecDelay )
	self:SetNextIdle( CurTime() + 2 )
	
	if not bDidHit then
		-- play wiff or swish sound
		self:EmitSound( "Weapon_Knife.Slash" )
	else	
	-- play thwack, smack, or dong sound
		local pEntity = tr.Entity
		
		local flDamage = 42

		if bStab then
			flDamage = 65

			if IsValid( pEntity ) and ( pEntity:IsPlayer() or pEntity:IsNPC() ) then
				local vTragetForward = pEntity:GetAngles():Forward()
				--Jvs TODO: finish converting
				local vecLOS = pEntity:GetPos() - pPlayer:GetPos()
				vecLOS.z = 0
				
				vecLOS:Normalize()
				
				local vTragetForward2d = vTragetForward
				vTragetForward2d.z = 0
				
				local flDot = vecLOS:Dot( vTragetForward2d )

				--Triple the damage if we are stabbing them in the back.
				if flDot > 0.80 then
					 flDamage = flDamage * 3
				end
			end
		else
			if bFirstSwing then
				-- first swing does full damage
				flDamage = 20
			else
				-- subsequent swings do less	
				flDamage = 15
			end
		end

		local info = DamageInfo()
		info:SetAttacker( pPlayer )
		info:SetInflictor( self )
		info:SetDamage( flDamage )
		info:SetDamageType( bit.bor( DMG_BULLET , DMG_NEVERGIB ) )
		pEntity:DispatchTraceAttack( info, tr, vForward )
	end

	--if bDidHit then
		-- delay the decal a bit
		self:SetHitEntity( tr.Entity )
		self:SetIsStab( bStab )
		self:SetSmackTime( CurTime() + ( bStab and 0.2 or 0.1 ) )
	--end
	
	self:GetOwner():LagCompensation( false )
end

function SWEP:SendWeaponAnimFix( seqstr , slot , rate )
	local vm = self:GetOwner():GetViewModel( slot or 0 )
	if IsValid( vm ) then
		local seq = vm:LookupSequence( seqstr )
		vm:SendViewModelMatchingSequence( seq )
		vm:SetPlaybackRate( rate or 1 )
	end
end

function SWEP:Smack()
	if self:GetHitEntity() == NULL then return end
	
	if self:GetHitEntity():IsPlayer() or self:GetHitEntity():IsNPC() then
		self:EmitSound( self:GetIsStab() and "Weapon_Knife.Stab" or "Weapon_Knife.Hit" )
	else
		self:EmitSound( "Weapon_Knife.HitWall" )
	end
	
	
	self:SetHitEntity( NULL )
	self:SetIsStab( false )
	
	--[[
	CEffectData data
	data.m_vOrigin = m_trHit.endpos
	data.m_vStart = m_trHit.startpos
	data.m_nSurfaceProp = m_trHit.surface.surfaceProps
	data.m_nDamageType = DMG_SLASH
	data.m_nHitBox = m_trHit.hitbox
#ifdef CLIENT_DLL
	data.m_hEntity = m_trHit.m_pEnt->GetRefEHandle()
#else
	data.m_nEntIndex = m_trHit.m_pEnt->entindex()
#endif

	CPASFilter filter( data.m_vOrigin )
	
#ifndef CLIENT_DLL
	filter.RemoveRecipient( GetPlayerOwner() )
#endif

	data.m_vAngles = GetPlayerOwner()->GetAbsAngles()
	data.m_fFlags = 0x1	--IMPACT_NODECAL
	te->DispatchEffect( filter, 0.0, data.m_vOrigin, "KnifeSlash", data )
	]]

end

function SWEP:Idle()
	if self:GetNextIdle() > CurTime() then return end
	
	self:SetNextIdle( CurTime() + 20 )
	self:SendWeaponAnim( ACT_VM_IDLE )
end

