require('Calculator')

local c = Calculator()

local argument = ""

for i=1,#arg do             -- combine all arguments after the first (which is script name)
    local e = arg[i]        -- into one string
    argument = argument .. e
end

argument = argument:gsub("%s", "") -- remove spaces/whitespace characters

local result

local status, err = pcall(function()  -- try/catch
    c:String_To_Postfix(argument)
    result = c:Calculate()
end)

if status then
    print(result)
else
    print("Error in calculating expression.\n\t" .. err .. "\nMake sure expression is valid/balanced.")
end