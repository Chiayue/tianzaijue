LinkLuaModifier("modifier_cmd_enchantress_2", "abilities/commander/cmd_enchantress/cmd_enchantress_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_enchantress_2_buff", "abilities/commander/cmd_enchantress/cmd_enchantress_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_enchantress_2 == nil then
	cmd_enchantress_2 = class({})
end
function cmd_enchantress_2:GetIntrinsicModifierName()
	return "modifier_cmd_enchantress_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_enchantress_2 == nil then
	modifier_cmd_enchantress_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_enchantress_2:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_cmd_enchantress_2:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_enchantress_2:IsHidden()
	return true
end
function modifier_cmd_enchantress_2:UpdateValues()
	self.distance = self:GetAbilitySpecialValueFor('distance')
	self.atkbonuspct = self:GetAbilitySpecialValueFor('atkbonuspct')
end
function modifier_cmd_enchantress_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_cmd_enchantress_2:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local iDistance = (hTarget:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
	local iTimes = math.floor(iDistance / self.distance) * self.atkbonuspct
	local damage = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack) * iTimes * 0.01
	local tDamage = {
		ability = self:GetAbility(),
		attacker = self:GetParent(),
		victim = hTarget,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(tDamage)
end
function modifier_cmd_enchantress_2:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_cmd_enchantress_2_buff') then
					if hUnit:IsRangedAttacker() then
						hUnit:AddNewModifier(hCaster, self:GetAbility(), 'modifier_cmd_enchantress_2_buff', {})
					end
				end
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_enchantress_2:OnDestroy()
	if IsServer() then
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_enchantress_2_buff == nil then
	modifier_cmd_enchantress_2_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_enchantress_2_buff:OnCreated(params)
	self.attack_range_bonus = self:GetAbilitySpecialValueFor('attack_range_bonus')
	if IsServer() then
	end
end
function modifier_cmd_enchantress_2_buff:OnRefresh(params)
	self.attack_range_bonus = self:GetAbilitySpecialValueFor('attack_range_bonus')
	if IsServer() then
	end
end
function modifier_cmd_enchantress_2_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACK_RANGE_BONUS] = self.attack_range_bonus,
	}
end
function modifier_cmd_enchantress_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_enchantress_2_buff:OnTooltip()
	return	self.attack_range_bonus
end
function modifier_cmd_enchantress_2_buff:GetAttackRangeBonus()
	return self.attack_range_bonus
end