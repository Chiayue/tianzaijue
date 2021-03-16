LinkLuaModifier("modifier_golemB_1", "abilities/tower/golemB/golemB_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golemB_1_buff", "abilities/tower/golemB/golemB_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if golemB_1 == nil then
	golemB_1 = class({})
end
function golemB_1:GetIntrinsicModifierName()
	return "modifier_golemB_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_golemB_1 == nil then
	modifier_golemB_1 = class({}, nil, eom_modifier)
end
function modifier_golemB_1:OnCreated(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	if IsServer() then
		self.flDamageRecorder = 0
		self.flHealth = self:GetParent():GetHealth()
	end
end
function modifier_golemB_1:IsHidden()
	if not self:GetParent():HasModifier("modifier_golemB_1_buff") then
		return false
	end
	return true
end
function modifier_golemB_1:OnRefresh(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	if IsServer() then
	end
end
function modifier_golemB_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_golemB_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_IN_BATTLE
	}
end
function modifier_golemB_1:OnInBattle()
	self.flDamageRecorder = 0
end
function modifier_golemB_1:OnTakeDamage(params)
	if GSManager:getStateType() ~= GS_Battle then
		return
	end
	local hParent = self:GetParent()
	self.flDamageRecorder = self.flDamageRecorder + math.min(params.damage, self.flHealth)
	self.flHealth = hParent:GetHealth()
	local threshold = hParent:GetMaxHealth() * self.threshold * 0.01
	if not hParent:HasModifier("modifier_golemB_1_buff") and self.flDamageRecorder > threshold then
		local count = math.floor(self.flDamageRecorder / threshold)
		local summoner_atk_stack = math.floor(hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack) / hParent:GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE))
		for i = 1, count do
			self.flDamageRecorder = self.flDamageRecorder - threshold
			local hGolem = hParent:Summon(hParent:GetUnitName())
			hGolem:LevelUp(true, hParent:GetLevel() - 1)
			hGolem:AddNewModifier(hGolem, nil, "modifier_star_indicator", nil)
			hGolem:ModifyMaxHealth(-hGolem:GetMaxHealth() * (1 - self.health_pct * 0.01))
			hGolem:AddNewModifier(hParent, self:GetAbility(), "modifier_golemB_1_buff", nil)
			hGolem:SetModifierStackCount("modifier_golemB_1_buff", hParent, summoner_atk_stack)
			hGolem:AddNewModifier(hParent, nil, "modifier_building_ai", nil)
			hGolem:SetHullRadius(12)
			hGolem:SetForwardVector(hParent:GetForwardVector())
			for i = 0, 2 do
				hGolem:GetAbilityByIndex(i):SetLevel(hParent:GetAbilityByIndex(i):GetLevel())
			end
			hParent:KnockBack(hParent:GetAbsOrigin(), hGolem, 300, 150, 1, true)
			hGolem:AddBuff(hParent, BUFF_TYPE.INVINCIBLE, 1)
		end
	end
end
---------------------------------------------------------------------
if modifier_golemB_1_buff == nil then
	modifier_golemB_1_buff = class({}, nil, eom_modifier)
end
function modifier_golemB_1_buff:OnCreated(params)
	if IsServer() then
		self:GetParent():SetModelScale(0.5)
		self.flDamageRecorder = 0
	end
end
function modifier_golemB_1_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ATTACK_BONUS,
	}
end
function modifier_golemB_1_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_golemB_1_buff:GetPhysicalAttackBonus()
	return self:GetStackCount() * self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE)
end

function modifier_golemB_1_buff:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end