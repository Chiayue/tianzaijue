
modifier_bw_2_11 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_11:GetTexture()
	return "item_treasure/先锋盾"
end
--------------------------------------------------------------------------------
function modifier_bw_2_11:IsHidden()
	return true
end
function modifier_bw_2_11:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_11:OnRefresh()
	
end


function modifier_bw_2_11:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
	return funcs
end
function modifier_bw_2_11:GetModifierConstantHealthRegen( params )
	return 2000
end
function modifier_bw_2_11:GetModifierHealthBonus( params )
	return  30000
end

function modifier_bw_2_11:GetModifierTotal_ConstantBlock( params )
	if IsServer() then
		if	params.inflictor==nil then
			if RollPercentage(50) then
				if params.ranged_attack then
				
					return 500
				else
				
					return 1000
				end	
			end	

		end
	end
	return 0
end
function modifier_bw_2_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end