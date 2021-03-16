LinkLuaModifier("modifier_item_dragon_scale_debuff", "abilities/items/item_dragon_scale.lua", LUA_MODIFIER_MOTION_NONE)

---灼烧斗篷
if nil == item_dragon_scale then
	item_dragon_scale = class({}, nil, base_ability_attribute)
end
function item_dragon_scale:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_dragon_scale then
	modifier_item_dragon_scale = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_dragon_scale:IsHidden()
	return true
end
function modifier_item_dragon_scale:IsAura()
	return self:GetAbility():GetLevel() >= self.unlock_level
end
function modifier_item_dragon_scale:GetAuraRadius()
	return self.range
end
function modifier_item_dragon_scale:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_item_dragon_scale:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_item_dragon_scale:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_dragon_scale:GetModifierAura()
	return "modifier_item_dragon_scale_debuff"
end
function modifier_item_dragon_scale:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_dragon_scale:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_dragon_scale:UpdateValues()
	self.range = self:GetAbilitySpecialValueFor('range')
	self.magical_armor = self:GetAbilitySpecialValueFor('magical_armor')
	self.unlock_level = self:GetAbilitySpecialValueFor('unlock_level')
end


--DEBUFF
if nil == modifier_item_dragon_scale_debuff then
	modifier_item_dragon_scale_debuff = class({}, nil, eom_modifier)
end
function modifier_item_dragon_scale_debuff:IsHidden()
	return false
end
function modifier_item_dragon_scale_debuff:IsDebuff()
	return true
end
function modifier_item_dragon_scale_debuff:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self:StartIntervalThink(1)
	else
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf', PATTACH_INVALID, self:GetParent())
			self:AddParticle(iPtclID, false, true, 10, false, false)
			return iPtclID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_item_dragon_scale_debuff:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_dragon_scale_debuff:UpdateValues()
	if IsServer() then
		self.typeDamage = self:GetAbility():GetAbilityDamageType()
	end
end
function modifier_item_dragon_scale_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	if IsValid(hCaster) then
		local fDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalArmor)
		ApplyDamage({
			attacker = hCaster,
			victim = self:GetParent(),
			ability = self:GetAbility(),
			damage = fDamage,
			damage_type = self.typeDamage
		})
	end
end

AbilityClassHook('item_dragon_scale', getfenv(1), 'abilities/items/item_dragon_scale.lua', { KeyValues.ItemsKv })