LinkLuaModifier("modifier_ogre_magi_2_buff", "abilities/tower/ogre_magi/ogre_magi_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if ogre_magi_2 == nil then
	ogre_magi_2 = class({}, nil, ability_base_ai)
end
function ogre_magi_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_ogre_magi_2_buff", nil)
	hCaster:EmitSound("Greevil.Bloodlust.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_ogre_magi_2_buff == nil then
	modifier_ogre_magi_2_buff = class({}, nil, eom_modifier)
end
function modifier_ogre_magi_2_buff:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	if IsServer() then
		self:SetStackCount(self.attack_count)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 3, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_ogre_magi_2_buff:OnRefresh(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	if IsServer() then
		self:SetStackCount(self.attack_count)
	end
end
function modifier_ogre_magi_2_buff:EDeclareFunctions()
	return {
		-- EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		-- EMDF_ATTACKT_SPEED_BONUS,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_ogre_magi_2_buff:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		self:DecrementStackCount()
		if self:GetStackCount() == 0 then
			self:Destroy()
		end
	end
end
function modifier_ogre_magi_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_ogre_magi_2_buff:OnTooltip()
		return self:GetStackCount()
end