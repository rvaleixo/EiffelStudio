note
	legal: "See notice at end of class."
	status: "See notice at end of class."
class INLINED_RESULT_B

inherit
	RESULT_B
		redefine
			enlarged, propagate, free_register, print_register, type, print_checked_target_register,
			Current_register, is_result, is_inlined_result, generate, used
		end

feature

	enlarged: INLINED_RESULT_B
		do
			Result := Current
		end

	is_result: BOOLEAN
		do
		end

	is_inlined_result: BOOLEAN = True
			-- Current is inlined `Result'.

	used (r: REGISTRABLE): BOOLEAN
			-- Is `r' the inlined `Result' entity ?
		do
			Result := r.is_inlined_result
		end;

feature -- Register and code generation

	Current_register: INLINED_CURRENT_B
		once
			create Result
		end

	propagate (r: REGISTRABLE)
			-- Do nothing
		do
		end;

	generate
			-- Do nothing
		do
		end;

	free_register
			-- Do nothing
		do
		end;

	print_register
		do
			System.remover.inliner.inlined_feature.result_reg.print_register
		end

feature {REGISTRABLE} -- C code generation

	print_checked_target_register
			-- <Precursor>
		do
			System.remover.inliner.inlined_feature.result_reg.print_checked_target_register
		end

feature

	type: TYPE_A
		do
			Result := System.remover.inliner.inlined_feature.result_type
		end

note
	copyright:	"Copyright (c) 1984-2016, Eiffel Software"
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
