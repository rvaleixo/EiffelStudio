note
	legal: "See notice at end of class."
	status: "See notice at end of class."
class
	MAIN_WINDOW

inherit 

	WEL_FRAME_WINDOW
		redefine
			on_paint,
			on_left_button_down,
			on_left_button_up,
			on_mouse_move,
			on_menu_command,
			on_key_down,
			on_timer,
			class_icon
		end

	WEL_RASTER_OPERATIONS_CONSTANTS
		export
			{NONE} all
		end

	WEL_PC_CONSTANTS
		export
			{NONE} all
		end

	WEL_VK_CONSTANTS
		export
			{NONE} all
		end

	APPLICATION_IDS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Make the window.
		do
			zoom := 4
			create zoom_point.make (100, 100)
			make_top (Title)
			resize (44 * zoom, 36 * zoom)
			is_tracking := False
			is_refreshing := False
			set_menu (main_menu)
		end

feature -- Access

	cx_zoomed: INTEGER
			-- X coordinate on screen
		do 
			Result := (client_rect.right // zoom) + 1
		end

	cy_zoomed: INTEGER
			-- Y coordinate on screen
		do 
			Result := (client_rect.bottom // zoom) + 1
		end
	
	zoom_point: WEL_POINT
			-- Hot spot

	zoom: INTEGER
			-- Zoom factor (4 by default)

	palette: WEL_PALETTE
			-- Physical palette to grab images on the screen
		local
			log_palette: WEL_LOG_PALETTE
			entry: WEL_PALETTE_ENTRY
			i: INTEGER
		once
			from
				create log_palette.make (Windows_95, 256)
			until	
				i = 256
			loop
				create entry.make (i, 0, 0, Pc_explicit)
				log_palette.set_pal_entry (i, entry)
				i := i + 1
			end
			create Result.make (log_palette)
		end

feature -- Messages

	on_paint (paint_dc: WEL_PAINT_DC; invalid_rect: WEL_RECT)
			-- Zoom in rectangle on screen.
		do
			zoom_in
		end

	on_left_button_down (keys, x_pos, y_pos: INTEGER)
			-- Draw zoom rectangle and paint window.
		do
			zoom_point.set_x_y (x_pos, y_pos)
			zoom_point.client_to_screen (Current)
			if zoom_point.x > screen_width then
				zoom_point.set_x (zoom_point.x - 65535)
			end
			if zoom_point.y > screen_height then
				zoom_point.set_y (zoom_point.y - 65535)
			end
			draw_zoom_rect
			zoom_in
			set_capture
			is_tracking := True
		end

	on_left_button_up (keys, x_pos, y_pos: INTEGER)
			-- Stop grabbing.
		do
			if is_tracking then
				draw_zoom_rect
				release_capture
				is_tracking := False
			end
		end

	on_mouse_move (keys, x_pos, y_pos: INTEGER)
			-- Repaint window with new region.
		do
			if is_tracking then
				draw_zoom_rect
				zoom_point.set_x_y (x_pos, y_pos)
				zoom_point.client_to_screen (Current)
				if zoom_point.x > screen_width then
					zoom_point.set_x (zoom_point.x - 65535)
				end
				if zoom_point.y > screen_height then
					zoom_point.set_y (zoom_point.y - 65535)
				end
				draw_zoom_rect 
				zoom_in
			end
		end

	on_menu_command (id_menu: INTEGER)
			-- Process the command identified by `id_menu'.
		do
			if id_menu = Cmd_exit then
				destroy
			elseif id_menu = Cmd_zoom_in then
				increase_zoom
			elseif id_menu = Cmd_zoom_out then
				decrease_zoom
			elseif id_menu = Cmd_refresh then
				invalidate
			elseif id_menu = Cmd_automatic_refresh then
				if not is_refreshing then 
					main_menu.check_item (Cmd_automatic_refresh)
					set_timer (1, 100)
				else
					main_menu.uncheck_item	(Cmd_automatic_refresh)
					kill_timer (1)
				end
				is_refreshing := not is_refreshing
			elseif id_menu = Cmd_quickref then
				quick_reference.activate
			elseif id_menu = Cmd_about then
				about_box.activate
			end
		end

	on_key_down (virtual_key, key_data: INTEGER)
			-- Wm_keydown message.
		do
			if virtual_key = Vk_add then
				increase_zoom
			elseif virtual_key = Vk_subtract then
				decrease_zoom
			elseif virtual_key = Vk_f5 then
				invalidate
			end
		end

	on_timer (timer_id: INTEGER)
			-- Refresh the window.
		do
			zoom_in
		end

feature -- Status Report

	is_tracking: BOOLEAN
			-- Is mouse moving with left button pressed?

	is_refreshing: BOOLEAN
			-- Is automatic refreshing on?

feature {NONE} -- Implementation

	bound (x_arg, min, max: INTEGER): INTEGER
			-- Adjust coordinates so that it stand in screen bounds.
		do
			if x_arg < min then
				Result := min
			elseif x_arg > max then
				Result := max
			else 
				Result := x_arg
			end
		end

	zoom_in
			-- Stretch screen region in rectangle.
		local
			screen_dc: WEL_SCREEN_DC
			x1, y1: INTEGER
			dc: WEL_CLIENT_DC
		do
			create dc.make (Current)
			dc.get
			dc.select_palette (palette)
			dc.realize_palette
			create screen_dc
			screen_dc.get
			x1 := bound (zoom_point.x, cx_zoomed // 2,
				screen_width - 1 - cx_zoomed // 2)
			y1 := bound (zoom_point.y, cy_zoomed // 2,
				screen_height - 1 - cy_zoomed // 2)
			dc.stretch_blt (0, 0, zoom * cx_zoomed,
				zoom * cy_zoomed, screen_dc,
				x1 - cx_zoomed // 2, y1 - cy_zoomed // 2,
				cx_zoomed, cy_zoomed, Srccopy)
			screen_dc.release
			dc.unselect_palette
			dc.release
		end

	draw_zoom_rect
			-- Draw rectangle with inverted borders.
		local
			a_rect: WEL_RECT
			x1, y1: INTEGER
			sdc: WEL_SCREEN_DC
		do
			x1 := bound (zoom_point.x, cx_zoomed // 2,
				screen_width - 1 - cx_zoomed // 2)
			y1 := bound (zoom_point.y, cy_zoomed // 2,
				screen_height - 1 - cy_zoomed // 2)
			create a_rect.make (x1 - cx_zoomed // 2,
				y1 - cx_zoomed // 2,
				x1 - cx_zoomed // 2 + cx_zoomed,
				y1 - cy_zoomed // 2 + cy_zoomed)
			a_rect.inflate (1, 1)
			create sdc
			sdc.get
			sdc.pat_blt (a_rect.left,
				a_rect.top, a_rect.width, 1, Dstinvert)
			sdc.pat_blt (a_rect.right, a_rect.top, 1,
				a_rect.height, Dstinvert)
			sdc.pat_blt (a_rect.left, a_rect.top, 1,
				a_rect.height, Dstinvert)
			sdc.pat_blt (a_rect.left, a_rect.bottom,
				a_rect.width, 1, Dstinvert)
			sdc.release
		end
	
	increase_zoom
			-- Add 1 to current zoom value.
		do
			if zoom < Max_zoom then
				zoom := zoom + 1
				zoom_in
			end
		ensure
			zoom_increased: zoom < Max_zoom implies
				zoom = old zoom + 1
		end

	decrease_zoom
			-- Subtract 1 to current zoom value.
		do
			if zoom > Min_zoom then
				zoom := zoom - 1
				zoom_in
			end
		ensure
			zoom_decreased: zoom > Min_zoom implies
				zoom = old zoom - 1
		end

	Windows_95: INTEGER = 768
			-- Windows version

	Max_zoom: INTEGER = 32
			-- Maximum zoom value

	Min_zoom: INTEGER = 1
			-- Minimum zoom value

	about_box: WEL_MODAL_DIALOG
			-- About dialog box
		once
			create Result.make_by_id (Current, About_dlg_id)
		ensure
			Result_not_void: Result /= Void
		end

	quick_reference: WEL_MODAL_DIALOG
			-- Quick reference dialog box
		once
			create Result.make_by_id (Current, Quickref_dlg_id)
		ensure
			Result_not_void: Result /= Void
		end

	main_menu: WEL_MENU
			-- Window's menu
		once
			create Result.make_by_id (Id_main_menu)
		ensure
			menu_not_void: Result /= Void
		end

	class_icon: WEL_ICON
			-- Window's icon
		once
			create Result.make_by_id (Id_ico_application)
		end

	Title: STRING = "WEL Magnify"
			-- Window's title

invariant
	zoom_in_bounds: Min_zoom <= zoom and zoom <= Max_zoom

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end -- class MAIN_WINDOW

