if modifier_attribute_getter == nil then
	modifier_attribute_getter = class({})
end
local public = modifier_attribute_getter

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:IsStunDebuff()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:GetTexture()
	if IsClient() then
		local hParent = self:GetParent()

		if _G.GetAbilityCooldown_AbilityEntIndex ~= -1 then
			local hAbility = EntIndexToHScript(_G.GetAbilityCooldown_AbilityEntIndex)
			local iLevel = _G.GetAbilityCooldown_Level
	
			_G.GetAbilityCooldown_AbilityEntIndex = -1
			_G.GetAbilityCooldown_Level = -1
	
			if IsValid(hAbility) and hAbility.GetCooldown ~= nil then
				return tostring(hAbility:GetCooldown(iLevel))
			else
				return ""
			end
		end
	
		if _G.GetAbilityManaCost_AbilityEntIndex ~= -1 then
			local hAbility = EntIndexToHScript(_G.GetAbilityManaCost_AbilityEntIndex)
			local iLevel = _G.GetAbilityManaCost_Level
	
			_G.GetAbilityManaCost_AbilityEntIndex = -1
			_G.GetAbilityManaCost_Level = -1
	
			if IsValid(hAbility) and hAbility.GetManaCost ~= nil then
				return tostring(hAbility:GetManaCost(iLevel))
			else
				return ""
			end
		end

		if _G.GetAbilityGoldCost_AbilityEntIndex ~= -1 then
			local hAbility = EntIndexToHScript(_G.GetAbilityGoldCost_AbilityEntIndex)
			local iLevel = _G.GetAbilityGoldCost_Level
	
			_G.GetAbilityGoldCost_AbilityEntIndex = -1
			_G.GetAbilityGoldCost_Level = -1
	
			if IsValid(hAbility) and hAbility.GetGoldCost ~= nil then
				return tostring(hAbility:GetGoldCost(iLevel))
			else
				return ""
			end
		end

		local tData = {}
		for k, v in pairs(ATTRIBUTE_SYNC) do
			tData[k] = hParent:GetVal(k)
		end
		return json.encode(tData)
	end
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end
function public:GetModifierAttackRangeBonus()
	if not self.iBaseAttackRange then
		if IsServer() then
			self.iBaseAttackRange = self:GetParent():GetBaseAttackRange()
		else
			local tKV = KeyValues.UnitsKv[self:GetParent():GetUnitName()]
			self.iBaseAttackRange = tKV and tonumber(tKV.AttackRange) or 0
		end
	end
	return self:GetParent():GetVal(ATTRIBUTE_KIND.AttackRange) - self.iBaseAttackRange
end
function public:GetModifierAttackSpeedBonus_Constant()
	-- 减去100基础值
	return self:GetParent():GetVal(ATTRIBUTE_KIND.AttackSpeed) - 100
end
function public:GetModifierConstantManaRegen()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.ManaRegen)
end
function public:GetModifierMoveSpeedBonus_Constant()
	if not self.iBaseMoveSpeed then
		if IsServer() then
			self.iBaseMoveSpeed = self:GetParent():GetBaseMoveSpeed()
		else
			local tKV = KeyValues.UnitsKv[self:GetParent():GetUnitName()]
			self.iBaseMoveSpeed = tKV and tonumber(tKV.MovementSpeed) or 0
		end
	end
	return self:GetParent():GetVal(ATTRIBUTE_KIND.MoveSpeed) - self.iBaseMoveSpeed
end
function public:GetModifierManaBonus()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.StatusMana) - 100
end
function public:GetModifierConstantHealthRegen()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.HealthRegen)
end