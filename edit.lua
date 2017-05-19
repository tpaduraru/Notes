-----------------------------------------------------------------------------------------
--
-- edit.lua
--
-----------------------------------------------------------------------------------------

-- requires
local widget = require( "widget" )
local composer = require( "composer" )
local json = require( "json" )

-- create new composer scene
local scene = composer.newScene()

-- global vars
local g = globalAppData

-- vars
local titleText
local textBox = native.newTextBox( g.xCenter, g.yCenter+25, g.width, g.height-50 )
textBox.text = text
textBox.title = title
textBox.isEditable = true
textBox.isVisible = false
textBox.font = native.newFont( "liberation_serif", 14 )


------------- Listeners ---------------
-- user presses the < List button
local function onList( event )
	composer.gotoScene( "list", {effect = "slideRight", time = g.timeSlide} )
end

-- user presses the * List button
local function onMenu( event )
	-- body
end

local function textListener( event )
	if event.phase == "editing" then
		g.note.text = textBox.text
		print( "note: " .. g.note.text )
	end
end

function scene:create( event )
	local sceneGroup = self.view

	-- Make a light gray background
	local bg = display.newRect( sceneGroup, g.xCenter, g.yCenter, g.width, g.height )
	bg:setFillColor( 0.9 )

	-- Make the title
	titleText = g.makeTitle( sceneGroup, "Edit" )

	-- Create the Clear and Add buttons
	g.makeButton( sceneGroup, "< List", g.xMin + 40, g.yTitle, onList )
	g.makeButton( sceneGroup, "*", g.xMax - 30, g.yTitle, onMenu )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

		-- Called when the scene is now on screen
		local text = "Start Writing!"
		local title = "Editing Note " .. g.noteIndex
		if g.notes[g.noteIndex] then
			text = g.notes[g.noteIndex].text
		end

		-- edit the title text
		titleText.text = "Editing note " .. g.noteIndex

		-- create the text box
		textBox.isVisible = true
		textBox.text = text
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		-- save the data
		g.notes[g.noteIndex] = {}
		g.notes[g.noteIndex].text = textBox.text or "Start Writing!"
		g.notes[g.noteIndex].title = "Note # " .. g.noteIndex

		-- delets the textbox
		textBox.isVisible = false

		-- deletes temp note data
		g.note = nil
		g.noteIndex = nil

	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
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
