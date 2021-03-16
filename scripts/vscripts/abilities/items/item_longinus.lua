LinkLuaModifier("modifier_item_longinus", "abilities/items/item_longinus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_longinus_shield", "abilities/items/item_longinus.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_longinus == nil then
	item_longinus = class({})
end
function item_longinus:Precache(context)
	PrecacheResource("particle", "particles/econ/events/ti10/attack_modifier_ti10.vpcf", context)
	PrecacheResource("particle", "particles/items/item_tutankhamun_mask/tutankhamun_mask_shield.vpcf", context)
	PrecacheResource("particle", "particles/items/item_longinus/longinus_spear_atfield.vpcf", context)
end
function item_longinus:GetIntrinsicModifierName()
	return "modifier_item_longinus"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_longinus == nil then
	modifier_item_longinus = class({}, nil, modifier_base_ability_attribute)
end
-- function modifier_item_longinus:IsHidden()
-- 	return true
-- end
function modifier_item_longinus:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.magical2magical = self:GetAbilitySpecialValueFor("magical2magical")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
		self:StartIntervalThink(3)
	end
end
function modifier_item_longinus:OnRefresh(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.magical2magical = self:GetAbilitySpecialValueFor("magical2magical")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_longinus:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_longinus_shield")
	end
end
function modifier_item_longinus:OnIntervalThink()
	if self:GetAbility():GetLevel() >= self.unlock_level then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_longinus_shield", nil)
	end
end
function modifier_item_longinus:GetAttackProjectile()
	if self:GetStackCount() == self.attack_count then
		return "particles/econ/events/ti10/attack_modifier_ti10.vpcf"
	end
end
function modifier_item_longinus:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_ATTACKT_PROJECTILE,
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() }
	}
end
function modifier_item_longinus:OnAttack(params)
	if params.attacker == self:GetParent() then
		if self:GetStackCount() < self.attack_count then
			self:IncrementStackCount()
		end
	end
end
function modifier_item_longinus:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if nil == hTarget
	or tAttackInfo.attacker ~= self:GetParent()
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end

	local hParent = self:GetParent()
	if self:GetStackCount() >= self.attack_count then
		self:SetStackCount(0)
		for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
			if iDamageType == DAMAGE_TYPE_PURE then
				tDamageInfo.damage = tDamageInfo.damage + hParent:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical2magical * 0.01
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_item_longinus_shield == nil then
	modifier_item_longinus_shield = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_longinus_shield:IsHidden()
	return true
end
function modifier_item_longinus_shield:OnCreated(params)
	self.shield_health = self:GetAbilitySpecialValueFor("shield_health")
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = hParent:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.shield_health * 0.01
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/items/item_tutankhamun_mask/tutankhamun_mask_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_longinus_shield:OnRefresh(params)
	self.shield_health = self:GetAbilitySpecialValueFor("shield_health")
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = hParent:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.shield_health * 0.01
	end
end
function modifier_item_longinus_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
end
function modifier_item_longinus_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() and params.damage > 0 then
		local hParent = self:GetParent()
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		local vDirection = (params.attacker:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
		local p = ParticleManager:CreateParticle("particles/items/item_longinus/longinus_spear_atfield.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(p, 0, hParent:GetAbsOrigin() + vDirection * 100)
		ParticleManager:SetParticleControlForward(p, 0, vDirection)
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return flBlock
	end
end