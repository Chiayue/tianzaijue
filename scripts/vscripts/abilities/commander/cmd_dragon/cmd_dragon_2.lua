LinkLuaModifier("modifier_cmd_dragon_2", "abilities/commander/cmd_dragon/cmd_dragon_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_dragon_2_buff", "abilities/commander/cmd_dragon/cmd_dragon_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_dragon_2_debuff", "abilities/commander/cmd_dragon/cmd_dragon_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
-- 攻击弹道modifier
-- particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf
if cmd_dragon_2 == nil then
	cmd_dragon_2 = class({})
end
function cmd_dragon_2:GetIntrinsicModifierName()
	return "modifier_cmd_dragon_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_dragon_2 == nil then
	modifier_cmd_dragon_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_dragon_2:IsHidden()
	return true
end
function modifier_cmd_dragon_2:OnCreated(params)
	self.health_threhold = self:GetAbilitySpecialValueFor('health_threhold')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_cmd_dragon_2:OnRefresh(params)
	self.health_threhold = self:GetAbilitySpecialValueFor('health_threhold')
	if IsServer() then
	end
end
function modifier_cmd_dragon_2:OnDestroy()
	if IsServer() then
		-- self:GetParent():RemoveGesture(ACT_DOTA_VICTORY_STATUE)
	end
end
function modifier_cmd_dragon_2:OnIntervalThink()
	if IsServer() then
		local hParent =	self:GetParent()
		local health = hParent:GetHealth()
		local maxhealth = hParent:GetMaxHealth()
		local pct = health / maxhealth * 100
		if pct >= self.health_threhold then
			if GSManager:getStateType() == GS_Battle then
				if not hParent:HasModifier("modifier_cmd_dragon_2_buff") then
					hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_cmd_dragon_2_buff", {})
				end
			end
		else
			if hParent:FindModifierByName("modifier_cmd_dragon_2_buff") then
				hParent:RemoveModifierByName("modifier_cmd_dragon_2_buff")
			end
		end
	end
end
function modifier_cmd_dragon_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
	}
end
function modifier_cmd_dragon_2:OnInBattle()
	self:OnIntervalThink()
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_dragon_2_buff == nil then
	modifier_cmd_dragon_2_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_dragon_2_buff:OnCreated(params)
	self.atk_bonus = self:GetAbilitySpecialValueFor('atk_bonus')
	self.atk_range = self:GetAbilitySpecialValueFor('atk_range')
	self.slow_duration = self:GetAbilitySpecialValueFor('slow_duration')
	local hParent = self:GetParent()
	if IsServer() then
		hParent:GameTimer(0, function()
			self:GetParent():SetMaterialGroup('2')
			self:GetParent():StartGesture(ACT_DOTA_CONSTANT_LAYER)
		end)
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_cmd_dragon_2_buff:OnRefresh(params)
	self.atk_bonus = self:GetAbilitySpecialValueFor('atk_bonus')
	self.atk_range = self:GetAbilitySpecialValueFor('atk_range')
	self.slow_duration = self:GetAbilitySpecialValueFor('slow_duration')
	if IsServer() then
	end
end
function modifier_cmd_dragon_2_buff:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveGesture(ACT_DOTA_CONSTANT_LAYER)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_cmd_dragon_2_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACK_RANGE_BONUS] = self.atk_range,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.atk_bonus,
		EMDF_ATTACKT_PROJECTILE,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_cmd_dragon_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	}
end
function modifier_cmd_dragon_2_buff:GetPhysicalAttackBonusPercentage()
	return self.atk_bonus
end
function modifier_cmd_dragon_2_buff:GetAttackRangeBonus()
	return self.atk_range
end
function modifier_cmd_dragon_2_buff:GetAttackProjectile()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
end
function modifier_cmd_dragon_2_buff:GetModifierModelChange()
	return "models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl"
end
function modifier_cmd_dragon_2_buff:GetAttackSound()
	return "Hero_DragonKnight.ElderDragonShoot3.Attack"
end
function modifier_cmd_dragon_2_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsValid(hAbility) then
		hTarget:AddNewModifier(hParent, hAbility, "modifier_cmd_dragon_2_debuff", {})
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hParent, hAbility, "modifier_cmd_dragon_2_debuff", {duration=GetStatusDebuffDuration(self.slow_duration, hUnit, hParent)})
			if hUnit ~= hTarget then
				for iDamageType, tDamageTable in pairs(tAttackInfo.tDamageInfo) do
					if tDamageTable.damage > 0 then
						ApplyDamage({
							ability = hAbility,
							attacker = hParent,
							victim = hUnit,
							damage = tDamageTable.damage,
							damage_type = iDamageType,
						})
					end
				end
			end
		end
	end
end
function modifier_cmd_dragon_2_buff:OnBattleEnd()
	self:Destroy()
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_dragon_2_debuff == nil then
	modifier_cmd_dragon_2_debuff = class({}, nil, eom_modifier)
end
function modifier_cmd_dragon_2_debuff:IsHidden()
	return false
end
function modifier_cmd_dragon_2_debuff:IsDebuff()
	return true
end
function modifier_cmd_dragon_2_debuff:IsPurgable()
	return true
end
function modifier_cmd_dragon_2_debuff:IsPurgeException()
	return true
end
function modifier_cmd_dragon_2_debuff:IsStunDebuff()
	return false
end
function modifier_cmd_dragon_2_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_cmd_dragon_2_debuff:OnCreated(params)
	self.atkspeed_reduce = self:GetAbilitySpecialValueFor('atkspeed_reduce')
	self.movespeed_reduce = self:GetAbilitySpecialValueFor('movespeed_reduce')
	local hParent = self:GetParent()
	if IsServer() then
	end
end
function modifier_cmd_dragon_2_debuff:OnRefresh(params)
	self.atkspeed_reduce = self:GetAbilitySpecialValueFor('atkspeed_reduce')
	self.movespeed_reduce = self:GetAbilitySpecialValueFor('movespeed_reduce')
	if IsServer() then
	end
end
function modifier_cmd_dragon_2_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_dragon_2_debuff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_MOVEMENT_SPEED_BONUS
	}
end
function modifier_cmd_dragon_2_debuff:GetAttackSpeedBonus()
	return -self.atkspeed_reduce
end
function modifier_cmd_dragon_2_debuff:GetMoveSpeedBonus()
	return -self.movespeed_reduce
end