
modifier_bw_3_1 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_1:GetTexture()
	return "item_treasure/魔力箭袋"
end
--------------------------------------------------------------------------------
function modifier_bw_3_1:IsHidden()
	return true
end
function modifier_bw_3_1:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_1:OnRefresh()
	
end


function modifier_bw_3_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end
function modifier_bw_3_1:GetModifierAttackRangeBonus( params )
	
	return 200
end
function modifier_bw_3_1:GetModifierPreAttack_BonusDamage( params )
	return 7000
end

function modifier_bw_3_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end