LinkLuaModifier("modifier_kingkong_2", "abilities/boss/kingkong_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if kingkong_2 == nil then
	kingkong_2 = class({})
end
function kingkong_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local flDistance = self:GetSpecialValueFor("distance")
	local flStartWidth = self:GetSpecialValueFor("start_width")
	local flEndWidth = self:GetSpecialValueFor("end_width")
	local flDamage = self:GetAbilityDamage()
	local flDuration = self:GetDuration()
	local vStart = hCaster:GetAbsOrigin()
	local vDirection = hCaster:GetForwardVector()

	local vEnd = vStart + vDirection * flDistance
	local v = Rotation2D(vDirection, math.rad(90))
	local tPolygon = {
		vStart + v * flStartWidth,
		vEnd + v * flEndWidth,
		vEnd - v * flEndWidth,
		vStart - v * flStartWidth,
	}
	DebugDrawLine(tPolygon[1], tPolygon[2], 255, 255, 255, true, 1)
	DebugDrawLine(tPolygon[2], tPolygon[3], 255, 255, 255, true, 1)
	DebugDrawLine(tPolygon[3], tPolygon[4], 255, 255, 255, true, 1)
	DebugDrawLine(tPolygon[4], tPolygon[1], 255, 255, 255, true, 1)

	local iTeamNumber = hCaster:GetTeamNumber()
	local iTeamFilter = self:GetAbilityTargetTeam()
	local iTypeFilter = self:GetAbilityTargetType()
	local iFlagFilter = self:GetAbilityTargetFlags()
	local tTargets = Spawner:FindMissingInRadius(iTeamNumber, vStart, flDistance, iTeamFilter, iTypeFilter, iFlagFilter, FIND_ANY_ORDER)
	for _, hUnit in pairs(tTargets) do
		if IsPointInPolygon(hUnit:GetAbsOrigin(), tPolygon) then
			local tDamageInfo =			{
				victim = hUnit,
				attacker = hCaster,
				damage = flDamage,
				damage_type = self:GetAbilityDamageType(),
				ability = self,
			}
			ApplyDamage(tDamageInfo)
			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, flDuration)
		end
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/roar.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_mouth", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 1, vEnd)
	hCaster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")
end
function kingkong_2:GetIntrinsicModifierName()
	return "modifier_kingkong_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_2 == nil then
	modifier_kingkong_2 = class({}, nil, BaseModifier)
end
function modifier_kingkong_2:IsHidden()
	return true
end
function modifier_kingkong_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_kingkong_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local radius = self:GetAbility():GetSpecialValueFor("distance")
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), FIND_CLOSEST, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end