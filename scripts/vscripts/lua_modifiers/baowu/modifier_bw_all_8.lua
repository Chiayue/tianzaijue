
modifier_bw_all_8 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_8:GetTexture()
	return "item_treasure/法术偏科"
end
--------------------------------------------------------------------------------
function modifier_bw_all_8:IsHidden()
	return true
end
function modifier_bw_all_8:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_8:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_8:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_bw_all_8:GetModifierAttackSpeedBonus_Constant( params )
	return -200*self:GetStackCount()
end

function modifier_bw_all_8:GetModifierSpellAmplify_Percentage( params )
	return 100*self:GetStackCount()
end

function modifier_bw_all_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end