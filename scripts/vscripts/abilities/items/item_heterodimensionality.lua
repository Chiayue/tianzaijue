---异次元之壁
---
LinkLuaModifier("modifier_heterodimensionality_buff", "abilities/items/item_heterodimensionality.lua", LUA_MODIFIER_MOTION_NONE)

if nil == item_heterodimensionality then
	item_heterodimensionality = class({}, nil, base_ability_attribute)
end
function item_heterodimensionality:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_heterodimensionality then
	modifier_item_heterodimensionality = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_heterodimensionality:OnCreated(params)
	self:UpdateValues()
	local hAbility = self:GetAbility()

	if IsServer() then

	end

end

function modifier_item_heterodimensionality:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_heterodimensionality:UpdateValues()
	self.range = self:GetAbilitySpecialValueFor('range')
	self.health_reduce_pct = self:GetAbilitySpecialValueFor('health_reduce_pct')
	self.health_self_pct = self:GetAbilitySpecialValueFor('health_self_pct')
	self.friend_range = self:GetAbilitySpecialValueFor('friend_range')
	self.health_recover_pct = self:GetAbilitySpecialValueFor('health_recover_pct')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
end
function modifier_item_heterodimensionality:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = { self:GetParent() }
	}
end
function modifier_item_heterodimensionality:OnAbilityExecuted(params)
	if self:GetParent():IsAlive() then
		local hCaster = self:GetParent()
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			if not hUnit:HasModifier("modifier_ghost_enemy") and not hUnit:IsBoss() then
				if not Spawner:IsGoldRound() then
					hUnit:AddNewModifier(hCaster, self:GetAbility(), 'modifier_heterodimensionality_buff', { duration = 2 })
				end

			end
		end
	end
	if IsServer() then

		local FlHealth = self:GetParent():GetMaxHealth() * 0.01 * self.health_self_pct
		if self:GetParent():GetHealth() <= FlHealth and self.health_recover_pct ~= 0 then
			if self:GetAbility():IsCooldownReady() then
				self:GetParent():Heal(self:GetParent():GetMaxHealth() * 0.01 * self.health_recover_pct, self:GetAbility())
				self:GetAbility():UseResources(false, false, true)
			end
		end
	end
end


function modifier_item_heterodimensionality:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
-- function modifier_heterodimensionality_buff:OnTooltip()
-- 	return self.health_per
-- end
function modifier_item_heterodimensionality:OnTooltip2()
	return self.health_recover_pct
end


-----------------------------------------------------------
if modifier_heterodimensionality_buff == nil then
	modifier_heterodimensionality_buff = class({}, nil, eom_modifier)
end
function modifier_heterodimensionality_buff:OnCreated(params)
	self.range = self:GetAbilitySpecialValueFor('range')
	self.health_reduce_pct = self:GetAbilitySpecialValueFor('health_reduce_pct')
	self.health_self_pct = self:GetAbilitySpecialValueFor('health_self_pct')
	self.friend_range = self:GetAbilitySpecialValueFor('friend_range')
	self.health_recover_pct = self:GetAbilitySpecialValueFor('health_recover_pct')
	self.damagefactor = self:GetAbilitySpecialValueFor('damagefactor')
	if IsServer() then

		local flDamage = self:GetParent():GetHealth()
		local iDamageMax = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack) + self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
		local tDamageInfo = {
			attacker = self:GetCaster(),
			victim = self:GetParent(),
			ability = self,
			damage = math.min(flDamage * 0.01 * self.health_reduce_pct, iDamageMax * self.damagefactor * 0.01),
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(tDamageInfo)
	end
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local hParent = self:GetParent()
			local iPtclID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iPtclID, 0, hParent:GetAbsOrigin() + Vector(0, 0, 1000))
			-- ParticleManager:SetParticleControlEnt(iPtclID, 0, hParent, PATTACH_POINT_FOLLOW, nil, hParent:GetAbsOrigin() + Vector(0,0,1000), true)
			ParticleManager:SetParticleControlEnt(iPtclID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
			self:AddParticle(iPtclID, true, false, -1, false, false)
			ParticleManager:ReleaseParticleIndex(iPtclID)
			return iPtclID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_heterodimensionality_buff:IsDebuff()
	return true
end
function modifier_heterodimensionality_buff:IsHidden()
	return false
end
function modifier_heterodimensionality_buff:OnRefresh(params)
	self.range = self:GetAbilitySpecialValueFor('range')
	self.health_reduce_pct = self:GetAbilitySpecialValueFor('health_reduce_pct')
	self.health_self_pct = self:GetAbilitySpecialValueFor('health_self_pct')
	self.friend_range = self:GetAbilitySpecialValueFor('friend_range')
	self.health_recover_pct = self:GetAbilitySpecialValueFor('health_recover_pct')
end
function modifier_heterodimensionality_buff:OnDestroy(params)
	if IsServer() then return end
end

-- function modifier_heterodimensionality_buff:EDeclareFunctions()
-- 	return {
-- 		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE
-- 	}
-- end
-- function modifier_heterodimensionality_buff:GetStatusHealthBonusPercentage()
-- 	return -100
-- end
-- function modifier_item_heterodimensionality:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOOLTIP2
-- 	}
-- end
-- function modifier_item_heterodimensionality:OnTooltip2()
-- 	return self.attack_speed_bonus * self:GetStackCount()
-- end
AbilityClassHook('item_heterodimensionality', getfenv(1), 'abilities/items/item_heterodimensionality.lua', { KeyValues.ItemsKv })