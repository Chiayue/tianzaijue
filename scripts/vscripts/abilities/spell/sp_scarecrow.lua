LinkLuaModifier("modifier_sp_scarecrow_attribute_buff", "abilities/spell/sp_scarecrow.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if sp_scarecrow == nil then
	sp_scarecrow = class({}, nil, sp_base)
end
function sp_scarecrow:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_scarecrow:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local hCreep = CreateUnitByName("npc_dota_scarecrow", vPosition, true, hCaster, hCaster, iTeamNumber)
	Attributes:Register(hCreep)
	hCreep:SetForwardVector(Vector(0, -1, 0))
	hCreep:AddNewModifier(hCaster, self, "modifier_sp_scarecrow_attribute_buff", { duration = duration })

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCreep)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCreep, PATTACH_POINT_FOLLOW, "attach_hitloc", hCreep:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Axe.Berserkers_Call", hCreep)
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_scarecrow_attribute_buff == nil then
	modifier_sp_scarecrow_attribute_buff = class({}, nil, eom_modifier)
end
function modifier_sp_scarecrow_attribute_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.tTargets = {}
		self:StartIntervalThink(0)
		self:OnIntervalThink()
	end
end
function modifier_sp_scarecrow_attribute_buff:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_sp_scarecrow_attribute_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for i, hTarget in pairs(tTargets) do
			if TableFindKey(self.tTargets, hTarget) == nil and not hTarget:HasModifier(BUFF_TYPE.TAUNT) then
				table.insert(self.tTargets, hTarget)
				hTarget:AddBuff(hParent, BUFF_TYPE.TAUNT, self:GetRemainingTime())
			end
		end
	end
end
function modifier_sp_scarecrow_attribute_buff:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function modifier_sp_scarecrow_attribute_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_sp_scarecrow_attribute_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_scarecrow_attribute_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_sp_scarecrow_attribute_buff:GetModifierAvoidDamage(params)
	return 1
end
function modifier_sp_scarecrow_attribute_buff:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
