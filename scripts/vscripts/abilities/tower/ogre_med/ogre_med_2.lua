LinkLuaModifier("modifier_ogre_med_2", "abilities/tower/ogre_med/ogre_med_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if ogre_med_2 == nil then
	ogre_med_2 = class({})
end
function ogre_med_2:GetIntrinsicModifierName()
	return "modifier_ogre_med_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ogre_med_2 == nil then
	modifier_ogre_med_2 = class({}, nil, eom_modifier)
end
function modifier_ogre_med_2:IsHidden()
	return true
end
function modifier_ogre_med_2:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		self.records = {}
	end
end
function modifier_ogre_med_2:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		self.records = {}
	end
end
function modifier_ogre_med_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_ogre_med_2:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	if RollPseudoRandomPercentage(self.chance, tAttackInfo.attacker:entindex(), tAttackInfo.attacker) then
		tAttackInfo.attacker:DealDamage(hTarget, self:GetAbility(), 0)

		local hCaster = tAttackInfo.attacker
		hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_duration)

		local hAbility = hCaster:FindAbilityByName("ogre_med_3")
		if IsValid(hAbility) then
			hAbility:Action()
		end
	end
end