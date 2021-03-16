


modifiy_shopmall_tszc_5 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_5:GetTexture()
	return "rune/shopmall_tszc_4"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_5:IsHidden()
	return true
end
function modifiy_shopmall_tszc_5:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 10 )
	end
end

function modifiy_shopmall_tszc_5:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			for i=0,4 do
				local ability = self:GetCaster():GetAbilityByIndex(i)
				if ability then
					ability:EndCooldown()
				end
			end
		end
	end
end



function modifiy_shopmall_tszc_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end