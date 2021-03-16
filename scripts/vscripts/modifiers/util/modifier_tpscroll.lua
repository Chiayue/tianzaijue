if modifier_tpscroll == nil then
	modifier_tpscroll = class({})
end
local public = modifier_tpscroll
function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		self.vPosition = Vector(params.x, params.y, params.z)
		self.bFindClear = tonumber(params.find_clear) == 1

		local vPosition = self.vPosition
		local vColor = Vector(255, 255, 255) / 255

		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 2, vColor)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
		ParticleManager:SetParticleControl(iParticleID, 2, vColor)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_ABSORIGIN, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 4, Vector(0, 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 5, vPosition)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		-- hParent:EmitSound("Portal.Loop_Disappear")
		-- StartSoundEventFromPosition("Portal.Loop_Appear", vPosition)
		-- EmitSoundOn("Portal.Loop_Appear", hParent)
	else
	end
end
function public:OnRemoved()
	local hParent = self:GetParent()
	if IsServer() then
		-- StopGlobalSound("Portal.Loop_Appear")
		-- StopSoundOn("Portal.Loop_Appear", hParent)
		local vPosition = self.vPosition
		if IsValid(hParent) then
			-- hParent:StopSound("Portal.Loop_Disappear")
			EmitSoundOnLocationWithCaster(hParent:GetAbsOrigin(), "Portal.Hero_Disappear", hParent)

			if self.bFindClear then
				FindClearSpaceForUnit(hParent, vPosition, true)
			else
				hParent:SetAbsOrigin(vPosition)
			end
			hParent:FireTeleported(vPosition)

			EmitSoundOnLocationWithCaster(vPosition, "Portal.Hero_Appear", hParent)
		end
	end
end
function public:OnDestroy()
	if IsServer() then
		-- StopGlobalSound("Portal.Loop_Appear")
		-- StopSoundOn("Portal.Loop_Appear", hParent)
	end
end
function public:CheckState()
	return {
		-- [MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
end
function public:GetOverrideAnimation(params)
	return ACT_DOTA_TELEPORT
end
function public:GetOverrideAnimationRate(params)
	return 1
end