
modifier_bw_2_27 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_2_27:GetTexture()
	return "item_treasure/影之灵龛"
end

function modifier_bw_2_27:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_2_27:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_2_27:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jyjc"] = netTable["jyjc"] +30
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_2_27:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jyjc"] = netTable["jyjc"] -30
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_2_27:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end