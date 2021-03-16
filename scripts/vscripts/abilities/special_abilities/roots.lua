LinkLuaModifier("modifier_roots", "abilities/special_abilities/roots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roots_debuff", "abilities/special_abilities/roots.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if roots == nil then
	roots = class({})
end
function roots:GetIntrinsicModifierName()
	return "modifier_roots"
end
---------------------------------------------------------------------
--Modifiers
if modifier_roots == nil then
	modifier_roots = class({}, nil, eom_modifier)
end
function modifier_roots:OnCreated(params)
	self.rooted_pct = self:GetAbilitySpecialValueFor("rooted_pct")
	self.rooted_duration = self:GetAbilitySpecialValueFor("rooted_duration")
	if IsServer() then
	end
end
function modifier_roots:OnRefresh(params)
	self.rooted_pct = self:GetAbilitySpecialValueFor("rooted_pct")
	self.rooted_duration = self:GetAbilitySpecialValueFor("rooted_duration")
	if IsServer() then
	end
end
function modifier_roots:OnDestroy()
	if IsServer() then
	end
end
function modifier_roots:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACKED] = { self:GetParent() }
	}
end
function modifier_roots:OnAttacked(params)
	if params.target == nil
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

	if IsValid(hTarget) and IsValid(hAbility) and hTarget:IsAlive() then
		local iRandom = RandomInt(0, 100)
		local hCaster = self:GetCaster()
		if iRandom <= self.rooted_pct then
			local duration = GetStatusDebuffDuration(self.rooted_duration, hTarget, self:GetCaster())
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_roots_debuff", { duration = duration })
			hTarget:AddBuff(hCaster, BUFF_TYPE.IGNITE, duration, false, { iCount = 50 })
		end
	end
end

------------------------------------------------------------------------------
if modifier_roots_debuff == nil then
	modifier_roots_debuff = class({}, nil, BaseModifier)
end
function modifier_roots_debuff:OnCreated(params)
	if IsServer() then

	end
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/neutral_fx/dark_troll_ensnare.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticle, false, false, 5, false, false)
	end
end
function modifier_roots_debuff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_roots_debuff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_roots_debuff:DeclareFunctions()
	return {
	}
end
function modifier_roots_debuff:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end