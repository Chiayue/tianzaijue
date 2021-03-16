
modifier_bw_1_4 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_4:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_bw_1_4:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_4:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_4:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end
--------------------------------------------------------------------------------

function modifier_bw_1_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_bw_1_4:GetModifierBonusStats_Strength( params )
	return self:GetStackCount()*200
end
function modifier_bw_1_4:GetModifierMagicalResistanceBonus( params )
	return self:GetStackCount()*20
end
function modifier_bw_1_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

