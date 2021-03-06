note
	description	: "Command to show the preference window."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author		: "Arnaud PICHERY [aranud@mail.dotcom.fr]"
	date		: "$Date$"
	revision	: "$Revision$"

class EB_SHOW_PREFERENCES_COMMAND

inherit
	EB_MENUABLE_COMMAND

	EB_SHARED_WINDOW_MANAGER
		export
			{NONE} all
		end

	EB_SHARED_PREFERENCES

create
	make

feature {NONE} -- Initialization

	make
			-- Create this command.
		do
		end

feature {NONE} -- Execution

	execute
			-- Execute command.
		local
			l_show_hidden_flag: BOOLEAN
		do
			l_show_hidden_flag := preferences.misc_data.show_hidden_preferences
			if preference_window = Void or else preference_window.is_destroyed then
					-- Preference tool is not currently displayed, create and display it.
				create preference_window.make_with_hidden (preferences.preferences,l_show_hidden_flag)
			end
			preference_window.set_size (preferences.misc_data.preference_window_width, preferences.misc_data.preference_window_height)
			preference_window.set_show_hidden_preferences (l_show_hidden_flag)
			preference_window.raise
		end

feature -- Properties

	name: STRING
			-- Command name
		do
			Result := "Preferences"
		end

	menu_name: STRING_GENERAL
			-- Name used in menu entry
		do
			Result := Interface_names.m_Preferences
		end

feature {NONE} -- Implementation

	preference_window: EB_PREFERENCES_WINDOW;
			-- Current preference window if any.

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EB_SHOW_PREFERENCE_TOOL
