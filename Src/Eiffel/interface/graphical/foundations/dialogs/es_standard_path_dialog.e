note
	description: "[
		ESF standard dialogs exposing paths and supporting sticky path locations for like dialogs.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_STANDARD_PATH_DIALOG [G -> EV_STANDARD_DIALOG]

inherit
	ES_STANDARD_DIALOG [G]
		redefine
			on_after_initialized,
			on_closed
		end

-- inherit {NONE}
	SHARED_WORKBENCH
		export
			{NONE} all
		end

	EIFFEL_LAYOUT
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make_with_sticky_path (a_title: attached READABLE_STRING_GENERAL; a_id: attached like sticky_path_id)
			-- Initializes the dialog and perserves the path automatically between showns.
			--
			-- `a_title': The title to set on the standard dialog.
			-- `a_id': An ID used to perserve the dialog's path.
			--         Use an empty string ("") to save the path for all dialogs.
		require
			not_a_title_is_empty: not a_title.is_empty
		do
			sticky_path_id := a_id.twin
			make (a_title)
		ensure
			is_initialized: is_initialized
			is_initializing_unchanged: old is_initializing = is_initializing
			sticky_path_id_set: sticky_path_id ~ a_id
		end

	on_after_initialized
			-- <Precursor>
		do
			Precursor

				-- This may look weird but `start_path' uses cached, sticky or Eiffel projects path.
			set_start_path (start_path)
		end

feature -- Access

	start_path: PATH assign set_start_path
			-- Initial path nagivated to when showing the dialog
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
		local
			l_result: detachable PATH
			l_id: like sticky_path_id
		do
			if attached internal_start_path as l_path then
				Result := l_path
			else
				if is_path_sticky then
					l_id := sticky_path_id
					check l_id_attached: l_id /= Void end
					if sticky_paths.has (l_id) then
							-- Set stick path from previous show.
						l_result := sticky_paths.item (l_id)
					end
				end
				if l_result = Void then
					if workbench.system_defined then
							-- Use the project location
						l_result := workbench.project_location.path
					else
							-- Use the working directory
						l_result := (create {EXECUTION_ENVIRONMENT}).current_working_path
					end
				end
				Result := l_result
				internal_start_path := Result
			end
		ensure
			result_consistent: Result ~ start_path
			not_result_is_empty: not Result.is_empty
		end

	path: PATH
			-- Retrieves the dialog's path, which will be used on next show
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
			is_confirmed: is_confirmed
		deferred
		ensure
			not_result_is_empty: not Result.is_empty
		end

feature {NONE} -- Access

	sticky_paths: HASH_TABLE [PATH, STRING]
			-- Table of sticky path names.
		once
			create Result.make (10)
		end

	sticky_path_id: detachable STRING
			-- ID use to retain a sticky path to the last navigated folder.

feature {NONE} -- Element change

	set_start_path (a_path: like start_path)
			-- Sets the dialog's initial start path, where the dialog will navigate to on show.
			--
			-- `a_path': The default start path.
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
			not_a_path_is_empty: a_path /= Void implies not a_path.is_empty
			a_path_exists: a_path /= Void implies (create {DIRECTORY}.make_with_path (a_path)).exists
		local
			l_path: detachable like start_path
		do
			if a_path /= Void then
				internal_start_path := a_path.twin
				l_path := a_path
			else
				internal_start_path := Void
			end
			set_start_path_on_dialog (l_path, dialog)
		ensure
			internal_start_path_set: internal_start_path ~ a_path
			start_path_set: a_path /= Void implies start_path ~ a_path
		end

feature {NONE} -- Element change

	set_start_path_on_dialog (a_path: detachable like start_path; a_dialog: like dialog)
			-- Sets the start path on a dialog.
			--
			-- `a_path': The initial start location to set.
			-- `a_dialog': A dialog to set the start location on.
		require
			is_interface_usable: is_interface_usable
			not_a_path_is_empty: a_path /= Void implies not a_path.is_empty
			a_path_exists: a_path /= Void implies (create {DIRECTORY}.make_with_path (a_path)).exists
			not_a_dialog_is_destroyed: not a_dialog.is_destroyed
		deferred
		end

feature {NONE} -- Status report

	is_path_sticky: BOOLEAN
			-- Indicates if the dialog's path is perserve between dialogs shows.
		require
			is_interface_usable: is_interface_usable
		do
			Result := sticky_path_id /= Void
		ensure
			sticky_path_id_attached: Result implies sticky_path_id /= Void
		end

feature {NONE} -- Helpers

	file_utilities: attached GOBO_FILE_UTILITIES
			-- File utilities
		once
			create Result
		end

feature {NONE} -- Action handlers

	on_closed
			-- <Precursor>
		local
			l_id: like sticky_path_id
		do
			Precursor
			if is_path_sticky and then is_confirmed then
					-- The dialog was confirmed, set a stick folder
				l_id := sticky_path_id
				check l_id_attached: l_id /= Void end
				sticky_paths.force (path, l_id)
			end
		end

feature {NONE} -- Implementation: Internal cache

	internal_start_path: detachable like start_path
			-- Cached version of `start_path'.
			-- Note: Do not use directly!

;note
	copyright:	"Copyright (c) 1984-2013, Eiffel Software"
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

end
