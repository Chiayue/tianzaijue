LinkLuaModifier("modifier_drow_2", "abilities/tower/drow/drow_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_2_cast", "abilities/tower/drow/drow_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_2_arrow", "abilities/tower/drow/drow_2.lua", LUA_MODIFIER_MOTION_NONE)

if drow_2 == nil then
	---@type CDOTABaseAbility
	drow_2 = class({}, nil, ability_base_ai)
end
function drow_2:Spawn()
	if IsServer() then
		if not drow_2.tTinkers then
			drow_2.tTinkers = {}
			EventManager:register(ET_BATTLE.ON_BATTLEING_END, function()
				for i = #drow_2.tTinkers, 1, -1 do
					local hTinker = drow_2.tTinkers[i]
					if IsValid(hTinker) then
						hTinker:ForceKill(false)
						hTinker:RemoveSelf()
						table.remove(drow_2.tTinkers)
					end
				end
			end, 'drow_2_thinker_del')
		end
		self.tTinkers = drow_2.tTinkers
	end
end
function drow_2:_GetArrowThinker()
	local hTinker
	for i = #self.tTinkers, 1, -1 do
		hTinker = self.tTinkers[i]
		if IsValid(hTinker) then
			if not hTinker.bEnable then
				hTinker.bEnable = true
				break
			end
		else
			table.remove(self.tTinkers, i)
		end
		hTinker = nil
	end
	if not hTinker then
		hTinker = CreateModifierThinker(self:GetCaster(), nil, "modifier_dummy", {}, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
		table.insert(self.tTinkers, hTinker)
	end
	hTinker.bEnable = true
	hTinker:GameTimer('RemoveNoDraw', 0, function()
		if hTinker.bEnable then
			hTinker:RemoveNoDraw()
		end
	end)
	return hTinker
end
function drow_2:_SetArrowThinker(hTinker)
	if IsValid(hTinker) then
		hTinker.bEnable = nil
		hTinker:AddNoDraw()
	end
end
function drow_2:GetAOERadius()
	return self:GetCaster():Script_GetAttackRange() + self:GetCaster():GetHullRadius()
end
function drow_2:GetIntrinsicModifierName()
	return "modifier_drow_2"
end
function drow_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

	hCaster:EmitSound("Hero_DrowRanger.Multishot.Channel")
	hCaster:AddNewModifier(hCaster, self, 'modifier_drow_2_cast', {
		duration = self:GetSpecialValueFor('duration'),
	})

	local attack_speed_add = self:GetSpecialValueFor('attack_speed_add')
	local iVal = self:Load("attack_speed_add")
	self:Save("attack_speed_add", iVal + attack_speed_add)
	hCaster:SetModifierStackCount('modifier_drow_2', hCaster, iVal + attack_speed_add)

	-- hCaster:EmitSound("Hero_DrowRanger.Multishot.Attack")
	-- hCaster:StopSound("Hero_DrowRanger.Multishot.Channel")
	-- EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_DrowRanger.ProjectileImpact", hCaster)
end

---------------------------------------------------------------------
--Modifiers
if modifier_drow_2 == nil then
	modifier_drow_2 = class({}, nil, eom_modifier)
end
function modifier_drow_2:IsHidden()
	return false
end
function modifier_drow_2:OnCreated(params)
	self.attack_speed_add = self:GetAbilitySpecialValueFor('attack_speed_add')
	if IsServer() then
		local hAblt = self:GetAbility()
		local iVal = hAblt:Load("attack_speed_add")
		self:SetStackCount(iVal)
	end
end
function modifier_drow_2:OnRefresh(params)
	self.attack_speed_add = self:GetAbilitySpecialValueFor('attack_speed_add')
end
function modifier_drow_2:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_BONUS_MAXIMUM_ATTACK_SPEED
	}
end
function modifier_drow_2:GetAttackSpeedBonusMaximum()
	return math.max(self:GetStackCount(), 500)
end
function modifier_drow_2:GetAttackSpeedBonus()
	return self:GetStackCount()
end
function modifier_drow_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_drow_2:OnTooltip()
	return self:GetAttackSpeedBonus()
end

--Modifiers
if modifier_drow_2_cast == nil then
	modifier_drow_2_cast = class({}, nil, eom_modifier)
end
function modifier_drow_2_cast:IsHidden()
	return true
end
function modifier_drow_2_cast:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	if IsServer() then
		if 0 >= self.count then
			self:Destroy()
			return
		end
		self.range = self:GetAbilitySpecialValueFor('range')

		self:SetStackCount(self.count)
	end

	self.fAtkTime = math.max(self:GetDuration() / self.count, 0.01)
	self.fAtkSpd = self:GetParent():GetBaseAttackTime() / self.fAtkTime * 100 + self:GetParent():GetVal(ATTRIBUTE_KIND.AttackSpeed)
end
function modifier_drow_2_cast:EDeclareFunctions()
	return {
		[EMDF_BONUS_MAXIMUM_ATTACK_SPEED] = self.fAtkSpd,
		[EMDF_ATTACKT_SPEED_OVERRIDE] = self.fAtkSpd,
		[EMDF_ATTACKT_ANIMATION] = { ATTACK_PROJECTILE_LEVEL.ULTRA },
		[EMDF_ATTACKT_ANIMATION_RATE] = { ATTACK_PROJECTILE_LEVEL.ULTRA },
		[EMDF_DO_ATTACK_BEHAVIOR] = { ATTACK_PROJECTILE_LEVEL.ULTRA },
		[EMDF_ATTACKT_FLAGS] = { ATTACK_PROJECTILE_LEVEL.ULTRA },
	}
end
function modifier_drow_2_cast:GetAttackSpeedBonusMaximum()
	return self.fAtkSpd
end
function modifier_drow_2_cast:GetAttackSpeedOverride()
	return self.fAtkSpd
end
function modifier_drow_2_cast:GetAttackAnimation(params)
	params.bNeedStop = true
	return ACT_DOTA_CHANNEL_ABILITY_3
end
function modifier_drow_2_cast:GetAttackAnimationRate()
	return math.min(self:GetParent():GetAttackSpeed() * 0.25, 2)
	-- return 1 / (self.fAtkTime / 0.66666)
end
function modifier_drow_2_cast:GetAttackFlags(params, typeFlags)
	if params.attacker ~= self:GetParent() then return end
	return bit.bor(typeFlags, ATTACK_STATE_SKIPCOUNTING)
end
function modifier_drow_2_cast:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hCaster = self:GetParent()

	local sParticlePath = "particles/units/heroes/drow/drow_2_2snapfire_lizard_blobs_arced.vpcf"
	hCaster:EmitSound("Hero_DrowRanger.Multishot.Attack")
	-- local sParticlePath = "particles/units/heroes/drow/drow_2parent.vpcf"
	-- hCaster:EmitSound("Hero_DrowRanger.Multishot.FrostArrows")
	--
	self.fRangeCur = math.min((self.fRangeCur or 0) + (self.range / (self.count * 0.3)), self.range)
	local fRadius = self.fRangeCur * 0.5
	local vTarget = tAttackInfo.target:GetAbsOrigin() + Vector(RandomFloat(-fRadius, fRadius), RandomFloat(-fRadius, fRadius), 0)
	local fSpeed = hCaster:GetProjectileSpeed() * 1.5

	-- local hThinker = CreateModifierThinker(hCaster, self:GetAbility(), "modifier_dummy", { duration = 5 }, vTarget, hCaster:GetTeamNumber(), false)
	local hThinker = self:GetAbility():_GetArrowThinker()
	hThinker:SetAbsOrigin(vTarget)
	hThinker:SetTeam(hCaster:GetTeamNumber())
	hThinker:AddNewModifier(hCaster, self:GetAbility(), 'modifier_drow_2_arrow', { duration = 5 })
	local tInfo = {
		Source = hCaster,
		Target = hThinker,
		Ability = hAttackAbility,
		EffectName = sParticlePath,
		iMoveSpeed = fSpeed,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
		fExpireTime = GameRules:GetGameTime() + 5,
		bDeleteOnHit = true,
		ExtraData = {
			record = tAttackInfo.record,
		}
	}
	ProjectileManager:CreateTrackingProjectile(tInfo)

	if 1 == self:GetStackCount() then
		self:Destroy()
		return
	end
	self:DecrementStackCount()
end

--Modifiers
if modifier_drow_2_arrow == nil then
	modifier_drow_2_arrow = class({}, nil, eom_modifier)
end
function modifier_drow_2_arrow:IsHidden()
	return true
end
function modifier_drow_2_arrow:OnCreated(params)
	if IsServer() then
		self.arrow_radius = self:GetAbilitySpecialValueFor('arrow_radius')
	end
end
function modifier_drow_2_arrow:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		-- self:GetParent():RemoveSelf()
		-- self:GetAbility():_SetArrowThinker(self:GetParent())
	end
end
function modifier_drow_2_arrow:EDeclareFunctions()
	return {
		EMDF_CHANGE_PROJECTILE_HIT_TARGET,
	}
end
function modifier_drow_2_arrow:ChangeProjectileHitTarget(hTarget, tProjectileInfo, ExtraData, vLocation)
	if hTarget == self:GetParent() and IsValid(hTarget) then
		local tTargets = FindUnitsInRadius(hTarget:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self.arrow_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
		FIND_CLOSEST, false)

		if IsValid(tTargets[1]) then
			hTarget = tTargets[1]
			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_DrowRanger.ProjectileImpact", hTarget)
		else
			local vDir = (hTarget:GetAbsOrigin() - (self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1250))):Normalized()

			local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/drow/drow_2parent.vpcf', PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iPtclID, 0, hTarget:GetAbsOrigin() + vDir * 1000)
			ParticleManager:SetParticleControl(iPtclID, 3, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
			ParticleManager:ReleaseParticleIndex(iPtclID)
			hTarget = nil
		end
		self:Destroy()
	end
	return hTarget
end