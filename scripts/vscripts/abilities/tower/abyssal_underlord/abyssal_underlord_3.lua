LinkLuaModifier("modifier_abyssal_underlord_3", "abilities/tower/abyssal_underlord/abyssal_underlord_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_3_thinker", "abilities/tower/abyssal_underlord/abyssal_underlord_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enigma_3_devil", "abilities/tower/abyssal_underlord/abyssal_underlord_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if abyssal_underlord_3 == nil then
	abyssal_underlord_3 = class({})
end
function abyssal_underlord_3:GetIntrinsicModifierName()
	return "modifier_abyssal_underlord_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_abyssal_underlord_3 == nil then
	modifier_abyssal_underlord_3 = class({}, nil, eom_modifier)
end
function modifier_abyssal_underlord_3:IsHidden()
	return true
end
function modifier_abyssal_underlord_3:OnCreated(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	if IsServer() then
	end
end
function modifier_abyssal_underlord_3:OnRefresh(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	if IsServer() then
	end
end
function modifier_abyssal_underlord_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_abyssal_underlord_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_abyssal_underlord_3:OnInBattle()
	local hParent = self:GetParent()
	if hParent:IsAlive() then
		self.hThinker = CreateModifierThinker(hParent, self:GetAbility(), "modifier_abyssal_underlord_3_thinker", { duration = 100 }, hParent:GetAbsOrigin(), hParent:GetTeamNumber(), false)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_abyssal_underlord_3_thinker == nil then
	modifier_abyssal_underlord_3_thinker = class({}, nil, eom_modifier)
end
function modifier_abyssal_underlord_3_thinker:OnCreated(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	if IsServer() then
		GameTimer(5, function()
			if IsValid(hCaster) and IsValid(hParent) then
				local hDevil = CreateUnitByName("abyss_devil", hParent:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
				FindClearSpaceForUnit(hDevil, hParent:GetAbsOrigin(), true)

				hDevil:FireSummonned(hCaster)

				Attributes:Register(hDevil)
				hDevil:AddNewModifier(hCaster, hAbility, "modifier_enigma_3_devil", { duration = self.summon_interval })
			end
		end)
		self:StartIntervalThink(self.summon_interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/abyss/abyssknight_3_summon.vpcf", PATTACH_WORLDORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin() + Vector(0, 0, 128))
		ParticleManager:SetParticleControl(iParticleID, 6, hParent:GetAbsOrigin() + Vector(0, 0, 128))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_abyssal_underlord_3_thinker:OnRefresh(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	if IsServer() then
	end
end
function modifier_abyssal_underlord_3_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end
function modifier_abyssal_underlord_3_thinker:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_abyssal_underlord_3_thinker:OnBattleEnd()
	-- 回合清除
	self:Destroy()
end
function modifier_abyssal_underlord_3_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	-- local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/abyss/abyssknight_3_summon_a.vpcf", PATTACH_ABSORIGIN, hParent)
	-- ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin() + Vector(0, 0, 228))
	-- ParticleManager:SetParticleControl(iParticleID, 6, hParent:GetAbsOrigin() + Vector(0, 0, 228))
	-- self:AddParticle(iParticleID, false, false, -1, false, false)\
	if hCaster and hParent then
		local hDevil = CreateUnitByName("abyss_devil", self:GetParent():GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
		FindClearSpaceForUnit(hDevil, self:GetParent():GetAbsOrigin(), true)

		hDevil:FireSummonned(hCaster)

		Attributes:Register(hDevil)
		hDevil:AddNewModifier(hCaster, self:GetAbility(), "modifier_enigma_3_devil", { duration = self.summon_interval })
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_enigma_3_devil == nil then
	modifier_enigma_3_devil = class({}, nil, eom_modifier)
end
function modifier_enigma_3_devil:OnCreated(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.selfLevel = self:GetAbility():GetLevel()

	if IsServer() then
	end
end
function modifier_enigma_3_devil:OnRefresh(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	if IsServer() then
	end
end
function modifier_enigma_3_devil:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_enigma_3_devil:OnBattleEnd()
	self:Destroy()
end
function modifier_enigma_3_devil:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = (0 + self.selfLevel * 100),
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = (0 + self.selfLevel * 100),
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = (0 + self.selfLevel * 100),
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = (0 + self.selfLevel * 100),
	}
end