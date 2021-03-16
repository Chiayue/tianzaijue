require( "event.Itembaolv" )
modifier_item_net_aaaa = class({})
function modifier_item_net_aaaa:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
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
		
	}
	return funcs
end

function modifier_item_net_aaaa:GetModifierExtraHealthPercentage( params )	--智力
	return math.ceil(self.bfbtssm)
end


function modifier_item_net_aaaa:GetModifierDamageOutgoing_Percentage( params )	--智力
	return math.ceil(self.damage_bfb)
end

function modifier_item_net_aaaa:GetModifierAttackSpeedBonus_Constant( params )
	return math.ceil(self.attack_speed)
end
function modifier_item_net_aaaa:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end	
function modifier_item_net_aaaa:GetModifierSpellAmplify_Percentage( params )	--力量
	return math.ceil(self.jnsh)
end
function modifier_item_net_aaaa:GetModifierPercentageCooldown( params )
	return math.ceil(self.lqsj)
end

function modifier_item_net_aaaa:GetModifierEvasion_Constant( params )	--智力
	return math.ceil(self.sb)
end
function modifier_item_net_aaaa:GetModifierHealthRegenPercentage( params )	--智力
	return math.ceil(self.smzhfbfb)
end
function modifier_item_net_aaaa:GetModifierPhysicalArmorBonus( params )	--智力
	return math.ceil(self.hj)
end
function modifier_item_net_aaaa:GetModifierConstantHealthRegen( params )	--智力
	return math.ceil(self.smhf)
end


function modifier_item_net_aaaa:GetModifierMagicalResistanceBonus( params )	--智力
	return math.ceil(self.mfkx)
end
function modifier_item_net_aaaa:GetModifierManaBonus( params )	--智力
	return math.ceil(self.mfz)
end

function modifier_item_net_aaaa:GetModifierConstantManaRegen( params )	--智力
	return math.ceil(self.mfhf)
end
--function modifier_item_net_aaaa:GetModifierIncomingDamage_Percentage( params )	--智力
	--return -self.shjm
--end
function modifier_item_net_aaaa:GetModifierAttackRangeBonus( params )
	return math.ceil(self.gjjl)
end
--------------------------------------------------------------------------------

function modifier_item_net_aaaa:IsDebuff()
	return false
end

function modifier_item_net_aaaa:GetTexture( params )
    return "modifier_item_net_aaaa"
end
function modifier_item_net_aaaa:IsHidden()
	return true
	-- body
end
function modifier_item_net_aaaa:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_item_net_aaaa:OnRefresh( kv )
	
	
	
--	self.yxtfjndjjc=0;		--英雄天赋技能等级加成   (该词条不受品质浮动)
	self.grjndj=0;			--个人技能等级加成
--	self.ggjndj=0;			--公共技能等级加成
	self.jqjc=0	
	self.msmjq=0		
	self.sgzjjb=0
	self.jyjc=0
	self.ydsd=0
	self.bfbtssm=0  --百分比增加生命
	self.damage_bfb=0
	self.attack_speed=0
	self.jnsh=0
	self.wlbjgl=0
	self.wlbjsh=0
	self.mfbjgl=0
	self.mfbjsh=0
	self.lqsj=0
	self.attack_damage_plus= 0
	self.gjxx= 0
	self.fsxx= 0
	self.fjsh= 0
	self.zzsh= 0
	self.wlxx=0
	self.wlshts=0
	self.mfshts=0
	self.wlct=0
	self.mfct=0
	self.zhwsh=0
	self.gjjl=0

	
	self.mfhf=0
	self.mfz=0
	self.mfkx=0
	self.smhf=0
	self.hj=0
	self.sb=0
	self.smzhfbfb=0
	self.shjm=0
	self.qjxx=0
	self.shhm=0
	
	self.bfbtsll=0	--百分比提升力量
	self.bfbtsmj=0		--百分比提升敏捷
	self.bfbtszl=0		--百分比提升智力
	self.bfbtsqsx=0		--百分比提升全属性
	self.sjjll=0
	self.sjjmj=0
	self.sjjzl=0
	self.sjjqsx=0


    
        local itempro=CustomNetTables:GetTableValue( "ItemsInfo", "modifier_item_net_aaaa")
        
		if itempro.item_attributes.wlxx then
			self.wlxx=itempro.item_attributes.wlxx
		end
		if itempro.item_attributes.attack_speed then
			self.attack_speed=itempro.item_attributes.attack_speed
		end
		if itempro.item_attributes.damage_bfb then
			self.damage_bfb=itempro.item_attributes.damage_bfb
		end
		if itempro.item_attributes.jnsh then
			self.jnsh=itempro.item_attributes.jnsh
		end
		
		if itempro.item_attributes.attack_damage_plus then
			self.attack_damage_plus=itempro.item_attributes.attack_damage_plus
		end

		if itempro.item_attributes.gjxx then
			self.gjxx=itempro.item_attributes.gjxx
		end
		if itempro.item_attributes.fsxx then
			self.fsxx=itempro.item_attributes.fsxx
		end


		if itempro.item_attributes.zzsh then
			self.zzsh=itempro.item_attributes.zzsh
		end 
		if itempro.item_attributes.fjsh then
			self.fjsh=itempro.item_attributes.fjsh
		end
		if itempro.item_attributes.lqsj then
			self.lqsj=itempro.item_attributes.lqsj
		end
		if itempro.item_attributes.wlbjgl then
			self.wlbjgl=itempro.item_attributes.wlbjgl
		end
		if itempro.item_attributes.wlbjsh then
			self.wlbjsh=itempro.item_attributes.wlbjsh
		end

		if itempro.item_attributes.mfhf then
			self.mfhf=itempro.item_attributes.mfhf
		end

		if itempro.item_attributes.mfz then
			self.mfz=itempro.item_attributes.mfz
		end
		if itempro.item_attributes.mfkx then
			self.mfkx=itempro.item_attributes.mfkx
		end
		if itempro.item_attributes.qsx then
			self.qsx=itempro.item_attributes.qsx
		end
		if itempro.item_attributes.smhf then
			self.smhf=itempro.item_attributes.smhf
			
		end
		if itempro.item_attributes.hj then
			self.hj=itempro.item_attributes.hj
			
		end
		if itempro.item_attributes.sb then
			self.sb=itempro.item_attributes.sb
			
		end
		if itempro.item_attributes.smzhfbfb then
			self.smzhfbfb=itempro.item_attributes.smzhfbfb
			
		end
		
		if itempro.item_attributes.shjm then
			self.shjm=itempro.item_attributes.shjm
			
		end
		if itempro.item_attributes.qjxx then
			self.qjxx=itempro.item_attributes.qjxx
		end
		if itempro.item_attributes.shhm then
			self.shhm=itempro.item_attributes.shhm
		end
		if itempro.item_attributes.bfbtsll then
			self.bfbtsll=itempro.item_attributes.bfbtsll
		end
		if itempro.item_attributes.bfbtsmj then
			self.bfbtsmj=itempro.item_attributes.bfbtsmj
		end
		if itempro.item_attributes.bfbtszl then
			self.bfbtszl=itempro.item_attributes.bfbtszl
		end
		if itempro.item_attributes.bfbtsqsx then
			self.bfbtsqsx=itempro.item_attributes.bfbtsqsx
		end
		if itempro.item_attributes.sjjll then
			self.sjjll=itempro.item_attributes.sjjll
		end
		if itempro.item_attributes.sjjmj then
			self.sjjmj=itempro.item_attributes.sjjmj
		end
		if itempro.item_attributes.sjjzl then
			self.sjjzl=itempro.item_attributes.sjjzl
		end
		if itempro.item_attributes.sjjqsx then
			self.sjjll= self.sjjll + itempro.item_attributes.sjjqsx
			self.sjjmj= self.sjjmj + itempro.item_attributes.sjjqsx
			self.sjjzl= self.sjjzl + itempro.item_attributes.sjjqsx
		end

		if itempro.item_attributes.mfbjgl then
			self.mfbjgl=itempro.item_attributes.mfbjgl
		end
		if itempro.item_attributes.mfbjsh then
			self.mfbjsh=itempro.item_attributes.mfbjsh
		end
		if itempro.item_attributes.wlshts then
			self.wlshts=itempro.item_attributes.wlshts
		end
		if itempro.item_attributes.mfshts then
			self.mfshts=itempro.item_attributes.mfshts
		end
		if itempro.item_attributes.wlct then
			self.wlct=itempro.item_attributes.wlct
		end
		if itempro.item_attributes.mfct then
			self.mfct=itempro.item_attributes.mfct
		end
		if itempro.item_attributes.zhwsh then
			self.zhwsh=itempro.item_attributes.zhwsh
		end
		if itempro.item_attributes.gjjl then
			self.gjjl=itempro.item_attributes.gjjl
		end



		
		if itempro.item_attributes.bfbtssm then
			self.bfbtssm=itempro.item_attributes.bfbtssm
		end
		if itempro.item_attributes.jqjc then
			self.jqjc=itempro.item_attributes.jqjc
		end
		if itempro.item_attributes.jyjc then
			self.jyjc=itempro.item_attributes.jyjc
		end
		if itempro.item_attributes.sgzjjb then
			self.sgzjjb=itempro.item_attributes.sgzjjb
		end
		if itempro.item_attributes.msmjq then
			self.msmjq=itempro.item_attributes.msmjq
		end
		if itempro.item_attributes.grjndj then
			self.grjndj=itempro.item_attributes.grjndj
		end


		if IsServer() then
            local attributes = {}
            attributes["gjxx"] = self.gjxx
            attributes["fsxx"] = self.fsxx
            attributes["zzsh"] = self.zzsh
            attributes["fjsh"] = self.fjsh
            attributes["lqsj"] = self.lqsj
            attributes["wlbjgl"] = self.wlbjgl
            attributes["wlbjsh"] = self.wlbjsh
            attributes["mfbjgl"] = self.mfbjgl
            attributes["mfbjsh"] = self.mfbjsh
            attributes["jnsh"] = self.jnsh
            attributes["wlxx"] = self.wlxx
			
			attributes["shjm"] = self.shjm 
			attributes["qjxx"] = self.qjxx 
			attributes["shhm"] = self.shhm 
			attributes["bfbtsll"] = self.bfbtsll
			attributes["bfbtsmj"] = self.bfbtsmj
			attributes["bfbtszl"] = self.bfbtszl
			attributes["bfbtsqsx"] = self.bfbtsqsx
			attributes["sjjll"] = self.sjjll
			attributes["sjjmj"] = self.sjjmj
			attributes["sjjzl"] = self.sjjzl
			attributes["mfbjgl"] = self.mfbjgl
			attributes["mfbjsh"] = self.mfbjsh
			attributes["wlshts"] = self.wlshts
			attributes["mfshts"] = self.mfshts
			attributes["wlct"] = self.wlct
			attributes["mfct"] = self.mfct
			attributes["zhwsh"] = self.zhwsh




			attributes["grjndj"] = self.grjndj 
			attributes["jqjc"] = self.jqjc 
			attributes["msmjq"] = self.msmjq 
			attributes["sgzjjb"] = self.sgzjjb 
			attributes["jyjc"] = self.jyjc 
			attributes["ydsd"] = self.ydsd 
			attributes["bfbtssm"] = self.bfbtssm 


			AttributesSet(self:GetParent(),attributes)
			
        end
end
function modifier_item_net_aaaa:OnDestroy( )
	if IsServer() then
		local attributes = {}
		attributes["gjxx"] = self.gjxx and -self.gjxx or nil
		attributes["fsxx"] = self.fsxx and -self.fsxx or nil
		attributes["zzsh"] = self.zzsh and -self.zzsh or nil
		attributes["fjsh"] = self.fjsh and -self.fjsh or nil
		attributes["lqsj"] = self.lqsj and -self.lqsj or nil
		attributes["wlbjgl"] = self.wlbjgl and -self.wlbjgl or nil
		attributes["wlbjsh"] = self.wlbjsh and -self.wlbjsh or nil
		attributes["mfbjgl"] = self.mfbjgl and -self.mfbjgl or nil
		attributes["mfbjsh"] = self.mfbjsh and -self.mfbjsh or nil
		attributes["jnsh"] = self.jnsh and -self.jnsh or nil
		attributes["wlxx"] = self.wlxx and -self.wlxx or nil

		attributes["shjm"] = self.shjm and -self.shjm or nil
		attributes["qjxx"] = self.qjxx and -self.qjxx or nil
		attributes["shhm"] = self.shhm and -self.shhm or nil
		attributes["bfbtsll"] = self.bfbtsll and -self.bfbtsll or nil
		attributes["bfbtsmj"] = self.bfbtsmj and -self.bfbtsmj or nil
		attributes["bfbtszl"] = self.bfbtszl and -self.bfbtszl or nil
		attributes["bfbtsqsx"] = self.bfbtsqsx and -self.bfbtsqsx or nil
		attributes["sjjll"] = self.sjjll and -self.sjjll or nil
		attributes["sjjmj"] = self.sjjmj and -self.sjjmj or nil
		attributes["sjjzl"] = self.sjjzl and -self.sjjzl or nil

		attributes["grjndj"] = self.grjndj  and -self.grjndj or nil
		attributes["jqjc"] = self.jqjc and -self.jqjc or nil
		attributes["msmjq"] = self.msmjq and -self.msmjq or nil
		attributes["sgzjjb"] = self.sgzjjb and -self.sgzjjb or nil
		attributes["jyjc"] = self.jyjc and -self.jyjc or nil
		attributes["ydsd"] = self.ydsd and -self.ydsd or nil
		attributes["bfbtssm"] = self.bfbtssm and -self.bfbtssm or nil
		attributes["mfbjgl"] = self.mfbjgl	and -self.mfbjgl or nil
		attributes["mfbjsh"] = self.mfbjsh	and -self.mfbjsh or nil
		attributes["wlshts"] = self.wlshts	and -self.wlshts or nil
		attributes["mfshts"] = self.mfshts	and -self.mfshts or nil
		attributes["wlct"] = self.wlct	and -self.wlct or nil
		attributes["mfct"] = self.mfct 	and -self.mfct or nil
		attributes["zhwsh"] = self.zhwsh 	and -self.zhwsh or nil
		AttributesSet(self:GetParent(),attributes)
	end
end



--------------------------------------------------------------------------------
