--SpecialKey对应属性
local Special2Attribute = {
	status_health						=	EMDF_STATUS_HEALTH_BONUS,
	status_mana							=	EMDF_STATUS_MANA_BONUS,

	physical_attack						=	EMDF_PHYSICAL_ATTACK_BONUS,
	magical_attack						=	EMDF_MAGICAL_ATTACK_BONUS,

	physical_armor						=	EMDF_PHYSICAL_ARMOR_BONUS,
	magical_armor						=	EMDF_MAGICAL_ARMOR_BONUS,

	physical_attack_pct					= EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
	magical_attack_pct					= EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,

	physical_armor_pct					= EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
	magical_armor_pct					= EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE,

	attack_helf							=	EMDF_ATTACK_HELF_BONUS_PERCENTAGE,
	damage_helf							=	EMDF_DAMAGE_HELF_BONUS_PERCENTAGE,
	magical_helf						=	EMDF_MAGICAL_HELF_BONUS_PERCENTAGE,
	physical_helf						=	EMDF_PHYSICAL_HELF_BONUS_PERCENTAGE,
	pure_helf							=	EMDF_PURE_HELF_BONUS_PERCENTAGE,

	mana_regen_outgoing					=	EMDF_OUTGOING_MANA_REGEN_PERCENTAGE,
	mana_regen_incoming					=	EMDF_INCOMING_MANA_REGEN_PERCENTAGE,

	attack_speed						=	EMDF_ATTACKT_SPEED_BONUS,
	attack_speed_percentage				=	EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE,

	movement_speed						=	EMDF_MOVEMENT_SPEED_BONUS,
	movement_speed_percentage			=	EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE,

	attack_range_of_range				=	EMDF_ATTACK_RANGE_BONUS,
	attack_range_of_melee				=	EMDF_ATTACK_RANGE_BONUS,

	mana_regen							=	EMDF_MANA_REGEN_BONUS,
	mana_regen_percentage				=	EMDF_MANA_REGEN_PERCENTAGE,

	health_regen						=	EMDF_HEALTH_REGEN_BONUS,
	health_regen_percentage				=	EMDF_HEALTH_REGEN_PERCENTAGE,

	attack_miss							=	EMDF_ATTACK_MISS_BONUS,

}

--Abilities
base_ability_attribute = class({})
function base_ability_attribute:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end
function base_ability_attribute:OnUpgrade()
	--物品升级时刷新buff属性
	if self:IsItem() then
		local tBuffs = self:GetParent():FindAllModifiersByName(self:GetIntrinsicModifierName())
		for _, hBuff in pairs(tBuffs) do
			if IsValid(hBuff) and hBuff:GetAbility() == self then
				hBuff:OnRefresh(nil)
				return
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_base_ability_attribute == nil then
	modifier_base_ability_attribute = {
	}
	modifier_base_ability_attribute = class({}, modifier_base_ability_attribute, eom_modifier)
end

--生成属性修改函数
-- for sSpecialKey, sFunc in pairs(Special2Attribute) do
-- 	local k = sSpecialKey
-- 	modifier_base_ability_attribute[sFunc] = function(self)
-- 		return self:GetAbilitySpecialValueFor(sSpecialKey)
-- 	end
-- end
function modifier_base_ability_attribute:IsHidden()
	return true
end
function modifier_base_ability_attribute:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_base_ability_attribute:EDeclareFunctions(bUnregister)
	local t = {}
	for sSpecialKey, sFunc in pairs(Special2Attribute) do
		local val
		if type(modifier_base_ability_attribute[sFunc]) == 'function' then
			val = modifier_base_ability_attribute[sFunc](self)
		end
		if nil == val then
			val = self:GetAbilitySpecialValueFor(sSpecialKey)
		end
		if 0 ~= val then
			if bUnregister or IsClient() then
				t[sFunc] = val
			else
				t[sFunc] = val
			end
		end
	end
	return t
end

--远程单位攻击范围增加
function modifier_base_ability_attribute:GetAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbilitySpecialValueFor('attack_range_of_range') or 0
	end
	return self:GetAbilitySpecialValueFor('attack_range_of_melee') or 0
end

--封装子类的EDeclareFunctions
function modifier_base_ability_attribute:constructor()
	eom_modifier.constructor(self)
	if type(self.EDeclareFunctions) == "function" then
		if self.EDeclareFunctions ~= modifier_base_ability_attribute.EDeclareFunctions then
			local _EDeclareFunctions = self.EDeclareFunctions
			self.EDeclareFunctions = function(...)
				local t = modifier_base_ability_attribute.EDeclareFunctions(...)
				local t1 = _EDeclareFunctions(...)
				local l = #t1
				for k, v in pairs(t1) do
					if 'number' == type(k) and k <= l then
						t[v] = nil
						table.insert(t, v)
					else
						t[k] = v
					end
				end
				return t
			end
		end
	else
		self.OnCreated = modifier_base_ability_attribute.EDeclareFunctions
	end
end

AbilityClassHook('base_ability_attribute', getfenv(1), 'abilities/base_ability_attribute.lua')