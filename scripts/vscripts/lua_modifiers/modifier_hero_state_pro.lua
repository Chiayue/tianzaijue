
modifier_hero_state_pro = class({})

-----------------------------------------------------------------------------------------

function modifier_hero_state_pro:IsPurgable()
	return false
end
function modifier_hero_state_pro:IsHidden()
	return true
end
----------------------------------------

function modifier_hero_state_pro:OnCreated( kv )
	if IsServer() then
		self.bfbtsll=0
		self.bfbtsmj=0
		self.bfbtszl=0
		self.bfbtsqsx=0
		self.modifier_int = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_hero_state_pro_int_per", {} )
		self.modifier_str = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_hero_state_pro_str_per", {} )
		self.modifier_agi = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_hero_state_pro_agi_per", {} )
		self:StartIntervalThink(1.5)
	end
end

----------------------------------------

function modifier_hero_state_pro:OnIntervalThink()
	if IsServer() then
		local unit=self:GetParent()
		if not unit:IsRealHero() then   
			return nil
		end
		self.bfbtsll=unit.cas_table.bfbtsll or 0
		self.bfbtsmj=unit.cas_table.bfbtsmj or 0
		self.bfbtszl=unit.cas_table.bfbtszl or 0
		self.bfbtsqsx=unit.cas_table.bfbtsqsx or 0
		
		local int=unit:GetBaseIntellect()
		local str=unit:GetBaseStrength()
		local agi=unit:GetBaseAgility()
		
		local modifierStr = 0
		local modifierAgi = 0
		local modifierInt = 0
		
		if self.bfbtsll > 0 then
			modifierStr = math.ceil(str*self.bfbtsll/100)
		end
		if self.bfbtsmj > 0 then
			modifierAgi=math.ceil(agi*self.bfbtsmj/100)
		end
		if self.bfbtszl > 0 then
			modifierInt=math.ceil(int*self.bfbtszl/100)
		end
		if self.bfbtsqsx > 0 then
			modifierStr = modifierStr + math.ceil(str*self.bfbtsqsx/100)
			modifierAgi = modifierAgi + math.ceil(agi*self.bfbtsqsx/100)
			modifierInt = modifierInt + math.ceil(int*self.bfbtsqsx/100)
		end
		if str + modifierStr > 10000000 then  --力量超过1000万，血量超过21E会出现BUG
			modifierStr = 10000000 - str
		end
		self.modifier_str:SetStackCount(modifierStr)
		self.modifier_agi:SetStackCount(modifierAgi)
		self.modifier_int:SetStackCount(modifierInt)
		
		unit:CalculateStatBonus(true)
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
