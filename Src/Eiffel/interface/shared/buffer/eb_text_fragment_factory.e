﻿note
	description: "Text fragment factory."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_TEXT_FRAGMENT_FACTORY

inherit
	EB_SHARED_MANAGERS

	EB_EDITORS_MANAGER

	SHARED_SERVER

-- inherit {NONE}
	EIFFEL_LAYOUT
		export
			{NONE} all
		end

feature -- Access

	new_file_name (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$file_name" fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_file (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$file" tool buffer selected fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_path (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$path" tool buffer selected fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_directory_name (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$directory_name" fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_w_code (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$w_code" fragment
		require
			a_scanner_attached: a_scanner /= Void
		local
			l_fragment: EB_AGENT_BASED_TEXT_FRAGMENT
		do
			create l_fragment.make (a_scanner.text, agent new_w_code_replacement, agent is_string_case_insensitive_equal (?, "$w_code"))
			l_fragment.set_location (a_scanner.position)
			Result := l_fragment
			Result.set_normalized_text_function (agent lower_case_text_normalizer)
		ensure
			result_attached: Result /= Void
		end

	new_f_code (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$f_code" fragment
		require
			a_scanner_attached: a_scanner /= Void
		local
			l_fragment: EB_AGENT_BASED_TEXT_FRAGMENT
		do
			create l_fragment.make (a_scanner.text, agent new_f_code_replacement, agent is_string_case_insensitive_equal (?, "$f_code"))
			l_fragment.set_location (a_scanner.position)
			Result := l_fragment
			Result.set_normalized_text_function (agent lower_case_text_normalizer)
		ensure
			result_attached: Result /= Void
		end

	new_project_directory (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$project_path" fragment
		require
			a_scanner_attached: a_scanner /= Void
		local
			l_fragment: EB_AGENT_BASED_TEXT_FRAGMENT
		do
			create l_fragment.make (a_scanner.text, agent new_project_directory_replacement, agent is_true)
			l_fragment.set_location (a_scanner.position)
			Result := l_fragment
			Result.set_normalized_text_function (agent lower_case_text_normalizer)
		ensure
			result_attached: Result /= Void
		end

	new_target_directory (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$targer_path" fragment
		local
			l_fragment: EB_AGENT_BASED_TEXT_FRAGMENT
		do
			create l_fragment.make (a_scanner.text, agent new_target_directory_replacement, agent is_true)
			l_fragment.set_location (a_scanner.position)
			Result := l_fragment
			Result.set_normalized_text_function (agent lower_case_text_normalizer)
		ensure
			result_attached: Result /= Void
		end

	new_group_directory (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$group_path" fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_group_name (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$group_name" fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_class_name (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$class_name" fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_line (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$line" fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_class_buffer (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "{CLASS}" buffer fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_class_buffer_selected (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "@{CLASS}" class buffer selected fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_feature_buffer (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "{CLASS}.feature" buffer fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_tool_buffer (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "[Tool name]" tool buffer fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_tool_buffer_selected (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "@[Tool name]" tool buffer selected fragment
		require
			a_scanner_attached: a_scanner /= Void
		deferred
		ensure
			result_attached: Result /= Void
		end

	new_target_name (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- New "$target_name" text fragment
		require
			a_scanner_attached: a_scanner /= Void
		local
			l_fragment: EB_AGENT_BASED_TEXT_FRAGMENT
		do
			create l_fragment.make (a_scanner.text, agent new_target_name_replacement, agent is_true)
			l_fragment.set_location (a_scanner.position)
			Result := l_fragment
			Result.set_normalized_text_function (agent lower_case_text_normalizer)
		ensure
			result_attached: Result /= Void
		end

feature -- Text Normalizer

	lower_case_text_normalizer (a_text: STRING_32): STRING_32
			-- Text normalizer, return a copy of `a_text' in which all letters are turned into lower case
		require
			a_text_attached: a_text /= Void
		do
			Result := a_text.as_lower
		ensure
			result_attached: Result /= Void
		end

	upper_case_text_normalizer (a_text: STRING_32): STRING_32
			-- Text normalizer, return a copy of `a_text' in which all letters are turned into upper case
		require
			a_text_attached: a_text /= Void
		do
			Result := a_text.as_upper
		ensure
			result_attached: Result /= Void
		end

	class_name_text_normalizer (a_text: STRING_32): STRING_32
			-- Text normalize which turns `a_text' in form of "{ class_name }" into "CLASS_NAME",
			-- i.e., remove surrounding "{" and "}", remove heading and trailing space and turn all letters into upper case.
		require
			a_text_attached: a_text /= Void
			a_text_valid: a_text.count > 2
		do
			Result := a_text.substring (2, a_text.count - 1)
			Result.left_adjust
			Result.right_adjust
			Result.to_upper
		ensure
			result_attached: Result /= Void
		end

	class_selected_text_normalizer (a_text: STRING_32): STRING_32
			-- Text normalize which turns `a_text' in form of "@{ class_name }" into "CLASS_NAME",
			-- i.e., remove surrounding "@{" and "}", remove heading and trailing space and turn all letters into upper case.
		require
			a_text_attached: a_text /= Void
			a_text_valid: a_text.count > 3
		do
			Result := a_text.substring (3, a_text.count - 1)
			Result.left_adjust
			Result.right_adjust
			Result.to_upper
		ensure
			result_attached: Result /= Void
		end

	class_feature_text_normalizer (a_text: STRING_32): STRING_32
			-- Text normalize which turns `a_text' in form of "{ class_name }.feature_name" into "CLASS_NAME.feature_name",
			-- i.e., remove surrounding "{" and "}", remove heading and trailing space and turn all letters related to class
			-- into upper case and all letters related to feature into lower case.
		require
			a_text_attached: a_text /= Void
			a_text_valid: a_text.count >= 5 and then a_text.index_of ('.', 1) > 1 and then a_text.index_of ('.', 1) < a_text.count
		local
			l_dot_index: INTEGER
			l_class_name: STRING
			l_feature_name: STRING
			l_dot: CHARACTER
		do
			l_dot := '.'
			l_dot_index := a_text.index_of (l_dot, 1)

			l_class_name := a_text.substring (2, l_dot_index - 2)
			l_class_name.left_adjust
			l_class_name.right_adjust
			l_class_name.to_upper

			l_feature_name := a_text.substring (l_dot_index + 1, a_text.count)
			l_feature_name.to_lower

			create Result.make (64)
			Result.append (l_class_name)
			Result.append_character (l_dot)
			Result.append (l_feature_name)
		ensure
			result_attached: Result /= Void
		end

	tool_name_text_normalizer (a_text: STRING): STRING
			-- Text normalize which turns `a_text' in form of "[ tool_name ]" into "tool name",
			-- i.e., remove surrounding "{" and "}", remove heading and trailing space and turn all letters into lower case.
		require
			a_text_attached: a_text /= Void
			a_text_valid: a_text.count > 2
		do
			Result := a_text.substring (2, a_text.count - 1)
			Result.left_adjust
			Result.right_adjust
			Result.to_lower
		ensure
			result_attached: Result /= Void
		end

	tool_selected_text_normalizer (a_text: STRING): STRING
			-- Text normalize which turns `a_text' in form of "@[ tool_name ]" into "CLASS_NAME",
			-- i.e., remove surrounding "@{" and "}", remove heading and trailing space and turn all letters into lower case.
		require
			a_text_attached: a_text /= Void
			a_text_valid: a_text.count > 3
		do
			Result := a_text.substring (3, a_text.count - 1)
			Result.left_adjust
			Result.right_adjust
			Result.to_lower
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	is_string_case_insensitive_equal (a_string, b_string: STRING_32): BOOLEAN
			-- Is `a_string' is case-insensitive equal to `b_string'?
		require
			a_string_attached: a_string /= Void
			b_string_attached: b_string /= Void
		do
			Result := a_string.is_case_insensitive_equal (b_string)
		ensure
			good_result: Result = a_string.is_case_insensitive_equal (b_string)
		end

	new_w_code_replacement (a_text: STRING_32): STRING_32
			-- New w_code replacement for `a_text'.
			-- Return path of `w_code' directory if system is defined,
			-- otherwise return a copy of `a_text'.
		require
			a_text_attached: a_text /= Void
		do
			if workbench.system_defined then
				Result := project_location.workbench_path.name
			else
				Result := a_text.twin
			end
		ensure
			result_attached: Result /= Void
		end

	new_f_code_replacement (a_text: STRING_32): STRING_32
			-- New w_code replacement for `a_text'.
			-- Return path of `f_code' directory if system is defined,
			-- otherwise return a copy of `a_text'.
		require
			a_text_attached: a_text /= Void
		do
			if workbench.system_defined then
				Result := project_location.final_path.name
			else
				Result := a_text.twin
			end
		ensure
			result_attached: Result /= Void
		end

	new_project_directory_replacement (a_text: STRING_32): STRING_32
			-- New project_path replacement for `a_text'.
			-- Return path of current porject if system is defined,
			-- otherwise return a copy of `a_text'.
		require
			a_text_attached: a_text /= Void
		do
			if workbench.system_defined then
				Result := project_location.path.name
			else
				Result := a_text.twin
			end
		ensure
			result_attached: Result /= Void
		end

	new_target_directory_replacement (a_text: STRING_32): STRING_32
			-- New target_path replacement for `a_text'.
			-- Return path of current target if system is defined,
			-- otherwise return a copy of `a_text'.
		require
			a_text_attached: a_text /= Void
		do
			if workbench.system_defined then
				Result := project_location.target_path.name
			else
				Result := a_text.twin
			end
		ensure
			result_attached: Result /= Void
		end

	new_target_name_replacement (a_text: STRING_32): STRING_32
			-- New target_name replacement for `a_text'.
			-- Return path of current target if system is defined,
			-- otherwise return a copy of `a_text'.
		require
			a_text_attached: a_text /= Void
		do
			if workbench.system_defined and then attached universe.target then
				Result := universe.target_name.as_string_32.string
			else
				Result := a_text.string
			end
		ensure
			result_attached: Result /= Void
		end

	basic_text_fragment (a_scanner: EB_COMMAND_SCANNER_SKELETON): EB_TEXT_FRAGMENT
			-- Basic text fragment for text in `a_scanner'
		require
			a_scanner_attached: a_scanner /= Void
		do
			create {EB_AGENT_BASED_TEXT_FRAGMENT}Result.make (a_scanner.text, agent (a_text: STRING_32): STRING_32 do Result := a_text.twin end, agent is_true)
			Result.set_location (a_scanner.position)
			Result.set_normalized_text_function (agent (a_text: STRING_32): STRING_32 do Result := a_text.twin end)
		ensure
			result_attached: Result /= Void
		end

	is_true (a_text: STRING_32): BOOLEAN
			-- Is `a_text' valid?
			-- Always returns True.
		require
			a_text_attached: a_text /= Void
		do
			Result := True
		ensure
			good_result: Result
		end

note
	copyright: "Copyright (c) 1984-2018, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
