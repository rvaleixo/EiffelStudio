indexing

	description:	
		"Window to choose a name.";
	date: "$Date$";
	revision: "$Revision$"

class NAME_CHOOSER_W 

inherit

	COMMAND_W;
	FILE_SEL_D
		rename
			make as file_sel_d_create,
			popup as file_sel_d_popup
		end;
	FILE_SEL_D
		rename
			make as file_sel_d_create
		redefine
			popup
		select
			popup
		end;
	SHARED_LICENSE;
	SET_WINDOW_ATTRIBUTES

creation

	make
	
feature -- Initialization

	make (a_composite: COMPOSITE) is
			-- Create a file selection dialog
		do
			file_sel_d_create (l_file_selection, a_composite);
			hide_help_button;
			add_ok_action (Current, Current);
			add_cancel_action (Current, Void);
			set_title (l_Select_a_file);
			set_exclusive_grab;
			set_default_position (false);
			set_composite_attributes (Current);
			realize
		end;

feature -- Graphical Interface

	popup is
			-- Popup file selection window.
		local
			new_x, new_y: INTEGER
		do
			if is_popped_up then popdown end;
			if window /= Void then
				new_x := window.real_x + (window.width - width) // 2;
				new_y := window.real_y + (window.height - height) // 2;
			else
				new_x := (screen.width - width) // 2;
				new_y := (screen.height - height) // 2
			end;
			if new_x + width > screen.width then
				new_x := screen.width - width
			end;
			if new_x < 0 then
				new_x := 0
			end;
			if new_y + height > screen.height then
				new_y := screen.height - height
			end;
			if new_y < 0 then
				new_y := 0
			end;
			set_x_y (new_x, new_y);
			file_sel_d_popup
		end;

	call (a_command: COMMAND_W) is
			-- Record calling command `a_command' and popup current.
		do
			last_caller := a_command;
			popup
		ensure
			last_caller_recorded: last_caller = a_command
		end;

	set_window (wind: TEXT_WINDOW) is
		do
			window ?= wind.tool
		end;

feature {NONE} -- Properties

	last_caller: COMMAND_W
			-- Last command which popped up current

	window: WIDGET;
			-- Window to which the file selection will apply

feature {NONE} -- Implementation

	work (argument: ANY) is
		local
			mp: MOUSE_PTR
		do
			popdown;
			if argument = Current then
				last_caller.execute (Current)
			else
				!! mp.set_watch_cursor;
				project_tool.set_changed (false);
				if not project_tool.initialized then
					discard_licence;
					exit
				end;
			end
		end;

end -- class NAME_CHOOSER_W
