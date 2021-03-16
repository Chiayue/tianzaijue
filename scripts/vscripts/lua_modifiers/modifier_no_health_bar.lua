if modifier_no_health_bar == nil then
	modifier_no_health_bar = class({})
	
	local m = modifier_no_health_bar;
	
	
	function m:IsHidden()
		return true
	end
	
	function m:GetAttributes()
		return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT;
	end
	
	function m:CheckState()
		local state = {
			[MODIFIER_STATE_NO_HEALTH_BAR] = true
		}
		return state
	end
end

