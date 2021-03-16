
modifier_bw_3_6 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_6:GetTexture()
	return "item_treasure/法术棱镜"
end
--------------------------------------------------------------------------------
function modifier_bw_3_6:IsHidden()
	return true
end
function modifier_bw_3_6:OnCreated( kv )
	self.value = 17
	self.mfhf = 5
	self:OnRefresh()
end


function modifier_bw_3_6:OnRefresh()
	if IsServer() then
		-- Returns true if this is lua running from the server.dll.
		
			local attributes = {}
			attributes["lqsj"] = self.value
				
			AttributesSet(self:GetParent(),attributes)
		end
end
function modifier_bw_3_6:OnDestroy()
	if IsServer() then
	-- Returns true if this is lua running from the server.dll.
	
		local attributes = {}
		attributes["lqsj"] = -self.value
			
		AttributesSet(self:GetParent(),attributes)
	end
end

function modifier_bw_3_6:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
function modifier_bw_3_6:GetModifierPercentageCooldown( params )
	return  self.value
end
function modifier_bw_3_6:GetModifierConstantManaRegen( params )
	return self.mfhf
end
function modifier_bw_3_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
