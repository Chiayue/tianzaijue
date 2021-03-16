LinkLuaModifier("modifier_sp_cooldown", "abilities/spell/sp_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_cooldown == nil then
	sp_cooldown = class({}, nil, sp_base)
end
function sp_cooldown:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_cooldown", nil)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_cooldown == nil then
	modifier_sp_cooldown = class({}, nil, eom_modifier)
end
function modifier_sp_cooldown:IsHidden()
	return true
end
function modifier_sp_cooldown:IsDebuff()
	return false
end
function modifier_sp_cooldown:IsPurgable()
	return false
end
function modifier_sp_cooldown:IsPurgeException()
	return false
end
function modifier_sp_cooldown:IsStunDebuff()
	return false
end
function modifier_sp_cooldown:RemoveOnDeath()
	return false
end
function modifier_sp_cooldown:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_sp_cooldown:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end