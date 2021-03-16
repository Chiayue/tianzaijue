
modifier_bw_all_96 = class({})
LinkLuaModifier( "modifier_bw_all_96_buff", "lua_modifiers/baowu/modifier_bw_all_96_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function modifier_bw_all_96:GetTexture()
	return "item_treasure/达贡之神力"
end

function modifier_bw_all_96:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_all_96:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 5 )
	end
end
function modifier_bw_all_96:OnRefresh()
	
end

--------------------------------------------------------------------------------




function modifier_bw_all_96:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			caster:AddNewModifier( caster, nil, "modifier_bw_all_96_buff", {duration = 3} )
			caster:SetModifierStackCount( "modifier_bw_all_96_buff",caster, 100+caster:GetLevel() )
		end
	end
end


function modifier_bw_all_96:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

