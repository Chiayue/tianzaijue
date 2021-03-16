LinkLuaModifier("modifier_sp_peaceful", "abilities/spell/sp_peaceful.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_peaceful_aura", "abilities/spell/sp_peaceful.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_peaceful == nil then
	sp_peaceful = class({}, nil, sp_base)
end
function sp_peaceful:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_peaceful:OnSpellStart()
	local hCaster = self:GetCaster()
	local PlayerID = hCaster:GetPlayerOwnerID()
	local duration = self:GetSpecialValueFor("duration")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_shockwave_1/generic_aoe_shockwave_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(5, 2, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(154, 205, 50))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(0, 128, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Enchantress.NaturesAttendantsCast", hCaster)

	CreateModifierThinker(hCaster, self, "modifier_sp_peaceful", { duration = duration }, vPosition, iTeamNumber, false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_peaceful == nil then
	modifier_sp_peaceful = class({})
end
function modifier_sp_peaceful:IsHidden()
	return true
end
function modifier_sp_peaceful:IsDebuff()
	return false
end
function modifier_sp_peaceful:IsPurgable()
	return false
end
function modifier_sp_peaceful:IsPurgeException()
	return false
end
function modifier_sp_peaceful:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.period = self:GetAbilitySpecialValueFor("period")
	if IsServer() then
		self:StartIntervalThink(self.period)
		self:OnIntervalThink()
	else
		local vPosition = self:GetParent():GetAbsOrigin()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healing_ward_fortunes_tout_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 0, -self.radius))
		ParticleManager:SetParticleControl(iParticleID, 2, vPosition)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_peaceful:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()
	end
end
function modifier_sp_peaceful:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for k, hTarget in pairs(tTargets) do
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_sp_peaceful_aura", {duration=self.period+0.5})
		end
	end
end
function modifier_sp_peaceful:CheckState()
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
if modifier_sp_peaceful_aura == nil then
	modifier_sp_peaceful_aura = class({}, nil, eom_modifier_aura)
end
function modifier_sp_peaceful_aura:IsDebuff()
	return false
end
function modifier_sp_peaceful_aura:IsHidden()
	return false
end
function modifier_sp_peaceful_aura:IsPurgable()
	return false
end
function modifier_sp_peaceful_aura:IsPurgeException()
	return false
end
function modifier_sp_peaceful_aura:OnCreated(params)
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	self.period = self:GetAbilitySpecialValueFor("period")
	if IsServer() then
		self:StartIntervalThink(self.period)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_gold_hero_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_peaceful_aura:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:Heal(hParent:GetMaxHealth() * self.heal_pct * 0.01, self:GetAbility())
	end
end