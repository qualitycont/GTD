GM.Util = GM.Util or {}
local util = GM.util

function util:TableLen(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end