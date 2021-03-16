
modifier_bw_2_25 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_2_25:GetTexture()
	return "item_treasure/迈达斯之手"
end

function modifier_bw_2_25:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_2_25:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_2_25:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] +80
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_2_25:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] -80
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_2_25:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end