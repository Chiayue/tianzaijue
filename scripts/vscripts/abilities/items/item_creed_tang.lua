---唐僧的信条
LinkLuaModifier("modifier_creed_tang_wearing_buff", "abilities/items/item_creed_tang.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creed_tang_buff", "abilities/items/item_creed_tang.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_creed_tang then
	item_creed_tang = class({}, nil, base_ability_attribute)
end
function item_creed_tang:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_creed_tang then
	modifier_item_creed_tang = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_creed_tang:IsHidden()
	return true
end
function modifier_item_creed_tang:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_creed_tang:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_creed_tang:UpdateValues(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.disarm_duration = self:GetAbilitySpecialValueFor('disarm_duration')
	self.armor_reducec_pct = self:GetAbilitySpecialValueFor('armor_reducec_pct')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end

function modifier_item_creed_tang:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = { self:GetParent() }
	}
end
function modifier_item_creed_tang:OnDestroy()
	if IsServer() then
		if IsValid(self.hModifier) then
			self.hModifier:Destroy()
		end
	end
end


function modifier_item_creed_tang:OnAbilityExecuted(params)
	if self:GetParent():IsAlive() and RollPercentage(self.chance) then
		local hCaster = self:GetParent()

		local tTargets = Spawner:FindMissingInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		GetPlayerID(self:GetParent()),
		false
		)
		--给佩戴者带个特效
		hCaster:AddNewModifier(hCaster, self:GetAbility(), 'modifier_creed_tang_wearing_buff', { duration = self.disarm_duration })
		for _, hUnit in pairs(tTargets) do
			if not hUnit:HasModifier("modifier_ghost_enemy") then
				hUnit:AddNewModifier(hCaster, self:GetAbility(), 'modifier_creed_tang_buff', { duration = self.disarm_duration })
			end
		end
	end
end

---------
if modifier_creed_tang_buff == nil then
	modifier_creed_tang_buff = class({}, nil, eom_modifier)
end

function modifier_creed_tang_buff:IsDebuff()
	return false
end
function modifier_creed_tang_buff:IsHidden()
	return false
end
function modifier_creed_tang_buff:OnRefresh(params)
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor('armor_reducec_pct')
end
function modifier_creed_tang_buff:OnCreated(params)
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor('armor_reducec_pct')
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_stunned.vpcf', PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(iPtclID, 0, self:GetParent():GetAbsOrigin())
			self:AddParticle(iPtclID, false, false, -1, false, false)
			return iPtclID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_creed_tang_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = -self.attack_reduce_pct,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = -self.attack_reduce_pct
	}
end
function modifier_creed_tang_buff:CheckState()
	return {
		-- [MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	-- [MODIFIER_STATE_CANNOT_TARGET_ENEMIES] = true,
	}
end
-- function modifier_creed_tang_buff:GetPhysicalAttackBonusPercentage()
-- 	return -self.attack_reduce_pct
-- end
-- function modifier_creed_tang_buff:GetMagicalAttackBonusPercentage()
-- 	return -self.attack_reduce_pct
-- end
---------
if modifier_creed_tang_wearing_buff == nil then
	modifier_creed_tang_wearing_buff = class({}, nil, ParticleModifier)
end
function modifier_creed_tang_wearing_buff:OnCreated(params)
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_dazzle/dazzle_weave_circle_traceb.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iPtclID, false, false, -1, false, false)
			-- ParticleManager:SetParticleControl(iPtclID, 1, Vector(self.aoe_range, self.aoe_range, self.aoe_range)
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	else
	end

end
-- function modifier_creed_tang_wearing_buff:CheckState()
-- 	return
-- 	{
-- 		[MODIFIER_STATE_ROOTED] = true,
-- 		[MODIFIER_STATE_DISARMED] = true,
-- 		[MODIFIER_STATE_CANNOT_TARGET_ENEMIES] = true,
-- 	}
-- end
AbilityClassHook('item_creed_tang', getfenv(1), 'abilities/items/item_creed_tang.lua', { KeyValues.ItemsKv })