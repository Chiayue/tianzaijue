LinkLuaModifier("modifier_lich_3", "abilities/tower/lich/lich_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_3_buff", "abilities/tower/lich/lich_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lich_3 == nil then
	lich_3 = class({})
end
function lich_3:Precache(context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_staff_lvlup_globe.vpcf", context)
end
function lich_3:GetIntrinsicModifierName()
	return "modifier_lich_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_lich_3 == nil then
	modifier_lich_3 = class({}, nil, eom_modifier)
end
function modifier_lich_3:IsHidden()
	return true
end
function modifier_lich_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,

	}
end
function modifier_lich_3:OnInBattle()
	if self:GetParent():PassivesDisabled() then return end
	local hParent = self:GetParent()
	EachUnits(GetPlayerID(hParent), function(hUnit)
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_lich_3_buff", nil)
	end, UnitType.AllFirends)
end
---------------------------------------------------------------------
if modifier_lich_3_buff == nil then
	modifier_lich_3_buff = class({}, nil, eom_modifier)
end
function modifier_lich_3_buff:IsHidden()
	return true
end
function modifier_lich_3_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.regen_pct = self:GetAbilitySpecialValueFor("regen_pct")
	if IsServer() then
	end
end
function modifier_lich_3_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] = { self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_lich_3_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_lich_3_buff:OnAbilityFullyCast()
	if RollPercentage(self.chance) then
		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self.regen_pct * 0.01)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_staff_lvlup_globe.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(1, 1, 1))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end