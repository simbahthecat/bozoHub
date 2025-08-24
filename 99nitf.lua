
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character
local humanoidRootPart
local inventory = player:WaitForChild("Inventory")

local function onCharacterAdded(char)
	character = char
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
	onCharacterAdded(player.Character)
end

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

local function isSackFull()
	if not sack then return true end
	local current = sack:GetAttribute("NumberItems")
	local capacity = sack:GetAttribute("Capacity")
	return current ~= nil and capacity ~= nil and current >= capacity
end

local function store(item)
	if not sack then return end
	local part = item:FindFirstChildWhichIsA("BasePart")
	if part then
		humanoidRootPart.CFrame = part.CFrame
		task.wait(0.2)
		ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestBagStoreItem"):InvokeServer(sack, item)
		task.wait(0.2)
	end
end

function unstoreItem(name)
	if not sack then return end
	ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestBagDropItem"):FireServer(sack, workspace.Items[name], true)
end

function bringitem(name)
		lastPos = humanoidRootPart.CFrame
		pcall(function ()
			local all = {}
			for _, obj in pairs(itemsFolder:GetChildren()) do table.insert(all, obj) end
			for _, obj in pairs(characters:GetChildren()) do table.insert(all, obj) end

			for _, item in pairs(all) do
				if isSackFull() then break end
				if item.Name == name then
					store(item)
				end
			end
		end)
		humanoidRootPart.CFrame = lastPos
	end


function tptoitem()
		local item = itemsFolder:FindFirstChild(name) or characters:FindFirstChild(name)
		if item then
			local part = item:FindFirstChildWhichIsA("BasePart")
			if part then
				humanoidRootPart.CFrame = part.CFrame
			end
		end
	end

local campfire = workspace:FindFirstChild("Map"):FindFirstChild("Campground"):FindFirstChild("MainFire")
function tptocampfire()
		if campfire then
			local center = campfire:FindFirstChild("Center")
			if center then
				humanoidRootPart.CFrame = center.CFrame * CFrame.new(0, 13, 0)
			end
		end
	end

function fuelit()
	for i,v in workspace.Items:GetChildren() do
		if v:GetAttribute("BurnFuel") then
			store(v)
			tptocampfire()
			unstoreItem(v)
		end
	end
end

fuelit()
