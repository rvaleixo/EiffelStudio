indexing
	description:
		"Abstract description of an access to the precursor of%
		%an Eiffel feature. Version for Bench."
	date: "$Date$"
	revision: "$Revision$"

class PRECURSOR_AS

inherit
	ACCESS_AS
		redefine
			type_check, byte_node, is_equivalent
		end

	CLICKABLE_AST
		redefine
			is_precursor, associated_eiffel_class
		end

	SHARED_CONFIGURE_RESOURCES

feature {AST_FACTORY} -- Initialization

	initialize (n: like parent_name; p: like parameters) is
			-- Create a new PRECURSOR AST node.
		do
			parent_name := n
			parameters := p
			if parameters /= Void then
				parameters.start
			end
		ensure
			parent_name_set: parent_name = n
			parameters_set: parameters = p
		end

feature -- Visitor

	process (v: AST_VISITOR) is
			-- process current element.
		do
			v.process_precursor_as (Current)
		end

feature -- Attributes

	parent_name: ID_AS
			-- Optional name of the parent

	parameters: EIFFEL_LIST [EXPR_AS]
			-- List of parameters

	parameter_count: INTEGER is
			-- Number of parameters
		do
			if parameters /= Void then
				Result := parameters.count
			end
		end

	access_name: STRING is
		do
			-- Void because a Precursor call is like a client call but without
			-- a client, so there is no variable which is accessing the feature.
		end

	is_precursor: BOOLEAN is True
			-- Precursor makes reference to a class

feature -- Comparison

	is_equivalent (other: like Current): BOOLEAN is
			-- Is `other' equivalent to the current object ?
		do
			Result := equivalent (parent_name, other.parent_name) and
				equivalent (parameters, other.parameters)
		end

feature -- Stoning

	associated_eiffel_class (reference_class: CLASS_I): CLASS_I is
		do
			Result :=  Universe.class_named (parent_name, reference_class.cluster)
		end

feature -- Type check, byte code and dead code removal

	type_check is
			-- Type check a precursor call
		local
			vupr1: VUPR1
			vupr2: VUPR2
			vupr3: VUPR3
			pre_table: LINKED_LIST [PAIR[CL_TYPE_A, INTEGER]]
			feature_i: FEATURE_I
			parent_type: CL_TYPE_A
			parent_class: CLASS_C
			feat_ast: FEATURE_AS
		do
				-- Check that we're in the body of a routine (vupr1).
			if
				context.is_checking_precondition or else
				context.is_checking_postcondition or else
				context.is_checking_invariant
			then
				create vupr1
				context.init_error (vupr1)
				Error_handler.insert_error (vupr1)
					-- Cannot go on here.
				Error_handler.raise_error
			end

				--  Check that feature has a unique name (vupr1)
			feat_ast := context.current_class.feature_with_name (context.current_feature.feature_name).ast

			if feat_ast.feature_names.count > 1 then
					-- feature has multiple names.
				create vupr1
				context.init_error (vupr1)
				Error_handler.insert_error (vupr1)
					-- Cannot go on here.
				Error_handler.raise_error
			end

				-- Create table of routine ids of all parents which have 
				-- an effective precursor of the current feature.
			pre_table := precursor_table

				-- Check that current feature is a redefinition.
			if pre_table.count = 0 then
				if parent_name /= Void then
						-- The specified parent does not have
						-- an effective precursor.
					create vupr2
					context.init_error (vupr2)
					Error_handler.insert_error (vupr2)
						-- Cannot go on here.
					Error_handler.raise_error
				else
						-- No parent has an effective precursor
						-- (not a redefinition)
					create vupr3
					context.init_error (vupr3)
					Error_handler.insert_error (vupr3)
						-- Cannot go on here.
					Error_handler.raise_error
				end
			end

				-- Check that an unqualified precursor construct
				-- is not ambiguous.
			if pre_table.count > 1 then
					-- Ambiguous construct
				create vupr3
				context.init_error (vupr3)
				Error_handler.insert_error (vupr3)
					-- Cannot go on here.
				Error_handler.raise_error
			end

				-- Table has exactly one entry.
			pre_table.start
			parent_type := pre_table.item.first
			parent_class := parent_type.associated_class
			feature_i := parent_class.feature_table.feature_of_rout_id (pre_table.item.second)
			
				-- Update signature of parent `feature_i' in context of its instantiation
				-- in current class.
			feature_i := feature_i.duplicate
			feature_i.instantiate (parent_type)

				-- Update type stack.
			context.replace (access_type (parent_type, feature_i))
		end

	is_export_valid (feat: FEATURE_I): BOOLEAN is
			-- Is the call export-valid ?
		require
			good_argument: feat /= Void
		do
			Result := True      -- because it's an unqualified call
		end

	access_type (p_type: CL_TYPE_A; a_feature: FEATURE_I): TYPE_A is
			-- Type check the access to `a_feature' in `p_type'.
		local
			arg_type, l_like_arg_type: TYPE_A
			i, count: INTEGER
				-- Id of the class type on the stack
			current_item: TYPE_A
			last_type, last_constrained: TYPE_A
				-- Type onto the stack
			last_id: INTEGER
			context_count: INTEGER
				-- Id of the class correponding to `last_type'
			last_class: CLASS_C
			depend_unit: DEPEND_UNIT
			access_b: CALL_ACCESS_B
			vuar1: VUAR1
			obs_warn: OBS_FEAT_WARN
			gen_type: GEN_TYPE_A
		do
			last_type := context.item

			check
					-- No way we can have a precursor call in the
					-- context of a manifest arrays. It is always
					-- a CL_TYPE_A.
				not_multi_type: not last_type.is_multi_type
			end

			last_constrained := context.last_constrained_type
			last_class := last_constrained.associated_class

				-- Type of feature has to be evaluated in the context of current
				-- class type. That way types of return type, and parameters are
				-- correctly evaluated.
			last_id := context.current_class.class_id
			
				-- Supplier dependances update
				-- Create self-dependance
			create depend_unit.make_with_level (last_id, context.current_feature,
				context.depend_unit_level)
			context.supplier_ids.extend (depend_unit)

				-- Create dependance on precursor
			create depend_unit.make_with_level (p_type.class_id, a_feature,
			context.depend_unit_level)
			context.supplier_ids.extend (depend_unit)
			
				-- Attachments type check
			count := parameter_count
			if count /= a_feature.argument_count then
				create vuar1
				context.init_error (vuar1)
				vuar1.set_called_feature (a_feature, last_class.class_id)
				vuar1.set_argument_count (count)
				Error_handler.insert_error (vuar1)
					-- Cannot go on here: too dangerous
				Error_handler.raise_error
			elseif parameters /= Void then
					-- Type check on parameters
				parameters.type_check
					-- Conformance initialization
				Argument_types.init2 (a_feature)
				from
					i := count
					context_count := context.count - count
				until
					i < 1
				loop
						-- Extract expression type
					current_item := context.i_th (context_count + i) 

						-- Extract feature argument type
					arg_type ?= a_feature.arguments.i_th (i)

						-- Take care of anchoring to argument
					if arg_type.is_like_argument then
						l_like_arg_type := arg_type.conformance_type
						l_like_arg_type :=
							l_like_arg_type.instantiation_in (last_type, last_id).actual_type
							-- Check that `current_item' does conform to its `like argument'.
							-- Once this is done, then type checking is done on the real
							-- type of the routine, not the anchor.
						if
							not current_item.conform_to (l_like_arg_type) and then
							not current_item.convert_to (context.current_class, l_like_arg_type)
						then
							insert_vuar2_error (a_feature, last_id, i, current_item, l_like_arg_type)
						end
					end

						-- Instantiation of it in the context of
						-- the context of the target
					arg_type := arg_type.instantiation_in (last_type, last_id).actual_type

						-- Conformance: take care of constrained genericity
					if not current_item.conform_to (arg_type) then
						if current_item.convert_to (context.current_class, arg_type) then
							if parameters_convert_info = Void then
								create parameters_convert_info.make (1, count)
							end
							parameters_convert_info.put (context.last_conversion_info, i)
							if context.last_conversion_info.has_depend_unit then
								context.supplier_ids.extend (
									context.last_conversion_info.depend_unit)
							end
						elseif
							current_item.is_expanded and then arg_type.is_external and then
							current_item.is_conformant_to (arg_type)
						then
								-- No need for conversion, this is currently done at the code
								-- generation level to properly handle the generic case.
								-- If not done at the code generation, we would need the
								-- following lines.
--							if parameters_convert_info = Void then
--								create parameters_convert_info.make (1, count)
--							end
--							parameters_convert_info.put (
--								create {BOX_CONVERSION_INFO}.make (current_item), i)	
						else
							insert_vuar2_error (a_feature, last_class.class_id, i,
								current_item, arg_type)
						end
					end

						-- Insert the attachment type in the
						-- parameters line for byte code
					Attachments.insert (arg_type)
					i := i - 1
				end
			end

				-- Get the type of Current feature.
			Result ?= a_feature.type
			Result := Result.conformance_type
			context.pop (count)
			current_item := context.actual_class_type
			if Result.actual_type.is_formal then
					-- We need to evaluate the formal parameter in the context of `last_type'
					-- which knows about the current generic derivation.
				Result := Result.instantiation_in (last_type, last_id).actual_type
			else
				gen_type ?= Result.actual_type 
				if gen_type /= Void and then gen_type.has_formal then
						-- We need to evaluate the formal parameter in the context of
						-- `last_type' which knows about the current generic derivation.
					Result := Result.instantiation_in (last_type, last_id).actual_type
				else
						-- The result is clearly defined so we need to find its type in the 
						-- context of the caller of `Precursor'.
					Result := Result.instantiation_in (current_item, current_item.associated_class.class_id).actual_type
				end
			end

			if
				a_feature.is_obsolete
					-- If the obsolete call is in an obsolete class,
					-- no message is displayed
				and then not context.current_class.is_obsolete
					-- The current feature is whether the invariant or
					-- a non obsolete feature
				and then (context.current_feature = Void or else
					not context.current_feature.is_obsolete)
			then
				create obs_warn
				obs_warn.set_class (context.current_class)
				obs_warn.set_obsolete_class (context.last_class)
				obs_warn.set_obsolete_feature (a_feature)
				obs_warn.set_feature (context.current_feature)
				Error_handler.insert_warning (obs_warn)
			end

				-- Access managment
			access_b ?= a_feature.access_for_feature (Result.type_i, p_type.type_i)
			context.access_line.insert (access_b)
		end

	byte_node: ACCESS_B is
			-- Associated byte code
		local
			access_line: ACCESS_LINE
			params: BYTE_LIST [PARAMETER_B]
			l_info: CONVERSION_INFO
			p: PARAMETER_B
			i, nb: INTEGER
			l_convert_info: like parameters_convert_info
		do
			if parameters /= Void then
				from
					nb := parameters.count
					create params.make_filled (nb)
					l_convert_info := parameters_convert_info
					i := 1
				until
					i > nb
				loop
					create p
					if l_convert_info /= Void then
						l_info := l_convert_info.item (i)
					end
					if l_info /= Void then
						p.set_expression (l_info.byte_node (parameters.i_th (i).byte_node))
					else
						p.set_expression (parameters.i_th (i).byte_node)
					end
					params.put_i_th (p, i)
					i := i + 1
				end
					-- Attachment types are inserted in the reversal
					-- order in `Attachments' during type check
				from
					i := nb
				until
					i < 1
				loop
					params.i_th (i).set_attachment_type (Attachments.item.type_i)
					Attachments.forth
					i := i - 1
				end
				parameters_convert_info := Void
			end

			access_line := context.access_line
			Result := access_line.access
			Result.set_parameters (params)
			access_line.forth
		end

	Attachments: LINE [TYPE_A] is
			-- Attachement types line
		once
			Result := Context.parameters
		end

feature {NONE}  -- precursor table

	precursor_table: LINKED_LIST [PAIR[CL_TYPE_A, INTEGER]] is
				-- Table of parent types which have an effective
				-- precursor of current feature. Indexed by
				-- routine ids.
		local
			rout_id_set: ROUT_ID_SET
			rout_id: INTEGER
			parents: FIXED_LIST [CL_TYPE_A]
			a_parent: CLASS_C
			a_feature: E_FEATURE
			p_name: STRING
			spec_p_name: STRING
			p_list: HASH_TABLE [CL_TYPE_A, STRING]
			i, rc: INTEGER
			pair: PAIR [CL_TYPE_A, INTEGER]
			couple: PAIR [INTEGER, INTEGER]
			check_written_in: LINKED_LIST [PAIR [INTEGER, INTEGER]]
			r_class_i: CLASS_I
			a_cluster: CLUSTER_I
		do
			rout_id_set := context.current_feature.rout_id_set
			rc := rout_id_set.count

			if parent_name /= Void then
				-- Take class renaming into account
				a_cluster := context.current_class.cluster
				r_class_i := Universe.class_named (parent_name, a_cluster)

				if r_class_i /= Void then
					spec_p_name := r_class_i.name_in_upper
				else
					-- A class of name `parent_name' does not exist
					-- in the universe. Use an empty name to trigger
					-- an error message later.
					spec_p_name := ""
				end
			end

			from
				parents := context.current_class.parents
				create Result.make
				create check_written_in.make
				check_written_in.compare_objects
				create p_list.make (parents.count)
				parents.start
			until
				parents.after
			loop
				a_parent := parents.item.associated_class
				p_name := a_parent.name_in_upper

					-- Don't check the same parent twice.
					-- If construct is qualified, check
					-- specified parent only.
				if
					not (p_list.has (p_name) and then
					p_list.found_item.is_equivalent (parents.item)) and then
					(spec_p_name = Void or else spec_p_name.is_equal (p_name))
				then
						-- Check if parent has an effective precursor
					from
						i := 1
					until
						i > rc
					loop
						rout_id   := rout_id_set.item (i)
						a_feature := a_parent.feature_with_rout_id (rout_id)
						   
						if a_feature /= Void and then not a_feature.is_deferred  then
								-- Ok, add parent.
							create pair
							pair.set_first (parents.item)
							pair.set_second (rout_id)

							create couple
							couple.set_first (rout_id)
							couple.set_second (a_feature.written_in)

								-- Before entering the new info in `Result' we
								-- need to make sure that we do not have the same
								-- item, because if we were adding it, it will
								-- cause a VUPR3 error when it is not needed.
							if not special_has (check_written_in, couple) then
								Result.extend (pair)
								check_written_in.extend (couple)
							end

								-- Register parent
							p_list.put (parents.item, p_name)
							i := rc -- terminate loop
						end

						i := i + 1
					end
				end
				parents.forth
			end
		end

feature {AST_EIFFEL} -- Output

	simple_format (ctxt: FORMAT_CONTEXT) is
			-- Reconstitute text.
		local
			real_feature: E_FEATURE
			parent_class: CLASS_C
			current_feature: E_FEATURE
		do
			ctxt.begin

			current_feature := ctxt.global_adapt.target_enclosing_feature.api_feature (ctxt.class_c.class_id)

			if parent_name /= Void then
				parent_class := Universe.class_named (parent_name, ctxt.class_c.cluster).compiled_class
			else
				parent_class := current_feature.precursors.last
			end

			if parent_class /= Void then
				real_feature := current_feature.ancestor_version (parent_class)
			end

			if real_feature /= Void then
				ctxt.put_text_item (
					create {PRECURSOR_KEYWORD_TEXT}.make (real_feature)
				) 
			else
					-- For some reason the parent feature could not be found, so the keyword won't be pickable.
				ctxt.put_text_item (
					create {KEYWORD_TEXT}.make (Ti_precursor_keyword.image)
				)
			end

			if parent_name /= Void then
				ctxt.put_text_item (ti_space)
				ctxt.put_text_item (ti_L_curly)
				ctxt.put_class_name (parent_name)
				ctxt.put_text_item (ti_R_curly)
			end

				-- We simply use an empty feature in
				-- order to print the parameter list.
			if parameter_count > 0 then
				ctxt.prepare_for_feature ("", parameters)
				ctxt.put_current_feature
			end

			ctxt.commit
		end

feature {COMPILER_EXPORTER} -- Replication {PRECURSOR_AS, USER_CMD, CMD}

	set_parent_name (name: like parent_name) is
		require
			valid_arg: name /= Void
		do
			parent_name := name
		end

	set_parameters (p: like parameters) is
		do
			parameters := p
		end

feature {NONE} -- Implementation

	special_has (l: LINKED_LIST [PAIR [INTEGER, INTEGER]]; p: PAIR [INTEGER, INTEGER]): BOOLEAN is
			-- Does `l' contain `p'?
		require
			valid_pair: p /= Void
			valid_pair_first: p.first /= 0
			valid_pair_second: p.second /= 0
		local
			l_item: PAIR [INTEGER, INTEGER]
		do
			from
				l.start
				Result := False
			until
				l.after or Result
			loop
				l_item := l.item
				Result := l_item.first = p.first and then
								l_item.second = p.second
				l.forth
			end
		end

feature {NONE} -- Implementation: convertibility

	parameters_convert_info: ARRAY [CONVERSION_INFO]
			-- For each parameters that need a conversion call, we store info used in `byte_node'
			-- to generate conversion call

end -- class PRECURSOR_AS
