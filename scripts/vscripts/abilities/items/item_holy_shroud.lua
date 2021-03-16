LinkLuaModifier("modifier_item_holy_shroud", "abilities/items/item_holy_shroud.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_holy_shroud_buff", "abilities/items/item_holy_shroud.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_holy_shroud == nil then
	item_holy_shroud = class({}, nil, base_ability_attribute)
end
function item_holy_shroud:GetIntrinsicModifierName()
	return "modifier_item_holy_shroud"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_holy_shroud == nil then
	modifier_item_holy_shroud = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_holy_shroud:OnCreated(params)
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.trigger_health_pct = self:GetAbilitySpecialValueFor("trigger_health_pct")
	self.shield_pct = self:GetAbilitySpecialValueFor("shield_pct")
	if IsServer() then
		self.flHealth = self:GetParent():GetHealth()
		self.flLoseHealth = 0
		self:StartIntervalThink(0)
	end
end
function modifier_item_holy_shroud:OnRefresh(params)
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.trigger_health_pct = self:GetAbilitySpecialValueFor("trigger_health_pct")
	self.shield_pct = self:GetAbilitySpecialValueFor("shield_pct")
	if IsServer() then
	end
end
function modifier_item_holy_shroud:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetAbility():IsCooldownReady() then
		if hParent:GetHealth() < self.flHealth then
			self.flLoseHealth = self.flLoseHealth + self.flHealth - hParent:GetHealth()
			if self.flLoseHealth >= hParent:GetMaxHealth() * self.trigger_health_pct * 0.01 then
				self:GetAbility():UseResources(false, false, true)
				self.flLoseHealth = 0
				hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_holy_shroud_buff", { flHealth = math.ceil(hParent:GetHealthDeficit() * self.shield_pct * 0.01) })
				local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/eternal_shroud_launch.vpcf", PATTACH_ABSORIGIN, hParent)
				ParticleManager:SetParticleControl(iParticleID, 2, Vector(125, 0, 0))
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
		self.flHealth = hParent:GetHealth()
	end
end
function modifier_item_holy_shroud:EDeclareFunctions()
	return {
		EMDF_HEALTH_REGEN_BONUS,
	}
end
function modifier_item_holy_shroud:GetHealthRegenBonus()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.health_regen_pct * 0.01
end
---------------------------------------------------------------------
if modifier_item_holy_shroud_buff == nil then
	modifier_item_holy_shroud_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_holy_shroud_buff:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		self:SetStackCount(params.flHealth)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/eternal_shroud.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(125, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_holy_shroud_buff:OnRefresh(params)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + params.flHealth)
	end
end
function modifier_item_holy_shroud_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_holy_shroud_buff:GetModifierTotal_ConstantBlock(params)
	if params.damage ~= params.damage then return end
	if self:GetStackCount() <= params.damage then
		self:Destroy()
		return self:GetStackCount()
	end
	self:SetStackCount(self:GetStackCount() - math.ceil(params.damage))
	return params.damage
end
function modifier_item_holy_shroud_buff:OnTooltip()
	return self:GetStackCount()
end