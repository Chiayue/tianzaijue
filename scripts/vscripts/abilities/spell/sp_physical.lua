LinkLuaModifier("modifier_sp_physical", "abilities/spell/sp_physical.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_physical == nil then
	sp_physical = class({}, nil, sp_base)
end
function sp_physical:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_physical", nil)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_physical == nil then
	modifier_sp_physical = class({}, nil, eom_modifier)
end
function modifier_sp_physical:IsHidden()
	return true
end
function modifier_sp_physical:IsDebuff()
	return false
end
function modifier_sp_physical:IsPurgable()
	return false
end
function modifier_sp_physical:IsPurgeException()
	return false
end
function modifier_sp_physical:IsStunDebuff()
	return false
end
function modifier_sp_physical:RemoveOnDeath()
	return false
end
function modifier_sp_physical:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_sp_physical:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end