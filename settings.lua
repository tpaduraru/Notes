-----------------------------------------------------------------------------------------
--
-- settings.lua
--
-----------------------------------------------------------------------------------------

-- requires
local widget = require( "widget" )
local composer = require( "composer" )

-- creates scene
local scene = composer.newScene()

local g = globalAppData

-- will stop music when flipped
local function onBgMusicChannelRelease(event)
	print( event.target.isOn )
	if event.target.isOn then
		audio.resume( bgMusicChannel )
	else
		audio.pause( bgMusicChannel )
	end
end

local function onBack( event )
	composer.gotoScene( "list", { effect = "slideRight", time = g.timeSlide } )
end

--------------------------------------------

function scene:create( event )
	local sceneGroup = self.view

	-- Make a light gray background
	local bg = display.newRect( sceneGroup, g.xCenter, g.yCenter, g.width, g.height )
	bg:setFillColor( 0.9 )

	-- Make the title
	g.makeTitle( sceneGroup, "Settings" )

	-- Make the Back and Cancel buttons
	g.makeButton( sceneGroup, "< Notes", g.xMin + 30, g.yTitle, onBack )

	-- loads music
	local bgMusic = audio.loadStream( "bgmusic.mp3" )

	-- begins to play background music and then pause it
	local bgMusicChannel = audio.play( bgMusic, { loops=-1 } )
	audio.pause( bgMusicChannel )

	local bgMusicSwitch = widget.newSwitch
						{
							x = g.xCenter,
							y = g.yCenter,
							initialSwitchState = false;
							onRelease = onBgMusicChannelRelease,
						}

	sceneGroup:insert( bgMusicSwitch  )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
	elseif phase == "did" then
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		
	elseif phase == "did" then
		
	end	
	
end

function scene:destroy( event )

	
	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene