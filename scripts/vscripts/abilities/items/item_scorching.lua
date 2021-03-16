LinkLuaModifier("modifier_item_scorching", "abilities/items/item_scorching.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_scorching_firesea", "abilities/items/item_scorching.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_scorching == nil then
	item_scorching = class({}, nil, base_ability_attribute)
end
function item_scorching:GetIntrinsicModifierName()
	return "modifier_item_scorching"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_scorching == nil then
	modifier_item_scorching = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_scorching:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_item_scorching:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_item_scorching:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_scorching:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() }
	}
end
function modifier_item_scorching:OnDeath(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if params.attacker == self:GetParent() then
		local vPosition = params.unit:GetAbsOrigin()
		CreateModifierThinker(hParent, hAbility, "modifier_item_scorching_firesea", { duration = self.duration }, vPosition, hParent:GetTeamNumber(), false)
	end
end
-- thinker
---------------------------------------------------------------------
if modifier_item_scorching_firesea == nil then
	modifier_item_scorching_firesea = class({}, nil, ParticleModifierThinker)
end
function modifier_item_scorching_firesea:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage_interval = self:GetAbilitySpecialValueFor("damage_interval")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
		self:StartIntervalThink(self.damage_interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/brewmaster_firespirit_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_scorching_firesea:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end
function modifier_item_scorching_firesea:OnIntervalThink()
	if not IsValid(self:GetCaster()) then
		self:Destroy()
		return
	end
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local phyDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	local magDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)
	local baseattack = phyDamage + magDamage
	for _, hUnit in pairs(tTargets) do
		local damageInfo =		{
			victim = hUnit,
			attacker = self:GetCaster(),
			damage = baseattack * self.damage_pct * 0.01,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility,
		}
		ApplyDamage(damageInfo)
	end
end