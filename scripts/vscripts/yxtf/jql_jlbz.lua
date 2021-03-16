function jlbz( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	local level = ability:GetLevel() - 1
	local time = ability:GetLevelSpecialValueFor("time",level)  
	for i=1,time do
		point = FindRandomPoint(point,500)
		if RollPercentage(80) then
			CreateItemOnGround("item_xhp_xjb",nil,point,500)
		else
			CreateItemOnGround("item_xhp_nljs",nil,point,500)
		end
	end
	

end