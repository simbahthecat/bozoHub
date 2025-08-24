local plr = game:GetService("Players").LocalPlayer
local chr
local hum
local loadr = game:GetService("ContentProvider")
local user = game:GetService("UserInputService")

chr = plr.Character or plr.CharacterAdded:Wait()
hum = chr:FindFirstChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui")
gui.Parent = plr.PlayerGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Name = "popcogui"
local mainfr = Instance.new("Frame")
mainfr.Name = "main"
mainfr.Parent = gui
mainfr.Size = UDim2.new(1,0,1,0)
mainfr.Transparency = 1
local text = Instance.new("TextLabel")
text.Parent = mainfr
text.Position = UDim2.new(0.5,0,0.5,0)
text.Text = "popco farm"
text.Name = "text"
text.Font = Enum.Font.Arimo
text.BackgroundTransparency = 1
text.TextTransparency = 0.1
text.TextColor3 = Color3.new(1,1,1)
--text.TextSize = 20
text.TextScaled = true
text.Size = UDim2.new(0.123,0,0.072,0)
local stroke = Instance.new("UIStroke")
stroke.Parent = text
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
stroke.Name = "stroke"
local uigradient = Instance.new("UIGradient")
uigradient.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(140, 36, 36))
uigradient.Parent = text
uigradient.Name = "uigradient"
uigradient.Rotation = 0
loadr:PreloadAsync(gui:GetDescendants())
task.spawn(function()
	while task.wait(0.01) do
		uigradient.Rotation += 1
	end
end)

local inventory = plr:WaitForChild("Backpack")
local sack = nil
local function findSack()
	for _, item in pairs(inventory:GetChildren()) do
		if string.find(item.Name, "Sack") then
			return item
		end
	end
	return nil
end

sack = findSack()

inventory.ChildAdded:Connect(function(child)
	if string.find(child.Name, "Sack") then
		sack = child
	end
end)

inventory.ChildRemoved:Connect(function(child)
	if sack and child == sack then
		sack = findSack()
	end
end)

local itemsFolder = workspace:FindFirstChild("Items")
local characters = workspace:FindFirstChild("Characters")
local lastPos = nil
local items = {}
local kids = {}
local name = nil
local fuel = {}

local function isSackFull()
	if not sack then return true end
	local current = sack:GetAttribute("NumberItems")
	local capacity = sack:GetAttribute("Capacity")
	return current ~= nil and capacity ~= nil and current >= capacity
end

function emptySack()
	if not sack then return end
	local current = sack:GetAttribute("NumberItems")
	local capacity = sack:GetAttribute("Capacity")
	if current ~= nil and capacity ~= nil and current >= capacity then
		game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestBagStoreItem"):InvokeServer(sack, nil)
	end
end

local function store(item)
	if not sack then return end
	local part = item:FindFirstChildWhichIsA("BasePart")
	if part then
		hum.CFrame = part.CFrame
		task.wait(0.2)
		game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestBagStoreItem"):InvokeServer(sack, item)

		task.wait(0.2)
	end
end

function getKidsAsClass() 
	for _, kid in pairs(characters:GetChildren()) do
		if string.find(kid.Name, "Child") then
			table.insert(kids, kid)
		end
	end
end

getKidsAsClass()

function getFuelAsClass()
	for i,v: Model in workspace.Items:GetChildren() do
		if v:GetAttribute("BurnFuel") then
			table.insert(fuel, v)
		end
	end
end
getFuelAsClass()

function campfireFuelLoop()
	lastPos = hum.CFrame
	while task.wait(0.1) do
		for _, item in pairs(fuel) do
			if isSackFull() then
				hum.Position = workspace.Map.Campground.MainFire.Center.Position * Vector3.new(0,13,0)
				for i=0,sack:GetAttribute("Capacity") do
					game:GetService("ReplicatedStorage").RemoteEvents.RequestBagDropItem:FireServer(sack, workspace.Items[item.name], true)
				end
			end
			hum.CFrame = item.BasePart.CFrame
			store(item)
		end
	end
	hum.CFrame = lastPos
end

campfireFuelLoop()

function getKids()
lastPos = hum.CFrame
pcall(function ()
	
	for _, item in pairs(kids) do
		if isSackFull() then break end
		if item.Name == name then
			store(item)
		end
	end
end)
hum.CFrame = lastPos
end

task.wait(5)

getKids()

gui:Destroy()
