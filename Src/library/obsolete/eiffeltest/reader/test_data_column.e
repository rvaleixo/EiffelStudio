﻿note
	description: "Columns in a table representing test input data"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class TEST_DATA_COLUMN

inherit
	ANY

	EXCEPTIONS
		export
			{NONE} all
		end

feature -- Status report

	input_accepted (s: STRING): BOOLEAN
			-- Is `s' acceptable input for this column?
		do
			Result := True
		end

feature -- Basic operations

	frozen inject (t: TEST_SIMPLE_CASE; s: STRING)
			-- Inject data `s' into test case `t'.
		require
			test_case_exists: t /= Void
			accepted_input: input_accepted (s)
		do
			test_case := {like test_case} / t
			if test_case = Void then
				raise ("Passed test case is of wrong type")
			end
			inject_data (s)
		end

feature {NONE} -- Implementation

	test_case: TEST_SIMPLE_CASE
			-- Test case to be injected
			-- (To be redefined.)

	inject_data (s: STRING)
			-- Inject `s' into `test_case'.
		require
			test_case_set: test_case /= Void
		deferred
		end

note
	copyright:	"Copyright (c) 1984-2019, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
