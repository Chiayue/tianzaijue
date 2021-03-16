LinkLuaModifier("modifier_item_sunshine_sword_1", "abilities/items/item_sunshine_sword_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_sunshine_sword_1 == nil then
	item_sunshine_sword_1 = class({}, nil, base_ability_attribute)
end

function item_sunshine_sword_1:GetIntrinsicModifierName()
	return "modifier_item_sunshine_sword_1"
end
function item_sunshine_sword_1:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		local flDamage = (self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) + self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)) * self:GetSpecialValueFor("damage_factor") * 0.01
		local tDamage = {
			ability = self,
			attacker = self:GetCaster(),
			victim = hTarget,
			damage = flDamage,
			damage_type = DAMAGE_TYPE_PHYSICAL
		}
		ApplyDamage(tDamage)
		-- if self:GetLevel() >= self:GetSpecialValueFor("unlock_level") then
		-- hTarget:AddBuff(self:GetCaster(), BUFF_TYPE.DISARM, self:GetSpecialValueFor('disarm_duration'))
		-- end
		self:GetCaster():KnockBack(self:GetCaster():GetAbsOrigin(), hTarget, self:GetSpecialValueFor('knockback_distance'), 0, self:GetSpecialValueFor('disarm_duration'), false)

	end

end
---------------------------------------------------------------------
--Modifiers
if modifier_item_sunshine_sword_1 == nil then
	modifier_item_sunshine_sword_1 = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_sunshine_sword_1:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_sunshine_sword_1:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_sunshine_sword_1:UpdateValues()
	self.damage_factor = self:GetAbilitySpecialValueFor('damage_factor')
	self.attack_miss_factor = self:GetAbilitySpecialValueFor('attack_miss_factor')
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.attack_speed_percentage = self:GetAbilitySpecialValueFor('attack_speed_percentage')
	self.unlock_level = self:GetAbilitySpecialValueFor('unlock_level')
end

function modifier_item_sunshine_sword_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_sunshine_sword_1:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS,
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_CRIT_BONUS
	}
end
-- function modifier_item_sunshine_sword_1:GetAttackMissBonus()
-- 	return 100, self.attack_miss_factor
-- end
function modifier_item_sunshine_sword_1:GetAttackSpeedPercentage()
	return self.attack_speed_percentage
end
function modifier_item_sunshine_sword_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if self.unlock_level > self:GetAbility():GetLevel() then
		return
	end
	--打一个卡尔特效projectile
	if RollPercentage(self.chance) then
		self:Sunshine(hTarget)
	end
end
function modifier_item_sunshine_sword_1:Sunshine(hTarget)
	local hParent = self:GetParent()
	-- local speed = self:GetAbilitySpecialValueFor("speed")
	local distance = 1000
	local vDirection = (hTarget:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
	vDirection.z = 0
	if vDirection == Vector(0, 0, 0) then
		vDirection = RandomVector(1)
	end
	local info = {
		Ability = self:GetAbility(),
		Source = hParent,
		EffectName = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf",
		vSpawnOrigin = self:GetParent():GetAbsOrigin(),
		vVelocity = vDirection * 600,
		fDistance = 300,
		fStartRadius = 300,
		fEndRadius = 300,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true
	}
	ProjectileManager:CreateLinearProjectile(info)
end

AbilityClassHook('item_sunshine_sword_1', getfenv(1), 'abilities/items/item_sunshine_sword_1.lua', { KeyValues.ItemsKv })