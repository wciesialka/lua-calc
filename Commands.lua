require("Stack")

local command_meta = {}

function command_meta.New(self,stk)
    local command = {}

    if(stk == nil) then
        stk = Stack()
    end

    command.stack = stk

    setmetatable(command, command_meta)

    return command
end

command_meta.__call = command_meta.New

local command_index = {}

function command_index.Execute(self)
    local v2 = self.stack:Pop()
    local v1 = self.stack:Pop()
    local result = self:Evaluate(v1,v2)

    self.stack:Push(result)
end

command_meta.__index = command_index

Command = {}

setmetatable(Command, command_meta)

-- builder

local function copy_table(tab)
    local copy

    if type(tab) == "table" then
        copy = {}

        for k, v in next, tab, nil do           -- iterate through list
            copy[copy_table(k)] = copy_table(v) -- copy keys and values
        end
        setmetatable(copy, copy_table(getmetatable(tab))) -- make sure we copy metatable
    else
        copy = tab -- in case tab isn't a table, we also copy the value
    end

    return copy
end

local function Operator(_precedence,_evaluate) -- this function will let us create
    local Operator_Command = {}                -- operator "classes" much easier.
                                               -- it is almost an example of inheritance.
    local operator_meta = {}

    function operator_meta.New(self,stk)       -- here we have our base constructor
        local operator = {}

        if(stk == nil) then
            stk = Stack()
        end

        operator.stack = stk
        operator.precedence = _precedence      -- we set the precedence as neccessary

        setmetatable(operator, operator_meta)

        return operator
    end

    operator_meta.__call = operator_meta.New

    operator_meta.__index = copy_table(command_index)

    function operator_meta.__index.Evaluate(self,v1,v2)
        return _evaluate(v1,v2)                -- we set the evaluate function of the
    end                                        -- operator class to a call to the func
                                               -- we pass in
    setmetatable(Operator_Command, operator_meta) 

    return Operator_Command                    -- here we return the 'class' so that we
end                                            -- may call it like a class.

-- commands

Add_Command = Operator(1,function(v1,v2)
    return v1 + v2
end)

Subtract_Command = Operator(1,function(v1,v2)
    return v1 - v2
end)

Multiply_Command = Operator(2,function(v1,v2)
    return v1 * v2
end)

Divide_Command = Operator(2,function(v1,v2)
    if v2 == 0 then
        error("Cannot Divide by Zero!")
    else
        return v1/v2
    end
end)

Modulo_Command = Operator(2,function(v1,v2)
    if v2 == 0 then
        error("Cannot Modulo by Zero!")
    else
        return v1%v2
    end
end)

Exponent_Command = Operator(3,function(v1,v2)
    return v1 ^ v2
end)

-- value command

local value_meta = {}

function value_meta.New(self,stk,val)
    local command = {}

    if(stk == nil) then
        stk = Stack()
    end

    command.stack = stk
    command.value = val

    setmetatable(command, value_meta)

    return command
end

value_meta.__call = value_meta.New

local value_index = {}

function value_index.Execute(self) -- execute should just push itself onto the stack
    self.stack:Push(self.value)    -- since it's just a number
end

value_meta.__index = value_index

Value_Command = {}

setmetatable(Value_Command, value_meta)