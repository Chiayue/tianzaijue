LinkLuaModifier("modifier_vengeful_spirit_2_thinker", "abilities/tower/vengeful_spirit/vengeful_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_spirit_2_debuff", "abilities/tower/vengeful_spirit/vengeful_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_spirit_2_debuff_slow", "abilities/tower/vengeful_spirit/vengeful_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if vengeful_spirit_2 == nil then
	vengeful_spirit_2 = class({}, nil, ability_base_ai)
end
function vengeful_spirit_2:OnSpellStart()
	local vPos = self:GetCursorPosition()
	local hCaster = self:GetCaster()
	local vOrigin = hCaster:GetAbsOrigin()

	local duration = self:GetSpecialValueFor("duration")
	local length = self:GetSpecialValueFor("length")

	local vDir = CalculateDirection(vPos, vOrigin)
	vDir = CalculateVerticalVector(vDir)

	local vStartPos = vPos + vDir * length / 2
	local vEndPos = vPos - vDir * length / 2

	CreateModifierThinker(hCaster, self, "modifier_vengeful_spirit_2_thinker", { x = vEndPos.x, y = vEndPos.y, z = vEndPos.z, duration = duration }, vStartPos, hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_vengeful_spirit_2_thinker == nil then
	modifier_vengeful_spirit_2_thinker = class({}, nil, BaseModifier)
end
function modifier_vengeful_spirit_2_thinker:OnCreated(params)
	if IsServer() then
		self.vStart = self:GetParent():GetAbsOrigin()
		self.vEnd = Vector(params.x, params.y, params.z)
		self.width = self:GetAbilitySpecialValueFor("width")
		self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
		self:StartIntervalThink(0.1)

		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(iParticle, 0, self.vStart)
		ParticleManager:SetParticleControl(iParticle, 1, self.vEnd)
		self:AddParticle(iParticle, false, false, 0, false, false)

		if IsInToolsMode() then
			local vDirection = CalculateDirection(self.vEnd, self.vStart)
			local v = Rotation2D(vDirection, math.rad(90))
			local tPolygon = {
				(self.vStart - vDirection * self.width) + v * self.width,
				self.vEnd + v * self.width,
				self.vEnd - v * self.width,
				(self.vStart - vDirection * self.width) - v * self.width,
			}
			DebugDrawLine(tPolygon[1], tPolygon[2], 255, 255, 255, true, params.duration)
			DebugDrawLine(tPolygon[2], tPolygon[3], 255, 255, 255, true, params.duration)
			DebugDrawLine(tPolygon[3], tPolygon[4], 255, 255, 255, true, params.duration)
			DebugDrawLine(tPolygon[4], tPolygon[1], 255, 255, 255, true, params.duration)
		end
	end
end
function modifier_vengeful_spirit_2_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end

	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInLine(hParent:GetTeamNumber(), self.vStart, self.vEnd, nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
	for _, hTarget in pairs(tTargets) do
		if IsValid(hTarget) then
			hTarget:AddNewModifier(hParent, hAbility, "modifier_vengeful_spirit_2_debuff", { duration = self.slow_duration })
			local fDuration = GetStatusDebuffDuration(self.slow_duration, hTarget, hParent)
			if 0 < fDuration then
				hTarget:AddNewModifier(hParent, hAbility, "modifier_vengeful_spirit_2_debuff_slow", { duration = fDuration })
			end
		end
	end
end

------------------------------------------------------------------------------
if modifier_vengeful_spirit_2_debuff == nil then
	modifier_vengeful_spirit_2_debuff = class({}, nil, eom_modifier)
end
function modifier_vengeful_spirit_2_debuff:IsDebuff()
	return true
end
function modifier_vengeful_spirit_2_debuff:OnCreated(params)
	self.physical_armor_reduce_pct = self:GetAbilitySpecialValueFor("physical_armor_reduce_pct")
end
function modifier_vengeful_spirit_2_debuff:OnRefresh(params)
	self.physical_armor_reduce_pct = self:GetAbilitySpecialValueFor("physical_armor_reduce_pct")
end
function modifier_vengeful_spirit_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_vengeful_spirit_2_debuff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = -self.physical_armor_reduce_pct
	}
end
function modifier_vengeful_spirit_2_debuff:GetPhysicalArmorBonusPercentage()
	return -self.physical_armor_reduce_pct
end
function modifier_vengeful_spirit_2_debuff:OnTooltip()
	return -self.physical_armor_reduce_pct
end
------------------------------------------------------------------------------
if modifier_vengeful_spirit_2_debuff_slow == nil then
	modifier_vengeful_spirit_2_debuff_slow = class({}, nil, eom_modifier)
end
function modifier_vengeful_spirit_2_debuff_slow:IsDebuff()
	return true
end
function modifier_vengeful_spirit_2_debuff_slow:OnCreated(params)
	self.slow_pct = self:GetAbilitySpecialValueFor("slow_pct")
end
function modifier_vengeful_spirit_2_debuff_slow:OnRefresh(params)
	self.slow_pct = self:GetAbilitySpecialValueFor("slow_pct")
end
function modifier_vengeful_spirit_2_debuff_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_vengeful_spirit_2_debuff_slow:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.slow_pct
	}
end
function modifier_vengeful_spirit_2_debuff_slow:OnTooltip()
	return -self.slow_pct
end
function modifier_vengeful_spirit_2_debuff_slow:GetMoveSpeedBonusPercentage()
	return -self.slow_pct
end