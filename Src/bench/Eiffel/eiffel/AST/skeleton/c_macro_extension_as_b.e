class C_MACRO_EXTENSION_AS_B

inherit
	C_MACRO_EXTENSION_AS;
	C_EXTENSION_AS_B
		undefine
			parse_special_part, is_macro
		redefine
			extension_i, byte_node
		end

feature

	extension_i (external_as: EXTERNAL_AS): C_MACRO_EXTENSION_I is
			-- EXTERNAL_EXT_I corresponding to current extension
		do
			!! Result
			init_extension_i (Result)
			Result.set_special_file_name (special_file_name)
		end

feature -- Byte code

	byte_node: MACRO_EXT_BYTE_CODE is
			-- Byte code for external extension
		do
			!! Result
		end

end -- class C_MACRO_EXTENSION_AS_B
