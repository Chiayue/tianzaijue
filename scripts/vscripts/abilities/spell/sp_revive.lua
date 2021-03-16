--Abilities
if sp_revive == nil then
	sp_revive = class({}, nil, sp_base)
end
function sp_revive:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_revive:OnSpellStart()
	local hCaster = self:GetCaster()
	local revive_count = self:GetSpecialValueFor("revive_count")
	local radius = self:GetSpecialValueFor("radius")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_shockwave_1/generic_aoe_shockwave_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 5, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(255, 191, 0))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(238, 232, 170))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local iCount = 0
	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		if not hTarget:IsAlive() and hTarget:UnitCanRespawn() and type(hTarget.GetBuilding) == "function" and hTarget:GetBuilding() ~= nil then
			local hBuilding = hTarget:GetBuilding()

			hBuilding:RespawnBuildingUnit()

			local iParticleID = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			iCount = iCount + 1
			if iCount >= revive_count then
				break
			end

			hTarget:GetBuilding():RespawnBuildingUnit()
		end
	end
end