LinkLuaModifier("modifier_ogre_med_1_buff", "abilities/tower/ogre_med/ogre_med_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if ogre_med_1 == nil then
	ogre_med_1 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET }, nil, ability_base_ai)
end
function ogre_med_1:GetAOERadius()
	return self:GetSpecialValueFor("width")
end
function ogre_med_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	local flDuration = self:GetSpecialValueFor("stun_duration")
	local health_damge_pct = self:GetSpecialValueFor("health_damge_pct")
	local flDamage = self:GetAbilityDamage() + health_damge_pct * hCaster:GetHealthDeficit() * 0.01

	local hp_per_amplify_per = self:GetSpecialValueFor("hp_per_amplify_per")
	local fAmplifyRate = (100 - hCaster:GetHealthPercent()) * hp_per_amplify_per * 0.01
	distance = distance * (1 + fAmplifyRate)
	width = width * (1 + fAmplifyRate)

	local vStart = hCaster:GetAbsOrigin()
	local vDirection = (vPosition - vStart):Normalized()
	local vEnd = vStart + vDirection * distance
	vEnd = GetGroundPosition(vEnd, nil)

	local hAbility = hCaster:FindAbilityByName("ogre_med_3")
	local tTargets = FindUnitsInLineWithAbility(hCaster, vStart + vDirection * width, vEnd, width, self)
	for _, hUnit in pairs(tTargets) do
		---@param tDamageData DamageData
		hCaster:DealDamage(hUnit, self, flDamage, nil, nil, function(tDamageData)
			tDamageData.damage = tDamageData.damage * (1 + fAmplifyRate)
		end)

		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, flDuration)

		local fDurationFly = RemapVal(1 + fAmplifyRate, 1, 2, 0.15, 0.4)
		local fHeight = RemapVal(1 + fAmplifyRate, 1, 2, 50, 400)
		hUnit:AddBuff(hCaster, BUFF_TYPE.KNOCKBACK, flDuration, nil, {
			center_x = hUnit:GetAbsOrigin().x,
			center_y = hUnit:GetAbsOrigin().y,
			center_z = hUnit:GetAbsOrigin().z,
			should_stun = 0,
			duration = fDurationFly,
			knockback_duration = fDurationFly,
			knockback_distance = 0,
			knockback_height = fHeight,
		})
		if IsValid(hAbility) then
			hAbility:Action()
		end
	end
	hCaster:AddNewModifier(hCaster, self, "modifier_ogre_med_1_buff", { duration = self:GetDuration() })

	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/ogre_med/ogre_med_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
	ParticleManager:SetParticleControl(iParticleID, 1, vEnd)

	local fScale = distance / 100 * (7 / 9)
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(fScale, 0, 0))

	local vOffset = (vStart + vEnd) / 2
	vOffset.z = vOffset.z + (200 / 7) * fScale / 100
	ParticleManager:SetParticleControl(iParticleID, 4, (vStart + vEnd) / 2)

	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end
function ogre_med_1:GetIntrinsicModifierName()
	return "modifier_ogre_med_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ogre_med_1_buff == nil then
	modifier_ogre_med_1_buff = class({}, nil, eom_modifier)
end
function modifier_ogre_med_1_buff:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
end
function modifier_ogre_med_1_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		[EMDF_ATTACKT_SPEED_BONUS] = self.bonus_attackspeed,
	}
end
function modifier_ogre_med_1_buff:GetAttackSpeedBonus()
	return self.bonus_attackspeed
end