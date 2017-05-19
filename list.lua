-----------------------------------------------------------------------------------------
--
-- list.lua
--
-- This file manages the List view in the Car List app.
-----------------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local json = require("json")
local scene = composer.newScene()

-- File local reference to the global data
local g = globalAppData


-- Render a row in the table widget
local function onRowRender( event )
	-- Get the row to render and the corresponding car record
	local row = event.row
	local index = row.index
	local note = g.notes[index] 

	-- Make the row text
	local title = note.title or ""
	local rowText = title
	
	-- Draw the row
	local rowHeight = row.contentHeight
	local rowWidth = row.contentWidth
	local rowTitle = display.newText( row, rowText, 0, 0, native.systemFont, 18 )
	rowTitle:setFillColor( 0 )	-- black text
	rowTitle.anchorX = 0  	-- left aligned
	rowTitle.x = 15         -- leave some left margin
	rowTitle.y = rowHeight * 0.5  -- vertically centered
end

-- Handle a touch event for a row in the table widget
local function onRowTouch( event )
	if event.phase == "tap" or event.phase == "release" then
		-- Remember the car index and make a copy of the car record, then go to the car view
		g.noteIndex = event.target.index
		g.note = g.copyTable( g.notes[g.noteIndex] )
		print(json.prettify(g.notes))
		composer.gotoScene( "edit", { effect = "slideLeft", time = g.timeSlide } )
	end
end

-- Handler that gets notified when the Clear alert closes
local function onClearAlertComplete( event )
    if event.action == "clicked" then
        if event.index == 2 then  -- Clear button on the alert (not Cancel)
        	-- Clear the model data 
			g.notes = {}
			g.noteIndex = nil
			g.note = nil

			-- Clear the table view to match 
			g.tableView:deleteAllRows()          
		end
    end
end

-- Handle the Clear button
local function onSettings(event)
	-- Show alert to confirm the clear
	--native.showAlert( "Note List", "Delete all Notes?", { "Cancel", "Clear" }, onClearAlertComplete )
	composer.gotoScene( "settings", {effect = "slideLeft", time = g.timeSlide} )
end

-- Handle the Add (+) button
local function onAdd( event )
	-- Make a new default car and edit it in the car view
	g.noteIndex = #g.notes + 1   -- Add new car past end of current list
	g.note = {}     -- Missing fields should become defaults
	composer.gotoScene( "edit", { effect = "slideLeft", time = g.timeSlide } )
	print( g.noteIndex )
end

-- Called when the scene's view does not exist.
function scene:create( event )
	local sceneGroup = self.view

	-- Make a light gray background
	local bg = display.newRect( sceneGroup, g.xCenter, g.yCenter, g.width, g.height )
	bg:setFillColor( 0.9 )

	-- Make the title
	g.makeTitle( sceneGroup, "Notes" )

	-- Create the Clear and Add buttons
	g.makeButton( sceneGroup, "Settings", g.xMin + 40, g.yTitle, onSettings )
	g.makeButton( sceneGroup, "+", g.xMax - 30, g.yTitle, onAdd )

	-- Create the table widget
	local margin = 5
	g.tableView = widget.newTableView
	{
	    left = g.xMin + margin,
	    top = g.yMin + g.topMargin,
	    width = g.width - margin * 2,
	    height = g.height - g.topMargin - margin,
	    onRowRender = onRowRender,
	    onRowTouch = onRowTouch,
	}
	sceneGroup:insert( g.tableView )
end

-- Called when the scene is about to show or is now showing
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Make sure the table widget has enough rows for the cars list
		local t = g.tableView
		while #g.notes > t:getNumRows() do
			t:insertRow{}
		end

		-- Init or reload the table widget for any changes made after editing
		if t:getNumRows() > 0 then
			g.tableView:reloadData()	 -- this crashes if there are 0 cars
		end
	end
end


---------------------------------------------------------------------------------

-- Composer listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

-----------------------------------------------------------------------------------------

return scene