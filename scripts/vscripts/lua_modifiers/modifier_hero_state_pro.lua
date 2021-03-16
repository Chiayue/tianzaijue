
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
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_hero_state_pro:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end
	if IsServer() then
		self.bfbtsll=0
		self.bfbtsmj=0
		self.bfbtszl=0
		self.bfbtsqsx=0
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_hero_state_pro_int_per", {} )
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_hero_state_pro_str_per", {} )
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_hero_state_pro_agi_per", {} )
		self:StartIntervalThink( 3 )
	end

end

function modifier_hero_state_pro:OnIntervalThink()
	if IsServer() then
		local unit=self:GetParent()
		if not unit:IsRealHero() then   
			return nil
		end
		local ischange=false
		if self.bfbtsll~=unit.cas_table.bfbtsll then
			ischange=true
			self.bfbtsll=unit.cas_table.bfbtsll 
		end
		if self.bfbtsmj~=unit.cas_table.bfbtsmj then
			ischange=true
			self.bfbtsmj=unit.cas_table.bfbtsmj 
		end
		if self.bfbtszl~=unit.cas_table.bfbtszl then
			ischange=true
			self.bfbtszl=unit.cas_table.bfbtszl 
		end
		if self.bfbtsqsx~=unit.cas_table.bfbtsqsx then
			ischange=true
			self.bfbtsqsx=unit.cas_table.bfbtsqsx 
		end
		if ischange then
			unit:RemoveModifierByName("modifier_hero_state_pro_int_per")
			unit:RemoveModifierByName("modifier_hero_state_pro_str_per")
			unit:RemoveModifierByName("modifier_hero_state_pro_agi_per")
			local int=unit:GetBaseIntellect()
			local str=unit:GetBaseStrength()
			local agi=unit:GetBaseAgility()	
			if not self.bfbtsll then return nil end
			if not self.bfbtsmj then return nil end
			if not self.bfbtszl then return nil end
			if not self.bfbtsqsx then return nil end
			if self.bfbtsll>0 or self.bfbtsqsx >0 then
				local buff_str=unit:AddNewModifier( unit, self:GetAbility(), "modifier_hero_state_pro_str_per", {} )
				if buff_str then
					buff_str:SetStackCount(math.ceil(str*self.bfbtsll/100)+math.ceil(str*self.bfbtsqsx/100))
				end
			end
			if self.bfbtsmj>0 or self.bfbtsqsx >0 then
				local buff_agi=unit:AddNewModifier( unit, self:GetAbility(), "modifier_hero_state_pro_agi_per", {} )
				if buff_agi then
					buff_agi:SetStackCount(math.ceil(agi*self.bfbtsmj/100)+math.ceil(agi*self.bfbtsqsx/100))
				end
			end
			if self.bfbtszl>0  or self.bfbtsqsx >0 then
				local buff_int=unit:AddNewModifier( unit, self:GetAbility(), "modifier_hero_state_pro_int_per", {} )
				if buff_int then
					buff_int:SetStackCount(math.ceil(int*self.bfbtszl/100)+math.ceil(int*self.bfbtsqsx/100))
				end
			end
		
		end
		
		
	end
end
--------------------------------------------------------------------------------

function modifier_hero_state_pro:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end
function modifier_hero_state_pro:OnDeath( params )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return 1
		end

		--[[if params.unit ~= nil and params.attacker ~= nil and params.attacker == self:GetParent() then
			if self.sgzjzl~=0 and RollPercentage(5) then
				self:GetCaster():ModifyIntellect(self.sgzjzl)
			end
			if self.sgzjmj~=0 and RollPercentage(5) then
				self:GetCaster():ModifyAgility(self.sgzjmj)
			end
			if self.sgzjll~=0 and RollPercentage(5) then
				self:GetCaster():ModifyStrength(self.sgzjll)
			end
			if self.sgzjqsx~=0 and RollPercentage(5) then
				self:GetCaster():ModifyStrength(self.sgzjqsx)
				self:GetCaster():ModifyAgility(self.sgzjqsx)
				self:GetCaster():ModifyIntellect(self.sgzjqsx)
			end
			if self.sgzjsmz~=0 and RollPercentage(5) then
				if self:GetCaster():HasModifier("modifier_hero_state_pro_maxhealth") then
					local buff =self:GetCaster():FindModifierByName("modifier_hero_state_pro_maxhealth")
					buff:SetStackCount(buff:GetStackCount()+self.sgzjsmz)
				else
					self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_hero_state_pro_maxhealth", {} )
				end
				
			end
		end]]
	end
end
function modifier_hero_state_pro:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() and params.attacker ~= nil then
			--[[if RollPercentage(5)  then
				if self.gjzjll~=0 then
					self:GetCaster():ModifyStrength(self.gjzjll)
				end
				if self.gjzjmj~=0 then
					self:GetCaster():ModifyAgility(self.gjzjmj)
				end
				if self.gjzjzl~=0 then
					self:GetCaster():ModifyIntellect(self.gjzjzl)
				end
				if self.gjzjqsx~=0 then
					self:GetCaster():ModifyIntellect(self.gjzjqsx)
					self:GetCaster():ModifyAgility(self.gjzjqsx)
					self:GetCaster():ModifyStrength(self.gjzjqsx)
				end
				
			end]]
		end
	end

	return 1
end
--------------------------------------------------------------------------------
