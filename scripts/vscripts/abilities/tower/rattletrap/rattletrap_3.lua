LinkLuaModifier("modifier_rattletrap_3", "abilities/tower/rattletrap/rattletrap_3.lua", LUA_MODIFIER_MOTION_NONE)
if rattletrap_3 == nil then
	rattletrap_3 = class({})
end
function rattletrap_3:GetIntrinsicModifierName()
	return "modifier_rattletrap_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_rattletrap_3 == nil then
	modifier_rattletrap_3 = class({}, nil, eom_modifier)
end
function modifier_rattletrap_3:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_rattletrap_3:OnCreated(params)
	self.armor_per_stack = self:GetAbilitySpecialValueFor("armor_per_stack")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	self.count = self:GetAbilitySpecialValueFor("count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.armor_factor = self:GetAbilitySpecialValueFor("armor_factor")
end
function modifier_rattletrap_3:OnRefresh(params)
	self.armor_per_stack = self:GetAbilitySpecialValueFor("armor_per_stack")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	self.count = self:GetAbilitySpecialValueFor("count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.armor_factor = self:GetAbilitySpecialValueFor("armor_factor")
end
function modifier_rattletrap_3:Refresh()
	self:SetStackCount(self.max_stack)
end
function modifier_rattletrap_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ARMOR_BONUS,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent()}
	}
end
function modifier_rattletrap_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_rattletrap_3:OnTooltip()
	return self.armor_per_stack * self:GetStackCount()
end
function modifier_rattletrap_3:OnTakeDamage(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		self:DecrementStackCount()
		local flDamage = self.armor_factor * hParent:GetVal(ATTRIBUTE_KIND.PhysicalArmor) * 0.01
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		for i = 1, math.min(#tTargets, self.count) do
			hParent:DealDamage(tTargets[i], hAbility, flDamage)
			tTargets[i]:AddBuff(hParent, BUFF_TYPE.STUN, 0.1)
			-- 弹片特效
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", PATTACH_CENTER_FOLLOW, hParent)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, tTargets[i], PATTACH_POINT_FOLLOW, "attach_hitloc", tTargets[i]:GetAbsOrigin(), false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			-- sound
			hParent:EmitSound("Hero_Rattletrap.Battery_Assault_Launch")
		end
	end
end
function modifier_rattletrap_3:OnInBattle()
	self:SetStackCount(self.max_stack)
end
function modifier_rattletrap_3:OnBattleEnd()
	self:SetStackCount(0)
end
function modifier_rattletrap_3:GetPhysicalArmorBonus()
	return self.armor_per_stack * self:GetStackCount()
end