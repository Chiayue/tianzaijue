LinkLuaModifier("modifier_art_giant_mask_buff", "abilities/artifact/art_giant_mask.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_giant_mask_armor", "abilities/artifact/art_giant_mask.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_giant_mask == nil then
	art_giant_mask = class({}, nil, artifact_base)
end
function art_giant_mask:GetIntrinsicModifierName()
	return "modifier_art_giant_mask_buff"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_giant_mask_buff == nil then
	modifier_art_giant_mask_buff = class({}, nil, eom_modifier)
end
function modifier_art_giant_mask_buff:OnCreated(params)
	self.probability = self:GetAbilitySpecialValueFor("probability")
	self.armor_bonus_pct_max = self:GetAbilitySpecialValueFor("armor_bonus_pct_max")
	self.armor_bonus_pct_min = self:GetAbilitySpecialValueFor("armor_bonus_pct_min")
	self.tModifiers = {}
end
function modifier_art_giant_mask_buff:OnRefresh(params)
	self.probability = self:GetAbilitySpecialValueFor("probability")
	self.armor_bonus_pct_max = self:GetAbilitySpecialValueFor("armor_bonus_pct_max")
	self.armor_bonus_pct_min = self:GetAbilitySpecialValueFor("armor_bonus_pct_min")
end
function modifier_art_giant_mask_buff:OnDestroy(params)
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_giant_mask_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
	}
end
function modifier_art_giant_mask_buff:OnInBattle()
	if not IsServer() then
		return
	end

	if IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		local iRandom = RandomInt(1, 100)
		if iRandom <= self.probability then
			local hParent = self:GetParent()
			local iBonusPct = RandomInt(self.armor_bonus_pct_min, self.armor_bonus_pct_max)

			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_giant_mask_armor') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_giant_mask_armor", { iBonusPct = iBonusPct })
				end
			end, UnitType.Building)
		end
	end
end

------------------------------------------------------------------------------
if modifier_art_giant_mask_armor == nil then
	modifier_art_giant_mask_armor = class({}, nil, eom_modifier)
end
function modifier_art_giant_mask_armor:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iBonusPct)
	end
end
function modifier_art_giant_mask_armor:OnRefresh(params)
	if IsServer() then
		self:SetStackCount(params.iBonusPct)
	end
end
function modifier_art_giant_mask_armor:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_giant_mask_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_art_giant_mask_armor:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE,
		EMDF_MAGICAL_ATTACK_BONUS_UNIQUE,
	}
end
function modifier_art_giant_mask_armor:OnBattleEnd()
	if IsValid(self) then
		self:Destroy()
	end
end
function modifier_art_giant_mask_armor:GetPhysicalAttackBonusUnique()
	---获取非独立护甲值转为独立攻击力（防止循环叠加）
	local i = self:GetParent():GetValConst(ATTRIBUTE_KIND.PhysicalArmor, ATTRIBUTE_FLAG.NONE)
	local fPer = self:GetParent():GetValPercent(ATTRIBUTE_KIND.PhysicalArmor, ATTRIBUTE_FLAG.NONE)
	return i * fPer * self:GetStackCount() * 0.01
end
function modifier_art_giant_mask_armor:GetMagicalAttackBonusUnique()
	local i = self:GetParent():GetValConst(ATTRIBUTE_KIND.MagicalArmor, ATTRIBUTE_FLAG.NONE)
	local fPer = self:GetParent():GetValPercent(ATTRIBUTE_KIND.MagicalArmor, ATTRIBUTE_FLAG.NONE)
	return i * fPer * self:GetStackCount() * 0.01
end
function modifier_art_giant_mask_armor:OnTooltip()
	return self:GetStackCount()
end
function modifier_art_giant_mask_armor:OnTooltip2()
	if 1 == self._OnTooltip2 then
		self._OnTooltip2 = 2
		return self:GetMagicalAttackBonusUnique()
	end
	self._OnTooltip2 = 1
	return self:GetPhysicalAttackBonusUnique()
end