LinkLuaModifier("modifier_enemy_ogre_med_1", "abilities/special_abilities/enemy_ogre_med_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_ogre_med_1_buff", "abilities/special_abilities/enemy_ogre_med_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_ogre_med_1 == nil then
	enemy_ogre_med_1 = class({})
end
function enemy_ogre_med_1:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end
function enemy_ogre_med_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	local flDuration = self:GetSpecialValueFor("stun_duration")
	local flDamage = self:GetAbilityDamage()

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
		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, flDuration)
		hCaster:DealDamage(hUnit, self, flDamage, nil, nil, function(tDamageData)
			tDamageData.damage = tDamageData.damage * (1 + fAmplifyRate)
		end)


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
	hCaster:AddNewModifier(hCaster, self, "modifier_enemy_ogre_med_1_buff", { duration = self:GetDuration() })

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
function enemy_ogre_med_1:GetIntrinsicModifierName()
	return "modifier_enemy_ogre_med_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_ogre_med_1 == nil then
	modifier_enemy_ogre_med_1 = class({}, nil, ModifierHidden)
end
function modifier_enemy_ogre_med_1:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_enemy_ogre_med_1:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility(), FIND_CLOSEST)
		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), tTargets[1]:GetAbsOrigin())
		end
	end
end
function modifier_enemy_ogre_med_1:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_enemy_ogre_med_1_buff == nil then
	modifier_enemy_ogre_med_1_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_ogre_med_1_buff:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
end
function modifier_enemy_ogre_med_1_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		[EMDF_ATTACKT_SPEED_BONUS] = self.bonus_attackspeed,
	}
end
function modifier_enemy_ogre_med_1_buff:GetAttackSpeedBonus()
	return self.bonus_attackspeed
end
function modifier_enemy_ogre_med_1_buff:IsHidden()
	return true
end