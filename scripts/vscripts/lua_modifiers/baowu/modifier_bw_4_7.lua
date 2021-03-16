
modifier_bw_4_7 = class({})

--------------------------------------------------------------------------------

function modifier_bw_4_7:GetTexture()
	return "item_treasure/疯狂的海盗帽"
end
--------------------------------------------------------------------------------
function modifier_bw_4_7:IsHidden()
	return true
end
function modifier_bw_4_7:OnCreated( kv )
	self:OnRefresh()
end


function modifier_bw_4_7:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jqjc"] = netTable["jqjc"] +100
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_4_7:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jqjc"] = netTable["jqjc"] -100
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_4_7:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_4_7:GetModifierAttackSpeedBonus_Constant( params )
	return 300
end
function modifier_bw_4_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end