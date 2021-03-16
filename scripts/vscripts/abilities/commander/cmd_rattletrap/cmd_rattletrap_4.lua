--Abilities
if cmd_rattletrap_4 == nil then
	cmd_rattletrap_4 = class({}, nil, ability_base_ai)
end
function cmd_rattletrap_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local count = self:GetSpecialValueFor("count")
	local iPlayerID = GetPlayerID(hCaster)
	local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
	local vCenter = Spawner:IsBossRound() and Spawner.hBossMapPoint:GetAbsOrigin() or hEntPoint:GetAbsOrigin()
	GameTimer(0, function()
		if count > 0 then
			count = count - 1
			local vPosition = GetRandomPosition(vCenter + Vector(0, 400, 0), 0, 800)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_rocket")))
			ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(2000, 0, 0))

			local info = {
				EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
				Ability = self,
				iMoveSpeed = 2000,
				Source = hCaster,
				Target = Spawner:IsBossRound() and Spawner.hBossMapPoint or hEntPoint,
				iSourceAttachment = hCaster:ScriptLookupAttachment("attach_rocket"),
				bDodgeable = false,
				bRebound = false,
				ExtraData = {
					iParticleID = iParticleID
				}
			}

			ProjectileManager:CreateTrackingProjectile(info)
			return 0.2
		end
	end)
	-- DotaTD:EachPlayer(function(_, iPlayerID)
	-- 	if PlayerData:IsPlayerDeath(iPlayerID) then return end
	-- 	local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
	-- 	GameTimer(0, function()
	-- 		if count > 0 then
	-- 			count = count - 1
	-- 			local vPosition = GetRandomPosition(hEntPoint:GetAbsOrigin() + Vector(0, 400, 0), 0, 800)
	-- 			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- 			ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_rocket")))
	-- 			ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	-- 			ParticleManager:SetParticleControl(iParticleID, 2, Vector(2000, 0, 0))
	-- 			local info = {
	-- 				EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
	-- 				Ability = self,
	-- 				iMoveSpeed = 2000,
	-- 				Source = hCaster,
	-- 				Target = hEntPoint,
	-- 				iSourceAttachment = hCaster:ScriptLookupAttachment("attach_rocket"),
	-- 				bDodgeable = false,
	-- 				bRebound = false,
	-- 				ExtraData = {
	-- 					iParticleID = iParticleID
	-- 				}
	-- 			}
	-- 			ProjectileManager:CreateTrackingProjectile(info)
	-- 			return 0.2
	-- 		end
	-- 	end)
	-- end, UnitType.Building)
	hCaster:EmitSound("Hero_Rattletrap.Rocket_Flare.Fire")
end
function cmd_rattletrap_4:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local attack_pct = self:GetSpecialValueFor("attack_pct")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, stun_duration)
	end
	hCaster:DealDamage(tTargets, self, hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * attack_pct * 0.01)
	hCaster:EmitSound("Hero_Rattletrap.Rocket_Flare.Explode")
	ParticleManager:DestroyParticle(ExtraData.iParticleID, false)
end