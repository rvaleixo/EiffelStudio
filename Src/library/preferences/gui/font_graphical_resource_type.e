indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FONT_GRAPHICAL_RESOURCE_TYPE

inherit
	GRAPHICAL_RESOURCE_TYPE

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize `Current'.
		do
			
		end

feature -- Access

	edition_box (caller: PREFERENCE_WINDOW): FONT_SELECTION_BOX is
			-- Widget that lets the user edit resources.
		do
			create Result.make (caller)
		end

	xml_name: STRING is "FONT"
	
	registry_name: STRING is "EIFFON"
	
	load_resource (n, v: STRING): FONT_RESOURCE is
			-- Load a resource from its string representation.
		do
			create Result.make (n, v, Current)
		end

end -- class FONT_GRAPHICAL_RESOURCE_TYPE
