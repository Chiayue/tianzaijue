
modifier_bw_all_26 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_26:GetTexture()
	return "item_treasure/超远射"
end
--------------------------------------------------------------------------------
function modifier_bw_all_26:IsHidden()
	return true
end
function modifier_bw_all_26:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_26:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_26:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end
function modifier_bw_all_26:GetModifierAttackRangeBonus( params )
	return 200*self:GetStackCount()
end

function modifier_bw_all_26:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end