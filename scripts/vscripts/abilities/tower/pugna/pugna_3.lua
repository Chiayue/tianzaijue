LinkLuaModifier("modifier_pugna_3", "abilities/tower/pugna/pugna_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if pugna_3 == nil then
	pugna_3 = class({iBehavior=DOTA_ABILITY_BEHAVIOR_NO_TARGET}, nil, ability_base_ai)
end
function pugna_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local fDuration = self:GetDuration()
	local extra_targets = self:GetSpecialValueFor("extra_targets")
	local radius = self:GetSpecialValueFor("radius")

	hCaster:AddNewModifier(hCaster, self, "modifier_pugna_3", {duration=fDuration})

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self, FIND_ANY_ORDER)
	table.sort(tTargets, function(a, b)
		return (a.IsBuilding and a:IsBuilding()) and not (b.IsBuilding and b:IsBuilding())
	end)
	local iCount = 0
	for _, hTarget in pairs(tTargets) do
		if hTarget ~= hCaster then
			hTarget:AddNewModifier(hCaster, self, "modifier_pugna_3", {duration=fDuration})

			iCount = iCount + 1
			if iCount >= extra_targets then
				break
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_pugna_3 == nil then
	modifier_pugna_3 = class({}, nil, eom_modifier)
end
function modifier_pugna_3:IsHidden()
	return false
end
function modifier_pugna_3:IsDebuff()
	return false
end
function modifier_pugna_3:IsPurgable()
	return true
end
function modifier_pugna_3:IsPurgeException()
	return true
end
function modifier_pugna_3:IsStunDebuff()
	return false
end
function modifier_pugna_3:AllowIllusionDuplicate()
	return false
end
function modifier_pugna_3:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end
function modifier_pugna_3:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_pugna_3:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_pugna_3:StatusEffectPriority()
	return 10
end
function modifier_pugna_3:OnCreated(params)
	self.physical_damage_reduction = self:GetAbilitySpecialValueFor("physical_damage_reduction")
	self.magical_attack_per_mana = self:GetAbilitySpecialValueFor("magical_attack_per_mana")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Pugna.Decrepify")
	end
end
function modifier_pugna_3:OnRefresh(params)
	self.physical_damage_reduction = self:GetAbilitySpecialValueFor("physical_damage_reduction")
	self.magical_attack_per_mana = self:GetAbilitySpecialValueFor("magical_attack_per_mana")
end
function modifier_pugna_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_pugna_3:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_INCOMING_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_pugna_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_pugna_3:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetPhysicalIncomingPercentage()
	elseif self._tooltip == 2 then
		return self:GetMagicalAttackBonus()
	end
end
function modifier_pugna_3:GetPhysicalIncomingPercentage()
	return -self.physical_damage_reduction
end
function modifier_pugna_3:GetMagicalAttackBonus()
	local hCaster = self:GetCaster()
	if IsValid(hCaster) then
		return hCaster:GetMaxMana() * self.magical_attack_per_mana
	end
	return 0
end
function modifier_pugna_3:OnBattleEnd()
	self:Destroy()
end