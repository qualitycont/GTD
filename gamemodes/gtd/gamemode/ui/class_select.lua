local panelColor = Color(50, 50, 50, 200)
local function _openMenu()
    local main = vgui.Create("DFrame")
    main:SetSize(ScrW()/2, ScrH()/2)
    main:SetBackgroundBlur(true)
    main:ShowCloseButton(true)
    main:Center()
    main:SetTitle("Class Selection")
    main:Center()
    main:MakePopup()

    local rightsub = vgui.Create("DPanel", main)
    rightsub:Dock(RIGHT)
    rightsub:SetSize(main:GetWide()/2,main:GetTall())

    local classlist = vgui.Create("DListView", rightsub)
    classlist:Dock(TOP)
    classlist:SetMultiSelect(false)
    classlist:SetHeight( rightsub:GetTall()-40 )
    local name = classlist:AddColumn("Name", 1)
    name:SetMaxWidth(rightsub:GetWide()/4)
    classlist:AddColumn("Description", 2)
    local keys = classlist:AddColumn("key", 3)
    keys:SetMaxWidth(0)
    local models = classlist:AddColumn("models", 4)
    models:SetMaxWidth(0)

    local classes = GAMEMODE.ClassManager.GetAll()
    if istable(classes) then
        for k,v in pairs(classes) do
            if k == "none" then continue end
            classlist:AddLine(v.DisplayName,v.Description,k,v.Model)
        end
    end

    local modelPreview = vgui.Create("DModelPanel",  main)
    modelPreview:Dock(LEFT)
    modelPreview:SetWidth(main:GetWide()/2)
    modelPreview:SetModel(LocalPlayer():GetModel())

    classlist.OnRowSelected = function(panel, index)
        local row = classlist:GetLine(index)
        modelPreview:SetModel(row:GetValue( 4 ))
    end

    local selectButton = vgui.Create("DButton",rightsub)
    selectButton:Dock(BOTTOM)
    selectButton:SetHeight(40)
    selectButton:SetText("Switch to Class")
    selectButton.DoClick = function()
        local _, selectedLine = classlist:GetSelectedLine()
        local key = selectedLine:GetValue(3)
        RunConsoleCommand("td_class", key)
    end
end

net.Receive("td_f2", function()
    _openMenu()
end)