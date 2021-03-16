
modifier_bw_all_13 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_13:GetTexture()
	return "item_treasure/格斗箭术"
end
--------------------------------------------------------------------------------
function modifier_bw_all_13:IsHidden()
	return true
end
function modifier_bw_all_13:OnCreated( kv )
	
	self:OnRefresh()
end

function modifier_bw_all_13:OnDestroy()
	if IsServer() then
		self:GetCaster().range300zzsh=nil
	end
end
function modifier_bw_all_13:OnRefresh()
	if IsServer() then
			self:GetCaster().range300zzsh=20
			local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
			if player_info==nil then
				player_info={}
			end
			player_info.range300zzsh=20
			CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)
			PrintTable(player_info)
		
	end
end


function modifier_bw_all_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end