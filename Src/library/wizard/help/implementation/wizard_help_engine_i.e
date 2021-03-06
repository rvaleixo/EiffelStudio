note
	description: "Help engine, displays help context, implementation interface"
	legal: "See notice at end of class."
	status: "See notice at end of class."

deferred class
	WIZARD_HELP_ENGINE_I

feature -- Status Report

	last_show_successful: BOOLEAN
			-- Was last call to `show' successful?
		deferred
		ensure
			message_if_failed: not Result implies (attached last_error_message as m and then not m.is_empty)
		end

	last_error_message: detachable STRING
			-- Last error message, if any
		deferred
		end

feature -- Basic Operations

	show (a_help_context: WIZARD_HELP_CONTEXT)
			-- Show help with context `a_help_context'.
		deferred
		end

note
	copyright:	"Copyright (c) 1984-2012, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
