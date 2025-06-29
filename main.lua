local oh
local gui
local tws = game:GetService("TweenService")
local twp = TweenInfo.new(1,Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, false, 0)
local cns = game:GetService("ContentProvider")
local cas = game:GetService("ContextActionService")
local bat
local attacked = {}
local chr = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local hrp = chr:FindFirstChild("HumanoidRootPart")

local function guiLoad()
	gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
	gui.Name = "bozoHub UI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	Instance.new("Frame",gui).Name = "Main"
	gui:FindFirstChild("Main").Size = UDim2.new(1,0,1,0)
	gui:FindFirstChild("Main").BackgroundTransparency = 1
	Instance.new("Frame", gui:FindFirstChild("Main")).Name = "Normframe"
	gui:FindFirstChild("Main"):FindFirstChild("Normframe").BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Instance.new("UICorner", gui:FindFirstChild("Main"):FindFirstChild("Normframe"))
	gui:FindFirstChild("Main"):FindFirstChild("Normframe").Size = UDim2.new(0.353,0,0,0)
	gui:FindFirstChild("Main"):FindFirstChild("Normframe").Position = UDim2.new(0.323, 0,0.344, 0)
	Instance.new("TextLabel",gui:FindFirstChild("Main"):FindFirstChild("Normframe")).Position = UDim2.new(0.25,0,0.35,0)
	gui:FindFirstChild("Main"):FindFirstChild("Normframe"):FindFirstChild("TextLabel").Size= UDim2.new(0.5,0,0.25,0)
	gui:FindFirstChild("Main"):FindFirstChild("Normframe"):FindFirstChild("TextLabel").BackgroundTransparency = 1
	gui:FindFirstChild("Main"):FindFirstChild("Normframe"):FindFirstChild("TextLabel").TextColor3 = Color3.new(1,1,1)
	gui:FindFirstChild("Main"):FindFirstChild("Normframe"):FindFirstChild("TextLabel").TextScaled = true
	gui:FindFirstChild("Main"):FindFirstChild("Normframe"):FindFirstChild("TextLabel").Font = Enum.Font.SourceSansBold
	cns:PreloadAsync(gui:GetDescendants())
end

guiLoad()

local function Notify(string:string, duration:number)
	task.spawn(function()
	tws:Create(gui:FindFirstChild("Main"):FindFirstChild("Normframe"), twp, {["Size"] = UDim2.new(0.353, 0,0.31, 0)}):Play()
	gui:FindFirstChild("Main"):FindFirstChild("Normframe"):FindFirstChild("TextLabel").Text = string
	task.wait(duration)
	tws:Create(gui:FindFirstChild("Main"):FindFirstChild("Normframe"), twp, {["Size"] = UDim2.new(0.353, 0,0, 0)}):Play()
	task.wait(1)
	gui:FindFirstChild("Main"):FindFirstChild("Normframe"):FindFirstChild("TextLabel").Text = ""
	end)
end



if game.PlaceId == 109983668079237 or 1+1==2 then
	Notify("bozoHub Loaded, Steal A Brainrot detected update 2",3.5)
	repeat
		task.wait()
	until game.Players.LocalPlayer.Backpack:FindFirstChild("Tung Bat")
	bat = game.Players.LocalPlayer.Backpack:FindFirstChild("Tung Bat")
	bat.Parent = chr
	
else
	Notify("bozoHub is not compatible with this game ",3.5)
end

local function killAuraLoop()
	task.spawn(function()
		while task.wait() do
			if not chr or not chr:FindFirstChild("HumanoidRootPart") then return end

			for _, pl in ipairs(game.Players:GetPlayers()) do
				if pl ~= game.Players.LocalPlayer then
					local otchr = pl.Character
					if otchr and otchr:FindFirstChild("HumanoidRootPart") then
						local dist = (hrp.Position - otchr:FindFirstChild("HumanoidRootPart").Position).Magnitude
						if dist <= 10 and not attacked[pl] then
							attacked[pl]=true
							chr:PivotTo(otchr:GetPivot())
							bat:Activate()
						elseif dist > 10 and attacked[pl] then
							attacked[pl]=false
						end
					end
				end
			end
		end
	end)
end

killAuraLoop()
