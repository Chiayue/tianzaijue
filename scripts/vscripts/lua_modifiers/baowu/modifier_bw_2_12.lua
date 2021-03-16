
modifier_bw_2_12 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_12:GetTexture()
	return "item_treasure/魔龙枪"
end
--------------------------------------------------------------------------------
function modifier_bw_2_12:IsHidden()
	return true
end
function modifier_bw_2_12:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_12:OnRefresh()
	
end


function modifier_bw_2_12:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end
function modifier_bw_2_12:GetModifierBonusStats_Strength( params )
	if IsServer() then
		return 550
	end
	
end
function modifier_bw_2_12:GetModifierBonusStats_Agility( params )
	if IsServer() then

		return  550
	end
	
end
function modifier_bw_2_12:GetModifierAttackRangeBonus( params )
	if IsServer() then
		if self:GetParent():GetAttackCapability()==1 then
			return 0		
		end
	end
	return 200		--近战的显示不正确
	
end
function modifier_bw_2_12:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end