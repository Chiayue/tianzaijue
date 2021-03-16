
LinkLuaModifier( "modifier_shredderA_3", "abilities/tower/shredderA/shredderA_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shredderA_3_debuff", "abilities/tower/shredderA/shredderA_3.lua", LUA_MODIFIER_MOTION_NONE )
if shredderA_3 == nil then
	shredderA_3 = class({})
end
function shredderA_3:Action(hTarget)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_shredderA_3_debuff", {duration = self:GetDuration()})
end
function shredderA_3:GetIntrinsicModifierName()
	return "modifier_shredderA_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderA_3 == nil then
	modifier_shredderA_3 = class({}, nil, ModifierHidden)
end
---------------------------------------------------------------------
if modifier_shredderA_3_debuff == nil then
	modifier_shredderA_3_debuff = class({}, nil, eom_modifier)
end
function modifier_shredderA_3_debuff:IsDebuff()
	return true
end
function modifier_shredderA_3_debuff:OnCreated(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	if IsServer() then
		self.tData = { self:GetDieTime() }
		self:IncrementStackCount()
		self:StartIntervalThink(0)
	end
end
function modifier_shredderA_3_debuff:OnRefresh(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	if IsServer() then
		table.insert(self.tData, self:GetDieTime())
		self:IncrementStackCount()
	end
end
function modifier_shredderA_3_debuff:OnIntervalThink()
	local fGameTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if fGameTime > self.tData[i] then
			table.remove(self.tData, i)
			self:DecrementStackCount()
		end
	end
end
function modifier_shredderA_3_debuff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_shredderA_3_debuff:GetPhysicalArmorBonus()
	return -self.armor_reduce * self:GetStackCount()
end
function modifier_shredderA_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_shredderA_3_debuff:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 2
	if 0 == self._iTooltip then
		return self.armor_reduce * self:GetStackCount()
	elseif 1 == self._iTooltip then
		return self.movespeed_reduce_pct
	end
end