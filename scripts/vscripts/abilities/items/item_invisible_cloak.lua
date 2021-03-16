---隐身斗篷
LinkLuaModifier("modifier_item_invisible_cloak_buff", "abilities/items/item_invisible_cloak.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invisible_cloak_wearing_buff", "abilities/items/item_invisible_cloak.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invisible_cloak_friend_buff", "abilities/items/item_invisible_cloak.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_invisible_cloak then
	item_invisible_cloak = class({}, nil, base_ability_attribute)
end
function item_invisible_cloak:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_invisible_cloak then
	modifier_item_invisible_cloak = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_invisible_cloak:IsHidden()
	return true
end
function modifier_item_invisible_cloak:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_invisible_cloak:OnRefresh(params)
	self:UpdateValues()
end

function modifier_item_invisible_cloak:OnDestroy()
	if self:GetParent():HasModifier('modifier_item_invisible_cloak_buff') then
		self:GetParent():RemoveModifierByName('modifier_item_invisible_cloak_buff')
	end
end
function modifier_item_invisible_cloak:UpdateValues(params)
	-- self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	-- self.chance = self:GetAbilitySpecialValueFor('chance')
	-- self.range = self:GetAbilitySpecialValueFor('range')
	-- self.duration = self:GetAbilitySpecialValueFor('duration')
	-- self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_invisible_cloak:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = { self:GetParent() }
	}
end
function modifier_item_invisible_cloak:OnInBattle()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_item_invisible_cloak_buff', {})
end
function modifier_item_invisible_cloak:OnBattleEnd()
	if self:GetParent():HasModifier("modifier_item_invisible_cloak_buff") then
		self:GetParent():RemoveModifierByName('modifier_item_invisible_cloak_buff')
	end
end

--------------------------------------------
---隐身
if modifier_item_invisible_cloak_buff == nil then
	modifier_item_invisible_cloak_buff = class({}, nil, BaseModifier)
end

function modifier_item_invisible_cloak_buff:IsHidden()
	return false
end

function modifier_item_invisible_cloak_buff:OnRefresh(params)
	-- self:UpdateValues()
end

function modifier_item_invisible_cloak_buff:OnCreated(params)
	-- self:UpdateValues()
	local iPtclID = ParticleManager:CreateParticle('particles/generic_hero_status/status_invisibility_start.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(iPtclID, false, false, -1, false, false)
	if IsServer() then
		self:StartIntervalThink(2)
	end
end

function modifier_item_invisible_cloak_buff:OnIntervalThink()
	if IsServer() then
		local bOn = 0
		EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
			if hUnit:IsAlive() then
				bOn = bOn + 1
			end
		end, UnitType.Building)
		if bOn == 1 then
			self:Destroy()
		end
	end
end

function modifier_item_invisible_cloak_buff:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}
end

function modifier_item_invisible_cloak_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end
function modifier_item_invisible_cloak_buff:GetModifierInvisibilityLevel(params)
	return 1
end


--------------------------
-- -自我特效
if modifier_invisible_cloak_wearing_buff == nil then
	modifier_invisible_cloak_wearing_buff = class({}, nil, eom_modifier)
end

function modifier_invisible_cloak_wearing_buff:IsHidden()
	return true
end
function modifier_invisible_cloak_wearing_buff:OnCreated(params)
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			-- ParticleManager:SetParticleControlEnt(particleID, 0, self:GetParent():GetAbsOrigin())
			self:AddParticle(particleID, false, false, -1, false, false)
			return particleID
		end, PARTICLE_DETAIL_MEDIUM_MEDIUM)
	end
end


AbilityClassHook('item_invisible_cloak', getfenv(1), 'abilities/items/item_invisible_cloak.lua', { KeyValues.ItemsKv })