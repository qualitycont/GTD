include("shared.lua")

local vOffset = Vector(0, 0, 60) -- constants
local tDefaultTrace = {start = nil, endpos = nil, mask = MASK_OPAQUE_AND_NPCS, filter = nil} -- constants
tDefaultTrace.output = tDefaultTrace -- Reuse the same table for the result for efficiency
local nMaxTraceLength = math.sqrt(3) * 2 * 16384 -- Adjust this value for the max length of the beam
local colBeam = Color(255, 0, 0)


function ENT:Draw()

	self:DrawModel()

	local vPos = self:GetPos()
	vPos:Add(vOffset)
	tDefaultTrace.start = vPos

	local vForward = self:GetForward()
	vForward:Mul(nMaxTraceLength)
	vForward:Add(vPos)
	tDefaultTrace.endpos = vForward

	tDefaultTrace.filter = self

	local tTrace = util.TraceLine(tDefaultTrace)
	render.DrawLine(vPos, tTrace.HitPos, colBeam, true)
end
