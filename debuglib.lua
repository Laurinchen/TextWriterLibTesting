---@param indend integer
---@param ... string
---@return string
function IndentConcat(indend, ...)
    ---@type string[]
    local indends = {};
    for _ = 1, indend do
        table.insert(indends, "\t");
    end
    return table.concat(indends) .. table.concat(table.pack(...))
end


---@param t table
---@param indend? integer
---@return string
function Dump(t, indend)
    local any_useful_stuff = false;
    for _, value in pairs(t) do
        if type(value) ~= "function" then
            any_useful_stuff = true
            goto end_check;
        end
    end
    ::end_check::

    if not any_useful_stuff then
        return "{}"
    end

    indend = indend or 0
    local x = "{\n" .. IndentConcat(indend + 1);
    ---@type boolean
    local item_exists = false
    for key, value in pairs(t) do
        if type(value) == "function" then
            goto con;
        end
        if type(key) == "table" then
            x = x .. Dump(key, indend+1)
        elseif type(key) == "string" then
            x = table.concat({x, '"', key, '"'})
        else
            x = x .. tostring(key)
        end
        x = x .. "=";
        if type(value) == "table" then
            x = x .. Dump(value, indend+1)
        elseif type(value) == "string" then
            x = table.concat({x, '"', value, '"'});
        else
            x = x .. tostring(value)
        end
        x = x .. ',\n' .. IndentConcat(indend + 1);
        ::con::
    end
    x = x:sub(0, #x - 3 - indend) .. '\n' .. IndentConcat(indend) .. '}';
    return x
end

