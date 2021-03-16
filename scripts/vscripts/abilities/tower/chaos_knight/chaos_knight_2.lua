LinkLuaModifier("modifier_chaos_knight_2", "abilities/tower/chaos_knight/chaos_knight_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if chaos_knight_2 == nil then
	chaos_knight_2 = class({}, nil, ability_base_ai)
end
function chaos_knight_2:GetIntrinsicModifierName()
	return "modifier_chaos_knight_2"
end
function chaos_knight_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPos = hCaster:GetAbsOrigin()

	local radius = self:GetSpecialValueFor('radius')
	local max_stun_duration = self:GetSpecialValueFor("max_stun_duration")
	local min_stun_duration = self:GetSpecialValueFor("min_stun_duration")
	local max_count = self:GetSpecialValueFor("max_count")
	local min_count = self:GetSpecialValueFor("min_count")
	local chaos_bolt_speed = self:GetSpecialValueFor("chaos_bolt_speed")

	local count = RandomInt(min_count, max_count)
	local stun_duration = RandomInt(min_stun_duration, max_stun_duration)
	local damage_pct = 100

	local hModifier = hCaster:FindModifierByName("modifier_chaos_knight_1")
	if IsValid(hModifier) and hModifier.RollDamagePct then
		damage_pct = hModifier:RollDamagePct()
	end

	local tTargets = Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), vPos, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, GetPlayerID(hCaster))
	local tUseTargets = {}
	for i = 1, math.min(count, #tTargets) do
		local hTarget = RandomValue(tTargets)
		while exist(tUseTargets, hTarget) do
			hTarget = RandomValue(tTargets)
		end
		local tInfo = {
			Target = hTarget,
			Source = hCaster,
			Ability = self,
			vSourceLoc = vPos,
			EffectName = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf",
			bDodgable = true,
			bProvidesVision = false,
			iMoveSpeed = chaos_bolt_speed,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			ExtraData = {
				stun_duration = stun_duration,
				damage_pct = damage_pct
			}
		}
		ProjectileManager:CreateTrackingProjectile(tInfo)
	end
end
function chaos_knight_2:OnProjectileHit_ExtraData(hTarget, vLocation, table)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		ApplyDamage({
			ability = self,
			attacker = hCaster,
			victim = hTarget,
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType()
		},
		function(tDamage)
			tDamage.damage = tDamage.damage * table.damage_pct * 0.01
		end)

		if hTarget:IsAlive() then
			hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, table.stun_duration)
		end
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_chaos_knight_2 == nil then
	modifier_chaos_knight_2 = class({}, nil, BaseModifier)
end
function modifier_chaos_knight_2:IsHidden()
	return true
end
function modifier_chaos_knight_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_chaos_knight_2:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_chaos_knight_2:OnIntervalThink()
	if GSManager:getStateType() ~= GS_Battle then
		return
	end

	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = Spawner:FindMissingInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, GetPlayerID(self:GetParent()))
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end