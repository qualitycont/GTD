function _openMenu()
    local perks = GAMEMODE.PerkManager.GetAll()

    local mainframe = vgui.Create("DFrame")
    mainframe:SetBackgroundBlur(true)
    mainframe:SetSize(800,600)
    mainframe:SetTitle("Perk Selection")
    mainframe:Center()
    mainframe:MakePopup()

    local perklist = vgui.Create("DListView", mainframe)
    perklist:Dock( LEFT )
    perklist:SetMultiSelect(false)
    perklist:SetWidth( mainframe:GetWide() / 2 )
    perklist:SetDataHeight(25)

    perklist:AddColumn("Name", 1)
    perklist:AddColumn("Description", 2)
    perklist:AddColumn("Class", 3)
    perklist:AddColumn("Level", 4)

    local keycolumn = perklist:AddColumn("key", 5)
    keycolumn:SetMaxWidth(0)

    for k, v in pairs(perks) do
        perklist:AddLine(v.DisplayName, v.Description, v.Class, v.Level,k )
    end
end

net.Receive("gtd_f4", _openMenu)