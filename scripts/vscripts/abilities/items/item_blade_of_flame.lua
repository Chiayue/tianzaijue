LinkLuaModifier( "modifier_item_blade_of_flame", "abilities/items/item_blade_of_flame.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_blade_of_flame == nil then
	item_blade_of_flame = class({}, nil, base_ability_attribute)
end
function item_blade_of_flame:GetIntrinsicModifierName()
	return "modifier_item_blade_of_flame"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_blade_of_flame == nil then
	modifier_item_blade_of_flame = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_blade_of_flame:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.damage_per_count = self:GetAbilitySpecialValueFor("damage_per_count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
	--self.magical_strengthen = self:GetAbilitySpecialValueFor("magical_strengthen")
	self.ignite_duration = self:GetAbilitySpecialValueFor("ignite_duration")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_item_blade_of_flame:OnRefresh(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.damage_per_count = self:GetAbilitySpecialValueFor("damage_per_count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
	--self.magical_strengthen = self:GetAbilitySpecialValueFor("magical_strengthen")
	self.ignite_duration = self:GetAbilitySpecialValueFor("ignite_duration")
	if IsServer() then
	end
end
function modifier_item_blade_of_flame:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddBuff(hParent, BUFF_TYPE.IGNITE, self.ignite_duration, true, { iCount = self.ignite_count })
	end
end
function modifier_item_blade_of_flame:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		--[EMDF_MAGICAL_OUTGOING_PERCENTAGE] = self.magical_strengthen,
	}
end
function modifier_item_blade_of_flame:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hParent = self:GetParent()

	self:IncrementStackCount()
	if self:GetStackCount() >= self.attack_count then
		self:SetStackCount(0)
		local hModifier = hTarget:FindModifierByName("modifier_ignite")
		if IsValid(hModifier) and hModifier:GetStackCount() > 0 then
			hParent:DealDamage(hTarget, self:GetAbility(), self.damage_per_count * hModifier:GetStackCount() * hParent:GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01)
		end
	end
end