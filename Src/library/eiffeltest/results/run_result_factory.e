indexing
	description:
		"Factory producing test run results"

	status:	"See note at end of class"
	date: "$Date$"
	revision: "$Revision$"

class 
	RUN_RESULT_FACTORY

feature {NONE} -- Initialization

	run_result_factory: HASHED_PROTOTYPE_FACTORY [TEST_RUN_RESULT] is
			-- Singleton of run result factory
		local
			r: TEST_RUN_RESULT
		once
			create Result.make
			create r.make_pass; Result.extend (r, "T")
			create r.make_failure; Result.extend (r, "F")
			create r.make_exception; Result.extend (r, "E")
		ensure
			not_empty: Result /= Void and then not Result.empty
		end
		
end -- class RUN_RESULT_FACTORY

--|----------------------------------------------------------------
--| EiffelTest: Reusable components for developing unit tests.
--| Copyright (C) 2000 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------
