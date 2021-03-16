LinkLuaModifier("modifier_faceless_void_2", "abilities/tower/faceless_void/faceless_void_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if faceless_void_2 == nil then
	faceless_void_2 = class({})
end
function faceless_void_2:Jump(hCaster, hTarget, radius, jump_count, jump_delay, damage, damage_percent_add, units, iCount)
	self:GameTimer(jump_delay, function()
		if not IsValid(hCaster) then
			return
		end
		if not IsValid(hTarget) then
			return
		end
		local hNewTarget = GetBounceTarget(hTarget, hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags() + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, units)
		if IsValid(hNewTarget) then
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hNewTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hNewTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			hCaster:DealDamage(hNewTarget, self, damage)

			EmitSoundOnLocationWithCaster(hNewTarget:GetAbsOrigin(), "Hero_Zuus.ArcLightning.Target", hCaster)

			if iCount < jump_count then
				table.insert(units, hNewTarget)
				self:Jump(hCaster, hNewTarget, radius, jump_count, jump_delay, damage, damage_percent_add, units, iCount + 1)
			end
		end
	end)
end
function faceless_void_2:ArcLightning(hTarget, bBonus)
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) then return end
	local arc_damage = self:GetAbilityDamage()
	local jump_radius = self:GetSpecialValueFor("jump_radius")
	local jump_count = self:GetSpecialValueFor("jump_count")
	local jump_delay = self:GetSpecialValueFor("jump_delay")
	local arc_damage_percent_add = 0

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	if bBonus then
		ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin() + Vector(0, 0, 700))
	else
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, nil, hCaster:GetAbsOrigin() + Vector(0, 0, 700), true)
	end
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:DealDamage(hTarget, self, arc_damage)
	-- sound
	hCaster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Zuus.ArcLightning.Target", hCaster)

	self:Jump(hCaster, hTarget, jump_radius, jump_count, jump_delay, arc_damage, arc_damage_percent_add, { hTarget }, 2)
end
function faceless_void_2:Action(hTarget, bBonus)
	if self:IsCooldownReady() then
		self:UseResources(false, false, true)
		local hCaster = self:GetCaster()
		local hTarget = hTarget or self:GetCursorTarget()
		self:ArcLightning(hTarget, bBonus)
	end
end