item_sj_wq_ll_1_1_lv1 = class({})
LinkLuaModifier( "item_weapon", "lua_items/item_weapon", LUA_MODIFIER_MOTION_NONE )


function item_sj_wq_ll_1_1_lv1:Spawn()

	if IsServer() then
	--	self:SetLevel(4)
		
			--self.itemtype={}  --初始化，防止取不到值
			--self.itemtype.item_attributes={}
			--self.itemtype.item_attributes_spe={}
			local NameArrary=string.split(self:GetName(), "_")
			self.itemtype={}
			local show_list={}
			self.itemtype.item_attributes={}
			self.itemtype.item_attributes_spe={}
			show_list.item_attributes={}
			show_list.item_attributes_spe={}
			self.lv =SjLevel[SjTime]
			if self.lv==nil then
				self.lv=1
			end
			self.zdl = 0
			self.pz=tonumber(string.sub(NameArrary[7],3,-1))--从名称取等级
			self:SetLevel(self.pz)
			--随机装备等级，由阶段固定  --需要由怪物等级控制
			--buff_list.itemlevel=itemlevel--存储物品等级
			--buff_list.itemrare=itemrare--存储物品等级
			local base_pro_num=Weightsgetvalue_one_se(Item_Rare["rare_"..self.pz]['rare_base_pro'])  --普通词条个数
			local spe_pro_num=Weightsgetvalue_one_se(Item_Rare["rare_"..self.pz]['rare_spe_pro'])  --特殊词条个数
			local baseprotable=Weightsgetvalue_one_key(Item_Pro_Weight[NameArrary[3]].base_pro,base_pro_num)
			local speprotable=Weightsgetvalue_one_key(Item_Pro_Weight[NameArrary[3]].spe_pro,spe_pro_num)
			local rarevalue=RandomFloat(Item_Rare["rare_"..self.pz]["pro_value"][1], Item_Rare["rare_"..self.pz]["pro_value"][2]) --品质区间
			self.itemtype.item_attributes,show_list.item_attributes=self:SetAttrTable(baseprotable,rarevalue)
			self.itemtype.item_attributes_spe,show_list.item_attributes_spe=self:SetAttrTable(speprotable,rarevalue)
			
			CustomNetTables:SetTableValue( "ItemsInfo", string.format( "%d", self:GetEntityIndex() ), self.itemtype)
			show_list.itemlevel=self.lv--存储物品等级
			show_list.itemrare=self.pz--存储物品等级
			show_list.zdl=self.zdl --存储物品战斗力
			show_list.price= 500 * self.pz * self.lv  --存储物品价格
			show_list.sds=self.lv * self.pz --存储物品回收的杀敌积分
			CustomNetTables:SetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ), show_list)
		

	end
end

function item_sj_wq_ll_1_1_lv1:SetAttrTable(ftable,rarevalue)
	local cc={}
	local vv={}
	for i=1,#ftable do
		local prokey=ftable[i]
		local result=RandomFloat(Rare_Pro_Value[prokey][self.lv][1],Rare_Pro_Value[prokey][self.lv ][2])
		local provalue=math.ceil(result*rarevalue)
		self.zdl = self.zdl +  (Rare_Pro_zdl[self.lv ]/Rare_Pro_Value[prokey][self.lv ][2]*provalue)
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
function item_sj_wq_ll_1_1_lv1:GetIntrinsicModifierName()
	return "item_weapon"
end

