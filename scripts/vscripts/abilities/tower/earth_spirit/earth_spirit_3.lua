LinkLuaModifier("modifier_earth_spirit_3", "abilities/tower/earth_spirit/earth_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_spirit_3_stone", "abilities/tower/earth_spirit/earth_spirit_3.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_earth_spirit_3_buff", "abilities/tower/earth_spirit/earth_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if earth_spirit_3 == nil then
	earth_spirit_3 = class({iBehavior = DOTA_ABILITY_BEHAVIOR_POINT, iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET}, nil, ability_base_ai)
end
function earth_spirit_3:Spawn()
	self.tStone = {}
end
function earth_spirit_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function earth_spirit_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDistance = self:GetSpecialValueFor("distance")
	local flSpeed = self:GetSpecialValueFor("speed")
	local flRadius = self:GetSpecialValueFor("radius")
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()

	local hStone = CreateUnitByName("npc_dota_earth_spirit_stone", hCaster:GetAbsOrigin(), true, nil, nil, hCaster:GetTeamNumber())
	local tData = {
		flSpeed = flSpeed,
		flDistance = flDistance,
		flDirX = vDirection.x,
		flDirY = vDirection.y,
		flRadius = flRadius,
		iDamage = self:GetAbilityDamage(),
		duration = self:GetDuration()
	}
	hStone:AddNewModifier(hCaster, self, "modifier_earth_spirit_3_stone", tData)
	table.insert(self.tStone, hStone)
	-- sound
	hCaster:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")
end
---------------------------------------------------------------------
-- Modifiers
if modifier_earth_spirit_3_stone == nil then
	modifier_earth_spirit_3_stone = class({})
end
function modifier_earth_spirit_3_stone:IsHidden()
	return true
end
function modifier_earth_spirit_3_stone:IsPurgable()
	return false
end
function modifier_earth_spirit_3_stone:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = self:GetParent():IsHero(),
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end

function modifier_earth_spirit_3_stone:OnCreated(params)
	if not IsServer() then
		return
	end

	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()

	local sParticleName = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_earth_spirit/espirit_stoneremnant.vpcf", self:GetCaster())
	local iParticle = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControl(iParticle, 1, hParent:GetOrigin())
	self:AddParticle(iParticle, false, false, 0, false, false)

	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end

	self.tRecorder = {}

	self.vOrigin = hParent:GetAbsOrigin()
	self.flSpeed = params.flSpeed
	self.vDirection = Vector(params.flDirX, params.flDirY, 0)
	self.flDistance = params.flDistance
	self.flRadius = params.flRadius
	self.iDamage = params.iDamage
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")

	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_geomagentic_grip_target.vpcf", PATTACH_CUSTOMORIGIN, hParent)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticle, 1, hCaster:GetOrigin())
	ParticleManager:SetParticleControl(iParticle, 2, Vector(self.flDistance / self.flSpeed, 0, 0))
	ParticleManager:SetParticleControlForward(iParticle, 3, self.vDirection)
	self:AddParticle(iParticle, false, false, 0, false, false)

	self:StartIntervalThink(0)
end
function modifier_earth_spirit_3_stone:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:InterruptMotionControllers(true)
		hParent:EmitSound("Hero_EarthSpirit.StoneRemnant.Destroy")
		if IsValid(hParent) then
			if IsValid(self:GetAbility()) and self:GetAbility().tStone then
				ArrayRemove(self:GetAbility().tStone, hParent)
			end
			self:GetParent():ForceKill(false)
		end
	end
end
function modifier_earth_spirit_3_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end
function modifier_earth_spirit_3_stone:GetModifierProvidesFOWVision(params)
	return 1
end
function modifier_earth_spirit_3_stone:UpdateHorizontalMotion(me, dt)
	local hCaster = self:GetCaster()
	local hTarget = self:GetParent()
	local vPos = hTarget:GetAbsOrigin()

	if (vPos - self.vOrigin):Length2D() >= self.flDistance then
		FindClearSpaceForUnit(self:GetParent(), vPos, true)
		-- self:Destroy()
		me:InterruptMotionControllers(true)
		return
	end

	vPos = vPos + self.vDirection * self.flSpeed * dt

	hTarget:SetAbsOrigin(vPos)

	local tTargets = FindUnitsInRadiusWithAbility(me, me:GetAbsOrigin(), self.flRadius, self:GetAbility())
	for k, hUnit in pairs(tTargets) do
		if not TableFindKey(self.tRecorder, hUnit) then
			table.insert(self.tRecorder, hUnit)
			hCaster:DealDamage(hUnit, self:GetAbility(), self.iDamage)
			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_duration)
			hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_earth_spirit_3_buff", nil)
		end
	end
end
function modifier_earth_spirit_3_stone:OnHorizontalMotionInterrupted()
	if IsServer() then
		-- self:Destroy()
	end
end
---------------------------------------------------------------------
if modifier_earth_spirit_3_buff == nil then
	modifier_earth_spirit_3_buff = class({}, nil, eom_modifier)
end
function modifier_earth_spirit_3_buff:OnCreated(params)
	self.attack_per_enemy = self:GetAbilitySpecialValueFor("attack_per_enemy")
	self.armor_per_enemy = self:GetAbilitySpecialValueFor("armor_per_enemy")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_earth_spirit_3_buff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_earth_spirit_3_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ROUND_CHANGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE
	}
end
function modifier_earth_spirit_3_buff:GetPhysicalAttackBonusPercentage()
	return self:GetStackCount() * self.attack_per_enemy
end
function modifier_earth_spirit_3_buff:GetMagicalArmorBonusPercentage()
	return self:GetStackCount() * self.armor_per_enemy
end
function modifier_earth_spirit_3_buff:GetPhysicalArmorBonusPercentage()
	return self:GetStackCount() * self.armor_per_enemy
end
function modifier_earth_spirit_3_buff:OnRoundChange()
	self:Destroy()
end