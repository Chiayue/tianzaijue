LinkLuaModifier("modifier_cmd_fur_1", "abilities/commander/cmd_fur/cmd_fur_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_fur_1_buff", "abilities/commander/cmd_fur/cmd_fur_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_fur_1 == nil then
	cmd_fur_1 = class({})
end
function cmd_fur_1:GetIntrinsicModifierName()
	return "modifier_cmd_fur_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_fur_1 == nil then
	modifier_cmd_fur_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_fur_1:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_cmd_fur_1:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_fur_1:UpdateValues()
end
function modifier_cmd_fur_1:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(hCaster)
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_cmd_fur_1_buff') then
					hUnit:AddNewModifier(hCaster, self:GetAbility(), 'modifier_cmd_fur_1_buff', {})
				end
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_fur_1:OnDestroy()
	if IsServer() then
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_fur_1_buff == nil then
	modifier_cmd_fur_1_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_fur_1_buff:OnCreated(params)
	self.armor_bonus = self:GetAbilitySpecialValueFor('armor_bonus')
	if IsServer() then
	end
end
function modifier_cmd_fur_1_buff:OnRefresh(params)
	self.armor_bonus = self:GetAbilitySpecialValueFor('armor_bonus')
	if IsServer() then
	end
end
function modifier_cmd_fur_1_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.armor_bonus,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.armor_bonus,
	}
end
function modifier_cmd_fur_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_fur_1_buff:GetMagicalArmorBonus()
	return self.armor_bonus
end
function modifier_cmd_fur_1_buff:GetPhysicalArmorBonus()
	return self.armor_bonus
end
function modifier_cmd_fur_1_buff:OnTooltip()
	return self.armor_bonus
end