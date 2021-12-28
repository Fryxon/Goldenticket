net.Receive("Menu", function()
    OpenMenu()
end)

function OpenMenu()
    local frame = vgui.Create("XeninUI.Frame")
    frame:SetSize(1280, 580)
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetTitle("Adminmenu")
    local SplitGate = vgui.Create("XeninUI.Panel", frame)
    SplitGate:SetPos(640, 40)
    SplitGate:SetSize(10, 600)

    SplitGate.Paint = function(pnl, w, h)
        surface.SetDrawColor(48, 44, 44)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(48, 44, 44)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local category = vgui.Create("XeninUI.Category", frame)
    category:SetSize(300, 50)
    category:SetPos(190, 60)
    category:SetName("Select Player")
    local button1 = vgui.Create("XeninUI.ButtonV2", frame)
    button1:SetSolidColor(Color(40, 45, 45, 45))
    button1:SetText("Ban Player")
    button1:SetPos(20, 300)
    button1:SetSize(175, 100)
    local button2 = vgui.Create("XeninUI.ButtonV2", frame)
    button2:SetSolidColor(Color(40, 45, 45, 45))
    button2:SetText("Kick Player")
    button2:SetPos(200, 300)
    button2:SetSize(175, 100)
    local button3 = vgui.Create("XeninUI.ButtonV2", frame)
    button3:SetSolidColor(Color(223, 11, 11, 45))
    button3:SetText("Restart Round")
    button3:SetPos(900, 300)
    button3:SetSize(175, 100)

    button1.DoClick = function(btn)
        net.Start("ClickButton1")
        net.SendToServer()
    end

    button2.DoClick = function(btn)
        net.Start("ClickButton2")
        net.SendToServer()
    end

    button3.DoClick = function(btn)
        net.Start("ClickButton3")
        net.SendToServer()
    end

    return ""
end

surface.CreateFont("Scoreboard_18", {
    font = "Roboto",
    size = 18,
    weight = 500,
})

function ToggleScorboard(toggle)
    if toggle then
        Scoreboard = vgui.Create("XeninUI.Frame")
        Scoreboard:SetTitle("Scoreboard")
        Scoreboard:SetSize(1300, 720)
        Scoreboard:Center()
        Scoreboard:MakePopup()
        Scoreboard:ShowCloseButton(false)
        local ypos = Scoreboard:GetTall() * .08

        for k, v in pairs(player.GetAll()) do
            local playerPanel = vgui.Create("XeninUI.Panel", Scoreboard)
            playerPanel:SetPos(0, ypos)
            playerPanel:SetSize(Scoreboard:GetWide(), Scoreboard:GetTall() * .05)
            local name = v:Name()
            local ping = v:Ping()

            playerPanel.Paint = function(self, w, h)
                surface.SetDrawColor(40, 41, 40)
                surface.DrawRect(0, 0, w, h)
                draw.SimpleText(name, "Scoreboard_18", 50, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("Ping: " .. ping, "Scoreboard_18", w * 0.90, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("Kills: " .. v:GetNWInt("TotalFrags"), "Scoreboard_18", w * 0.5, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local AvatarImage = vgui.Create("AvatarImage", playerPanel)
            AvatarImage:SetPos(0, 0)
            AvatarImage:SetSize(40, Scoreboard:GetTall() * .05)
            AvatarImage:SetPlayer(v, 64)

            AvatarImage.Paint = function(self, w, h)
                surface.SetDrawColor(40, 41, 40)
                surface.DrawRect(0, 0, w, h)
            end

            ypos = ypos + playerPanel:GetTall() * 1.1
        end
    else
        if IsValid(Scoreboard) then
            Scoreboard:Remove()
        end
    end
end

hook.Add("ScoreboardShow", "ScoreboardOpen", function()
    ToggleScorboard(true)

    return false
end)

hook.Add("ScoreboardHide", "ScoreboardClose", function()
    ToggleScorboard(false)
end)

net.Receive("Shop", function()
    OpenShop()
end)

surface.CreateFont("description_24", {
    font = "Roboto",
    size = 24,
    weight = 500,
})

button1_gekauft = false
button2_gekauft = false
button3_gekauft = false

function OpenShop()
    local shop = vgui.Create("XeninUI.Frame")
    shop:SetSize(1280, 880)
    shop:Center()
    shop:SetVisible(true)
    shop:MakePopup()
    shop:SetTitle("Pointshop")
    local ypos = shop:GetTall() * .06
    local description = vgui.Create("XeninUI.Panel", shop)
    description:SetPos(0, ypos)
    description:SetSize(shop:GetWide(), shop:GetTall() * .05)

    description.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Deine Punkte: " .. LocalPlayer():GetNWInt("Points"), "description_24", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local ModelPanel1 = vgui.Create("XeninUI.Panel", shop)
    ModelPanel1:SetPos(10, 110)
    ModelPanel1:SetSize(200, 285)

    ModelPanel1.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
    end

    surface.CreateFont("NeedPoints_18", {
        font = "Roboto",
        size = 18,
        weight = 500,
    })

    local NeedPoints1 = vgui.Create("XeninUI.Panel", shop)
    NeedPoints1:SetPos(75, 300)
    NeedPoints1:SetSize(75, 50)

    NeedPoints1.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Points: 20 ", "NeedPoints_18", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local icon1 = vgui.Create("DModelPanel", shop)
    icon1:SetSize(200, 300)
    icon1:SetPos(10, 50)
    icon1:SetModel("models/captainbigbutt/vocaloid/miku_classic.mdl")
    local SelectButton1 = vgui.Create("XeninUI.ButtonV2", shop)
    SelectButton1:SetSolidColor(Color(55, 63, 75, 45))
    SelectButton1:SetText("Select")
    SelectButton1:SetPos(20, 350)
    SelectButton1:SetSize(175, 40)
    SelectButton1:SetVisible(false)

    SelectButton1.DoClick = function(Selectbtn)
        net.Start("SelectButton1")
        net.SendToServer()
    end

    local button1 = vgui.Create("XeninUI.ButtonV2", shop)

    if button1_gekauft then
        button1:SetVisible(false)
        SelectButton1:SetVisible(true)
    end

    button1:SetSolidColor(Color(55, 63, 75, 45))
    button1:SetText("Buy")
    button1:SetPos(20, 350)
    button1:SetSize(175, 40)

    button1.DoClick = function(btn)
        if (LocalPlayer():GetNWInt("Points") >= 20) then
            net.Start("BuyButton1")
            net.SendToServer()
            btn:Remove()
            button1_gekauft = true
            SelectButton1:SetVisible(true)
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, " System | DU HAST ZU WENIG PUNKTE, STRENG DICH MAL MEHR AN!")
        end
    end

    local ModelPanel2 = vgui.Create("XeninUI.Panel", shop)
    ModelPanel2:SetPos(220, 110)
    ModelPanel2:SetSize(200, 285)

    ModelPanel2.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
    end

    surface.CreateFont("NeedPoints_18", {
        font = "Roboto",
        size = 18,
        weight = 500,
    })

    local NeedPoints2 = vgui.Create("XeninUI.Panel", shop)
    NeedPoints2:SetPos(285, 300)
    NeedPoints2:SetSize(75, 50)

    NeedPoints2.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Points: 60 ", "NeedPoints_18", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local icon2 = vgui.Create("DModelPanel", shop)
    icon2:SetSize(200, 300)
    icon2:SetPos(220, 50)
    icon2:SetModel("models/freeman/player/left_shark.mdl")
    local SelectButton2 = vgui.Create("XeninUI.ButtonV2", shop)
    SelectButton2:SetSolidColor(Color(55, 63, 75, 45))
    SelectButton2:SetText("Select")
    SelectButton2:SetPos(230, 350)
    SelectButton2:SetSize(175, 40)
    SelectButton2:SetVisible(false)

    SelectButton2.DoClick = function(Selectbtn)
        net.Start("SelectButton2")
        net.SendToServer()
    end

    local button2 = vgui.Create("XeninUI.ButtonV2", shop)

    if button2_gekauft then
        button2:SetVisible(false)
        SelectButton2:SetVisible(true)
    end

    button2:SetSolidColor(Color(55, 63, 75, 45))
    button2:SetText("Buy")
    button2:SetPos(230, 350)
    button2:SetSize(175, 40)

    button2.DoClick = function(btn)
        if (LocalPlayer():GetNWInt("Points") >= 60) then
            net.Start("BuyButton2")
            net.SendToServer()
            btn:Remove()
            button2_gekauft = true
            SelectButton2:SetVisible(true)
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, " System | DU HAST ZU WENIG PUNKTE, STRENG DICH MAL MEHR AN!")
        end
    end

    local ModelPanel3 = vgui.Create("XeninUI.Panel", shop)
    ModelPanel3:SetPos(430, 110)
    ModelPanel3:SetSize(200, 285)

    ModelPanel3.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
    end

    surface.CreateFont("NeedPoints_18", {
        font = "Roboto",
        size = 18,
        weight = 500,
    })

    local NeedPoints3 = vgui.Create("XeninUI.Panel", shop)
    NeedPoints3:SetPos(495, 300)
    NeedPoints3:SetSize(80, 50)

    NeedPoints3.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Points: 120 ", "NeedPoints_18", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local icon3 = vgui.Create("DModelPanel", shop)
    icon3:SetSize(200, 300)
    icon3:SetPos(430, 50)
    icon3:SetModel("models/player/daedric.mdl")
    local SelectButton3 = vgui.Create("XeninUI.ButtonV2", shop)
    SelectButton3:SetSolidColor(Color(55, 63, 75, 45))
    SelectButton3:SetText("Select")
    SelectButton3:SetPos(440, 350)
    SelectButton3:SetSize(175, 40)
    SelectButton3:SetVisible(false)

    SelectButton3.DoClick = function(Selectbtn)
        net.Start("SelectButton3")
        net.SendToServer()
    end

    local button3 = vgui.Create("XeninUI.ButtonV2", shop)

    if button3_gekauft then
        button3:SetVisible(false)
        SelectButton3:SetVisible(true)
    end

    button3:SetSolidColor(Color(55, 63, 75, 45))
    button3:SetText("Buy")
    button3:SetPos(440, 350)
    button3:SetSize(175, 40)

    button3.DoClick = function(btn)
        if (LocalPlayer():GetNWInt("Points") >= 120) then
            net.Start("BuyButton3")
            net.SendToServer()
            btn:Remove()
            button3_gekauft = true
            SelectButton3:SetVisible(true)
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, " System | DU HAST ZU WENIG PUNKTE, STRENG DICH MAL MEHR AN!")
        end
    end
end

net.Receive("MapVotingSystem", function()
    OpenMapVoting()
end)

function OpenMapVoting()
    local MapVoting = vgui.Create("XeninUI.Frame")
    MapVoting:MakePopup()
    MapVoting:SetSize(950, 600)
    MapVoting:Center()
    MapVoting:SetTitle("Vote für die nächste Map", TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local Map1 = vgui.Create("XeninUI.ButtonV2", MapVoting)
    Map1:SetImage()
    Map1:SetSize(225, 185)
    Map1:SetPos(5, 50)
end


