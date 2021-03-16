LinkLuaModifier("modifier_huskar_2", "abilities/tower/huskar/huskar_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_2_buff", "abilities/tower/huskar/huskar_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if huskar_2 == nil then
	huskar_2 = class({}, nil, ability_base_ai)
end
function huskar_2:Spawn()
	self.tIllusion = {}
end
function huskar_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hp_deduce = self:GetSpecialValueFor("hp_deduce")
	local radius = self:GetSpecialValueFor("radius")

	hCaster:ModifyHealth(hCaster:GetHealth() * (1-hp_deduce*0.01), nil, false, 0)

	local hIllusion = CreateIllusion(hCaster, hCaster:GetAbsOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber(), self:GetDuration(), self:GetSpecialValueFor("damage_pct"), 100)
	if IsValid(hIllusion) then
		table.insert(self.tIllusion, hIllusion)
		hIllusion:SetControllableByPlayer(-1, false)
		local iBonusAttackRange = 
		hIllusion:AddNewModifier(hCaster, self, "modifier_huskar_2_buff", nil)
		hIllusion:AddNewModifier(hCaster, nil, "modifier_building_ai", nil)
		hIllusion:SetAcquisitionRange(3000)
	end

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in ipairs(tTargets) do
		hCaster:KnockBack(hCaster:GetAbsOrigin(), hUnit, math.abs(radius - CalculateDistance(hCaster, hUnit)), 0, 0.5, false)
		hCaster:DealDamage(hUnit, self)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Huskar.Inner_Fire.Cast")
end
function huskar_2:GetIntrinsicModifierName()
	return "modifier_huskar_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_huskar_2 == nil then
	modifier_huskar_2 = class({}, nil, eom_modifier)
end
function modifier_huskar_2:IsHidden()
	return true
end
function modifier_huskar_2:OnCreated(params)
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	if IsServer() then
	end
end
function modifier_huskar_2:OnRefresh(params)
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
end
function modifier_huskar_2:EDeclareFunctions()
	return {
		EMDF_INCOMING_PERCENTAGE
	}
end
function modifier_huskar_2:GetIncomingPercentage(params)
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end

	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:IsIllusion() then return end
	if not IsValid(hAbility) then return end

	local tIllusion = hAbility.tIllusion

	for i = #tIllusion, 1, -1 do
		local hIllusion = tIllusion[i]
		if not IsValid(hIllusion) or not hIllusion:IsAlive() then
			table.remove(tIllusion, i)
		end
	end

	local iIllusionCount = #tIllusion
	if iIllusionCount > 0 then
		local fDamage = params.damage * self.damage_reduce_pct*0.01 / iIllusionCount
		for _, hIllusion in ipairs(tIllusion) do
			params.attacker:DealDamage(hIllusion, params.inflictor, fDamage, params.damage_type, params.damage_flags+DOTA_DAMAGE_FLAG_HPLOSS)
		end
		return -self.damage_reduce_pct
	end
end
---------------------------------------------------------------------
if modifier_huskar_2_buff == nil then
	modifier_huskar_2_buff = class({}, nil, eom_modifier)
end
function modifier_huskar_2_buff:OnCreated(params)
	local hCaster = self:GetCaster()
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.fAttackRange = hCaster:Script_GetAttackRange()
end
function modifier_huskar_2_buff:OnRefresh(params)
	local hCaster = self:GetCaster()
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.fAttackRange = hCaster:Script_GetAttackRange()
end
function modifier_huskar_2_buff:OnDestroy()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			ArrayRemove(self:GetAbility().tIllusion, self:GetParent())
		end
	end
end
function modifier_huskar_2_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
function modifier_huskar_2_buff:EDeclareFunctions()
	return {
		EMDF_ATTACK_RANGE_OVERRIDE,
		EMDF_INCOMING_PERCENTAGE,
	}
end
function modifier_huskar_2_buff:GetAttackRangeOverride()
	local hCaster = self:GetCaster()
	if IsValid(hCaster) then
		self.fAttackRange = hCaster:Script_GetAttackRange()
	end
	return self.fAttackRange
end
function modifier_huskar_2_buff:GetIncomingPercentage(params)
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end

	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if not IsValid(hAbility) then return end

	local tIllusion = hAbility.tIllusion

	for i = #tIllusion, 1, -1 do
		local hIllusion = tIllusion[i]
		if not IsValid(hIllusion) or not hIllusion:IsAlive() then
			table.remove(tIllusion, i)
		end
	end

	local iIllusionCount = #tIllusion - 1
	if IsValid(hCaster) and hCaster:IsAlive() then
		iIllusionCount = iIllusionCount + 1
	end
	if iIllusionCount > 0 then
		local fDamage = params.damage * self.damage_reduce_pct*0.01 / iIllusionCount
		for _, hIllusion in ipairs(tIllusion) do
			if hIllusion ~= hParent then
				params.attacker:DealDamage(hIllusion, params.inflictor, fDamage, params.damage_type, params.damage_flags+DOTA_DAMAGE_FLAG_HPLOSS)
			end
		end
		if IsValid(hCaster) and hCaster:IsAlive() then
			params.attacker:DealDamage(hCaster, params.inflictor, fDamage, params.damage_type, params.damage_flags+DOTA_DAMAGE_FLAG_HPLOSS)
		end
		return -self.damage_reduce_pct
	end
end