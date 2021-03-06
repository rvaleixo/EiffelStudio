
--| Copyright (c) 1993-2006 University of Southern California and contributors.
--| All rights reserved.
--| Your use of this work is governed under the terms of the GNU General
--| Public License version 2.

class MANU [G]

create
	make
	
feature
	
	make (a_s: STRING a_i: INTEGER n: INTEGER)
		do
			s := a_s
			create s.make (n)
			s.fill_character ('%/0/')
			i := a_i
			$INSTRUCTION
		end
		
	statistic: FUNCTION [ANY, TUPLE [ARRAY [G]], LIST [G]]
	
	s: STRING
	
	i: INTEGER

end
