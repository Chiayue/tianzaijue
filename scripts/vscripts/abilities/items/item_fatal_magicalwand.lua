LinkLuaModifier("modifier_item_fatal_magicalwand", "abilities/items/item_fatal_magicalwand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fatal_magicalwand_damage", "abilities/items/item_fatal_magicalwand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_fatal_magicalwand == nil then
	item_fatal_magicalwand = class({}, nil, base_ability_attribute)
end
function item_fatal_magicalwand:GetIntrinsicModifierName()
	return "modifier_item_fatal_magicalwand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_fatal_magicalwand == nil then
	modifier_item_fatal_magicalwand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_fatal_magicalwand:OnCreated(params)

	self.range = self:GetAbilitySpecialValueFor("range")
	self.mana_recover = self:GetAbilitySpecialValueFor("mana_recover")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_fatal_magicalwand:OnRefresh(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.mana_recover = self:GetAbilitySpecialValueFor("mana_recover")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_fatal_magicalwand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_fatal_magicalwand:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = { self:GetParent() },
		-- [MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() }
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_item_fatal_magicalwand:OnAbilityExecuted(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if params.unit == self:GetParent() then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, hUnit in ipairs(tTargets) do
			hUnit:AddNewModifier(hParent, hAbility, "modifier_item_fatal_magicalwand_damage", { duration = 0.1 })
			break
		end
	end
end

function modifier_item_fatal_magicalwand:OnDeath(params)
	if IsServer() then
		if params.attacker == self:GetParent() and self:GetAbility():GetLevel() >= self.unlock_level then
			-- 如果杀死单位则获得蓝量
			self:GetParent():GiveMana(self.mana_recover)
		end
	end
end

--------------------------------
--Modifiers
if modifier_item_fatal_magicalwand_damage == nil then
	modifier_item_fatal_magicalwand_damage = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_fatal_magicalwand_damage:OnCreated(params)
	self.magical_attack = self:GetAbilitySpecialValueFor("magical_attack")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.mana_recover = self:GetAbilitySpecialValueFor("mana_recover")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_item_fatal_magicalwand_damage:OnRefresh(params)
	self.magical_attack = self:GetAbilitySpecialValueFor("magical_attack")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.mana_recover = self:GetAbilitySpecialValueFor("mana_recover")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_fatal_magicalwand_damage:OnDestroy()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local tDamage = {
			ability = hAbility,
			attacker = hCaster,
			victim = hParent,
			damage = self.damage * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(tDamage)
	end

end