-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- This file manages the model data and the app inititalization for the Car List app.
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local json = require( "json" )
--[[

██╗  ██╗███████╗ █████╗ ██████╗ ███████╗██████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗
███████║█████╗  ███████║██║  ██║█████╗  ██████╔╝
██╔══██║██╔══╝  ██╔══██║██║  ██║██╔══╝  ██╔══██╗
██║  ██║███████╗██║  ██║██████╔╝███████╗██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝

What this app does:
This app is designed to take notes and to export them to either pastebin or a file

How to use:
when the app launches, use the + button to create a new note, click on the options button
to export the file or change the font/font size for that specific note.
In the settings tab on the first page you can change the default settings for new notes and 
toggle the sound

Claimed points:
40 - significant new work
10 - good code quality
10 - header comment

5 - sound effects during transitions
5 - bg music with switch in settings
5 - several different buttons, and a switch
5 - a native text field
10 - table view
5 - save and load the notes
5 - saves the settings in a file
10 - HTTP put to pastebin


]]



----------- Global app data accessible from all scenes ----------------------------------

-- This table contains the app's "model" data as well as other global data and functions.
globalAppData = 
{
	notes = {
		-- lists user created
	},


	note = nil;  	 -- a copy of the note record being edited, or nil if none
	noteIndex = nil;	 -- index of note in cars array being edited, or nil if none

	bgMusicState = false;
}

-- File local reference to the global data
local g = globalAppData


----------- Global Utility Functions ----------------------------------------------------------------

-- Return a (shallow) copy of a table
function g.copyTable( t )
	-- Make a new table and copy each index-value pair into it
	local copy = {}
	for i, v in pairs( t ) do
		copy[i] = v
	end
	return copy
end

-- Make and return a UI button in group with the given label, position, and listener
function g.makeButton( group, label, x, y, listener )
	local btn = widget.newButton{ 
		x = x, 
		y = y, 
		label = label, 
		textOnly = true, 
		font = native.systemFont,
		onRelease = listener 
	}
	group:insert( btn )
	return btn
end

-- Make and return a text label in group left-aligned at left and centered at yCenter
function g.makeLabel( group, label, left, yCenter )
	local t = display.newText{
		parent = group,
		text = label,
		x = left,
		y = yCenter,
		font = native.systemFont,
		fontSize = 18,
		align = "left"
	}
	t.anchorX = 0
	t:setFillColor( 0 )  -- black
	return t
end

-- Make and return a scene title in group
function g.makeTitle( group, label )
	local t = display.newText{
		parent = group,
		text = label,
		x = g.xCenter,
		y = g.yTitle,
		font = native.systemFontBold,
		fontSize = 18,
	}
	t:setFillColor( 0 )  -- black
	return t
end

----------- Functions to save and load the model data to a data file -------------------------

-- Return the path name for the user data file where the car list is saved
local function dataFilePath()
	return system.pathForFile( "carData.txt", system.DocumentsDirectory )
end

-- -- Save the cars list to the user data file
-- local function saveCarData()
-- 	local file = io.open( dataFilePath(), "w" )
-- 	if file then
-- 		file:write( json.encode( g.cars ) )
-- 		io.close( file )
-- 		print( "Car list saved: " .. #g.cars .. " cars" )
-- 	end
-- end

-- -- Load the cars list from the user data file
-- local function loadCarData()
-- 	local file = io.open( dataFilePath(), "r" )
-- 	if file then
-- 		local str = file:read( "*a" )	-- Read entile file as a string (JSON encoded)
-- 		if str then
-- 			local carTable = json.decode( str )
-- 			if carTable then
-- 				g.cars = carTable
-- 				print( "Car list loaded: " .. #g.cars .. " cars" )
-- 			end
-- 		end
-- 		io.close( file )
-- 	end
-- end

-- Handle system events for the app
local function onSystemEvent( event )
	-- Save the car data if the user switches out of or quits the app
	if event.type == "applicationSuspend" or event.type == "applicationExit" then
		--saveCarData()
	end
end


----------- App initialization ---------------------------------------------------------------

-- Init the app 
local function initApp()
	-- Compute screen metrics for the entire device screen area and add to our global data table
	g.width = display.actualContentWidth
	g.height = display.actualContentHeight
	g.xMin = display.screenOriginX
	g.yMin = display.screenOriginY
	g.xMax = g.xMin + g.width
	g.yMax = g.yMin + g.height
	g.xCenter = (g.xMin + g.xMax) / 2
	g.yCenter = (g.yMin + g.yMax) / 2

	-- Additional metrics
	g.topMargin = 45    -- Room for title and buttons at the top of each scene
	g.yTitle = g.yMin + g.topMargin / 2   -- vertical center for top titles and buttons
	g.timeSlide = 150   -- scene transition time

	-- Load saved car data, if any
	--loadCarData()

	-- Add system event listener for the app (stays installed in all scenes)
	Runtime:addEventListener( "system", onSystemEvent )

	-- Start in the list view
	display.setStatusBar( display.HiddenStatusBar )

	composer.gotoScene( "list" )
end

-- Start the app
initApp()
