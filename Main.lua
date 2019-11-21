require('Calculator')

local c = Calculator()

local argument = ""

for i=1,#arg do
    local e = arg[i]
    argument = argument .. e .. " "
end

argument = argument:gsub("^%s*(.-)%s*$", "%1") -- trim

local result

local status, err = pcall(function()
    c:String_To_Postfix(argument)
    result = c:Calculate()
end)

if status then
    print(result)
else
    print("Error in calculating expression.\n\t" .. err .. "\nMake sure expression is valid and space delimited.")
end