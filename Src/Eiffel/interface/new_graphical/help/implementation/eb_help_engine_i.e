note
	description: "Help engine, displays help context, implementation interface"
	legal: "See notice at end of class."
	status: "See notice at end of class."

deferred class
	EB_HELP_ENGINE_I

feature -- Status Report

	last_show_successful: BOOLEAN
			-- Was last call to `show' successful?
		deferred
		ensure
			message_if_failed: not Result implies (last_error_message /= Void and then not last_error_message.is_empty)
		end

	last_error_message: STRING_GENERAL
			-- Last error message, if any
		deferred
		end

feature -- Basic Operations

	show (a_help_context: EB_HELP_CONTEXT)
			-- Show help with context `a_help_context'.
		deferred
		end

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

end -- class EB_HELP_ENGINE
