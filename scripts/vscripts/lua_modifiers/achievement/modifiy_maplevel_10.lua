


modifiy_maplevel_10 = class({})

--------------------------------------------------------------------------------

function modifiy_maplevel_10:GetTexture()
	return "item_treasure/幽冥披巾"
end
--------------------------------------------------------------------------------
function modifiy_maplevel_10:IsHidden()
	return true
end
function modifiy_maplevel_10:OnCreated( kv )
	if IsServer(  ) then
		self:StartIntervalThink( 10 )
	end
end

function modifiy_maplevel_10:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			
		end
	end
end
function modifiy_maplevel_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end