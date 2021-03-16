LinkLuaModifier("modifier_sp_hpregen", "abilities/spell/sp_hpregen.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_hpregen == nil then
	sp_hpregen = class({}, nil, sp_base)
end
function sp_hpregen:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_hpregen", nil)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_hpregen == nil then
	modifier_sp_hpregen = class({}, nil, eom_modifier)
end
function modifier_sp_hpregen:IsHidden()
	return true
end
function modifier_sp_hpregen:IsDebuff()
	return false
end
function modifier_sp_hpregen:IsPurgable()
	return false
end
function modifier_sp_hpregen:IsPurgeException()
	return false
end
function modifier_sp_hpregen:IsStunDebuff()
	return false
end
function modifier_sp_hpregen:RemoveOnDeath()
	return false
end
function modifier_sp_hpregen:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_sp_hpregen:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end