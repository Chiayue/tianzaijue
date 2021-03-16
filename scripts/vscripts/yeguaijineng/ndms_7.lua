
ndms_gh7={
	"modifier_ndms_7_1";
	"modifier_ndms_7_2";
	"modifier_ndms_7_3";
	"modifier_ndms_7_4";
	"modifier_ndms_7_5";
	"modifier_ndms_7_6";
	"modifier_ndms_7_7";
	"modifier_ndms_7_8";
	"modifier_ndms_7_9";
	"modifier_ndms_7_10";
}




function ndms_7( keys )	
	local caster = keys.caster
	local ability = keys.ability
	for i=0,3 do
		local hero = PlayerUtil.GetHero(i)
		if hero then
			if hero:IsAlive() then
				local modifiername = ndms_gh7[RandomInt(1,#ndms_gh7)]
				local modifier = hero:FindModifierByName(modifiername)
				if modifier then
					local cs = modifier:GetStackCount() + 1 
					modifier:SetStackCount(cs)
				else
					local modifier = ability:ApplyDataDrivenModifier(caster,hero,modifiername,{})
					modifier:SetStackCount(1)
				end
			end
		end
	end
	


end


