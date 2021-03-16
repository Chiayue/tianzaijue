item_sqts_jnsh = class({})

function item_sqts_jnsh:GetTexture( params )
    return "item_sq_pd"
end
function item_sqts_jnsh:IsHidden()
	return true
	-- body
end
function item_sqts_jnsh:DeclareFunctions()
	local funcs = {
	
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

	}
	return funcs
end


function item_sqts_jnsh:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end

function item_sqts_jnsh:GetModifierSpellAmplify_Percentage( params )	--力量
		return self:GetStackCount()
end

--------------------------------------------------------------------------------

function item_sqts_jnsh:IsDebuff()
	return false
end



function item_sqts_jnsh:OnCreated( kv )

		self:OnRefresh( )

end

----------------------------------------

function item_sqts_jnsh:OnRefresh()
		
	if IsServer() then
	
		local caster = self:GetParent()
		self.jnsh = caster.sq_ts.jnsh
		if not self.jnsh then
			self.jnsh = 0
		end
		self:SetStackCount(self.jnsh)

	end
	
end




-----------------------------------------------------------------------

