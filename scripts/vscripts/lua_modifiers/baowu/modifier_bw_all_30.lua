
modifier_bw_all_30 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_30:GetTexture()
	return "item_treasure/强人所难"
end
--------------------------------------------------------------------------------
function modifier_bw_all_30:IsHidden()
	return true
end
function modifier_bw_all_30:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_30:OnDestroy()
	if IsServer() then
		self:GetCaster().healthpercent25zzsh=nil
		local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if player_info==nil then
			player_info={}
		end
		player_info.healthpercent25zzsh=nil
		CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)
	end
end

function modifier_bw_all_30:OnRefresh()
	if IsServer() then
		local healthpercent25zzsh={}
		healthpercent25zzsh.healthpercent=25
		healthpercent25zzsh.damage=30
		self:GetCaster().healthpercent25zzsh=healthpercent25zzsh
		local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if player_info==nil then
			player_info={}
		end
		player_info.healthpercent25zzsh=healthpercent25zzsh
		CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)
		
	
	end
end

function modifier_bw_all_30:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end