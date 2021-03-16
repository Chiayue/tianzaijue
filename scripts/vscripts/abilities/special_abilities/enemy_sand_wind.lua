LinkLuaModifier("modifier_enemy_sand_wind", "abilities/special_abilities/enemy_sand_wind.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_sand_wind_buff", "abilities/special_abilities/enemy_sand_wind.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_sand_wind_debuff", "abilities/special_abilities/enemy_sand_wind.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_sand_wind == nil then
	enemy_sand_wind = class({})
end
function enemy_sand_wind:GetIntrinsicModifierName()
	return "modifier_enemy_sand_wind"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_sand_wind == nil then
	modifier_enemy_sand_wind = class({}, nil, eom_modifier)
end
function modifier_enemy_sand_wind:OnCreated(params)
	self.slow_down_duration = self:GetAbilitySpecialValueFor("slow_down_duration")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_enemy_sand_wind:OnRefresh(params)
	self.slow_down_duration = self:GetAbilitySpecialValueFor("slow_down_duration")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_enemy_sand_wind:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_sand_wind:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
	}
end
function modifier_enemy_sand_wind:OnTakeDamage(params)
	if params.unit ~= self:GetParent() or not IsValid(params.attacker) then return end
	if 0 >= params.damage then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:IsAlive() and RollPercentage(self.chance) then
		hParent:AddNewModifier(hParent, hAbility, "modifier_enemy_sand_wind_buff", { duration = self.slow_down_duration })
		params.attacker:AddNewModifier(hParent, hAbility, "modifier_enemy_sand_wind_debuff", { duration = self.slow_down_duration })
	end
end
function modifier_enemy_sand_wind:IsHidden()
	return true
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_sand_wind_buff == nil then
	modifier_enemy_sand_wind_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_sand_wind_buff:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient_a.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 4, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParID = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParID, false, false, -1, false, false)
	else
	end
end
function modifier_enemy_sand_wind_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_sand_wind_buff:OnRefresh(params)
	if IsServer() then

	end
end
function modifier_enemy_sand_wind_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_sand_wind_debuff == nil then
	modifier_enemy_sand_wind_debuff = class({}, nil, eom_modifier)
end
function modifier_enemy_sand_wind_debuff:OnCreated(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_enemy_sand_wind_debuff:OnRefresh(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
	if IsServer() then
	end
end
function modifier_enemy_sand_wind_debuff:EDeclareFunctions(params)
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_slow
	}
end
function modifier_enemy_sand_wind_debuff:GetMoveSpeedBonusPercentage(params)
	return -self.movespeed_slow
end
function modifier_enemy_sand_wind_debuff:IsDebuff()
	return true
end