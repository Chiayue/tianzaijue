LinkLuaModifier( "modifier_omniknight_2", "abilities/boss/omniknight_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_omniknight_2_motion", "abilities/boss/omniknight_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if omniknight_2 == nil then
	omniknight_2 = class({})
end
function omniknight_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vDirection = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	local flDistance = self:GetSpecialValueFor("front_distance")
	hTarget:AddNewModifier(hCaster, self, "modifier_omniknight_2_motion", {vPosition = hCaster:GetAbsOrigin() + vDirection * flDistance})
	-- sound
	hCaster:EmitSound("Hero_EarthSpirit.Petrify")
end
function omniknight_2:GetIntrinsicModifierName()
	return "modifier_omniknight_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_2 == nil then
	modifier_omniknight_2 = class({}, nil, BaseModifier)
end
function modifier_omniknight_2:IsHidden()
	return true
end
function modifier_omniknight_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_omniknight_2:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local hAbility = hParent:FindAbilityByName("omniknight_1")
		if IsValid(hAbility) and IsValid(hAbility.hLinkTarget) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, hAbility.hLinkTarget, self:GetAbility())
		else
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
			if IsValid(tTargets[1]) then
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, tTargets[1], self:GetAbility())
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_omniknight_2_motion == nil then
	modifier_omniknight_2_motion = class({}, nil, HorizontalModifier)
end
function modifier_omniknight_2_motion:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_omniknight_2_motion:OnCreated(params)
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage_distance_factor = self:GetAbilitySpecialValueFor("damage_distance_factor")

	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
		
		self.vOrigin = self:GetParent():GetAbsOrigin()
		self.vPosition = StringToVector(params.vPosition)
		self.flDistance = (self.vPosition - self.vOrigin):Length2D()
		self.vDirection = (self.vPosition - self.vOrigin):Normalized()
		
		self:GetParent():EmitSound("Hero_StormSpirit.ElectricVortex")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omniknight_2_motion:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
		local flDamage = self.base_damage + self.damage_distance_factor * self.flDistance
		self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), flDamage)
	end
end
function modifier_omniknight_2_motion:OnHorizontalMotionInterrupted()
	self:Destroy()
end
function modifier_omniknight_2_motion:UpdateHorizontalMotion(me, dt)
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local vPos = hParent:GetAbsOrigin()

	if (vPos - self.vOrigin):Length2D() >= self.flDistance then
		FindClearSpaceForUnit(hParent, self.vPosition, true)
		self:Destroy()
		return
	end

	vPos = vPos + self.vDirection * self.speed * dt

	hParent:SetAbsOrigin(vPos)
end
function modifier_omniknight_2_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_omniknight_2_motion:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end