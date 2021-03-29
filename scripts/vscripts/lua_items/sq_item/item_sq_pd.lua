item_sq_pd = class({})


function item_sq_pd:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function item_sq_pd:GetModifierBaseDamageOutgoing_Percentage( params )	--智力
	return self.gjl
end

function item_sq_pd:GetModifierAttackSpeedBonus_Constant( params )
	return self.gjsd
end
function item_sq_pd:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_sq_pd:GetModifierSpellAmplify_Percentage( params )	--力量
	return self.jnsh
end
function item_sq_pd:GetModifierPercentageCooldown( params )
	return self.lqsj
end
--------------------------------------------------------------------------------

function item_sq_pd:IsHidden()
	return true
	-- body
end
function item_sq_pd:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function item_sq_pd:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end
	
	self.bfbtsqsx=0			--敏捷				
	self.jnsh=0
	self.zzsh=0
	self.jqjc=0
	self.jyjc=0
	self.lqsj=0
	self.shjm= 0
	self.grjndj=0
	self.wlbjsh= 0
	self.wlbjgl= 0
	self.lqsj= 0
--1
	self.zzjt_time= 0
	self.ltyj_time= 0
	self.czss_time= 0
	self.hxs_multiple = 0
	self.tkjj_multiple = 0
--2
	self.swmc_damage= 0
	self.swmc_heal= 0
	self.tkjj_time= 0
	self.gjz_max= 0
	self.swzz_max= 0
--3
	self.ldj_time= 0
	self.fx_time= 0
	self.dxcq_time= 0
--4
	self.ldj_max= 0
	self.fx_max= 0
	self.dxcq_max= 0
--5
	self.jqz_time= 0
	self.zdb_time= 0
	self.lpz_time= 0
--6
	self.jqz_max= 0
	self.zdb_max= 0
	self.lpz_max= 0
--7
	self.lzfs_time= 0
	self.blgj_time= 0
	self.bsbp_time= 0
	self.zkfs_time= 0

--8
	self.lxdf_time= 0
	self.hdyj_time= 0
	self.hpq_time= 0
	self.hyqj_time= 0
	self.lypj_time= 0
--9
	self.qssw_max = 0
	self.dyh_max = 0
	self.swsw_max = 0

--10
	self.lxdf_multiple= 0
	self.hdyj_multiple= 0
	self.hpq_multiple= 0
	self.hyqj_multiple= 0
	self.lypj_multiple= 0


	if IsServer() then
		local itempro=self:GetAbility().itemtype
		if not itempro then
			DebugPrint("[item_sq_pd.lua]: itempro is nil")
			itempro = {}
		end
		
		if itempro.item_attributes.gjsd then
			self.gjsd=itempro.item_attributes.gjsd
		end
		if itempro.item_attributes.gjl then
			self.gjl=itempro.item_attributes.gjl
		end
		if itempro.item_attributes.jnsh then
			self.jnsh=itempro.item_attributes.jnsh
		end
		
		if itempro.item_attributes.bfbtsqsx then
			self.bfbtsqsx=itempro.item_attributes.bfbtsqsx
		end

		if itempro.item_attributes.zzsh then
			self.zzsh=itempro.item_attributes.zzsh
		end 
		if itempro.item_attributes.jqjc then
			self.jqjc=itempro.item_attributes.jqjc
		end
	
		if itempro.item_attributes.jyjc then
			self.jyjc=itempro.item_attributes.jyjc
		end 
		if itempro.item_attributes.lqsj then
			self.lqsj=itempro.item_attributes.lqsj
		end
		if itempro.item_attributes.wlbjsh then
			self.wlbjsh=itempro.item_attributes.wlbjsh
		end
		if itempro.item_attributes.shjm then
			self.shjm=itempro.item_attributes.shjm
		end
		if itempro.item_attributes.wlbjgl then
			self.wlbjgl=itempro.item_attributes.wlbjgl
		end
		if itempro.item_attributes.grjndj then
			self.grjndj=itempro.item_attributes.grjndj
		end
		--神器1
		if itempro.item_attributes.zzjt_time then
			self.zzjt_time=itempro.item_attributes.zzjt_time
		end
		if itempro.item_attributes.ltyj_time then
			self.ltyj_time=itempro.item_attributes.ltyj_time
		end
		if itempro.item_attributes.czss_time then
			self.czss_time=itempro.item_attributes.czss_time
		end
		if itempro.item_attributes.hxs_multiple then
			self.hxs_multiple=itempro.item_attributes.hxs_multiple
		end
		if itempro.item_attributes.tkjj_multiple then
			self.tkjj_multiple=itempro.item_attributes.tkjj_multiple
		end

		--神器2
		if itempro.item_attributes.swmc_damage then
			self.swmc_damage=itempro.item_attributes.swmc_damage
		end
		if itempro.item_attributes.swmc_heal then
			self.swmc_heal=itempro.item_attributes.swmc_heal
		end
		if itempro.item_attributes.tkjj_time then
			self.tkjj_time=itempro.item_attributes.tkjj_time
		end
		if itempro.item_attributes.gjz_max then
			self.gjz_max=itempro.item_attributes.gjz_max
		end
		if itempro.item_attributes.swzz_max then
			self.swzz_max=itempro.item_attributes.swzz_max
		end
		if itempro.item_attributes.bsxx_max then
			self.bsxx_max=itempro.item_attributes.bsxx_max
		end
		
		--神器3
		if itempro.item_attributes.ldj_time then
			self.ldj_time=itempro.item_attributes.ldj_time
		end
		if itempro.item_attributes.fx_time then
			self.fx_time=itempro.item_attributes.fx_time
		end
		if itempro.item_attributes.dxcq_time then
			self.dxcq_time=itempro.item_attributes.dxcq_time
		end

		--神器4
		if itempro.item_attributes.ldj_max then
			self.ldj_max=itempro.item_attributes.ldj_max
		end
		if itempro.item_attributes.fx_max then
			self.fx_max=itempro.item_attributes.fx_max
		end
		if itempro.item_attributes.dxcq_max then
			self.dxcq_max=itempro.item_attributes.dxcq_max
		end

		--神器5
		if itempro.item_attributes.jqz_time then
			self.jqz_time=itempro.item_attributes.jqz_time
		end
		if itempro.item_attributes.zdb_time then
			self.zdb_time=itempro.item_attributes.zdb_time
		end
		if itempro.item_attributes.lpz_time then
			self.lpz_time=itempro.item_attributes.lpz_time
		end


		--神器6
		if itempro.item_attributes.jqz_max then
			self.jqz_max=itempro.item_attributes.jqz_max
		end
		if itempro.item_attributes.zdb_max then
			self.zdb_max=itempro.item_attributes.zdb_max
		end
		if itempro.item_attributes.lpz_max then
			self.lpz_max=itempro.item_attributes.lpz_max
		end


		--神器7
		if itempro.item_attributes.lzfs_time then
			self.lzfs_time=itempro.item_attributes.lzfs_time
		end
		if itempro.item_attributes.blgj_time then
			self.blgj_time=itempro.item_attributes.blgj_time
		end
		if itempro.item_attributes.bsbp_time then
			self.bsbp_time=itempro.item_attributes.bsbp_time
		end
		if itempro.item_attributes.zkfs_time then
			self.zkfs_time=itempro.item_attributes.zkfs_time
		end

		--神器8
		if itempro.item_attributes.lxdf_time then
			self.lxdf_time=itempro.item_attributes.lxdf_time
		end
		if itempro.item_attributes.hdyj_time then
			self.hdyj_time=itempro.item_attributes.hdyj_time
		end
		if itempro.item_attributes.hpq_time then
			self.hpq_time=itempro.item_attributes.hpq_time
		end
		if itempro.item_attributes.hyqj_time then
			self.hyqj_time=itempro.item_attributes.hyqj_time
		end
		if itempro.item_attributes.lypj_time then
			self.lypj_time=itempro.item_attributes.lypj_time
		end

		--神器9
		if itempro.item_attributes.qssw_max then
			self.qssw_max=itempro.item_attributes.qssw_max
		end
		if itempro.item_attributes.swsw_max then
			self.swsw_max=itempro.item_attributes.swsw_max
		end
		if itempro.item_attributes.dyh_max then
			self.dyh_max=itempro.item_attributes.dyh_max
		end
		if itempro.item_attributes.smbf_multiple then
			self.smbf_multiple=itempro.item_attributes.smbf_multiple
		end
		if itempro.item_attributes.sxs_multiple then
			self.sxs_multiple=itempro.item_attributes.sxs_multiple
		end

		--神器10
		if itempro.item_attributes.lxdf_multiple then
			self.lxdf_multiple=itempro.item_attributes.lxdf_multiple
		end
		if itempro.item_attributes.hdyj_multiple then
			self.hdyj_multiple=itempro.item_attributes.hdyj_multiple
		end
		if itempro.item_attributes.hpq_multiple then
			self.hpq_multiple=itempro.item_attributes.hpq_multiple
		end
		if itempro.item_attributes.hyqj_multiple then
			self.hyqj_multiple=itempro.item_attributes.hyqj_multiple
		end
		if itempro.item_attributes.lypj_multiple then
			self.lypj_multiple=itempro.item_attributes.lypj_multiple
		end
		
		local attributes = {}
		attributes["jqjc"] = self.jqjc
		attributes["jyjc"] = self.jyjc
		attributes["zzsh"] = self.zzsh
		attributes["bfbtsqsx"] = self.bfbtsqsx
		attributes["lqsj"] = self.lqsj
		attributes["wlbjgl"] = self.wlbjgl
		attributes["wlbjsh"] = self.wlbjsh
		attributes["shjm"] = self.shjm
		attributes["grjndj"] = self.grjndj
		
		AttributesSet(self:GetParent(),attributes)
		
		local attributes2 = {}

		attributes2["zzjt_time"] = self.zzjt_time
		attributes2["ltyj_time"] = self.ltyj_time
		attributes2["czss_time"] = self.czss_time
		attributes2["hxs_multiple"] = self.hxs_multiple
		attributes2["tkjj_multiple"] = self.tkjj_multiple

		attributes2["swmc_damage"] = self.swmc_damage
		attributes2["swmc_heal"] = self.swmc_heal
		attributes2["tkjj_time"] = self.tkjj_time
		attributes2["gjz_max"] = self.gjz_max
		attributes2["swzz_max"] = self.swzz_max
		attributes2["bsxx_max"] = self.bsxx_max

		attributes2["ldj_time"] = self.ldj_time
		attributes2["fx_time"] = self.fx_time
		attributes2["dxcq_time"] = self.dxcq_time

		attributes2["ldj_max"] = self.ldj_max
		attributes2["fx_max"] = self.fx_max
		attributes2["dxcq_max"] = self.dxcq_max


		attributes2["jqz_time"] = self.jqz_time
		attributes2["zdb_time"] = self.zdb_time
		attributes2["lpz_time"] = self.lpz_time

		attributes2["jqz_max"] = self.jqz_max
		attributes2["zdb_max"] = self.zdb_max
		attributes2["lpz_max"] = self.lpz_max


		attributes2["lzfs_time"] = self.lzfs_time
		attributes2["blgj_time"] = self.blgj_time
		attributes2["bsbp_time"] = self.bsbp_time
		attributes2["zkfs_time"] = self.zkfs_time

		attributes2["lxdf_time"] = self.lxdf_time
		attributes2["hdyj_time"] = self.hdyj_time
		attributes2["hpq_time"] = self.hpq_time
		attributes2["hyqj_time"] = self.hyqj_time
		attributes2["lypj_time"] = self.lypj_time

		attributes2["dyh_max"] = self.dyh_max
		attributes2["qssw_max"] = self.qssw_max
		attributes2["swsw_max"] = self.swsw_max
		attributes2["smbf_multiple"] = self.smbf_multiple
		attributes2["sxs_multiple"] = self.sxs_multiple

		attributes2["lxdf_multiple"] = self.lxdf_multiple
		attributes2["hdyj_multiple"] = self.hdyj_multiple
		attributes2["hpq_multiple"] = self.hpq_multiple
		attributes2["hyqj_multiple"] = self.lypj_multiple
		attributes2["lypj_multiple"] = self.lypj_multiple
		AttributesSet2(self:GetParent(),attributes2)
		
		CustomNetTables:SetTableValue( "ItemsInfo", tostring( self:GetParent():GetPlayerOwnerID() ), HERO_CUSTOM_PRO )
		local hAbility = self:GetParent():FindAbilityByName( "ascension_crit" )
		if hAbility ~= nil then
			if hAbility:GetIntrinsicModifierName() ~= nil then
				local hIntrinsicModifier = self:GetParent():FindModifierByName( hAbility:GetIntrinsicModifierName() )
				if hIntrinsicModifier then
					print( "Force Refresh intrinsic modifier after minor upgrade" )
					hIntrinsicModifier:ForceRefresh()
				end
			end
		end
	else
		local itempro=CustomNetTables:GetTableValue( "ItemsInfo", string.format( "%d", self:GetAbility():GetEntityIndex()))
		if itempro.item_attributes.gjsd then
			self.gjsd=itempro.item_attributes.gjsd
		end
		if itempro.item_attributes.gjl then
			self.gjl=itempro.item_attributes.gjl
		end
		if itempro.item_attributes.jnsh then
			self.jnsh=itempro.item_attributes.jnsh
		end
		
		if itempro.item_attributes.bfbtsqsx then
			self.bfbtsqsx=itempro.item_attributes.bfbtsqsx
		end

		if itempro.item_attributes.zzsh then
			self.zzsh=itempro.item_attributes.zzsh
		end 
		if itempro.item_attributes.jqjc then
			self.jqjc=itempro.item_attributes.jqjc
		end
	
		if itempro.item_attributes.jyjc then
			self.jyjc=itempro.item_attributes.jyjc
		end 
		if itempro.item_attributes.lqsj then
			self.lqsj=itempro.item_attributes.lqsj
		end
		if itempro.item_attributes.wlbjsh then
			self.wlbjsh=itempro.item_attributes.wlbjsh
		end
		if itempro.item_attributes.shjm then
			self.shjm=itempro.item_attributes.shjm
		end
		if itempro.item_attributes.wlbjgl then
			self.wlbjgl=itempro.item_attributes.wlbjgl
		end
		if itempro.item_attributes.grjndj then
			self.grjndj=itempro.item_attributes.grjndj
		end
		--神器1
		if itempro.item_attributes.zzjt_time then
			self.zzjt_time=itempro.item_attributes.zzjt_time
		end
		if itempro.item_attributes.ltyj_time then
			self.ltyj_time=itempro.item_attributes.ltyj_time
		end
		if itempro.item_attributes.czss_time then
			self.czss_time=itempro.item_attributes.czss_time
		end 
		if itempro.item_attributes.hxs_multiple then
			self.hxs_multiple=itempro.item_attributes.hxs_multiple
		end 
		if itempro.item_attributes.tkjj_multiple then
			self.tkjj_multiple=itempro.item_attributes.tkjj_multiple
		end 


		--神器2
		if itempro.item_attributes.swmc_damage then
			self.swmc_damage=itempro.item_attributes.swmc_damage
		end
		if itempro.item_attributes.swmc_heal then
			self.swmc_heal=itempro.item_attributes.swmc_heal
		end
		if itempro.item_attributes.tkjj_time then
			self.tkjj_time=itempro.item_attributes.tkjj_time
		end
		if itempro.item_attributes.gjz_max then
			self.gjz_max=itempro.item_attributes.gjz_max
		end
		if itempro.item_attributes.swzz_max then
			self.swzz_max=itempro.item_attributes.swzz_max
		end
		if itempro.item_attributes.bsxx_max then
			self.bsxx_max=itempro.item_attributes.bsxx_max
		end
		
		--神器3
		if itempro.item_attributes.ldj_time then
			self.ldj_time=itempro.item_attributes.ldj_time
		end
		if itempro.item_attributes.fx_time then
			self.fx_time=itempro.item_attributes.fx_time
		end
		if itempro.item_attributes.dxcq_time then
			self.dxcq_time=itempro.item_attributes.dxcq_time
		end

		--神器4
		if itempro.item_attributes.ldj_max then
			self.ldj_max=itempro.item_attributes.ldj_max
		end
		if itempro.item_attributes.fx_max then
			self.fx_max=itempro.item_attributes.fx_max
		end
		if itempro.item_attributes.dxcq_max then
			self.dxcq_max=itempro.item_attributes.dxcq_max
		end

		--神器5
		if itempro.item_attributes.jqz_time then
			self.jqz_time=itempro.item_attributes.jqz_time
		end
		if itempro.item_attributes.zdb_time then
			self.zdb_time=itempro.item_attributes.zdb_time
		end
		if itempro.item_attributes.lpz_time then
			self.lpz_time=itempro.item_attributes.lpz_time
		end


		--神器6
		if itempro.item_attributes.jqz_max then
			self.jqz_max=itempro.item_attributes.jqz_max
		end
		if itempro.item_attributes.zdb_max then
			self.zdb_max=itempro.item_attributes.zdb_max
		end
		if itempro.item_attributes.lpz_max then
			self.lpz_max=itempro.item_attributes.lpz_max
		end


		--神器7
		if itempro.item_attributes.lzfs_time then
			self.lzfs_time=itempro.item_attributes.lzfs_time
		end
		if itempro.item_attributes.blgj_time then
			self.blgj_time=itempro.item_attributes.blgj_time
		end
		if itempro.item_attributes.bsbp_time then
			self.bsbp_time=itempro.item_attributes.bsbp_time
		end
		if itempro.item_attributes.zkfs_time then
			self.zkfs_time=itempro.item_attributes.zkfs_time
		end

		--神器8
		if itempro.item_attributes.lxdf_time then
			self.lxdf_time=itempro.item_attributes.lxdf_time
		end
		if itempro.item_attributes.hdyj_time then
			self.hdyj_time=itempro.item_attributes.hdyj_time
		end
		if itempro.item_attributes.hpq_time then
			self.hpq_time=itempro.item_attributes.hpq_time
		end
		if itempro.item_attributes.hyqj_time then
			self.hyqj_time=itempro.item_attributes.hyqj_time
		end
		if itempro.item_attributes.lypj_time then
			self.lypj_time=itempro.item_attributes.lypj_time
		end


		--神器9
		if itempro.item_attributes.qssw_max then
			self.qssw_max=itempro.item_attributes.qssw_max
		end
		if itempro.item_attributes.swsw_max then
			self.swsw_max=itempro.item_attributes.swsw_max
		end
		if itempro.item_attributes.dyh_max then
			self.dyh_max=itempro.item_attributes.dyh_max
		end
		if itempro.item_attributes.smbf_multiple then
			self.smbf_multiple=itempro.item_attributes.smbf_multiple
		end
		if itempro.item_attributes.sxs_multiple then
			self.sxs_multiple=itempro.item_attributes.sxs_multiple
		end

		--神器10
		if itempro.item_attributes.lxdf_multiple then
			self.lxdf_multiple=itempro.item_attributes.lxdf_multiple
		end
		if itempro.item_attributes.hdyj_multiple then
			self.hdyj_multiple=itempro.item_attributes.hdyj_multiple
		end
		if itempro.item_attributes.hpq_multiple then
			self.hpq_multiple=itempro.item_attributes.hpq_multiple
		end
		if itempro.item_attributes.hyqj_multiple then
			self.hyqj_multiple=itempro.item_attributes.hyqj_multiple
		end
		if itempro.item_attributes.lypj_multiple then
			self.lypj_multiple=itempro.item_attributes.lypj_multiple
		end
		
	end
end




function item_sq_pd:OnDestroy( )
	if IsServer() then
		for k,v in pairs(HERO_CUSTOM_PRO.ascension_crit) do
			if self[k] then
				local result=math.max(0, v-self[k])
				HERO_CUSTOM_PRO.ascension_crit[k]=result
			end
		end
		CustomNetTables:SetTableValue( "ItemsInfo", tostring( self:GetParent():GetPlayerOwnerID() ), HERO_CUSTOM_PRO )
		local hAbility = self:GetParent():FindAbilityByName( "ascension_crit" )
		if hAbility ~= nil then
			if hAbility:GetIntrinsicModifierName() ~= nil then
				local hIntrinsicModifier = self:GetParent():FindModifierByName( hAbility:GetIntrinsicModifierName() )
				if hIntrinsicModifier then
					print( "Force Refresh intrinsic modifier after minor upgrade" )
					hIntrinsicModifier:ForceRefresh()
				end
			end
		end

		local attributes = {}
		attributes["jqjc"] = self.jqjc and -self.jqjc or nil
		attributes["jyjc"] = self.jyjc and -self.jyjc or nil
		attributes["zzsh"] = self.zzsh and -self.zzsh or nil
		attributes["bfbtsqsx"] = self.bfbtsqsx and -self.bfbtsqsx or nil
		attributes["lqsj"] = self.lqsj and -self.lqsj or nil
		attributes["wlbjgl"] = self.wlbjgl and -self.wlbjgl or nil
		attributes["wlbjsh"] = self.wlbjsh and -self.wlbjsh or nil
		attributes["shjm"] = self.shjm and -self.shjm or nil
		attributes["grjndj"] = self.grjndj and -self.grjndj or nil
		
		AttributesSet(self:GetParent(),attributes)

		local attributes2 = {}

		attributes2["zzjt_time"] = self.zzjt_time and -self.zzjt_time or nil
		attributes2["ltyj_time"] = self.ltyj_time and -self.ltyj_time or nil
		attributes2["czss_time"] = self.czss_time and -self.czss_time or nil 
		attributes2["hxs_multiple"] = self.hxs_multiple and -self.hxs_multiple or nil
		attributes2["tkjj_multiple"] = self.tkjj_multiple and -self.tkjj_multiple or nil

		attributes2["swmc_damage"] = self.swmc_damage and -self.swmc_damage or nil
		attributes2["swmc_heal"] = self.swmc_heal and -self.swmc_heal or nil
		attributes2["tkjj_time"] = self.tkjj_time and -self.tkjj_time or nil
		attributes2["gjz_max"] = self.gjz_max and -self.gjz_max or nil
		attributes2["swzz_max"] = self.swzz_max and -self.swzz_max or nil
		attributes2["bsxx_max"] = self.bsxx_max and -self.bsxx_max or nil

		attributes2["ldj_time"] = self.ldj_time and -self.ldj_time or nil
		attributes2["fx_time"] = self.fx_time and -self.fx_time or nil
		attributes2["dxcq_time"] = self.dxcq_time and -self.fx_time or nil

		attributes2["ldj_max"] = self.ldj_max and -self.ldj_max or nil
		attributes2["fx_max"] = self.fx_max and -self.fx_max or nil
		attributes2["dxcq_max"] = self.dxcq_max and -self.dxcq_max or nil


		attributes2["jqz_time"] = self.jqz_time and -self.jqz_time or nil
		attributes2["zdb_time"] = self.zdb_time and -self.zdb_time or nil
		attributes2["lpz_time"] = self.lpz_time and -self.lpz_time or nil

		attributes2["jqz_max"] = self.jqz_max and -self.jqz_max or nil
		attributes2["zdb_max"] = self.zdb_max and -self.zdb_max or nil
		attributes2["lpz_max"] = self.lpz_max and -self.lpz_max or nil


		attributes2["lzfs_time"] = self.lzfs_time and -self.lzfs_time or nil
		attributes2["blgj_time"] = self.blgj_time and -self.blgj_time or nil
		attributes2["bsbp_time"] = self.bsbp_time and -self.bsbp_time or nil
		attributes2["zkfs_time"] = self.zkfs_time and -self.zkfs_time or nil

		attributes2["lxdf_time"] = self.lxdf_time and -self.lxdf_time or nil
		attributes2["hdyj_time"] = self.hdyj_time and -self.hdyj_time or nil
		attributes2["hpq_time"] = self.hpq_time and -self.hpq_time or nil
		attributes2["hyqj_time"] = self.hyqj_time and -self.hyqj_time or nil
		attributes2["lypj_time"] = self.lypj_time and -self.lypj_time or nil

		attributes2["dyh_max"] = self.dyh_max and -self.dyh_max or nil
		attributes2["swsw_max"] = self.swsw_max and -self.swsw_max or nil
		attributes2["qssw_max"] = self.qssw_max and -self.qssw_max or nil
		attributes2["smbf_multiple"] = self.smbf_multiple and -self.smbf_multiple or nil
		attributes2["sxs_multiple"] = self.sxs_multiple and -self.sxs_multiple or nil

		attributes2["lxdf_multiple"] = self.lxdf_multiple and -self.lxdf_multiple or nil
		attributes2["hdyj_multiple"] = self.hdyj_multiple and -self.hdyj_multiple or nil
		attributes2["hpq_multiple"] = self.hpq_multiple and -self.hpq_multiple or nil
		attributes2["hyqj_multiple"] = self.hyqj_multiple and -self.hyqj_multiple or nil
		attributes2["lypj_multiple"] = self.lypj_multiple and -self.lypj_multiple or nil

		
		AttributesSet2(self:GetParent(),attributes2)
	end
end

-----------------------------------------------------------------------

--function item_sq_pd:GetAttributes()
--	return MODIFIER_ATTRIBUTE_PERMANENT 
--end