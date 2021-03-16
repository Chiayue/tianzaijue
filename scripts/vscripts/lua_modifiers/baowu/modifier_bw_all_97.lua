
modifier_bw_all_97 = class({})
LinkLuaModifier( "modifier_bw_all_97", "lua_modifiers/baowu/modifier_bw_all_97", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_97:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_all_97:IsHidden()
	return true
end
function modifier_bw_all_97:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_97:OnRefresh()
	
end


function modifier_bw_all_97:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end


function modifier_bw_all_97:OnDeath( params )
	if IsServer() then
		if self:GetParent() == params.unit then
			local caster = self:GetParent()
			local chance = math.ceil(caster:GetLevel()/10 + 9)
			if RollPercentage(chance) then
				self:GetCaster():AddItemByName("item_bw_1")	
			end
		end
	end
end

function modifier_bw_all_97:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end