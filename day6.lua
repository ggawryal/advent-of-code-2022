local K = 14

local file = io.open("input/day6.in", "rb")
if not file then return nil end
local s = file:read "*all"
file:close()

a = {}
for c = 0,26 do
    a[c+string.byte('a')] = 0
end  


for i = 1,K do
    local c = string.byte(s:sub(i,i))
    a[c] = a[c] + 1
end

for i = K,#s do
    local good = 1 
    for j = 0,26 do
        if(a[j + string.byte('a')] > 1) then
            good = 0
        end 
    end
    if(good == 1) then
        print(i)
        break
    end

    local old = string.byte(s:sub(i-K+1,i-K+1))
    a[old] = a[old] - 1
    if(i ~= #s) then  
        local new = string.byte(s:sub(i+1,i+1))
        if(new >= string.byte('a') and new <= string.byte('z')) then
            a[new] = a[new] + 1
        end
    end
end