indexing
	description	: "Command to create a new feature."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"

class
	EB_TOGGLE_FEATURE_SIGNATURE_COMMAND

inherit
	EB_TOOLBARABLE_TOGGLE_COMMAND
		redefine
			mini_pixmap
		end

	EB_DEVELOPMENT_WINDOW_COMMAND

	SHARED_WORKBENCH

create
	make

feature -- Basic operations

	execute is
			-- show/hide signature
		do
			target.tools.features_tool.toggle_signatures
		end

feature -- Access

	mini_pixmap: EV_PIXMAP is
			-- Pixmap representing the command for mini toolbars.
		do
			Result := pixmaps.mini_pixmaps.completion_show_signature_icon
		end

feature {NONE} -- Implementation

	pixmap: EV_PIXMAP is
			-- Pixmaps representing the command.
		do
		end

	pixel_buffer: EV_PIXEL_BUFFER is
			-- Pixel buffer representing the command.
		do
			-- Currently there is no pixel buffer for this command.
		end
		
	tooltip: STRING_GENERAL is
			-- Tooltip for the toolbar button.
		do
			if target.tools.features_tool.is_signature_enabled then
				Result := Interface_names.f_hide_signature
			else
				Result := Interface_names.f_show_signature
			end
		end

	is_selected: BOOLEAN is
		do
			Result := target.tools.features_tool.is_signature_enabled
		end

	description: STRING_GENERAL is
			-- Description for this command.
		do
			Result := Interface_names.l_toggle_signature
		end

	name: STRING is "Toggle_feature_signature";
			-- Name of the command. Used to store the command in the
			-- preferences.

indexing
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

end
