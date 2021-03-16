LinkLuaModifier("modifier_item_doubleclick_wand_1", "abilities/items/item_doubleclick_wand_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_doubleclick_wand_1_buff", "abilities/items/item_doubleclick_wand_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_doubleclick_wand_1 == nil then
	item_doubleclick_wand_1 = class({}, nil, base_ability_attribute)
end
function item_doubleclick_wand_1:Precache(context)
	PrecacheResource("particle_folder", "particles/units/heroes/tinker/tinker_missile.vpcf", context)
end
function item_doubleclick_wand_1:GetIntrinsicModifierName()
	return "modifier_item_doubleclick_wand_1"
end
function item_doubleclick_wand_1:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self:GetSpecialValueFor("damage_factor") * 0.01
		-- 直接伤害
		local tDamage = {
			ability = self,
			attacker = self:GetCaster(),
			victim = hTarget,
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(tDamage)
		-- 命中音效
		hTarget:EmitSound("Hero_Tinker.Heat-Seeking_Missile.Impact")
		if self:GetLevel() >= self:GetSpecialValueFor("unlock_level") then
			hTarget:AddBuff(self:GetParent(), BUFF_TYPE.STUN, self:GetSpecialValueFor('stun_time'))
		end

	end
	return true
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_doubleclick_wand_1 == nil then
	modifier_item_doubleclick_wand_1 = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_doubleclick_wand_1:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_doubleclick_wand_1:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_doubleclick_wand_1:UpdateValues(params)
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.attack_speed = self:GetAbilitySpecialValueFor("damage_factor")
	self.armor_reduce_pct = self:GetAbilitySpecialValueFor('armor_reduce_pct')
	self.attack_speed_factor = self:GetAbilitySpecialValueFor('attack_speed_factor')
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.unlock_level = self:GetAbilitySpecialValueFor('unlock_level')
end
function modifier_item_doubleclick_wand_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_doubleclick_wand_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end
function modifier_item_doubleclick_wand_1:OnAttack(params)
	if PRD(self:GetParent(), self.chance, "item_doubleclick_wand") then
		self:Missile()
	end
end

function modifier_item_doubleclick_wand_1:Missile()
	local hParent = self:GetParent()
	local speed = self:GetAbilitySpecialValueFor("speed")
	local distance = hParent:Script_GetAttackRange() + 200

	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #tTargets > 0 then
		local hEnemy = RandomValue((tTargets))
		if IsValid(hEnemy) then
			local tInfo = {
				Ability = self:GetAbility(),
				Target = hEnemy,
				iMoveSpeed = speed,
				vSourceLoc = hParent:GetAbsOrigin(),
				EffectName = "particles/units/heroes/tinker/tinker_missile.vpcf",
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)
		end
	end
	hParent:EmitSound("Hero_Tinker.Heat-Seeking_Missile")
end