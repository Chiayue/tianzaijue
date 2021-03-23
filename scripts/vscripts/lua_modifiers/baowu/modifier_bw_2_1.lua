
modifier_bw_2_1 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_1:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_bw_2_1:IsHidden()
	return true
end

function modifier_bw_2_1:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/blademail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		
		
	end
	self:OnRefresh()
end
function modifier_bw_2_1:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
		
		
	end
end

function modifier_bw_2_1:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_bw_2_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end
function modifier_bw_2_1:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount()*30
end
function modifier_bw_2_1:OnTakeDamage( params )
	if IsServer() then
		
		local Attacker = params.attacker
		local target = params.unit
		local Ability = params.inflictor
		--local flDamage = params.damage
		local flDamage = params.original_damage --初始伤害
		if target == self:GetParent() and Attacker ~= self:GetParent() then --有自己给自己造成伤害的逻辑，这里要排除掉，否则会游戏崩溃
			if target:IsAlive() then
				local damageInfo =
				{
					victim = Attacker,
					attacker = target,
					damage = flDamage*0.2,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = nil,
				}
				ApplyDamage( damageInfo )
			end
		end
	end
--	return 0
end
function modifier_bw_2_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end