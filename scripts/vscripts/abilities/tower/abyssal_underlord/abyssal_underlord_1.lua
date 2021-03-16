LinkLuaModifier("modifier_abyssal_underlord_1", "abilities/tower/abyssal_underlord/abyssal_underlord_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_1_thinker", "abilities/tower/abyssal_underlord/abyssal_underlord_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_1_debuff", "abilities/tower/abyssal_underlord/abyssal_underlord_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if abyssal_underlord_1 == nil then
	local tInitData = {
		iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET,
	}
	abyssal_underlord_1 = class(tInitData, nil, ability_base_ai)
end
function abyssal_underlord_1:GetIntrinsicModifierName()
	return "modifier_abyssal_underlord_1"
end

function abyssal_underlord_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function abyssal_underlord_1:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	self.iPreParticleID = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", PATTACH_WORLDORIGIN, hCaster)
	ParticleManager:SetParticleControl(self.iPreParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(self.iPreParticleID, 1, Vector(radius, 1, 1))

	hCaster:EmitSound(AssetModifiers:GetSoundReplacement("Hero_AbyssalUnderlord.Firestorm.Cast", hCaster))
	return true
end
function abyssal_underlord_1:OnAbilityPhaseInterrupted()
	if self.iPreParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iPreParticleID, true)
		self.iPreParticleID = nil
	end
end
function abyssal_underlord_1:OnSpellStart()
	if self.iPreParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iPreParticleID, false)
		self.iPreParticleID = nil
	end
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	CreateModifierThinker(hCaster, self, "modifier_abyssal_underlord_1_thinker", nil, vPosition, hCaster:GetTeamNumber(), false)
end

function abyssal_underlord_1:IsHiddenWhenStolen()
	return false
end



-- -----------------------------------------
-- thinker
if modifier_abyssal_underlord_1_thinker == nil then
	modifier_abyssal_underlord_1_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_abyssal_underlord_1_thinker:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local vPosition = hParent:GetAbsOrigin()
	self.wave_interval = self:GetAbilitySpecialValueFor("wave_interval")
	self.wave_count = self:GetAbilitySpecialValueFor("wave_count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.wave_damage = self:GetAbilitySpecialValueFor("damage")
	self.infected_chance = self:GetAbilitySpecialValueFor("infected_chance")

	if IsServer() then
		EmitSoundOnLocationWithCaster(vPosition, AssetModifiers:GetSoundReplacement("Hero_AbyssalUnderlord.Firestorm.Start", hCaster), hCaster)

		self.iCount = 0
		self:StartIntervalThink(self.wave_interval)
		self:OnIntervalThink()
	end
end
function modifier_abyssal_underlord_1_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local vPosition = hParent:GetAbsOrigin()
	if IsServer() then
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end

		self.iCount = self.iCount + 1

		local tTargets = Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), vPosition, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST)
		for n, hTarget in pairs(tTargets) do
			local tDamageTable = {
				ability = hAbility,
				victim = hTarget,
				attacker = hCaster,
				damage = self.wave_damage * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(tDamageTable)
			-- 感染
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_abyssal_underlord_1_debuff", { duration = self.duration })
		end

		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:SetParticleControl(iParticleID, 4, Vector(self.radius, self.radius, self.radius))
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(self.iCount, 0, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)

		EmitSoundOnLocationWithCaster(vPosition, AssetModifiers:GetSoundReplacement("Hero_AbyssalUnderlord.Firestorm", hCaster), hCaster)

		if self.iCount >= self.wave_count then
			self:SetDuration(LOCAL_PARTICLE_MODIFIER_DURATION, true)
			self:StartIntervalThink(-1)
		end
	end
end
---------------------------------------------------------------------
if modifier_abyssal_underlord_1_debuff == nil then
	modifier_abyssal_underlord_1_debuff = class({}, nil, eom_modifier)
end
function modifier_abyssal_underlord_1_debuff:IsHidden()
	return false
end
function modifier_abyssal_underlord_1_debuff:IsDebuff()
	return true
end
function modifier_abyssal_underlord_1_debuff:IsPurgable()
	return true
end
function modifier_abyssal_underlord_1_debuff:IsPurgeException()
	return true
end
function modifier_abyssal_underlord_1_debuff:IsStunDebuff()
	return false
end
function modifier_abyssal_underlord_1_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_abyssal_underlord_1_debuff:OnCreated(params)
	self.infected_damage = self:GetAbilitySpecialValueFor("infected_damage")
	self.infected_time = self:GetAbilitySpecialValueFor("infected_time")
	self.infected_chance = self:GetAbilitySpecialValueFor("infected_chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.wave_damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.fInterval = 1
	if IsServer() then
		self.fTime = 0
		self:StartIntervalThink(self.fInterval)
		self:IncrementStackCount()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		return iParticleID
	end
end
function modifier_abyssal_underlord_1_debuff:OnRefresh(params)
	self.infected_damage = self:GetAbilitySpecialValueFor("infected_damage")
	self.infected_time = self:GetAbilitySpecialValueFor("infected_time")
	self.infected_chance = self:GetAbilitySpecialValueFor("infected_chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.wave_damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_abyssal_underlord_1_debuff:OnIntervalThink(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if IsValid(hCaster) and IsValid(hParent) and IsValid(hAbility) then
			ApplyDamage({
				ability = self,
				victim = hParent,
				attacker = hCaster,
				damage = self.infected_damage * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01 * self:GetStackCount() * self.fInterval,
				damage_type = DAMAGE_TYPE_MAGICAL,
			})
			local infected_time = self.infected_time
			local modifier_abyssal_underlord_2_debuff = hParent:FindModifierByName("modifier_abyssal_underlord_2_debuff")
			if IsValid(modifier_abyssal_underlord_2_debuff) then
				infected_time = infected_time - (modifier_abyssal_underlord_2_debuff.infected_time_reduce or 0)
			end
			self.fTime = self.fTime + self.fInterval
			if self.fTime >= infected_time then
				self.fTime = self.fTime - infected_time
				-- 感染再感染
				if PRD(hParent, self.infected_chance, "abyssal_underlord_1") then
					local tTargets = Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST)
					for n, hTarget in pairs(tTargets) do
						if hParent ~= hTarget then
							hTarget:AddNewModifier(hCaster, hAbility, "modifier_abyssal_underlord_1_debuff", { duration = self.duration })
							local iParticleID = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ti9_immortal/pugna_ti9_immortal_netherblast_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
							ParticleManager:SetParticleControl(iParticleID, 1, Vector(300, 300, 300))
							ParticleManager:ReleaseParticleIndex(iParticleID)
							break
						end
					end
				end
			end
		end
	end
end

---------------------------------------------------------------------
--Modifiers2
if modifier_abyssal_underlord_1 == nil then
	modifier_abyssal_underlord_1 = class({}, nil, eom_modifier)
end
function modifier_abyssal_underlord_1:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_abyssal_underlord_1:OnCreated(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
	end
end
function modifier_abyssal_underlord_1:OnRefresh(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
	end
end
function modifier_abyssal_underlord_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_abyssal_underlord_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_abyssal_underlord_1:OnDeath(params)
	if params.attacker == self:GetParent() and params.unit:HasModifier("modifier_abyssal_underlord_1_debuff") then
		self:IncrementStackCount()
	end
end
function modifier_abyssal_underlord_1:GetPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_increase
end
function modifier_abyssal_underlord_1:OnBattleEnd()
	self:SetStackCount(0)
end
function modifier_abyssal_underlord_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_abyssal_underlord_1:OnTooltip()
	return self:GetStackCount() * self.armor_increase
end
-- function modifier_abyssal_underlord_1:OnIntervalThink()
-- 	-- 发动技能
-- 	if self:GetParent():IsAbilityReady(self:GetAbility()) then
-- 		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
-- 		if IsValid(tTargets[1]) then
-- 			self:GetParent():PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = tTargets[1], bIgnoreBackswing = true })
-- 		end
-- 	end
-- end
