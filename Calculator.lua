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

function calculator_index.String_To_Postfix(self, str)
    local tokens = Queue()

    -- "(\+|-|\*|\/|\^|%|\(|\)){1}"

    for token in string.gmatch(str, "[%+,%-,%*,/,^,%%,%(,%),%d*%.?%d+]") do -- tokenize. pattern means any operational character or number with optional decimals
        tokens:Enqueue(token)
    end


    self:Tokens_To_Postfix(tokens)
end

calculator_meta.__index = calculator_index

Calculator = {}

setmetatable(Calculator,calculator_meta)