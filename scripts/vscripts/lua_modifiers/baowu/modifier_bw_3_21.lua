
modifier_bw_3_21 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_3_21:GetTexture()
	return "item_treasure/炼金之手"
end

function modifier_bw_3_21:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_3_21:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_3_21:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] +200
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_3_21:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] -200
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_3_21:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end