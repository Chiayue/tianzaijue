LinkLuaModifier("modifier_sp_tax_buff", "abilities/spell/sp_tax.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_tax == nil then
	sp_tax = class({}, nil, sp_base)
end
function sp_tax:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_tax_buff", nil)
end
---------------------------------------------------------------------
if modifier_sp_tax_buff == nil then
	modifier_sp_tax_buff = class({}, nil, eom_modifier)
end
function modifier_sp_tax_buff:IsHidden()
	return true
end
function modifier_sp_tax_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_sp_tax_buff:OnCreated(params)
	self.tax_increase = self:GetAbilitySpecialValueFor("tax_increase")
	if IsServer() then
		self.bTax = false
		self:GetParent():Timer(0, function()
			HeroCardData:EachCard(GetPlayerID(self:GetParent()), function(hCard)
				HeroCardData:UpdateCard(hCard)
			end)
			HeroCardData:UpdateNetTables()
		end)
	end
end
function modifier_sp_tax_buff:Tax()
	if IsServer() then
		self.bTax = true
		HeroCardData:EachCard(GetPlayerID(self:GetParent()), function(hCard)
			HeroCardData:UpdateCard(hCard)
		end)
		HeroCardData:UpdateNetTables()
	end
end
function modifier_sp_tax_buff:OnDestroy()
	if IsServer() then
		local iPlayerID = GetPlayerID(self:GetParent())
		self:GetParent():Timer(0, function()
			HeroCardData:EachCard(iPlayerID, function(hCard)
				HeroCardData:UpdateCard(hCard)
			end)
			HeroCardData:UpdateNetTables()
		end)
	end
end
function modifier_sp_tax_buff:EDeclareFunctions()
	return {
		EMDF_TAX_PERCENTAGE,
		EMDF_EVENT_ON_PREPARATION,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_sp_tax_buff:OnBattleEnd()
	self:Tax()
end
function modifier_sp_tax_buff:OnPreparation()
	if self.bTax then
		self:Destroy()
	end
end
function modifier_sp_tax_buff:GetTaxPercentage()
	return self.tax_increase
end