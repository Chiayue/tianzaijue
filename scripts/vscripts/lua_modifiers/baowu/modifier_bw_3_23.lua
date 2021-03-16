
modifier_bw_3_23 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_3_23:GetTexture()
	return "item_treasure/魂之灵龛"
end

function modifier_bw_3_23:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_3_23:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_3_23:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jyjc"] = netTable["jyjc"] +50
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_3_23:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jyjc"] = netTable["jyjc"] -50
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_3_23:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end