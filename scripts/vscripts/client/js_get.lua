_G.GetAbilityCooldown_AbilityEntIndex = -1
_G.GetAbilityCooldown_Level = -1

_G.GetAbilityManaCost_AbilityEntIndex = -1
_G.GetAbilityManaCost_Level = -1

_G.GetAbilityGoldCost_AbilityEntIndex = -1
_G.GetAbilityGoldCost_Level = -1

if nil == JsGet then
	---@class JsGet
	JsGet = {}
	JsGet = class({}, JsGet)
end
---@type JsGet
local public = JsGet

function public:init(bReload)
	GameEvent("custom_get_ability_cooldown", Dynamic_Wrap(self, "OnGetAbilityCooldown"), self)
	GameEvent("custom_get_ability_mana_cost", Dynamic_Wrap(self, "OnGetAbilityManaCost"), self)
	GameEvent("custom_get_ability_gold_cost", Dynamic_Wrap(self, "OnGetAbilityGoldCost"), self)
end

function public:OnGetAbilityCooldown(tEvents)
	DeepPrintTable(tEvents)
	_G.GetAbilityCooldown_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilityCooldown_Level = tEvents.level
end
function public:OnGetAbilityManaCost(tEvents)
	_G.GetAbilityManaCost_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilityManaCost_Level = tEvents.level
end
function public:OnGetAbilityGoldCost(tEvents)
	_G.GetAbilityGoldCost_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilityGoldCost_Level = tEvents.level
end

return public