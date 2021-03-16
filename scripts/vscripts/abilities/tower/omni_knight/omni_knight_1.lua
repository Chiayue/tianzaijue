LinkLuaModifier("modifier_omni_knight_1_buff", "abilities/tower/omni_knight/omni_knight_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if omni_knight_1 == nil then
	local funcSortFunction = function(a, b) return a:GetHealthPercent() < b:GetHealthPercent() end
	omni_knight_1 = class({funcSortFunction = funcSortFunction}, nil, ability_base_ai)
end
function omni_knight_1:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hCaster == hTarget then
		hCaster:AddActivityModifier("self")
	else
		hCaster:RemoveActivityModifier("self")
	end
	return true
end
function omni_knight_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local heal = self:GetSpecialValueFor("heal_pct") * hTarget:GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
	local radius = self:GetSpecialValueFor("radius")

	local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", hCaster), PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hTarget:Heal(heal, self)
	hTarget:AddNewModifier(hCaster, self, "modifier_omni_knight_1_buff", nil)

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
	hCaster:DealDamage(tTargets, self, heal)

	if IsValid(hTarget) then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack2", hCaster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Omniknight.Purification", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_omni_knight_1_buff == nil then
	modifier_omni_knight_1_buff = class({}, nil, eom_modifier)
end
function modifier_omni_knight_1_buff:OnCreated(params)
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		end
	end
end
function modifier_omni_knight_1_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_omni_knight_1_buff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_omni_knight_1_buff:GetStatusHealthBonus()
	return self.bonus_health * self:GetStackCount()
end
function modifier_omni_knight_1_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_omni_knight_1_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_omni_knight_1_buff:OnTooltip()
	return self.bonus_health * self:GetStackCount()
end