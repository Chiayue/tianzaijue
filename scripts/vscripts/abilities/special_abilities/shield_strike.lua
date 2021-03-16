LinkLuaModifier("modifier_shield_strike", "abilities/special_abilities/shield_strike.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if shield_strike == nil then
	shield_strike = class({})
end
function shield_strike:GetIntrinsicModifierName()
	return "modifier_shield_strike"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shield_strike == nil then
	modifier_shield_strike = class({}, nil, eom_modifier)
end
function modifier_shield_strike:OnCreated(params)
	if IsServer() then
	end
end
function modifier_shield_strike:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_shield_strike:OnDestroy()
	if IsServer() then
	end
end
function modifier_shield_strike:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() }
	}
end
function modifier_shield_strike:OnAttack(params)
	if params.target == nil
	or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker ~= self:GetParent()
	or params.attacker:PassivesDisabled()
	or params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		return
	end

	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		local hTarget = params.target
		if IsValid(hTarget) and hTarget:IsAlive() then
			StartCooldown(hAbility)

			local hCaster = self:GetCaster()
			local duration = GetStatusDebuffDuration(hAbility:GetDuration(), hTarget, hCaster)
			hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, duration)
		end
	end
end