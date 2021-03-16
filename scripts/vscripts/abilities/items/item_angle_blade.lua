LinkLuaModifier("modifier_item_angle_blade", "abilities/items/item_angle_blade.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_angle_blade == nil then
	item_angle_blade = class({}, nil, base_ability_attribute)
end
function item_angle_blade:GetIntrinsicModifierName()
	return "modifier_item_angle_blade"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_angle_blade == nil then
	modifier_item_angle_blade = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_angle_blade:OnCreated(params)
	self.movespeed_pct = self:GetAbilitySpecialValueFor("movespeed_pct")
	self.attack_speed_pct = self:GetAbilitySpecialValueFor("attack_speed_pct")
	self.cooldown_pct = self:GetAbilitySpecialValueFor("cooldown_pct")
	if IsServer() then
		self.tAbility = {}
		for i = 0, 2 do
			local hAbility = self:GetParent():GetAbilityByIndex(i)
			table.insert(self.tAbility, hAbility)
		end
		self:StartIntervalThink(1)
	end
end
function modifier_item_angle_blade:OnRefresh(params)
	self.movespeed_pct = self:GetAbilitySpecialValueFor("movespeed_pct")
	self.attack_speed_pct = self:GetAbilitySpecialValueFor("attack_speed_pct")
	self.cooldown_pct = self:GetAbilitySpecialValueFor("cooldown_pct")
	if IsServer() then
	end
end
function modifier_item_angle_blade:OnIntervalThink()
	local bCooldown = false
	for i, v in ipairs(self.tAbility) do
		if not v:IsCooldownReady() then
			bCooldown = true
		end
	end
	self:SetStackCount(bCooldown and 1 or 0)
	self:ForceRefresh()
end
function modifier_item_angle_blade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
end
function modifier_item_angle_blade:EDeclareFunctions()
	if 0 == self:GetStackCount() then
		return {}
	else
		return {
			[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = self.movespeed_pct,
			[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.attack_speed_pct,
		}
	end
end
function modifier_item_angle_blade:GetModifierPercentageCooldown()
	if self:GetStackCount() == 1 then
		return self.cooldown_pct
	end
end