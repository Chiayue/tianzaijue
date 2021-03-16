LinkLuaModifier("modifier_omniknight_4", "abilities/boss/omniknight_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if omniknight_4 == nil then
	omniknight_4 = class({})
end
function omniknight_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local flNearDistance = self:GetSpecialValueFor("near_range")
	local flDamageNear = self:GetSpecialValueFor("damage_near")
	local flDamageFar = self:GetSpecialValueFor("damage_far")
	local flDuration = self:GetSpecialValueFor("stun_duration")
	local flDistance = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D()
	if flDistance > flNearDistance then
		hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, flDuration)
		hCaster:DealDamage(hTarget, self, flDamageNear)
	else
		hCaster:DealDamage(hTarget, self, flDamageNear)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_4.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(125, 125, 125))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_Omniknight.Purification")
end
function omniknight_4:GetIntrinsicModifierName()
	return "modifier_omniknight_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_4 == nil then
	modifier_omniknight_4 = class({}, nil, BaseModifier)
end
function modifier_omniknight_4:IsHidden()
	return true
end
function modifier_omniknight_4:OnCreated(params)
	self.active_range = self:GetAbilitySpecialValueFor("active_range")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_omniknight_4:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local hAbility = hParent:FindAbilityByName("omniknight_1")
		if IsValid(hAbility) and IsValid(hAbility.hLinkTarget) and (hAbility.hLinkTarget:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D() < self.active_range then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, hAbility.hLinkTarget, self:GetAbility())
		end
	end
end