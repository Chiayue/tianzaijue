
modifier_bw_all_72 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_72:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_72:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_72:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 90 )
	end
end

function modifier_bw_all_72:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			local level = math.ceil(self:GetCaster():GetLevel() / 30) +1
			if level > 7 then
				level = 7
			end
			local playerID = self:GetCaster():GetPlayerOwnerID()
			itemgive(playerID,3,1)
		end
	end
end


function modifier_bw_all_72:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

