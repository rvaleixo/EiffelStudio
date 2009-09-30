note
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_GOTO_DIALOG

inherit
	EB_GOTO_DIALOG_IMP

	EB_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	SHARED_BENCH_NAMES
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	EV_LAYOUT_CONSTANTS
		undefine
			default_create, copy, is_equal
		end

create
	make

feature -- Creation

	make (a_text_panel: like editor)
			-- Make with text panel
		require
			text_panel_not_void: a_text_panel /= Void
		do
			default_create
			editor := a_text_panel
			initialize_line_number_label_text
			line_number_text.focus_in_actions.extend (agent line_number_text.select_all)
			show_actions.extend (agent line_number_text.set_focus)
		ensure
			editor_set: editor = a_text_panel
		end

feature {NONE} -- Initialization

	user_initialization
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			set_title (names.t_go_to_line)
			line_number_label.set_text (names.l_line_number)
			go_button.set_text (names.b_go_to)
			cancel_button.set_text (names.b_cancel)
			cancel_button.select_actions.extend (agent destroy)
			set_default_cancel_button (cancel_button)
			go_button.select_actions.extend (agent goto_line)
			line_number_text.key_press_actions.extend (agent on_key_pressed)
			line_number_text.change_actions.extend (agent on_value_changed (?))
			line_number_text.text_change_actions.extend (agent on_value_changed (-1))
			set_icon_pixmap (pixmaps.icon_pixmaps.general_dialog_icon)
			set_default_size_for_button (go_button)
			set_default_size_for_button (cancel_button)
		end

	initialize_line_number_label_text
			-- Set line number label text
		local
			l_line_count, l_line_number: INTEGER
		do
			l_line_count := editor.number_of_lines
			if l_line_count > 0 then
				line_number_label.set_text (names.l_line_number_range (editor.number_of_lines.out))
				line_number_text.value_range.resize_exactly (1, l_line_count)
				if editor.text_displayed /= Void then
					l_line_number := editor.text_displayed.current_line_number
				else
					check editor_not_usable: False end
				end
				line_number_text.set_value (l_line_number)
			end
		end

feature {NONE} -- Implementation

	editor: EB_CLICKABLE_EDITOR
			-- Editor to search

	goto_line
			-- Goto line
		local
			l_line: INTEGER
		do
			if not editor.is_empty and then line_number_text.text.is_integer then
				l_line := line_number_text.text.to_integer
				if l_line > editor.number_of_lines then
					l_line := editor.number_of_lines
				elseif l_line < 1 then
					l_line := 1
				end
				editor.scroll_to_start_of_line_when_ready_if_top (l_line.min (editor.vertical_scrollbar.value_range.upper), 0, False, False)
			end
		end

	on_key_pressed (a_key: EV_KEY)
			-- Key was pressed in line number text field box
		do
			if a_key.code = {EV_KEY_CONSTANTS}.key_enter and then line_number_text.text.is_integer then
				go_button.enable_sensitive
				goto_line
			end
		end

	on_value_changed (a_value: INTEGER)
			-- Text field changed
		local
			i: INTEGER
		do
			if line_number_text.text.is_integer then
				i := line_number_text.text.to_integer
				if i >= 1 and then i <= editor.number_of_lines then
					go_button.enable_sensitive
				else
					go_button.disable_sensitive
				end
			else
				go_button.disable_sensitive
			end
		end

invariant
	has_editor: editor /= Void

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class GOTO_DIALOG

