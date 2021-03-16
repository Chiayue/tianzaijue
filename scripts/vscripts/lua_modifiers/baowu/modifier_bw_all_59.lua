
modifier_bw_all_59 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_59:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_59:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_59:OnCreated( kv )
	if IsServer() then
		if self:GetCaster() then
			local itemname = "item_bw_1"	
			for i=1,3 do
				self:GetCaster():AddItemByName(itemname)	
			end	
		end
	end
end



function modifier_bw_all_59:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

