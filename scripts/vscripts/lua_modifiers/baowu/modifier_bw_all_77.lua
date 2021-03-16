
modifier_bw_all_77 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_77:GetTexture()
	return "item_treasure/贤者石"
end


function modifier_bw_all_77:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_77:OnCreated( kv )
	if IsServer() then
		local playerID = self:GetCaster():GetPlayerOwnerID()
		local s = playerID +1
		Stage["gj"..s] = Stage["gj"..s]  +1
		Stage["xl"..s] = Stage["xl"..s]  +1
		Stage["fy"..s] = Stage["fy"..s]  +1
		Stage["jq"..s] = Stage["jq"..s]  +1
		Stage["jy"..s] = Stage["jy"..s]  +1
	end
end
function modifier_bw_all_77:OnDestroy()
	if IsServer() then
		local playerID = self:GetCaster():GetPlayerOwnerID()
		local s = playerID +1
		Stage["gj"..s] = Stage["gj"..s]  -1
		Stage["xl"..s] = Stage["xl"..s]  -1
		Stage["fy"..s] = Stage["fy"..s]  -1
		Stage["jq"..s] = Stage["jq"..s]  -1
		Stage["jy"..s] = Stage["jy"..s]  -1
	end
end



function modifier_bw_all_77:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------

