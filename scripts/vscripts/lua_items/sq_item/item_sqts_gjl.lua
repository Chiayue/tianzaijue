item_sqts_gjl = class({})

function item_sqts_gjl:GetTexture( params )
    return "item_sq_pd"
end
function item_sqts_gjl:IsHidden()
	return true
	-- body
end
function item_sqts_gjl:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function item_sqts_gjl:GetModifierBaseDamageOutgoing_Percentage( params )	--智力
		return self:GetStackCount()
end


--------------------------------------------------------------------------------

function item_sqts_gjl:IsDebuff()
	return false
end



function item_sqts_gjl:OnCreated( kv )

		self:OnRefresh( )

end

----------------------------------------

function item_sqts_gjl:OnRefresh()
		
	if IsServer() then
		local caster = self:GetParent()
		self.gjl =	 caster.sq_ts.gjl
		if not self.gjl then
			self.gjl = 0
		end
		self:SetStackCount(self.gjl)
	end
	
end

function item_sqts_gjl:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end



-----------------------------------------------------------------------

