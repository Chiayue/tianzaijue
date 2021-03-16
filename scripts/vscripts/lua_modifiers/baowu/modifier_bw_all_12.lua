
modifier_bw_all_12 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_12:GetTexture()
	return "item_treasure/宿敌克星"
end
--------------------------------------------------------------------------------
function modifier_bw_all_12:IsHidden()
	return true
end
function modifier_bw_all_12:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_12:OnRefresh()
	
end

function modifier_bw_all_12:OnDestroy()
	if IsServer() then
		self:GetCaster().targetzzsh=nil
		local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if player_info==nil then
			player_info={}
		end
		player_info.targetzzsh=nil
		CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)
	end
end
function modifier_bw_all_12:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
function modifier_bw_all_12:OnDeath( params )
	if IsServer() then
		if params.unit~= params.attacker and params.unit == self:GetCaster() then
			
			local targetzzsh={}
			targetzzsh.target=params.attacker:GetEntityIndex()
			targetzzsh.damage=50
			self:GetCaster().targetzzsh=targetzzsh
			local player_info=CustomNetTables:GetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()))
			if player_info==nil then
				player_info={}
			end
			player_info.targetzzsh=targetzzsh
			CustomNetTables:SetTableValue("damage_zzsh", "zzsh_"..tostring(self:GetCaster():GetPlayerOwnerID()), player_info)
			PrintTable(player_info)
		end
	end

	return 0
end
function modifier_bw_all_12:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end