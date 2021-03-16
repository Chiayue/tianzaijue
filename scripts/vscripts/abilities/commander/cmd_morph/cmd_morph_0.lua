LinkLuaModifier("modifier_cmd_morph_0", "abilities/commander/cmd_morph/cmd_morph_0.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_morph_0 == nil then
	cmd_morph_0 = class({})
end
function cmd_morph_0:GetIntrinsicModifierName()
	return "modifier_cmd_morph_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_morph_0 == nil then
	modifier_cmd_morph_0 = class({}, nil, eom_modifier)
end
function modifier_cmd_morph_0:OnCreated(params)
	self.convert_speed = self:GetAbilitySpecialValueFor('convert_speed')
	self.attack_bonus = self:GetAbilitySpecialValueFor('attack_bonus')
	self.health_reduce = self:GetAbilitySpecialValueFor('health_reduce')
	self.health_limit_pct = self:GetAbilitySpecialValueFor('health_limit_pct')
	self.health_limit = self.health_limit_pct * self:GetParent():GetMaxHealth() * 0.01
	self:SetStackCount(0)
	if IsServer() then
	end
end
function modifier_cmd_morph_0:OnRefresh(params)
	self.convert_speed = self:GetAbilitySpecialValueFor('convert_speed')
	self.attack_bonus = self:GetAbilitySpecialValueFor('attack_bonus')
	self.health_reduce = self:GetAbilitySpecialValueFor('health_reduce')
	self.health_limit_pct = self:GetAbilitySpecialValueFor('health_limit_pct')
	self.health_limit = self.health_limit_pct * self:GetParent():GetMaxHealth() * 0.01
	if IsServer() then
	end
end
function modifier_cmd_morph_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_morph_0:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE
	}
end
function modifier_cmd_morph_0:OnInBattle()
	local hParent = self:GetParent()
	if IsValid(hParent) then
		self:StartIntervalThink(self.convert_speed)
	end
end
function modifier_cmd_morph_0:OnBattleEnd()
	local hParent = self:GetParent()
	if IsValid(hParent) then
		self:StartIntervalThink(-1)
		self:SetStackCount(0)
	end
end
function modifier_cmd_morph_0:OnIntervalThink()
	local hParent = self:GetParent()
	if IsValid(hParent) then
		if self.health_limit < hParent:GetHealth() then
			local fHealth = hParent:GetHealth() - self.health_reduce
			hParent:ModifyHealth(fHealth, nil, false, 0)
			hParent:SetMaxHealth(fHealth)
			self:IncrementStackCount()
		end
	end
end
function modifier_cmd_morph_0:GetPhysicalAttackBonusUnique()
	if self:GetStackCount() ~= 0 then
		return self:GetStackCount() * self.attack_bonus
	else
		return 0
	end
end