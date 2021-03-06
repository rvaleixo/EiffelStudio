note
	description: "Implemented `Font' Interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	FONT_IMPL_PROXY

inherit
	FONT_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER)
			-- Make from pointer
		do
			initializer := ccom_create_font21_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	name: STRING
			-- No description available.
		do
			Result := ccom_name (initializer)
		end

	size: ECOM_CURRENCY
			-- No description available.
		do
			Result := ccom_size (initializer)
		end

	bold: BOOLEAN
			-- No description available.
		do
			Result := ccom_bold (initializer)
		end

	italic: BOOLEAN
			-- No description available.
		do
			Result := ccom_italic (initializer)
		end

	underline: BOOLEAN
			-- No description available.
		do
			Result := ccom_underline (initializer)
		end

	strikethrough: BOOLEAN
			-- No description available.
		do
			Result := ccom_strikethrough (initializer)
		end

	weight: INTEGER
			-- No description available.
		do
			Result := ccom_weight (initializer)
		end

	charset: INTEGER
			-- No description available.
		do
			Result := ccom_charset (initializer)
		end

feature -- Status Report

	last_error_code: INTEGER
			-- Last error code.
		do
			Result := ccom_last_error_code (initializer)
		end

	last_error_description: STRING
			-- Last error description.
		do
			Result := ccom_last_error_description (initializer)
		end

	last_error_help_file: STRING
			-- Last error help file.
		do
			Result := ccom_last_error_help_file (initializer)
		end

	last_source_of_exception: STRING
			-- Last source of exception.
		do
			Result := ccom_last_source_of_exception (initializer)
		end

feature -- Element Change

	set_name (a_value: STRING)
			-- Set `name' with `a_value'.
		do
			ccom_set_name (initializer, a_value)
		end

	set_size (a_value: ECOM_CURRENCY)
			-- Set `size' with `a_value'.
		do
			ccom_set_size (initializer, a_value.item)
		end

	set_bold (a_value: BOOLEAN)
			-- Set `bold' with `a_value'.
		do
			ccom_set_bold (initializer, a_value)
		end

	set_italic (a_value: BOOLEAN)
			-- Set `italic' with `a_value'.
		do
			ccom_set_italic (initializer, a_value)
		end

	set_underline (a_value: BOOLEAN)
			-- Set `underline' with `a_value'.
		do
			ccom_set_underline (initializer, a_value)
		end

	set_strikethrough (a_value: BOOLEAN)
			-- Set `strikethrough' with `a_value'.
		do
			ccom_set_strikethrough (initializer, a_value)
		end

	set_weight (a_value: INTEGER)
			-- Set `weight' with `a_value'.
		do
			ccom_set_weight (initializer, a_value)
		end

	set_charset (a_value: INTEGER)
			-- Set `charset' with `a_value'.
		do
			ccom_set_charset (initializer, a_value)
		end

feature {NONE}  -- Implementation

	delete_wrapper
			-- Delete wrapper
		do
			ccom_delete_font21_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_name (cpp_obj: POINTER): STRING
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_set_name (cpp_obj: POINTER; a_value: STRING)
			-- Set `name' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](EIF_OBJECT)"
		end

	ccom_size (cpp_obj: POINTER): ECOM_CURRENCY
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_set_size (cpp_obj: POINTER; a_value: POINTER)
			-- Set `size' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](CURRENCY *)"
		end

	ccom_bold (cpp_obj: POINTER): BOOLEAN
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_BOOLEAN"
		end

	ccom_set_bold (cpp_obj: POINTER; a_value: BOOLEAN)
			-- Set `bold' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](EIF_BOOLEAN)"
		end

	ccom_italic (cpp_obj: POINTER): BOOLEAN
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_BOOLEAN"
		end

	ccom_set_italic (cpp_obj: POINTER; a_value: BOOLEAN)
			-- Set `italic' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](EIF_BOOLEAN)"
		end

	ccom_underline (cpp_obj: POINTER): BOOLEAN
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_BOOLEAN"
		end

	ccom_set_underline (cpp_obj: POINTER; a_value: BOOLEAN)
			-- Set `underline' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](EIF_BOOLEAN)"
		end

	ccom_strikethrough (cpp_obj: POINTER): BOOLEAN
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_BOOLEAN"
		end

	ccom_set_strikethrough (cpp_obj: POINTER; a_value: BOOLEAN)
			-- Set `strikethrough' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](EIF_BOOLEAN)"
		end

	ccom_weight (cpp_obj: POINTER): INTEGER
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_set_weight (cpp_obj: POINTER; a_value: INTEGER)
			-- Set `weight' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](EIF_INTEGER)"
		end

	ccom_charset (cpp_obj: POINTER): INTEGER
			-- No description available.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_set_charset (cpp_obj: POINTER; a_value: INTEGER)
			-- Set `charset' with `a_value'.
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](EIF_INTEGER)"
		end

	ccom_delete_font21_impl_proxy (a_pointer: POINTER)
			-- Release resource
		external
			"C++ [delete Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]()"
		end

	ccom_create_font21_impl_proxy_from_pointer (a_pointer: POINTER): POINTER
			-- Create from pointer
		external
			"C++ [new Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER
			-- Item
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER
			-- Last error code
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING
			-- Last error description
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING
			-- Last error help file
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING
			-- Last source of exception
		external
			"C++ [Font21_impl_proxy %"ecom_Font21_impl_proxy.h%"]():EIF_REFERENCE"
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- FONT_IMPL_PROXY

