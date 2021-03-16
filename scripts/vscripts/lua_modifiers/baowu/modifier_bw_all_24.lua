
modifier_bw_all_24 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_24:GetTexture()
	return "item_treasure/提高灵巧"
end
--------------------------------------------------------------------------------
function modifier_bw_all_24:IsHidden()
	return true
end
function modifier_bw_all_24:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_24:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_24:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_all_24:GetModifierMoveSpeedBonus_Constant( params )
	return 10*self:GetStackCount()
end
function modifier_bw_all_24:GetModifierAttackSpeedBonus_Constant( params )
	return 30*self:GetStackCount()
end

function modifier_bw_all_24:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end