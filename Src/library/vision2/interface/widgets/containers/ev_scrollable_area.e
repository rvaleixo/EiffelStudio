indexing
	description:
		"Eiffel Vision scrollable area."
	status: "See notice at end of class"
	keywords: "container, scroll, scrollbar, viewport"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SCROLLABLE_AREA

inherit
	EV_VIEWPORT 
		redefine
			implementation,
			create_implementation,
			make_for_test
		end

create
	default_create,
	make_for_test

feature {NONE} -- Initialization

	create_implementation is
		do
			create {EV_SCROLLABLE_AREA_IMP} implementation.make (Current)
		end

	make_for_test is
		do
			default_create
			extend (create {EV_LABEL}.make_with_text ("Label in a scrollable area."))
			item.set_minimum_size (150,150)
		end

feature -- Access

	horizontal_step: INTEGER is
			-- Number of pixels scrolled up or down when user clicks
			-- an arrow on the horizontal scrollbar.
		do
			Result := implementation.horizontal_step
		ensure
			bridge_ok: Result = implementation.horizontal_step
		end

	vertical_step: INTEGER is
			-- Number of pixels scrolled left or right when user clicks
			-- an arrow on the vertical scrollbar.
		do
			Result := implementation.vertical_step
		ensure
			bridge_ok: Result = implementation.vertical_step
		end

	is_horizontal_scrollbar_visible: BOOLEAN is
			-- Should horizontal scrollbar be displayed?
		do
			Result := implementation.is_horizontal_scrollbar_visible
		ensure
			bridge_ok: Result = implementation.is_horizontal_scrollbar_visible
		end

	is_vertical_scrollbar_visible: BOOLEAN is
			-- Should vertical scrollbar be displayed?
		do
			Result := implementation.is_vertical_scrollbar_visible
		ensure
			bridge_ok: Result = implementation.is_vertical_scrollbar_visible
		end

feature -- Element change

	set_horizontal_step (a_step: INTEGER) is
			-- Set `horizontal_step' to `a_step'.
		require
			a_step_positive: a_step > 0
		do
			implementation.set_horizontal_step (a_step)
		ensure
			assigned: horizontal_step = a_step
		end

	set_vertical_step (a_step: INTEGER) is
			-- Set `vertical_step' to `a_step'.
		require
			a_step_positive: a_step > 0
		do
			implementation.set_vertical_step (a_step)
		ensure
			assigned: vertical_step = a_step
		end

	show_horizontal_scrollbar is
			-- Display horizontal scrollbar.
		do
			implementation.show_horizontal_scrollbar
		ensure
			shown: is_horizontal_scrollbar_visible
		end

	hide_horizontal_scrollbar is
			-- Do not display horizontal scrollbar.
		do
			implementation.hide_horizontal_scrollbar
		ensure
			hidden: not is_horizontal_scrollbar_visible
		end

	show_vertical_scrollbar is
			-- Display vertical scrollbar.
		do
			implementation.show_vertical_scrollbar
		ensure
			shown: is_vertical_scrollbar_visible
		end

	hide_vertical_scrollbar is
			-- Do not display vertical scrollbar.
		do
			implementation.hide_vertical_scrollbar
		ensure
			hidden: not is_vertical_scrollbar_visible
		end

feature {NONE} -- Implementation

	implementation: EV_SCROLLABLE_AREA_I

invariant
	horizontal_step_positive: is_useable implies horizontal_step > 0
	vertical_step_positive: is_useable implies vertical_step > 0

end -- class EV_SCROLLABLE_AREA

--!-----------------------------------------------------------------------------
--! EiffelVision2: library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-2000 Interactive Software Engineering Inc.
--! All rights reserved. Duplication and distribution prohibited.
--! May be used only with ISE Eiffel, under terms of user license. 
--! Contact ISE for any other use.
--!
--! Interactive Software Engineering Inc.
--! ISE Building, 2nd floor
--! 270 Storke Road, Goleta, CA 93117 USA
--! Telephone 805-685-1006, Fax 805-685-6869
--! Electronic mail <info@eiffel.com>
--! Customer support e-mail <support@eiffel.com>
--! For latest info see award-winning pages: http://www.eiffel.com
--!-----------------------------------------------------------------------------

--|-----------------------------------------------------------------------------
--| CVS log
--|-----------------------------------------------------------------------------
--|
--| $Log$
--| Revision 1.12  2000/03/01 03:30:06  oconnor
--| added make_for_test
--|
--| Revision 1.11  2000/02/29 18:09:10  oconnor
--| reformatted indexing cluase
--|
--| Revision 1.10  2000/02/22 18:39:51  oconnor
--| updated copyright date and formatting
--|
--| Revision 1.9  2000/02/14 11:40:51  oconnor
--| merged changes from prerelease_20000214
--|
--| Revision 1.8.6.7  2000/02/14 11:04:28  oconnor
--| added is_useable to invariants
--|
--| Revision 1.8.6.6  2000/02/12 01:04:32  king
--| Corrected is_vertical_scrollbar_visible due to careless cutting and pasting, doh Vincent
--|
--| Revision 1.8.6.5  2000/01/28 20:00:14  oconnor
--| released
--|
--| Revision 1.8.6.4  2000/01/28 19:30:15  brendel
--| Revision.
--| Now inherits from EV_VIEWPORT and adds the scrollbars to the viewable area.
--|
--| Revision 1.8.6.3  2000/01/27 19:30:52  oconnor
--| added --| FIXME Not for release
--|
--| Revision 1.8.6.2  1999/11/24 22:40:59  oconnor
--| added review notes
--|
--| Revision 1.8.6.1  1999/11/24 17:30:52  oconnor
--| merged with DEVEL branch
--|
--| Revision 1.8.2.4  1999/11/04 23:10:55  oconnor
--| updates for new color model, removed exists: not destroyed
--|
--| Revision 1.8.2.3  1999/11/02 17:20:13  oconnor
--| Added CVS log, redoing creation sequence
--|
--|
--|-----------------------------------------------------------------------------
--| End of CVS log
--|-----------------------------------------------------------------------------
