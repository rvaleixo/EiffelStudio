note
	description:
		"Action sequences for EV_TREE_NODE_I."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "event, action, sequence"
	date: "Generated!"
	revision: "Generated!"

deferred class
	 EV_TREE_NODE_ACTION_SEQUENCES_I


feature -- Event handling

	select_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when selected.
		do
			if attached select_actions_internal as l_result then
				Result := l_result
			else
				create Result
				select_actions_internal := Result
			end
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	select_actions_internal: detachable EV_NOTIFY_ACTION_SEQUENCE note option: stable attribute end
			-- Implementation of once per object `select_actions'.


feature -- Event handling

	deselect_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when deselected.
		do
			if attached deselect_actions_internal as l_result then
				Result := l_result
			else
				create Result
				deselect_actions_internal := Result
			end
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	deselect_actions_internal: detachable EV_NOTIFY_ACTION_SEQUENCE note option: stable attribute end
			-- Implementation of once per object `deselect_actions'.


feature -- Event handling

	expand_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when expanded.
		do
			if attached expand_actions_internal as l_result then
				Result := l_result
			else
				create Result
				expand_actions_internal := Result
			end
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	expand_actions_internal: detachable EV_NOTIFY_ACTION_SEQUENCE note option: stable attribute end
			-- Implementation of once per object `expand_actions'.


feature -- Event handling

	collapse_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when collapsed.
		do
			if attached collapse_actions_internal as l_result then
				Result := l_result
			else
				create Result
				collapse_actions_internal := Result
			end
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	collapse_actions_internal: detachable EV_NOTIFY_ACTION_SEQUENCE note option: stable attribute end;
			-- Implementation of once per object `collapse_actions'.

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




end









