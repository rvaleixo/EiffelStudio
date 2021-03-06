note
	description	: "Information about a call in the calling stack."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision $"

deferred class CALL_STACK_ELEMENT

feature {NONE} -- Initialization

	make (level: INTEGER; tid: like thread_id; scp_pid: like scoop_processor_id)
		require
			valid_level: level >= 1
		do
			level_in_stack := level
			thread_id := tid
			scoop_processor_id := scp_pid
		end

feature -- Properties

	class_name: STRING
			-- Associated class name

	routine_name: STRING
			-- Associated routine name

	routine_name_for_display: STRING_32
			-- Associated routine name for display

	level_in_stack: INTEGER
			-- Where is this element situated in the call stack?
			-- 1 means on the top.

	thread_id: POINTER
			-- Thread id related to Current

	scoop_processor_id: NATURAL_16
			-- Associated scoop processor id if relevant.

	break_index: INTEGER
			-- the "Line number" where application is stopped within current feature

	break_nested_index: INTEGER
			-- the "nested index" where application is stopped within current feature at line `break_index'

	object_address: DBG_ADDRESS
			-- Hector address of associated object
			--| Because the debugger is already in communication with
			--| the application (retrieving information such as locals ...)
			--| it doesn't ask an hector address for that object until
			--| the "line" between the two processes is free.
			--| Initialially it is the physical address but is then
			--| protected in the `set_hector_addr_for_current_object' routine.
		deferred
		end

feature -- Status

	is_not_valid: BOOLEAN
			-- Current call stack element is not valid ?
			-- (i.e: issue retrieving the data...)

	is_eiffel_call_stack_element: BOOLEAN
			-- Is, Current, an eiffel call stack element or not (external stack) ?
		deferred
		end

	is_hidden: BOOLEAN
			-- Is hidden from debugger callstack?
		deferred
		end

feature -- Output

	to_string: STRING
			-- String representation.
		do
			create Result.make_empty
			if object_address /= Void then
				Result.append ("[" + object_address.output + "] ")
			end

			if class_name /= Void then
				Result.append ("{" + class_name + "}")
			end
			if routine_name /= Void then
				if not Result.is_empty then
					Result.append_character ('.')
				end
				Result.append (routine_name)
			end
			Result.append (" @")
			Result.append_integer (break_index)
			if break_nested_index > 0 then
				Result.append_character ('+')
				Result.append_integer (break_nested_index)
			end
		end

	object_address_to_string: STRING
			-- Display object address
		deferred
		end

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

end -- class CALL_STACK_ELEMENT
