yxtfjn_lianjin = class({})
LinkLuaModifier( "modifier_yxtfjn_lianjin","yxtf/modifier_yxtfjn_lianjin.lua", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function yxtfjn_lianjin:OnSpellStart()
	local hCaster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration") 
	EmitSoundOn( "Hero_Alchemist.ChemicalRage.Cast", hCaster )
    hCaster:AddNewModifier(hCaster, self, "modifier_yxtfjn_lianjin", {duration=duration})
end
