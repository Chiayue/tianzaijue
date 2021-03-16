LinkLuaModifier("modifier_warlockA_3", "abilities/tower/warlockA/warlockA_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warlockA_3_buff", "abilities/tower/warlockA/warlockA_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warlockA_3_heal", "abilities/tower/warlockA/warlockA_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if warlockA_3 == nil then
	warlockA_3 = class({})
end
function warlockA_3:GetIntrinsicModifierName()
	return "modifier_warlockA_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_warlockA_3 == nil then
	modifier_warlockA_3 = class({}, nil, eom_modifier)
end
function modifier_warlockA_3:OnCreated(params)
	self.health_trigle_pct = self:GetAbilitySpecialValueFor("health_trigle_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.heatlh_recover_pct = self:GetAbilitySpecialValueFor("heatlh_recover_pct")
	self.health_recover = self:GetAbilitySpecialValueFor("health_recover")
	if IsServer() then
	end
end
function modifier_warlockA_3:OnRefresh(params)
	self.health_trigle_pct = self:GetAbilitySpecialValueFor("health_trigle_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.heatlh_recover_pct = self:GetAbilitySpecialValueFor("heatlh_recover_pct")
	self.health_recover = self:GetAbilitySpecialValueFor("health_recover")
	if IsServer() then
	end
end
function modifier_warlockA_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_warlockA_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
	-- [MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent()},
	}
end
--先寻找一个目标作为契约者
function modifier_warlockA_3:OnInBattle()
	if IsServer() then
		local hParent = self:GetParent()
		local tTargets = {}
		EachUnits(GetPlayerID(hParent), function(hUnit)
			if hUnit ~= hParent then
				table.insert(tTargets, hUnit)
			end
		end, UnitType.AllFirends - UnitType.Commander)
		table.sort(tTargets, function(a, b)
			return CalculateDistance(a, hParent) < CalculateDistance(b, hParent)
		end)
		if IsValid(tTargets[1]) then
			tTargets[1]:AddNewModifier(hParent, self:GetAbility(), 'modifier_warlockA_3_buff', {})
		end
	end
end
function modifier_warlockA_3:OnDeath(params)
	--术士死了buff消失
	self:Destroy()
end
function modifier_warlockA_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_warlockA_3:OnTooltip()
	return self.health_trigle_pct
end
---------------------------------------------------------------------
--Modifiers
if modifier_warlockA_3_buff == nil then
	modifier_warlockA_3_buff = class({}, nil, eom_modifier)
end
function modifier_warlockA_3_buff:OnCreated(params)
	self.health_trigle_pct = self:GetAbilitySpecialValueFor("health_trigle_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/warlock/warlock_3_contract.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end

	--契约buff
end
function modifier_warlockA_3_buff:OnRefresh(params)
	self.health_trigle_pct = self:GetAbilitySpecialValueFor("health_trigle_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_warlockA_3_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_warlockA_3_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END
	}
end

function modifier_warlockA_3_buff:OnBattleEnd()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_warlockA_3_buff:OnTakeDamage()
	if not IsValid(self) then return end
	if not IsValid(self:GetParent()) then return end
	if not IsValid(self:GetAbility()) then return end

	--受伤回血
	if self:GetParent():GetHealthPercent() <= self.health_trigle_pct and self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, true)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_warlockA_3_heal', { duration = self.duration })
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_warlockA_3_heal', { duration = self.duration })
	end
end
function modifier_warlockA_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_warlockA_3_buff:OnTooltip()
	return self.health_trigle_pct
end

---------------------------------------------------------------------
--Modifiers
--回血buff
if modifier_warlockA_3_heal == nil then
	modifier_warlockA_3_heal = class({}, nil, eom_modifier)
end
function modifier_warlockA_3_heal:OnCreated(params)
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.heatlh_recover_pct = self:GetAbilitySpecialValueFor("heatlh_recover_pct")
	self.health_recover = self:GetAbilitySpecialValueFor("health_recover")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
		-- self:StartIntervalThink(1)
	end
end
function modifier_warlockA_3_heal:OnRefresh(params)
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.heatlh_recover_pct = self:GetAbilitySpecialValueFor("heatlh_recover_pct")
	self.health_recover = self:GetAbilitySpecialValueFor("health_recover")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	else
	end
end

function modifier_warlockA_3_heal:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_HEALTH_REGEN_BONUS,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
	}
end

function modifier_warlockA_3_heal:OnIntervalThink()
	-- self:GetParent():Heal(self:GetParent():GetMaxHealth() * self.heatlh_recover_pct * 0.01, self:GetAbility())
end

function modifier_warlockA_3_heal:GetHealthRegenBonus()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.heatlh_recover_pct * 0.01
end

function modifier_warlockA_3_heal:GetMagicalAttackBonusPercentage()
	return self.attack_bonus_pct
end

function modifier_warlockA_3_heal:GetPhysicalAttackBonusPercentage()
	return self.attack_bonus_pct
end

function modifier_warlockA_3_heal:OnBattleEnd()
	self:Destroy()
end