indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

class
	WIZARD_COM_PROJECT_BOX

inherit
	WIZARD_COM_PROJECT_BOX_IMP
		redefine
			show
		end

	WIZARD_VALIDITY_CHECKER
		undefine
			default_create,
			copy,
			is_equal
		end

	WIZARD_SHARED_PROFILE_MANAGER
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	WIZARD_SETTINGS_CONSTANTS
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			initialize_checker
			definition_file_box.setup ("Component definition file:", "definition_key", agent definition_file_validity (?), create {ARRAYED_LIST [TUPLE [STRING, STRING]]}.make_from_array (<<["*.idl", "IDL file (*.idl)"], ["*.tlb", "Type Library (*.tlb)"], ["*.dll", "DLL file (*.dll)"], ["*.exe", "Executable (*.exe)"], ["*.ocx", "Component (*.ocx)"], ["*.*", "All Files (*.*)"]>>), "Browse for COM definition file")
		end

feature -- Basic Operations

	update_environment is
			-- Update `environment' according to active file name.
		local
			l_file_name: STRING
		do
			l_file_name := definition_file_box.value.as_lower
			if is_valid_file (l_file_name) then
				if l_file_name.substring_index (".idl", l_file_name.count - 3) = l_file_name.count - 3 then
					environment.set_idl_file_name (l_file_name)
					marshaller_box.show
				else
					environment.set_type_library_file_name (l_file_name)
					environment.set_idl (False)
					marshaller_box.hide
				end
				environment.set_project_name (l_file_name.substring (l_file_name.last_index_of ('\', l_file_name.count) + 1, l_file_name.count))
			end
		end
		
	show is
			-- Update environment and show.
		local
			l_value: STRING
		do
			Precursor {WIZARD_COM_PROJECT_BOX_IMP}
			update_environment
			Profile_manager.search_active_profile (Marshaller_key)
			if Profile_manager.found then
				l_value := Profile_manager.found_item.value
				if l_value.is_equal (True_code) then
					marshaller_check_button.enable_select
				end
			end
		end
	
	hide_marshaller is
			-- Hide marshaller box
		do
			marshaller_box.hide
		end
		
	show_marshaller is
			-- Show marshaller box
		do
			marshaller_box.show
		end
		
feature {NONE} -- Events Handling

	on_use_marshaller is
			-- Called by `select_actions' of `marshaller_check_button'.
			-- Set `environment.marshaller_generated' accordingly.
		do
			environment.set_marshaller_generated (marshaller_check_button.is_selected)
			Profile_manager.save_active_profile
		end

feature {NONE} -- Implementation

	definition_file_validity (a_file_name: STRING): WIZARD_VALIDITY_STATUS is
			-- Is `a_file_name' a valid definition file?
			-- Show marshaller box if `a_file_name' corresponds to an IDL file.
		do
			if is_valid_file (a_file_name) then
				create Result.make_success (feature {WIZARD_VALIDITY_STATUS_IDS}.Component_definition_file)
				update_environment
			else
				create Result.make_error (feature {WIZARD_VALIDITY_STATUS_IDS}.Component_definition_file)
			end
			set_status (Result)
		end

end -- class WIZARD_COM_PROJECT_BOX

--+----------------------------------------------------------------
--| EiffelCOM Wizard
--| Copyright (C) 1999-2005 Eiffel Software. All rights reserved.
--| Eiffel Software Confidential
--| Duplication and distribution prohibited.
--|
--| Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| http://www.eiffel.com
--+----------------------------------------------------------------

