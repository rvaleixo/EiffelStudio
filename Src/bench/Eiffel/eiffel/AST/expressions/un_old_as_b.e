class UN_OLD_AS_B

inherit

	UN_OLD_AS
		redefine
			expr
		end;

	UNARY_AS_B
		undefine
			operator_is_keyword, simple_format
		redefine
			type_check, byte_node, operator_is_keyword, format,
			replicate, fill_calls_list, expr
		end;

feature -- Property

	expr: EXPR_AS_B

feature -- Type check, byte code and dead code removal

	type_check is
			-- Type check
		local
			vaol1: VAOL1;
			vaol2: VAOL2;
			saved_vaol_check: BOOLEAN;
		do
			if not context.level1 then
					-- Old expression found somewhere else that in a
					-- postcondition
				!!vaol1;
				context.init_error (vaol1);
				Error_handler.insert_error (vaol1);
				Error_handler.raise_error;
			end;

			saved_vaol_check := context.check_for_vaol;
			if not saved_vaol_check then
					-- Set flag for vaol check.
					-- Check for an old expression within
					-- an old expression.
				context.set_check_for_vaol (True)
			end;
				-- Expression type check
			expr.type_check;

			if not saved_vaol_check then
					-- Reset flag for vaol check
				context.set_check_for_vaol (False)
			end;
			if 
				context.item.conform_to (Void_type) or else
				context.check_for_vaol
			then
					-- Not an expression
				!!vaol2;
				context.init_error (vaol2);
				Error_handler.insert_error (vaol2);
			end;
		end;

	byte_node: UN_OLD_B is
			-- Associated byte code
		local
			old_expr: EXPR_B;
		do
			!!Result;
			old_expr := expr.byte_node;
			Result.set_expr (old_expr);
			Result.add_old_expression;
		end;

	format (ctxt: FORMAT_CONTEXT_B) is
			-- Reconstitute text
		do
			ctxt.begin;
			simple_format (ctxt);
			if ctxt.last_was_printed then
				ctxt.commit;
			else
				ctxt.rollback;
			end;
		end; 
			
feature	-- Replication
	
	fill_calls_list (l: CALLS_LIST) is
			-- find calls to Current
		do
			expr.fill_calls_list (l);
		end;

	replicate (ctxt: REP_CONTEXT): like Current is
			-- Adapt to replication
		do
			Result := clone (Current);
			Result.set_expr (expr.replicate (ctxt));
		end;

end -- class UN_OLD_AS_B
