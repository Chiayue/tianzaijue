LinkLuaModifier("modifier_kingkong_1", "abilities/boss/kingkong_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingkong_1_thinker", "abilities/boss/kingkong_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if kingkong_1 == nil then
	kingkong_1 = class({})
end
function kingkong_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local iProjectileSpeed = self:GetSpecialValueFor("projectile_speed")
	local hThinker = CreateModifierThinker(hCaster, self, "modifier_kingkong_1_thinker", { duration = 10 }, vPosition, hCaster:GetTeamNumber(), false)
	local info = {
		EffectName = "particles/units/boss/kingkong/kingkong_1.vpcf",
		Ability = self,
		iMoveSpeed = iProjectileSpeed,
		Source = hCaster,
		Target = hThinker,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		vSourceLoc = hCaster:GetAbsOrigin(),
		bDodgeable = true,
		ExtraData = {
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
function kingkong_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		local flRadius = self:GetSpecialValueFor("radius")
		local flDamage = self:GetAbilityDamage()
		local iDamageType = self:GetAbilityDamageType()
		local flDuration = self:GetSpecialValueFor("stun_duration")
		hTarget:RemoveModifierByName("modifier_kingkong_1_thinker")
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vLocation, nil, flRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			local tDamageInfo = {
				attacker = hCaster,
				victim = hUnit,
				ability = self,
				damage = flDamage,
				damage_type = iDamageType
			}
			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, flDuration)
			ApplyDamage(tDamageInfo)

		end
		-- 落地特效
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(flRadius, flRadius, flRadius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
	end
end
function kingkong_1:GetIntrinsicModifierName()
	return "modifier_kingkong_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_1 == nil then
	modifier_kingkong_1 = class({}, nil, BaseModifier)
end
function modifier_kingkong_1:IsHidden()
	return true
end
function modifier_kingkong_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_kingkong_1:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local radius = self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), nil)
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), FIND_CLOSEST, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self:GetAbility():entindex(),
				Position = tTargets[1]:GetAbsOrigin()
			})
		end
	end
end
---------------------------------------------------------------------
if modifier_kingkong_1_thinker == nil then
	modifier_kingkong_1_thinker = class({}, nil, ParticleModifierThinker)
end