LinkLuaModifier("modifier_druid_3", "abilities/tower/druid/druid_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if druid_3 == nil then
	druid_3 = class({})
end
function druid_3:GetIntrinsicModifierName()
	return "modifier_druid_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_druid_3 == nil then
	modifier_druid_3 = class({}, nil, eom_modifier)
end
function modifier_druid_3:IsHidden()
	return true
end
function modifier_druid_3:OnCreated(params)
	if IsServer() then
		local hBear = self:GetParent():GetBear()
		if hBear and not hBear:HasAbility("druid_5") then
			hBear:AddAbility("druid_5"):SetLevel(1)
		end
	end
end
function modifier_druid_3:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
		EMDF_EVENT_ON_IN_BATTLE,
	}
end
function modifier_druid_3:OnDeath()
	if IsServer() then
		if self:GetStackCount() >= 1 then
			local hBear = self:GetParent():GetBear()
			if hBear then
				self:SetStackCount(0)
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_spiritlink_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:SetParticleControl(iParticleID, 1, hBear:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(iParticleID)
				self:GetParent():GetBuilding():RespawnBuildingUnit()
				hBear:ForceKill(false)
			end
		end
	end
end
function modifier_druid_3:OnInBattle()
	self:SetStackCount(1)
end