LinkLuaModifier("modifier_sp_cataclysm", "abilities/spell/sp_cataclysm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_cataclysm_aura", "abilities/spell/sp_cataclysm.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_cataclysm == nil then
	sp_cataclysm = class({}, nil, sp_base)
end
function sp_cataclysm:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_cataclysm:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
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
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 10, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(21, 7, 3))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(106, 90, 205))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	CreateModifierThinker(hCaster, self, "modifier_sp_cataclysm", { duration = duration }, vPosition, iTeamNumber, false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_cataclysm == nil then
	modifier_sp_cataclysm = class({})
end
function modifier_sp_cataclysm:IsDebuff()
	return false
end
function modifier_sp_cataclysm:IsHidden()
	return true
end
function modifier_sp_cataclysm:IsPurgable()
	return false
end
function modifier_sp_cataclysm:IsPurgeException()
	return false
end
function modifier_sp_cataclysm:OnCreated(params)
	local hParent = self:GetParent()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		hParent:EmitSound("Hero_Warlock.Upheaval")
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_upheaval.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 1, 1))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_cataclysm:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:StopSound("Hero_Warlock.Upheaval")
		hParent:EmitSound("Hero_Warlock.Upheaval.Stop")
		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()
	end
end
function modifier_sp_cataclysm:OnIntervalThink()
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
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_sp_cataclysm_aura", {duration=self.interval+0.5})
		end
	end
end
function modifier_sp_cataclysm:CheckState()
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
if modifier_sp_cataclysm_aura == nil then
	modifier_sp_cataclysm_aura = class({})
end
function modifier_sp_cataclysm_aura:GetTexture()
	return "warlock_upheaval"
end
function modifier_sp_cataclysm_aura:IsDebuff()
	return true
end
function modifier_sp_cataclysm_aura:IsHidden()
	return false
end
function modifier_sp_cataclysm_aura:IsPurgable()
	return false
end
function modifier_sp_cataclysm_aura:IsPurgeException()
	return false
end
function modifier_sp_cataclysm_aura:GetEffectName()
	return "particles/units/heroes/hero_warlock/warlock_upheaval_debuff.vpcf"
end
function modifier_sp_cataclysm_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_cataclysm_aura:OnCreated(params)
	self.slow_move_speed = self:GetAbilitySpecialValueFor("slow_move_speed")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.damage_pct_ancient = self:GetAbilitySpecialValueFor("damage_pct_ancient")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_sp_cataclysm_aura:OnRefresh(params)
	self.slow_move_speed = self:GetAbilitySpecialValueFor("slow_move_speed")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.damage_pct_ancient = self:GetAbilitySpecialValueFor("damage_pct_ancient")
	self.interval = self:GetAbilitySpecialValueFor("interval")
end
function modifier_sp_cataclysm_aura:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end
		local fDamage = hParent:GetMaxHealth() * self.damage_pct*0.01
		if hParent:IsBoss() or hParent:IsGoldWave() then
			fDamage = hParent:GetMaxHealth() * self.damage_pct_ancient*0.01
		end
		ApplyDamage({
			victim = hParent,
			attacker = hCaster,
			ability = hAbility,
			damage = fDamage,
			damage_type = hAbility:GetAbilityDamageType(),
		})
	end
end
function modifier_sp_cataclysm_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_sp_cataclysm_aura:GetModifierMoveSpeedBonus_Percentage(params)
	return -self.slow_move_speed * self:GetParent():GetStatusResistanceFactor(self:GetCaster())
end