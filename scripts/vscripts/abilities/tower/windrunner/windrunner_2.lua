LinkLuaModifier("modifier_windrunner_2", "abilities/tower/windrunner/windrunner_2.lua", LUA_MODIFIER_MOTION_NONE)

if windrunner_2 == nil then
	---@type CDOTABaseAbility
	windrunner_2 = class({})
end
function windrunner_2:Precache(context)
	PrecacheResource("particle", "particles/items3_fx/fish_bones_active.vpcf", context)
	PrecacheResource("particle", "particles/items3_fx/mango_active.vpcf", context)
end
function windrunner_2:OnSpellStart(vStart, vDir)
	local hCaster = self:GetCaster()
	local hThinker = CreateModifierThinker(hCaster, self, "modifier_windrunner_2", {
		duration = self:GetDuration(),
		vDir_x = vDir.x,
		vDir_y = vDir.y,
		vDir_z = vDir.z,
	}, vStart, hCaster:GetTeamNumber(), false)
	return hThinker:entindex()
end
function windrunner_2:OnHit(hTarget)
	local hCaster = self:GetCaster()

	if hTarget:GetTeamNumber() == hCaster:GetTeamNumber() then
		self.hp_regain_per = self:GetSpecialValueFor('hp_regain_per')
		hTarget:Heal(self.hp_regain_per * 0.01 * hTarget:GetMaxHealth(), self)
		local iPtclID = ParticleManager:CreateParticle("particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:ReleaseParticleIndex(iPtclID)
	end

	if hTarget ~= hCaster then
		self.mp_regain = self:GetSpecialValueFor('mp_regain')
		hCaster:GiveMana(self.mp_regain)
		local iPtclID = ParticleManager:CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:ReleaseParticleIndex(iPtclID)
	end
end


---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_2 == nil then
	modifier_windrunner_2 = class({}, nil, BaseModifier)
end
function modifier_windrunner_2:IsHidden()
	return true
end
function modifier_windrunner_2:OnCreated(params)
	if IsServer() then
		-- self:StartIntervalThink(0.1)
		self.vEnd = self:GetParent():GetAbsOrigin()
		self.tTargets = {}
		self.hp_regain_per = self:GetAbilitySpecialValueFor('hp_regain_per')
		self.width = self:GetAbilitySpecialValueFor('width')
	end
end
-- function modifier_windrunner_2:OnIntervalThink()
-- 	local hParent = self:GetParent()
-- 	local tTargets = FindUnitsInLine(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), self.vEnd, nil, self.width, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
-- 	for _, hTarget in pairs(tTargets) do
-- 		if not KEY(self.tTargets, hTarget:entindex()) then
-- 			table.insert(self.tTargets, hTarget:entindex())
-- 			hTarget:Heal(self.hp_regain_per * 0.01 * hTarget:GetMaxHealth(), self:GetAbility())
-- 		end
-- 	end
-- end
function modifier_windrunner_2:SetEndPos(vEnd)
	self.vEnd = vEnd

	if self.iParticleID then
		ParticleManager:DestroyParticle(self.iParticleID, true)
	end
	self.iParticleID = ParticleManager:CreateParticle('particles/units/heroes/windrunner/windrunner_2.vpcf', PATTACH_CUSTOMORIGIN, self:GetParent())
	local iParticleID = self.iParticleID
	ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, self.vEnd)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(self:GetDuration(), 0, 0))
	self:AddParticle(self.iParticleID, false, false, -1, false, false)
end