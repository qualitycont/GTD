
function _openMenu()
    local perks = GAMEMODE.PerkManager.GetAll()

    local frame = vgui.Create("DFrame")
    frame:SetBackgroundBlur(true)
    frame:SetSize(ScrW()*0.32,ScrH()*0.3)
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame.Paint = function(s,w,h)
    end

    local scroll = vgui.Create("DHorizontalScroller",frame)
    scroll:Dock(FILL)
    scroll:SetOverlap(-5)

    local perkpanels = {}
    local c = 0
    for k,v in pairs(perks) do
        local p = vgui.Create("DPanel",scroll)
        scroll:AddPanel(p)
        p:SetSize(ScrW()*0.105,ScrH()*0.186)
        p.Paint = function(s,w,h)
            draw.RoundedBox(0,0,0,w*0.999,h,Color(75,75,75))
            draw.SimpleText(v.DisplayName, "DermaDefault", 50,50, Color( 255, 255, 255, 255 ))
        end

        local btn = p:Add("DButton")
        btn:Dock(FILL)
        btn:SetText("")
        btn.Paint = function(s,w,h)
        end

        btn.DoClick = function()

        end

        table.insert(perkpanels,p)
        c = c + 1
    end

    scroll.Paint = function(s,w,h)
        --draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
    end
    local scrollpos = 2
    function frame:OnKeyCodePressed(key)
        if key == KEY_D then 
            if (scrollpos + 2) > c then 
                scroll:ScrollToChild(perkpanels[2])
                scrollpos = 2
            else 
                scroll:ScrollToChild(perkpanels[scrollpos+2])
                scrollpos = scrollpos + 2
            end
        elseif key == KEY_A then 
            if (scrollpos - 2) <= 0 then 
                scroll:ScrollToChild(perkpanels[c-1])
                scrollpos = c-1
            else    
                scroll:ScrollToChild(perkpanels[scrollpos-2])
                scrollpos = scrollpos - 2
            end
        elseif key == KEY_F4 then 
            frame:Remove()
        end
    end
end
   
    -- local mainframe = vgui.Create("DFrame")
    -- mainframe:SetBackgroundBlur(true)
    -- mainframe:SetSize(800,600)
    -- mainframe:SetTitle("Perk Selection")
    -- mainframe:Center()
    -- mainframe:MakePopup()

    -- local perklist = vgui.Create("DListView", mainframe)
    -- perklist:Dock(LEFT)
    -- perklist:SetMultiSelect(false)
    -- perklist:SetWidth( mainframe:GetWide() / 2 )
    -- perklist:SetDataHeight(25)

    -- perklist:AddColumn("Name", 1)
    -- perklist:AddColumn("Description", 2)
    -- perklist:AddColumn("Class", 3)
    -- perklist:AddColumn("Level", 4)

    -- local keycolumn = perklist:AddColumn("key", 5)
    -- keycolumn:SetMaxWidth(0)

    -- for k, v in pairs(perks) do
    --     perklist:AddLine(v.DisplayName, v.Description, v.Class, v.Level,k )
    -- end


net.Receive("gtd_f4", _openMenu)