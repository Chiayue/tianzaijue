
modifier_bw_all_60 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_60:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_60:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_60:OnCreated( kv )
	if IsServer() then
		if self:GetCaster() then
			local itemname = "item_bw_1"	
			for i=1,5 do
				self:GetCaster():AddItemByName(itemname)	
			end	
		end
	end
end



function modifier_bw_all_60:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

