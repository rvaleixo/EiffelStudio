indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OPTION_TAB

inherit
	ANY_TAB
		redefine
			make,
			current_widget
		end


creation
	make

feature -- Initialization

	make (par: EV_CONTAINER) is
			-- Create the tab and initialise objects
		local
			cmd2: EV_ROUTINE_COMMAND
		once
			{ANY_TAB} Precursor (par)
			
				-- Creates the objects and their commands
			create cmd2.make(~selected_item)
			create f1.make (Current, "Selected Item", Void, cmd2)
			create cmd2.make (~child_menu)
			create f2.make (Current, "Child Menu", Void, cmd2)
--			set_parent(par)
		end

feature -- Access

	name:STRING is
			-- Returns the name of the tab
		do
			Result:="Option Button"
		end


feature -- Execution feature  

	selected_item (arg: EV_ARGUMENT; data: EV_EVENT_DATA) is
			-- Returns the currently selected_item.
		do
			if current_widget.selected_item /=Void then
				f1.set_text(current_widget.selected_item.text)
			end
		end

	child_menu (arg: EV_ARGUMENT; data: EV_EVENT_DATA) is
			-- Returns the menu which is affected to the option button.
		do
			f2.set_text(current_widget.text)
		end
	
feature -- Access

	current_widget: EV_OPTION_BUTTON
	f1,f2: TEXT_FEATURE_MODIFIER	
	b1: EV_BUTTON
end -- class OPTION_BUTTON_TAB