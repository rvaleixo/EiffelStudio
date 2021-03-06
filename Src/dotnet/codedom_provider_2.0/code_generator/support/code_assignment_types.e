note
	description: "Assignment types"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	CODE_ASSIGNMENT_TYPES

feature -- Access

	Default_assignment: INTEGER = 1
			-- Assignment target is neither a field nor a property
	
	Property_assignment: INTEGER = 2
			-- Assignment target is a property
	
	Field_assignment: INTEGER = 3
			-- Assignment target is a field

	Array_assignment: INTEGER = 4
			-- Assignment target is an array element

feature -- Status Report

	is_valid_assignment_type (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid assignment type?
		do
			Result := a_value = Default_assignment or a_value = Property_assignment or a_value = Field_assignment or a_value = Array_assignment
		ensure
			definition: Result = (a_value = Default_assignment or a_value = Property_assignment or a_value = Field_assignment or a_value = Array_assignment)
		end

invariant
	default_assignment_is_valid: is_valid_assignment_type (Default_assignment)
	property_assignment_is_valid: is_valid_assignment_type (Property_assignment)
	field_assignment_is_valid: is_valid_assignment_type (Field_assignment)
	array_assignment_is_valid: is_valid_assignment_type (Array_assignment)

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
end -- class CODE_ASSIGNMENT_TYPES

