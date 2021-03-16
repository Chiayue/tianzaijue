LinkLuaModifier("modifier_sp_manaregen", "abilities/spell/sp_manaregen.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_manaregen == nil then
	sp_manaregen = class({}, nil, sp_base)
end
function sp_manaregen:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_manaregen", nil)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_manaregen == nil then
	modifier_sp_manaregen = class({}, nil, eom_modifier)
end
function modifier_sp_manaregen:IsHidden()
	return true
end
function modifier_sp_manaregen:IsDebuff()
	return false
end
function modifier_sp_manaregen:IsPurgable()
	return false
end
function modifier_sp_manaregen:IsPurgeException()
	return false
end
function modifier_sp_manaregen:IsStunDebuff()
	return false
end
function modifier_sp_manaregen:RemoveOnDeath()
	return false
end
function modifier_sp_manaregen:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_sp_manaregen:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end