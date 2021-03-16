
modifier_bw_all_76 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_76:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_76:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_76:OnCreated( kv )
	if IsServer() then
		local playerID = self:GetCaster():GetPlayerOwnerID()
		local s = playerID +1
		Stage["gj"..s] = Stage["gj"..s]  +0.5
		Stage["xl"..s] = Stage["xl"..s]  +0.5
		Stage["fy"..s] = Stage["fy"..s]  +0.5
		Stage["jq"..s] = Stage["jq"..s]  +0.5
		Stage["jy"..s] = Stage["jy"..s]  +0.5
	end
end


function modifier_bw_all_76:OnDestroy()
	if IsServer() then
		local playerID = self:GetCaster():GetPlayerOwnerID()
		local s = playerID +1
		Stage["gj"..s] = Stage["gj"..s]  -0.5
		Stage["xl"..s] = Stage["xl"..s]  -0.5
		Stage["fy"..s] = Stage["fy"..s]  -0.5
		Stage["jq"..s] = Stage["jq"..s]  -0.5
		Stage["jy"..s] = Stage["jy"..s]  -0.5
	end
end



function modifier_bw_all_76:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

