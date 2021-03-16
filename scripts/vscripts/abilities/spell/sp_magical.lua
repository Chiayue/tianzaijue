LinkLuaModifier("modifier_sp_magical", "abilities/spell/sp_magical.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_magical == nil then
	sp_magical = class({}, nil, sp_base)
end
function sp_magical:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_magical", nil)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_magical == nil then
	modifier_sp_magical = class({}, nil, eom_modifier)
end
function modifier_sp_magical:IsHidden()
	return true
end
function modifier_sp_magical:IsDebuff()
	return false
end
function modifier_sp_magical:IsPurgable()
	return false
end
function modifier_sp_magical:IsPurgeException()
	return false
end
function modifier_sp_magical:IsStunDebuff()
	return false
end
function modifier_sp_magical:RemoveOnDeath()
	return false
end
function modifier_sp_magical:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_sp_magical:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end