
modifers_item_set_14 = class({})


function modifers_item_set_14:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifers_item_set_14:GetModifierHealthBonus( params )	--智力
	
	return 50000
end
function modifers_item_set_14:GetModifierMagicalResistanceBonus( params )	--智力
	
	return 30
end
function modifers_item_set_14:GetModifierPhysicalArmorBonus( params )	--智力
	
	return 50
end


function modifers_item_set_14:GetModifierBonusStats_Agility( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==1	 then
			return self:GetStackCount()
		end
	end
	return 0
end
function modifers_item_set_14:GetModifierBonusStats_Strength( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==0	 then
			return self:GetStackCount()
		end
	end
	return 0
end
function modifers_item_set_14:GetModifierBonusStats_Intellect( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==2	 then
			return self:GetStackCount()
		end
	end
	return 0
end

function modifers_item_set_14:OnIntervalThink()
	if IsServer() then
		local hCaster=self:GetCaster()
		if hCaster ~= nil and hCaster:IsAlive() then
			local ftype=self:GetParent():GetPrimaryAttribute()
			if hCaster:GetHealthPercent()<=70 then
				if hCaster:GetHealthPercent()<=40 then
					if ftype==0	 then
						self:SetStackCount(math.ceil(self.str*0.6))
					end
					if ftype==1	 then
						self:SetStackCount(math.ceil(self.agi*0.6))
					end
			    	if ftype==2	 then
						self:SetStackCount(math.ceil(self.int*0.6))
					end	
				else
					if ftype==0	 then
						self:SetStackCount(math.ceil(self.str*0.5))
					end
					if ftype==1	 then
						self:SetStackCount(math.ceil(self.agi*0.5))
					end
			    	if ftype==2	 then
						self:SetStackCount(math.ceil(self.int*0.5))
					end	
				end
			else
				if ftype==0	 then
					self:SetStackCount(math.ceil(self.str*0.4))
				end
				if ftype==1	 then
					self:SetStackCount(math.ceil(self.agi*0.4))
				end
		    	if ftype==2	 then
					self:SetStackCount(math.ceil(self.int*0.4))
				end	
			end
			if self.count<=60 then
				self.count=self.count+1
			else
				hCaster:SetHealth(hCaster:GetHealth()-hCaster:GetMaxHealth()*0.02)
				self.count=1
			end
		end
	end
end
--------------------------------------------------------------------------------

function modifers_item_set_14:IsDebuff()
	return false
end

function modifers_item_set_14:GetTexture( params )
    return "tz/毒龙"
end
function modifers_item_set_14:IsHidden()
	return false
	-- body
end
function modifers_item_set_14:OnCreated( kv )
	self.agi=0
	self.str=0 
	self.int=0
	 if IsServer() then
 		self:StartIntervalThink( 1)
		self.count=1
		
		 if self:GetParent():GetPrimaryAttribute()==0	 then
			self.str=self:GetParent():GetBaseStrength()
			self:SetStackCount(math.ceil(self.str*0.4))
		end
		if self:GetParent():GetPrimaryAttribute()==1	 then
			self.agi=self:GetParent():GetBaseAgility()
			self:SetStackCount(math.ceil(self.agi*0.4))
		end
		if self:GetParent():GetPrimaryAttribute()==2	 then
			self.int=self:GetParent():GetBaseIntellect()
			self:SetStackCount(math.ceil(self.int*0.4))
		end	
 	end
end

function modifers_item_set_14:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
