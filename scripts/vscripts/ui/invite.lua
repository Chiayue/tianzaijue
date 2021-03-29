if Invite == nil then
   Invite = {}
   Invite.PlayerInvite = {}
   Invite.SamePlayerList = {}
   setmetatable(Invite,Invite)
end
function Invite:init(playerid,data)
    --print(playerid)
   -- PrintTable(data)
    Invite.PlayerInvite[playerid]=data
    
    Invite:tzj_invite_init({PlayerID=playerid})
end
function Invite:Getinviteinfo(playerid)
    return Invite.PlayerInvite[playerid]
end
--*初始化

--UI发送事件：tzj_invite_init ，界面加载完毕会调用这个方法向服务器发送请求，服务器接收到以后，返回下面的数据
--UI响应事件：tzj_invite_init_return ,数据：
--{
--	aid="xxxxxxx", --返回请求玩家的accountID，使用PlayerUtil可获得
--UI响应事件：tzj_invite_count_update ,数据： {count=123,rewarded={1="2021-01-01 12:52:52",3="2021-01-01 12:52:52",4="2021-01-01 12:52:52"}}
--	invite_count = {}, --累计邀请数量和奖励信息，数据内容参考tzj_invite_count_update的返回值
	--invite_reward = {}, --激活邀请码领取到的奖励信息，内容参考tzj_invite_reward_update的返回值
--} 
function Invite:tzj_invite_init(data)
    --print('inviteinit')
    local playerdata=Invite:Getinviteinfo(data.PlayerID)
    local invite_reward={}
    if playerdata.bind then
        invite_reward.bind=playerdata.bind.code
        local players = PlayerUtil.GetAllPlayersID(false,true)
        for _, PlayerID in pairs(players) do
            if playerdata.bind.code==PlayerUtil.GetAccountID(PlayerID,true) then
                Invite.SamePlayerList[PlayerUtil.GetAccountID(PlayerID,true)]=1
                Invite.SamePlayerList[PlayerUtil.GetAccountID(data.PlayerID,true)]=1
            end
        end
    end
    if playerdata.actived then
        invite_reward.actived={}
        for k,v in pairs(playerdata.actived) do
            invite_reward.actived[k]={}
            invite_reward.actived[k]['inviter']=v.name
            invite_reward.actived[k]['code']=v.code
            invite_reward.actived[k]['content']=v.reward
            invite_reward.actived[k]['time']=v.time
        end
    end
    local invite_count = {}
    if playerdata.count and  playerdata.count.count then
        invite_count['count']=playerdata.count.count
    end
    if playerdata.count and playerdata.count.reward then
        invite_count['rewarded']=playerdata.count.reward
    else
        invite_count['rewarded']={}
    end
    SendToClient(data.PlayerID,"tzj_invite_init_return",{aid=PlayerUtil.GetAccountID(data.PlayerID,true),invite_count=invite_count,invite_reward=invite_reward})
end
--获取该玩家是否在同一局而获得经验和晶石加成
function Invite:IsSameList(playerid)
    
    if Invite.SamePlayerList[PlayerUtil.GetAccountID(playerid,true)] then
        return true
    end
    return false
end
--[[*激活邀请码

UI发送事件：tzj_invite_active ,数据： {code="xxxxxxxxx",bind=true/false}，code是邀请码，bind代表是否是绑定玩家的

UI响应事件：tzj_invite_active_return ,数据： 
{
	success=true/false, --激活结果
	bind="xxxxxxx", --如果是绑定玩家类的，返回绑定的玩家id，和reward不共存
	reward={  --如果是普通的邀请码，返回相关信息，和bind不共存
		inviter = "xxxx", --邀请者的名字
		code = "xxxxxx",--邀请码 
		content = { --奖励内容，结构和累计邀请的一致
			jing = 100,
			plus = 3,
			shopmall_1 = 1
		}，
		time = "2021-01-01 12:52:52"
	},
	info = "#xxxxxx" --如果激活失败，这个是对应的国际化信息的key
	infoKV = {k=v} --如果国际化比较复杂，需要格式化（国际化中使用了{s:xxx}），则添加这一项来传递格式化用的数据
} ]]
function Invite:tzj_invite_active(data)
    local bindReward={}
    bindReward["jing_stone"] = { --商品名称（商城道具），晶石奖励则名称固定为： jing_stone
		count=2000,
    }
    
    if	data.bind==1 then
        SrvInvite.BindPlayer(data.PlayerID,data.code,bindReward,function(success,arg2,arg3) 
            if success==true then
                if arg2.jing then
                    Shopmall:SetStone(data.PlayerID,"3",2,arg2.jing)
                end
                if arg2.items then
                    for k,v in pairs(arg2.items) do
                        Shopmall:UpdatePlayerdata( data.PlayerID,k,v.stack,v.invalid_time)  --刷新商城物品
                    end
                end 
                local alldata={}
                alldata.success=true
                alldata.bind=arg2.invite.code --如果是绑定玩家类的，返回绑定的玩家id，和reward不共存
                local players = PlayerUtil.GetAllPlayersID(false,true)
                for _, PlayerID in pairs(players) do
                    if tonumber(arg2.invite.code)==tonumber(PlayerUtil.GetAccountID(PlayerID,true)) then
                        Invite.SamePlayerList[PlayerUtil.GetAccountID(PlayerID,true)]=1
                        Invite.SamePlayerList[PlayerUtil.GetAccountID(data.PlayerID,true)]=1
                    end
                end
                if arg3 then
                    Invite:invite_count_update(arg3.pid,arg3.inviteCount)
                end
                --Invite:invite_reward_update(1,alldata.bind)
                alldata.info = "#invite_success" --如果激活失败，这个是对应的国际化信息的key
                alldata.infoKV = {} --如果国际化比较复杂，需要格式化（国际化中使用了{s:xxx}），则添加这一项来传递格式化用的数据
                SendToClient(data.PlayerID,"tzj_invite_active_return",alldata)
            else
                print("BindPlayer",success,arg2)
                local alldata={}
                alldata.success=success
                --0（未知错误），1（参数错误），2（要绑定的玩家不存在，必须是玩过一次游戏的才能被绑定），3（已经绑定了某个玩家了）,4（不能绑定自己）
                alldata.info = "#invite_fail"..arg2 --如果激活失败，这个是对应的国际化信息的key
                alldata.infoKV = {} --如果国际化比较复杂，需要格式化（国际化中使用了{s:xxx}），则添加这一项来传递格式化用的数据
                SendToClient(data.PlayerID,"tzj_invite_active_return",alldata)
            end
        
        
        
        end)
        
    else
       
        ---激活平台类的邀请码
        --@param #number PlayerID 玩家id
        --@param #string code 邀请码
        --@param #function callback 回调函数：success,arg2
        --如果success=true，则arg2是一个表，里面包含相关数据的最新值：邀请码使用结果、晶石总量、商城物品数据等
        --如果success=false，则arg2代表错误代码。0=未知错误，1=参数错误（玩家id或者邀请码为空），2=邀请码不存在或已失效，3=已使用过该邀请码
        SrvInvite.ActivePlatform(data.PlayerID,data.code,function(success,arg2) 
            if success==true then
                local alldata={}
                alldata.success=true
                alldata.reward={  --如果是普通的邀请码，返回相关信息，和bind不共存
                    inviter = arg2.invite.name, --邀请者的名字
                    code = arg2.invite.code,--邀请码 
                    content = arg2.invite.reward,
                    time = arg2.invite.time
                }
                --Invite:invite_reward_update(0,alldata.reward)
                alldata.info = "#invite_success" --如果激活失败，这个是对应的国际化信息的key
                alldata.infoKV = {} --如果国际化比较复杂，需要格式化（国际化中使用了{s:xxx}），则添加这一项来传递格式化用的数据
                if arg2.jing then
                    Shopmall:SetStone(data.PlayerID,"3",2,arg2.jing)
                end
                if arg2.items then
                    for k,v in pairs(arg2.items) do
                        Shopmall:UpdatePlayerdata( data.PlayerID,k,v.stack,v.invalid_time)  --刷新商城物品
                    end
                end 
                SendToClient(data.PlayerID,"tzj_invite_active_return",alldata)
            else
                print("BindPlatform",success,arg2)
                local alldata={}
                alldata.success=success
                --0（未知错误），1（参数错误），2（要绑定的玩家不存在，必须是玩过一次游戏的才能被绑定），3（已经绑定了某个玩家了）,4（不能绑定自己）
                alldata.info = "#InvitePlatform_fail"..arg2 --如果激活失败，这个是对应的国际化信息的key
                alldata.infoKV = {} --如果国际化比较复杂，需要格式化（国际化中使用了{s:xxx}），则添加这一项来传递格式化用的数据
                SendToClient(data.PlayerID,"tzj_invite_active_return",alldata)
            end
        end)
    end
    
    
end
--[[玩家领取阶段奖励
UI发送事件：tzj_invite_count_reward ,数据： {stage=1}

UI响应事件：tzj_invite_count_reward_return ,数据： {stage=1,success=true/false,count=123} 
其中count是在失败的时候返回实际的邀请数量，用来更新界面（主要是解决跨月的时候，界面显示的邀请数量和实际不符的情况）]]

function Invite:tzj_invite_count_reward(data)
    local playerdata=Invite:Getinviteinfo(data.PlayerID)
    local tempdata=CustomNetTables:GetTableValue( "config", "invite_stage")
    if playerdata.count.count<tempdata[tostring(data.stage)]['count'] then
        SendToClient(data.PlayerID,"tzj_invite_count_reward_return",{stage=data.stage,success=false,count=playerdata.count.count})
        return 
    end
    local reward={}
    for k, v in pairs(tempdata[tostring(data.stage)]['reward']) do
        reward[k]={}
        reward[k]['count']=v
        if Shopmall:IsUnique( k ) then
            reward[k]['count']=nil
        end
        if k=="plus" then
           reward[k]['valid']=v
           local itemdata=Shopmall:GetMallState(data.PlayerID)
            if SrvStore.IsPermanent(itemdata[SrvStore.NAME_PLUS]) then --如果是永久有效的通行证则返回，不领取
                reward[k]=nil
            end
        end
    end
    SrvInvite.getReward(data.PlayerID,data.stage,tempdata[tostring(data.stage)]['count'],reward,function(success,arg2,arg3)
        if success then
            if arg2.jing then
                Shopmall:SetStone(data.PlayerID,"invite",2,arg2.jing)
            end
            if arg2.items then
                for k,v in pairs(arg2.items) do
                    Shopmall:UpdatePlayerdata( data.PlayerID,k,v.stack,v.invalid_time)  --刷新商城物品
                end
            end 
	        SendToClient(data.PlayerID,"tzj_invite_count_reward_return",{stage=data.stage,success=true,time=arg2.time})
        else
	        SendToClient(data.PlayerID,"tzj_invite_count_reward_return",{stage=data.stage,success=false,count=arg3})
        end
    end)
    
end
--刷新玩家邀请数量和奖励领取情况
--UI响应事件：tzj_invite_count_update ,数据： {count=123,rewarded={1="2021-01-01 12:52:52",3="2021-01-01 12:52:52",4="2021-01-01 12:52:52"}}
--其中count代表总邀请数量，rewarded代表已经领取过奖励的阶段和领取时间
function Invite:invite_count_update(playerid,count)
    local playerdata=Invite:Getinviteinfo(playerid)
    local invite_count = {}
    invite_count['count']=count
    if playerdata.count and playerdata.count.reward then
        invite_count['rewarded']=playerdata.count.reward
    else
        invite_count['rewarded']={}
    end
    SendToClient(playerid,"tzj_invite_count_update",{invite_count})
end
--[[*被邀请奖励界面（使用邀请码的领取过的奖励数据）

UI响应事件：tzj_invite_reward_update ,数据： 
{
	bind="123456", --绑定玩家的id，没有就不传。当只是激活普通的邀请码的时候，不用传这个。
	actived={--激活的所有邀请码信息，是一个数组，有多少条记录，就往“我的奖励”界面插多少条数据。当激活的是绑定玩家类型的邀请码的时候，不用传这个
		{
			inviter = "xxxx", --邀请者的名字
			code = "xxxxxx",--邀请码
			content = { --奖励内容，结构和累计邀请的一致
				jing = 100,
				plus = 3,
				shopmall_1 = 1
			}，
			time = "2021-01-01 12:52:52"
		}
	}
}
其中count代表总邀请数量，actived代表激活过的邀请码数据]]
function Invite:invite_reward_update(bind,data)
        local alldata={}
        if bind==1 then
            alldata.bind=data
        else
            alldata.actived=data
        end
        SendToClient(data.PlayerID,"tzj_invite_reward_update",{alldata})
end
CustomGameEventManager:RegisterListener("tzj_invite_init",Dynamic_Wrap(Invite,"tzj_invite_init"))
CustomGameEventManager:RegisterListener("tzj_invite_active",Dynamic_Wrap(Invite,"tzj_invite_active"))
CustomGameEventManager:RegisterListener("tzj_invite_count_reward",Dynamic_Wrap(Invite,"tzj_invite_count_reward"))
