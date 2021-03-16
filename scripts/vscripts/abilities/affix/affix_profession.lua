LinkLuaModifier("modifier_affix_profession", "abilities/affix/affix_profession.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if affix_profession == nil then
	affix_profession = class({})
end
function affix_profession:GetIntrinsicModifierName()
	return "modifier_affix_profession"
end
---------------------------------------------------------------------
--Modifiers
if modifier_affix_profession == nil then
	modifier_affix_profession = class({}, nil, eom_modifier)
end
function modifier_affix_profession:OnCreated(params)
	if IsServer() then
		EModifier:RegModifierKeyVal(EMDF_TAG_ABLT_LOCK_STATE, 'aaa', function(iPlayerID, sTagName, sAbltName)
			if iPlayerID == GetPlayerID(self:GetParent()) then
				if params.tag1 ~= "" and params.tag1 == sTagName then
					return 1
				elseif params.tag1 ~= "" and params.tag2 == sTagName then
					return 1
				end
			end
		end)
	end
end
function modifier_affix_profession:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_affix_profession:OnDestroy()
	if IsServer() then
	end
end
function modifier_affix_profession:DeclareFunctions()
	return {
	}
end