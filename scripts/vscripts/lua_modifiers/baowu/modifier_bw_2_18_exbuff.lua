
modifier_bw_2_18_exbuff = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_18_exbuff:GetTexture()
	return "item_treasure/无知小帽"
end
--------------------------------------------------------------------------------
function modifier_bw_2_18_exbuff:IsHidden()
	return true
end
function modifier_bw_2_18_exbuff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_18_exbuff:OnRefresh()
	if IsServer() then
		self:StartIntervalThink(1) 
		self:SetStackCount(math.ceil(self:GetParent():GetMaxMana()*0.8))
		
	end
end
function modifier_bw_2_18_exbuff:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(math.ceil(self:GetParent():GetMaxMana()*0.8))
	end
end

function modifier_bw_2_18_exbuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
	}
	return funcs
end
function modifier_bw_2_18_exbuff:GetModifierExtraHealthPercentage( params )
	if IsServer() then 
		return 100
	end
	return  0
end
function modifier_bw_2_18_exbuff:GetModifierExtraManaBonus( params )
	if IsServer() then 
		return self:GetStackCount()*(-1)
	end
	return  0
end
function modifier_bw_2_18_exbuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
