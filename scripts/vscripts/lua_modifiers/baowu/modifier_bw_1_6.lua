
modifier_bw_1_6 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_6:GetTexture()
	return "item_treasure/空灵挂件"
end

function modifier_bw_1_6:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_6:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_6:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end
--------------------------------------------------------------------------------

function modifier_bw_1_6:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_1_6:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount()*200
end
function modifier_bw_1_6:GetModifierSpellAmplify_Percentage( params )
	return self:GetStackCount()*20
end
function modifier_bw_1_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

