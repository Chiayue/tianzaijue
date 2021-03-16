-----------------------------------------------------------------
modifiy_shopmall_cmzc_4_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifiy_shopmall_cmzc_4_buff:IsHidden()
	return true
end

function modifiy_shopmall_cmzc_4_buff:GetTexture()
	return "rune/shopmall_cmzc_4"
end
--------------------------------------------------------------------------------
-- Modifier Effects


function modifiy_shopmall_cmzc_4_buff:OnCreated( kv )
	if IsServer() then
		local caster = self:GetParent() 
		if caster:GetPrimaryAttribute()==2 then
			self.cs =  math.ceil(caster:GetBaseIntellect() *0.8)
		elseif caster:GetPrimaryAttribute()==1 then
			self.cs =  math.ceil(caster:GetBaseAgility() *0.8)
		elseif caster:GetPrimaryAttribute()==0 then
			self.cs =  math.ceil(caster:GetBaseStrength() *0.8)
		end
		self:OnRefresh()
	end
end
function modifiy_shopmall_cmzc_4_buff:OnRefresh()
	if IsServer() then
		self:SetStackCount(self.cs)
	end
end
function modifiy_shopmall_cmzc_4_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifiy_shopmall_cmzc_4_buff:GetModifierBonusStats_Intellect( params )
	if IsServer() then	
		if self:GetParent():GetPrimaryAttribute()==2 then
			return self:GetStackCount()
		else
			return 0
		end
	end
end
function modifiy_shopmall_cmzc_4_buff:GetModifierBonusStats_Agility( params )
	if IsServer() then	
		if self:GetParent():GetPrimaryAttribute()==1 then
			return self:GetStackCount()
		else
			return 0
		end
	end
end
function modifiy_shopmall_cmzc_4_buff:GetModifierBonusStats_Strength( params )
	if IsServer() then	
		if self:GetParent():GetPrimaryAttribute()==0 then
			return self:GetStackCount()
		else
			return 0
		end
	end
end

function modifiy_shopmall_cmzc_4_buff:GetBonusDayVision( params )
	if IsServer() then	
		return self:GetStackCount()
	end
end

function modifiy_shopmall_cmzc_4_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

-----------