require("Commands")

local factory_meta = {}

function factory_meta.New(self,stk)

    if (stk==nil) then
        stk = Stack()
    end

    local factory = {}

    factory.stack = stk

    setmetatable(factory, factory_meta)

    return factory
end

factory_meta.__call = factory_meta.New

local factory_index = {}

function factory_index.Create_Add(self)
    return Add_Command(self.stack)
end

function factory_index.Create_Subtract(self)
    return Subtract_Command(self.stack)
end

function factory_index.Create_Multiply(self)
    return Multiply_Command(self.stack)
end

function factory_index.Create_Divide(self)
    return Divide_Command(self.stack)
end

function factory_index.Create_Modulo(self)
    return Modulo_Command(self.stack)
end

function factory_index.Create_Value(self,v)
    return Value_Command(self.stack,v)
end

factory_meta.__index = factory_index

Factory = {}

setmetatable(Factory, factory_meta)