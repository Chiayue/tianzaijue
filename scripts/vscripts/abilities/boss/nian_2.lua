LinkLuaModifier("modifier_nian_2_rush", "abilities/boss/nian_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if nian_2 == nil then
	nian_2 = class({})
end
function nian_2:Precache(context)
	PrecacheResource("particle", "particles/units/boss/nian/nian_2.vpcf", context)
end
function nian_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	return true
end
function nian_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local distance = self:GetSpecialValueFor('distance')
	local speed = self:GetSpecialValueFor('speed')
	local duration = distance / speed
	hCaster:AddNewModifier(hCaster, self, "modifier_nian_2_rush", { duration = duration })
	hCaster:EmitSound("Hero_Magnataur.Skewer.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_nian_2_rush == nil then
	modifier_nian_2_rush = class({})
end
function modifier_nian_2_rush:IsHidden()
	return true
end
function modifier_nian_2_rush:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_nian_2_rush:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_nian_2_rush:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self.distance = self:GetAbilitySpecialValueFor('distance')
		self.fSpeed = self:GetAbilitySpecialValueFor('speed')
		self.vS = self:GetParent():GetAbsOrigin()
		self.vV = self:GetParent():GetForwardVector() * self.fSpeed
		self.radius = self:GetAbilitySpecialValueFor('radius')
		-- self.impact_damage = 100
		self.tTargets = {}
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/nian/nian_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_mouthbase", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_nian_2_rush:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		for _, hUnit in pairs(self.tTargets) do
			FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), true)
		end
		-- 狂暴下接技能
		if self:GetParent():HasModifier("modifier_nian_7_knockdown_rage") then
			local hAbility = self:GetParent():FindAbilityByName("nian_3")
			hAbility:EndCooldown()
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hAbility)
		end
	end
end
function modifier_nian_2_rush:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.distance then
			fDis = self.distance
		end
		if GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), vPos) then
			me:SetAbsOrigin(vPos)
		end

		local tTargets = FindUnitsInRadiusWithAbility(me, vPos, self.radius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				table.insert(self.tTargets, hUnit)
				me:DealDamage(hUnit, self:GetAbility())
			end
			hUnit:SetAbsOrigin(vPos + self:GetParent():GetForwardVector() * 150)
		end

		if fDis == self.distance then
			self:Destroy()
		end
	end
end
function modifier_nian_2_rush:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_nian_2_rush:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_nian_2_rush:GetOverrideAnimation(params)
	return ACT_DOTA_MAGNUS_SKEWER_END
end
function modifier_nian_2_rush:GetOverrideAnimationRate()
	return 1.5
end
function modifier_nian_2_rush:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end