LinkLuaModifier("modifier_earth_spirit_1", "abilities/tower/earth_spirit/earth_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_spirit_1_rolling_boulder", "abilities/tower/earth_spirit/earth_spirit_1.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_earth_spirit_1_rolling_boulder_stun", "abilities/tower/earth_spirit/earth_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_spirit_1_armorincrease_buff", "abilities/tower/earth_spirit/earth_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_spirit_1_enemy_explosion", "abilities/tower/earth_spirit/earth_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if earth_spirit_1 == nil then
	earth_spirit_1 = class({})
end
function earth_spirit_1:GetIntrinsicModifierName()
	return "modifier_earth_spirit_1"
end

function earth_spirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPoint = hTarget:GetAbsOrigin()

	local vDirection = vPoint - hCaster:GetAbsOrigin()
	vDirection.z = 0
	vDirection = vDirection:Normalized()
	self.vDirection = vDirection

	self.hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_earth_spirit_1_rolling_boulder", {
		fDirX = vDirection.x,
		fDirY = vDirection.y,
	})


	hCaster:EmitSound("Hero_EarthSpirit.RollingBoulder.Cast")
end


---------------------------------------------------------------------
-- Modifiers
if modifier_earth_spirit_1_rolling_boulder == nil then
	modifier_earth_spirit_1_rolling_boulder = class({}, nil, HorizontalModifier)
end
function modifier_earth_spirit_1_rolling_boulder:IsHidden()
	return true
end
function modifier_earth_spirit_1_rolling_boulder:IsDebuff()
	return false
end
function modifier_earth_spirit_1_rolling_boulder:IsPurgable()
	return false
end
function modifier_earth_spirit_1_rolling_boulder:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_earth_spirit_1_rolling_boulder:OnCreated(params)
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	self.type_damage = DAMAGE_TYPE_PHYSICAL
	self.delay = hAbility:GetSpecialValueFor("delay")
	self.fRadius = hAbility:GetSpecialValueFor("radius")
	self.fSpeed = hAbility:GetSpecialValueFor("speed")
	self.fDistance = hAbility:GetSpecialValueFor("distance")
	self.vDirection = Vector(params.fDirX, params.fDirY, 0)
	self.vOrigin = self:GetParent():GetAbsOrigin()
	self.tTargetsRecord = {}

	if IsServer() then
		self:StartIntervalThink(self.delay)
		self.bGestureStarted = false
		hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)

	else
		local sParticleName = "particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder.vpcf"
		self.iParticle = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.iParticle, false, false, -1, false, false)

	end
end

function modifier_earth_spirit_1_rolling_boulder:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveHorizontalMotionController(self)
		FindClearSpaceForUnit(hParent, hParent:GetAbsOrigin(), true)
		hParent:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
		hParent:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL)
		hParent:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END)
	end
end

function modifier_earth_spirit_1_rolling_boulder:OnRemoved(params)
	if IsServer() and self.iParticle then
		ParticleManager:SetParticleControl(self.iParticle, 3, self:GetParent():GetAbsOrigin())
		self:GetParent():StopSound("Hero_EarthSpirit.RollingBoulder.Loop")
		self:GetParent():EmitSound("Hero_EarthSpirit.RollingBoulder.Destroy")
	end
end

function modifier_earth_spirit_1_rolling_boulder:OnIntervalThink()
	local hCaster = self:GetCaster()

	if not self.bGestureStarted then
		self.bGestureStarted = true
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self:StartIntervalThink(0)
		hCaster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
		hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL)
	end

	local tTargets = FindUnitsInRadius(
	hCaster:GetTeamNumber(),
	hCaster:GetAbsOrigin(),
	nil,
	self.fRadius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_ALL,
	DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	FIND_CLOSEST,
	false
	)

	for _, hTarget in pairs(tTargets) do
		if not exist(self.tTargetsRecord, hTarget) then
			table.insert(self.tTargetsRecord, hTarget)

			local iFilter = UnitFilter(hTarget,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			hCaster:GetTeamNumber())
			if iFilter == UF_SUCCESS then
				local tDamage = {
					victim = hTarget,
					attacker = hCaster,
					damage = self:GetAbilitySpecialValueFor("damage") * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01,
					damage_type = self.type_damage,
					ability = self:GetAbility(),
				}
				ApplyDamage(tDamage)

				-- 音效
				hTarget:EmitSound("Hero_EarthSpirit.RollingBoulder.Damage")
				hTarget:EmitSound("Hero_EarthSpirit.RollingBoulder.Target")

				local fStunDurtion = self:GetAbilitySpecialValueFor("stun_duration")

				-- hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_earth_spirit_1_rolling_boulder_stun", { duration = fStunDurtion })
				hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, fStunDurtion)
				hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_earth_spirit_1_armorincrease_buff", {})

				-- 土猫撞到英雄之后会炸一个小范围爆炸
				if hTarget then
					local tTargets = FindUnitsInRadius(
					hCaster:GetTeamNumber(),
					hCaster:GetAbsOrigin(),
					nil,
					300,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_ALL,
					DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					FIND_CLOSEST,
					false
					)
					for _, hTargett in pairs(tTargets) do
						if hTargett ~= self:GetCaster() then
							hTargett:AddNewModifier(hCaster, self:GetAbility(), "modifier_earth_spirit_1_enemy_explosion", { duration = 0.1 })
							-- 并谭飞
						end
					end
					self:Destroy()
				end
			end
		end
	end
end

function modifier_earth_spirit_1_rolling_boulder:UpdateHorizontalMotion(me, dt)
	local vPos = self:GetParent():GetAbsOrigin()
	local vPos = vPos + self.vDirection * self.fSpeed * dt
	self.fDistanceCur = (self.fDistanceCur or 0) + self.fSpeed * dt
	local hCaster = self:GetCaster()
	if not GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), vPos) then
		self:Destroy()
		return
	end


	if self.fDistanceCur >= self.fDistance then
		local tTargets = FindUnitsInRadius(
		hCaster:GetTeamNumber(),
		hCaster:GetAbsOrigin(),
		nil,
		300,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false
		)
		for _, hTargett in pairs(tTargets) do
			if hTargett ~= self:GetCaster() then
				hTargett:AddNewModifier(hCaster, self:GetAbility(), "modifier_earth_spirit_1_enemy_explosion", { duration = 0.1 })
				-- 并谭飞
			end
		end
		self:Destroy()

	else
		self:GetParent():SetAbsOrigin(vPos)
	end
end
function modifier_earth_spirit_1_rolling_boulder:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end


-- ---------------------------------------------------------------------
if modifier_earth_spirit_1_armorincrease_buff == nil then
	modifier_earth_spirit_1_armorincrease_buff = class({}, nil, eom_modifier)
end
function modifier_earth_spirit_1_armorincrease_buff:IsDebuff()
	return false
end
function modifier_earth_spirit_1_armorincrease_buff:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_earth_spirit_1_armorincrease_buff:OnCreated(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_earth_spirit_1_armorincrease_buff:OnRefresh(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_earth_spirit_1_armorincrease_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,

	}
end

function modifier_earth_spirit_1_armorincrease_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_earth_spirit_1_armorincrease_buff:GetMagicalArmorBonus()
	return self:GetStackCount() * self.armor_increase
end

function modifier_earth_spirit_1_armorincrease_buff:GetPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_increase
end

function modifier_earth_spirit_1_armorincrease_buff:OnTooltip()
	return self:GetStackCount() * self.armor_increase
end

function modifier_earth_spirit_1_armorincrease_buff:OnBattleEnd()
	self:SetStackCount(0)
end
---------------------------------------------------------------------
--Modifiers
if modifier_earth_spirit_1 == nil then
	modifier_earth_spirit_1 = class({})
end
function modifier_earth_spirit_1:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_earth_spirit_1:IsHidden(params)
	return true
end
function modifier_earth_spirit_1:OnRefresh(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
	end
end
function modifier_earth_spirit_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_earth_spirit_1:DeclareFunctions()
	return {
	}
end

function modifier_earth_spirit_1:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = Spawner:FindMissingInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, GetPlayerID(self:GetParent()))
		-- , iNotFadeAnimation = 1
		if IsValid(tTargets[1]) then
			self:GetParent():PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = tTargets[1], bIgnoreBackswing = true })
		end
	end
end

---------------------------------------------------------------------
-- 爆炸
if modifier_earth_spirit_1_enemy_explosion == nil then
	modifier_earth_spirit_1_enemy_explosion = class({})
end
function modifier_earth_spirit_1_enemy_explosion:OnCreated(params)
	if IsServer() then
	else
		-- local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
		-- ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_earth_spirit_1_enemy_explosion:IsHidden(params)
	return true
end
function modifier_earth_spirit_1_enemy_explosion:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_earth_spirit_1_enemy_explosion:OnDestroy()
	if IsServer() then
		local tDamage = {
			ability = self:GetAbility(),
			attacker = self:GetCaster(),
			victim = self:GetParent(),
			damage = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack),
			damage_type = DAMAGE_TYPE_PHYSICAL
		}
		ApplyDamage(tDamage)
		self:GetCaster():KnockBack(self:GetParent():GetAbsOrigin() + Vector(0, 50, 0), self:GetParent(), 0, 50, 0.25, true)
	end
end
function modifier_earth_spirit_1_enemy_explosion:DeclareFunctions()
	return {
	}
end