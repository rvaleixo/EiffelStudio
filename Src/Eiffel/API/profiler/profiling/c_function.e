note

	description:
		"Information about a profiled C function."
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class C_FUNCTION

inherit
	LANGUAGE_FUNCTION

create
	make

feature -- Creation

	make (new_name: like function_name)
			-- Create a C function with function name
			-- `new_name'.
		do
			function_name := new_name;
		end

feature -- Output

	name: STRING_32
			-- The name of the function.
		do
			Result := function_name
		end

feature {NONE} -- Attributes

	function_name: STRING_32;
		-- C function name as declared in source code.

note
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

end -- class C_FUNCTION
