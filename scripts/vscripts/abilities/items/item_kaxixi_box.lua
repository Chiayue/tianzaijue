LinkLuaModifier("modifier_item_kaxixi_box", "abilities/items/item_kaxixi_box.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--咯系系魔盒
if item_kaxixi_box == nil then
	item_kaxixi_box = class({})
end
function item_kaxixi_box:GetIntrinsicModifierName()
	return "modifier_item_kaxixi_box"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_kaxixi_box == nil then
	modifier_item_kaxixi_box = class({}, nil, eom_modifier)
end

function modifier_item_kaxixi_box:OnCreated(params)
	self.attackspeed_increase = self:GetAbilitySpecialValueFor("attackspeed_increase")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_kaxixi_box:OnRefresh(params)
	self.attackspeed_increase = self:GetAbilitySpecialValueFor("attackspeed_increase")
	if IsServer() then
	end
end
function modifier_item_kaxixi_box:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_kaxixi_box:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_ATTACKT_SPEED_BONUS
	}
end
function modifier_item_kaxixi_box:OnInBattle()
	self:IncrementStackCount()
	self:GetAbility():Save("iStackCount", self:GetStackCount())
end
function modifier_item_kaxixi_box:GetAttackSpeedBonus()
	return self:GetStackCount() * self.attackspeed_increase
end


function modifier_item_kaxixi_box:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_kaxixi_box:OnTooltip()
	return self:GetStackCount() * self.attackspeed_increase
end