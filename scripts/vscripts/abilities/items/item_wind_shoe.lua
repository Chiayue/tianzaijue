LinkLuaModifier("modifier_item_wind_shoe", "abilities/items/item_wind_shoe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--恐鳌之戒
if item_wind_shoe == nil then
	item_wind_shoe = class({}, nil, base_ability_attribute)
end
function item_wind_shoe:GetIntrinsicModifierName()
	return "modifier_item_wind_shoe"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_wind_shoe == nil then
	modifier_item_wind_shoe = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_wind_shoe:OnCreated(params)
	self.attack_miss = self:GetAbilitySpecialValueFor("attack_miss")
	if IsServer() then
	end
end
function modifier_item_wind_shoe:OnRefresh(params)
	self.attack_miss = self:GetAbilitySpecialValueFor("attack_miss")
	if IsServer() then
	end
end
function modifier_item_wind_shoe:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_wind_shoe:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS
	}
end
function modifier_item_wind_shoe:GetAttackMissBonus()
	return 100, self.attack_miss
end



AbilityClassHook('item_wind_shoe', getfenv(1), 'abilities/items/item_wind_shoe.lua', { KeyValues.ItemsKv })