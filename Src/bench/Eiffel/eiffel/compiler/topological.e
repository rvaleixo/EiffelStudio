deferred class TOPOLOGICAL

inherit

	PART_COMPARABLE

feature

	topological_id: INTEGER is
			-- Id of topological item
		deferred
		end;

	successors: LINKED_LIST [like Current] is
			-- Successors
		deferred
		end;

end
