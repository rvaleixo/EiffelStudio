note
	description: "Actual type for bits."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class BITS_A

inherit
	BASIC_A
		rename
			make as cl_make
		redefine
			is_bit, is_class_valid, internal_is_valid_for_class, conform_to,
			base_class, dump,
			same_as, ext_append_to,
			is_equivalent, process,
			generate_cid, generate_cid_array, generate_cid_init,
			make_type_byte_code, associated_class_type, has_associated_class_type,
			metamorphose, is_external, reference_type
		end

create
	make

feature {NONE} -- Initialization

	make (c: like bit_count)
			-- Initialize new instance of BITS_A with `c' bits.
		do
			bit_count := c
			cl_make (base_class.class_id)
				-- Set expanded mark explicitly because
				-- associated class BIT_REF is reference.
			set_expanded_mark
		ensure
			bit_count_set: bit_count = c
		end

feature -- Visitor

	process (v: TYPE_A_VISITOR)
			-- Process current element.
		do
			v.process_bits_a (Current)
		end

feature -- Status Report

	is_bit: BOOLEAN = True
			-- Is the current actual type a bits type?

	is_class_valid: BOOLEAN
		do
			Result := bit_count > 0
		end

	is_external: BOOLEAN = False
			-- <Precursor>

	has_associated_class_type (a_context_type: TYPE_A): BOOLEAN
		do
			Result := not base_class.types.is_empty
		end

feature -- Comparison

	is_equivalent (other: like Current): BOOLEAN
			-- Is `other' equivalent to the current object?
		do
			Result := bit_count = other.bit_count
		end

feature -- Access

	same_as (other: TYPE_A): BOOLEAN
			-- Is `other' the same as Current?
		do
			Result := attached {BITS_A} other as b and then  bit_count = b.bit_count
		end

	base_class: CLASS_C
			-- Associated class
		do
			if attached System.bit_class as c then
				Result := c.compiled_class
			end
		end

	associated_class_type (a_context_type: TYPE_A): CLASS_TYPE
			-- Associated class type
		do
				-- Return class type for BIT_REF.
			Result := base_class.types.first
		end

	bit_count: NATURAL_32
			-- Bit count

feature -- Settings

	set_bit_count (a_count: like bit_count)
			-- Set `bit_count' with `a_count'.
		require
			a_count_positive: a_count > 0
		do
			bit_count := a_count
		ensure
			bit_count_set: bit_count = a_count
		end

feature -- Generic conformance

	generate_cid (buffer : GENERATION_BUFFER; final_mode, use_info : BOOLEAN; a_context_type: TYPE_A)
		do
			Precursor (buffer, final_mode, use_info, a_context_type)
			buffer.put_natural_32 (bit_count)
			buffer.put_character (',')
		end

	generate_cid_array (buffer: GENERATION_BUFFER; final_mode, use_info: BOOLEAN; idx_cnt: COUNTER; a_context_type: TYPE_A)
		local
			dummy: INTEGER
		do
			Precursor (buffer, final_mode, use_info, idx_cnt, a_context_type)
			buffer.put_natural_32 (bit_count)
			buffer.put_character (',')
				-- Increment counter.
			dummy := idx_cnt.next
		end

	generate_cid_init (buffer: GENERATION_BUFFER; final_mode, use_info: BOOLEAN; idx_cnt: COUNTER; a_context_type: TYPE_A; a_level: NATURAL)
		local
			dummy: INTEGER
		do
			Precursor (buffer, final_mode, use_info, idx_cnt, a_context_type, a_level)
			dummy := idx_cnt.next
		end

	make_type_byte_code (ba : BYTE_ARRAY; use_info : BOOLEAN; a_context_type: TYPE_A)
		do
			Precursor (ba, use_info, a_context_type)
				-- FIXME: Manu 08/06/2003: There is no limitation about the size
				-- of a BIT to 2^15, therefore when `size' is greater than 2^15
				-- we have a problem!!!!. It does not only apply to current routine
				-- but to all the generic conformance stuff.
			ba.append_short_integer (bit_count.as_integer_32)
		end

feature -- C code generation

	metamorphose (reg, value: REGISTRABLE; buffer: GENERATION_BUFFER)
			-- Generate the metamorphism from simple type to reference and
			-- put result in register `reg'. The value of the basic type is
			-- held in `value'.
		do
			reg.print_register
			buffer.put_string (" = ")
			value.print_register
		end

feature -- Output

	dump: STRING
			-- Dumped trace
		do
			create Result.make (10)
			Result.append ("BIT ")
			Result.append_natural_32 (bit_count)
		end

	ext_append_to (st: TEXT_FORMATTER; c: CLASS_C)
		do
			st.process_keyword_text ({SHARED_TEXT_ITEMS}.ti_bit_class, Void)
			st.add_space
			st.add_natural_32 (bit_count)
		end

feature {TYPE_A} -- Helpers

	internal_is_valid_for_class (a_class: CLASS_C): BOOLEAN
			-- Is current type valid?
		do
			Result := bit_count > 0
		end

feature {COMPILER_EXPORTER}

	reference_type: BITS_A
			-- We can use Current as `reference type' since they share the same code.
		do
			Result := Current
		end

	conform_to (a_context_class: CLASS_C; other: TYPE_A): BOOLEAN
			-- Does Current conform to `other'?
		local
			other_bits: BITS_A
		do
			other_bits ?= other.conformance_type
			if other_bits /= Void then
				Result := other_bits.bit_count >= bit_count
			else
				Result := Precursor {BASIC_A} (a_context_class, other)
			end
		end

	c_type: BIT_I
			-- C type
		do
			create Result.make (bit_count)
		end

invariant
	bit_count_positive: is_valid implies bit_count > 0

note
	copyright:	"Copyright (c) 1984-2011, Eiffel Software"
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

end -- class BITS_A
