LinkLuaModifier("modifier_art_joker1", "abilities/artifact/art_joker1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_joker1_buff", "abilities/artifact/art_joker1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_joker1_debuff", "abilities/artifact/art_joker1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_joker1 == nil then
	art_joker1 = class({}, nil, artifact_base)
end
function art_joker1:GetIntrinsicModifierName()
	return "modifier_art_joker1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_joker1 == nil then
	modifier_art_joker1 = class({}, nil, eom_modifier)
end
function modifier_art_joker1:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:StartIntervalThink(1)
	end
end
function modifier_art_joker1:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_art_joker1:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_joker1:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(self:GetParent())
			EachUnits(iPlayerID, function(hUnit)
				if DotaTD:GetCardRarity(hUnit:GetUnitName()) == 'ssr' and not hUnit:HasModifier("modifier_art_joker1_buff") then
					table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_joker1_buff", nil))
				end
				if DotaTD:GetCardRarity(hUnit:GetUnitName()) == 'n' and not hUnit:HasModifier("modifier_art_joker1_debuff") then
					if not hUnit:HasModifier("modifier_art_joker2_buff") then
						table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_joker1_debuff", nil))
					end
				end
				if hUnit:HasModifier("modifier_art_joker2_buff") and hUnit:HasModifier("modifier_art_joker1_debuff") then
					hUnit:RemoveModifierByName('modifier_art_joker1_debuff')
				end
			end, UnitType.Building)
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_joker1_buff == nil then
	modifier_art_joker1_buff = class({}, nil, eom_modifier)
end
function modifier_art_joker1_buff:OnCreated(params)
	self.health_bonus_pct = self:GetAbilitySpecialValueFor('health_bonus_pct')
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
	end
end
function modifier_art_joker1_buff:OnRefresh(params)
	self.health_bonus_pct = self:GetAbilitySpecialValueFor('health_bonus_pct')
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
	end
end
function modifier_art_joker1_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_joker1_buff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_art_joker1_buff:GetStatusHealthBonusPercentage()
	return	self.health_bonus_pct
end
function modifier_art_joker1_buff:GetMagicalAttackBonusPercentage()
	return	self.attack_bonus_pct
end
function modifier_art_joker1_buff:GetPhysicalAttackBonusPercentage()
	return	self.attack_bonus_pct
end
function modifier_art_joker1_buff:DeclareFunctions()
	return		{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_joker1_buff:OnTooltip()
	return self.attack_bonus_pct
end
-----------------------------
--Modifiers
if modifier_art_joker1_debuff == nil then
	modifier_art_joker1_debuff = class({}, nil, eom_modifier)
end
function modifier_art_joker1_debuff:OnCreated(params)
	self.health_reduce_pct = self:GetAbilitySpecialValueFor('health_reduce_pct')
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor('attack_reduce_pct')
	if IsServer() then
	end
end
function modifier_art_joker1_debuff:OnRefresh(params)
	self.health_reduce_pct = self:GetAbilitySpecialValueFor('health_reduce_pct')
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor('attack_reduce_pct')
	if IsServer() then
	end
end
function modifier_art_joker1_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_joker1_debuff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
	}
end
function modifier_art_joker1_debuff:GetStatusHealthBonusPercentage()
	return	- self.health_reduce_pct
end
function modifier_art_joker1_debuff:GetMagicalAttackBonusPercentage()
	return	- self.attack_reduce_pct
end
function modifier_art_joker1_debuff:GetPhysicalAttackBonusPercentage()
	return	- self.attack_reduce_pct
end
function modifier_art_joker1_debuff:DeclareFunctions()
	return		{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_joker1_debuff:OnTooltip()
	return -self.attack_reduce_pct
end
function modifier_art_joker1_debuff:IsDebuff()
	return true
end