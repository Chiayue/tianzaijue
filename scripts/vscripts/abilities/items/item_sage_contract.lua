LinkLuaModifier("modifier_item_sage_contract", "abilities/items/item_sage_contract.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sage_contract_link", "abilities/items/item_sage_contract.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_sage_contract == nil then
	item_sage_contract = class({}, nil, base_ability_attribute)
end
function item_sage_contract:GetIntrinsicModifierName()
	return "modifier_item_sage_contract"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_sage_contract == nil then
	modifier_item_sage_contract = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_sage_contract:IsHidden()
	return true
end
function modifier_item_sage_contract:OnDestroy()
	if IsServer() then
		-- 清除buff
		self:OnBattleEnd()
	end
end
function modifier_item_sage_contract:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_item_sage_contract:OnInBattle()
	local hParent = self:GetParent()
	local sAttackDamageType = hParent:GetAttackDamageType() == "Magical" and "Physical" or "Magical"

	local tTarget = {}
	EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		-- if hUnit:GetAttackDamageType() == sAttackDamageType then
		-- end
		if hUnit ~= hParent then
			table.insert(tTarget, hUnit)
		end
	end, UnitType.Building)
	if #tTarget > 0 then
		table.sort(tTarget, function(a, b)
			return CalculateDistance(hParent, a) < CalculateDistance(hParent, b)
		end)
		self.hTarget = tTarget[1]
		self.hTarget:AddNewModifier(hParent, self:GetAbility(), "modifier_item_sage_contract_link", nil)
		hParent:AddNewModifier(self.hTarget, self:GetAbility(), "modifier_item_sage_contract_link", nil)
	end
end
function modifier_item_sage_contract:OnBattleEnd()
	if IsValid(self.hTarget) then
		self.hTarget:RemoveModifierByName("modifier_item_sage_contract_link")
	end
	self:GetParent():RemoveModifierByName("modifier_item_sage_contract_link")
end
---------------------------------------------------------------------
if modifier_item_sage_contract_link == nil then
	modifier_item_sage_contract_link = class({}, nil, eom_modifier)
end
function modifier_item_sage_contract_link:OnCreated(params)
	self.attribute_pct = self:GetAbilitySpecialValueFor("attribute_pct")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	local hCaster = self:GetAbility():GetCaster()
	local hParent = self:GetParent()
	local hTarget = self:GetCaster()
	if hCaster ~= hParent then
		self.PhysicalAttack	= hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.attribute_pct * 0.01
		self.MagicalAttack	= hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.attribute_pct * 0.01
		self.PhysicalArmor	= hCaster:GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self.attribute_pct * 0.01
		self.MagicalArmor	= hCaster:GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.attribute_pct * 0.01
		self.HealthRegen	= hCaster:GetVal(ATTRIBUTE_KIND.HealthRegen) * self.attribute_pct * 0.01
		self.ManaRegen		= hCaster:GetVal(ATTRIBUTE_KIND.ManaRegen) * self.attribute_pct * 0.01
		self.StatusHealth	= hCaster:GetVal(ATTRIBUTE_KIND.StatusHealth) * self.attribute_pct * 0.01
		self.StatusMana		= hCaster:GetVal(ATTRIBUTE_KIND.StatusMana) * self.attribute_pct * 0.01
	end
	if IsServer() then
	else
		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		if hCaster == hParent then
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(100, 0, 0))
		else
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(100, 0, 0))
		end
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_sage_contract_link:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent()},
		[MODIFIER_EVENT_ON_HEAL_RECEIVED] = { self:GetParent() },
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_MANA_REGEN_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_STATUS_MANA_BONUS,
	}
end
function modifier_item_sage_contract_link:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_item_sage_contract_link:OnHealReceived(params)
	local hCaster = self:GetAbility():GetCaster()
	local hParent = self:GetParent()
	local hTarget = self:GetCaster()
	if hCaster == hParent then
		hTarget:Heal(params.gain, self:GetAbility(), params.inflictor ~= nil)
	end
end
function modifier_item_sage_contract_link:GetMinHealth()
	if IsServer() then
		if self:GetAbility():GetLevel() >= self.unlock_level then
			if IsValid(self:GetCaster()) and self:GetCaster():HasModifier("modifier_item_sage_contract_link") and self:GetCaster():FindModifierByName("modifier_item_sage_contract_link"):GetStackCount() ~= 1 then
				return 1
			end
		end
	end
end
function modifier_item_sage_contract_link:OnTakeDamage(params)
	if IsServer() then
		if self:GetAbility():GetLevel() >= self.unlock_level and self:GetParent():GetHealth() == 1 then
			self:SetStackCount(1)
		end
		-- if params.unit == self:GetParent() and
		-- bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and
		-- bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and
		-- IsValid(self.hTarget) and
		-- self.hTarget:IsAlive() then
		-- 	params.attacker:DealDamage(self.hTarget, self:GetAbility(), params.original_damage, params.damage_type, params.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR)
		-- end
	end
end
function modifier_item_sage_contract_link:GetPhysicalAttackBonus()
	return self.PhysicalAttack or 0
end
function modifier_item_sage_contract_link:GetMagicalAttackBonus()
	return self.MagicalAttack or 0
end
function modifier_item_sage_contract_link:GetPhysicalArmorBonus()
	return self.PhysicalArmor or 0
end
function modifier_item_sage_contract_link:GetMagicalArmorBonus()
	return self.MagicalArmor or 0
end
function modifier_item_sage_contract_link:GetHealthRegenBonus()
	return self.HealthRegen or 0
end
function modifier_item_sage_contract_link:GetManaRegenBonus()
	return self.ManaRegen or 0
end
function modifier_item_sage_contract_link:GetStatusHealthBonus()
	return self.StatusHealth or 0
end
function modifier_item_sage_contract_link:GetStatusManaBonus()
	return self.StatusMana or 0
end

AbilityClassHook('item_sage_contract', getfenv(1), 'abilities/items/item_sage_contract.lua', { KeyValues.ItemsKv })