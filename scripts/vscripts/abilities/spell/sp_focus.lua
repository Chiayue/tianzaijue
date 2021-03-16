LinkLuaModifier("modifier_sp_focus_buff", "abilities/spell/sp_focus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_focus_debuff", "abilities/spell/sp_focus.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_focus == nil then
	sp_focus = class({}, nil, sp_base)
end
function sp_focus:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_focus:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local hTarget = self:GetCursorTarget()
	if not IsValid(hTarget) then return end

	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, hTarget:GetAbsOrigin()) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local fDuration = GetStatusDebuffDuration(duration, hTarget, hCaster)
	hTarget:AddNewModifier(hCaster, self, "modifier_sp_focus_debuff", { duration = fDuration })

	local tTargets = FindUnitsInRadius(iTeamNumber, hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hTarget, self, "modifier_sp_focus_buff", { duration = fDuration })
	end

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "General.PingAttack", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_focus_buff == nil then
	modifier_sp_focus_buff = class({}, nil, eom_modifier)
end
function modifier_sp_focus_buff:IsHidden()
	return false
end
function modifier_sp_focus_buff:IsDebuff()
	return false
end
function modifier_sp_focus_buff:IsPurgable()
	return false
end
function modifier_sp_focus_buff:IsPurgeException()
	return false
end
function modifier_sp_focus_buff:IsStunDebuff()
	return false
end
function modifier_sp_focus_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_ATTACK_TARGET, self:GetCaster())
		self:StartIntervalThink(0.1)
	end
end
function modifier_sp_focus_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_sp_focus_buff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()

		if not IsValid(hCaster) or not hCaster:IsAlive() or CalcDistanceBetweenEntityOBB(hCaster, hParent) > self.radius then
			self:Destroy()
			return
		end

		if hParent:IsAttacking() then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_TARGET, hCaster)
		end
	end
end
function modifier_sp_focus_buff:ECheckState()
	return {
		[MODIFIER_STATE_AI_DISABLED] = true
	}
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_focus_debuff == nil then
	modifier_sp_focus_debuff = class({}, nil, eom_modifier)
end
function modifier_sp_focus_debuff:IsHidden()
	return false
end
function modifier_sp_focus_debuff:IsDebuff()
	return true
end
function modifier_sp_focus_debuff:IsPurgable()
	return false
end
function modifier_sp_focus_debuff:IsPurgeException()
	return false
end
function modifier_sp_focus_debuff:IsStunDebuff()
	return false
end
function modifier_sp_focus_debuff:OnCreated(params)
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/ui_mouseactions/ping_attack.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(self:GetDuration(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_focus_debuff:OnRefresh(params)
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
end
function modifier_sp_focus_debuff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = self.bonus_damage_pct
	}
end
function modifier_sp_focus_debuff:GetIncomingPercentage()
	return self.bonus_damage_pct
end