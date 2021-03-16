LinkLuaModifier("modifier_art_jokerq", "abilities/artifact/art_jokerq.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_jokerq_buff", "abilities/artifact/art_jokerq.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_jokerq_debuff", "abilities/artifact/art_jokerq.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_jokerq == nil then
	art_jokerq = class({}, nil, artifact_base)
end
function art_jokerq:GetIntrinsicModifierName()
	return "modifier_art_jokerq"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_jokerq == nil then
	modifier_art_jokerq = class({}, nil, eom_modifier)
end
function modifier_art_jokerq:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:StartIntervalThink(1)
	end
end
function modifier_art_jokerq:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_art_jokerq:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_jokerq:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(self:GetParent())
			EachUnits(iPlayerID, function(hUnit)
				if DotaTD:GetCardRarity(hUnit:GetUnitName()) == 'r' and not hUnit:HasModifier("modifier_art_jokerq_buff") then
					table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_jokerq_buff", nil))
				end
				if DotaTD:GetCardRarity(hUnit:GetUnitName()) == 'sr' and not hUnit:HasModifier("modifier_art_jokerq_debuff") then
					if not hUnit:HasModifier("modifier_art_jokerk_buff") then
						table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_jokerq_debuff", nil))
					end
				end
				if hUnit:HasModifier("modifier_art_jokerk_buff") and hUnit:HasModifier("modifier_art_jokerq_debuff") then
					hUnit:RemoveModifierByName('modifier_art_jokerq_debuff')
				end
			end, UnitType.Building)
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_jokerq_buff == nil then
	modifier_art_jokerq_buff = class({}, nil, eom_modifier)
end
function modifier_art_jokerq_buff:OnCreated(params)
	self.health_bonus_pct = self:GetAbilitySpecialValueFor('health_bonus_pct')
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
	end
end
function modifier_art_jokerq_buff:OnRefresh(params)
	self.health_bonus_pct = self:GetAbilitySpecialValueFor('health_bonus_pct')
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
	end
end
function modifier_art_jokerq_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_jokerq_buff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_art_jokerq_buff:GetStatusHealthBonusPercentage()
	return	self.health_bonus_pct
end
function modifier_art_jokerq_buff:GetMagicalAttackBonusPercentage()
	return	self.attack_bonus_pct
end
function modifier_art_jokerq_buff:GetPhysicalAttackBonusPercentage()
	return	self.attack_bonus_pct
end
function modifier_art_jokerq_buff:DeclareFunctions()
	return		{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_jokerq_buff:OnTooltip()
	return self.attack_bonus_pct
end
-----------------------------
--Modifiers
if modifier_art_jokerq_debuff == nil then
	modifier_art_jokerq_debuff = class({}, nil, eom_modifier)
end
function modifier_art_jokerq_debuff:OnCreated(params)
	self.health_reduce_pct = self:GetAbilitySpecialValueFor('health_reduce_pct')
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor('attack_reduce_pct')
	if IsServer() then
	end
end
function modifier_art_jokerq_debuff:OnRefresh(params)
	self.health_reduce_pct = self:GetAbilitySpecialValueFor('health_reduce_pct')
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor('attack_reduce_pct')
	if IsServer() then
	end
end
function modifier_art_jokerq_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_jokerq_debuff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_art_jokerq_debuff:GetStatusHealthBonusPercentage()
	return	- self.health_reduce_pct
end
function modifier_art_jokerq_debuff:GetMagicalAttackBonusPercentage()
	return	- self.attack_reduce_pct
end
function modifier_art_jokerq_debuff:GetPhysicalAttackBonusPercentage()
	return	- self.attack_reduce_pct
end
function modifier_art_jokerq_debuff:DeclareFunctions()
	return		{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_jokerq_debuff:OnTooltip()
	return -self.attack_reduce_pct
end
function modifier_art_jokerq_debuff:IsDebuff()
	return true
end