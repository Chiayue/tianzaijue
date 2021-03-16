
modifier_bw_all_71 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_71:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_71:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_71:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 75 )
	end
end

function modifier_bw_all_71:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			local level = math.ceil(self:GetCaster():GetLevel() / 30)
			if level > 6 then
				level = 6
			end
			local itemname = "item_xhp_wzts_"..level	
			self:GetCaster():AddItemByName(itemname)	
		end
	end
end


function modifier_bw_all_71:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

