indexing
	description: "Instance of an Eiffel feature: for every inherited feature there is%N%
		%an instance of FEATURE_I with its final name, the class name where it%N%
		%is written, the body id of its content and the routine table ids to%N%
		%which the feature is attached.%N%
		%Attribute `type' is the real type of the feature in the class where it%N%
		%is inherited (or written), that means there is no more anchored type."
	date: "$Date$"
	version: "$Revision$"

deferred class FEATURE_I 

inherit
	SHARED_WORKBENCH

	SHARED_SERVER
		export
			{ANY} all
		end

	SHARED_INSTANTIATOR

	SHARED_ERROR_HANDLER

	SHARED_TYPES

	SHARED_EVALUATOR

	SHARED_ARG_TYPES

	SHARED_TABLE

	SHARED_AST_CONTEXT

	SHARED_BYTE_CONTEXT
		rename
			context as byte_context
		end

	SHARED_CODE_FILES

	SHARED_PATTERN_TABLE

	SHARED_INST_CONTEXT

	SHARED_ID_TABLES
		export
			{ANY} Body_index_table, Original_body_index_table
		end

	SHARED_ARRAY_BYTE

	SHARED_EXEC_TABLE

	HASHABLE
		rename
			hash_code as feature_name_id
		end

	COMPILER_EXPORTER

	SHARED_NAMES_HEAP
		
	DEBUG_OUTPUT

	COMPARABLE
		undefine
			is_equal
		end
			
feature -- Access

	feature_name: STRING is
			-- Final name of feature.
		require
			feature_name_id_set: feature_name_id > 0
		do
			Result := Names_heap.item (feature_name_id)
		ensure
			feature_name_not_void: Result /= Void
			feature_name_not_empty: not Result.is_empty
		end
		
	escaped_feature_name: STRING is
			-- Final name of feature with escape for C code generation
		local
			l_string_converter: STRING_CONVERTER
		do
			create l_string_converter
			Result := l_string_converter.escaped_string (feature_name)
		ensure
			feature_name_not_void: Result /= Void
			feature_name_not_empty: not Result.is_empty
		end

	feature_name_id: INTEGER
			-- Id of `feature_name' in `Names_heap' table.

	feature_id: INTEGER
			-- Feature id: first key in feature call hash table
			-- of a class: tow features of different names have two
			-- different feature ids.

	written_in: INTEGER
			-- Class id where feature is written

	body_index: INTEGER
			-- Index of body id

	pattern_id: INTEGER
			-- Id of feature pattern

	rout_id_set: ROUT_ID_SET
			-- Routine table to which feature belongs to.

	export_status: EXPORT_I
			-- Export status of feature

	origin_feature_id: INTEGER
			-- Feature ID of Current in associated CLASS_INTERFACE
			-- that defines it.
			-- Used for MSIL code generation only.

	origin_class_id: INTEGER
			-- Class ID of class defining Current in associated CLASS_INTERFACE
			-- that defines it.
			-- Used for MSIL code generation only.

	written_feature_id: INTEGER
			-- Feature ID of Current in associated CLASS_C of ID `written_in'
			-- that gives a body.
			-- Used for MSIL code generation only.

	frozen is_origin: BOOLEAN is
			-- Is feature an origin?
		do
			Result := feature_flags & is_origin_mask = is_origin_mask
		end

	frozen is_frozen: BOOLEAN is
			-- Is feature frozen?
		do
			Result := feature_flags & is_frozen_mask = is_frozen_mask
		end

	frozen is_empty: BOOLEAN is
			-- Is feature with an empty body?
		do
			Result := feature_flags & is_empty_mask = is_empty_mask
		end

	frozen is_infix: BOOLEAN is
			-- Is feature an infixed one ?
		do
			Result := feature_flags & is_infix_mask = is_infix_mask
		end

	frozen is_prefix: BOOLEAN is
			-- Is feature a prefixed one ?
		do
			Result := feature_flags & is_prefix_mask = is_prefix_mask
		end

	frozen is_selected: BOOLEAN is
			-- Is feature selected?
		do
			-- FIXME: Manu 11/21/2001.
			-- Not used at the moment.
		end

	extension: EXTERNAL_EXT_I is
			-- Encapsulation of the external extension
		do
		end

	external_name: STRING is
			-- External name
		require
			external_name_id_set: external_name_id > 0
		do
			Result := Names_heap.item (external_name_id)
		ensure
			Result_not_void: Result /= Void
			Result_not_empty: not Result.is_empty
		end;

	external_name_id: INTEGER is
			-- External name of feature if any generation.
		do
			Result := private_external_name_id
			if Result = 0 then
				Result := feature_name_id
			end
		end

feature -- Comparison

	infix "<" (other: FEATURE_I): BOOLEAN is
			-- Comparison of FEATURE_I based on their name.
		local
			l_name, l_other_name: like feature_name
		do
			l_name := feature_name
			l_other_name := other.feature_name
			if l_name = Void then
				Result := other.feature_name /= Void
			else
				Result := l_other_name /= Void and l_name < l_other_name
			end
		end

feature -- Debugger access

	number_of_breakpoint_slots: INTEGER is
			-- Number of breakpoint slots in feature (:::)
			-- It includes pre/postcondition (inner & herited)
			-- and rescue clause.
			--
			--|---------------------------------------------------------
			--| Note from Arnaud PICHERY [ aranud@mail.dotcom.fr ]     |
			--|---------------------------------------------------------
			--| If the feature inherits from one routine that has no   |
			--| precondition, the precondition for this routine will   |
			--| always be true and thus will not be generated by the   |
			--| compiler. So, we do not count the preconditions if one |
			--| of the inherited routines has an empty precondition    |
			--| clause.                                                |
			--|---------------------------------------------------------
		local
			loc_assert_id_set		: ASSERT_ID_SET
			inh_assert_info			: INH_ASSERT_INFO
			i						: INTEGER
			l_body: like body			
		do
				-- Get the number of breakpoint slots in the body + rescue +
				-- inner preconditions and inner postconditions
			l_body := body
			if l_body /= Void then
					-- May be Void in case of Invariant_feature_i
				Result := l_body.number_of_breakpoint_slots
			end				

				-- Add the number of breakpoint slots for inherited
				-- pre & postconditions.
			loc_assert_id_set := assert_id_set
			if loc_assert_id_set /= Void then
				from
					i := 1
				until
					i > loc_assert_id_set.count
				loop
					inh_assert_info := loc_assert_id_set @ i
					if loc_assert_id_set.has_precondition then
						Result := Result + inh_assert_info.precondition_count
					end
					Result := Result + inh_assert_info.postcondition_count
					i := i + 1
				end

					-- If the inherited assertions does not define a precondition,
					-- the precondition will be true and thus no precondition
					-- clause will be generated at all, so we have to remove the
					-- inner preconditions that we have already counted
					--
					-- Note: the inner preconditions have been added by the
					-- operation "Result := body.number_of_breakpoint_slots".
				if not loc_assert_id_set.has_precondition then
					Result := Result - number_of_precondition_slots
				end
			end
		end

	number_of_all_precondition_slots: INTEGER is
			-- Number of precondition slots in feature (:::)
			-- It includes precondition (inner & herited).
		local
			loc_assert_id_set		: ASSERT_ID_SET
			inh_assert_info			: INH_ASSERT_INFO
			i						: INTEGER
		do
			Result := number_of_precondition_slots

				-- Add the number of breakpoint slots for inherited
				-- preconditions.
			loc_assert_id_set := assert_id_set
			if loc_assert_id_set /= Void then
				from
					i := 1
				until
					i > loc_assert_id_set.count
				loop
					inh_assert_info := loc_assert_id_set @ i
					if loc_assert_id_set.has_precondition then
						Result := Result + inh_assert_info.precondition_count
					end
					i := i + 1
				end
					-- If the inherited assertions does not define a precondition,
					-- the precondition will be true and thus no precondition
					-- clause will be generated at all, so we have to remove the
					-- inner preconditions that we have already counted
					--
					-- Note: the inner preconditions have been added by the
					-- operation "Result := number_of_precondition_slots".
				if not loc_assert_id_set.has_precondition then
					Result := Result - number_of_precondition_slots
				end
			end
		end

	number_of_precondition_slots: INTEGER is 
			-- Number of preconditions
			-- (inherited assertions are not taken into account)
		local
			l_body: like body
		do
			l_body := body
			if l_body /= Void then
				Result := l_body.number_of_precondition_slots
			end
		end

	number_of_postcondition_slots: INTEGER is 
			-- Number of postconditions
			-- (inherited assertions are not taken into account)
		local
			l_body: like body
		do
			l_body := body
			if l_body /= Void then
				Result := l_body.number_of_postcondition_slots
			end
		end

feature -- Status

	to_melt_in (a_class: CLASS_C): BOOLEAN is
			-- Has current feature to be melted in class `a_class' ?
		require
			good_argument: a_class /= Void
		do
			Result := a_class.class_id = written_in
		end

	to_generate_in (a_class: CLASS_C): BOOLEAN is
			-- Has current feature to be generated in class `a_class' ?
		require
			good_argument: a_class /= Void
		do
			Result := a_class.class_id = written_in
		end

	frozen to_implement_in (a_class: CLASS_C): BOOLEAN is
			-- Does Current feature need to be exposed in interface 
			-- used for IL generation?
		require
			a_class_not_void: a_class /= Void
		do
			Result := a_class.class_id = written_in
		end

feature -- Setting

	set_feature_id (i: INTEGER) is
			-- Assign `i' to `feature_id'
		do
			feature_id := i
		end

	set_body_index (i: INTEGER) is
			-- Assign `i' to `body_index'.
		do
			body_index := i
		end

	set_pattern_id (i: INTEGER) is
			-- Assign `i' to `pattern_id'.
		do
			pattern_id := i
		end

	set_feature_name, set_renamed_name (s: STRING) is
			-- Assign `s' to `feature_name'.
			-- `set_renamed_name' is needed for C external
			-- routines that can't be renamed.
		require
			s_not_void: s /= Void
			s_not_empty: not s.is_empty
		local
			l_names_heap: like Names_heap
		do
			l_names_heap := Names_heap
			l_names_heap.put (s)
			feature_name_id := l_names_heap.found_item
		ensure
			feature_name_set: equal (feature_name, s)
		end

	set_feature_name_id, set_renamed_name_id (id: INTEGER) is
			-- Assign `id' to `feature_name_id'.
		require
			valid_id: Names_heap.valid_index (id)
		do
			feature_name_id := id
		ensure
			feature_name_id_set: feature_name_id = id
		end

	set_written_in (a_class_id: like written_in) is
			-- Assign `a_class_id' to `written_in'.
		require
			a_class_id_not_void: a_class_id > 0
		do
			written_in := a_class_id
		ensure
			written_in_set: written_in = a_class_id
		end

	set_written_feature_id (a_feature_id: like written_feature_id) is
			-- Assign `a_feature_id' to `written_feature_id'.
		require
			valid_feature_id: a_feature_id >= 0
		do
			written_feature_id := a_feature_id
		ensure
			written_feature_id_set: written_feature_id = a_feature_id
		end

	set_origin_feature_id (a_feature_id: like origin_feature_id) is
			-- Assign `a_feature_id' to `origin_feature_id'.
		require
			valid_feature_id: a_feature_id >= 0
		do
			origin_feature_id := a_feature_id
		ensure
			origin_feature_id_set: origin_feature_id = a_feature_id
		end

	set_origin_class_id (a_class_id: like origin_class_id) is
			-- Assign `a_class_id' to `origin_class_id'.
		require
			valid_feature_id: a_class_id >= 0
		do
			origin_class_id := a_class_id
		ensure
			origin_class_id_set: origin_class_id = a_class_id
		end

	set_export_status (e: EXPORT_I) is
			-- Assign `e' to `export_status'.
		do
			export_status := e
		ensure
			export_status_set: export_status = e
		end

	frozen set_is_origin (b: BOOLEAN) is
			-- Assign `b' to `is_origin'.
		do
			feature_flags := feature_flags.set_bit_with_mask (b, is_origin_mask)
		ensure
			is_origin_set: is_origin = b
		end

	frozen set_is_empty (b : BOOLEAN) is
			-- Set `is_empty' to `b'
		do
			feature_flags := feature_flags.set_bit_with_mask (b, is_empty_mask)
		ensure
			is_empty_set: is_empty = b
		end

	frozen set_is_frozen (b: BOOLEAN) is
			-- Assign `b' to `is_frozen'.
			--|Note: nothing to do with melted/frozen features
		do
			feature_flags := feature_flags.set_bit_with_mask (b, is_frozen_mask)
		ensure
			is_frozen_set: is_frozen = b
		end

	frozen set_is_infix (b: BOOLEAN) is
			-- Assign `b' to `is_infix'. 
		do
			feature_flags := feature_flags.set_bit_with_mask (b, is_infix_mask)
		ensure
			is_infix_set: is_infix = b
		end

	frozen set_is_prefix (b: BOOLEAN) is
			-- Assign `b' to `is_prefix'.
		do
			feature_flags := feature_flags.set_bit_with_mask (b, is_prefix_mask)
		ensure
			is_prefix_set: is_prefix = b
		end

	frozen set_is_require_else (b: BOOLEAN) is
			-- Assign `b' to `is_require_else'.
		do
			feature_flags := feature_flags.set_bit_with_mask (b, is_require_else_mask)
		ensure
			is_require_else_set: is_require_else = b
		end

	frozen set_is_ensure_then (b: BOOLEAN) is
			-- Assign `b' to `is_ensure_then'.
		do
			feature_flags := feature_flags.set_bit_with_mask (b, is_ensure_then_mask)
		ensure
			is_ensure_then_set: is_ensure_then = b
		end

	set_is_selected (b: BOOLEAN) is
			-- Assign `b' to `is_selected'.
		do
			-- FIXME: Manu 11/21/2001
			-- Not used currently used
			-- is_selected := b
		end

	set_rout_id_set (set: like rout_id_set) is
			-- Assign `set' to `rout_id_set'.
		do
			rout_id_set := set
		end

	set_private_external_name_id (n_id: like private_external_name_id) is
			-- Assign `n_id' to `private_external_name_id'.
		require
			valid_n: n_id > 0
		do
			private_external_name_id := n_id
		ensure
			private_external_name_set: private_external_name_id = n_id
		end

	generation_class_id: INTEGER is
			-- Id of class where feature has to be generated in
		do
			Result := written_in
		end

	duplicate: like Current is
			-- Clone
		do
			Result := twin
		end

	duplicate_arguments is
			-- Do a clone of arguments (for replication)
		do
			-- Do nothing
		end

feature -- Incrementality

	equiv (other: FEATURE_I): BOOLEAN is
			-- Incrementality test on instance of FEATURE_I during
			-- second pass.
		require
			good_argument: other /= Void
		do
			Result := written_in = other.written_in
				and then is_selected = other.is_selected
				and then rout_id_set.same_as (other.rout_id_set)
				and then is_origin = other.is_origin
				and then is_frozen = other.is_frozen
				and then is_deferred = other.is_deferred
				and then is_external = other.is_external
				and then export_status.same_as (other.export_status)
				and then same_signature (other)
				and then has_precondition = other.has_precondition
				and then has_postcondition = other.has_postcondition
				and then is_once = other.is_once
debug ("ACTIVITY")
	if not Result then
			io.error.putbool (written_in = other.written_in) io.error.new_line;
			io.error.putbool (is_selected = other.is_selected) io.error.new_line;
			io.error.putbool (rout_id_set.same_as (other.rout_id_set)) io.error.new_line;
			io.error.putbool (is_origin = other.is_origin) io.error.new_line;
			io.error.putbool (is_frozen = other.is_frozen) io.error.new_line;
			io.error.putbool (is_deferred = other.is_deferred) io.error.new_line;
			io.error.putbool (is_external = other.is_external) io.error.new_line;
			io.error.putbool (export_status.same_as (other.export_status)) io.error.new_line;
			io.error.putbool (same_signature (other)) io.error.new_line;
			io.error.putbool (has_precondition = other.has_precondition) io.error.new_line;
			io.error.putbool (has_postcondition = other.has_postcondition) io.error.new_line;
			io.error.putbool (is_once = other.is_once) io.error.new_line;
	end
end
			if Result then
				if assert_id_set /= Void then
					Result := assert_id_set.same_as (other.assert_id_set)
				else
					Result := (other.assert_id_set = Void)
				end
			end

			if Result and then rout_id_set.first = System.default_rescue_id then
				-- This is the default rescue feature.
				-- Test whether emptiness of body has changed.
				Result := (is_empty = other.is_empty)
			end

			if Result and then rout_id_set.first = System.default_create_id then
				-- This is the default create feature.
				-- Test whether emptiness of body has changed.
				Result := (is_empty = other.is_empty)
			end

debug ("ACTIVITY")
	if not Result then
		io.error.putstring ("%T%T")
		io.error.putstring (feature_name)
		io.error.putstring (" is not equiv%N")
	end
end
		end

	select_table_equiv (other: FEATURE_I): BOOLEAN is
			-- Incrementality of select table
		require
			good_argumnet: other /= Void

		do
			Result := written_in = other.written_in
						and then rout_id_set.same_as (other.rout_id_set)
						and then is_origin = other.is_origin
						and then body_index = other.body_index
						and then type.is_deep_equal (other.type)
		end

	is_valid: BOOLEAN is
			-- Is feature still valid?
			-- Incrementality: The types of arguments and/or result
			-- are still defined in system
		local
			type_a: TYPE_A
		do
			type_a ?= type
			Result := type_a.is_valid
			if Result and then has_arguments then
				Result := arguments.is_valid
			end
		end

	same_class_type (other: FEATURE_I): BOOLEAN is
			-- Has `other' same resulting type than Current ?
		require
			good_argument: other /= Void
			same_names: other.feature_name_id = feature_name_id
		do
			Result := type.same_as (other.type)
		end

	same_interface (other: FEATURE_I): BOOLEAN is
			-- Has `other' same interface than Current ?
			-- [Semnatic for second pass is `old_feat.same_interface (new)']
		require
			good_argument: other /= Void
			same_names: other.feature_name_id = feature_name_id
--			export_statuses_exist: not (export_status = Void
--										or else	other.export_status = Void)
		do
				-- Still an attribute
			Result := is_attribute = other.is_attribute 

				-- Same return type
			Result := Result and then type.same_as (other.type)
--						and then export_status.equiv (other.export_status)

				-- Same arguments if any
			if Result then
				if argument_count = 0 then
					Result := other.argument_count = 0
				else
					Result := argument_count = other.argument_count
							and then arguments.same_interface (other.arguments)
				end
			end

				-- Still a once
			Result := Result and then is_once = other.is_once
		end

feature -- creation of default rescue clause

	create_default_rescue (def_resc_name : STRING) is
			-- Create default_rescue clause if necessary
		require
			valid_feature_name : def_resc_name /= Void
		local
			my_body : like body
		do
			if not (is_attribute or is_constant or 
									is_external or is_deferred) then
				my_body := body

				if (my_body /= Void) then 
					my_body.create_default_rescue (def_resc_name)
				end
			end
		end

feature -- Type id

	written_type_id (class_type: CL_TYPE_I): INTEGER is
			-- Written type id of feature in context of
			-- type `class_type'.
		do
			Result := written_type (class_type).type_id
		end

	written_type (class_type: CL_TYPE_I): CL_TYPE_I is
			-- Written type of feature in context of 
			-- type `class_type'.
		require
			good_argument: class_type /= Void
			conformance: class_type.base_class.conform_to (written_class)
		do
			Result := written_class.meta_type (class_type)
		end

feature -- Conveniences

	assert_id_set: ASSERT_ID_SET is
			-- Assertions to which procedure belongs to
			-- (To be redefined in PROCEDURE_I).
		do
			-- Do nothing
		end

	is_obsolete: BOOLEAN is
			-- Is Current feature obsolete?
		do
			Result := obsolete_message /= Void
		end

	obsolete_message: STRING is
			-- Obsolete message
			-- (Void if Current is not obsolete)
		do
			-- Do nothing
		end

	has_arguments: BOOLEAN is
			-- Has current feature some formal arguments ?
		do
			Result := arguments /= Void
		end

	is_replicated: BOOLEAN is
			-- Is Current feature conceptually replicated?
		do
			-- Do nothig
		end

	is_routine: BOOLEAN is
			-- Is current feature a routine ?
		do
			-- Do nothing
		end

	is_function: BOOLEAN is
			-- Is current feature a function ?
		do
			-- Do nothing
		end

	is_type_feature: BOOLEAN is
			-- Is current an instance of TYPE_FEATURE_I?
		do
			-- Do nothing
		end

	is_attribute: BOOLEAN is
			-- Is current feature an attribute ?
		do
			-- Do nothing
		end

	is_constant: BOOLEAN is
			-- Is current feature a constant ?
		do
			-- Do nothing
		end

	is_once: BOOLEAN is
			-- Is current feature a once one ?
		do
			-- Do nothing
		end

	is_do: BOOLEAN is
			-- Is current feature a do one ?
		do
			-- Do nothing
		end

	is_deferred: BOOLEAN is
			-- Is current feature a deferred one ?
		do
			-- Do nothing
		end

	is_unique: BOOLEAN is
			-- Is current feature a unique constant ?
		do
			-- Do nothing
		end

	is_external: BOOLEAN is
			-- Is current feature an external one ?
		do
			-- Do nothing
		end

	has_return_value: BOOLEAN is
			-- Does current return a value?
		do
			Result := is_constant or is_attribute or is_function
		ensure
			validity: Result implies (is_constant or is_attribute or is_function)
		end

	frozen is_il_external: BOOLEAN is
			-- Is current feature a C external one?
		local
			ext: IL_EXTENSION_I
			l_const: CONSTANT_I
		do
			ext ?= extension
			Result := ext /= Void
			if not Result then
				l_const ?= Current
				if l_const /= Void then
					Result := l_const.written_class.is_external
				end
			end
		ensure
			not_is_c_external: Result implies not is_c_external
		end

	frozen is_c_external: BOOLEAN is
			-- Is current feature a C external one?
		local
			ext: EXTERNAL_EXT_I
		do
			ext := extension
			Result := ext /= Void and then not ext.is_il
		ensure
			not_is_il_external: Result implies not is_il_external
		end

	has_static_access: BOOLEAN is
			-- Can Current be access in a static manner?
		local
			l_ext: IL_EXTENSION_I
		do
			Result := (is_constant and not is_once)
			if not Result then
				if System.il_generation then
					l_ext ?= extension
						 -- Static access only if it is a C external (l_ext = Void)
						 -- or if IL external does not need an object.
					Result :=
						(l_ext = Void and (is_external and is_frozen and not has_assertion)) or
						(l_ext /= Void and then not l_ext.need_current (l_ext.type))
				else
					Result := is_external and is_frozen and not has_assertion
				end
			end
		end
		
	frozen has_precondition: BOOLEAN is
			-- Is feature declaring some preconditions ?
		do
			Result := feature_flags & has_precondition_mask = has_precondition_mask
		end

	frozen has_postcondition: BOOLEAN is
			-- Is feature declaring some postconditions ?
		do
			Result := feature_flags & has_postcondition_mask = has_postcondition_mask
		end

	has_assertion: BOOLEAN is
			-- Is feature declaring some pre or post conditions ?
		do
			Result := has_postcondition or else has_precondition
		end

	frozen is_require_else: BOOLEAN is
			-- Is precondition block of feature a redefined one ?
		do
			Result := feature_flags & is_require_else_mask = is_require_else_mask
		end

	frozen is_ensure_then: BOOLEAN is
			-- Is postcondition block of feature a redefined one ?
		do
			Result := feature_flags & is_ensure_then_mask = is_ensure_then_mask
		end

	can_be_encapsulated: BOOLEAN is
			-- Is current feature a feature that can be encapsulated?
			-- Eg: attribute or constant.
		do
		end

	redefinable: BOOLEAN is
			-- Is feature redefinable ?
		do
			Result := not is_frozen
		end

	undefinable: BOOLEAN is
			-- Is feature undefinable ?
		do
			Result := redefinable
		end

	type: TYPE is
			-- Type of feature
		do
			Result := Void_type
		end

	set_type (t: TYPE) is
			-- Assign `t' to `type'.
		do
			-- Do nothing
		end

	arguments: FEAT_ARG is
			-- Argument types
		do
			-- No arguments
		end

	set_assert_id_set (set: like assert_id_set) is
			-- Assign `set' to assert_id_set.
		do
			-- Do nothing	
		end

	argument_count: INTEGER is
			-- Number of arguments of feature
		do
			if arguments /= Void then
				Result := arguments.count
			end
		end

	written_class: CLASS_C is
			-- Class where feature is written in
		require
			good_written_in: written_in /= 0
		do
			Result := System.class_of_id (written_in)
		end

feature -- Export checking

--	has_special_export: BOOLEAN is
--			-- The export status is special, i.e. feature
--			-- is not exported to all other classes.
--			-- A call to this feature must be recorded specially
--			-- in dependances for incrementality purpose:
--			-- If hierarchy changes, call may be invalid.
--		require
--			has_export_status: export_status /= Void
--		do
--			Result := not export_status.is_all
--		end

	is_exported_for (client: CLASS_C): BOOLEAN is
			-- Is current feature exported to class `client' ?
		require
			good_argument: client /= Void
			has_export_status: export_status /= Void
		do
			Result := export_status.valid_for (client)
		end

	record_suppliers (feat_depend: FEATURE_DEPENDANCE) is
			-- Record suppliers ids in `feat_depend'
		require
			good_arg: feat_depend /= Void
		local
			type_a: TYPE_A
			a_class: CLASS_C
		do
				-- Create the supplier set for the feature
			type_a ?= type
			if type_a /= Void then
				a_class := type_a.associated_class
				if a_class /= Void then
					feat_depend.add_supplier (a_class)
				end
				type_a.update_dependance (feat_depend)
			end
			if has_arguments then
				from
					arguments.start
				until
					arguments.after
				loop
					type_a ?= arguments.item
					a_class := type_a.associated_class
					if a_class /= Void then
						feat_depend.add_supplier (a_class)
					end
					arguments.forth
				end
			end
		end

	suppliers: TWO_WAY_SORTED_SET [INTEGER] is
			-- Class ids of all suppliers of feature
		require
			Tmp_depend_server.has (written_in) or else
			Depend_server.has (written_in)
		local
			class_dependance: CLASS_DEPENDANCE
		do
			if Tmp_depend_server.has (written_in) then
				class_dependance := Tmp_depend_server.item (written_in)
			else
				class_dependance := Depend_server.item (written_in)
			end
			Result := class_dependance.item (body_index).suppliers
		end

feature -- Check

	body: FEATURE_AS is
			-- Body of feature
		local
			class_ast: CLASS_AS
			bid: INTEGER
		do
			if body_index > 0 then
				bid := body_index
				if Tmp_body_server.has (bid) then
					Result := Tmp_body_server.item (bid)
				elseif Body_server.server_has (bid) then
					Result := Body_server.server_item (bid)
				end
			end
			if Result = Void then
				if Tmp_ast_server.has (written_in) then
					-- Means a degree 4 error has occurred so the
					-- best we can do is to search through the
					-- class ast and find the feature as
					class_ast := Tmp_ast_server.item (written_in)
					Result ?= class_ast.feature_with_name (feature_name)
				end
			end
		end

	type_check is
			-- Third pass on current feature
		require
			in_pass3
		do
			record_suppliers (context.supplier_ids)

			debug ("SERVER", "TYPE_CHECK")
				io.error.putstring ("feature name: ")
				io.error.putstring (feature_name)
				io.error.new_line
				io.error.putstring ("body index: ")
				io.error.putint (body_index)
				io.error.new_line
			end

				-- Make type check
			body.type_check
		end

-- Note: `require else' can be used even if feature has no
-- precursor. There is no problem to raise an error in normal case,
-- only case  where we cannot do anything is when aliases are used
-- and one name references a feature with a predecessor and not 
-- other one

-- Used to be called from `type_check':
--
--	check_assertions is
--			-- Raise an error if "require else" or "ensure then" is used
--			-- but feature has no ancestor
--		do
--		end

	check_local_names is
			-- Check conflicts between local names and feature names
			-- for an unchanged feature
		do
		end

	in_pass3: BOOLEAN is
			-- Does current feature support type check ?
		do
			Result := True
		end

feature -- IL code generation

	generate_il is
			-- Generate IL code for current feature.
		local
			byte_code: BYTE_CODE
		do
			if not is_attribute and then not is_external then
				byte_code := Byte_server.item (body_index)
				byte_context.set_byte_code (byte_code)
				byte_context.set_current_feature (Current)
				byte_code.generate_il
				byte_context.clear_all
			end
		end

	custom_attributes: BYTE_LIST [BYTE_NODE] is
			-- Custom attributes of Current if any.
		local
			byte_code: BYTE_CODE
		do
			if not is_attribute and then not is_external then
				if Byte_server.has (body_index) then
					byte_code := Byte_server.item (body_index)
					Result := byte_code.custom_attributes
				end
			end
		end

feature -- Byte code computation

	compute_byte_code (has_default_rescue: BOOLEAN) is
			-- Compute byte code for melted feature
		require
			in_pass3: in_pass3
		local
			byte_code: BYTE_CODE
		do
				-- Process byte code
			byte_code := body.byte_node
			byte_code.set_default_rescue (has_default_rescue)

				-- Put it in the temporary byte code server
			if not byte_context.old_expressions.is_empty then
				byte_code.set_old_expressions (byte_context.old_expressions)
			end
			byte_context.clear_old_expressions

			Tmp_byte_server.put (byte_code)
		end

	melt (exec: EXECUTION_UNIT) is
			-- Generate byte code for current feature
			-- [To be redefined in CONSTANT_I, ATTRIBUTE_I and in EXTERNAL_I].
		require
			good_argument: exec /= Void
		local
			byte_code: BYTE_CODE
			melted_feature: MELT_FEATURE
		do
			byte_code := Byte_server.item (body_index)

			byte_context.set_byte_code (byte_code)
			byte_context.set_current_feature (Current)

			Byte_array.clear
			byte_code.set_real_body_id (real_body_id)
			byte_code.make_byte_code (Byte_array)
			byte_context.clear_all

			melted_feature := Byte_array.melted_feature
			melted_feature.set_real_body_id (exec.real_body_id)
	
			if not System.freeze then
				Tmp_m_feature_server.put (melted_feature)
			end

			Execution_table.mark_melted (exec)
		end

feature -- Polymorphism

 	has_entry: BOOLEAN is
 			-- Has feature an associated polymorphic unit ?
 		do
 			Result := True
 		end
 
 	new_entry (rout_id: INTEGER): ENTRY is
 			-- New polymorphic unit
 		require
			rout_id_not_void: rout_id /= 0
 		do
 			if not is_attribute or not Routine_id_counter.is_attribute (rout_id) then
 				Result := new_rout_entry
 			else
 				Result := new_attr_entry
 			end
 		end
 
 	new_rout_entry: ROUT_ENTRY is
 			-- New routine unit
 		require
 			not_deferred: not is_deferred
 		do
 			create Result
 			Result.set_body_index (body_index)
 			Result.set_type_a (type.actual_type)
 			Result.set_written_in (written_in)
 			Result.set_pattern_id (pattern_id)
			Result.set_feature_id (feature_id)
 		end
 
 	new_attr_entry: ATTR_ENTRY is
 			-- New attribute unit
 		require
 			is_attribute: is_attribute
 		do
 			create Result
 			Result.set_type_a (type.actual_type)
 			Result.set_feature_id (feature_id)
 		end
 
 	poly_equiv (other: FEATURE_I): BOOLEAN is
 			-- Is `other' equivalent to Current from polymorphic table 
			-- implementation point of view ?
 		require
 			good_argument: other /= Void
 		local
 			is_attr: BOOLEAN
 		do
 			is_attr := is_attribute
 			Result := 	other.is_attribute = is_attr
 						and then
 						type.actual_type.same_as (other.type.actual_type)
 			if Result then
 				if is_attr then
 					Result := 	feature_id = other.feature_id
				else
	 				Result :=   written_in = other.written_in
 								and then body_index = other.body_index
 								and then pattern_id = other.pattern_id
 				end
 			end
 		end

feature -- Signature instantiation

	instantiate (parent_type: CL_TYPE_A) is
			-- Instantiated signature in context of `parent_type'.
		require
			good_argument: parent_type /= Void
			is_solved: type.is_solved
		local
			i, nb: INTEGER
			old_type: TYPE_A
		do
				-- Instantiation of the type
			old_type ?= type
			set_type (old_type.instantiated_in (parent_type))
				-- Instantiation of the arguments
			from
				i := 1
				nb := argument_count
			until
				i > nb
			loop
				old_type ?= arguments.i_th (i)
				arguments.put_i_th (old_type.instantiated_in (parent_type), i)
				i := i + 1
			end
		end

feature -- Signature checking
	
	check_argument_names (feat_table: FEATURE_TABLE) is
			-- Check argument names
		require
			argument_names_exists: arguments.argument_names /= Void
			written_in_class: written_in = feat_table.feat_tbl_id
				-- The feature must be written in the associated class
				-- of `feat_table'.
		local
			args: like arguments
			arg_id: INTEGER
			vreg: VREG
			vrfa: VRFA
			i, nb: INTEGER
		do
			from
				args := arguments
				i := 1
				nb := args.count
			until
				i > nb
			loop
				arg_id := args.item_id (i)
					-- Searching to find after the current item another one
					-- with the same name. 
					-- We do `i + 1' for the start index because we need to go
					-- one step further (+ 1)
				if args.argument_position_id (arg_id, i + 1) /= 0 then
						-- Two arguments with the same name
					create vreg
					vreg.set_class (written_class)
					vreg.set_feature (Current)
					vreg.set_entity_name (Names_heap.item (arg_id))
					Error_handler.insert_error (vreg)
				end
				if feat_table.has_id (arg_id) then
						-- An argument name is a feature name of the feature
						-- table.
					create vrfa
					vrfa.set_class (written_class)
					vrfa.set_feature (Current)
					vrfa.set_other_feature (feat_table.found_item)
					Error_handler.insert_error (vrfa)
				end
				i := i + 1
			end
		end

	check_types (feat_table: FEATURE_TABLE) is
			-- Check type and arguments types. The objective is
			-- to deal with anchored types and genericity. All anchored
			-- types are interpreted here and generic parameter
			-- instantiated if possible.
		require
			type /= Void
		local
			solved_type: TYPE_A
			vffd5: VFFD5
			vffd6: VFFD6
			vffd7: VFFD7
			vtug: VTUG
			vtcg1: VTCG1
		do
			if type.has_like and then is_once then
					-- We have an anchored type.
					-- Check if the feature is not a once feature
				create vffd7
				vffd7.set_class (written_class)
				vffd7.set_feature_name (feature_name)
				Error_handler.insert_error (vffd7)
			end
				-- Process an actual type for the feature interpret
				-- anchored types.
			solved_type := Result_evaluator.evaluated_type
												(type, feat_table, Current)

			check
					-- If an anchored cannot be valuated then an
					-- exection is triggered by the type evaluator.
				solved_type /= Void
			end
debug ("ACTIVITY")
	io.error.putstring ("Check types of ")
	io.error.putstring (feature_name)
	io.error.new_line
	if solved_type = Void then
		io.error.putstring ("VOID solved type!!%N")
	else
		io.error.putstring ("Solved type: ")
		io.error.putstring (solved_type.dump)
		io.error.new_line
	end
end

			if feat_table.associated_class = written_class then
					-- Check valididty of a generic class type
				if not solved_type.good_generics then
					vtug := solved_type.error_generics
					vtug.set_class (written_class)
					vtug.set_feature (Current)
					vtug.set_entity_name ("Result")
					Error_handler.insert_error (vtug)
						-- Cannot go on here ..
					Error_handler.raise_error
				end
					-- Check constrained genericity validity rule
				solved_type.reset_constraint_error_list
				solved_type.check_constraints (written_class)
				if not solved_type.constraint_error_list.is_empty then
					create vtcg1
					vtcg1.set_class (written_class)
					vtcg1.set_feature (Current)
					vtcg1.set_error_list (solved_type.constraint_error_list)
					Error_handler.insert_error (vtcg1)
				end
			end

			set_type (solved_type)
				-- Instantitate the feature type in the context of the
				-- actual type of the class associated to `feat_table'.

			if is_once and then solved_type.has_formal_generic then
					-- A once funtion cannot have a type with formal generics
				create vffd7
				vffd7.set_class (written_class)
				vffd7.set_feature_name (feature_name)
				Error_handler.insert_error (vffd7)
			end
			solved_type.check_for_obsolete_class (feat_table.associated_class)

			if 
				is_infix and then 
				((argument_count /= 1) or else (type = Void_type))
			then
					-- Infixed features should have only one argument
					-- and must have a return type.
				create vffd6
				vffd6.set_class (written_class)
				vffd6.set_feature_name (feature_name)
				Error_handler.insert_error (vffd6)
			end
			if 
				is_prefix and then 
				((argument_count /= 0) or else (type = Void_type))
			then
					-- Prefixed features shouldn't have any argument
					-- and must have a return type.
				create vffd5
				vffd5.set_class (written_class)
				vffd5.set_feature_name (feature_name)
				Error_handler.insert_error (vffd5)
			end

			if arguments /= Void then
					-- Check types of arguments
				arguments.check_types (feat_table, Current)
			end
		end

	check_expanded (class_c: CLASS_C) is
			-- Check expanded validity rules
		require
			class_c_not_void: class_c /= Void
			type /= Void
		local
			solved_type: TYPE_A
			vtec1: VTEC1
			vtec2: VTEC2
		do
debug ("CHECK_EXPANDED")
	io.error.putstring ("Check expanded of ")
	io.error.putstring (feature_name)
	io.error.new_line
end
			if class_c.class_id = written_in then
					-- Check validity of an expanded result type

					-- `set_type' has been called in `check_types' so
					-- the reverse assignment is valid.
				solved_type ?= type.actual_type
				if	solved_type.has_expanded then
					if 	solved_type.expanded_deferred then
						create vtec1
						vtec1.set_class (written_class)	
						vtec1.set_feature (Current)
						vtec1.set_entity_name (feature_name)
						Error_handler.insert_error (vtec1)
					elseif not solved_type.valid_expanded_creation (class_c) then
						create vtec2
						vtec2.set_class (written_class)	
						vtec2.set_feature (Current)
						vtec2.set_entity_name (feature_name)
						Error_handler.insert_error (vtec2)
					end
				end
				if solved_type.has_generics then
					system.expanded_checker.check_actual_type (solved_type)
				end
				if arguments /= Void then
					arguments.check_expanded (class_c, Current)
				end
			end
		end

	check_signature (old_feature: FEATURE_I) is
			-- Check signature conformance beetween Current
			-- and inherited feature in `inherit_info' from which Current
			-- is a redefinition.
		require
			good_argument: old_feature /= Void
		local
			old_type, new_type: TYPE_A
			i, arg_count: INTEGER
			old_arguments: like arguments
			current_class: CLASS_C
			vdrd51: VDRD51
			vdrd52: VDRD52
			vdrd53: VDRD53
			vdrd6: VDRD6
			vdrd7: VDRD7
			ve02: VE02
			ve02a: VE02A
		do
debug ("ACTIVITY")
	io.error.putstring ("Check signature of ")
	io.error.putstring (feature_name)
	io.error.new_line
end
			current_class := System.current_class

				-- Check if an attribute is redefined in an attribute
			if old_feature.is_attribute and then not is_attribute then
				create vdrd6
				vdrd6.init (old_feature, Current)
				Error_handler.insert_error (vdrd6)
			end

				-- Check if an effective feature is not redefined in a
				-- non-effective feature
			if (not old_feature.is_deferred) and then is_deferred then
				create vdrd7
				vdrd7.set_class (current_class)
				vdrd7.init (old_feature, Current)
				Error_handler.insert_error (vdrd7)
			end
	
				-- Initialization for like-argument types
			Argument_types.init1 (Current)
		
			old_type ?= old_feature.type	
			old_type := old_type.conformance_type.actual_type
				-- `new_type' is the actual type of the redefinition already
				-- instantiated
			new_type := type.actual_type
debug ("ACTIVITY")
	io.error.putstring ("Types:%N")
	if old_type /= Void then
		io.error.putstring ("old type:%N")
		io.error.putstring (old_type.dump)
		io.error.new_line
	end
	if new_type /= Void then
		io.error.putstring ("new type:%N")
		io.error.putstring (new_type.dump)
		io.error.new_line
	else
		io.error.putstring ("New type: VOID%Ntype:")
		io.error.putstring (type.dump)
		io.error.new_line
		io.error.putstring (type.out)
		io.error.new_line
	end
	io.error.new_line
end

			if not new_type.conform_to (old_type) then
				create vdrd51
				vdrd51.init (old_feature, Current)
				Error_handler.insert_error (vdrd51)
			elseif
				new_type.is_expanded /= old_type.is_expanded
			then
				create ve02
				ve02.init (old_feature, Current)
--				ve02.set_type (new_type)
--				ve02.set_precursor_type (old_type)
				Error_handler.insert_error (ve02)
			end

				-- Check the argument count
			if argument_count /= old_feature.argument_count then
				create vdrd52
				vdrd52.init (old_feature, Current)
				Error_handler.insert_error (vdrd52)
			else
					-- Check the argument conformance
				from
					i := 1
					arg_count := argument_count
					old_arguments := old_feature.arguments
				until
					i > arg_count
				loop
					old_type ?= old_arguments.i_th (i)
					old_type := old_type.conformance_type.actual_type
					new_type := arguments.i_th (i).actual_type
debug ("ACTIVITY")
	io.error.putstring ("Types:%N")
	if old_type /= Void then
		io.error.putstring ("old type:%N")
		io.error.putstring (old_type.dump)
		io.error.new_line
	end
	if new_type /= Void then
		io.error.putstring ("new type:%N")
		io.error.putstring (new_type.dump)
		io.error.new_line
	end
	io.error.new_line
end
					if not new_type.conform_to (old_type) then
						create vdrd53
						vdrd53.init (old_feature, Current)
						Error_handler.insert_error (vdrd53)
					elseif
						new_type.is_expanded /= old_type.is_expanded
					then
						create ve02a
						ve02a.init (old_feature, Current)
--						ve02a.set_type (new_type)
--						ve02a.set_precursor_type (old_type)
						ve02a.set_argument_number (i)
						Error_handler.insert_error (ve02a)
					end
	
					i := i + 1
				end
			end
		end

	check_same_signature (old_feature: FEATURE_I) is
			-- Check signature equality beetween Current
			-- and inherited feature in `inherit_info' from which Current
			-- is a join.
		require
			good_argument: old_feature /= Void
			is_deferred
			old_feature.is_deferred
			old_feature_is_solved: old_feature.type.is_solved
		local
			old_type, new_type: TYPE_A
			i, arg_count: INTEGER
			old_arguments: like arguments
			vdjr: VDJR
			vdjr1: VDJR1
			vdjr2: VDJR2
		do
				-- Check the result type conformance
				-- `old_type' is the instantiated inherited type in the
				-- context of the class where the join takes place:
				-- i.e the class relative to `written_in'.
			old_type ?= old_feature.type
				-- `new_type' is the actual type of the join already
				-- instantiated
			new_type ?= type
			if not new_type.is_deep_equal (old_type) then
				create vdjr1
				vdjr1.init (old_feature, Current)
				vdjr1.set_type (new_type)
				vdjr1.set_old_type (old_type)
				Error_handler.insert_error (vdjr1)
			end

				-- Check the argument count
			if argument_count /= old_feature.argument_count then
				create vdjr
				vdjr.init (old_feature, Current)
				Error_handler.insert_error (vdjr)
			else
	
					-- Check the argument equality
				from
					i := 1
					arg_count := argument_count
					old_arguments := old_feature.arguments
				until
					i > arg_count
				loop
					old_type ?= old_arguments.i_th (i)
					new_type ?= arguments.i_th (i)
					if not new_type.is_deep_equal (old_type) then
						create vdjr2
						vdjr2.init (old_feature, Current)
						vdjr2.set_type (new_type)
						vdjr2.set_old_type (old_type)
						vdjr2.set_argument_number (i)
						Error_handler.insert_error (vdjr2)
					end
					i := i + 1
				end
			end
		end

	has_same_il_signature (a_parent_type, a_written_type: CL_TYPE_A; old_feature: FEATURE_I): BOOLEAN is
			-- Is current feature defined in `a_written_type' same as `old_feature'
			-- defined in `a_parent_type'?
		require
			a_parent_type_not_void: a_parent_type /= Void
			a_written_type_not_void: a_written_type /= Void
			old_feature_not_void: old_feature /= Void
			il_generation: System.il_generation
		local
			old_type, new_type: TYPE_A
			i, arg_count, id: INTEGER
			old_arguments: like arguments
		do
				-- Initialization for like-argument types
			Argument_types.init1 (Current)
	
			id := a_written_type.class_id
			old_type ?= old_feature.type	
			old_type := old_type.conformance_type.
				instantiation_in (a_written_type, a_written_type.class_id).actual_type

			new_type := type.actual_type

				-- Check exact match of signature for IL generation.
			Result := old_type.same_as (new_type)

				-- Check the argument conformance
			from
				i := 1
				arg_count := argument_count
				old_arguments := old_feature.arguments
			until
				i > arg_count
			loop
				old_type ?= old_arguments.i_th (i)
				old_type := old_type.conformance_type.
					instantiation_in (a_written_type, a_written_type.class_id).actual_type

				new_type := arguments.i_th (i).actual_type
					-- Check exact match of signature for IL generation.
				Result := Result and then old_type.same_as (new_type)

				i := i + 1
			end
		end

	solve_types (feat_tbl: FEATURE_TABLE) is
			-- Evaluates signature types in context of `feat_tbl'.
			-- | Take care of possible anchored types
		do
			set_type
				(Result_evaluator.evaluated_type (type, feat_tbl, Current))
			if arguments /= Void then
				arguments.solve_types (feat_tbl, Current)
			end
		end

	same_signature (other: FEATURE_I): BOOLEAN is
			-- Has `other' same signature than Current ?
		require
			good_argument: other /= Void
			same_feature_names: feature_name_id = other.feature_name_id
		local
			i, nb: INTEGER
		do
			Result := type.is_deep_equal (other.type)
			from
				nb := argument_count
				Result := Result and then nb = other.argument_count
				nb := argument_count
				i := 1
			until
				i > nb or else not Result
			loop
				Result := arguments.i_th (i).is_deep_equal (other.arguments.i_th (i))
				i := i + 1
			end
		end

	argument_position (arg_id: ID_AS): INTEGER is
			-- Position of argument `arg_id' in list of arguments
			-- of current feature. 0 if none or not found.
		require
			arg_id /= Void
		do
			if arguments /= Void then
				Result := arguments.argument_position (arg_id, 1)
			end
		end

	has_argument_name (arg_id: INTEGER): BOOLEAN is
			-- Has current feature an argument named `arg_id" ?
		require
			arg_id /= Void
		do
			if arguments /= Void then
				Result := arguments.argument_position_id (arg_id, 1) /= 0
			end
		end

feature -- Undefinition

	new_deferred: DEF_PROC_I is
			-- New deferred feature for undefinition
		require
			not is_deferred
			redefinable
		local
			ext: EXTERNAL_I
		do
			if is_function then
				create {DEF_FUNC_I} Result
			else
				create Result
			end
			Result.set_type (type)
			Result.set_arguments (arguments)
			Result.set_written_in (written_in)
			Result.set_origin_feature_id (origin_feature_id)
			Result.set_origin_class_id (origin_class_id)
			Result.set_rout_id_set (rout_id_set)
			Result.set_assert_id_set (assert_id_set)
			Result.set_is_selected (is_selected)
			Result.set_is_infix (is_infix)
			Result.set_is_prefix (is_prefix)
			Result.set_is_frozen (is_frozen)
			Result.set_feature_name_id (feature_name_id)
			Result.set_feature_id (feature_id)
			Result.set_pattern_id (pattern_id)
			Result.set_is_require_else (is_require_else)
			Result.set_is_ensure_then (is_ensure_then)
			Result.set_export_status (export_status)
			Result.set_body_index (body_index)
			Result.set_has_postcondition (has_postcondition)
			Result.set_has_precondition (has_precondition)

			if is_external then
				ext ?= Current
				if ext.extension.is_il then
					Result.set_extension (ext.extension)
				end
			end
		ensure
			Result_exists: Result /= Void
			Result_is_deferred: Result.is_deferred
		end

	new_rout_id: INTEGER is
			-- New routine id
		do
			Result := Routine_id_counter.next_rout_id
		end

	Routine_id_counter: ROUTINE_COUNTER is
			-- Routine id counter
		once
			Result := System.routine_id_counter
		end

feature -- Replication

	code_id: INTEGER is
			-- Code id for inheritance analysis
		do
			Result := body_index
		end

	set_code_id (i: INTEGER) is
			-- Assign `i' to code_id.
		do
			-- Do nothing
		end

	access_in: INTEGER is
			-- Id of class where current feature can be accessed
			-- through its routine id
			-- Useful for replication
		do
			Result := written_in
		end

	replicated: FEATURE_I is
			-- Replicated feature
		deferred
		ensure
			Result /= Void
		end

	new_code_id: INTEGER is
			-- New code id
		do
			Result := System.body_index_counter.next_id
		end

	unselected (in: INTEGER): FEATURE_I is
			-- Unselected feature
		require
			in_not_void: in /= 0
		deferred
		ensure
			Result_exists: Result /= Void
		end

	is_unselected: BOOLEAN is
			-- Is current feature an unselected one ?
		do
			-- Do nothing
		end

	transfer_to (other: FEATURE_I) is
			-- Transfer of datas from Current into `other'.
		require
			other_exists: other /= Void
		do
			other.set_body_index (body_index)
			other.set_export_status (export_status)
			other.set_feature_id (feature_id)
			other.set_feature_name_id (feature_name_id)
			other.set_is_frozen (is_frozen)
			other.set_is_infix (is_infix)
			other.set_is_prefix (is_prefix)
			other.set_is_selected (is_selected)
			other.set_pattern_id (pattern_id)
			other.set_rout_id_set (rout_id_set)
			other.set_written_in (written_in)
			other.set_written_feature_id (written_feature_id)
			other.set_is_origin (is_origin)
			other.set_origin_feature_id (origin_feature_id)
			other.set_origin_class_id (origin_class_id)
		end

feature -- Genericity

	update_instantiator2 (a_class: CLASS_C) is
			-- Look for generic/expanded types in result and arguments in order
			-- to update instantiator.
		require
			good_argument: a_class /= Void
			good_context: a_class.changed
		local
			i, arg_count: INTEGER
		do
			Instantiator.dispatch (type.actual_type, a_class)
			from
				i := 1
				arg_count := argument_count
			until
				i > arg_count
			loop	
				Instantiator.dispatch (arguments.i_th (i).actual_type, a_class)
				i := i + 1
			end
		end

feature -- Pattern

	pattern: PATTERN is
			-- Feature pattern
		do
			create Result.make (type.actual_type.meta_type)
			if argument_count > 0 then
				Result.set_argument_types (arguments.pattern_types)
			end
		end

	process_pattern is
			-- Process pattern of Current feature
		local
			p: PATTERN_TABLE
		do
			p := Pattern_table
			p.insert (generation_class_id, pattern)
			pattern_id := p.last_pattern_id
		end
			
feature -- Dead code removal

	used: BOOLEAN is
			-- Is feature used ?
		do
					-- In final mode dead code removal process is on.
					-- In workbench mode all features are considered
					-- used.
			Result := 	byte_context.workbench_mode 
						or else
						System.is_used (Current)
		end

feature -- Byte code access

	frozen access (access_type: TYPE_I): ACCESS_B is
			-- Byte code access for current feature
		require
			access_type_not_void: access_type /= Void
		do
			Result := access_for_feature (access_type, Void)
		ensure
			Result_exists: Result /= Void
		end

	access_for_feature (access_type: TYPE_I; static_type: CL_TYPE_I): ACCESS_B is
			-- Byte code access for current feature. Dynamic binding if
			-- `static_type' is Void, otherwise static binding on `static_type'.
		require
			access_type_not_void: access_type /= Void
		do
			if System.il_generation and then written_in = System.any_id then
					-- Feature written in ANY in IL code generation.
				create {ANY_FEATURE_B} Result.make (Current, access_type, static_type)
			else
				create {FEATURE_B} Result.make (Current, access_type, static_type)
			end
		ensure
			Result_exists: Result /= Void
		end

feature {NONE} -- log file

	add_in_log (class_type: CLASS_TYPE; encoded_name: STRING) is
		do
			System.used_features_log_file.add (class_type, feature_name, encoded_name)
		end

feature -- C code generation

	generate (class_type: CLASS_TYPE; buffer: GENERATION_BUFFER) is
			-- Generate feature written in `class_type' in `buffer'.
		require
			valid_buffer: buffer /= Void
			written_in_type: class_type.associated_class.class_id = generation_class_id
			not_deferred: not is_deferred
		local
			byte_code: BYTE_CODE
			tmp_body_index: INTEGER
		do
			if used then
					-- `generate' from BYTE_CODE will log the feature name
					-- and encoded name in `used_features_log_file' from SYSTEM_I
				generate_header (buffer)

				tmp_body_index := body_index
				if Tmp_opt_byte_server.has (tmp_body_index) then
					byte_code := Tmp_opt_byte_server.disk_item (tmp_body_index)
				else
					byte_code := Byte_server.disk_item (tmp_body_index)
				end

					-- Generation of C code for an Eiffel feature written in
					-- the associated class of the current type.
				byte_context.set_byte_code (byte_code)

				if System.in_final_mode and then System.inlining_on then
					byte_code := byte_code.inlined_byte_code
				end

					-- Generation of the C routine
				byte_context.set_current_feature (Current)
				byte_code.analyze
				byte_code.set_real_body_id (real_body_id)
				byte_code.generate
				byte_context.clear_all

			else
				System.removed_log_file.add (class_type, feature_name)
			end
		end

	generate_header (buffer: GENERATION_BUFFER) is
			-- Generate a header before body of feature
		require
			valid_buffer: buffer /= Void
		do
			buffer.putstring ("/* ")
			buffer.putstring (feature_name)
			buffer.putstring (" */%N%N")
		end

feature -- Debug purpose

	trace is
			-- Debug purpose
		do
			io.error.putstring ("feature name: ")
			io.error.putstring (feature_name)
			io.error.putchar (' ')
			rout_id_set.trace
			io.error.putstring (" {")
			io.error.putstring ("fid = ")
			io.error.putint (feature_id)
			io.error.putstring ("}");
			io.error.putstring (" {")
			io.error.putstring ("body_index = ")
			io.error.putint (body_index)
			io.error.putstring ("}");
			io.error.putstring (" {")
			io.error.putstring ("written in = ")
			io.error.putstring (written_class.name)
			io.error.putstring ("}");
			io.error.putstring (" {")
			io.error.putstring ("body_index = ")
			if body_index > 0 then
				io.error.putint (body_index)
			else
				io.error.putint (0)
			end
			io.error.new_line
		end

feature -- Debugging

	is_debuggable: BOOLEAN is
		local
			wc: CLASS_C
		do
			if (not is_external)
				and then (not is_attribute)
				and then (not is_constant)
				and then (not is_deferred)
				and then (not is_unique)
			then
				wc := written_class
				Result := (not wc.is_basic)
					and then (not wc.is_special)
					and then (wc.has_types)
			end
		end

	real_body_id: INTEGER is
			-- Real body id at compilation time. This id might be
			-- obsolete after supermelting this feature.
			--| In latter case, new real body id is kept
			--| in DEBUGGABLE objects.
		require
			valid_body_id: valid_body_id
		local
			exec_unit: EXECUTION_UNIT
			class_type: CLASS_TYPE
			old_cluster: CLUSTER_I
		do
			old_cluster := Inst_context.cluster
			Inst_context.set_cluster (written_class.cluster)
			class_type := written_class.types.first

				-- Search for associated EXECUTION_UNIT
			create exec_unit.make (class_type)
			exec_unit.set_body_index (body_index)
			Execution_table.search (exec_unit)
			exec_unit := Execution_table.last_unit

			Result := exec_unit.real_body_id
			Inst_context.set_cluster (old_cluster)
		end

	valid_body_id: BOOLEAN is
			-- Use of this routine as precondition for real_body_id.
		do
			Result := ((not is_attribute)
						and then (not is_constant)
						and then (not is_deferred)
						and then (not is_unique)
						and then written_class.has_types)
				or else
					(is_constant and is_once)
		end

feature -- Api creation

	e_feature: E_FEATURE is
		do
			Result := api_feature (written_in)
		end

	api_feature (a_class_id: INTEGER): E_FEATURE is
			-- API representation of Current
		require
			a_class_id_positive: a_class_id > 0
		do
			Result := new_api_feature
			Result.set_written_in (written_in)
			Result.set_associated_class_id (a_class_id)
			Result.set_body_index (body_index)
			Result.set_is_origin (is_origin)
			Result.set_export_status (export_status)
			Result.set_is_frozen (is_frozen)
			Result.set_is_infix (is_infix)
			Result.set_is_prefix (is_prefix)
			Result.set_rout_id_set (rout_id_set)
		end		

feature {NONE} -- Implementation

	new_api_feature: E_FEATURE is
			-- API feature creation
		deferred
		ensure
			non_void_result: Result /= Void
		end

	feature_flags: INTEGER_16
			-- Property of Current feature, i.e. frozen,
			-- infix, origin, prefix, selected.

	is_frozen_mask: INTEGER_16 is 0x0001
	is_origin_mask: INTEGER_16 is 0x0002
	is_empty_mask: INTEGER_16 is 0x0004
	is_infix_mask: INTEGER_16 is 0x0008
	is_prefix_mask: INTEGER_16 is 0x0010
	is_require_else_mask: INTEGER_16 is 0x0020
	is_ensure_then_mask: INTEGER_16 is 0x0040
	has_precondition_mask: INTEGER_16 is 0x0080
	has_postcondition_mask: INTEGER_16 is 0x0100
			-- Mask used for each feature property.

feature {INHERIT_TABLE} -- Access

	private_external_name_id: INTEGER
			-- External name id of feature if any in IL generation.

	private_external_name: STRING is
			-- External name of feature if any in IL generation.
		require
			valid_private_external_name_id: private_external_name_id > 0
		do
			Result := Names_heap.item (private_external_name_id)
		ensure
			Result_not_void: Result /= Void
			Result_not_empty: not Result.is_empty
		end

feature {NONE} -- Debug output

	debug_output: STRING is
			-- Textual representation of current feature for debugging.
		do
			Result := feature_name 
			if Result = Void then
				Result := "Name not yet assigned"
			end
		end

end
