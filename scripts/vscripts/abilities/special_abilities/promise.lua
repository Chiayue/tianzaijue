LinkLuaModifier("modifier_promise", "abilities/special_abilities/promise.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if promise == nil then
	promise = class({})
end
function promise:GetIntrinsicModifierName()
	return "modifier_promise"
end
---------------------------------------------------------------------
--Modifiers
if modifier_promise == nil then
	modifier_promise = class({}, nil, eom_modifier)
end
function modifier_promise:OnCreated(params)
	self.physical_incoming_percentage = self:GetAbilitySpecialValueFor("physical_incoming_percentage")
	if IsServer() then
	end
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/modifier_promise.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 1, false, false)
	end
end
function modifier_promise:OnRefresh(params)
	self.physical_incoming_percentage = self:GetAbilitySpecialValueFor("physical_incoming_percentage")
	if IsServer() then
	end
end
function modifier_promise:OnDestroy()
	if IsServer() then
	end
end
function modifier_promise:CheckState()
	return {
	-- [MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end
function modifier_promise:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_INCOMING_PERCENTAGE] = -1000,
		[EMDF_PHYSICAL_INCOMING_PERCENTAGE] = self.physical_incoming_percentage
	}
end
function modifier_promise:GetMagicalIncomingPercentage()
	return -1000
end
function modifier_promise:GetPhysicalIncomingPercentage()
	return self.physical_incoming_percentage
end