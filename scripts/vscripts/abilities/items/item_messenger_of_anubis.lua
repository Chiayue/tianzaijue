LinkLuaModifier("modifier_suicide", "abilities/items/item_messenger_of_anubis.lua", LUA_MODIFIER_MOTION_NONE)
---阿努比斯的使者
if nil == item_messenger_of_anubis then
	item_messenger_of_anubis = class({}, nil, base_ability_attribute)
end
function item_messenger_of_anubis:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_messenger_of_anubis then
	modifier_item_messenger_of_anubis = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_messenger_of_anubis:IsHidden()
	return true
end
function modifier_item_messenger_of_anubis:OnCreated(params)
	self:UpdateValues()

end

function modifier_item_messenger_of_anubis:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_messenger_of_anubis:UpdateValues(params)
	self.illusion_count = self:GetAbilitySpecialValueFor("illusion_count")
	self.illusion_incoming_damage = self:GetAbilitySpecialValueFor('illusion_incoming_damage')
	self.duration_time = self:GetAbilitySpecialValueFor("duration_time")
	self.tTable = {}
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")

	if self:GetAbility():GetLevel() < self.unlock_level then
		self.illusion_outgoing_damage = self:GetAbilitySpecialValueFor("illusion_outgoing_damage")
	else
		self.illusion_outgoing_damage = self:GetAbilitySpecialValueFor("illusion_outgoing_damage2")
	end
end


function modifier_item_messenger_of_anubis:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END
	}
end

function modifier_item_messenger_of_anubis:OnDeath(params)
	if self:GetParent():IsIllusion() or self:GetStackCount() == 1 then return end
	if self:GetParent():IsClone() then return end
	if GSManager:getStateType() == GS_End then return end
	-- if self:GetParent():IsIllusion() and RollPercentage(100) and self.illusion_extra ~= 0 then
	-- 	for i = 0, 0 + self.illusion_extra do
	-- 		local hIllusion = CreateIllusion(self:GetParent(), self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber(), self.time_extra_duration, self.illusion_outgoing_damage, self.illusion_incoming_damage)
	-- 		hIllusion:Heal(self:GetParent():GetMaxHealth(),self:GetAbility())
	--	 end
	-- end
	-- if self:GetParent():IsIllusion() and self:GetStackCount() == 0 then return end
	for i = 1, self.illusion_count do
		local hIllusion = CreateIllusion(self:GetParent(), self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber(), self.duration_time, self.illusion_outgoing_damage, self.illusion_incoming_damage)
		hIllusion:SetControllableByPlayer(-1, false)
		hIllusion:Heal(self:GetParent():GetMaxHealth(), self:GetAbility())
		hIllusion:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_building_ai", {})
		hIllusion:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_suicide", {})
		hIllusion:SetControllableByPlayer(-1, false)
		hIllusion:SetAcquisitionRange(3000)

	end

end

function modifier_item_messenger_of_anubis:OnBattleEnd()
	if self.tTable then
		for _, iTargetIndex in pairs(self.tTable) do
			local hTarget = EntIndexToHScript(iTargetIndex)
			if IsValid(hTarget) then
				hTarget:ForceKill(true)
				UTIL_Remove(hTarget)
			end
		end
	end
end


---------------------------------------------------------------------
--Modifiers
if nil == modifier_suicide then
	modifier_suicide = class({}, nil, eom_modifier)
end

function modifier_suicide:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_suicide:OnBattleEnd()
	self:GetParent():ForceKill(true)
end


AbilityClassHook('item_messenger_of_anubis', getfenv(1), 'abilities/items/item_messenger_of_anubis.lua', { KeyValues.ItemsKv })