require( "event.Itembaolv" )
modifier_item_net_aaaa = class({})
function modifier_item_net_aaaa:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
--		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		
	}
	return funcs
end

function modifier_item_net_aaaa:GetModifierExtraHealthPercentage( params )	--智力
	--if IsServer() then
	--	local maxHealth = self:GetCaster():GetMaxHealth()
	--	print("maxHealth",maxHealth)
	--end
	local smts = math.ceil(self.attributes.bfbtssm)
	local smjc = (smts+100) /100 
	if self:GetCaster():GetMaxHealth() * smjc > 700000000 then
		smts = math.floor(smts * ( 700000000/self:GetCaster():GetMaxHealth()/ smjc))
	end
	return smts
end


function modifier_item_net_aaaa:GetModifierBaseDamageOutgoing_Percentage( params )	--智力
	return math.ceil(self.attributes.damage_bfb)
end

function modifier_item_net_aaaa:GetModifierAttackSpeedBonus_Constant( params )
	return math.ceil(self.attributes.attack_speed)
end

function modifier_item_net_aaaa:GetModifierSpellAmplify_Percentage( params )	--力量
	return math.ceil(self.attributes.jnsh)
end
function modifier_item_net_aaaa:GetModifierPercentageCooldown( params )
	local sb = math.ceil(self.attributes.lqsj)
	if sb > 50 then
	   sb = math.floor(math.sqrt(sb -50) +50)
	   if sb > 75 then
	   	  sb = math.floor(math.sqrt(math.sqrt(sb -75))+75)
	   end
	end
	return sb
end

function modifier_item_net_aaaa:GetModifierEvasion_Constant( params )	--智力
	local sb = math.ceil(self.attributes.sb)
	if sb > 60 then
	   sb = math.sqrt(sb -60) +60
	   if sb > 90 then
	   	  sb = math.sqrt(math.sqrt(sb -90))+90
	   end
	end
	return sb
end
function modifier_item_net_aaaa:GetModifierHealthRegenPercentage( params )	--智力
	return math.ceil(self.attributes.smzhfbfb)
end
function modifier_item_net_aaaa:GetModifierPhysicalArmorBonus( params )	--智力
	return math.ceil(self.attributes.hj)
end
function modifier_item_net_aaaa:GetModifierConstantHealthRegen( params )	--智力
	return math.ceil(self.attributes.smhf)
end
function modifier_item_net_aaaa:GetModifierMoveSpeedBonus_Constant( params )	--智力
	return math.ceil(self.attributes.ydsd)
end

function modifier_item_net_aaaa:GetModifierMagicalResistanceBonus( params )	--智力
	local sb = math.ceil(self.attributes.mfkx)
	if sb > 90 then
	   sb = math.sqrt(sb -90) +90
	   if sb > 95 then
	   	  sb = math.sqrt(math.sqrt(sb -95))+95
	   end
	end
	--print("mfkx",sb)
	return sb
end
function modifier_item_net_aaaa:GetModifierManaBonus( params )	--智力
	return math.ceil(self.attributes.mfz)
end

function modifier_item_net_aaaa:GetModifierConstantManaRegen( params )	--智力
	return math.ceil(self.attributes.mfhf)
end
--function modifier_item_net_aaaa:GetModifierIncomingDamage_Percentage( params )	--智力
	--return -self.attributes.shjm
--end
function modifier_item_net_aaaa:GetModifierAttackRangeBonus( params )
	return math.ceil(self.attributes.gjjl)
end
--------------------------------------------------------------------------------

function modifier_item_net_aaaa:IsHidden()
	return true
	-- body
end
function modifier_item_net_aaaa:OnCreated( kv )

	self.attributes = {}

--	self.attributes.yxtfjndjjc=0;		--英雄天赋技能等级加成   (该词条不受品质浮动)
	self.attributes.grjndj=0;			--个人技能等级加成
--	self.attributes.ggjndj=0;			--公共技能等级加成
	self.attributes.jqjc=0	
	self.attributes.msmjq=0		
	self.attributes.sgzjjb=0
	self.attributes.jyjc=0
	self.attributes.ydsd=0
	self.attributes.bfbtssm=0  --百分比增加生命
	self.attributes.damage_bfb=0
	self.attributes.attack_speed=0
	self.attributes.jnsh=0
	self.attributes.wlbjgl=0
	self.attributes.wlbjsh=0
	self.attributes.mfbjgl=0
	self.attributes.mfbjsh=0
	self.attributes.lqsj=0
	self.attributes.attack_damage_plus= 0
	self.attributes.gjxx= 0
	self.attributes.fsxx= 0
	self.attributes.fjsh= 0
	self.attributes.zzsh= 0
	self.attributes.tswsh= 0
	self.attributes.wlxx=0
	self.attributes.wlshts=0
	self.attributes.mfshts=0
	self.attributes.wlct=0
	self.attributes.mfct=0
	self.attributes.zhwsh=0
	self.attributes.gjjl=0

	
	self.attributes.mfhf=0
	self.attributes.mfz=0
	self.attributes.mfkx=0
	self.attributes.smhf=0
	self.attributes.hj=0
	self.attributes.sb=0
	self.attributes.smzhfbfb=0
	self.attributes.shjm=0
	self.attributes.qjxx=0
	self.attributes.shhm=0
	
	self.attributes.bfbtsll=0	--百分比提升力量
	self.attributes.bfbtsmj=0		--百分比提升敏捷
	self.attributes.bfbtszl=0		--百分比提升智力
	self.attributes.bfbtsqsx=0		--百分比提升全属性
	self.attributes.sjjll=0
	self.attributes.sjjmj=0
	self.attributes.sjjzl=0
	self.attributes.sjjqsx=0

	self:OnRefresh( kv )
end

----------------------------------------

function modifier_item_net_aaaa:OnRefresh( kv )
	--移除之前的数值
	self:OnDestroy()

	local parent = self:GetParent();
	if not parent then
		return;
	end
	
	local itempro= nil
	if IsServer() then
		itempro = parent._net_equip_buff_list
	else
		itempro = CustomNetTables:GetTableValue( "ItemsInfo", "modifier_item_net_aaaa_"..parent:entindex())
	end
	
	if itempro then
		local attrs = itempro.item_attributes or {}
		for key, var in pairs(self.attributes) do
			self.attributes[key] = attrs[key] or 0
		end
	
		if IsServer() then
			local attributes = {}
			for key, var in pairs(self.attributes) do
				attributes[key] = var
			end
			AttributesSet(self:GetParent(),attributes)
		end
	end
	
end
function modifier_item_net_aaaa:OnDestroy( )
	if IsServer() then
		local attributes = {}
		for key, var in pairs(self.attributes) do
			attributes[key] = -var
		end
		
		AttributesSet(self:GetParent(),attributes)
	else
		for key, var in pairs(self.attributes) do
			self.attributes[key] = 0
		end
	end
end

function modifier_item_net_aaaa:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------
