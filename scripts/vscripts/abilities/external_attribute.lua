---卡牌英雄成长属性
LinkLuaModifier("modifier_external_attribute", "abilities/external_attribute.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if external_attribute == nil then
	external_attribute = class({})
end
function external_attribute:GetIntrinsicModifierName()
	return "modifier_external_attribute"
end
function external_attribute:OnHeroLevelUp()
	self:SetLevel(self:GetLevel() + 1)
end
---------------------------------------------------------------------
--Modifiers
if modifier_external_attribute == nil then
	modifier_external_attribute = class({}, nil, eom_modifier)
end
function modifier_external_attribute:IsHidden()
	return self:GetStackCount() == 0 or self:GetStackCount() == 1
end
function modifier_external_attribute:OnCreated(params)
	self.sAttributeKey = self:GetParent():GetEntityIndex() .. self:GetName()
	if IsServer() then
		local hParent = self:GetParent()
		local iCardID = DotaTD:GetCardID(hParent:GetUnitName())

		self:SetStackCount(HeroCard:GetPlayerHeroCardLevel(GetPlayerID(hParent), iCardID))
		self:OnUpdate()
	end
end
function modifier_external_attribute:OnRefresh(params)
	if IsServer() then
		self:OnUpdate()
	end
end
function modifier_external_attribute:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		for _, typeAtrbt in pairs(self.tAttributes) do
			AttributeSystem[typeAtrbt]:SetVal(hParent, nil, self.sAttributeKey)
			AttributeSystem[typeAtrbt]:UpdateClient(hParent, self.sAttributeKey)
		end
	end
end
function modifier_external_attribute:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_external_attribute:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { 'UpdateExternalAttribute', 'OnUpdate' }
	}
end
function modifier_external_attribute:OnUpdate()
	local hParent = self:GetParent()
	local iPlayerID = GetPlayerID(hParent)
	local sUnitName = hParent:GetUnitName()
	self.tAttributes = {}
	local tAttributes = CardGrowingUp:GetPlayerGrowingUpAttribute(iPlayerID, sUnitName, hParent:GetLevel())
	if tAttributes then
		for typeAtrbt, iVal in pairs(tAttributes) do
			if
			typeAtrbt == ATTRIBUTE_KIND.PhysicalAttack
			or typeAtrbt == ATTRIBUTE_KIND.MagicalAttack
			or typeAtrbt == ATTRIBUTE_KIND.PhysicalArmor
			or typeAtrbt == ATTRIBUTE_KIND.MagicalArmor
			or typeAtrbt == ATTRIBUTE_KIND.StatusHealth
			then
				local fBase = AttributeSystem[typeAtrbt]:GetValByKey(hParent, ATTRIBUTE_KEY.BASE)
				iVal = fBase * iVal * 0.01
			end
			AttributeSystem[typeAtrbt]:SetVal(hParent, iVal, self.sAttributeKey)
			AttributeSystem[typeAtrbt]:UpdateClient(hParent, self.sAttributeKey)
			table.insert(self.tAttributes, typeAtrbt)
		end
	end
end
function modifier_external_attribute:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 9
	if 0 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, self.sAttributeKey)
	elseif 1 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.MagicalAttack, self.sAttributeKey)
	elseif 2 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.PhysicalArmor, self.sAttributeKey)
	elseif 3 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.MagicalArmor, self.sAttributeKey)
	elseif 4 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.StatusHealth, self.sAttributeKey)
	elseif 5 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.StatusMana, self.sAttributeKey)
	elseif 6 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.ManaRegen, self.sAttributeKey)
	elseif 7 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.AttackSpeed, self.sAttributeKey)
	elseif 8 == self._iTooltip then
		return hParent:GetValByKey(ATTRIBUTE_KIND.MoveSpeed, self.sAttributeKey)
	end
	return 0
end