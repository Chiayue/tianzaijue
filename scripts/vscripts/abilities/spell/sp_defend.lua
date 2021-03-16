LinkLuaModifier("modifier_sp_defend", "abilities/spell/sp_defend.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_defend == nil then
	sp_defend = class({}, nil, sp_base)
end
function sp_defend:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_defend", nil)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_defend == nil then
	modifier_sp_defend = class({}, nil, eom_modifier)
end
function modifier_sp_defend:IsHidden()
	return true
end
function modifier_sp_defend:IsDebuff()
	return false
end
function modifier_sp_defend:IsPurgable()
	return false
end
function modifier_sp_defend:IsPurgeException()
	return false
end
function modifier_sp_defend:IsStunDebuff()
	return false
end
function modifier_sp_defend:RemoveOnDeath()
	return false
end
function modifier_sp_defend:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_sp_defend:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end