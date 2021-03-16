
modifier_bw_1_8 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_8:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_1_8:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_8:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
	self:OnRefresh()
end

function modifier_bw_1_8:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifier_bw_1_8:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end
function modifier_bw_1_8:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			local gold = self:GetStackCount()*200* (1+self:GetCaster().cas_table.jqjc/100)
		--	SendOverheadEventMessage( nil, 0, self:GetCaster(), gold, nil )
			PlayerUtil.ModifyGold(self:GetCaster(),gold)
		end
	end
end

function modifier_bw_1_8:GetBonusDayVision( params )
	return self:GetStackCount()*200
end
function modifier_bw_1_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

