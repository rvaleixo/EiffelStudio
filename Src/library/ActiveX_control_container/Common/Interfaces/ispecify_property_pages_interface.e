note
	description: "Control interfaces. Help file: "
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

deferred class
	ISPECIFY_PROPERTY_PAGES_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	get_pages_user_precondition (p_pages: TAG_CAUUID_RECORD): BOOLEAN
			-- User-defined preconditions for `get_pages'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	get_pages (p_pages: TAG_CAUUID_RECORD)
			-- No description available.
			-- `p_pages' [out].  
		require
			non_void_p_pages: p_pages /= Void
			valid_p_pages: p_pages.item /= default_pointer
			get_pages_user_precondition: get_pages_user_precondition (p_pages)
		deferred

		end

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




end -- ISPECIFY_PROPERTY_PAGES_INTERFACE

