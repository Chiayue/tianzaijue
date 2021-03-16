LinkLuaModifier("modifier_skywrath_mage_1", "abilities/tower/skywrath_mage/skywrath_mage_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skywrath_mage_1_buff", "abilities/tower/skywrath_mage/skywrath_mage_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skywrath_mage_1 == nil then
	skywrath_mage_1 = class({})
end
function skywrath_mage_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function skywrath_mage_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local fDuration = self:GetDuration()
	local fRadius = self:GetSpecialValueFor("radius")
	local tUnits = FindUnitsInRadius(
	hCaster:GetTeamNumber(),
	self:GetCursorPosition(),
	nil,
	fRadius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false
	)
	for _, hEnemy in pairs(tUnits) do
		if IsValid(hEnemy) then
			hEnemy:AddBuff(hCaster, BUFF_TYPE.HEX, fDuration)
			-- hEnemy:AddBuff(hCaster, BUFF_TYPE.DISARM, fDuration)
			-- hEnemy:AddBuff(hCaster, BUFF_TYPE.MUTE, fDuration)
			-- hEnemy:AddBuff(hCaster, BUFF_TYPE.SILENCE, fDuration)
			hEnemy:AddNewModifier(hCaster, self, "modifier_skywrath_mage_1_buff", { duration = fDuration * hEnemy:GetStatusResistanceFactor(hCaster) })
		end
	end

	hCaster:EmitSound("Hero_Lion.Voodoo")
end
function skywrath_mage_1:GetIntrinsicModifierName()
	return "modifier_skywrath_mage_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_skywrath_mage_1 == nil then
	modifier_skywrath_mage_1 = class({}, nil, BaseModifier)
end
function modifier_skywrath_mage_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_skywrath_mage_1:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self:GetAbility():entindex(),
				Position = tTargets[1]:GetAbsOrigin()
			})
		end
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_skywrath_mage_1_buff == nil then
	modifier_skywrath_mage_1_buff = class({})
end
function modifier_skywrath_mage_1_buff:IsHidden()
	return true
end
function modifier_skywrath_mage_1_buff:IsDebuff()
	return true
end
function modifier_skywrath_mage_1_buff:IsPurgable()
	return false
end
function modifier_skywrath_mage_1_buff:IsPurgeException()
	return true
end
function modifier_skywrath_mage_1_buff:IsStunDebuff()
	return false
end
function modifier_skywrath_mage_1_buff:AllowIllusionDuplicate()
	return false
end
function modifier_skywrath_mage_1_buff:OnCreated(params)
	self.fMoveSpeed = self:GetAbilitySpecialValueFor("movespeed")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")

	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_SPAWN)

	self:PlayEffects(true)
end
function modifier_skywrath_mage_1_buff:OnRefresh(params)
	self.fMoveSpeed = self:GetAbilitySpecialValueFor("movespeed")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")

	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_SPAWN)
	self:PlayEffects(true)
end
function modifier_skywrath_mage_1_buff:OnDestroy(params)
	if not IsServer() then return end

	self:GetParent():FadeGesture(ACT_DOTA_SPAWN)
	self:PlayEffects(false)
end
function modifier_skywrath_mage_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_skywrath_mage_1_buff:GetModifierMoveSpeedOverride()
	return self.fMoveSpeed
end
function modifier_skywrath_mage_1_buff:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end
function modifier_skywrath_mage_1_buff:GetModifierIncomingDamage_Percentage()
	return self.bonus_damage_pct
end
function modifier_skywrath_mage_1_buff:CheckState()
	return {
	-- [MODIFIER_STATE_HEXED] = true,
	-- [MODIFIER_STATE_DISARMED] = true,
	-- [MODIFIER_STATE_SILENCED] = true,
	-- [MODIFIER_STATE_MUTED] = true,
	}
end
function modifier_skywrath_mage_1_buff:PlayEffects(bStart)
	local iParticle = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", self:GetCaster()), PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:ReleaseParticleIndex(iParticle)

	if bStart then
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Lion.Hex.Target", self:GetCaster())
	end
end