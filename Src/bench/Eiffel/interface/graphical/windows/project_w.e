indexing

	description:	
		"The project window.";
	date: "$Date$";
	revision: "$Revision$"

class PROJECT_W

inherit

	TOOL_W
		rename
			execute as old_execute
		redefine
			text_window, tool_name
		end
	TOOL_W
		redefine
			text_window, tool_name,
			execute
		select
			execute
		end;
	BASE
		rename
			make as base_make
		end;
	EXCEPTIONS
		rename
			raise as raise_exception
		end;
	SET_WINDOW_ATTRIBUTES;
	SHARED_APPLICATION_EXECUTION

creation

	make

feature -- Initialization

	make is
			-- Create a project application.
		local
			a_screen: SCREEN;
			app_stopped_cmd: APPLICATION_STOPPED_CMD
		do
			a_screen := display;
			base_make (tool_name, a_screen);
			forbid_resize;
			build_widgets;
			set_title (l_project);
			set_icon_name (tool_name);
			set_default_position;
			realize;
			transporter_init;
			if bm_Project_icon.is_valid then
				set_icon_pixmap (bm_Project_icon);
			end;
			set_action ("<Unmap>,<Prop>", Current, popdown);
			set_action ("<Configure>", Current, remapped);
			set_action ("<Visible>", Current, remapped);
			set_delete_command (quit_command);
			set_composite_attributes (Current);
			text_window.set_font_to_default;
			!! app_stopped_cmd;
			Application.set_before_stopped_command (app_stopped_cmd);
			Application.set_after_stopped_command (app_stopped_cmd);
		end;

feature -- Properties

	popdown: ANY is
		once
			!! Result
		end;

	remapped: ANY is
		once
			!! Result
		end;

	display: SCREEN is
		local
			display_name: STRING;
		do
			!! Result.make ("");
			if not Result.is_valid then
				io.error.putstring ("Cannot open display %"");
				display_name := Execution_environment.get ("DISPLAY");
				if display_name /= Void then
					io.error.putstring (display_name);
				end;
				io.error.putstring ("%"%N%
					%Check that $DISPLAY is properly set and that you are%N%
					%authorized to connect to the corresponding server%N");
				raise_exception ("Invalid display");
			end;
		end;

feature -- Window Settings

	set_default_size is
		do
		end;

	set_default_position is
			-- Display the project tool at the 
			-- upper left corner of the screen.
		do
			set_x_y (0, 0)
		end;
 
	set_initialized is
			-- Set `initialized' to true.
		do
			initialized := true
		ensure
			initialized = true
		end;

	set_changed (f: BOOLEAN) is
			-- Assign `f' to `changed'.
		do
			changed := f
		end

feature -- Window Implementation

	close_windows is 
		do 
			change_font_command.close
		end;

	popup_file_selection is
		do
			open_command.execute (text_window);
		end;

feature -- Window Properties

	changed: BOOLEAN;
			-- Is or has the window changed?

	initialized: BOOLEAN;
			-- Is the workbench created?

	is_system_window_hidden: BOOLEAN;
			-- Is the system window hidden?

	is_name_chooser_hidden: BOOLEAN;
			-- Is the name chooser hidden?

	is_warner_hidden: BOOLEAN;
			-- Is the warner window hidden?

	is_confirmer_hidden: BOOLEAN;
			-- Is the confirmer window hidden?

	is_project_tool_hidden: BOOLEAN;
			-- Is the project tool hidden?

	eiffel_symbol: PIXMAP is
		do
			Result := bm_Project
		end;

	tool_name: STRING is
		do
			Result := l_Project
		end;

	text_window: PROJECT_TEXT;
			-- Text window associated with Current.

feature -- WIndow Holes

	stop_points_hole: DEBUG_STOPIN;

	system_hole: SYSTEM_HOLE;

	class_hole: PROJ_CLASS_HOLE;

	routine_hole: ROUTINE_HOLE;

	object_hole: OBJECT_HOLE;

	explain_hole: EXPLAIN_HOLE;

feature -- Window Forms

	icing: FORM;
			-- Icing form with global command buttons

	form_manager: FORM;
			-- Manager of constraints on sub widgets.

	classic_bar: FORM;
			-- Main menu bar

	format_bar: FORM;
			-- Format menu bar

feature -- Focus Label

	type_teller: LABEL_G;
			-- To tell what type of element we are dealing with

	tell_type (a_type_name: STRING) is
			-- Display `a_type_name' in type teller.
		do
			type_teller.set_text (a_type_name)
		end;

	clean_type is
			-- Clean what's said in the type teller window.
		do
			type_teller.set_text (" ")
		end;

feature -- Execution Implementation

	execute (arg: ANY) is
			-- Resize xterm window when drawing area is resized
		do
			if arg = remapped then
				if is_project_tool_hidden then
						-- The project tool is being deiconified.
					is_project_tool_hidden := False;
					window_manager.show_all_editors
					if is_system_window_hidden then
						system_tool.show
						is_system_window_hidden := False;
					elseif system_tool.text_window.in_use then
						system_tool.show
					end;
					raise
					if is_warner_hidden then
						is_warner_hidden := false;
						last_warner.popup
					end
					if is_confirmer_hidden then
						is_confirmer_hidden := false;
						last_confirmer.popup
					end
					if is_name_chooser_hidden then
						is_name_chooser_hidden := false;
						name_chooser.popup
					end
				else
						-- The project tool is being raised, moved or resized.
						-- Raise popups with an exclusive grab.
					raise_grabbed_popup
				end
			elseif arg = popdown then
				is_project_tool_hidden := True;
				close_windows;
				window_manager.hide_all_editors;
				if 	system_tool.realized and then system_tool.shown then
					system_tool.hide;
					system_tool.close_windows;
					is_system_window_hidden := True;
				end;
				if name_chooser.is_popped_up then
					is_name_chooser_hidden := true;
					name_chooser.popdown
				end;	
				if last_warner /= Void and then last_warner.is_popped_up then
					is_warner_hidden := true;
					last_warner.popdown
				end;
				if 
					last_confirmer /= Void and then 
					last_confirmer.is_popped_up
				then
					is_confirmer_hidden := true;
					last_confirmer.popdown
				end
			else
				old_execute (arg)
			end
		end;

feature -- Graphical Interface

	build_widgets is
			-- Build widget.
		do
			set_size (478, 306);
			!! form_manager.make (new_name, Current);
			build_text;
			build_top;
			build_icing;
			build_format_bar;
			exec_stop.execute (Void);
			attach_all
		end;

	build_top is
			-- Build top bar
		do
			!! open_command.make (text_window);
			!! classic_bar.make (new_name, form_manager);

			!! quit_command.make (classic_bar, text_window);
			!! change_font_command.make (classic_bar, text_window);
			!! type_teller.make (new_name, classic_bar);
			type_teller.set_center_alignment;
			!! explain_hole.make (classic_bar, Current);
			!! system_hole.make (classic_bar, Current);
			!! class_hole.make (classic_bar, Current);
			!! routine_hole.make (classic_bar, Current);
			!! object_hole.make (classic_bar, Current);
			!! stop_points_hole.make (classic_bar, Current);

			classic_bar.attach_left (explain_hole, 0);
			classic_bar.attach_top (explain_hole, 0);
			classic_bar.attach_bottom (explain_hole, 0);
			classic_bar.attach_left_widget (explain_hole, system_hole,0);
			classic_bar.attach_top (system_hole, 0);
			classic_bar.attach_bottom (system_hole, 0);
			classic_bar.attach_left_widget (system_hole, class_hole,0);
			classic_bar.attach_top (class_hole, 0);
			classic_bar.attach_bottom (class_hole, 0);
			classic_bar.attach_left_widget (class_hole, routine_hole, 0);
			classic_bar.attach_top (routine_hole, 0);
			classic_bar.attach_bottom (routine_hole, 0);
			classic_bar.attach_left_widget (routine_hole, object_hole, 0);
			classic_bar.attach_top (object_hole, 0);
			classic_bar.attach_bottom (object_hole, 0);
			classic_bar.attach_left_widget (object_hole, stop_points_hole, 0);
			classic_bar.attach_top (stop_points_hole, 0);
			classic_bar.attach_bottom (stop_points_hole, 0);
			classic_bar.attach_left_widget (stop_points_hole, type_teller, 0);
			classic_bar.attach_top (type_teller, 0);
			classic_bar.attach_bottom (type_teller, 0);
			classic_bar.attach_right_widget (change_font_command, type_teller, 0);
			classic_bar.attach_top (change_font_command, 0);
			classic_bar.attach_bottom (change_font_command, 0);
			classic_bar.attach_right_widget (quit_command, change_font_command, 0);
			classic_bar.attach_top (quit_command, 0);
			classic_bar.attach_bottom (quit_command, 0);
			classic_bar.attach_right (quit_command, 23);

			clean_type;
		end;

	build_text is
			-- Build console text window.
		do
			if tabs_disabled then
				!! text_window.make (new_name, form_manager, Current);
			else
				!PROJECT_TAB_TEXT! text_window.make (new_name, form_manager, Current)
			end;
			text_window.set_size (200, 100);
		end;

	build_format_bar is
			-- Build formatting buttons in `format_bar'.
		do
			!! format_bar.make (new_name, form_manager);

			!! exec_stop.make (format_bar, text_window);
			format_bar.attach_left (exec_stop, 0);
			format_bar.attach_top (exec_stop, 0);
			format_bar.attach_bottom (exec_stop, 0);
			!! exec_step.make (format_bar, text_window);
			format_bar.attach_top (exec_step, 0);
			format_bar.attach_bottom (exec_step, 0);
			format_bar.attach_left_widget (exec_stop, exec_step, 0);
			!! exec_last.make (format_bar, text_window);
			format_bar.attach_top (exec_last, 0);
			format_bar.attach_bottom (exec_last, 0);
			format_bar.attach_left_widget (exec_step, exec_last, 0);
			!! exec_nostop.make (format_bar, text_window);
			format_bar.attach_top (exec_nostop, 0);
			format_bar.attach_bottom (exec_nostop, 0);
			format_bar.attach_left_widget (exec_last, exec_nostop, 0);
		end;

	build_icing is
			-- Build icing area
		do
			!! icing.make (new_name, form_manager);
			!! update_command.make (icing, text_window);
			!! debug_run_command.make (icing, text_window);
			!! debug_status_command.make (icing, text_window);
			!! debug_quit_command.make (icing, text_window);
			!! special_command.make (icing, text_window);
			!! freeze_command.make (icing, text_window);
			!! finalize_command.make (icing, text_window);
			icing.attach_top (update_command, 0);
			icing.attach_left (update_command, 0);
			icing.attach_right (update_command, 0);
			icing.attach_top_widget (update_command, debug_run_command, 0);
			icing.attach_left (debug_run_command, 0);
			icing.attach_right (debug_run_command, 0);
			icing.attach_top_widget (debug_run_command, debug_status_command, 0);
			icing.attach_left (debug_status_command, 0);
			icing.attach_right (debug_status_command, 0);
			icing.attach_top_widget (debug_status_command, debug_quit_command, 0);
			icing.attach_left (debug_quit_command, 0);
			icing.attach_right (debug_quit_command, 0);
			icing.attach_top_widget (debug_quit_command, special_command, 0);
			icing.attach_left (special_command, 0);
			icing.attach_right (special_command, 0);
			icing.attach_bottom_widget (freeze_command, special_command, 0);
			icing.attach_left (freeze_command, 0);
			icing.attach_right (freeze_command, 0);
			icing.attach_bottom_widget (finalize_command, freeze_command, 0);
			icing.attach_bottom (finalize_command, 0);
			icing.attach_left (finalize_command, 0);
			icing.attach_right (finalize_command, 0);
		end;

	attach_all is
			-- Adjust and attach main widgets together.
		do
			form_manager.attach_left (classic_bar, 0);
			form_manager.attach_top (classic_bar, 0);
			form_manager.attach_right_widget (icing, classic_bar, 0);

			form_manager.attach_left (text_window, 0);
			form_manager.attach_top_widget (classic_bar, text_window, 0);
			form_manager.attach_right_widget (icing, text_window, 0);
			-- (text_window will resize when window grows)

			-- form_manager.attach_left (xterminal, 5);
			-- form_manager.attach_top_widget (text_window, xterminal, 5);
			-- form_manager.attach_right_widget (icing, xterminal, 5);
			-- (xterminal will resize when window grows)
			-- form_manager.attach_bottom (xterminal, 5);

			form_manager.attach_bottom_widget (format_bar, text_window, 0);

			form_manager.attach_top (icing, 0);
			form_manager.attach_right (icing, 0);
			form_manager.attach_bottom (icing, 0)

			form_manager.attach_left (format_bar, 0);
			form_manager.attach_right_widget (icing, format_bar, 0);
			form_manager.attach_bottom (format_bar, 0)
		end;

feature -- System Execution Modes

	exec_nostop: EXEC_NOSTOP;
			-- Set execution format so that no stop points will
			-- be taken into account

	exec_stop: EXEC_STOP;
			-- Set execution format so that user-defined stop
			-- points will be taken into account

	exec_step: EXEC_STEP;
			-- Set execution format so that each breakable points
			-- of the current routine will be taken into account

	exec_last: EXEC_LAST;
			-- Set execution format so that only the last					-- breakable point of the current routine will be
			-- taken into account

feature -- Commands

	open_command: OPEN_PROJECT;

	quit_command: QUIT_PROJECT;

	update_command: UPDATE_PROJECT;

	debug_run_command: DEBUG_RUN;

	debug_status_command: DEBUG_STATUS;

	debug_quit_command: DEBUG_QUIT;

	special_command: SPECIAL_COMMAND;

	freeze_command: FREEZE_PROJECT;

	finalize_command: FINALIZE_PROJECT;

	change_font_command: CHANGE_FONT;

end -- class PROJECT_W
