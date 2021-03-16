---弩炮
if nil == item_ballista then
	item_ballista = class({}, nil, base_ability_attribute)
end
function item_ballista:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end
---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_ballista then
	modifier_item_ballista = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_ballista:IsHidden()
	return self:GetStackCount() <= 0
end
function modifier_item_ballista:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_ballista:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_ballista:UpdateValues()
	self.attack_count = self:GetAbilitySpecialValueFor('attack_count')
	self.aoe_range = self:GetAbilitySpecialValueFor('aoe_range')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_ballista:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end
function modifier_item_ballista:OnAttack(params)
	if params.attacker ~= self:GetParent() or params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK, ATTACK_STATE_SKIPCOUNTING) then
		return
	end

	if self.unlock_level > self:GetAbility():GetLevel() then
		return
	end

	if 0 < self.attack_count then
		self.iAtkCount = (self.iAtkCount or 0) + 1
		if self.iAtkCount >= self.attack_count then
			self.iAtkCount = 0
			local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.target:GetAbsOrigin(), nil, self.aoe_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, hUnit in pairs(tTargets) do
				local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_NOT_PROCESSPROCS + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
				params.attacker:Attack(hUnit, iAttackState)
			end
		end
		self:SetStackCount(self.iAtkCount)
	end
end







AbilityClassHook('item_ballista', getfenv(1), 'abilities/items/item_ballista.lua', { KeyValues.ItemsKv })