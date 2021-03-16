LinkLuaModifier("modifier_item_maya_shield_1", "abilities/items/item_maya_shield_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_maya_shield_1_buff", "abilities/items/item_maya_shield_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--玛雅神盾
if item_maya_shield_1 == nil then
	item_maya_shield_1 = class({}, nil, base_ability_attribute)
end
function item_maya_shield_1:GetIntrinsicModifierName()
	return "modifier_item_maya_shield_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_maya_shield_1 == nil then
	modifier_item_maya_shield_1 = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_maya_shield_1:OnCreated(params)
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	self.block = self:GetAbilitySpecialValueFor("block")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_maya_shield_1:OnRefresh(params)
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	self.block = self:GetAbilitySpecialValueFor("block")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_maya_shield_1:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
function modifier_item_maya_shield_1:EDeclareFunctions()
	return {
		[EMDF_HEALTH_REGEN_BONUS] = self.health_regen,
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_item_maya_shield_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_item_maya_shield_1:GetModifierTotal_ConstantBlock(params)
	return self.block
end
function modifier_item_maya_shield_1:OnInBattle()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:GetLevel() >= self.unlock_level then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_item_maya_shield_1:OnBattleEnd()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:GetLevel() >= self.unlock_level then
		self:StartIntervalThink(-1)
	end
end
function modifier_item_maya_shield_1:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:IsAlive() then
		hParent:AddNewModifier(self:GetParent(), hAbility, 'modifier_item_maya_shield_1_buff', { duration = self.duration })
	end
end

---------------------------------------------------------------------
if modifier_item_maya_shield_1_buff == nil then
	modifier_item_maya_shield_1_buff = class({}, nil, eom_modifier)
end
function modifier_item_maya_shield_1_buff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items/item_maya_shield/maya_shield_buff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(1, 1, 1), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_maya_shield_1_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_maya_shield_1_buff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -100,
	}
end
-- function modifier_item_maya_shield_1_buff:OnDestroy()-- 	local hParent = self:GetParent()-- 	if IsServer() then-- 		if IsValid(hParent) then-- 			hParent:RemoveSelf()-- 		end-- 	end-- end