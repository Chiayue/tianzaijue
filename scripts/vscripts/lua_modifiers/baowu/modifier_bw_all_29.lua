
modifier_bw_all_29 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_29:GetTexture()
	return "item_treasure/先发制人"
end
--------------------------------------------------------------------------------
function modifier_bw_all_29:IsHidden()
	return true
end
function modifier_bw_all_29:OnCreated( kv )
	
	self:OnRefresh()
end
function modifier_bw_all_29:OnDestroy()
	if IsServer() then
		self:GetCaster().healthpercent70zzsh=nil
		local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if player_info==nil then
			player_info={}
		end
		player_info.healthpercent70zzsh=nil
		CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)
	end
end

function modifier_bw_all_29:OnRefresh()
	if IsServer() then
		local healthpercent70zzsh={}
		healthpercent70zzsh.healthpercent=70
		healthpercent70zzsh.damage=30
		self:GetCaster().healthpercent70zzsh=healthpercent70zzsh
		local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if player_info==nil then
			player_info={}
		end
		player_info.healthpercent70zzsh=healthpercent70zzsh
		CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)
		PrintTable(player_info)
	
	end
end


function modifier_bw_all_29:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end