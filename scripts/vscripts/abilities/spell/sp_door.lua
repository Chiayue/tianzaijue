LinkLuaModifier("modifier_sp_door", "abilities/spell/sp_door.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if sp_door == nil then
	sp_door = class({}, nil, sp_base)
end
function sp_door:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_door:CastFilterResultLocation(vLocation)
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hCommander = Commander:GetCommander(iPlayerID)
	if not IsValid(hCommander) then
		return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
	end
	return UF_SUCCESS
end
function sp_door:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hCommander = Commander:GetCommander(iPlayerID)

	local number_of_creeps = self:GetSpecialValueFor("number_of_creeps")
	local inherited_percent = self:GetSpecialValueFor("inherited_percent")
	local duration = self:GetSpecialValueFor("duration")
	local sCreepName = "npc_dota_creep_goodguys_melee_upgraded_mega"
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	EmitSoundOnLocationWithCaster(vPosition, "DOTA_Item.Necronomicon.Activate", hCaster)

	local type = 1
	if hCommander:HasAbility("base_attack_2") then
		type = 2
	elseif hCommander:HasAbility("base_attack_3") then
		type = 3
	elseif hCommander:HasAbility("base_attack_4") then
		type = 4
	end

	for n = 1, number_of_creeps do
		local hCreep = CreateUnitByName(sCreepName, vPosition, true, hCaster, hCaster, iTeamNumber)
		Attributes:Register(hCreep)
		hCreep:SetVal(ATTRIBUTE_KIND.StatusHealth, 1, ATTRIBUTE_KEY.BASE)
		hCreep:AddNewModifier(hCommander, self, "modifier_kill", { duration = duration })
		hCreep:AddNewModifier(hCommander, self, "modifier_sp_door", { duration = duration })
		hCreep:SetAcquisitionRange(3000)
		hCreep:FireSummonned(hCommander)
		hCreep:RemoveAbility("base_attack_1")
		hCreep:RemoveAbility("base_attack_2")
		hCreep:RemoveAbility("base_attack_3")
		hCreep:RemoveAbility("base_attack_4")
		hCreep:AddAbility("base_attack_" .. type):SetLevel(1)

		local iParticleID = ParticleManager:CreateParticle("particles/items_fx/necronomicon_spawn_warrior.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCreep)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_door == nil then
	modifier_sp_door = class({}, nil, eom_modifier)
end
function modifier_sp_door:IsHidden()
	return true
end
function modifier_sp_door:IsDebuff()
	return false
end
function modifier_sp_door:IsPurgable()
	return false
end
function modifier_sp_door:IsPurgeException()
	return false
end
function modifier_sp_door:IsStunDebuff()
	return false
end
function modifier_sp_door:OnCreated(params)
	self.inherited_percent = self:GetAbilitySpecialValueFor("inherited_percent")
	if IsServer() then
		self:SetStackCount(Spawner:GetRound())
	end
end
function modifier_sp_door:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_sp_door:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_sp_door:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_sp_door:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_sp_door:GetMagicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_door:GetPhysicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_door:GetStatusHealthBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.inherited_percent * 0.01 - 1
	end
	return 0
end
function modifier_sp_door:GetMagicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_door:GetPhysicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_door:OnBattleEnd()
	self:Destroy()
end