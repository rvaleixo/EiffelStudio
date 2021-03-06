﻿note
	description	: "Abstract description ao an alternative of a multi_branch instruction.."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class CASE_AS

inherit
	AST_EIFFEL

create
	initialize

feature {NONE} -- Initialization

	initialize (i: like interval; c: like compound; w_as, t_as: like when_keyword)
			-- Create a new WHEN AST node.
		require
			i_not_void: i /= Void
		do
			interval := i
			compound := c
			if w_as /= Void then
				when_keyword_index := w_as.index
			end
			if t_as /= Void then
				then_keyword_index := t_as.index
			end
		ensure
			interval_set: interval = i
			compound_set: compound = c
			when_keyword_set: w_as /= Void implies when_keyword_index = w_as.index
			then_keyword_set: t_as /= Void implies then_keyword_index = t_as.index
		end

feature -- Visitor

	process (v: AST_VISITOR)
			-- Process current element.
		do
			v.process_case_as (Current)
		end

feature -- Roundtrip

	when_keyword_index, then_keyword_index: INTEGER
			-- Index of keyword "when" and "then" associated with this structure.

	when_keyword (a_list: LEAF_AS_LIST): detachable KEYWORD_AS
			-- Keyword "when" associated with this structure.
		require
			a_list_not_void: a_list /= Void
		do
			Result := keyword_from_index (a_list, when_keyword_index)
		end

	then_keyword (a_list: LEAF_AS_LIST): detachable KEYWORD_AS
			-- Keyword "then" ssociated with this structure.
		require
			a_list_not_void: a_list /= Void
		do
			Result := keyword_from_index (a_list, then_keyword_index)
		end

	index: INTEGER
			-- <Precursor>
		do
			Result := when_keyword_index
		end

feature -- Attributes

	interval: EIFFEL_LIST [INTERVAL_AS]
			-- Interval of the alternative.

	compound: detachable EIFFEL_LIST [INSTRUCTION_AS]
			-- Compound.

feature -- Roundtrip/Token

	first_token (a_list: detachable LEAF_AS_LIST): detachable LEAF_AS
		do
			if a_list /= Void and when_keyword_index /= 0 then
				Result := when_keyword (a_list)
			else
				Result := interval.first_token (a_list)
			end
		end

	last_token (a_list: detachable LEAF_AS_LIST): detachable LEAF_AS
		do
			if attached compound as l_compound then
				Result := l_compound.last_token (a_list)
			elseif a_list /= Void and then_keyword_index /= 0 then
				Result := then_keyword (a_list)
			else
				Result := interval.last_token (a_list)
			end
		end

feature -- Comparison

	is_equivalent (other: like Current): BOOLEAN
			-- Is `other' equivalent to the current object?
		do
			Result := equivalent (compound, other.compound) and
				equivalent (interval, other.interval)
		end

feature {CASE_AS} -- Replication

	set_interval (i: like interval)
		require
			valid_arg: i /= Void
		do
			interval := i
		end

	set_compound (c: like compound)
		do
			compound := c
		end

invariant
	interval_not_void: interval /= Void

note
	copyright:	"Copyright (c) 1984-2018, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
