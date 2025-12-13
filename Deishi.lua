-- Dashi Hub UI Library (Smooth / Mobile / Switch Toggle)

local Library = {}

local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local UIS = game:GetService("UserInputService") local LP = Players.LocalPlayer

local function tween(obj, props, t) TweenService:Create(obj, TweenInfo.new(t or 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play() end

function Library:CreateWindow(cfg) local Window = {}

local gui = Instance.new("ScreenGui")
gui.Name = "DashiHub"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- Floating Toggle Button (Mobile)
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.fromOffset(52,52)
floatBtn.Position = UDim2.fromScale(0.02,0.5)
floatBtn.Text = "≡"
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 22
floatBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
floatBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1,0)

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.6,0.7)
main.Position = UDim2.fromScale(0.2,0.15)
main.BackgroundColor3 = Color3.fromRGB(15,15,18)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

local opened = true
floatBtn.MouseButton1Click:Connect(function()
    opened = not opened
    tween(main, {Size = opened and UDim2.fromScale(0.6,0.7) or UDim2.fromScale(0,0)}, 0.35)
    tween(main, {BackgroundTransparency = opened and 0 or 1}, 0.35)
end)

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,50)
header.BackgroundTransparency = 1

local hub = Instance.new("TextLabel", header)
hub.Text = cfg.Title or "Dashi Hub"
hub.Font = Enum.Font.GothamBold
hub.TextSize = 20
hub.TextColor3 = Color3.fromRGB(0,150,255)
hub.Size = UDim2.fromScale(0.6,1)
hub.BackgroundTransparency = 1
hub.Position = UDim2.fromScale(0.04,0)

local close = Instance.new("TextButton", header)
close.Text = "×"
close.Font = Enum.Font.GothamBold
close.TextSize = 22
close.TextColor3 = Color3.fromRGB(200,200,200)
close.BackgroundTransparency = 1
close.Size = UDim2.fromScale(0.1,1)
close.Position = UDim2.fromScale(0.9,0)

close.MouseButton1Click:Connect(function()
    opened = false
    tween(main,{Size=UDim2.fromScale(0,0),BackgroundTransparency=1},0.35)
end)

-- Sidebar
local side = Instance.new("Frame", main)
side.Position = UDim2.fromOffset(0,50)
side.Size = UDim2.fromScale(0.24,0.9)
side.BackgroundColor3 = Color3.fromRGB(12,12,15)
Instance.new("UICorner", side).CornerRadius = UDim.new(0,16)

local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0,6)

local content = Instance.new("Frame", main)
content.Position = UDim2.fromScale(0.26,0.12)
content.Size = UDim2.fromScale(0.7,0.82)
content.BackgroundTransparency = 1

local Tabs = {}

function Window:CreateTab(name)
    local Tab = {}

    local tabBtn = Instance.new("TextButton", side)
    tabBtn.Size = UDim2.fromScale(1,0.09)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextColor3 = Color3.fromRGB(180,180,180)
    tabBtn.BackgroundTransparency = 1

    local tabFrame = Instance.new("Frame", content)
    tabFrame.Size = UDim2.fromScale(1,1)
    tabFrame.Visible = false
    tabFrame.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", tabFrame)
    layout.Padding = UDim.new(0,14)

    tabBtn.MouseButton1Click:Connect(function()
        for _,t in pairs(Tabs) do
            t.Frame.Visible=false
            tween(t.Button,{TextColor3=Color3.fromRGB(180,180,180)},0.2)
        end
        tabFrame.Visible=true
        tween(tabBtn,{TextColor3=Color3.fromRGB(0,150,255)},0.2)
    end)

    table.insert(Tabs,{Frame=tabFrame,Button=tabBtn})
    if #Tabs==1 then tabFrame.Visible=true tabBtn.TextColor3=Color3.fromRGB(0,150,255) end

    local function Card(h)
        local c = Instance.new("Frame", tabFrame)
        c.Size = UDim2.new(1,0,0,h)
        c.BackgroundColor3 = Color3.fromRGB(22,22,26)
        Instance.new("UICorner", c).CornerRadius = UDim.new(0,14)
        return c
    end

    function Tab:AddToggle(cfg)
        local c = Card(60)

        local text = Instance.new("TextLabel", c)
        text.Text = cfg.Text
        text.Font = Enum.Font.Gotham
        text.TextSize = 14
        text.TextColor3 = Color3.new(1,1,1)
        text.BackgroundTransparency = 1
        text.Position = UDim2.fromScale(0.05,0)
        text.Size = UDim2.fromScale(0.6,1)

        local switch = Instance.new("Frame", c)
        switch.Size = UDim2.fromOffset(46,24)
        switch.Position = UDim2.fromScale(0.82,0.3)
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60)
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)

        local knob = Instance.new("Frame", switch)
        knobn
        knob.Size = UDim2.fromOffset(20,20)
        knob.Position = UDim2.fromOffset(2,2)
        knob.BackgroundColor3 = Color3.fromRGB(230,230,230)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

        local on = false
        c.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                on = not on
                tween(switch,{BackgroundColor3=on and Color3.fromRGB(0,140,255) or Color3.fromRGB(60,60,60)},0.25)
                tween(knob,{Position=on and UDim2.fromOffset(24,2) or UDim2.fromOffset(2,2)},0.25)
                if cfg.Callback then cfg.Callback(on) end
            end
        end)
    end

    return Tab
end

return Window

end

return Library
