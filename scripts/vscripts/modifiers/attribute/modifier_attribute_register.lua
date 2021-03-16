if modifier_attribute_register == nil then
	modifier_attribute_register = class({}, nil, BaseModifier)
end

local public = modifier_attribute_register

function public:IsHidden()
	return true
end
function public:OnCreated(table)
	local hUnit = self:GetParent()
	local sHeroName = hUnit:GetUnitName()
	local tData
	if KeyValues.HeroesKv then
		tData = KeyValues.HeroesKv[sHeroName]
	end
	if not tData and KeyValues.UnitsKv then
		tData = KeyValues.UnitsKv[sHeroName]
	end

	if IsServer() then
		hUnit:SetBaseDamageMin(0)
		hUnit:SetBaseDamageMax(0)

		hUnit:SetPhysicalArmorBaseValue(0)
		hUnit:SetBaseMagicalResistanceValue(0)

		hUnit:SetBaseManaRegen(0)
		if hUnit.SetManaRegenGain then
			hUnit:SetManaRegenGain(0)
		end

		-- 碰撞体积
		if tData and tData.BoundsHullRadius ~= nil then
			hUnit:SetHullRadius(tData.BoundsHullRadius)
		end
	else
	end

	if not tData then
		return
	end

	--生命值
	hUnit:SetVal(ATTRIBUTE_KIND.StatusHealth, tData.StatusHealth, ATTRIBUTE_KEY.BASE)

	--攻击力
	if tData.MagicalAttack and 0 ~= tData.MagicalAttack then
		hUnit:SetVal(ATTRIBUTE_KIND.MagicalAttack, tData.MagicalAttack, ATTRIBUTE_KEY.BASE)
	end

	if tData.PhysicalAttack and 0 ~= tData.PhysicalAttack then
		hUnit:SetVal(ATTRIBUTE_KIND.PhysicalAttack, tData.PhysicalAttack, ATTRIBUTE_KEY.BASE)
	end

	--防御力
	if tData.MagicalArmor and 0 ~= tData.MagicalArmor then
		hUnit:SetVal(ATTRIBUTE_KIND.MagicalArmor, tData.MagicalArmor, ATTRIBUTE_KEY.BASE)
	end
	if tData.PhysicalArmor and 0 ~= tData.PhysicalArmor then
		hUnit:SetVal(ATTRIBUTE_KIND.PhysicalArmor, tData.PhysicalArmor, ATTRIBUTE_KEY.BASE)
	end

	--回蓝
	if tData.StatusManaRegen and 0 ~= tData.StatusManaRegen then
		hUnit:SetVal(ATTRIBUTE_KIND.ManaRegen, tData.StatusManaRegen, ATTRIBUTE_KEY.BASE)
	end
	if tData.ManaRegenOutgoing and 0 ~= tData.ManaRegenOutgoing then
		hUnit:SetVal(ATTRIBUTE_KIND.OutgoingManaRegen, tData.ManaRegenOutgoing, ATTRIBUTE_KEY.BASE)
	end
	if tData.ManaRegenIncoming and 0 ~= tData.ManaRegenIncoming then
		hUnit:SetVal(ATTRIBUTE_KIND.IncomingManaRegen, tData.ManaRegenIncoming, ATTRIBUTE_KEY.BASE)
	end

	-- 初始状态抗性百分比
	if tData.StateResistance and 0 ~= tData.StateResistance then
		hUnit:SetVal(ATTRIBUTE_KIND.StatusResistancePercentage, tData.StateResistance, ATTRIBUTE_KEY.BASE)
	end
end
function public:OnDestroy()
end