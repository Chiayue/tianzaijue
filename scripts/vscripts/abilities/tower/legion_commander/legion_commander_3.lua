LinkLuaModifier("modifier_legion_commander_3", "abilities/tower/legion_commander/legion_commander_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_3_debuff", "abilities/tower/legion_commander/legion_commander_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if legion_commander_3 == nil then
	legion_commander_3 = class({})
end
function legion_commander_3:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	if hTarget then
		hCaster:DealDamage(hTarget, self)
		hTarget:AddNewModifier(hCaster, self, "modifier_legion_commander_3_debuff", { duration = self:GetDuration() })
		hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetDuration())
	end
end
function legion_commander_3:GetIntrinsicModifierName()
	return "modifier_legion_commander_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_legion_commander_3 == nil then
	modifier_legion_commander_3 = class({}, nil, eom_modifier)
end
function modifier_legion_commander_3:OnCreated(params)
	self.heal = self:GetAbilitySpecialValueFor("heal")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.width = self:GetAbilitySpecialValueFor("width")
	if IsServer() then
	end
end
function modifier_legion_commander_3:OnRefresh(params)
	self.heal = self:GetAbilitySpecialValueFor("heal")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.width = self:GetAbilitySpecialValueFor("width")
	if IsServer() then
	end
end
function modifier_legion_commander_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_legion_commander_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	-- [MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_legion_commander_3:GetModifierAvoidDamage(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hTarget = params.attacker
	if params.damage > 0 and hTarget and hAbility:IsCooldownReady() and RollPercentage(self.chance) then
		local vDirection = (hTarget == hParent) and RandomVector(1) or CalculateDirection(hTarget, hParent)
		hAbility:UseResources(false, false, true)
		hParent:StartGesture(ACT_DOTA_ATTACK)
		hParent:Heal(self.heal, self:GetAbility())
		hParent:EmitSound("Hero_LegionCommander.Courage")

		local info = {
			EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
			Ability = self:GetAbility(),
			vSpawnOrigin = hParent:GetAbsOrigin(),
			fDistance = self.distance,
			vVelocity = vDirection * self.speed,
			fStartRadius = self.width,
			fEndRadius = self.width,
			Source = hParent,
			iUnitTargetTeam = self:GetAbility():GetAbilityTargetTeam(),
			iUnitTargetType = self:GetAbility():GetAbilityTargetType(),
			iUnitTargetFlags = self:GetAbility():GetAbilityTargetFlags(),
			fExpireTime = GameRules:GetGameTime() + 0.5
		}

		ProjectileManager:CreateLinearProjectile(info)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/legion_commander/legion_commander_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(0, 1, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		return 1
	end
end
function modifier_legion_commander_3:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_legion_commander_3_debuff == nil then
	modifier_legion_commander_3_debuff = class({}, nil, eom_modifier)
end
function modifier_legion_commander_3_debuff:OnCreated(params)
	self.reduce_pct = self:GetAbilitySpecialValueFor("reduce_pct")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_tgt.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_legion_commander_3_debuff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.reduce_pct,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = self.reduce_pct
	}
end
function modifier_legion_commander_3_debuff:GetAttackSpeedPercentage()
	return -self.reduce_pct
end
function modifier_legion_commander_3_debuff:GetMoveSpeedBonusPercentage()
	return -self.reduce_pct
end
function modifier_legion_commander_3_debuff:IsHidden()
	return true
end