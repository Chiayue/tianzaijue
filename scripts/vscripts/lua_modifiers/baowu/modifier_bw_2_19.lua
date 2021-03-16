
modifier_bw_2_19 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_19:GetTexture()
	return "item_treasure/加速护符"
end
--------------------------------------------------------------------------------
function modifier_bw_2_19:IsHidden()
	return true
end
function modifier_bw_2_19:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_19:OnRefresh()
	if IsServer() then
	-- Returns true if this is lua running from the server.dll.
	
		local attributes = {}
		attributes["lqsj"] = 10
			
		AttributesSet(self:GetParent(),attributes)
	end
end
function modifier_bw_2_19:OnDestroy()
	if IsServer() then
	-- Returns true if this is lua running from the server.dll.  
	
		local attributes = {}
		attributes["lqsj"] = -10
			
		AttributesSet(self:GetParent(),attributes)
	end
end

function modifier_bw_2_19:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_2_19:GetModifierConstantHealthRegen( params )
	return 2000
end
function modifier_bw_2_19:GetModifierPercentageCooldown( params )
	return  10
end
function modifier_bw_2_19:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end