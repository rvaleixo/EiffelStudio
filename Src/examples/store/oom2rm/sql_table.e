note

	description:
		"An abstract representation of a SQL table with %
		%a set of fields."
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class SQL_TABLE inherit

	LINKED_LIST [SQL_COLUMN]
		rename
			make as linked_list_make
		end;

create

	make, make_prefix, linked_list_make

feature

	name: detachable STRING;
			-- Table name.

	make (a_name: STRING)
			-- Make a table named `a_name'.
		require
			a_name_not_void: a_name /= Void
		do
			linked_list_make;
			name := a_name
		ensure
			name = a_name
		end;

	make_prefix (a_name: STRING; a_prefix: STRING)
			-- Make a table named `a_name' with `a_prefix'.
		require
			a_name_not_void: a_name /= Void;
			a_prefix_not_void: a_prefix /= Void
		do
			make (a_name);
			a_name.insert_string ("_", 1);
			a_name.insert_string (a_prefix, 1)
		end;

	print_result (output: FILE)
			-- Print result on `output'.
		require
			output_not_void: output /= Void
		local
			l_name: detachable STRING
		do
			from
	 			output.putstring ("create table ");
	 			l_name := name
	 			check l_name /= Void end -- FIXME: implied by `table' make's postcondition, but if creation method is `linked_list_make' ?
				output.putstring (l_name);
				output.putstring (" (");
				start
			until
				after
			loop
				item.print_result (output);
				forth;
				if not after then
					output.putstring (", ")
				end;
			end;
			output.putchar (')')
		ensure
			is_after: after
		end;

invariant

	name_not_void: name /= Void

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


end -- class SQL_TABLE


