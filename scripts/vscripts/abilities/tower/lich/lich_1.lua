LinkLuaModifier("modifier_lich_1_buff", "abilities/tower/lich/lich_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_1_debuff", "abilities/tower/lich/lich_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lich_1 == nil then
	local funcSortFunction = function(a, b)
		-- 优先近战
		if not a:IsRangedAttacker() and b:IsRangedAttacker() then
			return true
		elseif a:IsRangedAttacker() and not b:IsRangedAttacker() then
			return false
		end
		-- 优先魔甲高
		if a:GetVal(ATTRIBUTE_KIND.MagicalArmor) > b:GetVal(ATTRIBUTE_KIND.MagicalArmor) then
			return true
		elseif a:GetVal(ATTRIBUTE_KIND.MagicalArmor) < b:GetVal(ATTRIBUTE_KIND.MagicalArmor) then
			return false
		end
		-- 优先血量高
		if a:GetHealth() / a:GetMaxHealth() < b:GetHealth() / b:GetMaxHealth() then
			return true
		elseif a:GetHealth() / a:GetMaxHealth() > b:GetHealth() / b:GetMaxHealth() then
			return false
		end
		return false
	end
	local funcUnitsCallback = function(self, tTargets)
		ArrayRemove(tTargets, Commander:GetCommander(GetPlayerID(self:GetCaster())))
	end
	lich_1 = class({ funcUnitsCallback = funcUnitsCallback, funcSortFunction = funcSortFunction }, nil, ability_base_ai)
end
function lich_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_lich_1_buff", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_Lich.IceAge")
	-- 技能2
	if hCaster:HasModifier("modifier_lich_2") then
		hCaster:FindAbilityByName("lich_2"):OnSpellStart()
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_lich_1_buff == nil then
	modifier_lich_1_buff = class({}, nil, eom_modifier)
end
function modifier_lich_1_buff:OnCreated(params)
	self.armor_bonus = self:GetAbilitySpecialValueFor("armor_bonus")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.magical2magical = self:GetAbilitySpecialValueFor("magical2magical")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.damage_mgc_armor_pct = self:GetAbilitySpecialValueFor("damage_mgc_armor_pct")
	self.magical2magical = self:GetAbilitySpecialValueFor("magical2magical")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lich_1_buff:GetPhysicalArmorBonus()
	return self.armor_bonus
end
function modifier_lich_1_buff:GetMagicalArmorBonus()
	return self.armor_bonus
end
function modifier_lich_1_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.armor_bonus,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.armor_bonus,
	}
end
function modifier_lich_1_buff:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:StartIntervalThink(-1)
			return
		end
		local hParent = self:GetParent()

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		hParent:EmitSound("Hero_Lich.IceAge.Tick")

		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		table.sort(tTargets, function(a, b)
			return a:GetHealth() > b:GetHealth()
		end)
		local flDamage = hParent:GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.damage_mgc_armor_pct * 0.01 + hParent:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical2magical * 0.01
		for _, hUnit in pairs(tTargets) do
			hCaster:DealDamage(hUnit, self:GetAbility(), flDamage)
			hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lich_1_debuff", { duration = self.slow_duration })
		end
	end
end
function modifier_lich_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_lich_1_buff:OnTooltip()
	return self.armor_bonus
end
---------------------------------------------------------------------
if modifier_lich_1_debuff == nil then
	modifier_lich_1_debuff = class({}, nil, eom_modifier)
end
function modifier_lich_1_debuff:IsDebuff()
	return true
end
function modifier_lich_1_debuff:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	self.attackspeed_reduce = self:GetAbilitySpecialValueFor("attackspeed_reduce")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_slowed_cold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lich_1_debuff:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_reduce,
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = -self.attackspeed_reduce
	}
end
function modifier_lich_1_debuff:GetMoveSpeedBonusPercentage()
	return -self.movespeed_reduce
end
function modifier_lich_1_debuff:GetAttackSpeedPercentage()
	return -self.attackspeed_reduce
end
function modifier_lich_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_lich_1_debuff:OnTooltip()
	return self.movespeed_reduce
end