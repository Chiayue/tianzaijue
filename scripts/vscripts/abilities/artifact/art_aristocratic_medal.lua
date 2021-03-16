LinkLuaModifier( "modifier_art_aristocratic_medal", "abilities/artifact/art_aristocratic_medal.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if art_aristocratic_medal == nil then
	art_aristocratic_medal = class({}, nil, artifact_base)
end
function art_aristocratic_medal:GetIntrinsicModifierName()
	return "modifier_art_aristocratic_medal"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_aristocratic_medal == nil then
	modifier_art_aristocratic_medal = class({}, nil, eom_modifier)
end
function modifier_art_aristocratic_medal:OnCreated(params)
	self.tax_pct = self:GetAbilitySpecialValueFor("tax_pct")
	if IsServer() then
		HeroCardData:EachCard(GetPlayerID(self:GetParent()), function(hCard)
			HeroCardData:UpdateCard(hCard)
		end)
		HeroCardData:UpdateNetTables()
	end
end
function modifier_art_aristocratic_medal:OnRefresh(params)
	self.tax_pct = self:GetAbilitySpecialValueFor("tax_pct")
	if IsServer() then
		HeroCardData:EachCard(GetPlayerID(self:GetParent()), function(hCard)
			HeroCardData:UpdateCard(hCard)
		end)
		HeroCardData:UpdateNetTables()
	end
end
function modifier_art_aristocratic_medal:OnDestroy()
	if IsServer() then
		local iPlayerID = GetPlayerID(self:GetParent())
		self:GetParent():Timer(0, function ()
			HeroCardData:EachCard(iPlayerID, function(hCard)
				HeroCardData:UpdateCard(hCard)
			end)
			HeroCardData:UpdateNetTables()
		end)
	end
end
function modifier_art_aristocratic_medal:EDeclareFunctions()
	return {
		EMDF_TAX_PERCENTAGE
	}
end
function modifier_art_aristocratic_medal:GetTaxPercentage()
	return self.tax_pct
end