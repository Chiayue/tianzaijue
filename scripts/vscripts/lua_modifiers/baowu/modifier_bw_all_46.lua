
modifier_bw_all_46 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_46:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_46:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_46:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 60 )
	end
end

function modifier_bw_all_46:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() then
			local level = self:GetCaster():GetLevel()
			local wave = Stage.wave
			if not wave or wave ==0 then
				wave = 1
			end
			local gold = math.ceil( level * level * wave *(1+self:GetCaster().cas_table.jqjc/100))
			SendOverheadEventMessage( nil, 0, self:GetCaster(), gold, nil )
			PlayerUtil.ModifyGold(self:GetCaster(),gold)
		end
	end
end


function modifier_bw_all_46:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

