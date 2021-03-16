
modifier_bw_all_87 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_87:GetTexture()
	return "item_treasure/智慧石"
end

function modifier_bw_all_87:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_87:OnCreated( kv )
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_87:OnRefresh()
	if IsServer() then
		HeroLevelUp.heroability(self:GetCaster())
	end
end



function modifier_bw_all_87:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end