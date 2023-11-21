local placeId = game.PlaceId
if placeId == 2753915549 or placeId == 4442272183 or placeId == 7449423635 then
    BF = true
end
if BF == true then
    repeat wait() until game:IsLoaded()
    function Notification(text)
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Hop When Meet";
            Text = text
        })
    end
    if _G.HopWhenMeetLoaded then return end
    _G.HopWhenMeetLoaded = 1
    Notification("Hop Loaded")
    local plr = game.Players.LocalPlayer
    local Name = plr.Name
    local function HopServer()
		local PlaceID = game.PlaceId
		local AllIDs = {}
		local foundAnything = ""
		local actualHour = os.date("!*t").hour
		local Deleted = false
        local File = pcall(function()
        AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServersHop.json"))
        end)
        if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServersHop.json", game:GetService('HttpService'):JSONEncode(AllIDs))
        end
		function TPReturner()
			local Site;
			if foundAnything == "" then
				Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
			else
				Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
			end
			local ID = ""
			if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
				foundAnything = Site.nextPageCursor
			end
			local num = 0;
			for i,v in pairs(Site.data) do
				local Possible = true
				ID = tostring(v.id)
				if tonumber(v.maxPlayers) > tonumber(v.playing) then
					for _,Existing in pairs(AllIDs) do
						if num ~= 0 then
							if ID == tostring(Existing) then
								Possible = false
							end
						else
							if tonumber(actualHour) ~= tonumber(Existing) then
								local delFile = pcall(function()
									-- delfile("NotSameServers.json")
									AllIDs = {}
									table.insert(AllIDs, actualHour)
								end)
							end
						end
						num = num + 1
					end
					if Possible == true then
						table.insert(AllIDs, ID)
						wait()
						pcall(function()
							-- writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
							wait()
							game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
						end)
						wait(4)
					end
				end
			end
		end
	
		function Teleport()
			while wait() do
				pcall(function()
					TPReturner()
					if foundAnything ~= "" then
						TPReturner()
					end
				end)
			end
		end
	
		Teleport()
		wait(1)
	end

    if _G.HopWhenPrefix then
        spawn(function()
            while true do 
                wait(0.5)
                for i, player in pairs(game.Players:GetChildren()) do
                    if player.Name != Name then
                        if string.find(player.Name, _G.HopWhenPrefix) then
                            HopServer()
                        end
                    end
                end
            end
        end)
    end
    if _G.HopWhenNickname then
        spawn(function()
            while true do 
                wait(0.5)
                for i, player in pairs(game.Players:GetChildren()) do
                    if player.Name != Name then
                        for _, nickname in pairs(_G.HopWhenNickname) do
                            if player.Name == nickname then
                                HopServer()
                            end
                        end
                    end
                end
            end
        end)
    end
end
