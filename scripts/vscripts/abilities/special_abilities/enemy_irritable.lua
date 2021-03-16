LinkLuaModifier("modifier_enemy_irritable", "abilities/special_abilities/enemy_irritable.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_irritable == nil then
	enemy_irritable = class({})
end
function enemy_irritable:GetIntrinsicModifierName()
	return "modifier_enemy_irritable"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_irritable == nil then
	modifier_enemy_irritable = class({}, nil, eom_modifier)
end
function modifier_enemy_irritable:OnCreated(params)
	self.attackspeed_perstack = self:GetAbilitySpecialValueFor("attackspeed_perstack")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
	end
end
function modifier_enemy_irritable:OnRefresh(params)
	self.attackspeed_perstack = self:GetAbilitySpecialValueFor("attackspeed_perstack")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
	end
end
function modifier_enemy_irritable:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_irritable:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_enemy_irritable:OnTooltip()
	return self.attackspeed_perstack * self:GetStackCount()
end

function modifier_enemy_irritable:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if IsServer() then
		local hStackCount = self:GetStackCount()
		if hStackCount < self.count then
			self:IncrementStackCount()
		end
	end
end

function modifier_enemy_irritable:OnBattleEnd()
	self:SetStackCount(0)
end

function modifier_enemy_irritable:GetAttackSpeedBonus()
	return self.attackspeed_perstack * self:GetStackCount()
end