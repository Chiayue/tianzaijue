---弯月刀
LinkLuaModifier("modifier_item_crescent_sword_buff", "abilities/items/item_crescent_sword.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_crescent_sword then
	item_crescent_sword = class({}, nil, base_ability_attribute)
end
function item_crescent_sword:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_crescent_sword then
	modifier_item_crescent_sword = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_crescent_sword:IsHidden()
	return false
end
function modifier_item_crescent_sword:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_crescent_sword:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_crescent_sword:UpdateValues(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor('crit_damage_pct')
	self.push_distance = self:GetAbilitySpecialValueFor('push_distance')
	self.invi_duration = self:GetAbilitySpecialValueFor('invi_duration')
	self.knockback_duration = self:GetAbilitySpecialValueFor('knockback_duration')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end


function modifier_item_crescent_sword:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		-- --检测的是别人死亡
		-- 	[MODIFIER_EVENT_ON_DEATH] = {self:GetParent()},
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = { self:GetParent() }
	}
end
function modifier_item_crescent_sword:GetAttackCritBonus()
	return self.crit_damage_pct, self.crit_chance
end

function modifier_item_crescent_sword:OnTakeDamage(params)
	local tAtkInfo = GetAttackInfoByDamageRecord(params.record, self:GetParent())
	if not tAtkInfo
	or self:GetParent() ~= params.attacker
	or IsAttackMiss(tAtkInfo)
	or not IsAttackCrit(tAtkInfo)
	then return end
	
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		local vCenter = hParent:GetAbsOrigin()
		if IsValid(tAtkInfo.target) and not tAtkInfo.target:FindModifierByName('modifier_knockback') then
			-- GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), vPos)
			hParent:KnockBack(vCenter, tAtkInfo.target, self.push_distance, 0, self.knockback_duration, false)
		end
		if self.unlock_level <= self:GetAbility():GetLevel() then
			hParent:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_crescent_sword_buff", { duration = self.invi_duration })
		end
	end
end
------------------------------------------------------------
---隐身
if modifier_item_crescent_sword_buff == nil then
	modifier_item_crescent_sword_buff = class({}, nil, BaseModifier)
end

function modifier_item_crescent_sword_buff:IsHidden()
	return true
end
function modifier_item_crescent_sword_buff:OnCreated(params)
	local iPtclID = ParticleManager:CreateParticle('particles/generic_hero_status/status_invisibility_start.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(iPtclID, false, false, -1, false, false)
	if IsClient() then
	end
end
function modifier_item_crescent_sword_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end
function modifier_item_crescent_sword_buff:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}
end

function modifier_item_crescent_sword_buff:GetModifierInvisibilityLevel(params)
	return 1
end




AbilityClassHook('item_crescent_sword', getfenv(1), 'abilities/items/item_crescent_sword.lua', { KeyValues.ItemsKv })