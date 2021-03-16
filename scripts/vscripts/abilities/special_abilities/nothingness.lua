LinkLuaModifier("modifier_nothingness", "abilities/special_abilities/nothingness.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if nothingness == nil then
	nothingness = class({})
end
function nothingness:GetIntrinsicModifierName()
	return "modifier_nothingness"
end
---------------------------------------------------------------------
--Modifiers
if modifier_nothingness == nil then
	modifier_nothingness = class({}, nil, eom_modifier)
end
function modifier_nothingness:OnCreated(params)
	self.magical_incoming_percentage = self:GetAbilitySpecialValueFor("magical_incoming_percentage")
	if IsServer() then
	end
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/items_fx/ghost.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_ghost.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_nothingness:OnRefresh(params)
	self.magical_incoming_percentage = self:GetAbilitySpecialValueFor("magical_incoming_percentage")
	if IsServer() then
	end
end
function modifier_nothingness:OnDestroy()
	if IsServer() then
	end
end
function modifier_nothingness:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
end
function modifier_nothingness:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_INCOMING_PERCENTAGE] = self.magical_incoming_percentage,
		[EMDF_PHYSICAL_INCOMING_PERCENTAGE] = -1000
	}
end
function modifier_nothingness:GetMagicalIncomingPercentage()
	return self.magical_incoming_percentage
end
function modifier_nothingness:GetPhysicalIncomingPercentage()
	return -1000
end