LinkLuaModifier("modifier_immortal", "abilities/special_abilities/immortal.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immortal_effect", "abilities/special_abilities/immortal.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if immortal == nil then
	immortal = class({})
end
function immortal:GetIntrinsicModifierName()
	return "modifier_immortal"
end
---------------------------------------------------------------------
--Modifiers
if modifier_immortal == nil then
	modifier_immortal = class({}, nil, eom_modifier)
end
function modifier_immortal:OnCreated(params)
	self.respawn_pct = self:GetAbilitySpecialValueFor("respawn_pct")
	if IsServer() then
	end
end
function modifier_immortal:OnRefresh(params)
	self.respawn_pct = self:GetAbilitySpecialValueFor("respawn_pct")
	if IsServer() then
	end
end
function modifier_immortal:OnDestroy()
	if IsServer() then
	end
end
function modifier_immortal:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_immortal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_immortal:GetMinHealth()
	return 1
end
function modifier_immortal:OnTakeDamage(params)
	if params.unit ~= self:GetParent()
	or params.attacker == self:GetParent() then
		return
	end
	local damage = params.damage
	if damage < self:GetParent():GetHealth() then
		return
	end

	local iRdm = RandomInt(0, 100)
	if iRdm < self.respawn_pct then
		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immortal_effect", { duration = 2 })
	end
end

------------------------------------------------------------------------------
if modifier_immortal_effect == nil then
	modifier_immortal_effect = class({}, nil, eom_modifier)
end
function modifier_immortal_effect:OnCreated(params)
	if IsServer() then

	end
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_spotlight.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end
function modifier_immortal_effect:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_immortal_effect:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_immortal_effect:DeclareFunctions()
	return {
	}
end
function modifier_immortal_effect:CheckState()
	return {
	}
end