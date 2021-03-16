LinkLuaModifier("modifier_nian_6", "abilities/boss/nian_6.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if nian_6 == nil then
	nian_6 = class({})
end
function nian_6:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_START)
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	return true
end
function nian_6:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
	hCaster:FadeGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_START)
end
function nian_6:OnSpellStart()
	local hCaster = self:GetCaster()
	self.iParticleID = ParticleManager:CreateParticle("particles/units/boss/nian/nian_6.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(self.iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_mouthbase", hCaster:GetAbsOrigin(), false)
	-- hCaster:StartGesture(ACT_DOTA_TELEPORT)
	hCaster:EmitSound("Hero_Phoenix.SunRay.Cast")
	hCaster:EmitSound("Hero_Phoenix.SunRay.Loop")
end
function nian_6:OnChannelThink(flInterval)
	local hCaster = self:GetCaster()
	local vStart = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_mouthbase"))
	local vEnd = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_mouthend"))
	local vCenter = GetGroundPosition(LerpVectors(vStart, vEnd, 0.5), hCaster)
	local radius = self:GetSpecialValueFor("radius")
	-- DebugDrawCircle(vCenter, Vector(0, 255, 0), 255, radius, false, 1)
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vCenter, radius, self)
	for _, hUnit in ipairs(tTargets) do
		if not hUnit:HasModifier("modifier_nian_6") then
			hUnit:AddNewModifier(hCaster, self, "modifier_nian_6", { duration = 1 })
		end
	end
end
function nian_6:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	ParticleManager:DestroyParticle(self.iParticleID, false)
	ParticleManager:ReleaseParticleIndex(self.iParticleID)
	hCaster:FadeGesture(ACT_DOTA_TELEPORT)
	hCaster:StopSound("Hero_Phoenix.SunRay.Loop")
end
---------------------------------------------------------------------
--Modifiers
if modifier_nian_6 == nil then
	modifier_nian_6 = class({})
end
function modifier_nian_6:IsHidden()
	return true
end
function modifier_nian_6:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_nian_6:OnIntervalThink()
	local hParent = self:GetParent()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility())
end