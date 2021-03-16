LinkLuaModifier("modifier_item_zhi_bow", "abilities/items/item_zhi_bow.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--制式长矛
if item_zhi_bow == nil then
	item_zhi_bow = class({}, nil, base_ability_attribute)
end
function item_zhi_bow:GetIntrinsicModifierName()
	return "modifier_item_zhi_bow"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_zhi_bow == nil then
	modifier_item_zhi_bow = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_zhi_bow:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_zhi_bow:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_zhi_bow:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_zhi_bow:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end
function modifier_item_zhi_bow:OnAttack(params)
	if params.attacker ~= self:GetParent() or params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK, ATTACK_STATE_SKIPCOUNTING) then
		return
	end
	if RollPercentage(self.chance) then
		local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, self:GetParent():GetBaseAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local hTarget = tTargets[1]
		if hTarget then
			local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_NOT_PROCESSPROCS + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
			params.attacker:Attack(hTarget, iAttackState)
		end
	end

end
AbilityClassHook('item_zhi_bow', getfenv(1), 'abilities/items/item_zhi_bow.lua', { KeyValues.ItemsKv })