---勇者战旗
LinkLuaModifier("modifier_item_banner_of_warrior_buff", "abilities/items/item_banner_of_warrior.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_banner_of_warrior then
	item_banner_of_warrior = class({}, nil, base_ability_attribute)
end
function item_banner_of_warrior:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_banner_of_warrior then
	modifier_item_banner_of_warrior = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_banner_of_warrior:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_item_banner_of_warrior:IsHidden()
	return false
end
function modifier_item_banner_of_warrior:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_banner_of_warrior:UpdateValues()

	self.range = self:GetAbilitySpecialValueFor('range')
	self.magical_attack_bonus = self:GetAbilitySpecialValueFor('magical_attack_bonus')
	self.stack_count = self:GetAbilitySpecialValueFor('stack_count')

end
function modifier_item_banner_of_warrior:OnIntervalThink()

	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if hUnit == self:GetParent() and self.stack_count > self:GetStackCount() then
			-- 	self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_magical_damage_bonus_buff",)
			-- 	hTarget:AddNewModifier(hCaster, self, "modifier_omniknight_2_motion", {vPosition = hCaster:GetAbsOrigin() + vDirection * flDistance})
			self:SetStackCount(self:GetStackCount() + 1)
			self:GetParent():SetVal(ATTRIBUTE_KIND.MagicalAttack, self.magical_attack_bonus * self:GetStackCount(), self)
			hParent:AddNewModifier(hParent, self:GetAbility(), 'modifier_item_banner_of_warrior_buff', { duration = LOCAL_PARTICLE_MODIFIER_DURATION })

		elseif hUnit ~= self:GetParent() then
			self:DecrementStackCount()
			self:DecrementStackCount()
			self:GetParent():RemoveModifierByName('modifier_item_banner_of_warrior_buff')
		elseif self.stack_count == self:GetStackCount() then
			self:SetStackCount(self.stack_count)
			self:GetParent():SetVal(ATTRIBUTE_KIND.MagicalAttack, self.magical_attack_bonus * self:GetStackCount(), self)
		end



	end
end
function modifier_item_banner_of_warrior:OnDestroy()
	self:StartIntervalThink(-1)
end

function modifier_item_banner_of_warrior:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS
	}
end

function modifier_item_banner_of_warrior:GetMagicalAttackBonus(params)
	return self.magical_attack_bonus * self:GetStackCount()
end

function modifier_item_banner_of_warrior:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
-- function modifier_attack_speed_bonus_buff:OnTooltip()
-- 	return self.health_per
-- end
function modifier_item_banner_of_warrior:OnTooltip2()
	return self.magical_attack_bonus * self:GetStackCount()
end



if modifier_item_banner_of_warrior_buff == nil then
	modifier_item_banner_of_warrior_buff = class({}, nil, ParticleModifier)
end
function modifier_item_banner_of_warrior_buff:OnCreated(params)
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf', PATTACH_POINT_FOLLOW, self:GetParent())
			self:AddParticle(iPtclID, false, false, -1, false, false)
			ParticleManager:SetParticleControl(iPtclID, 1, Vector(self.range, self.range, self.range))
			return iPtclID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)

	end
end












AbilityClassHook('item_banner_of_warrior', getfenv(1), 'abilities/items/item_banner_of_warrior.lua', { KeyValues.ItemsKv })