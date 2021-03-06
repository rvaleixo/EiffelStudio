﻿note
	description: "Reference description"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class REFERENCE_DESC

inherit
	ATTR_DESC
		redefine
			default_create,
			same_as
		end

feature {NONE} -- Initialization

	default_create
		do
			internal_flags := {SHARED_LEVEL}.reference_level
		end

feature -- Access

	type_i: TYPE_A
			-- Class type of a reference attribute

	sk_value: NATURAL_32
		do
			Result := {SK_CONST}.Sk_ref
		end

feature -- Settings

	set_type_i (t: like type_i)
			-- Assign `t' to `type_i'.
		require
			t_not_void: t /= Void
		do
			type_i := t
		ensure
			set: type_i = t
		end

feature -- Comparisons

	same_as (other: ATTR_DESC): BOOLEAN
			-- Is `other' equal to Current ?
		do
			if Precursor (other) and then attached {REFERENCE_DESC} other as l_ref then
				Result := (type_i /= Void and attached l_ref.type_i as l_ref_type_i) and then
					(type_i.is_valid and l_ref_type_i.is_valid) and then type_i.equivalent (type_i, l_ref_type_i)
			end
		end

feature -- Code generation

	generate_code (buffer: GENERATION_BUFFER)
			-- Generate type code for current attribute description in
			-- `buffer'.
		do
			buffer.put_string ({SK_CONST}.sk_ref_string)
		end

note
	copyright:	"Copyright (c) 1984-2017, Eiffel Software"
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
