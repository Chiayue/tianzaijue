
modifier_bw_5_4 = class({})
--------------------------------------------------------------------------------

function modifier_bw_5_4:GetTexture()
	return "item_treasure/达贡之神力"
end

function modifier_bw_5_4:IsHidden()
	return true
end

function modifier_bw_5_4:GetEffectName()
	return "particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf"
end
--------------------------------------------------------------------------------

function modifier_bw_5_4:OnCreated()
	if IsServer() then
		self:StartIntervalThink( 3 )
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["shjm"] = netTable["shjm"] +50
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_5_4:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["shjm"] = netTable["shjm"] -50
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_5_4:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_5_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end


function modifier_bw_5_4:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusExdd(caster,point,900)
			if not units then
				return nil
			end
			local damage = caster:GetMaxHealth() *3.5
			for k,unit in pairs(units) do
				ApplyDamageMf(caster,unit,nil,damage)
			end
		end
	end
end

function modifier_bw_5_4:GetModifierHealthBonus( params )
	return 100000
end
function modifier_bw_5_4:GetModifierPhysicalArmorBonus( params )
	return 200
end
function modifier_bw_5_4:GetModifierMagicalResistanceBonus( params )
	return 33
end
function modifier_bw_5_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

