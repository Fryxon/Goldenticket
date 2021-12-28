include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

net.Receive("Talk1", function()
    OpenTalk1()
end)

function OpenTalk1()
    local Talk1 = vgui.Create("XeninUI.Frame")
    Talk1:SetSize(900, 750)
    Talk1:Center()
    Talk1:MakePopup()
    Talk1:SetVisible(true)
    Talk1:SetTitle("Händler Musti")
    local buttonW1 = vgui.Create("XeninUI.ButtonV2", Talk1)
    buttonW1:SetSize(100, 50)
    buttonW1:SetPos(750, 650)
    buttonW1:SetSolidColor(Color(55, 63, 75, 45))
    buttonW1:SetText("Next >")
    local Image1 = vgui.Create("ModelImage", Talk1)
    Image1:SetSize(125, 125)
    Image1:SetPos(80,150)
    Image1:SetModel("models/player/jojo3/jtr.mdl")
    local TextPanel1 = vgui.Create("XeninUI.Panel", Talk1)
    TextPanel1:SetPos(300, 110)
    TextPanel1:SetSize(600, 285)

    TextPanel1.Paint = function(self, w, h)
        surface.SetDrawColor(40, 41, 40)
        surface.DrawRect(0, 0, w, h)
    end

    function OpenTalk2()
        local Talk2 = vgui.Create("XeninUI.Frame")
        Talk2:SetSize(900, 750)
        Talk2:Center()
        Talk2:MakePopup()
        Talk2:SetVisible(true)
        Talk2:SetTitle("Händler Musti")
        local buttonW2 = vgui.Create("XeninUI.ButtonV2", Talk2)
        buttonW2:SetSize(100, 50)
        buttonW2:SetPos(750, 650)
        buttonW2:SetSolidColor(Color(55, 63, 75, 45))
        buttonW2:SetText("Next >")
        local Image2 = vgui.Create("ModelImage", Talk2)
        Image2:SetSize(125, 125)
        Image2:SetPos(80,150)
        Image2:SetModel("models/player/jojo3/jtr.mdl")
        local TextPanel2 = vgui.Create("XeninUI.Panel", Talk2)
        TextPanel2:SetPos(300, 110)
        TextPanel2:SetSize(600, 285)
    
        TextPanel2.Paint = function(self, w, h)
            surface.SetDrawColor(40, 41, 40)
            surface.DrawRect(0, 0, w, h)
        end
    end

    buttonW1.DoClick = function(btn)
        if (Talk1:IsValid()) then
            Talk1:Remove()
            OpenTalk2()
        end
    end
end