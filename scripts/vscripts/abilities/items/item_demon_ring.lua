LinkLuaModifier("modifier_item_demon_ring", "abilities/items/item_demon_ring.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_demon_ring == nil then
	item_demon_ring = class({}, nil, base_ability_attribute)
end
function item_demon_ring:GetIntrinsicModifierName()
	return "modifier_item_demon_ring"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_demon_ring == nil then
	modifier_item_demon_ring = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_demon_ring:OnCreated(params)
	self.health_cost_pct = self:GetAbilitySpecialValueFor('health_cost_pct')
	self.interval = self:GetAbilitySpecialValueFor('interval')
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			-- self:GetAbility():StartCooldown(self.interval)
			self:StartIntervalThink(0.1)
		end
	end
end
function modifier_item_demon_ring:OnRefresh(params)
	self.health_cost_pct = self:GetAbilitySpecialValueFor('health_cost_pct')
	self.interval = self:GetAbilitySpecialValueFor('interval')
	if IsServer() then
	end
end
function modifier_item_demon_ring:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_demon_ring:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_item_demon_ring:OnInBattle()
	-- self:GetAbility():StartCooldown(self.interval)
	self:StartIntervalThink(0.1)
end
function modifier_item_demon_ring:OnBattleEnd()
	self:StartIntervalThink(-1)
end
function modifier_item_demon_ring:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:IsAlive() and hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		local flDamage = hParent:GetVal(ATTRIBUTE_KIND.StatusHealth) * self.health_cost_pct * 0.01
		hParent:DealDamage(hParent, hAbility, flDamage, nil, DOTA_DAMAGE_FLAG_NON_LETHAL)
		hParent:GiveMana(hParent:GetVal(ATTRIBUTE_KIND.StatusMana))
		for i = 0, 2 do
			local _hAbility = hParent:GetAbilityByIndex(i)
			if not _hAbility:IsCooldownReady() then
				_hAbility:EndCooldown()
			end
		end
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/soul_ring.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hParent:EmitSound("DOTA_Item.SoulRing.Activate")
	end
end