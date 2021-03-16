
modifier_bw_1_9 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_9:GetTexture()
	return "item_treasure/金币宝藏"
end

function modifier_bw_1_9:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_9:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_9:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		local wave = Stage.wave
		if wave == 0 then
			wave = 1
		end
		local gold =30000* (0.75+wave/4) *(1+self:GetCaster().cas_table.jqjc/100)
		SendOverheadEventMessage( nil, 0, self:GetCaster(), gold, nil )
		PlayerUtil.ModifyGold(self:GetCaster(),gold)
	end
end




function modifier_bw_1_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end