LinkLuaModifier("modifier_mirana_3_moonlight", "abilities/tower/mirana/mirana_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mirana_3_buff", "abilities/tower/mirana/mirana_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if mirana_3 == nil then
	mirana_3 = class({}, nil, ability_base_ai)
end
function mirana_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor('duration')
	hCaster:AddNewModifier(hCaster, self, 'modifier_mirana_3_moonlight', { duration = duration })
end
--Modifiers
if modifier_mirana_3_moonlight == nil then
	modifier_mirana_3_moonlight = class({}, nil, eom_modifier)
end
function modifier_mirana_3_moonlight:IsAura()
	return true
end
function modifier_mirana_3_moonlight:IsHidden()
	return true
end
function modifier_mirana_3_moonlight:GetAuraRadius()
	return self.radius
end
function modifier_mirana_3_moonlight:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_mirana_3_moonlight:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_mirana_3_moonlight:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_mirana_3_moonlight:GetModifierAura()
	return "modifier_mirana_3_buff"
end
function modifier_mirana_3_moonlight:OnCreated(params)
	if IsServer() then
		self.radius = self:GetAbilitySpecialValueFor("radius")
	else
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iParticleID = ParticleManager:CreateParticle("particles/econ/events/ti10/agh_aura_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
			local iParticleI = ParticleManager:CreateParticle("particles/units/heroes/mirana/mirana_3_light.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleI, 0, self:GetParent():GetAbsOrigin())
			self:AddParticle(iParticleID, false, false, -1, false, false)
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_mirana_3_moonlight:OnRefresh(params)
	if IsServer() then
		self.radius = self:GetAbilitySpecialValueFor("radius")
	end
end
---------------------------------------------------------------------
if modifier_mirana_3_buff == nil then
	modifier_mirana_3_buff = class({}, nil, BaseModifier)
end
function modifier_mirana_3_buff:IsDebuff()
	return false
end
function modifier_mirana_3_buff:OnCreated()
	self.manacost_reduce = self:GetAbilitySpecialValueFor("manacost_reduce")
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/mirana/mirana_3_moonset.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
			self:AddParticle(iParticleID, false, false, -1, false, false)
			return iParticleID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end

end
function modifier_mirana_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_mirana_3_buff:GetModifierPercentageManacostStacking()
	return self.manacost_reduce
end
function modifier_mirana_3_buff:OnTooltip()
	return self.manacost_reduce
end