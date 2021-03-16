LinkLuaModifier( "modifier_affix_flaws", "abilities/consumable/affix_flaws.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if affix_flaws == nil then
	affix_flaws = class({})
end
function affix_flaws:GetIntrinsicModifierName()
	return "modifier_affix_flaws"
end
---------------------------------------------------------------------
--Modifiers
if modifier_affix_flaws == nil then
	modifier_affix_flaws = class({})
end
function modifier_affix_flaws:OnCreated(params)
	if IsServer() then
	end
end
function modifier_affix_flaws:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_affix_flaws:OnDestroy()
	if IsServer() then
	end
end
function modifier_affix_flaws:DeclareFunctions()
	return {
	}
end