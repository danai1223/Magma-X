local player = game:GetService("Players").LocalPlayer
local gui = player:WaitForChild("PlayerGui", 5)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoSubmitUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = gui

-- 🔊 เสียงแจ้งเตือน
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://6026984224"
sound.Volume = 2
sound.Parent = workspace -- ✅ ย้ายออกจาก GUI เพื่อให้เสียงเล่นได้ชัวร์

-- 🔔 ฟังก์ชันแจ้งเตือน
local function createNotification(text)
	local notify = Instance.new("TextLabel")
	notify.Size = UDim2.new(0, 300, 0, 50)
	notify.Position = UDim2.new(0.5, -150, 0.1, 0)
	notify.AnchorPoint = Vector2.new(0.5, 0)
	notify.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	notify.TextColor3 = Color3.new(1, 1, 1)
	notify.Font = Enum.Font.GothamBold
	notify.TextSize = 20
	notify.Text = text
	notify.BackgroundTransparency = 0.2
	notify.Parent = screenGui
	Instance.new("UICorner", notify)

	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {
		BackgroundTransparency = 1,
		TextTransparency = 1,
	}):Play()

	delay(2.5, function()
		notify:Destroy()
	end)
end

-- 🪟 เมนูหลัก
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(255, 0, 0)

-- ❌ ปุ่มปิด
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", closeBtn)

-- 🧭 แถบเมนู
local tabs = {"อัตโนมัติ", "ตั้งค่า", "เครดิต"}
local pages = {}

for i, name in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton", mainFrame)
	tabBtn.Size = UDim2.new(0, 100, 0, 30)
	tabBtn.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 10)
	tabBtn.Text = name
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 14
	tabBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
	tabBtn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", tabBtn)

	local page = Instance.new("Frame", mainFrame)
	page.Size = UDim2.new(1, -20, 1, -60)
	page.Position = UDim2.new(0, 10, 0, 50)
	page.BackgroundTransparency = 1
	page.Visible = (i == 1)
	pages[name] = page

	tabBtn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Visible = false end
		page.Visible = true
	end)
end

-- 🟢 หน้า "อัตโนมัติ"
do
	local autoPage = pages["อัตโนมัติ"]

	local layout = Instance.new("UIListLayout", autoPage)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 10)
	layout.VerticalAlignment = Enum.VerticalAlignment.Top

	local padding = Instance.new("UIPadding", autoPage)
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)

	-- 🌱 ปุ่มส่งผักทั้งหมด
	local submitLoopRunning = false
	local submitLoopCoroutine

	local submitBtn = Instance.new("TextButton", autoPage)
	submitBtn.Size = UDim2.new(1, 0, 0, 50)
	submitBtn.Text = "เริ่มส่งผักทั้งหมด" -- ✅ ปรับข้อความให้ชัด
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.TextSize = 16
	submitBtn.TextColor3 = Color3.new(1, 1, 1)
	submitBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	Instance.new("UICorner", submitBtn)

	submitBtn.MouseButton1Click:Connect(function()
		if submitLoopRunning then
			submitLoopRunning = false
			submitBtn.Text = "เริ่มส่งผักทั้งหมด"
			submitBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
		else
			submitLoopRunning = true
			submitBtn.Text = "หยุดส่งผักทั้งหมด"
			submitBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

			submitLoopCoroutine = coroutine.wrap(function()
				while submitLoopRunning do
					local remote = game:GetService("ReplicatedStorage"):FindFirstChild("GameEvents")
					if remote then
						local event = remote:FindFirstChild("SummerHarvestRemoteEvent")
						if event then
							event:FireServer("SubmitAllPlants")
						else
							createNotification("❌ ไม่พบ SummerHarvestRemoteEvent")
						end
					else
						createNotification("❌ ไม่พบ GameEvents")
					end
					task.wait(1.5)
				end
			end)
			submitLoopCoroutine()
		end
	end)

	-- 🌾 ปุ่มเก็บผักทั้งหมด
	local openTriggerRunning = false
	local openTriggerCoroutine

	local openBtn = Instance.new("TextButton", autoPage)
	openBtn.Size = UDim2.new(1, 0, 0, 50)
	openBtn.Text = "เปิดเก็บผักในสวน"
	openBtn.Font = Enum.Font.GothamBold
	openBtn.TextSize = 16
	openBtn.TextColor3 = Color3.new(1, 1, 1)
	openBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	Instance.new("UICorner", openBtn)

	openBtn.MouseButton1Click:Connect(function()
		if openTriggerRunning then
			openTriggerRunning = false
			openBtn.Text = "เปิดเก็บผักในสวน"
			openBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
			createNotification("⛔ หยุดเก็บผักในสวนแล้ว!")
			sound:Play()
		else
			openTriggerRunning = true
			openBtn.Text = "หยุดเก็บผักในสวน"
			openBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
			createNotification("📂 เริ่มเปิดเก็บผักในสวน!")
			sound:Play()

			openTriggerCoroutine = coroutine.wrap(function()
				local success, plantsFolder = pcall(function()
					return workspace:WaitForChild("Farm", 5):WaitForChild("Farm", 5):WaitForChild("Important", 5):WaitForChild("Plants_Physical", 5)
				end)

				if not success or not plantsFolder then
					createNotification("❌ ไม่พบ Plants_Physical")
					return
				end

				local function triggerPromptsInModel(model)
					for _, descendant in ipairs(model:GetDescendants()) do
						if descendant:IsA("ProximityPrompt") then
							pcall(function()
								fireproximityprompt(descendant)
							end)
						end
					end
				end

				while openTriggerRunning do
					for _, obj in ipairs(plantsFolder:GetChildren()) do
						if obj:IsA("Model") then
							triggerPromptsInModel(obj)
						end
					end
					task.wait(5)
				end
			end)
			openTriggerCoroutine()
		end
	end)
end

-- 🧾 หน้า "เครดิต"
do
	local creditPage = pages["เครดิต"]
	creditPage.BackgroundTransparency = 0.5

	local creditContainer = Instance.new("Frame", creditPage)
	creditContainer.Size = UDim2.new(1, -20, 1, -20)
	creditContainer.Position = UDim2.new(0, 10, 0, 10)
	creditContainer.BackgroundTransparency = 1

	local copyBtn = Instance.new("TextButton", creditContainer)
	copyBtn.Size = UDim2.new(0, 100, 0, 30)
	copyBtn.Position = UDim2.new(0, 0, 0, 0)
	copyBtn.Text = "คัดลอก"
	copyBtn.Font = Enum.Font.GothamBold
	copyBtn.TextSize = 14
	copyBtn.TextColor3 = Color3.new(1, 1, 1)
	copyBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	Instance.new("UICorner", copyBtn)

	local creditLabel = Instance.new("TextLabel", creditContainer)
	creditLabel.Size = UDim2.new(1, 0, 1, -40)
	creditLabel.Position = UDim2.new(0, 0, 0, 40)
	creditLabel.BackgroundTransparency = 1
	creditLabel.TextColor3 = Color3.new(1, 1, 1)
	creditLabel.TextWrapped = true
	creditLabel.TextYAlignment = Enum.TextYAlignment.Top
	creditLabel.Font = Enum.Font.Gotham
	creditLabel.TextSize = 16
	creditLabel.Text = [[
🧠 สคริปต์โดย: Magma X
📅 เวอร์ชันแจกของผม: 0.0
⚙️ ระบบทั้วหมดตอนนี้: ออโต้ เก็บผัก ออโต้ส่งเควสอีเว้นท์
💬 ขอบคุณที่ใช้งาน 🤗
🔗 Discord: https://discord.gg/UMXCjYUQc3
]]

	copyBtn.MouseButton1Click:Connect(function()
		local link = "https://discord.gg/UMXCjYUQc3"
		if setclipboard then
			setclipboard(link)
			copyBtn.Text = "คัดลอกแล้ว!"
			task.wait(1.5)
			copyBtn.Text = "คัดลอก"
		else
			copyBtn.Text = "ไม่รองรับ"
		end
	end)
end

-- 📂 ปุ่มเปิดเมนู
local toggleMenuBtn = Instance.new("ImageButton")
toggleMenuBtn.Size = UDim2.new(0, 80, 0, 80)
toggleMenuBtn.Position = UDim2.new(0, 10, 0, 10)
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleMenuBtn.Image = "rbxthumb://type=Asset&id=79782244875699&w=420&h=420"
toggleMenuBtn.Active = true
toggleMenuBtn.Draggable = true
toggleMenuBtn.Parent = screenGui
Instance.new("UICorner", toggleMenuBtn)

toggleMenuBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	if mainFrame.Visible then
		createNotification("✅ เปิดเมนูสำเร็จ!")
		sound:Play()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)