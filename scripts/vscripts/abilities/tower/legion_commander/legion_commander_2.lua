LinkLuaModifier("modifier_legion_commander_2", "abilities/tower/legion_commander/legion_commander_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if legion_commander_2 == nil then
	legion_commander_2 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET }, nil, ability_base_ai)
end
function legion_commander_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetDuration()
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		if hUnit:IsAlive() and not hUnit:IsRangedAttacker() then
			hUnit:AddNewModifier(hCaster, self, "modifier_legion_commander_2", { duration = duration })
		end
	end, UnitType.Building)
	hCaster:EmitSound("Hero_LegionCommander.PressTheAttack")
end
---------------------------------------------------------------------
--Modifiers
if modifier_legion_commander_2 == nil then
	modifier_legion_commander_2 = class({}, nil, eom_modifier)
end
function modifier_legion_commander_2:OnCreated(params)
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_legion_commander_2:OnRefresh(params)
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_legion_commander_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_legion_commander_2:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		[EMDF_ATTACKT_SPEED_BONUS] = self.bonus_attackspeed,
		[EMDF_HEALTH_REGEN_BONUS] = self.bonus_health_regen
	}
end
function modifier_legion_commander_2:OnDeath(params)
	local hParent = self:GetParent()
	if params.attacker == hParent then
		self:GetAbility():Save("iStackCount", self:GetAbility():Load("iStackCount") + 1)
	end
end
function modifier_legion_commander_2:GetStatusHealthBonus()
	return self.bonus_health * self:GetStackCount()
end
function modifier_legion_commander_2:GetPhysicalAttackBonus()
	return self.bonus_attack * self:GetStackCount()
end
function modifier_legion_commander_2:GetAttackSpeedBonus()
	return self.bonus_attackspeed
end
function modifier_legion_commander_2:GetHealthRegenBonus()
	return self.bonus_health_regen
end
function modifier_legion_commander_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_legion_commander_2:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 2
	if 0 == self._iTooltip then
		return self:GetStackCount() * self.bonus_attack
	elseif 1 == self._iTooltip then
		return self:GetStackCount() * self.bonus_health
	end
end