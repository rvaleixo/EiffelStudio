indexing
	description	: "Wizard state: Error in the choosen directory"
	author		: "David Solal"
	date		: "$Date$"
	revision	: "$Revision$"

class
	WIZARD_ERROR_LOCATION

inherit
	BENCH_WIZARD_ERROR_STATE_WINDOW

	BENCH_WIZARD_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature -- basic Operations

	display_state_text is
			-- Display message text relative to current state.
		do
			title.set_text (Bench_interface_names.t_Location_state)
			message.set_text (Bench_interface_names.m_Location_state)
		end

	final_message: STRING is
		do
		end

feature {WIZARD_STATE_WINDOW}

	pixmap_icon_location: FILE_NAME is
			-- Icon for the Eiffel Wizard
		once
			create Result.make_from_string ("eiffel_wizard_icon")
			Result.add_extension (pixmap_extension)
		end
	
end -- class WIZARD_ERROR_LOCATION

