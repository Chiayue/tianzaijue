item_sq_1_1_1 = class({})
LinkLuaModifier( "item_sq_pd", "lua_items/sq_item/item_sq_pd", LUA_MODIFIER_MOTION_NONE )


function item_sq_1_1_1:Spawn()

	if IsServer() then
			local namearray= string.split(self:GetName(), "_")
			local sqtype =  tonumber(namearray[4])
			local level = tonumber(namearray[3])
			self.itemtype={}
			local show_list={}
			self.itemtype.item_attributes={}
			self.itemtype.item_attributes_spe={}
			show_list.item_attributes={}
			show_list.item_attributes_spe={}
			self.lv = level
			self.pz = Weightsgetvalue_one(Sq_pz)
			if self.lv==nil then
				self.lv=1
			end
			local sx ={}
			for i=1,self.pz do
				local r = RandomInt(1,#Item_Sq_Weight)
				local sx2 = Item_Sq_Weight[r]
				table.insert(sx,sx2)
			end

			self.itemtype.item_attributes,show_list.item_attributes=self:SetAttrTable(sx)
			if sqtype == 1 then
				self.itemtype.item_attributes.zzjt_time = 1 * level
				self.itemtype.item_attributes.ltyj_time = 1 * level
				self.itemtype.item_attributes.czss_time = 1 * level
				self.itemtype.item_attributes.hxs_multiple = 1 * level
				self.itemtype.item_attributes.tkjj_multiple = 1 * level				
			elseif sqtype == 2 then
				self.itemtype.item_attributes.swmc_damage = 5 * level
				self.itemtype.item_attributes.swmc_heal = 5 * level
				self.itemtype.item_attributes.tkjj_time = 1 * level
				self.itemtype.item_attributes.gjz_max = 1 * level
				self.itemtype.item_attributes.swzz_max = 1 * level
				self.itemtype.item_attributes.bsxx_max = 1 * level
			elseif sqtype == 3 then
				self.itemtype.item_attributes.ldj_time = 1 * level
				self.itemtype.item_attributes.fx_time = 1 * level
				self.itemtype.item_attributes.dxcq_time = 1 * level
			elseif sqtype == 4 then
				self.itemtype.item_attributes.ldj_max = 1 * level
				self.itemtype.item_attributes.fx_max = 1 * level
				self.itemtype.item_attributes.dxcq_max = 1 * level
			elseif sqtype == 5 then
				self.itemtype.item_attributes.jqz_time = 1 * level
				self.itemtype.item_attributes.zdb_time = 1 * level
				self.itemtype.item_attributes.lpz_time = 1 * level
			elseif sqtype == 6 then
				self.itemtype.item_attributes.jqz_max = 1 * level
				self.itemtype.item_attributes.zdb_max = 1 * level
				self.itemtype.item_attributes.lpz_max = 1 * level
			elseif sqtype == 7 then
				self.itemtype.item_attributes.lzfs_time = 1 * level
				self.itemtype.item_attributes.blgj_time = 1 * level
				self.itemtype.item_attributes.bsbp_time = 1 * level
				self.itemtype.item_attributes.zkfs_time = 1 * level
			elseif sqtype == 8 then
				self.itemtype.item_attributes.lxdf_time = 1 * level
				self.itemtype.item_attributes.hdyj_time = 1 * level
				self.itemtype.item_attributes.hpq_time = 1 * level
				self.itemtype.item_attributes.hyqj_time = 1 * level
				self.itemtype.item_attributes.lypj_time = 1 * level
			elseif sqtype == 9 then
				self.itemtype.item_attributes.swsw_max = 0.5 * level
				self.itemtype.item_attributes.dyh_max = 0.5 * level
				self.itemtype.item_attributes.qssw_max = 1 * level
			elseif sqtype == 10 then
				self.itemtype.item_attributes.lxdf_multiple = 1 * level
				self.itemtype.item_attributes.hdyj_multiple = 1 * level
				self.itemtype.item_attributes.hpq_multiple = 1 * level
				self.itemtype.item_attributes.hyqj_multiple = 1 * level
				self.itemtype.item_attributes.lypj_multiple = 1 * level
			end
			self.itemtype.item_attributes_spe={}
			show_list.item_attributes_spe={}
			CustomNetTables:SetTableValue( "ItemsInfo", string.format( "%d", self:GetEntityIndex() ), self.itemtype)
			show_list.itemlevel=self.lv--存储物品等级
			show_list.itemrare=self.pz--存储物品等级
			show_list.price= 500 * self.pz * self.lv  --存储物品价格
			show_list.sds=self.lv * self.pz --存储物品回收的杀敌积分
			CustomNetTables:SetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ), show_list)
		

	end
end

function item_sq_1_1_1:SetAttrTable(ftable)
	local cc={}
	local vv={}
	for i=1,#ftable do
		local prokey=ftable[i]
		local result=RandomInt(Sq_Pro_Value[prokey][self.lv],Sq_Pro_Value[prokey][self.lv+1]) 
		local provalue=result
		if cc[prokey] then
			table.insert(vv[prokey],provalue)
			cc[prokey]=cc[prokey]+provalue
		else
			vv[prokey]={}
			table.insert(vv[prokey],provalue)
			cc[prokey]=provalue
		end
	end
	return cc,vv
end
function item_sq_1_1_1:GetIntrinsicModifierName()
	return "item_sq_pd"
end

