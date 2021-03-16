
modifier_bw_all_57 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_57:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_57:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_57:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 120 )
	end
end

function modifier_bw_all_57:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			local itemname = "item_bw_1"	
			self:GetCaster():AddItemByName(itemname)	
		end
	end
end


function modifier_bw_all_57:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

