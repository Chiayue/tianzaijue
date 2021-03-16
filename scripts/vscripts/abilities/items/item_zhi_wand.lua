LinkLuaModifier("modifier_item_zhi_wand", "abilities/items/item_zhi_wand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--制式长矛
if item_zhi_wand == nil then
	item_zhi_wand = class({}, nil, base_ability_attribute)
end
function item_zhi_wand:GetIntrinsicModifierName()
	return "modifier_item_zhi_wand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_zhi_wand == nil then
	modifier_item_zhi_wand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_zhi_wand:OnCreated(params)
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_zhi_wand:OnRefresh(params)
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_zhi_wand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_zhi_wand:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
---@param tAttackInfo AttackInfo
function modifier_item_zhi_wand:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent()
	or not IsValid(hTarget)
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end
	-- 每次攻击有几率减少冷却
	if RollPercentage(self.chance) then
		for iIndex = 0, 5 do
			local hAbility = self:GetParent():GetAbilityByIndex(iIndex)
			if IsValid(hAbility) and hAbility ~= self and hAbility:GetCooldownTimeRemaining() > 0 then
				local flCooldown = math.max(hAbility:GetCooldownTimeRemaining() * self.cooldown_reduce * 0.01, 0)
				hAbility:EndCooldown()
				hAbility:StartCooldown(flCooldown)
			end
		end
	end
end

AbilityClassHook('item_zhi_wand', getfenv(1), 'abilities/items/item_zhi_wand.lua', { KeyValues.ItemsKv })