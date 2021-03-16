
modifier_bw_all_25 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_25:GetTexture()
	return "item_treasure/强化施法"
end
--------------------------------------------------------------------------------
function modifier_bw_all_25:IsHidden()
	return true
end
function modifier_bw_all_25:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_25:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_25:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_all_25:GetModifierSpellAmplify_Percentage( params )
	return 40*self:GetStackCount()
end
function modifier_bw_all_25:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end