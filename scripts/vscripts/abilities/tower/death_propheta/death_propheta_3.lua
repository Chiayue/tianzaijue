LinkLuaModifier("modifier_death_prophetA_3_buff", "abilities/tower/death_prophetA/death_prophetA_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_prophetA_3_ghost", "abilities/tower/death_prophetA/death_prophetA_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if death_prophetA_3 == nil then
	death_prophetA_3 = class({}, nil, ability_base_ai)
end
function death_prophetA_3:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_death_prophetA_3_buff", { duration = self:GetDuration() })

	hCaster:EmitSound("Hero_DeathProphet.Exorcism.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_death_prophetA_3_buff == nil then
	modifier_death_prophetA_3_buff = class({}, nil, eom_modifier)
end
function modifier_death_prophetA_3_buff:DestroyOnExpire()
	return false
end
function modifier_death_prophetA_3_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_death_prophetA_3_buff:OnCreated(params)
	local hCaster = self:GetCaster()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.spirits = self:GetAbilitySpecialValueFor("spirits")
	self.spirit_speed = self:GetAbilitySpecialValueFor("spirit_speed")
	self.max_distance = self:GetAbilitySpecialValueFor("max_distance")
	self.give_up_distance = self:GetAbilitySpecialValueFor("give_up_distance")
	self.ghost_spawn_rate = self:GetAbilitySpecialValueFor("ghost_spawn_rate")
	self.curse_duration = self:GetAbilitySpecialValueFor("curse_duration")
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		self:StartIntervalThink(self.ghost_spawn_rate)

		-- self.damage_type = hAbility:GetAbilityDamageType()
		self.sSoundName = "Hero_DeathProphet.Exorcism"
		hParent:EmitSound(self.sSoundName)

		self.tGhosts = {}

		self.unique_str = DoUniqueString("modifier_death_prophetA_3_buff")

		hParent:GameTimer(0, function()
			if not IsValid(self) then
				return
			end
			if not IsValid(hAbility) or not IsValid(hCaster) then
				return
			end
			if self:GetRemainingTime() <= -10 then
				self:Destroy()
				return
			end
			local hAttackTarget = hParent:GetAttackTarget()
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility(), FIND_CLOSEST)
			-- local tTargets = Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST)
			for i = #self.tGhosts, 1, -1 do
				local hGhost = self.tGhosts[i]

				if self:GetRemainingTime() <= 0 then
					hGhost.bReturning = true
					hGhost.hTarget = hParent
				end
				if hGhost.bReturning == false then
					local hTarget = hGhost.hTarget
					if IsValid(hTarget) then
						if not hTarget:IsAlive() or not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.give_up_distance) then
							hTarget = nil
						end
					end
					if not IsValid(hTarget) then
						hTarget = hAttackTarget
						if not IsValid(hTarget) then
							hTarget = GetRandomElement(tTargets)
						end
					end
					hGhost.hTarget = hTarget
					if not IsValid(hGhost.hTarget) then
						if hGhost.vTargetPosition == nil then
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
						end
					else
						hGhost.vTargetPosition = nil
					end
				end

				if not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
					hGhost.hUnit:SetAbsOrigin(hParent:GetAbsOrigin())
				end

				local fAngularSpeed = self:GetRemainingTime() <= 0 and (1 / (1 / 30) * FrameTime()) or ((1 / 9) / (1 / 30) * FrameTime())
				local vTargetPosition = IsValid(hGhost.hTarget) and hGhost.hTarget:GetAbsOrigin() or hGhost.vTargetPosition
				local vDirection = vTargetPosition - hGhost.hUnit:GetAbsOrigin()
				vDirection.z = 0
				vDirection = vDirection:Normalized()

				local vForward = hGhost.hUnit:GetForwardVector()

				local fAngle = math.acos(Clamp(vDirection.x * vForward.x + vDirection.y * vForward.y, -1, 1))

				fAngularSpeed = math.min(fAngularSpeed, fAngle)

				local vCross = vForward:Cross(vDirection)
				if vCross.z < 0 then
					fAngularSpeed = -fAngularSpeed
				end
				vForward = Rotation2D(vForward, fAngularSpeed)

				hGhost.hUnit:SetForwardVector(vForward)

				local vPosition = GetGroundPosition(hGhost.hUnit:GetAbsOrigin() + hGhost.hUnit:GetForwardVector() * (self.spirit_speed * FrameTime()), hParent)
				hGhost.hUnit:SetAbsOrigin(vPosition)

				if hGhost.hUnit:IsPositionInRange(vTargetPosition, 32) then
					if hGhost.hTarget ~= nil then
						if hGhost.bReturning then
							hGhost.hTarget = nil
							hGhost.bReturning = false
							if self:GetRemainingTime() <= 0 then
								hGhost.hUnit:RemoveModifierByName("modifier_death_prophetA_3_ghost")
								table.remove(self.tGhosts, i)
								if #self.tGhosts == 0 then
									self:Destroy()
									return
								end
							end
						else
							hCaster:DealDamage(hGhost.hTarget, hAbility)
							-- 诅咒
							hGhost.hTarget:AddBuff(hCaster, BUFF_TYPE.CURSE.COLD, self.curse_duration, true)
							-- local tDamageTable = {
							-- 	ability = hAbility,
							-- 	attacker = hCaster,
							-- 	victim = hGhost.hTarget,
							-- 	damage = RandomInt(self.min_damage, self.max_damage) + hCaster:GetIntellect() * self.damage_per_int,
							-- 	damage_type = self.damage_type
							-- }
							-- ApplyDamage(tDamageTable)
							-- hParent:AddNewModifier(hParent, hAbility, "modifier_death_prophet_3_intellect_buff", { unique_str = self.unique_str })
							hGhost.hTarget = hParent
							hGhost.bReturning = true
						end
					else
						hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
					end
				end
			end
			-- return 0.05
			return 0
		end
		)
	end
end
function modifier_death_prophetA_3_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			hParent:StopSound(self.sSoundName)
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_death_prophetA_3_ghost")
			end
		end
	end
end
function modifier_death_prophetA_3_buff:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()

		if not IsValid(hAbility) or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		if #(self.tGhosts) < self.spirits then
			local vPosition = hCaster:GetAbsOrigin()
			local vForward = RandomVector(1)
			local hGhost = {
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_death_prophetA_3_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
				vTargetPosition = nil,
				hTarget = nil,
				bReturning = false
			}
			hGhost.hUnit:SetForwardVector(vForward)

			table.insert(self.tGhosts, hGhost)
		end
	end
end
---------------------------------------------------------------------
if modifier_death_prophetA_3_ghost == nil then
	modifier_death_prophetA_3_ghost = class({}, nil, eom_modifier)
end
function modifier_death_prophetA_3_ghost:IsHidden()
	return true
end
function modifier_death_prophetA_3_ghost:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		self:GetParent():SetModelScale(0.9)
	end
end
function modifier_death_prophetA_3_ghost:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_death_prophetA_3_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_death_prophetA_3_ghost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_death_prophetA_3_ghost:GetModifierModelChange(params)
	return "models/heroes/death_prophet/death_prophet_ghost.vmdl"
end
function modifier_death_prophetA_3_ghost:GetOverrideAnimation(params)
	return ACT_DOTA_RUN
end