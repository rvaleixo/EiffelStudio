
class TEST
create
	make
feature
	
	make (args: ARRAY [STRING]) is
		local
			k, n, count: INTEGER
			t1: TEST1
		do
			n := args.item (1).to_integer
			count := args.item (2).to_integer
			from
				k := 1
			until
				k > count
			loop
				create s.make_filled (t1, 1, n)
				s.item (1).generate_collection
				k := k + 1
			end
		end

	s: ARRAY [TEST1]
end
