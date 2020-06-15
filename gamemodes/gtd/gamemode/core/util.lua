GM.Util = GM.Util or {}
local util = GM.Util

function util:JSONAndCompress(table)
    table = util.TableToJSON(table)
    return util.Compress(table)
end

function util:CompressedToTable(compressed)
    str = util.Decompress(compressed)
    return util.JSONToTable(str)
end

function util:Deviation(pass, cur) -- cur is an internal argument to pass on the current number
    cur = cur or 1
    local deviation = GM.Config.Deviation
    
    deviation = cur * math.Rand(1-deviation, 1+deviation)
    if !pass or pass == 0 then return deviation end
    self:Deviation(pass-1,deviation)
end