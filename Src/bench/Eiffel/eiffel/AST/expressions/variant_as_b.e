indexing

	description: "Description of variant loop. Version for Bench.";
	date: "$Date$";
	revision: "$Revision$"

class VARIANT_AS_B

inherit

	VARIANT_AS
		redefine
			tag, expr
		end;

	TAGGED_AS_B
		redefine
			byte_node, type_check, tag, expr
		end

feature -- Properties

	expr: EXPR_AS_B;

	tag: ID_AS_B	
	
feature

	type_check is
			-- Type check on the expression
		local
			current_context: TYPE_A;
			vave: VAVE;
		do
			expr.type_check;
				-- Check if the type of the expression is boolean
			current_context := context.item;
			if not current_context.is_integer then
				!!vave;
				context.init_error (vave);
				vave.set_type (current_context);
				Error_handler.insert_error (vave);
			end;
   
				-- Update the type stack
			context.pop (1);
		end;

	byte_node: VARIANT_B is
			-- Associated byte code
		do
			!!Result;
			Result.set_tag (tag);
			Result.set_expr (expr.byte_node);
		end;

end -- class VARIANT_AS_B
