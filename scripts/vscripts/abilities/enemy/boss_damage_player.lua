LinkLuaModifier("modifier_boss_damage_player", "abilities/enemy/boss_damage_player.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if boss_damage_player == nil then
	boss_damage_player = class({})
end
function boss_damage_player:Spawn()
	if IsServer() then
		self:UpgradeAbility(false)
		self:SetHidden(true)
	end
end
function boss_damage_player:GetIntrinsicModifierName()
	return "modifier_boss_damage_player"
end
function boss_damage_player:OnAbilityPhaseStart()
	return true
end
function boss_damage_player:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()

	local iParticleID = ParticleManager:CreateParticle("particles/units/boss/damage_player.vpcf", PATTACH_ABSORIGIN, hCaster)
	-- ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(1000, 0, -4))
	ParticleManager:SetParticleControl(iParticleID, 50, Vector(300, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 51, Vector(400, 0, 0))
	-- ParticleManager:SetParticleControl(iParticleID, 60, Vector(255, 0, 0))
	-- ParticleManager:SetParticleControl(iParticleID, 61, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:EmitSound("Hero_Phoenix.SuperNova.Explode")

	if 0 == Spawner:GetRoundLoseHPMode() then
		DotaTD:EachPlayer(function(_, iPlayerID)
			-- local hCommander = Commander:GetCommander(iPlayerID)
			-- hCommander:Kill(self, hCaster)
			local iDamage = KeyValues.UnitsKv[hCaster:GetUnitName()].HitPlayerAttack
			if 0 < iDamage then
				local tInfo = {
					PlayerID = iPlayerID,
					attacker = self:GetCaster(),
					damage = iDamage,
				}
				EventManager:fireEvent(ET_PLAYER.ON_DAMAGE, tInfo)
			end
		end)
	else
		PlayerData:LosePlayerHP()
	end

	-- hCaster:ForceKill(false)
end

---------------------------------------------------------------------
--Modifiers
if modifier_boss_damage_player == nil then
	modifier_boss_damage_player = class({}, nil, eom_modifier)
end
function modifier_boss_damage_player:IsHidden()
	return true
end
function modifier_boss_damage_player:IsDebuff()
	return false
end
function modifier_boss_damage_player:IsPurgable()
	return false
end
function modifier_boss_damage_player:IsPurgeException()
	return false
end
function modifier_boss_damage_player:IsStunDebuff()
	return false
end
function modifier_boss_damage_player:AllowIllusionDuplicate()
	return false
end
function modifier_boss_damage_player:OnCreated(params)
	if IsServer() then
		self.bDeath = false
	end
end
function modifier_boss_damage_player:OnDestroy()
end
function modifier_boss_damage_player:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = self.bDeath,
	}
end
function modifier_boss_damage_player:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_BATTLE.ON_BOSS_BOMB, self.OnBossBomb },
	}
end
function modifier_boss_damage_player:OnBossBomb(params)
	if not IsValid(self) or not IsValid(self:GetAbility()) then
		return true
	end
	self.bDeath = true
	self:GetAbility():SetHidden(false)
	ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		AbilityIndex = self:GetAbility():entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = self:GetParent():GetAbsOrigin(),
	})
end