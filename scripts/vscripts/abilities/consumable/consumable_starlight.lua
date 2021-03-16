LinkLuaModifier( "modifier_consumable_starlight", "abilities/consumable/consumable_starlight.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if consumable_starlight == nil then
	consumable_starlight = class({})
end
function consumable_starlight:GetIntrinsicModifierName()
	return "modifier_consumable_starlight"
end
---------------------------------------------------------------------
--Modifiers
if modifier_consumable_starlight == nil then
	modifier_consumable_starlight = class({})
end
function modifier_consumable_starlight:OnCreated(params)
	if IsServer() then
	end
end
function modifier_consumable_starlight:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_consumable_starlight:OnDestroy()
	if IsServer() then
	end
end
function modifier_consumable_starlight:DeclareFunctions()
	return {
	}
end