---漫射宝石
LinkLuaModifier("modifier_divergent_gem_particle_buff", "abilities/items/item_divergent_gem.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_divergent_gem then
	item_divergent_gem = class({}, nil, base_ability_attribute)
end
function item_divergent_gem:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_divergent_gem then
	modifier_item_divergent_gem = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_divergent_gem:IsHidden()
	return self.magical_rebound_pct == 0
end
function modifier_item_divergent_gem:OnCreated(params)
	self:UpdateValues()


end

function modifier_item_divergent_gem:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_divergent_gem:UpdateValues(params)
	self.physical_damage_punishment_pct = self:GetAbilitySpecialValueFor("physical_damage_punishment_pct")
	self.magical_rebound_pct = self:GetAbilitySpecialValueFor('magical_rebound_pct')
	self.range = self:GetAbilitySpecialValueFor('range')
	self.unlock_level = self:GetAbilitySpecialValueFor('unlock_level')
end

function modifier_item_divergent_gem:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
end
function modifier_item_divergent_gem:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_item_divergent_gem:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		[EMDF_PHYSICAL_INCOMING_PERCENTAGE] = self.physical_damage_punishment_pct,
	}
end


-- function modifier_item_divergent_gem:GetMagicalIncomingPercentage()
-- 	return -1000
-- end
-- function modifier_item_divergent_gem:GetPhysicalIncomingPercentage()
-- 	return self.physical_damage_punishment_pct
-- end
function modifier_item_divergent_gem:OnTakeDamage(params)
	if params.unit ~= self:GetParent() or not IsValid(params.attacker) then return end
	if 0 >= params.damage or params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end
	if self.unlock_level <= self:GetAbility():GetLevel() then
		self:CheckCounterAttack(params.attacker, params.damage)
	end
end
function modifier_item_divergent_gem:CheckCounterAttack(hTarget, fldamage)
	local hParent = self:GetParent()
	local flDamage = 0.01 * self.magical_rebound_pct * fldamage
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		ApplyDamage(
		{
			attacker = hParent,
			victim = hUnit,
			ability = self:GetAbility(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_PHYSICAL
		})
		-- hUnit:AddNewModifier(hParent, self:GetAbility(), 'modifier_divergent_gem_particle_buff', { duration = LOCAL_PARTICLE_MODIFIER_DURATION })
	end
end

function modifier_item_divergent_gem:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
function modifier_item_divergent_gem:OnTooltip()
	return self.range
end
function modifier_item_divergent_gem:OnTooltip2()
	return self.magical_rebound_pct
end




if modifier_divergent_gem_particle_buff == nil then
	modifier_divergent_gem_particle_buff = class({}, nil, ParticleModifier)
end
function modifier_divergent_gem_particle_buff:OnCreated(params)
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/items/item_divergent_gem/item_divergent_gem_target.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
			self:AddParticle(iPtclID, false, false, -1, false, false)
			ParticleManager:SetParticleControl(iPtclID, 1, self:GetParent():GetAbsOrigin())
			return iPtclID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)

	end
end







AbilityClassHook('item_divergent_gem', getfenv(1), 'abilities/items/item_divergent_gem.lua', { KeyValues.ItemsKv })