LinkLuaModifier("modifier_item_summon_flag", "abilities/items/item_summon_flag.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summon_flag_buff", "abilities/items/item_summon_flag.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_summon_flag == nil then
	item_summon_flag = class({}, nil, base_ability_attribute)
end
function item_summon_flag:GetIntrinsicModifierName()
	return "modifier_item_summon_flag"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_summon_flag == nil then
	modifier_item_summon_flag = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_summon_flag:OnCreated(params)
	self.summon_atkbonus = self:GetAbilitySpecialValueFor("summon_atkbonus")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_item_summon_flag:OnRefresh(params)
	self.summon_atkbonus = self:GetAbilitySpecialValueFor("summon_atkbonus")
	if IsServer() then
	end
end
function modifier_item_summon_flag:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_summon_flag:OnIntervalThink()
	if IsServer() then
		EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
			if not hUnit:HasModifier("modifier_item_summon_flag_buff") then
				hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_summon_flag_buff", {})
			end
		end, UnitType.Summoner)
	end

end
function modifier_item_summon_flag:EDeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_summon_flag_buff == nil then
	modifier_item_summon_flag_buff = class({}, nil, eom_modifier)
end
function modifier_item_summon_flag_buff:OnCreated(params)
	self.summon_atkbonus = self:GetAbilitySpecialValueFor("summon_atkbonus")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_item_summon_flag_buff:OnRefresh(params)
	self.summon_atkbonus = self:GetAbilitySpecialValueFor("summon_atkbonus")
	if IsServer() then
	end
end
function modifier_item_summon_flag_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_summon_flag_buff:OnIntervalThink()
	if IsServer() then
		EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
			if not hUnit:HasModifier("modifier_item_summon_flag_buff") then
				hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_summon_flag_buff", {})
			end
		end, UnitType.Summoner)
	end
end
function modifier_item_summon_flag_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS] = self.summon_atkbonus,
		[EMDF_MAGICAL_ATTACK_BONUS] = self.summon_atkbonus
	}
end

AbilityClassHook('item_summon_flag', getfenv(1), 'abilities/items/item_summon_flag.lua', { KeyValues.ItemsKv })