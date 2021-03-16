---幻影斧
if nil == item_mantas then
	item_mantas = class({}, nil, base_ability_attribute)
end
function item_mantas:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_mantas then
	modifier_item_mantas = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_mantas:IsHidden()
	return true
end
function modifier_item_mantas:OnCreated(params)
	self:UpdateValues()
	self.tTable = {}
	if IsServer() then
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
end

function modifier_item_mantas:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_mantas:UpdateValues(params)
	self.time_for_illusion = self:GetAbilitySpecialValueFor("time_for_illusion")
	self.attribute_have_pct = self:GetAbilitySpecialValueFor('attribute_have_pct')
	self.time_duration = self:GetAbilitySpecialValueFor("time_duration")
	self.illusion_extra = self:GetAbilitySpecialValueFor("illusion_extra")
	self.illusion_count = self:GetAbilitySpecialValueFor("illusion_count")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")

end


function modifier_item_mantas:EDeclareFunctions()
	return {
		-- EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end

function modifier_item_mantas:OnInBattle(params)
	if IsValid(self:GetParent()) and IsValid(self:GetAbility()) then
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
end
function modifier_item_mantas:OnBattleEnd(params)
	if not IsValid(self:GetParent()) or not IsValid(self:GetAbility()) then return end
	-- self:StartIntervalThink(-1)
	if self.tTable then
		for _, hTarget in pairs(self.tTable) do
			if IsValid(hTarget) then
				hTarget:ForceKill(false)
				-- UTIL_Remove(hTarget)
			end
		end
	end
end
function modifier_item_mantas:OnIntervalThink()
	if self:GetParent():IsIllusion() or self:GetParent():IsClone() or self:GetParent():IsAlive() == false then return end
	if self:GetAbility():IsCooldownReady() and GSManager:getStateType() == GS_Battle then
		if self.tTable then
			for _, hTarget in pairs(self.tTable) do
				if IsValid(hTarget) then
					hTarget:ForceKill(false)
					-- UTIL_Remove(hTarget)
				end
			end
		end
		local iCount = self.illusion_count
		if self.unlock_level <= self:GetAbility():GetLevel() then
			iCount = iCount + self.illusion_extra
		end
		for i = 1, iCount do
			local hIllusion = CreateIllusion(self:GetParent(), self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber(), self.time_duration, self.attribute_have_pct, 100)
			hIllusion:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_building_ai", {})
			hIllusion:SetControllableByPlayer(-1, false)
			hIllusion:SetAcquisitionRange(3000)
			table.insert(self.tTable, hIllusion)
		end
		self:GetAbility():UseResources(false, false, true)
	end
end

-- function modifier_item_mantas:CheckState()
-- 	return {
-- 		[DOTA_UNIT_TARGET_HERO] = true,
-- 	}
-- end
-- 	[EMDF_EVENT_CUSTOM] = { ET_GAME.GAME_BEGIN, self.func, ?EVENT_LEVEL_NONE }
AbilityClassHook('item_mantas', getfenv(1), 'abilities/items/item_mantas.lua', { KeyValues.ItemsKv })