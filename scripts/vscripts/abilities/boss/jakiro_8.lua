LinkLuaModifier("modifier_jakiro_8", "abilities/boss/jakiro_8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_8_respawn", "abilities/boss/jakiro_8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_8_egg", "abilities/boss/jakiro_8.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if jakiro_8 == nil then
	jakiro_8 = class({})
end
function jakiro_8:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.INVINCIBLE, self:GetCastPoint())
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	return true
end
function jakiro_8:OnSpellStart()
	local hCaster = self:GetCaster()
	-- local hTarget = self:GetCursorTarget()
	hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_8_respawn", { duration = self:GetDuration() })
	-- 所有蛋连接
	local tEgg = hCaster:GetEgg()
	for i, hEgg in ipairs(tEgg) do
		hEgg:Active()
		hEgg:AddNewModifier(hCaster, self, "modifier_jakiro_8_egg", { duration = self:GetDuration() })
	end
end
function jakiro_8:GetIntrinsicModifierName()
	return "modifier_jakiro_8"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_8 == nil then
	modifier_jakiro_8 = class({}, nil, ModifierHidden)
end
function modifier_jakiro_8:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_jakiro_8:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetAbility():IsCooldownReady() and hParent:GetHealthPercent() <= self.trigger_pct and #hParent:GetEgg() > 0 then
		for i, hEgg in ipairs(hParent:GetEgg()) do
			hEgg:UnActive()
		end
		hParent:Purge(false, true, false, true, true)
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
function modifier_jakiro_8:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_jakiro_8:GetActivityTranslationModifiers()
	return 2
end
---------------------------------------------------------------------
if modifier_jakiro_8_respawn == nil then
	modifier_jakiro_8_respawn = class({}, nil, ModifierHidden)
end
function modifier_jakiro_8_respawn:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_jakiro_8_respawn:OnCreated(params)
	self.heal_per_egg = self:GetAbilitySpecialValueFor("heal_per_egg")
	if IsServer() then
		local iEggCount = #self:GetCaster():GetEgg()
		-- self.flHealPerEgg = (iEggCount == 0) and 0 or self:GetCaster():GetHealthDeficit() / iEggCount
		-- self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_medusa_stone_gaze.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, 100, false, false)
	end
end
function modifier_jakiro_8_respawn:OnDestroy()
	if IsServer() then
		local flHealAmount = self.heal_per_egg * #self:GetCaster():GetEgg()
		local hCaster = self:GetCaster()
		if flHealAmount > 0 then
			self:GetCaster():Heal(flHealAmount * self:GetCaster():GetMaxHealth() * 0.01, self:GetAbility())
			self:GetCaster():RemoveAllModifiers(1, false, false, true)
			hCaster:AddActivityModifier("loadout")

			hCaster:StartGesture(ACT_DOTA_SPAWN)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 1, 1))
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
function modifier_jakiro_8_respawn:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_FROZEN] = self:GetElapsedTime() > FrameTime(),
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_jakiro_8_egg == nil then
	modifier_jakiro_8_egg = class({}, nil, eom_modifier)
end
function modifier_jakiro_8_egg:OnCreated(params)
	self.bonus_physical_armor = self:GetAbilitySpecialValueFor("bonus_physical_armor")
	self.bonus_magical_armor = self:GetAbilitySpecialValueFor("bonus_magical_armor")
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsServer() then
		-- hParent:Active()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/jakiro/jakiro_8.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_8_egg:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		if hParent:IsAlive() then
			-- hCaster:SetHealth(hCaster:GetMaxHealth())
			-- hCaster:AddActivityModifier("loadout")
			-- hCaster:ForcePlayActivityOnce(ACT_DOTA_SPAWN)
			-- local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, hCaster)
			-- ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 1, 1))
			-- ParticleManager:ReleaseParticleIndex(iParticleID)
		else
			-- hCaster:RemoveModifierByName("modifier_jakiro_8_respawn")
		end
	end
end
function modifier_jakiro_8_egg:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.bonus_magical_armor,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.bonus_physical_armor
	}
end
function modifier_jakiro_8_egg:GetMagicalArmorBonus()
	return self.bonus_magical_armor
end
function modifier_jakiro_8_egg:GetPhysicalArmorBonus()
	return self.bonus_physical_armor
end