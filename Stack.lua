local stack_meta = {}

function stack_meta.New(self)
    local stack = {} -- create queue

    stack.a = {} -- create a table to use to store elements of the queue
    
    setmetatable( stack, stack_meta ) -- set the queue's metatable

    return stack -- return the queue
end

stack_meta.__call = stack_meta.New -- this lets us use the metatable like a constructor

function stack_meta.__tostring( self )
    local s = ""
    if #self.a > 0 then
        for i=1,#self.a do
            s = s .. "Element #" .. i .. ":\t" .. self:Get(i) .. "\n"
        end
    else
        s = "Stack is empty."
    end
    return s
end

local stack_meta_index = {}

function stack_meta_index.Get( self,i )
    return self.a[i]
end

function stack_meta_index.Push(self, e)
    table.insert(self.a,e) -- if we use table.insert without a position index it inserts to end, a push
end

function stack_meta_index.Pop(self, e)
    if #self.a > 0 then
        return table.remove(self.a,#self.a) -- remove the last element of a and return it.
    else
        error("Cannot pop from empty stack.")
    end
end

stack_meta.__index = stack_meta_index -- we set the __index function to our index table so we can use the functions we just created

Stack = {}

setmetatable(Stack, stack_meta) -- these last two lines actually make our "class"