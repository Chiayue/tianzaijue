LinkLuaModifier("modifier_item_magic_cube", "abilities/items/item_magic_cube.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_magic_cube_thinker", "abilities/items/item_magic_cube.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_magic_cube_thinker_aoe", "abilities/items/item_magic_cube.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_magic_cube_buff", "abilities/items/item_magic_cube.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_magic_cube == nil then
	item_magic_cube = class({}, nil, base_ability_attribute)
end
function item_magic_cube:Precache(context)
	PrecacheResource("particle", "particles/items/item_magic_cube/magic_cube.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf", context)
end
function item_magic_cube:GetIntrinsicModifierName()
	return "modifier_item_magic_cube"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_magic_cube == nil then
	modifier_item_magic_cube = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_magic_cube:IsHidden()
	return true
end
function modifier_item_magic_cube:OnCreated(params)
	self.cube_count = self:GetAbilitySpecialValueFor("cube_count")
	self.cube_radius = self:GetAbilitySpecialValueFor("cube_radius")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_magic_cube:OnRefresh(params)
	self.cube_count = self:GetAbilitySpecialValueFor("cube_count")
	self.cube_radius = self:GetAbilitySpecialValueFor("cube_radius")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_magic_cube:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_magic_cube:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = { self:GetParent() }
	}
end
function modifier_item_magic_cube:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 1500, hAbility)
	if IsValid(tTargets[1]) then
		CreateModifierThinker(hParent, hAbility, "modifier_item_magic_cube_thinker", { duration = 0.6 }, tTargets[1]:GetAbsOrigin() + RandomVector(RandomInt(0, self.cube_radius)), hParent:GetTeamNumber(), false)
		self:DecrementStackCount()
	else
		self:SetStackCount(0)
	end
	if self:GetStackCount() == 0 then
		self:StartIntervalThink(-1)
		return
	end
end
function modifier_item_magic_cube:OnAbilityExecuted(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if params.unit == self:GetParent() then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 1500, hAbility)
		for i, hUnit in ipairs(tTargets) do
			if i <= self.cube_count then
				CreateModifierThinker(hParent, hAbility, "modifier_item_magic_cube_thinker", { duration = 0.6 }, hUnit:GetAbsOrigin() + RandomVector(RandomInt(0, self.cube_radius)), hParent:GetTeamNumber(), false)
			else
				break
			end
		end
		if #tTargets < self.cube_count then
			self:SetStackCount(self:GetStackCount() + self.cube_count - #tTargets)
			self:StartIntervalThink(0.2)
		end
		-- -- 三星
		-- if hAbility:GetLevel() >= self.unlock_level and hAbility:IsCooldownReady() then
		-- 	hAbility:UseResources(false, false, true)
		-- 	CreateModifierThinker(hParent, hAbility, "modifier_item_magic_cube_thinker_aoe", { duration = self.duration }, hParent:GetAbsOrigin(), hParent:GetTeamNumber(), false)
		-- 	hParent:EmitSound("Hero_FacelessVoid.Chronosphere")
		-- end
	end
end
---------------------------------------------------------------------
if modifier_item_magic_cube_thinker == nil then
	modifier_item_magic_cube_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_item_magic_cube_thinker:OnCreated(params)
	self.cube_radius = self:GetAbilitySpecialValueFor("cube_radius")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items/item_magic_cube/magic_cube.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_magic_cube_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.cube_radius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			hCaster:DealDamage(hUnit, self:GetAbility(), 0)
			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_duration)
		end
		-- 落地音效
		EmitSoundOnLocationWithCaster(hParent:GetAbsOrigin(), "Hero_Invoker.ChaosMeteor.Impact", hCaster)
		if IsValid(hParent) then
			hParent:RemoveSelf()
		end
	end
end
---------------------------------------------------------------------
if modifier_item_magic_cube_thinker_aoe == nil then
	modifier_item_magic_cube_thinker_aoe = class({}, nil, ParticleModifierThinker)
end
function modifier_item_magic_cube_thinker_aoe:IsAura()
	return true
end
function modifier_item_magic_cube_thinker_aoe:GetAuraRadius()
	return self.radius
end
function modifier_item_magic_cube_thinker_aoe:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_item_magic_cube_thinker_aoe:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_item_magic_cube_thinker_aoe:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_magic_cube_thinker_aoe:GetModifierAura()
	return "modifier_item_magic_cube_buff"
end
function modifier_item_magic_cube_thinker_aoe:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
---------------------------------------------------------------------
if modifier_item_magic_cube_buff == nil then
	modifier_item_magic_cube_buff = class({}, nil, eom_modifier)
end
function modifier_item_magic_cube_buff:IsHidden()
	return true
end
function modifier_item_magic_cube_buff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -100
	}
end