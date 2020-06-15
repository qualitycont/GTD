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