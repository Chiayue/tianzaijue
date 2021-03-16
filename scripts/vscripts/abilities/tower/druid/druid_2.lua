LinkLuaModifier( "modifier_druid_2", "abilities/tower/druid/druid_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_druid_2_bear", "abilities/tower/druid/druid_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if druid_2 == nil then
	druid_2 = class({})
end
function druid_2:Spawn()
	if IsServer() then
		-- 记录主身灵力
		local tAbilityData = PlayerData:GetAbilityData(self:GetCaster(), self:GetAbilityName())
		if tAbilityData and tAbilityData.iStackCount == nil then
			tAbilityData.iStackCount = 0
		end
	end
end
function druid_2:GetIntrinsicModifierName()
	return "modifier_druid_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_druid_2 == nil then
	modifier_druid_2 = class({}, nil, eom_modifier)
end
function modifier_druid_2:OnCreated(params)
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	if IsServer() then
		local tAbilityData = PlayerData:GetAbilityData(self:GetCaster(), self:GetAbility():GetAbilityName())
		if tAbilityData and tAbilityData.iStackCount ~= 0 then
			self:SetStackCount(tAbilityData.iStackCount)
		else
			local hBear = self:GetParent():GetBear()
			if hBear then
				if not hBear:HasModifier("modifier_druid_2_bear") then
					hBear:AddNewModifier(self:GetParent(), self:GetParent(), "modifier_druid_2_bear", nil)
				end
				local iStackCount = hBear:FindModifierByName("modifier_druid_4"):GetStackCount()
				self:SetStackCount(iStackCount)
				tAbilityData.iStackCount = iStackCount
			end

		end
	end
end
function modifier_druid_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
end
function modifier_druid_2:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local hBear = self:GetParent():GetBear()
		if hBear and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
			params.attacker:DealDamage(hBear, nil, params.damage * 0.5, params.damage_type, params.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION)
			return params.damage * 0.5	
		end
	end
end
function modifier_druid_2:EDeclareFunctions()
	return {
		EMDF_STATUS_MANA_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
	}
end
function modifier_druid_2:GetStatusManaBonus()
	return self.bonus_mana * self:GetStackCount()
end
function modifier_druid_2:GetMagicalAttackBonus()
	return self.bonus_attack * self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_druid_2_bear == nil then
	modifier_druid_2_bear = class({}, nil, ModifierHidden)
end
function modifier_druid_2_bear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_druid_2_bear:GetModifierTotal_ConstantBlock(params)
	if IsServer() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local hCaster = self:GetCaster()
		params.attacker:DealDamage(hCaster, nil, params.damage * 0.5, params.damage_type, params.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION)
		return params.damage * 0.5
	end
end