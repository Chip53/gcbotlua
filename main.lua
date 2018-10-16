--require("scripts.gcbot.functions") --REQUIRE OTHER SCRIPT FILES

--[[
****TODO
-Start implementing diamond solving
-Add other dragons
-Add seasons
-Add hell
-Reset speed to 1 after X amount of time (to ensure its set to 2 if somehow it reverted)
-Add wave skipping
-Add advertisement watching
]]

--Globals
Events = {
	NumOfEvents = 1,
	{Event = "Replay"},
	{Event = "Battle"},
	{Event = "Dragon"},
	REPLAY = "Replay",
	BATTLE = "Battle",
	DRAGON = "Dragon"
}

Speed = 1 --1 = 1x, 2 = 2x. If 2x do not search

--Returns name of script
function getName()
	return "LUA GCBot v0.1"
end

--Returns script version
function getVersion()
	return 1
end

--Script init function
function start()
	math.randomseed(23453437)
	Bot.IS_DEBUG = true -- Set debug messages to true or false
	Bot.IS_PLAYING = true -- Not required, starts bot in "playing" state
	--TODO Detect when platform is loaded
	Bot:BOOT_PLATFORM(Platforms.PLATFORM_BLUESTACKS2) --BOOT PLATFORM(BLUESTACKS 2)
	--TODO Check adb has connected
	Bot:CONNECT_ADB() --CONNECT ADB
	Bot:START_APP("com.raongames.growcastle") --START APP
end

--Script main loop
function loop()
	if Bot.IS_PLAYING then
		if Bot:FIND_IMAGE("replay.bmp") then --IF TRUE WE ARE ON MAIN MENU(CASTLE SCREEN)
			local randEvent = math.random(1, Events.NumOfEvents) -- RANDOMLY PICK NEXT EVENT
			if Events[randEvent].Event == Events.REPLAY then
				if Bot:FIND_CLICK_IMAGE("replay.bmp") then --START REPLAY
					Bot:WAIT(25)
					Bot:WAIT_CLICK_IMAGE("100_replay.bmp") --WAIT FOR 100% TO SHOW AND CLICK
				end
			elseif Events[randEvent].Event == Events.BATTLE then
				Bot:FIND_CLICK_IMAGE("battle_btn.bmp") --START BATTLE
				Bot:WAIT(150)
			elseif Events[randEvent].Event == Events.DRAGON then
				if(Bot:FIND_CLICK_IMAGE("dragon_shrine.bmp")) then --START DRAGON
					if(Bot:WAIT_CLICK_IMAGE("black_dragon.bmp")) then
						Bot:WAIT_CLICK_IMAGE("dragon_battle.bmp")
					end
				end
			end
		else
			if Bot:FIND_IMAGE("event_back.bmp") then --IF TRUE WE ARE IN AN EVENT(BATTLE, REPLAY, DRAGON, ETC)
				if(not Speed == 2) then
					if(Bot:FIND_CLICK_IMAGE("1xspeed.bmp")) then --CLICK 2xSPEED
						Speed = 2
					end
				end
				Bot:FIND_CLICK_IMAGE("tongue_chest.bmp") --CLICK CHESTS IF FOUND
				--SPAM ABILITIES START
				Bot:FIND_CLICK_IMAGE("ability.bmp") --CLICK BLUE BAR
				--Bot:WAIT(10) -- WAIT
				--Bot:CLICK_XY(733, 453) -- CLICK HERE SO WIZARDS DON'T BREAK US
				--SPAM ABILITIES END
			else
				local f, x, y = Bot:FIND_IMAGE_WITH_XY("mat2_btn.bmp")
				if (f) then
					Bot:CLICK_XY(x, y)
					Bot:CLICK_XY(x, y)
				end
			end
		end
	end
end
