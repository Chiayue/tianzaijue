LinkLuaModifier("modifier_ember_spirit_2", "abilities/tower/ember_spirit/ember_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_2_buff", "abilities/tower/ember_spirit/ember_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
if ember_spirit_2 == nil then
	ember_spirit_2 = class({}, nil, ability_base_ai)
end
function ember_spirit_2:GetAOERadius()
	return self:GetCaster():Script_GetAttackRange()
end
function ember_spirit_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("health_damage_pct") * hCaster:GetMaxHealth() * 0.01

	local hAbility = hCaster:FindAbilityByName("ember_spirit_3")
	local tTargets = {}
	if IsValid(hAbility) then
		tTargets = hAbility.tRemnant
	end
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		table.insert(tTargets, hUnit)
	end, UnitType.AllFirends)

	for _, hUnit in pairs(tTargets) do
		if IsValid(hUnit) then
			hUnit:AddNewModifier(hCaster, self, "modifier_ember_spirit_2_buff", { duration = self:GetDuration() })
		end
	end

	hCaster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
end
function ember_spirit_2:GetIntrinsicModifierName()
	return "modifier_ember_spirit_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ember_spirit_2 == nil then
	modifier_ember_spirit_2 = class({}, nil, ModifierHidden)
end
function modifier_ember_spirit_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_ember_spirit_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end
---------------------------------------------------------------------
if modifier_ember_spirit_2_buff == nil then
	modifier_ember_spirit_2_buff = class({}, nil, eom_modifier)
end
function modifier_ember_spirit_2_buff:OnCreated(params)
	self.absorb_damage = self:GetAbilitySpecialValueFor("absorb_damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.ignite_duration = self:GetAbilitySpecialValueFor("ignite_duration")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
	local hCaster = self:GetCaster()
	if IsValid(hCaster) then
		self.cur_phy_atk = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
		self.absorb_damage = self.absorb_damage * self.cur_phy_atk * 0.01
		self.fShieldHealth = self.absorb_damage
	end
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/ember_spirit/ember_spirit_2_spirit_flameguard.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.radius, self.radius, self.radius))
		ParticleManager:SetParticleControl(iParticleID, 3, Vector(hParent:GetModelRadius(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_ember_spirit_2_buff:OnRefresh(params)
	self.ignite_duration = self:GetAbilitySpecialValueFor("ignite_duration")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
	if IsServer() then
	end
end
function modifier_ember_spirit_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		local damage_table = {
			ability = self:GetAbility(),
			attacker = hCaster,
			victim = hUnit,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(damage_table)
		hUnit:AddBuff(hParent, BUFF_TYPE.IGNITE, self.ignite_duration, true, { iCount = self.ignite_count })
	end
end
function modifier_ember_spirit_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_ember_spirit_2_buff:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(params)
	if params.damage_type == DAMAGE_TYPE_MAGICAL then
		local blockDamage = self.fShieldHealth - math.max(self.fShieldHealth - params.damage, 0)
		self.fShieldHealth = self.fShieldHealth - blockDamage
		if self.fShieldHealth <= 0 then
			self:Destroy()
		end
		return blockDamage
	end
end
function modifier_ember_spirit_2_buff:OnTooltip()
	return self.fShieldHealth
end