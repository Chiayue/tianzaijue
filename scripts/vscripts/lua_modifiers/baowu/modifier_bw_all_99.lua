
modifier_bw_all_99 = class({})
LinkLuaModifier( "modifier_bw_all_99_buff", "lua_modifiers/baowu/modifier_bw_all_99_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_99:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_all_99:IsHidden()
	return true
end
function modifier_bw_all_99:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_99:OnRefresh()
	
end


function modifier_bw_all_99:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_bw_all_99:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local caster = self:GetParent()
			local hTarget = params.target
			if hTarget ~= nil and hTarget:IsAlive() then
				local modifier = hTarget:AddNewModifier( hTarget, self, "modifier_bw_all_99_buff", {duration=5} )
				modifier:SetStackCount(math.ceil(caster:GetLevel()/10))
			end
		end
	end
end
function modifier_bw_all_99:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end