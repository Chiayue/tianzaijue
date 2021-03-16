LinkLuaModifier("modifier_meepo_1", "abilities/tower/meepo/meepo_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meepo_1_buff", "abilities/tower/meepo/meepo_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meepo_1_debuff", "abilities/tower/meepo/meepo_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if meepo_1 == nil then
	meepo_1 = class({})
end
function meepo_1:GetIntrinsicModifierName()
	return "modifier_meepo_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_meepo_1 == nil then
	modifier_meepo_1 = class({}, nil, eom_modifier)
end
function modifier_meepo_1:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.stun_time = self:GetAbilitySpecialValueFor("stun_time")
	self.attack_bonus = self:GetAbilitySpecialValueFor("attack_bonus")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_meepo_1:IsHidden()
	return true
end
function modifier_meepo_1:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.stun_time = self:GetAbilitySpecialValueFor("stun_time")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_meepo_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_meepo_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_meepo_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local arc_damage_percent_add = 0

	local hCaster = self:GetParent()
	if not Spawner:IsBossRound() and not Spawner:IsGoldRound() then
		if RollPercentage(self.chance) then
			hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_time)
			hCaster:AddNewModifier(hCaster, self:GetAbility(), 'modifier_meepo_1_buff', { duration = self.duration })
			hTarget:AddNewModifier(hCaster, self:GetAbility(), 'modifier_meepo_1_debuff', { duration = self.stun_time })
		end
	end
	if Spawner:IsBossRound() or Spawner:IsGoldRound() then
		if RollPercentage(self.chance) then
			hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_time * 0.5)
			hCaster:AddNewModifier(hCaster, self:GetAbility(), 'modifier_meepo_1_buff', { duration = self.duration })
			hTarget:AddNewModifier(hCaster, self:GetAbility(), 'modifier_meepo_1_debuff', { duration = self.stun_time })
		end
	end
end

--------------------------
---------------------------------------------------------------------
--Modifiers
if modifier_meepo_1_buff == nil then
	modifier_meepo_1_buff = class({}, nil, eom_modifier)
end
function modifier_meepo_1_buff:OnCreated(params)
	self:SetStackCount(1)
	self.attack_bonus = self:GetAbilitySpecialValueFor("attack_bonus")
end
function modifier_meepo_1_buff:OnRefresh(params)
	self.attack_bonus = self:GetAbilitySpecialValueFor("attack_bonus")
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_meepo_1_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end

function modifier_meepo_1_buff:GetPhysicalAttackBonus()
	return self:GetStackCount() * self.attack_bonus
end
function modifier_meepo_1_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_meepo_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_meepo_1_buff:OnTooltip()
	return self:GetStackCount() * self.attack_bonus
end
--------------------------
---------------------------------------------------------------------
--Modifiers
if modifier_meepo_1_debuff == nil then
	modifier_meepo_1_debuff = class({}, nil, BaseModifier)
end
function modifier_meepo_1_debuff:IsHidden()
	return true
end
function modifier_meepo_1_debuff:OnCreated(params)
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient_poof.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iPtclID, false, false, -1, false, false)
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end