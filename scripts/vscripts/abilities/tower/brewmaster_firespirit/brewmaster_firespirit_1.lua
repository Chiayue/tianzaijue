LinkLuaModifier("modifier_brewmaster_firespirit_1_thinker", "abilities/tower/brewmaster_firespirit/brewmaster_firespirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_firespirit_3_debuff", "abilities/tower/brewmaster_firespirit/brewmaster_firespirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if brewmaster_firespirit_1 == nil then
	brewmaster_firespirit_1 = class({iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET}, nil, ability_base_ai)
end
function brewmaster_firespirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	self.hThinker = CreateModifierThinker(hCaster, self, "modifier_brewmaster_firespirit_1_thinker", {duration = self:GetDuration()}, vPosition, hCaster:GetTeamNumber(), false)
	-- 2技能
	local hAbility = hCaster:FindAbilityByName("brewmaster_firespirit_2")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self:GetSpecialValueFor("radius"), self)
		hAbility:Action(vPosition, tTargets)
	end
end
function brewmaster_firespirit_1:OnChannelFinish(bInterrupted)
	self.hThinker:RemoveModifierByName("modifier_brewmaster_firespirit_1_thinker")
end
---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_firespirit_1_thinker == nil then
	modifier_brewmaster_firespirit_1_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_brewmaster_firespirit_1_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.mana_cost = self:GetAbilitySpecialValueFor("mana_cost")
	self.ignite_duration = self:GetAbilitySpecialValueFor("ignite_duration")
	self.iCount = self:GetAbilitySpecialValueFor("ignite_count")
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/brewmaster_firespirit_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_brewmaster_firespirit_1_thinker:OnIntervalThink()
	if not IsValid(self:GetCaster()) then
		self:Destroy()
		return
	end
	local hAbility = self:GetAbility()
	local hCaster = hAbility:GetCaster()
	local tTargets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		local damageInfo =		{
			victim = hUnit,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility,
		}
		ApplyDamage(damageInfo)

		hUnit:AddBuff(hCaster, BUFF_TYPE.IGNITE, self.ignite_duration, true, { iCount = self.iCount})

		local hAbility_3 = self:GetCaster():FindAbilityByName("brewmaster_firespirit_3")
		local bReduce = (IsValid(hAbility_3) and hAbility_3:GetLevel() > 0) and true or false
		if bReduce then
			hUnit:AddNewModifier(self:GetCaster(), hAbility_3, "modifier_brewmaster_firespirit_3_debuff", { duration = 1 })
		end
	end
end