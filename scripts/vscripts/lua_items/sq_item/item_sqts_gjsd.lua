item_sqts_gjsd = class({})

function item_sqts_gjsd:GetTexture( params )
    return "item_sq_pd"
end
function item_sqts_gjsd:IsHidden()
	return true
	-- body
end
function item_sqts_gjsd:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

	}
	return funcs
end

function item_sqts_gjsd:GetModifierAttackSpeedBonus_Constant( params )
		return self:GetStackCount()

end
function item_sqts_gjsd:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


--------------------------------------------------------------------------------

function item_sqts_gjsd:IsDebuff()
	return false
end



function item_sqts_gjsd:OnCreated( kv )

		self:OnRefresh( )

end

----------------------------------------

function item_sqts_gjsd:OnRefresh()
		
	if IsServer() then
	
		local caster = self:GetParent()
		self.gjsd = caster.sq_ts.gjsd
		if not self.gjsd then
			self.gjsd = 0
		end
		self:SetStackCount(self.gjsd)
	end
	
end




-----------------------------------------------------------------------

