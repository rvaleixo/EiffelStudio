indexing
	description:
		"Action sequences for EV_LIST_ITEM_LIST."
	status: "Generated!"
	keywords: "event, action, sequence"
	date: "Generated!"
	revision: "Generated!"

deferred class
	 EV_LIST_ITEM_LIST_ACTION_SEQUENCES

inherit
	ANY
		export
			{EV_ANY_HANDLER} default_create
		undefine
			default_create, copy
		end

feature {NONE} -- Implementation

	implementation: EV_LIST_ITEM_LIST_ACTION_SEQUENCES_I

feature -- Event handling


	select_actions: EV_NOTIFY_ACTION_SEQUENCE is
			-- Actions to be performed when an item is selected.
		do
			Result := implementation.select_actions
		ensure
			not_void: Result /= Void
		end


	deselect_actions: EV_NOTIFY_ACTION_SEQUENCE is
			-- Actions to be performed when an item is deselected.
		do
			Result := implementation.deselect_actions
		ensure
			not_void: Result /= Void
		end

end

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2001 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support: http://support.eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

