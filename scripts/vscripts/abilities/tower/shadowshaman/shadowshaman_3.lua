LinkLuaModifier( "modifier_shadowshaman_3", "abilities/tower/shadowshaman/shadowshaman_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if shadowshaman_3 == nil then
	shadowshaman_3 = class({})
end
function shadowshaman_3:GetIntrinsicModifierName()
	return "modifier_shadowshaman_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shadowshaman_3 == nil then
	modifier_shadowshaman_3 = class({}, nil, BaseModifier)
end
function modifier_shadowshaman_3:IsHidden()
	return true
end
function modifier_shadowshaman_3:OnCreated(params)
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_shadowshaman_3:OnRefresh(params)
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_shadowshaman_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_shadowshaman_3:OnTakeDamage(params)
	if params.attacker == self:GetParent() then
		local flHealAmount = params.damage * self.heal_pct * 0.01
		local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			hUnit:Heal(flHealAmount, self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hUnit, flHealAmount, nil)
		end
	end
end