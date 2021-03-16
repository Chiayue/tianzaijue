LinkLuaModifier("modifier_enemy_shield", "abilities/special_abilities/enemy_shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_shield_buff", "abilities/special_abilities/enemy_shield.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_shield == nil then
	enemy_shield = class({})
end
function enemy_shield:GetIntrinsicModifierName()
	return "modifier_enemy_shield"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_shield == nil then
	modifier_enemy_shield = class({})
end
function modifier_enemy_shield:OnCreated(params)
	self.block_times = self:GetAbilitySpecialValueFor("block_times")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_enemy_shield:OnRefresh(params)
	self.block_times = self:GetAbilitySpecialValueFor("block_times")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
	end
end
function modifier_enemy_shield:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_shield:EDeclareFunctions()
	return {
	}
end
function modifier_enemy_shield:OnIntervalThink()
	if self:GetParent():IsAlive() then
		local hAbility = self:GetAbility()
		local hParent = self:GetParent()
		if hParent:HasModifier("modifier_ghost_enemy") then return end
		if hParent:HasModifier("modifier_enemy_shield_buff") then hParent:RemoveModifierByName("modifier_enemy_shield_buff") return end
		if hAbility and GSManager:getStateType() == GS_Battle then
			hAbility:UseResources(false, false, true)
			hParent:AddNewModifier(hParent, hAbility, "modifier_enemy_shield_buff", {})
		end
	end
end
function modifier_enemy_shield:IsHidden()
	return true
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_shield_buff == nil then
	modifier_enemy_shield_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_shield_buff:OnCreated(params)
	self.block_times = self:GetAbilitySpecialValueFor("block_times")
	self.isstacked = self:GetAbilitySpecialValueFor("isstacked")
	-- isstacked 如果是0 代表不叠加，如果不是0就是叠加
	if IsServer() then
		self:SetStackCount(self.block_times)
	else
		local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf', PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iPtclID, 1, self:GetParent(), PATTACH_CENTER_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iPtclID, false, false, -1, false, true)
	end
end
function modifier_enemy_shield_buff:OnRefresh(params)
	self.block_times = self:GetAbilitySpecialValueFor("block_times")
	self.isstacked = self:GetAbilitySpecialValueFor("isstacked")
	if self:GetStackCount() == 0 then
		self:Destroy()
	elseif self.isstacked == 0 and IsServer() then
		-- self:SetStackCount(self:GetStackCount() + self.block_times)
	end

end
function modifier_enemy_shield_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_shield_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_enemy_shield_buff:OnTooltip()
	return self:GetStackCount()
end

function modifier_enemy_shield_buff:GetModifierAvoidDamage(params)
	local hParent = self:GetParent()
	if IsValid(params.attacker) and params.damage >= 0 and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
		local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticleID, 1, (hParent:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized())
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		hParent:EmitSound("Hero_TemplarAssassin.Refraction.Absorb")

		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
		return 1
	end
end