--[[参数
	center_x,
	center_y,
	center_z,
	should_stun,
	duration,
	knockback_duration,
	knockback_distance,
	knockback_height,
]]
--击退
if modifier_knockback == nil then
	modifier_knockback = class({})
end
function modifier_knockback:IsHidden()
	return true
end
function modifier_knockback:OnCreated(params)
	self.knockback_distance = self:GetAbilitySpecialValueFor("knockback_distance")
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		local vDirection = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		vDirection.z = 0
		local iDis = self.knockback_distance - vDirection:Length2D()
		self.vVelocity = vDirection:Normalized() * iDis / self:GetDuration()
		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire_push.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		self:AddParticle(particleID, false, false, -1, false, false)
	end
end
function modifier_knockback:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():StartGesture(ACT_DOTA_FORCESTAFF_END)
	end
end
function modifier_knockback:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin() + self.vVelocity * dt)
		-- GridNav:DestroyTreesAroundPoint(me:GetAbsOrigin(), me:GetHullRadius(), true)
	end
end
function modifier_knockback:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_knockback:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_knockback:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end