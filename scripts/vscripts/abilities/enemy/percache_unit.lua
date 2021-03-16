LinkLuaModifier( "modifier_percache_unit", "abilities/enemy/percache_unit.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if percache_unit == nil then
	percache_unit = class({})
end
function percache_unit:GetIntrinsicModifierName()
	return "modifier_percache_unit"
end
---------------------------------------------------------------------
--Modifiers
if modifier_percache_unit == nil then
	modifier_percache_unit = class({})
end
function modifier_percache_unit:OnCreated(params)
	if IsServer() then
	end
end
function modifier_percache_unit:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_percache_unit:OnDestroy()
	if IsServer() then
	end
end
function modifier_percache_unit:DeclareFunctions()
	return {
	}
end