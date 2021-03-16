
modifier_bw_3_18 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_18:GetTexture()
	return "item_treasure/玲珑心"
end

function modifier_bw_3_18:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_3_18:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_3_18:OnRefresh()
	if IsServer() then
		-- Returns true if this is lua running from the server.dll.
		
			local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
			if not self:GetParent().cas_table then
				self:GetParent().cas_table = {}
			end
			local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
			netTable["fsxx"] = netTable["fsxx"] +10
			SetNetTableValue("UnitAttributes",unitKey,netTable)
		end
end
function modifier_bw_3_18:OnDestroy()
	if IsServer() then
	-- Returns true if this is lua running from the server.dll.
	
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["fsxx"] = netTable["fsxx"] -10
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
--------------------------------------------------------------------------------

function modifier_bw_3_18:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,

	}
	return funcs
end
function modifier_bw_3_18:GetModifierConstantManaRegen( params )
	return 10
end
function modifier_bw_3_18:GetModifierManaBonus( params )
	return 600
end
function modifier_bw_3_18:GetModifierHealthBonus( params )
	return 30000
end




function modifier_bw_3_18:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

