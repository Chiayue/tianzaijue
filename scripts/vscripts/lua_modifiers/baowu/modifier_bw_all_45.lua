
modifier_bw_all_45 = class({})
LinkLuaModifier( "modifier_bw_all_45_buff", "lua_modifiers/baowu/modifier_bw_all_45_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_45:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_all_45:IsHidden()
	return true
end
function modifier_bw_all_45:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_45:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["swfhsj"] = netTable["swfhsj"] +7
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_all_45:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["swfhsj"] = netTable["swfhsj"] -7
		SetNetTableValue("UnitAttributes",unitKey,netTable)
		self:GetParent():RemoveModifierByName( "modifier_bw_all_45_buff" )
	end
end


function modifier_bw_all_45:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end


function modifier_bw_all_45:OnDeath( params )
	if IsServer() then
		if self:GetParent() ~= params.unit and params.attacker:GetPlayerOwnerID() == self:GetParent():GetPlayerOwnerID() then
			local caster = self:GetParent()
			if caster:HasModifier("modifier_bw_all_45_buff") then	
				local level = caster:GetLevel()/6
				local cs = math.ceil(caster:GetModifierStackCount("modifier_bw_all_45_buff",caster)+level)
				caster:SetModifierStackCount( "modifier_bw_all_45_buff",caster, cs )
			else
				local level = math.ceil(caster:GetLevel()/6)
				caster:AddNewModifier( caster, caster, "modifier_bw_all_45_buff", {} )
				caster:SetModifierStackCount( "modifier_bw_all_45_buff",caster, level )
			end
		end
	end
end

function modifier_bw_all_45:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end