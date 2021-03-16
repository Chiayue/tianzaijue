--Abilities
if snapfire_1 == nil then
	snapfire_1 = class({}, nil, base_attack)
end
function snapfire_1:OnUpgrade()
	local hCaster = self:GetCaster()
	hCaster:SetVal(ATTRIBUTE_KIND.PhysicalCrit, self:GetSpecialValueFor("crit_mult"), self, self:GetSpecialValueFor("crit_chance"))
end
function snapfire_1:GetAttackProjectile()
	return ""
end
function snapfire_1:DoAttackBehavior(params)
	local hCaster = self:GetCaster()
	local hTarget = params.target
	local vTarget = hTarget:GetAbsOrigin()
	hCaster:EmitSound('Hero_Snapfire.Shotgun.Fire')

	local blast_speed = self:GetSpecialValueFor('blast_speed')
	local bullet_width = self:GetSpecialValueFor('bullet_width')
	local hAbility_3 = hCaster:FindAbilityByName("snapfire_3")
	local bonus_bullet = 0
	if IsValid(hAbility_3) and hAbility_3:GetLevel() > 0 then
		bonus_bullet = hAbility_3:GetSpecialValueFor("bonus_bullet")
		if hCaster:HasModifier("modifier_snapfire_2_crit") then
			bonus_bullet = bonus_bullet * hAbility_3:GetSpecialValueFor("bonus_bullet_factor")
		end
	end
	local bullet = self:GetSpecialValueFor('bullet') + bonus_bullet
	local angle_per_bullet = self:GetSpecialValueFor('angle_per_bullet')
	local max_angle = self:GetSpecialValueFor('max_angle')
	local distance = hCaster:Script_GetAttackRange()
	local angle = (bullet - 1) * angle_per_bullet
	if angle > max_angle then
		angle_per_bullet = max_angle / (bullet - 1)
		angle = max_angle
	end

	local vDir = (vTarget - hCaster:GetAbsOrigin()):Normalized()
	local vInitDir = RotatePosition(Vector(0, 0, 0), QAngle(0, -angle / 2, 0), vDir)
	local iPaticleID = ParticleManager:CreateParticle("particles/units/heroes/snapfire_shotgun.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlForward(iPaticleID, 0, vDir)
	ParticleManager:SetParticleControl(iPaticleID, 1, vDir * distance)
	params.bullet = bullet
	for i = 1, bullet do
		local info = {
			Ability = self,
			Source = hCaster,
			EffectName = "particles/units/heroes/snapfire_shotgun_l.vpcf",
			vSpawnOrigin = hCaster:GetAbsOrigin(),
			vVelocity = RotatePosition(Vector(0, 0, 0), QAngle(0, angle_per_bullet * i, 0), vInitDir) * blast_speed,
			fDistance = distance,
			fStartRadius = bullet_width,
			fEndRadius = bullet_width,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			iUnitTargetFlags = self:GetAbilityTargetFlags(),
			ExtraData = {
				record = params.record,
			}
		}
		ProjectileManager:CreateLinearProjectile(info)
	end
end
function snapfire_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if hTarget then
		self:OnDamage(hTarget, GetAttackInfo(ExtraData.record))
	end
	local params = GetAttackInfo(ExtraData.record)
	if params then
		params.bullet = params.bullet - 1
		if params.bullet <= 0 then
			self:OnProjectileEnd(hTarget, vLocation, ExtraData)
		end
	end
	return true
end