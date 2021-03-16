---水晶剑
-- LinkLuaModifier("modifier_angel_relics_physical_immune", "abilities/items/item_crystal_sword.lua", LUA_MODIFIER_MOTION_NONE)
if nil == item_crystal_sword then
	item_crystal_sword = class({}, nil, base_ability_attribute)
end
function item_crystal_sword:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_crystal_sword then
	modifier_item_crystal_sword = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_crystal_sword:IsHidden()
	return true
end
function modifier_item_crystal_sword:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_crystal_sword:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_crystal_sword:UpdateValues(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor('crit_damage_pct')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end

function modifier_item_crystal_sword:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		-- --检测的是别人死亡
		-- 	[MODIFIER_EVENT_ON_DEATH] = {self:GetParent()},
		EMDF_EVENT_ON_ATTACK_HIT,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = { self:GetParent() }
	}
end
function modifier_item_crystal_sword:GetAttackCritBonus()
	return self.crit_damage_pct, self.crit_chance
end




AbilityClassHook('item_crystal_sword', getfenv(1), 'abilities/items/item_crystal_sword.lua', { KeyValues.ItemsKv })