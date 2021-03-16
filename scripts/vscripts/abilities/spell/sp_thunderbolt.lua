LinkLuaModifier("modifier_lightning_bolt_debuff", "abilities/spell/sp_thunderbolt.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lightning_bolt_stack", "abilities/spell/sp_thunderbolt.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_thunderbolt == nil then
	sp_thunderbolt = class({}, nil, sp_base)
end
function sp_thunderbolt:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_thunderbolt:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local damage_per_stack = self:GetSpecialValueFor("damage_per_stack")
	local stun_time = self:GetSpecialValueFor("stun_time")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	local iStackCount = hCaster:GetModifierStackCount("modifier_lightning_bolt_stack", hCaster)

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local vStart = vPosition + Vector(0, 0, 1600)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 20, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(53, 74, 255))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(100, 149, 237))
	ParticleManager:SetParticleControl(iParticleID, 5, Vector(11, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Zuus.LightningBolt", hCaster)

	local fDamage = damage + damage_per_stack*iStackCount

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_lightning_bolt_debuff", { duration = GetStatusDebuffDuration(stun_time, hTarget, hCaster) })

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vStart)
		ParticleManager:SetParticleControl(iParticleID, 1, hTarget:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)

		ApplyDamage({
			attacker = hCaster,
			victim = hTarget,
			damage = fDamage,
			damage_type = self:GetAbilityDamageType(),
			ability = self,
			damage_flags = DOTA_DAMAGE_FLAG_SPELL,
		})
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_lightning_bolt_stack", nil)
end
---------------------------------------------------------------------
--Modifiers
if modifier_lightning_bolt_debuff == nil then
	modifier_lightning_bolt_debuff = class({})
end
function modifier_lightning_bolt_debuff:IsDebuff()
	return true
end
function modifier_lightning_bolt_debuff:IsHidden()
	return false
end
function modifier_lightning_bolt_debuff:IsPurgable()
	return false
end
function modifier_lightning_bolt_debuff:IsPurgeException()
	return true
end
function modifier_lightning_bolt_debuff:IsStunDebuff()
	return true
end
function modifier_lightning_bolt_debuff:OnCreated(params)
	local hParent = self:GetParent()
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lightning_bolt_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
---------------------------------------------------------------------
if modifier_lightning_bolt_stack == nil then
	modifier_lightning_bolt_stack = class({})
end
function modifier_lightning_bolt_stack:IsHidden()
	return true
end
function modifier_lightning_bolt_stack:IsDebuff()
	return false
end
function modifier_lightning_bolt_stack:IsPurgable()
	return false
end
function modifier_lightning_bolt_stack:IsPurgeException()
	return false
end
function modifier_lightning_bolt_stack:IsStunDebuff()
	return false
end
function modifier_lightning_bolt_stack:RemoveOnDeath()
	return false
end
function modifier_lightning_bolt_stack:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_lightning_bolt_stack:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end