indexing 
	description: "EiffelVision password field, implementation interface"
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_PASSWORD_FIELD_I

inherit
	EV_TEXT_FIELD_I

feature -- Access

	character: CHARACTER is
			-- Displayed character instead of the text.
		require
			exists: not destroyed
		deferred
		end

feature -- Element change

	set_character (char: CHARACTER) is
			-- Make `char' the new character displayed in the
			-- password field.
		require
			exists: not destroyed
		deferred
		end

end -- class EV_PASSWORD_FIELD_I

--!----------------------------------------------------------------
--! EiffelVision2: library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-1999 Interactive Software Engineering Inc.
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
--!----------------------------------------------------------------
