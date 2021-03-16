item_sqts_lqsj = class({})

function item_sqts_lqsj:GetTexture( params )
    return "item_sq_pd"
end
function item_sqts_lqsj:IsHidden()
	return true
	-- body
end
function item_sqts_lqsj:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end


function item_sqts_lqsj:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function item_sqts_lqsj:GetModifierPercentageCooldown( params )
		return self:GetStackCount()
end
--------------------------------------------------------------------------------

function item_sqts_lqsj:IsDebuff()
	return false
end



function item_sqts_lqsj:OnCreated( kv )

		self:OnRefresh( )

end

----------------------------------------

function item_sqts_lqsj:OnRefresh()
		
	if IsServer() then
	
		local caster = self:GetParent()

		self.lqsj = caster.sq_ts.lqsj
		if not self.lqsj then
			self.lqsj = 0
		end
		self:SetStackCount(self.lqsj)
	end
	
end




-----------------------------------------------------------------------

