local queue_meta = {}

function queue_meta.New(self)
    local queue = {} -- create queue

    queue.a = {} -- create a table to use to store elements of the queue
    
    setmetatable( queue, queue_meta ) -- set the queue's metatable

    return queue -- return the queue
end

queue_meta.__call = queue_meta.New -- this lets us use the metatable like a constructor

function queue_meta.__tostring( self )
    local s = ""
    if #self.a > 0 then
        for i=1,#self.a do
            s = s .. "Element #" .. i .. ":\t" .. self:Get(i) .. "\n"
        end
    else
        s = "Queue is empty."
    end
    return s
end

local queue_meta_index = {}

function queue_meta_index.Get( self,i )
    return self.a[i]
end

function queue_meta_index.Enqueue(self, e)
    table.insert(self.a,e) -- if we use table.insert without a position index it inserts to end, a push
end

function queue_meta_index.Dequeue(self, e)
    if #self.a > 0 then
        return table.remove(self.a,1) -- remove the first element of a and return it.
    else
        error("Cannot dequeue from empty queue.")
    end
end

function queue_meta_index.Peek(self)
    return self.a[1]
end

function queue_meta_index.Is_Empty(self)
    return #self.a == 0
end

queue_meta.__index = queue_meta_index -- we set the __index function to our index table so we can use the functions we just created

Queue = {}

setmetatable(Queue, queue_meta) -- these last two lines actually make our "class"