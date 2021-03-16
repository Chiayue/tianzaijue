if windrunner_1 == nil then
	---@type CDOTABaseAbility
	windrunner_1 = class({
		iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET,
	}, nil, ability_base_ai)
end
function windrunner_1:GetAOERadius()
	return self:GetSpecialValueFor("arrow_width")
end
function windrunner_1:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("arrow_range")
end
function windrunner_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

	EmitSoundOnLocationForAllies(hCaster:GetAbsOrigin(), "Ability.PowershotPull", hCaster)
end
function windrunner_1:OnChannelFinish(bInterrupted)
	local fChannelPct = (GameRules:GetGameTime() - self:GetChannelStartTime()) / self:GetChannelTime()
	local vPoint = self:GetCursorPosition()
	self:Fire(fChannelPct, vPoint)
end
function windrunner_1:Fire(fChannelPct, vPoint)
	local hCaster = self:GetCaster()

	local physical_rate = self:GetSpecialValueFor("physical_rate")


	self.fTreeWidth = self:GetSpecialValueFor("arrow_width")

	local sProjectileName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
	local arrow_speed = self:GetSpecialValueFor("arrow_speed")
	local arrow_range = self:GetSpecialValueFor("arrow_range")
	local arrow_width = self:GetSpecialValueFor("arrow_width")
	local vision_radius = self:GetSpecialValueFor("arrow_width")
	local vDirection = CalculateDirection(vPoint, hCaster)
	local vStartPosition = hCaster:GetAbsOrigin()

	local hThinker = CreateModifierThinker(hCaster, self, "modifier_dummy", {
		duration = 5
	}, vStartPosition, hCaster:GetTeamNumber(), false)

	local iParticleID = ParticleManager:CreateParticle(sProjectileName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_CUSTOMORIGIN, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 0, vStartPosition)
	ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
	ParticleManager:SetParticleControl(iParticleID, 1, vDirection * arrow_speed)
	ParticleManager:SetParticleControl(iParticleID, 3, vStartPosition + vDirection:Normalized() * arrow_range)
	hThinker.iParticleID = iParticleID

	local tExtraData = {
		thinker_index = hThinker:entindex(),
	}

	--2技能
	local hAblt2 = hCaster:FindAbilityByName('windrunner_2')
	if hAblt2 and 0 < hAblt2:GetLevel() and hAblt2:IsActivated() then
		tExtraData.ablt2_thinker_index = hAblt2:OnSpellStart(vStartPosition, vDirection)
	end

	local tInfo = {
		Source = hCaster,
		Ability = self,
		vSpawnOrigin = vStartPosition,

		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags = self:GetAbilityTargetFlags(),
		iUnitTargetType = self:GetAbilityTargetType(),

		EffectName = "", --sProjectileName,
		fDistance = arrow_range,
		fStartRadius = arrow_width,
		fEndRadius = arrow_width,
		vVelocity = vDirection * arrow_speed,

		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = hCaster:GetTeamNumber(),

		ExtraData = tExtraData,
	}
	local iProjectile = ProjectileManager:CreateLinearProjectile(tInfo)

	hCaster:EmitSound("Ability.Powershot")
end
function windrunner_1:OnProjectileHit_ExtraData(hTarget, vLocation, extraData)
	local hThinker = EntIndexToHScript(extraData.thinker_index)
	if not IsValid(hTarget) then
		if IsValid(hThinker) then
			if hThinker.iParticleID ~= nil then
				ParticleManager:DestroyParticle(hThinker.iParticleID, false)
				hThinker.iParticleID = nil
			end
			hThinker:RemoveSelf()
		end
		return
	end

	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		local iHitCount = hThinker and hThinker.iHitCount or 0
		hThinker.iHitCount = iHitCount + 1

		local tDamage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			ability = self
		}

		local damage_add_per = self:GetSpecialValueFor("damage_add_per")

		---@param tDamageData DamageData
		self:ApplyDamage(tDamage, function(tDamageData)
			tDamageData.damage = tDamageData.damage * (1 + iHitCount * damage_add_per * 0.01)
		end)

		hTarget:EmitSound("Hero_Windrunner.PowershotDamage")
	end

	--2技能命中触发额外效果
	local hAblt2 = self:GetCaster():FindAbilityByName('windrunner_2')
	if hAblt2 and 0 < hAblt2:GetLevel() and hAblt2:IsActivated() then
		hAblt2:OnHit(hTarget)
	end
end
function windrunner_1:OnProjectileThink_ExtraData(vLocation, extraData)
	local hThinker = EntIndexToHScript(extraData.thinker_index)
	if hThinker then
		hThinker:SetAbsOrigin(vLocation)
	end
	GridNav:DestroyTreesAroundPoint(vLocation, self.fTreeWidth, false)

	--2技能延伸
	if extraData.ablt2_thinker_index then
		local hThinker2 = EntIndexToHScript(extraData.ablt2_thinker_index)
		if IsValid(hThinker2) then
			local hBuff2 = hThinker2:FindModifierByName('modifier_windrunner_2')
			if hBuff2 then
				hBuff2:SetEndPos(vLocation)
			end
		end
	end
end
