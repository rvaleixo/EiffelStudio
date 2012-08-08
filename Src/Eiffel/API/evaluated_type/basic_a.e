note
	description: "Actual type for simple types."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision $"

deferred class
	BASIC_A

inherit
	CL_TYPE_A
		undefine
			c_type
		redefine
			instantiation_of,
			meta_type, is_basic, reference_type,
			good_generics, internal_is_valid_for_class, error_generics,
			description, description_with_detachable_type,
			generic_il_type_name, hash_code, internal_generic_derivation, generic_derivation,
			internal_same_generic_derivation_as, generate_cecil_value,
			sk_value, element_type, make, is_processor_attachable_to
		end

feature {NONE} -- Initialization

	make (a_class_id: INTEGER)
		local
			l_class: like base_class
		do
			class_id := a_class_id
			l_class := system.class_of_id (a_class_id)
				-- A basic type has always its base class expanded.
			set_expanded_class_mark
		end

feature -- Access

	generic_derivation: CL_TYPE_A
			-- <Precursor>
		do
			Result := internal_generic_derivation (0)
		end

feature -- FIXME

	associated_reference_class_type: CLASS_TYPE
			-- Reference class type of Current
		do
				-- We can safely use `Void' here because basic types are not generic.
				-- FIXME: Manu: check that it works fine for TYPED_POINTER_A.
			Result := reference_type.associated_class_type (Void)
		ensure
			associated_reference_class_type_not_void: Result /= Void
		end

feature -- Status Report

	is_basic: BOOLEAN = True
			-- Is the current actual type a basic one ?

feature -- Access

	hash_code: INTEGER
		do
			Result := c_type.hash_code
		end

	description: ATTR_DESC
			-- Type description for skeleton
		do
			Result := c_type.new_attribute_description
		end

	description_with_detachable_type: ATTR_DESC
			-- Type description for skeleton
		do
			Result := c_type.new_attribute_description
		end

	element_type: INTEGER_8
		do
			Result := c_type.element_type
		end

	sk_value (a_context_type: TYPE_A): NATURAL_32
		do
			Result := c_type.sk_value
		end

	meta_type: BASIC_A
			-- Associated meta type
		do
			Result := Current
		end

	good_generics: BOOLEAN
			-- Has the current type the right number of generic types ?
		do
			Result := True
		end

	error_generics: VTUG
		do
		end

feature -- IL code generation

	generic_il_type_name (a_context_type: TYPE_A): STRING
			-- Associated name to for naming in generic derivation.
		do
			Result := base_class.name.twin
		end

feature -- C code generation

	metamorphose (reg, value: REGISTRABLE; buffer: GENERATION_BUFFER)
			-- Generate the metamorphism from simple type to reference and
			-- put result in register `reg'. The value of the basic type is
			-- held in `value'.
		require
			valid_reg: reg /= Void
			valid_value: value /= Void
			valid_file: buffer /= Void
		local
			c: CREATE_TYPE
			buf: like buffer
			g: GEN_TYPE_A
		do
			buf := buffer
			create c.make (Current)
			if generics /= Void then
				g ?= Current
				buf.put_new_line
				buf.put_character ('{')
				buf.indent
				system.byte_context.generate_gen_type_conversion (g, 0)
			end
			buf.put_new_line
			reg.print_register
			buf.put_string (" = ")
			c.generate
			buf.put_character (';')
			if generics /= Void then
				buf.exdent
				buf.put_new_line
				buf.put_character ('}')
			end
			buf.put_new_line
			buf.put_character ('*')
			c_type.generate_access_cast (buffer)
			reg.print_register
			buf.put_string (" = ")
			value.print_register
		end

	generate_cecil_value (buffer: GENERATION_BUFFER; a_context_type: TYPE_A)
		do
			c_type.generate_sk_value (buffer)
		end

feature {TYPE_A} -- Helpers

	internal_is_valid_for_class (a_class: CLASS_C): BOOLEAN
			-- The associated class is still in the system
		do
			Result := True
		end

	internal_generic_derivation (a_level: INTEGER): CL_TYPE_A
			-- Precise generic derivation of current type.
			-- That is to say given a type, it gives the associated TYPE_I
			-- which can be used to search its associated CLASS_TYPE.
		do
				-- We do a special thing for basic types, since for generating the code
				-- which is in their base class, we need a reference and not a basic type.
			if a_level = 0 and not system.il_generation then
				create Result.make (class_id)
			else
				Result := Current
			end
		end

	internal_same_generic_derivation_as (current_type, other: TYPE_A; a_level: INTEGER): BOOLEAN
		do
			if a_level = 0 and not system.il_generation then
				if attached {CL_TYPE_A} other as l_type then
					Result := class_id = l_type.class_id and then
						(l_type.declaration_mark /= declaration_mark implies
							(l_type.is_expanded = is_expanded and then
							l_type.is_separate = is_separate)) and then
						l_type.generics = Void
				end
			else
				Result := same_as (other)
			end
		end

feature -- Comparison

	is_processor_attachable_to (other: TYPE_A): BOOLEAN
			-- <Precursor>
		do
			Result := True
		end

feature {COMPILER_EXPORTER}

	instantiation_of (type: TYPE_A; a_class_id: INTEGER): TYPE_A
			-- Insatiation of `type' in s simple type
		do
			Result := type.actual_type
		end

	reference_type: CL_TYPE_A
			-- Reference counterpart of an expanded type
		do
			create Result.make (class_id)
			if class_declaration_mark = expanded_mark then
				Result.set_expanded_class_mark
			end
			Result.set_reference_mark
		end

invariant
	is_basic: is_basic
	is_expanded: is_expanded

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

end -- class BASIC_A
