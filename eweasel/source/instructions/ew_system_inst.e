﻿note
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test";
	date: "$Date$"
	revision: "$Revision$"

class EW_SYSTEM_INST

inherit
	EW_TEST_INSTRUCTION
	EW_STRING_UTILITIES

feature

	inst_initialize (sys: READABLE_STRING_32)
			-- Initialize instruction from `sys'.
			-- Set `init_ok' to indicate whether initialization
			-- was successful.
		do
			if sys.is_empty or first_white_position (sys) > 0 then
				init_ok := False
				failure_explanation := {STRING_32} "zero or more than one system name supplied"
			else
				init_ok := True
				system_name := sys
			end
		end

	execute (test: EW_EIFFEL_EWEASEL_TEST)
			-- Execute `Current' as one of the
			-- instructions of `test'.
		do
			test.set_system_name (system_name)
		end

	init_ok: BOOLEAN
			-- Was last call to `initialize' successful?

	execute_ok: BOOLEAN = True
			-- Calls to `execute' always succeed.

feature {NONE}

	system_name: READABLE_STRING_32
			-- Name of executable file specified in Ace.

;note
	copyright: "[
			Copyright (c) 1984-2018, University of Southern California, Eiffel Software and contributors.
			All rights reserved.
		]"
	license:   "Your use of this work is governed under the terms of the GNU General Public License version 2"
	copying: "[
			This file is part of the EiffelWeasel Eiffel Regression Tester.

			The EiffelWeasel Eiffel Regression Tester is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License version 2 as published
			by the Free Software Foundation.

			The EiffelWeasel Eiffel Regression Tester is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License version 2 for more details.

			You should have received a copy of the GNU General Public
			License version 2 along with the EiffelWeasel Eiffel Regression Tester
			if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA
		]"

end
