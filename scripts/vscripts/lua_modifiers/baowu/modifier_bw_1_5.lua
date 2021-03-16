
modifier_bw_1_5 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_5:GetTexture()
	return "item_treasure/怨灵细带"
end

function modifier_bw_1_5:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_5:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_5:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end
--------------------------------------------------------------------------------

function modifier_bw_1_5:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_1_5:GetModifierBonusStats_Agility( params )
	return self:GetStackCount()*200
end
function modifier_bw_1_5:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount()*30
end
function modifier_bw_1_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

