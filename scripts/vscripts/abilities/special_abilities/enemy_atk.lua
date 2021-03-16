LinkLuaModifier("modifier_enemy_atk", "abilities/special_abilities/enemy_atk.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_atk_buff", "abilities/special_abilities/enemy_atk.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_atk == nil then
	enemy_atk = class({})
end
function enemy_atk:GetIntrinsicModifierName()
	return "modifier_enemy_atk"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_atk == nil then
	modifier_enemy_atk = class({}, nil, eom_modifier)
end
function modifier_enemy_atk:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_enemy_atk:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_enemy_atk:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_atk:EDeclareFunctions()
	return {
		--MODIFIER_EVENT_ON_TAKEDAMAGE
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_enemy_atk:OnAttackLanded(params)
	if RollPercentage(self.chance) then
		local hParent = params.attacker
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_enemy_atk_buff", { duration = self:GetDuration() })
	end
end
---------------------------------------------------------------------
if modifier_enemy_atk_buff == nil then
	modifier_enemy_atk_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_atk_buff:OnCreated(params)
	self.attack = self:GetAbilitySpecialValueFor("attack")
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_enemy_atk_buff:OnRefresh(params)
	self.attack = self:GetAbilitySpecialValueFor("attack")
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
		local hStackCount = self:GetStackCount()
		if hStackCount < self.count then
			self:IncrementStackCount()
		end
	end
end
function modifier_enemy_atk_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_enemy_atk_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_enemy_atk_buff:OnTooltip()
	return self.attack * self:GetStackCount()
end
function modifier_enemy_atk_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_enemy_atk_buff:GetMagicalAttackBonusPercentage()
	return self.attack * self:GetStackCount()
end
function modifier_enemy_atk_buff:GetPhysicalAttackBonusPercentage()
	return self.attack * self:GetStackCount()
end