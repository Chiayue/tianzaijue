LinkLuaModifier("modifier_silencer_summon_1", "abilities/tower/silencer_summon/silencer_summon_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if silencer_summon_1 == nil then
	silencer_summon_1 = class({})
end
function silencer_summon_1:GetIntrinsicModifierName()
	return "modifier_silencer_summon_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_silencer_summon_1 == nil then
	modifier_silencer_summon_1 = class({}, nil, eom_modifier)
end
function modifier_silencer_summon_1:IsHidden()
	return true
end
function modifier_silencer_summon_1:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_silencer_summon_1:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_silencer_summon_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_silencer_summon_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[MODIFIER_EVENT_ON_ATTACKED] = { self:GetParent(), nil },
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() }
	}
end
function modifier_silencer_summon_1:OnBattleEnd()
	local hParent = self:GetParent()
	hParent:ForceKill(false)
end
function modifier_silencer_summon_1:OnAttacked(params)
	if not IsValid(params.target)
	or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker ~= self:GetParent()
	or params.attacker:PassivesDisabled()
	or params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		return
	end

	local hTarget = params.target
	local hAbility = self:GetAbility()

	hTarget:AddBuff(self:GetCaster(), BUFF_TYPE.SILENCE, self.duration)
end
function modifier_silencer_summon_1:OnDeath(params)
	if params.unit == self:GetParent() then
		local hCaster = self:GetCaster()

		local iParticle = ParticleManager:CreateParticle("particles/econ/items/silencer/silencer_ti6/silencer_last_word_dmg_ti6.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(iParticle, 0, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticle)

		local tEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for k, hEnemy in pairs(tEnemies) do
			if IsValid(hEnemy) then
				hEnemy:AddBuff(self:GetCaster(), BUFF_TYPE.SILENCE, self.duration)
			end
		end
	end
end