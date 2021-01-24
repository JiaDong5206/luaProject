util = {}

function util.tostring_table(table, str)
    str = str or "";
    if type(table) == "table" then
        str = str .. "{\n"
        for k, v in pairs(table) do
            local value
            if type(v) == "table" then
                value = util.tostring_table(v)
            else
                value = v;
            end
            str = str .. k .. "=" .. value .. ",\n"
        end
        str = str .. "}\n"
    end
    return str
end

return util;
