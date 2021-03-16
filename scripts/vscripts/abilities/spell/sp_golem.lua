LinkLuaModifier("modifier_sp_golem_thinker", "abilities/spell/sp_golem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_golem", "abilities/spell/sp_golem.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_golem == nil then
	sp_golem = class({}, nil, sp_base)
end
function sp_golem:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_golem:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hCommander = Commander:GetCommander(iPlayerID)
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local land_time = self:GetSpecialValueFor("land_time")

	CreateModifierThinker(hCommander, self, "modifier_sp_golem_thinker", { duration = land_time }, vPosition, iTeamNumber, false)
end
---------------------------------------------------------------------
if modifier_sp_golem_thinker == nil then
	modifier_sp_golem_thinker = class({})
end
function modifier_sp_golem_thinker:OnCreated()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		self.vPosition = hParent:GetAbsOrigin()

		EmitSoundOnLocationWithCaster(self.vPosition, "Hero_Warlock.RainOfChaos_buildup", hCaster)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_sp_golem_thinker:OnDestroy()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	if IsServer() then
		local iTeamNumber = hParent:GetTeamNumber()
		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()

		if IsValid(hCaster) and IsValid(hAbility) then
			EmitSoundOnLocationWithCaster(self.vPosition, "Hero_Warlock.RainOfChaos", hCaster)

			local tTargets = FindUnitsInRadius(iTeamNumber, self.vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, hTarget in pairs(tTargets) do
				hTarget:AddNewModifier(hCaster, hAbility, "modifier_stunned", { duration = GetStatusDebuffDuration(self.stun_duration, hTarget, hCaster) })
			end

			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 1, 1))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local type = 1
			if hCaster:HasAbility("base_attack_2") then
				type = 2
			elseif hCaster:HasAbility("base_attack_3") then
				type = 3
			elseif hCaster:HasAbility("base_attack_4") then
				type = 4
			end

			local hCourier = PlayerData:GetHero(hCaster:GetPlayerOwnerID())

			local hGolem = CreateUnitByName("npc_dota_sp_golem", self.vPosition, true, hCourier, hCourier, iTeamNumber)
			Attributes:Register(hGolem)
			hGolem:SetVal(ATTRIBUTE_KIND.StatusHealth, 1, ATTRIBUTE_KEY.BASE)
			hGolem:AddNewModifier(hCaster, hAbility, "modifier_sp_golem", { duration = self.duration })
			hGolem:SetAcquisitionRange(3000)
			hGolem:FireSummonned(hCaster)
			hGolem:RemoveAbility("base_attack_1")
			hGolem:RemoveAbility("base_attack_2")
			hGolem:RemoveAbility("base_attack_3")
			hGolem:RemoveAbility("base_attack_4")
			hGolem:AddAbility("base_attack_" .. type):SetLevel(1)
		end
	end
end
function modifier_sp_golem_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
---------------------------------------------------------------------
if modifier_sp_golem == nil then
	modifier_sp_golem = class({}, nil, eom_modifier)
end
function modifier_sp_golem:IsHidden()
	return true
end
function modifier_sp_golem:IsDebuff()
	return false
end
function modifier_sp_golem:IsPurgable()
	return false
end
function modifier_sp_golem:IsPurgeException()
	return false
end
function modifier_sp_golem:IsStunDebuff()
	return false
end
function modifier_sp_golem:OnCreated(params)
	local hParent = self:GetParent()
	self.inherited_percent = self:GetAbilitySpecialValueFor("inherited_percent")
	if IsServer() then
		self:SetStackCount(Spawner:GetRound())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_hellsworn_construct/golem_hellsworn_ambient.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_mane1", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_mane2", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_mane3", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, "attach_mane4", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 4, hParent, PATTACH_POINT_FOLLOW, "attach_mane5", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, hParent, PATTACH_POINT_FOLLOW, "attach_mane6", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 6, hParent, PATTACH_POINT_FOLLOW, "attach_mane7", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 7, hParent, PATTACH_POINT_FOLLOW, "attach_mane8", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 8, hParent, PATTACH_POINT_FOLLOW, "attach_maneR", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 9, hParent, PATTACH_POINT_FOLLOW, "attach_maneL", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 10, hParent, PATTACH_POINT_FOLLOW, "attach_hand_r", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 11, hParent, PATTACH_POINT_FOLLOW, "attach_hand_l", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 12, hParent, PATTACH_POINT_FOLLOW, "attach_mouthFire", hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_golem:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_sp_golem:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_sp_golem:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_sp_golem:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_sp_golem:GetMagicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_golem:GetPhysicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_golem:GetStatusHealthBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.inherited_percent * 0.01 - 1
	end
	return 0
end
function modifier_sp_golem:GetMagicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_golem:GetPhysicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_golem:OnBattleEnd()
	self:Destroy()
end