LinkLuaModifier("modifier_pugna_2", "abilities/tower/pugna/pugna_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if pugna_2 == nil then
	pugna_2 = class({iBehavior=DOTA_ABILITY_BEHAVIOR_NO_TARGET}, nil, ability_base_ai)
end
function pugna_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local fDuration = self:GetDuration()

	local vPosition = GetGroundPosition(hCaster:GetAbsOrigin() + hCaster:GetForwardVector()*150, hCaster)

	local hWard = CreateUnitByName("npc_dota_pugna_nether_ward", vPosition, true, hCaster, hCaster, hCaster:GetTeamNumber())
	hWard:AddNewModifier(hCaster, self, "modifier_pugna_2", {duration = fDuration})

	hCaster:EmitSound("Hero_Pugna.NetherWard")
end
function pugna_2:Trigger(hWard)
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hWard:GetAbsOrigin(), radius, self, FIND_ANY_ORDER)

	if IsValid(tTargets[1]) then
		local hTarget = tTargets[1]

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hWard, PATTACH_POINT_FOLLOW, "attach_hitloc", hWard:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 4, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)

		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Pugna.NetherWard.Attack", hCaster)

		ApplyDamage({
			attacker = hCaster,
			victim = hTarget,
			ability = self,
			damage = damage * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack)*0.01,
			damage_type = self:GetAbilityDamageType(),
		})
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_pugna_2 == nil then
	modifier_pugna_2 = class({}, nil, eom_modifier)
end
function modifier_pugna_2:IsHidden()
	return true
end
function modifier_pugna_2:IsDebuff()
	return false
end
function modifier_pugna_2:IsPurgable()
	return false
end
function modifier_pugna_2:IsPurgeException()
	return false
end
function modifier_pugna_2:IsStunDebuff()
	return false
end
function modifier_pugna_2:AllowIllusionDuplicate()
	return false
end
function modifier_pugna_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_pugna_2:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_pugna_2:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
function modifier_pugna_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
end
function modifier_pugna_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_pugna_2:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_pugna_2:OnAbilityExecuted(params)
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if not IsValid(hAbility) or not IsValid(hCaster) then
		self:Destroy()
		return
	end
	if IsValid(params.unit) and params.unit:GetPlayerOwnerID() == hCaster:GetPlayerOwnerID() and params.unit:IsPositionInRange(hParent:GetAbsOrigin(), self.radius) then
		if params.ability ~= nil and not params.ability:IsItem() and not params.ability:IsToggle() and params.ability:ProcsMagicStick() then
			if type(hAbility.Trigger) == "function" then
				hAbility:Trigger(hParent)
			end
		end
	end
end
function modifier_pugna_2:OnBattleEnd()
	self:Destroy()
end