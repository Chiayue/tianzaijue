
modifier_bw_all_50 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_50:GetTexture()
	return "item_treasure/炼金石"
end

function modifier_bw_all_50:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_50:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_50:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["swfhsj"] = netTable["swfhsj"] -6
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_all_50:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["swfhsj"] = netTable["swfhsj"] +6
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_all_50:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end