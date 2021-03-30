local f = require('lua/demo/functions')

local Base = class('Base')

function Base:ctor(id)
    self.id = id
    -- error('test',1) 自定义错误
end

function Base:say()
    print('I\'m',self.id)
end

local b = Base.new(123)
b:say()

local c = clone(b)

dump(b)
dump(c)

--[[
local a = 10;
local b = 20;
local c = a + b;

print(a,b,c);
print(("%d"):format(5)) --> 5


for i = 0, 10, 1 do
    if i > 8
    then
        print(i)
    end
end

a = {"one", "two", "three"}
for i, v in ipairs(a) do
    print(i, v)
end 


local rsfile = io.popen('ls -hal')
local rschar = rsfile:read("*all")
print(rschar)

print(os.clock())

local function add(a,b)
   assert(type(a) == "number", "a 不是一个数字")
   assert(type(b) == "number", "b 不是一个数字")
   return a+b
end

print(add(1,2))

-- local array = {"Lua", "Tutorial"}
-- for i= 0, 2 do
--    print(array[i])
-- end

-- for k, v in pairs(package) do
--     print(k, v)
-- end

local function square(iteratorMaxCount,currentNumber)
    if currentNumber<iteratorMaxCount
    then
       currentNumber = currentNumber+1
    return currentNumber, currentNumber*currentNumber
    end
 end

 for i,n in square,3,0
 do
    print(i,n)
 end

]]
