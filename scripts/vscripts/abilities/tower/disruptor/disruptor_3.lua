LinkLuaModifier("modifier_disruptor_3", "abilities/tower/disruptor/disruptor_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disruptor_3_buff", "abilities/tower/disruptor/disruptor_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if disruptor_3 == nil then
	disruptor_3 = class({})
end
function disruptor_3:GetIntrinsicModifierName()
	return "modifier_disruptor_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_disruptor_3 == nil then
	modifier_disruptor_3 = class({}, nil, eom_modifier)
end
function modifier_disruptor_3:IsHidden()
	return true
end
function modifier_disruptor_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE
	}
end
function modifier_disruptor_3:OnInBattle()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disruptor_3_buff", nil)
end
---------------------------------------------------------------------
if modifier_disruptor_3_buff == nil then
	modifier_disruptor_3_buff = class({}, nil, eom_modifier)
end
function modifier_disruptor_3_buff:OnCreated(params)
	self.magical_armor = self:GetAbilitySpecialValueFor("magical_armor")
	self.armor2magical = self:GetAbilitySpecialValueFor("armor2magical")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 4, Vector(1, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_disruptor_3_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_disruptor_3_buff:OnDestroy()
	if IsServer() then
		if GSManager:getStateType() ~= GS_Battle then
			return
		end
		local tTargets = {}
		EachUnits(iPlayerID, function(hUnit)
			if hUnit:IsAlive() then
				table.insert(tTargets, hUnit)
			end
		end, UnitType.AllFirends)
		table.sort(tTargets, function(a, b)
			return CalculateDistance(a, self:GetParent()) < CalculateDistance(b, self:GetParent())
		end)
		-- ArrayRemove(tTargets, self:GetParent())
		if IsValid(tTargets[1]) then
			tTargets[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_disruptor_3_buff", nil)
		end
	end
end
function modifier_disruptor_3_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.magical_armor,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_MAGICAL_ATTACK_BONUS
	}
end
function modifier_disruptor_3_buff:GetMagicalArmorBonus()
	return self.magical_armor
end
function modifier_disruptor_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
function modifier_disruptor_3_buff:OnTooltip()
	return self.magical_armor
end
function modifier_disruptor_3_buff:OnTooltip2()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.armor2magical * 0.01
end
function modifier_disruptor_3_buff:GetMagicalAttackBonus()
	return self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.armor2magical * 0.01
end
function modifier_disruptor_3_buff:OnBattleEnd()
	self:Destroy()
end