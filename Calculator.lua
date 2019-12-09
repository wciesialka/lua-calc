require('Factory')
require('Queue')

calculator_meta = {}

function calculator_meta.New(self)
    
    local calculator = {}

    calculator.postfix = Queue()
    calculator.stack = Stack()
    calculator.factory = Factory(calculator.stack)

    setmetatable(calculator, calculator_meta)

    return calculator
end

calculator_meta.__call = calculator_meta.New

calculator_index = {}

function calculator_index.Calculate(self)
    while not (self.postfix:Is_Empty()) do
        self.postfix:Dequeue():Execute()
    end

    return self.stack:Peek()
end

function calculator_index.Tokens_To_Postfix(self, tokens)
    local expression = Stack()
    local node

    while not (tokens:Is_Empty()) do
        local token = tokens:Dequeue()

        if token == "+" then
            node = self.factory:Create_Add()
        elseif token == "-" then
            node = self.factory:Create_Subtract()
        elseif token == "*" then
            node = self.factory:Create_Multiply()
        elseif token == "/" then
            node = self.factory:Create_Divide()
        elseif token == "%" then
            node = self.factory:Create_Modulo()
        elseif token == "^" then
            node = self.factory:Create_Exponent()
        elseif token == "(" then
            self:Tokens_To_Postfix(tokens)
            goto next_iter -- we use this since Lua has no "continue" statement.
        elseif token == ")" then
            while not (expression:Is_Empty()) do
                self.postfix:Enqueue(expression:Pop())
            end
            return
        else -- values
            local i = tonumber(token)
            node = self.factory:Create_Value(i)
            self.postfix:Enqueue(node)
            goto next_iter
        end
        
        while (not (expression:Is_Empty()) and (expression:Peek().precedence >= node.precedence)) do -- this accounts for order of operations.
            self.postfix:Enqueue(expression:Pop())
        end

        expression:Push(node)

        ::next_iter::
    end

    while not (expression:Is_Empty()) do
        self.postfix:Enqueue(expression:Pop())
    end
end

local function tokenize(input)
    local ops = {}
    for match in input:gmatch("[%+,%-,%*,/,^,%%,%(,%)]") do
        table.insert( ops, #ops+1, match ) -- fill ops table with operators
    end
    local nums = {}
    for match in input:gmatch("%d*%.?%d+") do
        table.insert( nums, #nums+1, match ) -- fill nums table with numbers
    end

    local tokens = Queue()

    local lastindex = 0

    while(#ops > 0 and #nums > 0) do -- while neither are empty...
        local opindex = input:find(ops[1],lastindex) -- find the next occurance of first operator in list
        local nmindex = input:find(nums[1],lastindex) -- find the next occurance of first number in list
        if nmindex < opindex then -- if number comes first
            lastindex = opindex -- search from next operator
            tokens:Enqueue(nums[1]) -- enqueue number
            table.remove( nums, 1 )
        else
            lastindex = nmindex -- else search from next number
            tokens:Enqueue(ops[1])
            table.remove( ops, 1 )
        end
    end

    while(#ops > 0) do -- fill queue with anything remaining
        tokens:Enqueue(ops[1])
        table.remove(ops,1)
    end

    while(#nums > 0) do
        tokens:Enqueue(nums[1])
        table.remove(nums,1)
    end
    
    return tokens
end

function calculator_index.String_To_Postfix(self, str)
    local tokens = tokenize(str)

    self:Tokens_To_Postfix(tokens)
end

calculator_meta.__index = calculator_index

Calculator = {}

setmetatable(Calculator,calculator_meta)