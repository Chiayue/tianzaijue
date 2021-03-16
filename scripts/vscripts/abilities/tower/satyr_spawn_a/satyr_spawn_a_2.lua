LinkLuaModifier("modifier_satyr_spawn_a_2", "abilities/tower/satyr_spawn_a/satyr_spawn_a_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_spawn_a_2_share_damage", "abilities/tower/satyr_spawn_a/satyr_spawn_a_2.lua", LUA_MODIFIER_MOTION_NONE)

if satyr_spawn_a_2 == nil then
	satyr_spawn_a_2 = class({})
end
function satyr_spawn_a_2:GetIntrinsicModifierName()
	return "modifier_satyr_spawn_a_2"
end
------------------------------------------------------------------------------
if modifier_satyr_spawn_a_2 == nil then
	modifier_satyr_spawn_a_2 = class({}, nil, eom_modifier_aura)
end
function modifier_satyr_spawn_a_2:IsHidden()
	return false
end
function modifier_satyr_spawn_a_2:GetAuraUnitType()
	return UnitType.AllFirends
end
function modifier_satyr_spawn_a_2:GetAuraEntityReject(hEntity)
	return hEntity == self:GetParent()
end
function modifier_satyr_spawn_a_2:GetModifierAura()
	return 'modifier_satyr_spawn_a_2_share_damage'
end
function modifier_satyr_spawn_a_2:OnCreated(params)
	self.magical_armor_bonus_pct = self:GetAbilitySpecialValueFor("magical_armor_bonus_pct")
end
function modifier_satyr_spawn_a_2:OnRefresh()
	self.magical_armor_bonus_pct = self:GetAbilitySpecialValueFor("magical_armor_bonus_pct")
end
function modifier_satyr_spawn_a_2:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS,
	}
end
function modifier_satyr_spawn_a_2:GetMagicalArmorBonus()
	-- print("hanzhen", self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack))
	return self.magical_armor_bonus_pct * self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01
end
------------------------------------------------------------------------------
if modifier_satyr_spawn_a_2_share_damage == nil then
	modifier_satyr_spawn_a_2_share_damage = class({}, nil, eom_modifier)
end
function modifier_satyr_spawn_a_2_share_damage:OnCreated(params)
	self.take_magic_damage_pct = self:GetAbilitySpecialValueFor("take_magic_damage_pct")
	if IsServer() then
	end
end
function modifier_satyr_spawn_a_2_share_damage:OnRefresh(params)
	self.take_magic_damage_pct = self:GetAbilitySpecialValueFor("take_magic_damage_pct")
end
function modifier_satyr_spawn_a_2_share_damage:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.take_magic_damage_pct,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_satyr_spawn_a_2_share_damage:OnTakeDamage(params)
	if IsServer() then
		if IsValid(self:GetCaster())
		and params.unit == self:GetParent()
		and params.unit ~= self:GetCaster()
		and self:GetCaster():IsAlive() then
			local fDamage = params.original_damage * self.take_magic_damage_pct * 0.01
			if 0 < fDamage then
				local damage_table = {
					ability = self,
					attacker = params.attacker,
					victim = self:GetCaster(),
					damage = fDamage,
					-- damage_type = params.damage_type
					damage_type = DAMAGE_TYPE_MAGICAL
				}
				ApplyDamage(damage_table)
			end
		end
	end
end