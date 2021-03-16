
modifier_bw_all_14 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_14:GetTexture()
	return "item_treasure/狙击手"
end
--------------------------------------------------------------------------------
function modifier_bw_all_14:IsHidden()
	return true
end
function modifier_bw_all_14:OnCreated( kv )
	
	self:OnRefresh()
end

function modifier_bw_all_14:OnDestroy()
	if IsServer() then
		self:GetCaster().range900zzsh=nil
	end
end
function modifier_bw_all_14:OnRefresh()
	if IsServer() then
		self:GetCaster().range900zzsh=30
		local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if player_info==nil then
			player_info={}
		end
		player_info.range900zzsh=30
		CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)

	
	end
end


function modifier_bw_all_14:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end