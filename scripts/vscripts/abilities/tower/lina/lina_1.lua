LinkLuaModifier("modifier_lina_1", "abilities/tower/lina/lina_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lina_1 == nil then
	lina_1 = class({})
end
function lina_1:OnSpellStart(vPosition, ExtraData)
	local hCaster = self:GetCaster()
	local vPosition = vPosition or self:GetCursorPosition()
	local vStart = hCaster:GetAbsOrigin()
	local vDirection = CalculateDirection(vPosition, vStart)

	local dragon_slave_speed = self:GetSpecialValueFor("dragon_slave_speed")
	local dragon_slave_width_initial = self:GetSpecialValueFor("dragon_slave_width_initial")
	local dragon_slave_width_end = self:GetSpecialValueFor("dragon_slave_width_end")
	local dragon_slave_distance = self:GetSpecialValueFor("dragon_slave_distance")

	local info = {
		Ability = self,
		Source = hCaster,
		EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
		vSpawnOrigin = vStart,
		vVelocity = vDirection * dragon_slave_speed,
		fDistance = dragon_slave_distance,
		fStartRadius = dragon_slave_width_initial,
		fEndRadius = dragon_slave_width_end,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		ExtraData = ExtraData
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- 三技能
	hCaster:FindAbilityByName("lina_2"):OnAbilityExcuted()
	-- hCaster:FindAbilityByName("lina_3"):OnAbilityExcuted()
end
function lina_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		-- 不打攻击伤害（打攻击伤害在此处修改）
		-- self:GetCaster():DealDamage(hTarget, self)
		-- 打攻击伤害
		local tAttackInfo = GetAttackInfo(ExtraData.record, self:GetCaster())
		local hAttackAbility = EntIndexToHScript(ExtraData.iAbilityIndex)
		--命中
		EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, tAttackInfo)
		--伤害
		hAttackAbility:OnDamage(hTarget, tAttackInfo)
	else
		DelAttackInfo(ExtraData.record)
	end
	return false
end
function lina_1:GetIntrinsicModifierName()
	return "modifier_lina_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_lina_1 == nil then
	modifier_lina_1 = class({}, nil, eom_modifier)
end
function modifier_lina_1:IsHidden()
	return true
end
function modifier_lina_1:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	if IsServer() then
	end
end
function modifier_lina_1:EDeclareFunctions()
	return {
		EMDF_ATTACKT_ANIMATION,
		EMDF_ATTACKT_ANIMATION_RATE,
		EMDF_DO_ATTACK_BEHAVIOR,
	}
end
function modifier_lina_1:GetAttackAnimation()
	return self:GetStackCount() == self.attack_count - 1 and ACT_DOTA_CAST_ABILITY_1 or ACT_DOTA_ATTACK
end
function modifier_lina_1:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hTarget = tAttackInfo.target

	if self:GetStackCount() == self.attack_count - 1 then
		self:GetAbility():OnSpellStart(hTarget, { record = tAttackInfo.record, iAbilityIndex = hAttackAbility:entindex() })
	else
		local info = {
			EffectName = hAttackAbility:GetAttackProjectile(),
			Ability = hAttackAbility,
			iMoveSpeed = hParent:GetProjectileSpeed(),
			Source = hParent,
			Target = hTarget,
			iSourceAttachment = hAttackAbility:GetAttackAttachment(),
			bDodgeable = true,
			bRebound = true, --支持弹道反弹
			ExtraData = {
				record = tAttackInfo.record
			}
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

	if self:GetStackCount() < self.attack_count - 1 then
		self:IncrementStackCount()
	else
		self:SetStackCount(0)
	end
end