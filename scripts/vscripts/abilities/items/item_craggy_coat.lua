---浩劫巨锤
if nil == item_craggy_coat then
	item_craggy_coat = class({}, nil, base_ability_attribute)
end
function item_craggy_coat:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_craggy_coat then
	modifier_item_craggy_coat = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_craggy_coat:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_craggy_coat:IsHidden()
	return false
end
function modifier_item_craggy_coat:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_craggy_coat:UpdateValues()
	self.status_health = self:GetAbilitySpecialValueFor('status_health')
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.armor_count = self:GetAbilitySpecialValueFor('armor_count')
	self.health_add = self:GetAbilitySpecialValueFor('health_add')
	self.knockback_distance = self:GetAbilitySpecialValueFor('knockback_distance')
	self.knockback_duration = self:GetAbilitySpecialValueFor('knockback_duration')
	self.aoe_range = self:GetAbilitySpecialValueFor('aoe_range')
	self.health_per = self:GetAbilitySpecialValueFor('health_per')

	if IsServer() then
	end
end
function modifier_item_craggy_coat:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_PREPARATION
	}
end
function modifier_item_craggy_coat:OnPreparation()
	self:ForceRefresh()
end
function modifier_item_craggy_coat:OnTakeDamage(params)
	if params.unit ~= self:GetParent() or not IsValid(params.attacker) then return end
	if 0 >= params.damage then return end
	self:CheckCounterAttack(params.attacker)
end
function modifier_item_craggy_coat:CheckCounterAttack(hTarget)
	if RollPercentage(self.chance) then
		local hParent = self:GetParent()
		local vCenter = hParent:GetAbsOrigin()
		local flDamage = hParent:GetHealth() * 0.01 * self.health_per
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.aoe_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			if not hUnit:FindModifierByNameAndCaster('modifier_knockback', hParent) then
				--击退伤害
				hParent:KnockBack(vCenter, hUnit, self.knockback_distance, 0, self.knockback_duration, false)
				hParent:DealDamage(hUnit, self:GetAbility(), flDamage)
				-- 特效与音效
				local iParticleID = ParticleManager:CreateParticle("particles/items5_fx/havoc_hammer.vpcf", PATTACH_ABSORIGIN, hParent)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.aoe_range, self.aoe_range, self.aoe_range))
				ParticleManager:ReleaseParticleIndex(iParticleID)
				hParent:EmitSound("DOTA_Item.HavocHammer.Cast")
			end
		end
	end
end
function modifier_item_craggy_coat:GetStatusHealthBonus()
	if GSManager:getStateType() ~= GS_Preparation then
		return 0
	end
	local iHealth = self.status_health or 0
	if 0 < self.health_add then
		local iAtk = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalArmor)
		iHealth = iHealth + iAtk * self.armor_count * self.health_add
	end
	return iHealth
end

function modifier_item_craggy_coat:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_item_craggy_coat:OnTooltip()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self.health_add
end
function modifier_item_craggy_coat:OnTooltip2()
	return self.chance
end








AbilityClassHook('item_craggy_coat', getfenv(1), 'abilities/items/item_craggy_coat.lua', { KeyValues.ItemsKv })