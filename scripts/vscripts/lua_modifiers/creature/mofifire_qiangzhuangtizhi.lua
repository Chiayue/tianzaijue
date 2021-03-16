mofifire_qiangzhuangtizhi = class({})
--------------------------------------------------------------------------------

function mofifire_qiangzhuangtizhi:IsDebuff()
	return false
end
function mofifire_qiangzhuangtizhi:IsHidden()
	return true
end


function mofifire_qiangzhuangtizhi:OnCreated( kv )
    if IsServer() then
        
       
    end
    
end
function mofifire_qiangzhuangtizhi:OnDestroy()
	if IsServer() then
		
	end
end

function mofifire_qiangzhuangtizhi:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end

function mofifire_qiangzhuangtizhi:GetModifierExtraHealthPercentage( params )
    return 150
end