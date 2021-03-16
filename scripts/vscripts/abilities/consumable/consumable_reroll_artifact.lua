LinkLuaModifier( "modifier_consumable_reroll_artifact", "abilities/consumable/consumable_reroll_artifact.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if consumable_reroll_artifact == nil then
	consumable_reroll_artifact = class({})
end
function consumable_reroll_artifact:GetIntrinsicModifierName()
	return "modifier_consumable_reroll_artifact"
end
---------------------------------------------------------------------
--Modifiers
if modifier_consumable_reroll_artifact == nil then
	modifier_consumable_reroll_artifact = class({})
end
function modifier_consumable_reroll_artifact:OnCreated(params)
	if IsServer() then
	end
end
function modifier_consumable_reroll_artifact:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_consumable_reroll_artifact:OnDestroy()
	if IsServer() then
	end
end
function modifier_consumable_reroll_artifact:DeclareFunctions()
	return {
	}
end