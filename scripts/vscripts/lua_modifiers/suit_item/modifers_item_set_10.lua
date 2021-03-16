
modifers_item_set_10 = class({})


function modifers_item_set_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifers_item_set_10:GetModifierBonusStats_Agility( params )	--智力
	
	return 500
end
function modifers_item_set_10:GetModifierBonusStats_Strength( params )	--智力
	
	return 500
end
function modifers_item_set_10:GetModifierBonusStats_Intellect( params )	--智力
	
	return 500
end

function modifers_item_set_10:OnIntervalThink()
	if IsServer() then
		local hCaster=self:GetCaster()
		if hCaster ~= nil and hCaster:IsAlive() then
			hCaster:AddNewModifier(hCaster,nil,"modifers_item_set_10_buff",{duration=5})
		end
	end
end
--------------------------------------------------------------------------------

function modifers_item_set_10:IsDebuff()
	return false
end

function modifers_item_set_10:GetTexture( params )
    return "tz/海王"
end
function modifers_item_set_10:IsHidden()
	return false
	-- body
end
function modifers_item_set_10:OnCreated( kv )
 
if IsServer() then
 		self:StartIntervalThink( 10)	
 	end
end

function modifers_item_set_10:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
