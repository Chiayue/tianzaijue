function string.trim(s)
    return s:match "^%s*(.-)%s*$"
end

function string.pipei(s, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(s, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function string.split(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end
    
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


function Weightsgetvalue_one_key(wtable,pronum)
    local rtable={}
    local lintable={}
    local endtable={}
    if pronum==0 then
        return endtable
    end
    for k,v in pairs(wtable) do
        lintable[k]=v
    end
    --print("===")
    --PrintTable(lintable)
    for i=1,pronum do
        local num=0
        local weight=0
        local valuetable={}
        for k,v in pairs(lintable) do
            lintable[k]=v
            local cc={}
            if v==0 then
                cc={0,0}
                rtable[k]=cc
            else
                table.insert(cc,weight+1)
                weight=v+weight
                table.insert(cc,weight)
                rtable[k]=cc
            end
        end
        local randomvalue=RandomInt(1, math.max(weight))
        
        for k,v in pairs(rtable) do
            
            if randomvalue>=v[1] and randomvalue<=v[2] then
                num=k
            end
        end
        
        table.insert(endtable,num)
        --lintable[num]=nil

    end
    
   
    return endtable
end
function Weightsgetvalue_one_keyss(wtable,pronum)
    local rtable={}
    local lintable={}
    local endtable={}
    if pronum==0 then
        return endtable
    end
    for k,v in pairs(wtable) do
        lintable[k]=v
    end
    --print("===")
    --PrintTable(lintable)
    for i=1,pronum do
        local num=0
        local weight=0
        local valuetable={}
        for k,v in pairs(lintable) do
            lintable[k]=v
            local cc={}
            if v==0 then
                cc={0,0}
                rtable[k]=cc
            else
                table.insert(cc,weight+1)
                weight=v+weight
                table.insert(cc,weight)
                rtable[k]=cc
            end
        end
        local randomvalue=RandomInt(1, math.max(weight))
        
        for k,v in pairs(rtable) do
            
            if randomvalue>=v[1] and randomvalue<=v[2] then
                num=k
            end
        end
        
        table.insert(endtable,num)
        lintable[num]=nil

    end
    
   
    return endtable
end
function Weightsgetvalue_one_se(wtable)
    local num=0
    local weight=0
    local valuetable={}
    for k,v in pairs(wtable) do
        local cc={}
        if v==0 then
            cc={0,0}
            table.insert(valuetable,cc)
        else
            table.insert(cc,weight+1)
            weight=v+weight
            table.insert(cc,weight)
            table.insert(valuetable,cc)
        end
    end
    if weight==0 then
        return num
    end
    local randomvalue=RandomInt(1, math.max(weight, 100))
    for k,v in pairs(valuetable) do
        
        if randomvalue>=v[1] and randomvalue<=v[2] then
            num=k
        end
        
    end

    return num
end
function table_repeat_no(wtable,num)
    
    local weight=0
    local valuetable={}
    local resulttable={}

    for k,v in pairs(wtable) do
        table.insert(valuetable,v)
    end
    
    for i=1,num do
      
        local randomint=RandomInt(1,#valuetable)
      
        table.insert(resulttable,valuetable[randomint])
        table.remove(valuetable,randomint)
    end
    
    return resulttable
end

function EachPlayer(teamNumber, func)
	if type(teamNumber) == "function" then
		func = teamNumber
		teamNumber = DOTA_TEAM_GOODGUYS
	end
	for n = 1, PlayerResource:GetPlayerCountForTeam(teamNumber), 1 do
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNumber, n)
		if PlayerResource:IsValidPlayerID(playerID) then
			if func(n, playerID) == true then
				break
			end
		end
	end
end

--随机不重复
function RandomNoRepeat(wtable,num)
    local valuetable={}
    local resulttable={}
    
    for k,v in pairs(wtable) do
        table.insert(valuetable,v) 
    end
    
    for i=1,num do
    	if #valuetable == 0 then
    		break;
    	end
       local idx = RandomInt(1,#valuetable);
       table.insert(resulttable,table.remove(valuetable,idx))
    end
   

    return resulttable
end
--字符串分割
function lua_string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end