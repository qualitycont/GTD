local function _notify()
    local level = net.ReadUInt(8)
    LocalPlayer():EmitSound("items/medshot4.wav")

    -- Notification panel
    local NotifyPanel = vgui.Create("DNotify")
    NotifyPanel:SetPos(15, 15)
    NotifyPanel:SetSize(150, 190)

    -- Gray background panel
    local bg = vgui.Create("DPanel", NotifyPanel)
    bg:Dock(FILL)
    bg:SetBackgroundColor(Color(64, 64, 64))

    -- Image of Dr. Kleiner (parented to background panel)
    local biglbl = vgui.Create("DLabel", bg)
    biglbl:SetPos(11, 11)
    biglbl:SetSize(128, 128)
    biglbl:SetText(level)
    biglbl:SetFont("GTDBigNotify")

    -- A yellow label message (parented to background panel)
    local lbl = vgui.Create("DLabel", bg)
    lbl:SetPos(11, 136)
    lbl:SetSize(128, 36)
    lbl:SetText("You Levelled Up!")
    lbl:SetTextColor(Color(255, 200, 0))
    lbl:SetFont("GModNotify")
    lbl:SetWrap(true)

    -- Add the background panel to the notification
    NotifyPanel:AddItem(bg)
end

surface.CreateFont( "GTDBigNotify", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 128,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

net.Receive("gtd_levelup", _notify)