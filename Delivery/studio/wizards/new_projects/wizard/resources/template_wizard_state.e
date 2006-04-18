indexing
	description	: "Wizard Step."
	author		: "Generated by the Wizard wizard"
	revision	: "1.0.0"

class
	${FL_WIZARD_CLASS_NAME}

inherit
	WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			update_state_information,
			proceed_with_current_info,
			build
		end

create
	make

feature -- Basic Operation

	build is 
			-- Build entries.
		do 
			set_updatable_entries(<<>>)
		end

	proceed_with_current_info is
			-- User has clicked next, go to next step.
		do
			Precursor
			proceed_with_new_state(create {${FL_NEXT_STATE}}.make(wizard_information))
		end

	update_state_information is
			-- Check User Entries
		do
			Precursor
		end

feature {NONE} -- Implementation

	display_state_text is
			-- Set the messages for this state.
		do
			title.set_text ("Add Your Title Here (Step ${FL_STATE_NUMBER}).")
			subtitle.set_text ("Add your subtitle here.")
			message.set_text ("Add your message for this step here.")
		end

end -- class ${FL_WIZARD_CLASS_NAME}
