
modifier_yxtfjn_lanmao_buff = class({})

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao_buff:IsHidden()
	return false
end

function modifier_yxtfjn_lanmao_buff:GetTexture()
	return "storm_spirit_ball_lightning"
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao_buff:OnCreated( kv )
   
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

--------------------------------------------------------------------------------


function modifier_yxtfjn_lanmao_buff:GetModifierSpellAmplify_Percentage( params )
	return self:GetStackCount()
end