LinkLuaModifier("modifier_lina_2", "abilities/tower/lina/lina_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_2_buff", "abilities/tower/lina/lina_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_2_thinker", "abilities/tower/lina/lina_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lina_2 == nil then
	lina_2 = class({})
end
function lina_2:OnAbilityExcuted()
	if self:GetLevel() > 0 then
		self:GetCaster():AddNewModifier(hCaster, self, "modifier_lina_2_buff", { duration = self:GetDuration() })
	end
end
function lina_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPos = self:GetCursorPosition()

	local delay_time = self:GetSpecialValueFor("delay_time")
	hCaster:AddNewModifier(hCaster, self, "modifier_lina_2_buff", { duration = self:GetDuration() })
	CreateModifierThinker(hCaster, self, "modifier_lina_2_thinker", { duration = delay_time }, vPos, hCaster:GetTeamNumber(), false)

	-- 三技能
	-- hCaster:FindAbilityByName("lina_3"):OnAbilityExcuted()
end
function lina_2:GetIntrinsicModifierName()
	return "modifier_lina_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_lina_2 == nil then
	modifier_lina_2 = class({})
end
function modifier_lina_2:IsHidden()
	return true
end
function modifier_lina_2:OnCreated(params)
	if IsServer() then
		self.distance = self:GetAbility():GetCastRange(vec3_invalid, nil)
		self:StartIntervalThink(1)
	end
end
function modifier_lina_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_lina_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = Spawner:FindMissingInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, GetPlayerID(self:GetParent()))
		-- local vRandom = self:GetParent():GetAbsOrigin() + RandomVector(self.blink_radius)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self:GetAbility():entindex(),
				Position = tTargets[1]:GetAbsOrigin()
			})
		end
	end
end
------------------------------------------------------------------------------
if modifier_lina_2_thinker == nil then
	modifier_lina_2_thinker = class({}, nil, BaseModifier)
end
function modifier_lina_2_thinker:OnCreated(params)
	self.aoe_radius = self:GetAbilitySpecialValueFor(("aoe_radius"))
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")

	local hCaster = self:GetCaster()

	if IsServer() then
		EmitSoundOnLocationForAllies(self:GetParent():GetAbsOrigin(), "Ability.PreLightStrikeArray", hCaster)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, hCaster)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.aoe_radius, self.aoe_radius, self.aoe_radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_lina_2_thinker:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_lina_2_thinker:OnRemoved()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local vPos = hParent:GetAbsOrigin()

	if IsServer() then
		if not IsValid(hAbility)
		or not IsValid(hCaster) then
			return
		end

		local tTargets = Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), vPos, self.aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST)

		for k, hTarget in pairs(tTargets) do
			hCaster:DealDamage(tTargets, hAbility)
			hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_duration)
		end

		EmitSoundOnLocationWithCaster(vPos, "Ability.LightStrikeArray", hCaster)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_WORLDORIGIN, hCaster)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.aoe_radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
---------------------------------------------------------------------
if modifier_lina_2_buff == nil then
	modifier_lina_2_buff = class({}, nil, eom_modifier)
end
function modifier_lina_2_buff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
		self.tData = { self:GetDieTime() }
		self:IncrementStackCount(1)
		self:StartIntervalThink(1)
	end
end
function modifier_lina_2_buff:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, self:GetDieTime())
		self:IncrementStackCount(1)
	end
end
function modifier_lina_2_buff:OnIntervalThink()
	if IsValid(self:GetCaster()) and IsValid(self:GetParent()) then
		local flTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if self.tData[i] < flTime then
				self:DecrementStackCount()
				table.remove(self.tData, i)
			end
		end
	end
end
function modifier_lina_2_buff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS
	}
end
function modifier_lina_2_buff:GetAttackSpeedBonus()
	return self.attackspeed * self:GetStackCount()
end
function modifier_lina_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_lina_2_buff:OnTooltip()
	return self.attackspeed * self:GetStackCount()
end