--| FIXME NOT_REVIEWED this file has not been reviewed
indexing 
	description: "EiffelVision Combo-box. Implementation interface"
	note: "We cannot chAnge the feature `set_style' of wel_window%
		% to switch from editable to non editable because it%
		% doesn't for this kind of style changing."
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_COMBO_BOX_IMP

inherit
	EV_COMBO_BOX_I
		undefine
			set_default_colors
		redefine
			interface,
			initialize
		end

	EV_LIST_ITEM_LIST_IMP
		redefine
			interface,
			initialize
		end

	EV_TEXT_COMPONENT_IMP
		export {EV_INTERNAL_COMBO_FIELD_IMP, EV_INTERNAL_COMBO_BOX_IMP}
			on_left_button_up,
			on_middle_button_up,
			on_right_button_up,
			on_left_button_double_click,
			on_middle_button_double_click,
			on_right_button_double_click,
			on_mouse_move,
			on_key_down,
			on_key_up,
			on_set_focus,
			on_kill_focus,
			on_set_cursor
		undefine
			height,
			on_right_button_down,
			on_middle_button_down,
			on_left_button_down,
			on_left_button_up,
			pnd_press,
			set_default_colors
		redefine
			set_minimum_width_in_characters,
			set_default_minimum_size,
			wel_move_and_resize,
			set_editable,
			on_key_down,
			interface,
			initialize
		end
		
	WEL_DROP_DOWN_COMBO_BOX_EX
		rename
			make as wel_make,
			parent as wel_parent,
			set_parent as wel_set_parent,
			font as wel_font,
			set_font as wel_set_font,
			destroy as wel_destroy,
			shown as is_displayed,
			select_item as wel_select_item,
			selected_item as wel_selected_item,
			height as wel_height,
			width as wel_width,
			insert_item as wel_insert_item,
			set_limit_text as set_text_limit,
			set_text as wel_set_text,
			move as wel_move,
			x as x_position,
			y as y_position,
			resize as wel_resize,
			move_and_resize as wel_move_and_resize,
			item as wel_item,
			enabled as is_sensitive,
			count as wel_count
		export
			{EV_INTERNAL_COMBO_FIELD_IMP} edit_item
			{EV_INTERNAL_COMBO_BOX_IMP} combo_item
		undefine
			window_process_message,
			remove_command,
			set_width,
			set_height,
			on_left_button_down,
			on_right_button_down,
			on_left_button_up,
			on_right_button_up,
			on_left_button_double_click,
			on_right_button_double_click,
			on_mouse_move,
			on_set_focus,
			on_kill_focus,
			on_key_down,
			on_key_up,
			on_set_cursor,
			show,
			hide,
			on_size
		redefine
			on_cben_endedit_item,
			on_cbn_editchange,
			on_cbn_selchange,
			default_style
		end

	WEL_EM_CONSTANTS
		export
			{NONE} all
		end

creation
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a combo-box.
		do
			base_make (an_interface)
			internal_window_make (default_parent, Void, default_style +
				Cbs_dropdown, 0, 0, 0, 90, 0, default_pointer)
			create ev_children.make (2)
 			id := 0
		end

	initialize is
			-- Initialize combo box.
		do
			{EV_TEXT_COMPONENT_IMP} Precursor
			{EV_LIST_ITEM_LIST_IMP} Precursor
			create text_field.make_with_combo (Current)
			create combo.make_with_combo (Current)
		end

feature -- Access

	text_field: EV_INTERNAL_COMBO_FIELD_IMP
			-- An internal text field that forwards the events to the
			-- current combo-box-ex.

	combo: EV_INTERNAL_COMBO_BOX_IMP
			-- The combo_box inside the combo-box-ex. It forwards the
			-- events.

feature -- Measurement

	height: INTEGER is
			-- height of the combo-box when the list is hidden
			-- it is a constant.
		do
			Result := window_rect.height
		end

	extended_height: INTEGER is
			-- height of the combo-box when the list is shown.
		do
			Result := dropped_rect.height
		end

feature -- Status report

	item_height: INTEGER is
			-- height needed for an item.
		do
			Result := wel_font.log_font.height
		end

	is_selected (an_id: INTEGER): BOOLEAN is
			-- Is item given by the one-based index `an_id' selected?
		do
			if selected then
				Result := ( (an_id - 1) = wel_selected_item )
			end
		end

	selected_item: EV_LIST_ITEM is
			-- Currently selected item.
		local
			new_selected_item: EV_LIST_ITEM_IMP
		do
			if selected then
				new_selected_item := ev_children @ (wel_selected_item + 1)
					--| Arrays are zero-based in WEL and one-based in Vision2.
				Result := new_selected_item.interface
			end
		end

	has_selection: BOOLEAN is
			-- Is there a current text selection?
		local
			wel_sel: INTEGER
			start_pos, end_pos: INTEGER
				-- starting and ending character positions of the 
				-- current selection in the edit control
		do
			wel_sel := cwin_send_message_result (edit_item, Em_getsel, 0, 0)
			start_pos := cwin_hi_word (wel_sel)
			end_pos := cwin_lo_word (wel_sel)

				-- There is a current selection if the positions
				-- are different.
			Result :=  start_pos /= end_pos
		end

	internal_caret_position: INTEGER is
			-- Caret position.
		local
			wel_sel: INTEGER
		do
			wel_sel := cwin_send_message_result (edit_item, Em_getsel, 0, 0)
			Result := cwin_hi_word (wel_sel)
		end

feature -- Status setting

	set_text (a_text: STRING) is
			-- Set the text of the combo box.
		do
			wel_set_text (a_text)	
		end

	set_default_minimum_size is
			-- Called after creation. Set the current size and
			-- notify the parent.
		do
			--| FIXME ARNAUD: DON'T USE FIXED NUMBER, USE
			--| RELATIVE-FONT VALUES.
			internal_set_minimum_size (30, 22)
		end

	select_item (an_index: INTEGER) is
			-- Select the item at the one-based index `an_index'.
			--|--------------------------------------------------
			--| We cannot redefine this feature because then a
			--| postcondition is violated because of the change
			--| of index.
			--|--------------------------------------------------
		do
				-- Select the item in the combo box
			wel_select_item (an_index - 1)

				-- Deal with the selection change.
			on_cbn_selchange
		end

	deselect_item (an_index: INTEGER) is
			-- Unselect the item at the one-based index `an_index'.
		do
			clear_selection
		end

	clear_selection is
			-- Clear the selection of the list.
		do
				-- Unselect the item in the combo box
			unselect

				-- Deal with the selection change.
			on_cbn_selchange
		end

	set_editable (flag: BOOLEAN) is
			-- If `flag' then make `Current' read-write.
			-- If not `flag' then make `Current' read only.
		do
			if flag then
				set_read_write
			else
				set_read_only
			end
		end

	set_extended_height (value: INTEGER) is
			-- Make `value' the new extended-height of the box.
		do
			wel_resize (wel_width, value)
		end

	internal_set_caret_position (pos: INTEGER) is
			-- Set the caret position with `pos'.
		do
			cwin_send_message (edit_item, Em_setsel, pos, pos)
		end

feature -- Basic operation

	select_all is
			-- Select all the text.
		do
			cwin_send_message (edit_item, Em_setsel, 0, -1)
		end

	deselect_all is
			-- Unselect the current text selection.
		do
			cwin_send_message (edit_item, Em_setsel, -1, 0)
		end

	delete_selection is
			-- Delete the current selection.
		do
			cwin_send_message (edit_item, Wm_clear, 0, 0)
		end

	cut_selection is
			-- Cut the current selection to the clipboard.
		do
			cwin_send_message (edit_item, Wm_cut, 0, 0)
		end

	copy_selection is
			-- Copy the current selection to the clipboard.
		do
			cwin_send_message (edit_item, Wm_copy, 0, 0)
		end

	clip_paste is
			-- Paste at the current caret position the
			-- content of the clipboard.
		do
			cwin_send_message (edit_item, Wm_paste, 0, 0)
		end

	replace_selection (txt: STRING) is
			-- Replace the current selection with `new_text'.
			-- If there is no selection, `new_text' is inserted
			-- at the current `caret_position'.
		require
			exists: exists
			text_not_void: txt /= Void
		local
			wel_str: WEL_STRING
		do
			create wel_str.make (txt)
			cwin_send_message (edit_item, Em_replacesel, 
				0, cwel_pointer_to_integer (wel_str.item))
		end

feature {EV_LIST_ITEM_IMP} -- Implementation

	internal_select_item (item_imp: EV_LIST_ITEM_IMP) is
			-- Select `item_imp' in the list.
		do
			select_item (internal_get_index (item_imp))
		end

	internal_is_selected (item_imp: EV_LIST_ITEM_IMP): BOOLEAN is
			-- Is `item_imp' selected in the list?
		do
			Result := is_selected (internal_get_index (item_imp))
		end

	internal_deselect_item (item_imp: EV_LIST_ITEM_IMP) is
			-- Deselect `item_imp' in the list.
		do
			deselect_item (internal_get_index (item_imp))
		end

	internal_get_index (item_imp: EV_LIST_ITEM_IMP): INTEGER is
			-- Return the index of `item_imp' in the list.
		do
			Result := ev_children.index_of (item_imp, 1)
		end

   	get_item_position (an_index: INTEGER): WEL_POINT is
   			-- Retrieves the position of the zero-based `index'-th item.
   			-- in the drop-down list.
   		local
   			item_imp: EV_LIST_ITEM_IMP
   		do
   			create Result.make (0, 0)
   			item_imp := ev_children @ (an_index + 1)

   			if item_imp.is_displayed then
   				Result.set_y ((an_index - top_index) * item_height)
   			end
   		end

	visible_count: INTEGER is
   			-- Number of items that can be displayed in the list.
   		local
   			wel_rect: WEL_RECT
   			list_height: INTEGER
   		do
   			wel_rect := dropped_rect
   			list_height := wel_rect.bottom - wel_rect.top

   			Result := list_height // list_item_height
		end

feature {NONE} -- Implementation

	internal_propagate_pointer_press (keys, x_pos, y_pos, button: INTEGER) is
			-- Propagate `keys', `x_pos' and `y_pos' to the appropriate 
			-- item event.
		do
			--|FIXME Implement
			--check
			--	To_be_implemented: False
			--end
		end

	recreate_combo_box (creation_flag: INTEGER) is
			-- Destroy the existing combo box and recreate
			-- a new one with `creation_flag' in the style
		local
			par_imp		: WEL_WINDOW
			cur_x		: INTEGER
			cur_y		: INTEGER
			cur_width	: INTEGER
			cur_height	: INTEGER
		do
				-- We keep some useful informations that will be
				-- destroyed when calling `wel_destroy'
			par_imp ?= parent_imp
			cur_x := x_position
			cur_y := y_position
			cur_width := wel_width
			cur_height := wel_height

				-- We destroy the old combo
			wel_destroy

				-- We create the new combo.
			internal_window_make (par_imp, Void, default_style + creation_flag,
				cur_x, cur_y, cur_width, cur_height, 0, default_pointer)
 			id := 0
			internal_copy_list
		end

	set_read_only is
			-- Make `Current' read only.
		do
			if is_editable then
				recreate_combo_box (Cbs_dropdownlist)
					
					-- Remove the text field and create a combo.
				text_field := Void
				create combo.make_with_combo (Current)
			end
		end

	set_read_write is
			-- Make `Current' read-writeable.
		do
			if not is_editable then
				recreate_combo_box (Cbs_dropdown)
					
					-- Remove the combo and create a text field.
				combo := Void
 	 			create text_field.make_with_combo (Current)
			end
		end

	read_only: BOOLEAN is
			-- Is `Current' read-only?
		do
			Result := flag_set (style, Cbs_dropdownlist)
		end

	internal_copy_list is
			-- Take an empty list and initialize all the children with
			-- the contents of `ev_children'.
		local
			original_index: INTEGER
		do
			original_index := ev_children.index
			from
				ev_children.start
			until
				ev_children.after
			loop
				add_string (ev_children.item.wel_text)
				ev_children.forth
			end
			ev_children.go_i_th (original_index)
		ensure
			index_not_changed: index = old index
		end

	insert_item (item_imp: EV_LIST_ITEM_IMP; an_index: INTEGER) is
			-- Insert `item_imp' at the one-based index `an_index'.
		do
			insert_string_at (item_imp.wel_text, an_index - 1)
		end

	remove_item (item_imp: EV_LIST_ITEM_IMP) is
			-- Remove `item_imp'.
		local
			an_index: INTEGER
		do
			an_index := internal_get_index (item_imp)
			delete_string (an_index - 1)
		end

feature {EV_INTERNAL_COMBO_FIELD_IMP, EV_INTERNAL_COMBO_BOX_IMP}
	-- WEL Implementation

	on_key_down (virtual_key, key_data: INTEGER) is
			-- We check if the enter key is pressed.
			-- 13 is the number of the return key.
		local
			list: like ev_children
			counter: INTEGER
			found: BOOLEAN
		do
			{EV_TEXT_COMPONENT_IMP} Precursor (virtual_key, key_data)
			process_tab_key (virtual_key)
			if virtual_key = Vk_return then
				-- If return pressed, select item with matching text.
				list := ev_children
				from
					list.start
					counter := 1
				until
					counter = list.count + 1 or found
				loop
					if equal (list.item.text, text) then
						if not is_selected (counter) then
							select_item (counter)
						end
						found := True
					end
					list.forth
					counter := counter + 1
				end
			elseif selected and equal (text, selected_item.text) and
			   (virtual_key /= Vk_tab) and (virtual_key /= Vk_down) and
			   (virtual_key /= Vk_up) and (virtual_key /= Vk_f4)
			   		--| Note: F4 is used to open/close the list.
			then
					-- If a key is pressed and a selection is set,
					-- we clear the selection.
				clear_selection
			end
		end

feature {NONE} -- WEL Implementation

	default_style: INTEGER is
			-- Style used to create `Current'.
		do
			Result := Ws_child + Ws_visible + Ws_group
						+ Ws_tabstop + Ws_vscroll
						+ Cbs_autohscroll
		end

	old_selected_item: EV_LIST_ITEM_IMP
			-- The previously selected item.

	last_edit_change: STRING
			-- The string resulting from the last edit change.

	on_cben_endedit_item (info: WEL_NM_COMBO_BOX_EX_ENDEDIT) is
			-- The user has concluded an operation within the edit box
			-- or has selected an item from the control's drop-down list.
		do
			if info.why = Cbenf_return then
				set_caret_position (1)
			end
		end

	on_cbn_selchange is
			-- The selection is about to change.
		local
			new_selected_item: EV_LIST_ITEM_IMP
		do
					-- Retrieve the new selected item.
			if selected then
				new_selected_item := ev_children.i_th (wel_selected_item + 1)
			else
				new_selected_item := Void
			end

			if not equal (old_selected_item, new_selected_item) then
					-- Send a "Deselect Action" to the old item, and
					-- to the combo box.
				if old_selected_item /= Void then
					old_selected_item.interface.deselect_actions.call ([])
					interface.deselect_actions.call
						([old_selected_item.interface])
				end
					-- Send a "Select Action" to the new item, and
					-- to the combo box.
				if new_selected_item /= Void then
					new_selected_item.interface.select_actions.call ([])
					interface.select_actions.call
						([new_selected_item.interface])
				end
					-- Remember the current selected item.
				old_selected_item := new_selected_item
			end
		end

	on_cbn_editchange is
			-- The edit control portion is about to
			-- display altered text.
		do
			if not equal (text, last_edit_change) then
				interface.change_actions.call ([])
			end
			last_edit_change := text
		end

   	move_and_resize (a_x, a_y, a_width, a_height: INTEGER; repaint: BOOLEAN) is
	   		-- Resize Message for the combo-box.
   		do
	   			-- We must not resize the height of the combo-box.
  			cwin_move_window (wel_item, a_x, a_y, a_width, height, repaint)
  		end

	set_selection (start_pos, end_pos: INTEGER) is
			-- Hilight the text between `start_pos' and `end_pos'. 
			-- Both `start_pos' and `end_pos' are selected.
		do
			cwin_send_message (wel_item, Cb_seteditsel, 0, cwin_make_long (
				start_pos, end_pos))
		end

	wel_selection_start: INTEGER is
			-- Index of the first character selected
		do
			Result := cwin_lo_word (cwin_send_message_result (edit_item,
				Em_getsel, 0, 0))
		end

	wel_selection_end: INTEGER is
			-- Index of the last character selected
		do
			Result := cwin_hi_word (cwin_send_message_result (edit_item,
				Em_getsel, 0, 0))
		end

Feature -- Temp

	set_minimum_width_in_characters (nb: INTEGER) is
			-- Make `nb' characters visible on one line.
			-- We add nine for the borders.
		do
			--|FIXME Magic numbers.
			set_minimum_width (nb * 6 + 9)
		end

feature {NONE} -- Feature that should be directly implemented by externals

	next_dlgtabitem (hdlg, hctl: POINTER; previous: BOOLEAN): POINTER is
			-- Encapsulation of the SDK GetNextDlgTabItem,
			-- because we cannot do a deferred feature become an
			-- external feature.
		do
			Result := cwin_get_next_dlgtabitem (hdlg, hctl, previous)
		end

	next_dlggroupitem (hdlg, hctl: POINTER; previous: BOOLEAN): POINTER is
			-- Encapsulation of the SDK GetNextDlgGroupItem,
			-- because we cannot do a deferred feature become an
			-- external feature.
		do
			check
				Never_called: False
			end
		end

	mouse_message_x (lparam: INTEGER): INTEGER is
			-- Encapsulation of the c_mouse_message_x function of
			-- WEL_WINDOW. Normaly, we should be able to have directly
			-- c_mouse_message_x deferred but it does not wotk because
			-- it would be implemented by an external.
		do
			Result := c_mouse_message_x (lparam)
		end

	mouse_message_y (lparam: INTEGER): INTEGER is
			-- Encapsulation of the c_mouse_message_x function of
			-- WEL_WINDOW. Normaly, we should be able to have directly
			-- c_mouse_message_x deferred but it does not wotk because
			-- it would be implemented by an external.
		do
			Result := c_mouse_message_y (lparam)
		end

	show_window (hwnd: POINTER; cmd_show: INTEGER) is
			-- Encapsulation of the cwin_show_window function of
			-- WEL_WINDOW. Normaly, we should be able to have directly
			-- c_mouse_message_x deferred but it does not wotk because
			-- it would be implemented by an external.
		do
			cwin_show_window (hwnd, cmd_show)
		end

feature {EV_LIST_I} -- Implementation

	interface: EV_COMBO_BOX

end -- class EV_COMBO_BOX_IMP

--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-1998 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

--|-----------------------------------------------------------------------------
--| CVS log
--|-----------------------------------------------------------------------------
--|
--| $Log$
--| Revision 1.79  2000/06/09 01:38:09  manus
--| MErged version 1.50.2.7 from DEVEL branch to trunc
--|
--| Revision 1.50.2.7  2000/05/30 16:01:14  rogers
--| Removed unreferenced variables.
--|
--| Revision 1.50.2.6  2000/05/10 20:02:10  king
--| Integrated with new list_item_list structure
--|
--| Revision 1.50.2.5  2000/05/04 00:19:57  rogers
--| Comments and formatting.
--|
--| Revision 1.50.2.4  2000/05/03 22:35:04  brendel
--| Fixed resize_actions.
--|
--| Revision 1.50.2.3  2000/05/03 22:17:18  pichery
--| - Cosmetics / Optimization with local variables
--| - Replaced calls to `width' to calls to `wel_width'
--|   and same for `height'.
--|
--| Revision 1.50.2.2  2000/05/03 19:09:49  oconnor
--| mergred from HEAD
--|
--| Revision 1.76  2000/04/27 23:24:04  rogers
--| Undefined on_left_button_up from EV_TEXT_COMPONENT_IMP.
--|
--| Revision 1.75  2000/04/21 01:20:17  pichery
--| Commented check.
--|
--| Revision 1.74  2000/04/20 01:12:38  pichery
--| Complete Refactoring.
--|
--| Revision 1.73  2000/04/17 20:58:10  brendel
--| Commented out check False since the user can't even click on it.
--|
--| Revision 1.72  2000/04/17 18:40:58  brendel
--| Instead of undefining count from the WEL object, we rename it
--| because it is used in a WEL postcondition.
--|
--| Revision 1.71  2000/04/17 17:29:05  rogers
--| Added wel_window_parent fix.
--|
--| Revision 1.70  2000/04/11 19:01:29  rogers
--| Moved creation of ev_children into make.
--|
--| Revision 1.69  2000/04/11 17:02:39  rogers
--| Added internal_propagate_pointer_press.
--|
--| Revision 1.68  2000/04/06 17:01:42  rogers
--| Undefined count from WEL_COMBO_BOX_eXbutton_rectangle: WEL_RECT
--|
--| Revision 1.67  2000/03/30 22:40:04  rogers
--| Fixed by re-implementing : is_item_imp_selected, select_item_imp,
--| deselect_item_imp and internal_set_text_item.
--|
--| Revision 1.66  2000/03/30 18:11:12  brendel
--| Removed `insert_item'.
--| Added `top_index'.
--|
--| Revision 1.65  2000/03/30 17:44:44  brendel
--| Now inherits EV_LIST_ITEM_LIST_IMP.
--| Formatted for 80 columns.
--|
--| Revision 1.64  2000/03/30 16:24:14  rogers
--| Implemented insert_item
--| -----------------------------------------------------
--|
--| Revision 1.63  2000/03/24 19:30:38  rogers
--| Added call to {EV_LIST_ITEM_HOLDER_IMP} Precursor in initialize.
--|
--| Revision 1.62  2000/03/23 17:55:45  rogers
--| Removed some redundent lines.
--|
--| Revision 1.61  2000/03/22 20:16:19  rogers
--| Renamed
--| 	move_and_resize -> wel_move_and_resize,
--| 	move -> wel_move,
--| 	x -> x_position,
--| 	y -> y_position,
--| 	resize -> wel_Resize.
--| Fixed any references to these old names.
--|
--| Revision 1.60  2000/03/07 00:19:55  rogers
--| Corrected all select and deselect actions which did not previously call
--| the child's events first.
--|
--| Revision 1.59  2000/03/06 20:51:32  rogers
--| The list select and deselect action sequences now only return the selected
--| item, so any calls
--| to these action sequences have been modified.
--|
--| Revision 1.58  2000/03/02 18:10:33  rogers
--| Corrected two non working calls to a child's selection events.
--|
--| Revision 1.57  2000/03/02 17:29:27  rogers
--| Added calls to the children's select and deselect events.
--|
--| Revision 1.55  2000/03/02 16:38:35  rogers
--| Is selected and selected_item have had checks added, to limit the wel calls
--| when unecessary.
--| Fixed the call to deselect_actions in on_key_down.
--|
--| Revision 1.54  2000/03/01 16:39:10  rogers
--| Redfined initialize, commented out old command association.
--|
--| Revision 1.53  2000/02/19 06:34:13  oconnor
--| removed old command stuff
--|
--| Revision 1.52  2000/02/17 02:18:41  oconnor
--| released
--|
--| Revision 1.51  2000/02/14 11:40:44  oconnor
--| merged changes from prerelease_20000214
--|
--| Revision 1.50.2.1.2.3  2000/01/29 02:19:55  rogers
--| Modified to comply with the major vision2 changes. It is not currently
--| working.
--|
--| Revision 1.50.2.1.2.2  2000/01/27 19:30:26  oconnor
--| added --| FIXME Not for release
--|
--| Revision 1.50.2.1.2.1  1999/11/24 17:30:31  oconnor
--| merged with DEVEL branch
--|
--| Revision 1.47.2.3  1999/11/02 17:20:09  oconnor
--| Added CVS log, redoing creation sequence
--|
--|
--|-----------------------------------------------------------------------------
--| End of CVS log
--|-----------------------------------------------------------------------------
