indexing

	description: 
		"Window where output is generated.";
	date: "$Date$";
	revision: "$Revision $"

deferred class OUTPUT_WINDOW

inherit
	TEXT_FORMATTER

feature {TEXT_ITEM} -- Text processing

	process_basic_text (text: BASIC_TEXT) is
		do
			put_string (text.image)
		end;

	process_comment_text (text: COMMENT_TEXT) is
			-- Process comment text. 
		do
			put_comment (text.image)
		end;

	process_quoted_text (text: QUOTED_TEXT) is
			-- Process the quoted `text' within a comment.
		do
			put_quoted_comment (text.image)
		end;

	process_class_name_text (text: CLASS_NAME_TEXT) is
			-- Process class name text `t'.
		local
			e_class: E_CLASS;
			class_i: CLASS_I
		do
			class_i := text.class_i;
			e_class := class_i.compiled_eclass;
			if e_class /= Void then
				put_class (e_class, text.image)
			else
				put_classi (class_i, text.image)
			end;
		end;

	process_feature_name_text (text: FEATURE_NAME_TEXT) is
			-- Process feature name text `t'.
		do
			put_feature_name (text.image, text.e_class)
		end;

	process_feature_text (text: FEATURE_TEXT) is
			-- Process feature text `text'.
		do
			put_feature (text.e_feature, text.e_class, text.image)
		end;

	process_breakpoint (a_bp: BREAKPOINT_ITEM) is
			-- Process breakpoint.
		do
		end;

	process_padded is
			-- Process padded item at start of non breakpoint line.
		do
		end;

	process_new_line (text: NEW_LINE_ITEM) is
			-- Process new line text `t'.
		do
			new_line
		end;

	process_indentation (text: INDENT_TEXT) is
			-- Process indentation `t'.
		do
			put_indent (text.indent_depth, text.image)
		end;

	process_after_class (text: AFTER_CLASS) is
			-- Process after class text `t'.
		do
			put_after_class (text.e_class, text.image)
		end;

	process_before_class (text: BEFORE_CLASS) is
			-- Process before class `t'.
		do
			put_before_class (text.e_class)
		end;

	process_filter_item (text: FILTER_ITEM) is
			-- Process filter text `t'.
		do
			put_filter_item (text.construct, text.is_before)
		end;

	process_symbol_text (text: SYMBOL_TEXT) is
			-- Process symbol text.
		do
			put_symbol (text.image)
		end;

	process_keyword_text (text: KEYWORD_TEXT) is
			-- Process keyword text.
		do
			put_keyword (text.image)
		end;

	process_operator_text (text: OPERATOR_TEXT) is
			-- Process operator text.
		do
			put_operator (text.image, text.e_feature, text.e_class, text.is_keyword)
		end;

	process_address_text (text: ADDRESS_TEXT) is
			-- Process address text.
		do
			put_address (text.address, text.e_class)
		end;

	process_error_text (text: ERROR_TEXT) is
			-- Process error text.
		do
			put_error (text.error, text.error_text)
		end;

	process_cl_syntax (text: CL_SYNTAX_ITEM) is
			-- Process class syntax text.
		do
			put_class_syntax (text.syntax_error, text.e_class, text.error_text)
		end;

	process_ace_syntax (text: ACE_SYNTAX_ITEM) is
			-- Process Ace syntax text.
		do
			put_ace_syntax (text.syntax_error, text.error_text)
		end;

feature -- Ouput
	
	display is 
			-- Display the contents of window.
		do 
		end;

	clear_window is 		
			-- Clear the contents of window.
		do 
		end;

	new_line is 
			-- Put a new line at current position.
		deferred 
		end;

	put_string (s: STRING) is 
			-- Put string `s' at current position.
		require
			valid_s: s /= Void
		deferred 
		end;

	put_char (c: CHARACTER) is 
			-- Put a character `c' at current position.
		deferred 
		end;

	put_int (i: INTEGER) is
			-- Put a integer `i' at current position.
		do
			put_string (i.out);
		end;

	put_cluster (e_cluster: CLUSTER_I; str: STRING) is
			-- Put `e_cluster' with string representation
			-- `str' at current position.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_class (e_class: E_CLASS; str: STRING) is
			-- Put `e_class' with string representation
			-- `str' at current position.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_classi (class_i: CLASS_I; str: STRING) is
			-- Put `class_i' with string representation
			-- `str' at current position.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_error (error: ERROR; str: STRING) is
			-- Put `error' with string representation
			-- `str' at current position.
		require
			valid_error: error /= Void;
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_feature (feat: E_FEATURE; e_class: E_CLASS; str: STRING) is
			-- Put feature `feat' defined in `e_class' with string 
			-- representation `str' at current position.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_feature_name (f_name: STRING; e_class: E_CLASS) is
			-- Put feature name `f_name' defined in `e_class'.
		require
			valid_f_name: f_name /= Void
		do
			put_string (f_name)
		end;

	put_address (address: STRING; e_class: E_CLASS) is
			-- Put `address' for `e_class'.
		require
			valid_address: address /= Void;
		do
			put_string (address)
		end;

	put_class_syntax (syn: SYNTAX_ERROR; eclass: E_CLASS; str: STRING) is
			-- Put `syn' for `e_class' with `str' as representation.
		require
			valid_syn: syn /= Void;
			valid_str: str /= Void;
		do
			put_string (str)
		end;

	put_ace_syntax (syn: SYNTAX_ERROR; str: STRING) is
			-- Put `syn' with `str' as representation.
		require
			valid_syn: syn /= Void;
			valid_str: str /= Void;
		do
			put_string (str)
		end;

	put_comment (str: STRING) is
			-- Put `str' as representation of a comment.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_quoted_comment (str: STRING) is
			-- Put `str' as representation of quoted text.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;	

	put_one_indent is
			-- Put one indent to Current.
		do
			put_indent (1, "%T")
		end;

	put_indent (nbr_of_tabs: INTEGER; str: STRING) is
			-- Put indent of `nbr_of_tabs' with image `str'.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_after_class (e_class: E_CLASS; str: STRING) is
			-- Put `str' as representation of quoted text.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_before_class (e_class: E_CLASS) is
			-- Put `str' as representation of quoted text.
		require
			valid_e_class: e_class /= Void
		do
		end;

	put_filter_item (construct: STRING; is_before: BOOLEAN) is
			-- Put `str' as representation of quoted text.
		require
			valid_construct: construct /= Void
		do
		end;

	put_symbol (str: STRING) is
			-- Put `str' as representation of quoted text.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_keyword (str: STRING) is
			-- Put `str' as representation of quoted text.
		require
			valid_str: str /= Void
		do
			put_string (str)
		end;

	put_operator (str: STRING; e_feature: E_FEATURE; e_class: E_CLASS; is_keyword: BOOLEAN) is
			-- Put `str' as representation of quoted text.
		require
			valid_str: str /= Void;
			valid_e_feature: e_feature /= Void;
			valid_e_class: e_class /= Void;
		do
			put_string (str)
		end;

end -- class OUTPUT_WINDOW
