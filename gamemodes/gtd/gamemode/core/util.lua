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

function util:Deviation() -- cur is an internal argument to pass on the current number
    local deviation = GAMEMODE.Config.Deviation
    
    deviation = math.Rand(1-deviation, 1+deviation)
    return deviation
end