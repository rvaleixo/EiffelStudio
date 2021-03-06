note

	description:
			"Main shell for an application."
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	MEL_APPLICATION_SHELL

inherit

	MEL_APPLICATION_SHELL_RESOURCES
		export
			{NONE} all
		end;

	MEL_TOP_LEVEL_SHELL
		redefine
			make
		end

create
	make

feature -- Initialization

	make (app_name, app_class: STRING; a_screen: MEL_SCREEN)
			-- Create an application shell.
		local
			application, application_class: ANY
		do
			parent := Void;
			screen := a_screen;
			if app_name /= Void then
				application := app_name.to_c
			end;
			if app_class /= Void then
				application_class := app_class.to_c
			end;
			screen_object := xt_create_app_shell ($application, $application_class,
							a_screen.display.handle, 
							a_screen.handle);
			Mel_widgets.add_without_parent (Current);
			set_default
		end;

feature -- Status report

	argc: INTEGER
			-- Number of command line arguments.
		require
			exists: not is_destroyed
		do
			Result := get_xt_int (screen_object, XmNargc)
		ensure
			argc_large_enough: Result >= 0
		end;

	argv: STRING
			-- List of command line arguments.
		require
			exists: not is_destroyed
		do
			Result := c_get_argv (screen_object)
		ensure
			argv_not_void: Result /= Void
		end;

feature {NONE} -- Implementation

	c_get_argv (src_obj: POINTER): STRING
		external
			"C"
		end;

	xt_create_app_shell (appl_name, appl_class_name: POINTER; 
				display_ptr: POINTER; screen_ptr: POINTER): POINTER
		external
			"C"
		end;

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




end -- class MEL_APPLICATION_SHELL


