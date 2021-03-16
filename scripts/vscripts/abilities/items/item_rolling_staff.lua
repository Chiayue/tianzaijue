LinkLuaModifier("modifier_item_rolling_staff", "abilities/items/item_rolling_staff.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_rolling_staff == nil then
	item_rolling_staff = class({})
end
function item_rolling_staff:GetIntrinsicModifierName()
	return "modifier_item_rolling_staff"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_rolling_staff == nil then
	modifier_item_rolling_staff = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_rolling_staff:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	self.radius = self:GetAbilitySpecialValueFor('radius')
	self.damage_pct = self:GetAbilitySpecialValueFor('damage_pct')
	self:SetStackCount(0)
	if IsServer() then
	end
end
function modifier_item_rolling_staff:OnRefresh(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	self.radius = self:GetAbilitySpecialValueFor('radius')
	self.damage_pct = self:GetAbilitySpecialValueFor('damage_pct')
	if IsServer() then
	end
end
function modifier_item_rolling_staff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_rolling_staff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_item_rolling_staff:OnAttackLanded(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
	local hTarget = params.target
	if self:GetStackCount() < self.count then
		self:IncrementStackCount()
	end
	-- aoe
	if self:GetStackCount() == self.count then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_ecage_formation.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damage = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack) + self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
		for _, hTarget in pairs(tTargets) do
			local tDamage = {
				ability = self:GetAbility(),
				attacker = hParent,
				victim = hTarget,
				damage = damage * self.damage_pct * 0.01,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(tDamage)
		end
		self:SetStackCount(0)
	end
end