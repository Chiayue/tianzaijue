LinkLuaModifier( "modifier_druid_5", "abilities/tower/druid/druid_5.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_druid_5_buff", "abilities/tower/druid/druid_5.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if druid_5 == nil then
	druid_5 = class({})
end
function druid_5:GetIntrinsicModifierName()
	return "modifier_druid_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_druid_5 == nil then
	modifier_druid_5 = class({}, nil, eom_modifier)
end
function modifier_druid_5:IsHidden()
	return true
end
function modifier_druid_5:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent()},
	}
end
function modifier_druid_5:OnDeath()
	if IsServer() then
		EachUnits(GetPlayerID(self:GetParent()), function (hUnit)
			hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_druid_5_buff", nil)
		end, UnitType.AllFirends)
	end
end
---------------------------------------------------------------------
if modifier_druid_5_buff == nil then
	modifier_druid_5_buff = class({}, nil, eom_modifier)
end
function modifier_druid_5_buff:OnCreated(params)
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	if IsServer() then
		local tAbilityData = PlayerData:GetAbilityData(self:GetParent(), "druid_1")
		if tAbilityData and tAbilityData.iStackCount then
			self:SetStackCount(tAbilityData.iStackCount)
		end
	end
end
function modifier_druid_5_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_STATUS_MANA_BONUS
	}
end
function modifier_druid_5_buff:GetMagicalAttackBonus()
	return self.bonus_attack * self:GetStackCount()
end
function modifier_druid_5_buff:GetStatusManaBonus()
	return self.bonus_mana * self:GetStackCount()
end
function modifier_druid_5_buff:OnBattleEnd()
	self:Destroy()
end