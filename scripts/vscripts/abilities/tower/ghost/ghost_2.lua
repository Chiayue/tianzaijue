LinkLuaModifier( "modifier_ghost_2", "abilities/tower/ghost/ghost_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ghost_2_debuff", "abilities/tower/ghost/ghost_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if ghost_2 == nil then
	ghost_2 = class({})
end
function ghost_2:GetBonusDamage(hUnit, flDamage)
	local hCaster = self:GetCaster()
	local bonus_damage_pct = self:GetSpecialValueFor("bonus_damage_pct")
	local _flDamage = 0
	if hUnit:HasModifier("modifier_ghost_2_debuff") then
		_flDamage = flDamage * hUnit:GetModifierStackCount("modifier_ghost_2_debuff", hCaster) * bonus_damage_pct * 0.01
	end
	return _flDamage
end
function ghost_2:OnSpellStart(hTarget)
	local hCaster = self:GetCaster()
	if hTarget:HasModifier("modifier_ghost_2_debuff") and hTarget:GetModifierStackCount("modifier_ghost_2_debuff", hCaster) >= self:GetSpecialValueFor("max_stack") then
		return
	end
	hTarget:AddNewModifier(hCaster, self, "modifier_ghost_2_debuff", nil)
end
function ghost_2:GetIntrinsicModifierName()
	return "modifier_ghost_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ghost_2 == nil then
	modifier_ghost_2 = class({}, nil, ModifierHidden)
end
---------------------------------------------------------------------
if modifier_ghost_2_debuff == nil then
	modifier_ghost_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_ghost_2_debuff:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
		if self:GetStackCount() == self:GetAbilitySpecialValueFor("max_stack") then
			self:GetParent():AddBuff(self:GetCaster(), BUFF_TYPE.FROZEN, self:GetAbility():GetDuration())
			self:SetDuration(self:GetAbility():GetDuration(), true)
		end
	end
end
function modifier_ghost_2_debuff:OnRefresh(params)
	self:OnCreated(params)
end