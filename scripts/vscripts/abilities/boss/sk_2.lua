LinkLuaModifier( "modifier_sk_2", "abilities/boss/sk_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sk_2_thinker", "abilities/boss/sk_2.lua", LUA_MODIFIER_MOTION_NONE )

--Abilities
if sk_2 == nil then
	sk_2 = class({})
end
function sk_2:OnAbilityPhaseStart()
-- 	if IsServer() then
-- 		self.nPreviewFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
-- 		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_tail", self:GetCaster():GetOrigin(), true )
-- 		EmitSoundOn( "SandKingBoss.Epicenter.spell", self:GetCaster() )
-- 		self.nChannelFX = ParticleManager:CreateParticle( "particles/test_particle/dungeon_sand_king_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
-- 		self.hModifier = self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY)
-- 	end
	self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY, self:GetCastPoint())
	return true
end
-- function sk_2:OnAbilityPhaseInterrupted()
-- 	if IsServer() then
-- 		self.hModifier:Destroy()
-- 		ParticleManager:DestroyParticle( self.nPreviewFX, false )
-- 	end
-- end
-- function sk_2:GetPlaybackRateOverride()
-- 	return 2
-- end
function sk_2:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sk_2_thinker", {duration = 6})
	if IsServer() then
		-- self.hModifier:Destroy()
		-- self.Projectiles = {}
		-- ParticleManager:DestroyParticle( self.nPreviewFX, false )
		-- self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sk_2_thinker", {} )
		-- self.hThinker = CreateModifierThinker(self:GetCaster(), self, "modifier_sk_2_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	end
end
-- function sk_2:OnChannelFinish( bInterrupted )
-- 	if IsServer() then
-- 		-- self:GetCaster():RemoveModifierByName( "modifier_sk_2_thinker" )
-- 		ParticleManager:DestroyParticle( self.nChannelFX, false )
-- 		self.hThinker:RemoveModifierByName("modifier_sk_2_thinker")
-- 		-- self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4) 
-- 	end
-- end
function sk_2:GetIntrinsicModifierName()
	return "modifier_sk_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sk_2 == nil then
	modifier_sk_2 = class({}, nil, BaseModifier)
end
function modifier_sk_2:OnCreated(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sk_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and self:GetParent():GetHealthPercent() < self.threshold then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
		-- local radius = self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), nil)
		-- local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		-- if IsValid(tTargets[1]) then
		-- 	ExecuteOrderFromTable({
		-- 		UnitIndex = self:GetParent():entindex(),
		-- 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		-- 		AbilityIndex = self:GetAbility():entindex(),
		-- 		Position = tTargets[1]:GetAbsOrigin()
		-- 	})
		-- end
	end
end
function modifier_sk_2:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_sk_2_thinker == nil then
	modifier_sk_2_thinker = class({}, nil, ModifierHidden)
end
function modifier_sk_2_thinker:OnCreated(params)
	self.initial_radius = self:GetAbilitySpecialValueFor("initial_radius")
	self.radius_per_second = self:GetAbilitySpecialValueFor("radius_per_second")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_per_second = self:GetAbilitySpecialValueFor("damage_per_second")
	if IsServer() then
		self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
		self:StartIntervalThink(0.4)
	end
end
function modifier_sk_2_thinker:OnIntervalThink()
	local radius = self.initial_radius + self.radius_per_second * self:GetStackCount()
	local damage = self.damage + self.damage_per_second * self:GetStackCount()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		local damageInfo = 
		{
			victim = hUnit,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = hAbility:GetAbilityDamageType(),
			ability = hAbility,
		}
		ApplyDamage( damageInfo )
	end
	self:IncrementStackCount()
	local iParticleID = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( iParticleID, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( iParticleID, 1, Vector(radius, radius, radius) )
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function modifier_sk_2_thinker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_sk_2_thinker:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end