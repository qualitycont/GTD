util.AddNetworkString("td_f1")
util.AddNetworkString("td_f2")
util.AddNetworkString("td_f3")
util.AddNetworkString("td_f4")

function GM:ShowHelp(ply)
    net.Start("td_f1")
    net.Send(ply)
end

function GM:ShowTeam(ply)
    net.Start("td_f2")
    net.Send(ply)
end

function GM:ShowSpare1(ply)
    net.Start("td_f3")
    net.Send(ply)
end

function GM:ShowSpare2(ply)
    net.Start("td_f4")
    net.Send(ply)
end