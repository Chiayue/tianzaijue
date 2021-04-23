


modifiy_shopmall_tszc_10 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_10:GetTexture()
	return "rune/shopmall_tszc_10"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_10:IsHidden()
	return true
end
function modifiy_shopmall_tszc_10:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(60 )
	end
end

function modifiy_shopmall_tszc_10:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			local itemname = "item_bw_1"	
			self:GetCaster():AddItemByName(itemname)	
		end
	end
end



function modifiy_shopmall_tszc_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end