
--武器的基础词条属性权重]]
--base_pro--基础词条表
--spe_pro--特殊词条表
_G.Item_Sq_Weight={
		"gjl",
		"gjsd",
		"bfbtsqsx",
		"jnsh",
		"zzsh",
		"jqjc",
		"jyjc",
		"shjm",
		"grjndj",
		"wlbjgl",
		"wlbjsh",
		"mfbjgl",
		"mfbjsh",
		"lqsj",

	
}

--词条的属性值，
--得到的数值与品阶范围随机值相乘，保留两位小数点
_G.Sq_Pro_Value={
	gjsd={40,80,120,160,200},
	gjl={40,80,120,160,200},
	bfbtsqsx={10,30,60,90,120},
	jnsh={20,40,80,120,160},
	zzsh={10,30,50,70,90},
	jqjc={10,30,60,90,120},
	jyjc={10,30,60,90,120},
	shjm={10,30,60,90,120},
	grjndj={1,3,5,7,11},
	wlbjgl={5,10,15,25,35},
	wlbjsh={20,50,150,250,350},
	mfbjgl={5,10,15,25,35},
	mfbjsh={20,50,150,250,350},
	lqsj={3,5,7,9,11}

}

--词条的属性值，
--得到的数值与品阶范围随机值相乘，保留两位小数点
_G.Sq_pz={
	300,
	200,
	100,
	40,
	7,
	1
}

_G.Sq_qz={
	30,
	6,
	1
}




function itemgivesq(hero)
	local level = Weightsgetvalue_one(Sq_qz)

	if level > 3 then
		level = 3
	end
	local itemName= "item_sq_"..level.."_"..RandomInt(1,9).."_1"
	local newItem = CreateItem(itemName, hero, hero )	
	TimerUtil.createTimerWithDelay(0.5,function()  --延迟给物品，不然会明显卡顿
		hero:AddItem(newItem)				
	end)	
end
