note
	legal: "See notice at end of class."
	status: "See notice at end of class."
class ARRAY_OPTIMIZER

inherit
	FEAT_ITERATOR
		redefine
			make
		end

	SHARED_INST_CONTEXT

	SHARED_BYTE_CONTEXT

	SHARED_TABLE

	SHARED_GENERATION

	COMPILER_EXPORTER

	SHARED_NAMES_HEAP
		export
			{NONE} all
		end

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make

feature {NONE} -- Creation

	make
		local
			nb: INTEGER
		do
			array_optimization_on := System.array_optimization_on
			create optimized_features.make (300)
			nb := System.body_index_counter.count
			create marked_table.make_filled (Void, 1, nb)
			create unsafe_body_indexes.make (nb)
			Precursor {FEAT_ITERATOR}
			create context_stack.make
		end

feature

	record_array_descendants
		local
			array_class: CLASS_C
			ftable: FEATURE_TABLE
			l_names_heap: like Names_heap
			l_feat: FEATURE_I
		do
			array_class := System.array_class.compiled_class

			ftable := array_class.feature_table
			l_names_heap := Names_heap

				-- get the rout_ids of the special/unsafe features
			put_rout_id := ftable.item_id ({PREDEFINED_NAMES}.put_name_id).rout_id_set.first
			item_rout_id := ftable.item_id ({PREDEFINED_NAMES}.item_name_id).rout_id_set.first
			lower_rout_id := ftable.item_id ({PREDEFINED_NAMES}.lower_name_id).rout_id_set.first
			area_rout_id := ftable.item_id ({PREDEFINED_NAMES}.area_name_id).rout_id_set.first
			l_feat := ftable.item_id ({PREDEFINED_NAMES}.at_name_id)
			if l_feat = Void then
					-- We must be compiling an old version of the ARRAY class, so look for `infix "@"' instead.
				l_feat := ftable.item_id ({PREDEFINED_NAMES}.infix_at_name_id)
			end
			check l_feat_not_void: l_feat /= Void end
			infix_at_rout_id := l_feat.rout_id_set.first

			create array_descendants.make (10)

			create special_features.make
			special_features.compare_objects

			create lower_and_area_features.make
			lower_and_area_features.compare_objects

				-- Record descendants of ARRAY and some of the special features
			record_descendants (array_class)

				-- Record the rest of the unsafe features
			record_unsafe_features
		end

feature

	special_features: TWO_WAY_SORTED_SET [DEPEND_UNIT]
			-- Set of all the special features
			-- A set is used so that we can use the basic intersection
			-- with the FEATURE_DEPENDANCE

feature {NONE} -- Array optimization

	array_optimization_on: BOOLEAN

	put_rout_id, item_rout_id, infix_at_rout_id: INTEGER
	lower_rout_id, area_rout_id: INTEGER
			-- rout_ids of the special/unsafe features

	array_descendants: ARRAYED_LIST [CLASS_C]
			-- Descendants of ARRAY

	lower_and_area_features: TWO_WAY_SORTED_SET [DEPEND_UNIT]
			-- Set of all the features `lower' and `area' from ARRAY
			-- and descendants

	record_unsafe_features
		local
			a_class: CLASS_C
			ftable: FEATURE_TABLE
			a_feature: FEATURE_I
			class_depend: CLASS_DEPENDANCE
			depend_list: FEATURE_DEPENDANCE
			byte_code: BYTE_CODE
			dep: DEPEND_UNIT
			lower, area: FEATURE_I
			body_index: INTEGER
		do
				-- Callers of area, lower with assignment
			from
				array_descendants.start
			until
				array_descendants.after
			loop
				a_class := array_descendants.item
				ftable := a_class.feature_table
				class_depend := Depend_server.item (a_class.class_id)

				from
					ftable.start
				until
					ftable.after
				loop
					a_feature := ftable.item_for_iteration
					if a_feature.written_class = a_class then
						depend_list := class_depend.item (a_feature.body_index)
						if
							depend_list /= Void
						and then
							not lower_and_area_features.disjoint (depend_list)
						then
								-- Calls to `lower' or `area'
								-- See if assignment
							body_index := a_feature.body_index
							byte_code := Byte_server.item (body_index)
							if lower = Void then
									-- Optimization: get the FEATURE_Is only
									-- if the sets are not disjoint
								lower := ftable.feature_of_rout_id (lower_rout_id)
								area := ftable.feature_of_rout_id (area_rout_id)
							end
							if
								byte_code.assigns_to (lower.feature_id)
							or else
								byte_code.assigns_to (area.feature_id)
							then
								unsafe_body_indexes.put (True, body_index)
							end
						end
					end
					ftable.forth
				end
					-- Reset the `unsafe' FEATURE_Is
				lower := Void
				area := Void
				array_descendants.forth
			end

				-- record
			from
				array_descendants.start
			until
				array_descendants.after
			loop
				a_class := array_descendants.item
				ftable := a_class.feature_table
				from
					ftable.start
				until
					ftable.after
				loop
					a_feature := ftable.item_for_iteration
					if unsafe_body_indexes.item (a_feature.body_index) then
debug ("OPTIMIZATION")
	io.error.put_string ("Inserting ")
	io.error.put_string (a_feature.feature_name)
	io.error.put_string (" from ")
	io.error.put_string (a_class.name)
	io.error.put_new_line
end
						create dep.make (a_class.class_id, a_feature)
						mark_code_reachable (a_feature.body_index)
					end
					ftable.forth
				end
				array_descendants.forth
			end
				-- FIXME
				-- features from ANY (hints to stop propagation)
				-- Does it work?
			a_class := System.any_class.compiled_class
			a_feature := a_class.feature_table.item_id (Names_heap.clone_name_id)
			create dep.make (a_class.class_id, a_feature)
			unsafe_body_indexes.put (True, a_feature.body_index)
			mark_code_reachable (a_feature.body_index)
		end

	record_descendants (a_class: CLASS_C)
			-- Recursively records `a_class' and its descendants in `descendants'
		local
			d: ARRAYED_LIST [CLASS_C]
			an_id: INTEGER
			ftable: FEATURE_TABLE
			dep: DEPEND_UNIT
		do
			if not array_descendants.has (a_class) then
debug ("OPTIMIZATION")
	io.error.put_string ("Adding ")
	io.error.put_string (a_class.name)
	io.error.put_string (" as a descendant of ARRAY%N")
end
				array_descendants.extend (a_class)
				array_descendants.forth
				an_id := a_class.class_id
				ftable := a_class.feature_table

				create dep.make (an_id, ftable.feature_of_rout_id (put_rout_id))
				special_features.extend (dep)
				create dep.make (an_id, ftable.feature_of_rout_id (item_rout_id))
				special_features.extend (dep)
				create dep.make (an_id, ftable.feature_of_rout_id (infix_at_rout_id))
				special_features.extend (dep)

					-- Record `lower' and `area'
				create dep.make (an_id, ftable.feature_of_rout_id (lower_rout_id))
				lower_and_area_features.extend (dep)
				create dep.make (an_id, ftable.feature_of_rout_id (area_rout_id))
				lower_and_area_features.extend (dep)

					-- Record unsafe features
				from
					d := a_class.direct_descendants
					d.start
				until
					d.after
				loop
					record_descendants (d.item)
					d.forth
				end
			end
		end

feature

	process (a_class: CLASS_C; body_index: INTEGER; depend_list: FEATURE_DEPENDANCE)
		local
			opt_unit: OPTIMIZE_UNIT
			byte_code: BYTE_CODE
		do
			if array_optimization_on then
				create opt_unit.make (a_class.class_id, body_index)
				if
						-- The feature was marked during the type check
						-- and hasn't been processed yet
					optimization_tables.has (opt_unit)
					and then not optimized_features.has (opt_unit)
				then
						-- See if the routine really has a loop
						-- (incrementality can mess up everything) and
						-- then if the routine has a descendant of ARRAY
						-- as a local variable, an argument or Result and then
						-- calls put or item on this local/argument/Result
					byte_code := Byte_server.disk_item (body_index)
						-- `disk_item' is used because the byte code will be modified and
						-- we don't want the modified byte code to remain in the cache
					if
						byte_code.has_loop
						and then
							(byte_code.has_array_as_argument or else
					   		byte_code.has_array_as_local or else
					   		byte_code.has_array_as_result)
					then
							-- The routine calls `put' or `item' on a descendant of ARRAY
						if not special_features.disjoint (depend_list) then

								-- Initialization of the BYTE_CONTEXT
								-- => the types of the targets will be
								-- defined in calls a.f
							Context.init (a_class.types.first)
							Context.set_byte_code (byte_code)
							Inst_context.set_group (a_class.group)

							current_feature_optimized := False
							byte_code := byte_code.optimized_byte_node

							if current_feature_optimized then
									-- Mark the feature
								optimized_features.force (opt_unit)
									-- Store the new byte code
								tmp_opt_byte_server.put (byte_code)

							end

							check
								context_stack.is_empty
							end
							current_feature_optimized := False

								-- Clean byte context
							Context.array_opt_clear
						end
					end
				end
			end
		end

	optimized_features: SEARCH_TABLE [OPTIMIZE_UNIT]

	current_feature_optimized: BOOLEAN

	set_current_feature_optimized
		do
			current_feature_optimized := True
		end

feature {NONE} -- Modification

	mark_and_record (body_index: INTEGER; actual_class_id: INTEGER; written_class_id: INTEGER)
			-- Mark feature `feat' alive.
		local
			depend_list: FEATURE_DEPENDANCE
			just_born: BOOLEAN
			-- DEBUG
			a_class: CLASS_C
		do
			just_born := not is_code_reachable (body_index);
				-- Mark feature alive

DEBUG("DEAD_CODE")
	------------------------------------------
	--		DEBUG			--

	io.put_string ("MARKING: ")
	a_class := System.class_of_id (actual_class_id)
	io.put_string (a_class.feature_of_body_index (body_index).feature_name)
	io.put_string (" (bid: ")
	io.put_integer (body_index)
	io.put_string (") of ")
	io.put_string (a_class.lace_class.name)
	io.put_string (" (")
	io.put_integer (a_class.class_id)
	io.put_string (") originally in ")
	a_class := System.class_of_id (written_class_id)
	io.put_string (a_class.lace_class.name)
	io.put_string (" (")
	io.put_integer (a_class.class_id)
	io.put_string (")%N")
	------------------------------------------
end

			if just_born then
				mark_code_reachable (body_index);

					-- Take care of dependances
				depend_list := Depend_server.item (written_class_id).item (body_index)
				if depend_list /= Void then
					propagate_feature (written_class_id, body_index, depend_list);
				end
				a_class := System.class_of_id (actual_class_id)
				if a_class /= Void then
					depend_list := a_class.object_relative_once_dependances  (body_index)
					if depend_list /= Void then
						propagate_feature (written_class_id, body_index, depend_list)
					end
				end

DEBUG ("DEAD_CODE")
	io.put_string ("La depend_list contient ")
	if depend_list /= Void then
		io.put_integer (depend_list.count)
	else
		io.put_string ("aucun")
	end
	io.put_string (" elements.%N")
	io.put_string ("-----------------------------------------------------%N%N%N")
end
			end
DEBUG ("DEAD_CODE")
	if not just_born then
		io.put_string ("already alive%N")
	end
end
		end

	mark (body_index: INTEGER; static_class_id: INTEGER; original_class_id: INTEGER; rout_id_val: INTEGER)
			-- Mark feature and its redefinitions
		local
			old_position: INTEGER
			unit: ROUT_ENTRY
		do
			mark_and_record (body_index, static_class_id, original_class_id)

			if attached {ROUT_TABLE} tmp_poly_server.item (rout_id_val) as table and then table.count > 1 then
					-- If routine id available: this is not a deferred feature
					-- without any implementation
				from
					table.start
				until
					table.after
				loop
					unit := table.item
					if
						system.remover.is_class_alive (unit.class_id) and then
						System.class_of_id (unit.class_id).simple_conform_to (System.class_of_id (original_class_id))
					then
						old_position := table.position
						if not is_code_reachable (unit.body_index) then
							mark (unit.body_index, unit.class_id, unit.access_in, rout_id_val)
						end
						table.go_to (old_position)
					end
					table.forth
				end
			end
		end

	mark_treated (body_index: INTEGER; rout_id: INTEGER)
			-- record feature of body_index
		local
			tmp: ROUT_ID_SET
		do
			tmp := marked_table.item (body_index)
			if tmp = Void then
				create tmp.make
				marked_table.put (tmp, body_index)
			end
			tmp.extend (rout_id)
		end

feature {NONE} -- Status report

	is_treated (body_index: INTEGER; rout_id: INTEGER): BOOLEAN
		do
			Result := attached marked_table.item (body_index) as s and then s.has (rout_id)
		end

feature {NONE} -- State

	marked_table: ARRAY [detachable ROUT_ID_SET]
				-- table of marked rout_ids indexed by body_indexes

feature -- Contexts

	optimization_context: OPTIMIZATION_CONTEXT
			-- Current loop context
		do
			Result := context_stack.item
		end

	push_optimization_context (c: OPTIMIZATION_CONTEXT)
		do
			context_stack.put (c)
		end

	pop_optimization_context
		do
			context_stack.remove
		end

	array_item_type (id: INTEGER): TYPE_C
		local
			type_a: TYPE_A
			bc: BYTE_CODE
			array_type_a: CL_TYPE_A
			f: FEATURE_I
			formal_a: FORMAL_A
		do
			bc := context.byte_code
			if id = 0 then
					-- Result
				array_type_a ?= bc.result_type
			elseif id < 0 then
					-- local
				array_type_a ?= bc.locals.item (-id)
			else
					-- Argument
				array_type_a ?= bc.arguments.item (id)
			end
			f := array_type_a.base_class.feature_of_rout_id (item_rout_id)

			type_a ?= f.type
			type_a := type_a.instantiation_in (array_type_a, array_type_a.base_class.class_id)
								--(array_type_a, System.current_class.class_id)

			if type_a.is_formal then
				formal_a ?= type_a
				Result := Context.class_type.type.generics.i_th (formal_a.position).c_type
			else
				Result := type_a.c_type
			end
		end

	generate_plug_declarations (buffer: GENERATION_BUFFER)
		do
			generate_feature_table (buffer, "eif_lower_table", lower_rout_id)
			generate_feature_table (buffer, "eif_area_table", area_rout_id)
		end

	generate_feature_table (buffer: GENERATION_BUFFER; table_name: STRING
			rout_id: INTEGER)
		local
			entry: POLY_TABLE [ENTRY]
			temp: STRING
		do
			entry := Eiffel_table.poly_table (rout_id)
			Eiffel_table.mark_used (rout_id)
			temp := Encoder.attribute_table_name (rout_id)
			buffer.put_string ("extern long ")
			buffer.put_string (temp)
			buffer.put_string ("[];%Nlong *")
			buffer.put_string (table_name)
			buffer.put_string (" = ")
			buffer.put_string (temp)
			buffer.put_string (" - ")
			buffer.put_type_id (entry.min_type_id)
			buffer.put_string (";%N")
		end

feature {NONE} -- Contexts

	context_stack: LINKED_STACK [OPTIMIZATION_CONTEXT]

feature -- Detection of safe/unsafe features

	unsafe_body_indexes: BOOL_STRING

	test_safety (a_feature: FEATURE_I; a_class: CLASS_C)
			-- Insert the feature in the safe or unsafe set
			-- depending if it calls unsafe features
		require
			good_feature: a_feature /= Void
			good_class: a_class /= Void
		do
			if not (a_feature.is_attribute or else is_treated (a_feature.body_index, a_feature.rout_id_set.first)) then
				mark (a_feature.body_index, a_class.class_id, a_feature.written_in, a_feature.rout_id_set.first)
			end
		end

	is_safe (dep: DEPEND_UNIT): BOOLEAN
			-- Can the feature be safely called within an optimized loop?
		local
			table: ROUT_TABLE
			rout_id_val: INTEGER
			other_body_index: INTEGER
			unit: ROUT_ENTRY
			descendant_class, written_class: CLASS_C
		do
			if dep.is_external then
				Result := False
			else
				rout_id_val := dep.rout_id

				if
					not System.routine_id_counter.is_attribute (rout_id_val) and then
					Tmp_poly_server.has (rout_id_val)
				then
					written_class := System.class_of_id (dep.written_in)
					table ?= Tmp_poly_server.item (rout_id_val)
					from
						Result := True
						table.start
					until
						table.after or else not Result
					loop
						unit := table.item
						descendant_class := System.class_of_id (unit.class_id)
						if descendant_class.simple_conform_to (written_class) then
							other_body_index := unit.body_index
							Result := not unsafe_body_indexes.item (other_body_index)
						end
						table.forth
					end
				else
					Result := not unsafe_body_indexes.item (dep.body_index)
				end
			end
		end

feature {NONE} -- Detection of safe/unsafe features

	propagate_feature (written_class_id: INTEGER; original_body_index: INTEGER; depend_list: FEATURE_DEPENDANCE)
		local
			depend_unit: DEPEND_UNIT
			body_index: INTEGER
			unsafe: BOOLEAN
		do
			from
				depend_list.start
			until
				depend_list.after or else unsafe
			loop
				depend_unit := depend_list.item
				if depend_unit.is_needed_for_dead_code_removal then
					body_index := depend_unit.body_index
					if
						not (System.routine_id_counter.is_attribute (depend_unit.rout_id) or else
						is_treated (body_index, depend_unit.rout_id))
					then
						mark_treated (body_index, depend_unit.rout_id)
						mark (body_index, depend_unit.class_id, depend_unit.written_in, depend_unit.rout_id)
					end
						-- get the status ...
					if not is_safe (depend_unit) then
						unsafe := True
						unsafe_body_indexes.put (True, body_index)
					end
				end
				depend_list.forth
			end
		end

	optimization_tables: SEARCH_TABLE [OPTIMIZE_UNIT]
		do
			Result := System.optimization_tables
		end

note
	copyright:	"Copyright (c) 1984-2019, Eiffel Software"
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
