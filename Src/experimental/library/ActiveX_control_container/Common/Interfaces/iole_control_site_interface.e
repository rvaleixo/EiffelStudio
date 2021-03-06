note
	description: "Control interfaces. Help file: "
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IOLE_CONTROL_SITE_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	on_control_info_changed_user_precondition: BOOLEAN
			-- User-defined preconditions for `on_control_info_changed'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	lock_in_place_active_user_precondition (f_lock: INTEGER): BOOLEAN
			-- User-defined preconditions for `lock_in_place_active'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	get_extended_control_user_precondition (pp_disp: CELL [ECOM_INTERFACE]): BOOLEAN
			-- User-defined preconditions for `get_extended_control'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	transform_coords_user_precondition (p_ptl_himetric: X_POINTL_RECORD; p_ptf_container: TAG_POINTF_RECORD; dw_flags: INTEGER): BOOLEAN
			-- User-defined preconditions for `transform_coords'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	translate_accelerator_user_precondition (p_msg: TAG_MSG_RECORD; grf_modifiers: INTEGER): BOOLEAN
			-- User-defined preconditions for `translate_accelerator'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	on_focus_user_precondition (f_got_focus: INTEGER): BOOLEAN
			-- User-defined preconditions for `on_focus'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	show_property_frame_user_precondition: BOOLEAN
			-- User-defined preconditions for `show_property_frame'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	on_control_info_changed
			-- No description available.
		require
			on_control_info_changed_user_precondition: on_control_info_changed_user_precondition
		deferred

		end

	lock_in_place_active (f_lock: INTEGER)
			-- No description available.
			-- `f_lock' [in].  
		require
			lock_in_place_active_user_precondition: lock_in_place_active_user_precondition (f_lock)
		deferred

		end

	get_extended_control (pp_disp: CELL [ECOM_INTERFACE])
			-- No description available.
			-- `pp_disp' [out].  
		require
			non_void_pp_disp: pp_disp /= Void
			get_extended_control_user_precondition: get_extended_control_user_precondition (pp_disp)
		deferred

		ensure
			valid_pp_disp: pp_disp.item /= Void
		end

	transform_coords (p_ptl_himetric: X_POINTL_RECORD; p_ptf_container: TAG_POINTF_RECORD; dw_flags: INTEGER)
			-- No description available.
			-- `p_ptl_himetric' [in, out].  
			-- `p_ptf_container' [in, out].  
			-- `dw_flags' [in].  
		require
			non_void_p_ptl_himetric: p_ptl_himetric /= Void
			valid_p_ptl_himetric: p_ptl_himetric.item /= default_pointer
			non_void_p_ptf_container: p_ptf_container /= Void
			valid_p_ptf_container: p_ptf_container.item /= default_pointer
			transform_coords_user_precondition: transform_coords_user_precondition (p_ptl_himetric, p_ptf_container, dw_flags)
		deferred

		end

	translate_accelerator (p_msg: TAG_MSG_RECORD; grf_modifiers: INTEGER)
			-- No description available.
			-- `p_msg' [in].  
			-- `grf_modifiers' [in].  
		require
			non_void_p_msg: p_msg /= Void
			valid_p_msg: p_msg.item /= default_pointer
			translate_accelerator_user_precondition: translate_accelerator_user_precondition (p_msg, grf_modifiers)
		deferred

		end

	on_focus (f_got_focus: INTEGER)
			-- No description available.
			-- `f_got_focus' [in].  
		require
			on_focus_user_precondition: on_focus_user_precondition (f_got_focus)
		deferred

		end

	show_property_frame
			-- No description available.
		require
			show_property_frame_user_precondition: show_property_frame_user_precondition
		deferred

		end

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




end -- IOLE_CONTROL_SITE_INTERFACE

