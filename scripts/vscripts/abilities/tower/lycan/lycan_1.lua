LinkLuaModifier("modifier_lycan_1", "abilities/tower/lycan/lycan_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_1_debuff", "abilities/tower/lycan/lycan_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_1_buff", "abilities/tower/lycan/lycan_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lycan_1 == nil then
	lycan_1 = class({})
end
function lycan_1:GetIntrinsicModifierName()
	return "modifier_lycan_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_lycan_1 == nil then
	modifier_lycan_1 = class({}, nil, eom_modifier)
end
function modifier_lycan_1:IsHidden()
	return true
end
function modifier_lycan_1:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.tear_duration = self:GetAbilitySpecialValueFor("tear_duration")
	if IsServer() then
	end
end
function modifier_lycan_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_lycan_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_lycan_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
	}
end
function modifier_lycan_1:OnAttackLanded(params)
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lycan_1_debuff", { duration = self.tear_duration })
end
---------------------------------------------------------------------
if modifier_lycan_1_debuff == nil then
	modifier_lycan_1_debuff = class({}, nil, eom_modifier)
end
function modifier_lycan_1_debuff:IsDebuff()
	return true
end
function modifier_lycan_1_debuff:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.tear_damage = self:GetAbilitySpecialValueFor("tear_damage")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_lycan_1_debuff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_lycan_1_debuff:OnStackCountChanged(iStackCount)
	if IsServer() then
		if self:GetStackCount() >= self.attack_count then
			self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self:GetCaster():GetMaxHealth() * self.tear_damage * 0.01)
			EachUnits(GetPlayerID(self:GetCaster()), function(hUnit)
				hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lycan_1_buff", { duration = self:GetAbility():GetDuration() })
			end, UnitType.AllFirends)
			self:Destroy()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
			ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetAbsOrigin(), false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
function modifier_lycan_1_debuff:IsDebuff()
	return true
end
---------------------------------------------------------------------
if modifier_lycan_1_buff == nil then
	modifier_lycan_1_buff = class({}, nil, eom_modifier)
end
function modifier_lycan_1_buff:OnCreated(params)
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.health = self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth)
	self.attack = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	if IsServer() then
		self:IncrementStackCount()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lycan_1_buff:OnRefresh(params)

	if IsServer() then
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		end
	end
end
function modifier_lycan_1_buff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_PHYSICAL_ATTACK_BONUS
	}
end
function modifier_lycan_1_buff:GetStatusHealthBonus()
	return self.health * self.bonus_health * 0.01 * self:GetStackCount()
end
function modifier_lycan_1_buff:GetPhysicalAttackBonus()
	return self.attack * self.bonus_attack * 0.01 * self:GetStackCount()
end