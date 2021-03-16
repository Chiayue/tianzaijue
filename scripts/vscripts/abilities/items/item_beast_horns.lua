---猛兽犄角
LinkLuaModifier("modifier_beast_horns_magical_immune", "abilities/items/item_beast_horns.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_beast_horns then
	item_beast_horns = class({}, nil, base_ability_attribute)
end
function item_beast_horns:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_beast_horns then
	modifier_item_beast_horns = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_beast_horns:IsHidden()
	return true
end
function modifier_item_beast_horns:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_beast_horns:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_beast_horns:UpdateValues(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.time_duration = self:GetAbilitySpecialValueFor('time_duration')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	self.count = nil
end


function modifier_item_beast_horns:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_ROUND_CHANGE
	}
end
function modifier_item_beast_horns:OnDestroy()
	if IsServer() then
		if IsValid(self.hModifier) then
			self.hModifier:Destroy()
		end
	end
end


function modifier_item_beast_horns:OnTakeDamage(params)
	if self.unlock_level <= self:GetAbility():GetLevel() then
		if self.count == nil and self:GetParent():GetHealthPercent() <= self.health_pct then
			self.hModifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_beast_horns_magical_immune', { duration = self.time_duration })
			self.count = 1
		end
	end
end
function modifier_item_beast_horns:OnRoundChange(params)
	self.count = nil
end

if modifier_beast_horns_magical_immune == nil then
	modifier_beast_horns_magical_immune = class({}, nil, eom_modifier)
end
function modifier_beast_horns_magical_immune:OnCreated(params)
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/items_fx/black_king_bar_avatar.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iPtclID, false, false, -1, false, false)
			-- ParticleManager:SetParticleControl(iPtclID, 1, Vector(self.aoe_range, self.aoe_range, self.aoe_range))
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_beast_horns_magical_immune:IsDebuff()
	return false
end
function modifier_beast_horns_magical_immune:IsHidden()
	return false
end
function modifier_beast_horns_magical_immune:OnRefresh(params)
	if IsServer() then
		self.duration = params.duration
	end
end
function modifier_beast_horns_magical_immune:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_INCOMING_PERCENTAGE] = -1000
	}
end
AbilityClassHook('item_beast_horns', getfenv(1), 'abilities/items/item_beast_horns.lua', { KeyValues.ItemsKv })