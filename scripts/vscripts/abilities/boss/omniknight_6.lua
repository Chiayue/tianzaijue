LinkLuaModifier( "modifier_omniknight_6", "abilities/boss/omniknight_6.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if omniknight_6 == nil then
	omniknight_6 = class({})
end
function omniknight_6:OnChannelFinish(bInterrupted)
	if bInterrupted == false then
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()
		local vPosition = hTarget:GetAbsOrigin()
		-- 交换位置
		FindClearSpaceForUnit(hTarget, hCaster:GetAbsOrigin(), true)
		FindClearSpaceForUnit(hCaster, vPosition, true)
		-- hTarget:SetAbsOrigin(hCaster:GetAbsOrigin())
		-- hCaster:SetAbsOrigin(vPosition)
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		for i = 1, hCaster:GetAbilityCount() do
			local hAbility = hCaster:GetAbilityByIndex(i)
			if IsValid(hAbility) and hAbility ~= self then
				hAbility:EndCooldown()
			end
		end
	end
end
function omniknight_6:GetIntrinsicModifierName()
	return "modifier_omniknight_6"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_6 == nil then
	modifier_omniknight_6 = class({}, nil, BaseModifier)
end
function modifier_omniknight_6:IsHidden()
	return true
end
function modifier_omniknight_6:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_omniknight_6:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) and hParent:GetHealthPercent() <= self.trigger_pct then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 2000, self:GetAbility(), FIND_FARTHEST)
		-- 此技能不会以连接单位为目标
		local hAbility = hParent:FindAbilityByName("omniknight_1")
		if IsValid(hAbility) and IsValid(hAbility.hLinkTarget) then
			ArrayRemove(tTargets, hAbility.hLinkTarget)
		end

		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, tTargets[1], self:GetAbility())
		end
	end
end