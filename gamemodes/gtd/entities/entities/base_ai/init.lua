include("shared.lua")

local modes = {
	IDLE = 1,
	CORE = 2,
	PLAYER = 3,
	TOWER = 4
}

ENT.m_fMaxYawSpeed = 200

-- list.Set( "NPC", "combine1", {
-- 	Name = "combine",
-- 	Class = "combine1",
-- 	Category = "NextBot"
-- })

function ENT:Initialize()
	self.followers = {}
	self.difficulty = 1 -------------------------------------- hi quality change this to add more followers thanks bye
	self:TypeSpecific()
	self.istouched = false  
	self.target = nil 
	self:SetTargetCore()
end

function ENT:RunAnim(enum)
	if self:GetActivity() == enum then return end
	self:StartActivity(enum)
end

function ENT:RemoveDeadFollowers()
	if self.type ~= "master" then return end 
	if table.Count(self.followers) == 0 then return end 
	for k,v in pairs(self.followers) do 
		if not IsValid(v) then 
			table.remove(self.followers,k)
		end
	end
end 

function ENT:SpawnFollowers()
	if self.type ~= "master" then return end 
	local n = 50
	for i=1,self.difficulty do
		local follower = ents.Create("base_ai")
		follower:SetPos(self:GetPos()+Vector(n,n,0))
		follower.type = "follower"
		follower.command = ""
		follower:Spawn()
		follower:SetAngles(self:GetAngles())
		follower.master = self
		n = n + 50
		table.insert(self.followers,follower)
	end
end

-- tell the followers what to do 
function ENT:UpdateFollowers(updateMaster)
	if self.type ~= "master" then return end 
	self:RemoveDeadFollowers()
	for k,v in pairs(self.followers) do
		v.mode = self.mode 
		v.target = self.target
		if updateMaster then 
			v.master = self 
		end
	end
end

function ENT:FollowerCommand(command)
	if command == nil or self.type ~= "master" then return end
	self:RemoveDeadFollowers()
	for k,v in pairs(self.followers) do
		v.command = command
	end
end

function ENT:UpdateModels()
	-- two different models for debugging
	if self.type == "master" then 
		self:SetModel("models/Police.mdl")
	else 
		self:SetModel("models/Police.mdl")
	end
	self:PhysWake()
end

function ENT:TypeSpecific()
	self:SetHealth(100)
	self:UpdateModels()
	self.range = 150
	self:SpawnFollowers()
	self.RUN = ACT_RUN
	self.IDLE = ACT_COWER
	self.loco:SetDesiredSpeed(200)
	self.weapon = "weapon_ar2"
	self:Loadout()
end

-- no core
function ENT:Idle()
	self:RunAnim(self.IDLE)
end

-- moving to core
function ENT:Core() 
	if self.target == nil then return end
	self.loco:SetDesiredSpeed(200)
	self:RunAnim(self.RUN)
	self:MoveToPosition(self.target:GetPos())
end

-- targeting player
function ENT:Ply()
	self:RunAnim(self.RUN)
	self.loco:SetDesiredSpeed(100)
	self:Attack()
	if self.command == "follow" then 
		self:MoveToPosition(self.target:GetPos(),{maxage = 10})
	else 
		self:MoveToPosition(self.target:GetPos())
	end
end

-- attacking tower
function ENT:Tower() 

end

function ENT:Attack() 
	if not self:TargetValidate() then return end
	local bullet = {} 
		bullet.Num = 1
		bullet.Src = self.weapon:GetPos()
		bullet.Dir = self.target:GetPos() - bullet.Src
		bullet.Tracer = 1
		bullet.TracerName = "MuzzleFlash" 
		bullet.Damage = math.random(20,24)
	self:FireBullets( bullet )
end

function ENT:Loadout()
	self.weapon = ents.Create(self.weapon)
	local handpos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos 
	self.weapon:SetOwner(self)
	self.weapon:SetPos(handpos)
	self.weapon:Spawn()
	self.weapon:SetSolid(SOLID_NONE)
	self.weapon:SetParent(self)
	self.weapon.CanPickUp = false
	self.weapon:Fire("setparentattachment", "anim_attachment_RH")
	self.weapon:AddEffects(EF_BONEMERGE) 
end

function ENT:RunBehaviour()
	while true do 
		if self.mode == "idle" then 
			self:Idle()
		elseif self.mode == "core" then 
			self:Core()
		elseif self.mode == "player" then 
			self:Ply()
		elseif self.mode == "tower" then 
			self:Tower()
		end

		coroutine.yield()
	end
end

function ENT:TargetValidate()
	if self.type == "follower" && self.command ~= "follow" then return false end 
	-- if there's no target, go for the core 
	if self.target == nil then 	self.loco:SetDesiredSpeed(200) self:SetTargetCore() return false end
	-- checks if target is alive, in range and in LOS. 
	if self.mode == "player" && not self.target:Alive() then self:FindTarget() return false end
	if not self.target:IsLineOfSightClear(self:GetPos()) or self:GetRangeTo(self.target:GetPos()) > self.range then
		if self.command == "follow" && self.typer == "follower" then 
			self.master.mode = self.mode 
			self.master.target = self.target
		elseif self.command == "follow" && self.type == "master" then 
			self.loco:SetDesiredSpeed(200)
			self:SetTargetCore()
		end
		self.command = ""
		return false 
	end 
	return true
end

-- gets a random core for a target 
function ENT:SetTargetCore()
	if self.type == "follower" then return end 
	local c = ents.FindByClass("sent_ball")
	if table.Count(c) == 0 then self.mode = "idle" self:UpdateFollowers() return end
	local n = math.random(1,table.Count(c))
	self.target = c[n]
	self.mode = "core"
	self:UpdateFollowers()
end

-- find the nearest player, if there's no players, target the core 
function ENT:FindTarget()
	if self.type ~= "master" then 
		self.master.mode = self.mode 
		self.master.target = self.target
		self.command = ""
		return 
	end 

	local nearbyents = ents.FindInSphere(self:GetPos(), self.range)

	if nearbyents == nil then 
		self:SetTargetCore() 
		return 
	end

	for k,v in pairs(nearbyents) do 
		if v:IsPlayer() && v:Alive() && self:IsLineOfSightClear(v:GetPos()) then 
			self.target = v
			self.mode = "player"
			self:UpdateFollowers()
			return
		end
	end
	self:SetTargetCore()
end

function ENT:OnContact(ent)
	if IsValid(ent) && ent:IsPlayer() && ent:Alive() then 
		self.istouched = true
		self.target = ent
		self.command = "follow"
	end
end

function ENT:ElectNewMaster()
	if self.type ~= "master" then return end 
	-- sets a new master 
	self:RemoveDeadFollowers()
	if table.Count(self.followers) == 0 then return end 
	local n = math.random(1,table.Count(self.followers))
	if self.followers[n] == nil && not IsValid(self.followers[n]) then return end 
	self.followers[n].type = "master" 
	self.followers.command = nil
	self.followers[n]:UpdateModels()
	self.followers[n].followers = self.followers
	self.followers[n]:UpdateFollowers(true)
end

function ENT:OnInjured(info)
	local a = info:GetAttacker()
	local d = info:GetDamage()

	self:SetHealth(self:Health()-d)

	if self.type == "follower" then return end 
	if self:Health() > 0 && a:IsPlayer() then 
		self:FindTarget(a)
	else 
		self:ElectNewMaster()
	end
end

function ENT:HandleStuck()
	if self.istouched then return end
	self:SetSolidMask(MASK_BLOCKLOS)
	if self.type ~= "master" then return end 
	self:FollowerCommand("newpath")
end

function ENT:OnUnStuck()
	self:SetSolidMask(MASK_NPCSOLID)
end

-- edited from nextbot base function
function ENT:MoveToPosition(options)

    local options = options or {}

    local path = Path( "Follow" )

    path:SetMinLookAheadDistance(options.lookahead or 325)
 
    path:SetGoalTolerance(options.tolerance or 20)

    path:Compute(self, self.target:GetPos())     
 
    if ( !path:IsValid() ) then return "failed" end
 
    while path:IsValid() and self.target ~= nil do
        if self.mode ~= "core" && path:GetAge() > 0.1 then
        	self:Attack() 
            path:Compute(self, self.target:GetPos())
        end

        if self.istouched && self:TargetValidate() then
        	self.istouched = false
        	self.mode = "player"
        	if self.type == "master" then 
        		self:UpdateFollowers() 
        	end
        	return "new target"
        end

        path:Update( self )                             

        if (options.draw) then path:Draw() end

        if self.mode ~= "core" && not self:TargetValidate() or self.mode ~= "core" && not self:TargetValidate() && self.command == "follow" then
        	self:FindTarget()
        	return "failed"
        end 
        if self.loco:IsStuck() then
            self:HandleStuck()
            return "stuck"
        end
        coroutine.yield()
    end
    return "ok"
end

hook.Add("PlayerCanPickupWeapon","AIWeaponPickupPrevention",function(ply,weapon)
	if weapon.CanPickUp == false then 
		return false
	end
end)