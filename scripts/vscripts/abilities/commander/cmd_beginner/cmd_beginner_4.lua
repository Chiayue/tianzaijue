LinkLuaModifier("modifier_cmd_beginner_4", "abilities/commander/cmd_beginner/cmd_beginner_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_beginner_4_buff", "abilities/commander/cmd_beginner/cmd_beginner_4.lua", LUA_MODIFIER_MOTION_NONE)

if cmd_beginner_4 == nil then
	cmd_beginner_4 = class({})
end
function cmd_beginner_4:GetIntrinsicModifierName()
	return "modifier_cmd_beginner_4"
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_beginner_4 == nil then
	modifier_cmd_beginner_4 = class({}, nil, eom_modifier)
end
function modifier_cmd_beginner_4:IsHidden()
	return true
end
function modifier_cmd_beginner_4:OnCreated(params)
	self.attack_pct = self:GetAbilitySpecialValueFor('attack_pct')
	if IsServer() then
	end
end
function modifier_cmd_beginner_4:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PLAYER_USE_SPELL
	}
end
function modifier_cmd_beginner_4:OnHeroUseSpell(params)
	-- if IsValid(params.attacker) and GetPlayerID(params.attacker) == GetPlayerID(self:GetParent())
	-- and IsValid(params.inflictor) and params.inflictor.GetAbilityName and params.inflictor:GetAbilityName() == 'sp_fireball'
	-- and 0 < params.original_damage
	if params.iPlayerID == GetPlayerID(self:GetParent())
	then
		local sCardName = params.sCardName
		local hHero = PlayerData:GetHero(params.iPlayerID)
		local Ability = hHero:FindAbilityByName(sCardName)
		if Ability:GetAbilityDamageType() ~= 0 then
			-- AbilityUnitDamageType
			EachUnits(GetPlayerID(self:GetParent()), function(hEnt)
				hEnt:AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_cmd_beginner_4_buff', {})
			end, UnitType.AllFirends)
		end

	end
end

--buff
if modifier_cmd_beginner_4_buff == nil then
	modifier_cmd_beginner_4_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_beginner_4_buff:IsHidden()
	return false
end
function modifier_cmd_beginner_4_buff:IsPurgable()
	return true
end
function modifier_cmd_beginner_4_buff:IsPurgeException()
	return true
end
function modifier_cmd_beginner_4_buff:OnCreated(params)
	self:OnRefresh(params)
	if IsServer() then
	else
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iParticleID = ParticleManager:CreateParticle('particles/units/commander/cmd_beginner/cmd_beginner_2.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iParticleID, false, false, -1, false, false)
			return iParticleID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_cmd_beginner_4_buff:OnRefresh(params)
	self.attack_pct = self:GetAbilitySpecialValueFor('attack_pct')
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_cmd_beginner_4_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_cmd_beginner_4_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_cmd_beginner_4_buff:GetPhysicalAttackBonusPercentage()
	return self:GetStackCount() * self.attack_pct
end
function modifier_cmd_beginner_4_buff:GetMagicalAttackBonusPercentage()
	return self:GetStackCount() * self.attack_pct
end
function modifier_cmd_beginner_4_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_cmd_beginner_4_buff:OnTooltip()
	return self:GetPhysicalAttackBonusPercentage()
end
function modifier_cmd_beginner_4_buff:OnTooltip2()
	return self:GetMagicalAttackBonusPercentage()
end