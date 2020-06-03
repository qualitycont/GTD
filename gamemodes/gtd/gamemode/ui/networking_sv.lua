util.AddNetworkString("gtd_f1")
util.AddNetworkString("gtd_f2")
util.AddNetworkString("gtd_f3")
util.AddNetworkString("gtd_f4")

function GM:ShowHelp(ply)
    net.Start("gtd_f1")
    net.Send(ply)
end

function GM:ShowTeam(ply)
    net.Start("gtd_f2")
    net.Send(ply)
end

function GM:ShowSpare1(ply)
    net.Start("gtd_f3")
    net.Send(ply)
end

function GM:ShowSpare2(ply)
    net.Start("gtd_f4")
    net.Send(ply)
end