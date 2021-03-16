LinkLuaModifier("modifier_item_fire_elf_scepter", "abilities/items/item_fire_elf_scepter.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_fire_elf_scepter == nil then
	item_fire_elf_scepter = class({}, nil, base_ability_attribute)
end
function item_fire_elf_scepter:GetIntrinsicModifierName()
	return "modifier_item_fire_elf_scepter"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_fire_elf_scepter == nil then
	modifier_item_fire_elf_scepter = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_fire_elf_scepter:OnCreated(params)
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	self.incoming_reduce = self:GetAbilitySpecialValueFor("incoming_reduce")
	self.magical_strengthen = self:GetAbilitySpecialValueFor("magical_strengthen")
	self.stack = self:GetAbilitySpecialValueFor("stack")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:SetStackCount(0)
		self:StartIntervalThink(1)
	end
end

function modifier_item_fire_elf_scepter:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local vPosition = hParent:GetAbsOrigin()
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		local count = 0

		for i, tUnit in ipairs(tTargets) do
			if tUnit:HasModifier("modifier_ignite") then
				local unit_debuffCount = tUnit:FindModifierByName("modifier_ignite"):GetStackCount()
				count = count + unit_debuffCount
			end
		end
		if self.incoming_reduce * math.floor(self:GetStackCount() / self.stack) < 100 then
			self:SetStackCount(count)
		else
			count = 100 * self.stack / self.incoming_reduce - 1
			self:SetStackCount(count)
		end
	end
end

function modifier_item_fire_elf_scepter:OnDestroy()
	if IsServer() then
	end
end

function modifier_item_fire_elf_scepter:IsHidden()
	return false
end

function modifier_item_fire_elf_scepter:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.incoming_reduce * math.floor(self:GetStackCount() / self.stack),
		[EMDF_HEALTH_REGEN_BONUS] = self.health_regen * math.floor(self:GetStackCount() / self.stack),
		[EMDF_MAGICAL_OUTGOING_PERCENTAGE] = self.magical_strengthen * math.floor(self:GetStackCount() / self.stack)
	}
end

function modifier_item_fire_elf_scepter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_fire_elf_scepter:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 3
	if 0 == self.iTooltip then
		return self.health_regen * math.floor(self:GetStackCount() / self.stack)
	end
	if 1 == self.iTooltip then
		return self.incoming_reduce * math.floor(self:GetStackCount() / self.stack)
	end
	return self.magical_strengthen * math.floor(self:GetStackCount() / self.stack)
end