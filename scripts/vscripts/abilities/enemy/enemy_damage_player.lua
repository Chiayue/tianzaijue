LinkLuaModifier("modifier_enemy_damage_player", "abilities/enemy/enemy_damage_player.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_damage_player == nil then
	enemy_damage_player = class({})
end
function enemy_damage_player:GetIntrinsicModifierName()
	return "modifier_enemy_damage_player"
end
function enemy_damage_player:DamagePlayer()
	local hCaster = self:GetCaster()

	local iPlayerID = Spawner:GetEnemyPlayerID(hCaster)

	local iDamage = 0
	if 0 == Spawner:GetRoundLoseHPMode() then
		iDamage = KeyValues.UnitsKv[hCaster:GetUnitName()].HitPlayerAttack or 0
	end


	if 0 < iDamage then
		local iTeam = PlayerData:GetPlayerTeamID(iPlayerID)
		local hTarget = Entities:FindByName(nil, iTeam .. '_Enemy_Path_A_2')

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf", PATTACH_CUSTOMORIGIN, nil) -- 为nil才能在看不见caster的时候就看见弹道特效
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
		-- ParticleManager:SetParticleControlEnt(p_index, 1, nil, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		local v = hTarget:GetAbsOrigin()
		v.z = GetGroundHeight(v, hCaster) + 100
		ParticleManager:SetParticleControl(iParticleID, 1, v)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1000, 0, 0))

		local info = {
			Target = hTarget,
			Source = hCaster,
			Ability = self,
			-- EffectName = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf",
			-- iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			iMoveSpeed = 1000,
			bDodgeable = false,
			ExtraData = {
				damage = iDamage,
				iPlayerID = iPlayerID,
				iParticleID = iParticleID
			},
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
end
function enemy_damage_player:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
		self:DamageCourier(ExtraData.iPlayerID, ExtraData.damage)
		ParticleManager:DestroyParticle(ExtraData.iParticleID, false)
		UTIL_Remove(hCaster)
	end
end
function enemy_damage_player:DamageCourier(iPlayerID, iDamage)
	local tInfo = {
		PlayerID = iPlayerID,
		attacker = self:GetCaster(),
		damage = iDamage,
	}
	EventManager:fireEvent(ET_PLAYER.ON_DAMAGE, tInfo)

	local hHero = PlayerData:GetHero(iPlayerID)
	if IsValid(hHero) then
		iParticleID = ParticleManager:CreateParticle("particles/units/heroes/damage_courier.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hHero:GetAbsOrigin() + Vector(0, 0, 500))
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_damage_player == nil then
	modifier_enemy_damage_player = class({}, nil, eom_modifier)
end
function modifier_enemy_damage_player:IsHidden()
	return true
end
function modifier_enemy_damage_player:IsDebuff()
	return false
end
function modifier_enemy_damage_player:IsPurgable()
	return false
end
function modifier_enemy_damage_player:IsPurgeException()
	return false
end
function modifier_enemy_damage_player:IsStunDebuff()
	return false
end
function modifier_enemy_damage_player:AllowIllusionDuplicate()
	return false
end
function modifier_enemy_damage_player:OnCreated(params)
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_enemy_damage_player:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_enemy_damage_player:DeclareFunctions()
	return {
	-- MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_enemy_damage_player:OnDeath(params)
	if params.unit == self:GetParent() then
		if params.unit == params.attacker then
			self:GetAbility():DamagePlayer()
		end
	end
end