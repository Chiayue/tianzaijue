
modifier_bw_1_10 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_10:GetTexture()
	return "item_treasure/经验宝藏"
end

function modifier_bw_1_10:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_10:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_10:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		local wave = Stage.wave
		if wave == 0 then
			wave = 1
		end
		local exp =100000* (0.75+wave/4)  * (1+self:GetCaster().cas_table.jyjc/100)
		SendOverheadEventMessage( nil, 3, self:GetCaster(), exp, nil )
		self:GetCaster():AddExperience(exp,DOTA_ModifyXP_Unspecified,  false, false)
	end
end



function modifier_bw_1_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
