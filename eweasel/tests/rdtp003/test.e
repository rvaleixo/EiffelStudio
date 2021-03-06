indexing
	description	: "System's root class"

class
	TEST

create -- TITI
{ANY} -- TOOT
	make

feature
	t1: TUPLE [STRING, INTEGER]
	t2: TUPLE [s: STRING; i: INTEGER]
	t3: TUPLE [x1,x2,x3: STRING; y1,y2: INTEGER; z: BOOLEAN]
	t4: TUPLE []
	t5: TUPLE [x1: STRING; y1, y2: TUPLE[INTEGER, TUPLE[INTEGER]]]
	t6: TUPLE [y1, y2: TUPLE[INTEGER, TUPLE[INTEGER]]; x1: STRING]
	t7: TUPLE [y1, y2: TUPLE[z1:INTEGER; z2,z3: TUPLE[INTEGER]]; x1:TUPLE[z4,z5:INTEGER; z6,z7:STRING]]

feature -- Initialization

	button_id_mask: INTEGER
			-- Button ID mask
		once
			Result := 0b1111
		end

	test_recursive (a_dir: DIRECTORY) is
			-- Process files and directories under `a_dir'.
		require
			a_dir_not_void: a_dir /= Void
			a_dir_exists: a_dir.exists
		local
			dir_names, file_names: ARRAY [STRING]
		do
			dir_names := a_dir.directory_names
			if dir_names /= Void then
				dir_names.do_all (agent (a_path: STRING; a_dir_name: STRING)
					local
						l_dir: DIRECTORY
					do
						create l_dir.make (a_path + operating_environment.Directory_separator.out + a_dir_name)
						if l_dir.exists then
							test_recursive (l_dir)
						end
					end (a_dir.name, ?))
			end

			a_dir.open_read
			file_names := a_dir.filenames
			if file_names /= Void then
				file_names.do_all (agent (a_path: STRING; a_dir_name: STRING)
					do
						update_eiffel_class (
							a_path + operating_environment.Directory_separator.out + a_dir_name)
					end (a_dir.name, ?))
			end
		end

	make is
			-- Creation procedure.
		local
			a: ANY
		do
			print (agent io)
			print (agent io)
			print (agent io.print)
			print (agent io.print)
			print ( agent io.
				print)
			print (agent io-- TOTO
			.-- TUTU
			--TATA
			print)
			print (agent (io).print)
			print (agent (io).print)
			print ( agent ( io ).print)
			print ( -- TOTO
				agent (io)--TUTU
				.print)
			print (agent io.print ("FDSF"))
			print (agent io.print ("FDSF"))

			print (equal (toto,
				agent print))

			create a
			create a.default_create
			create a
			create a.default_create
			create a . default_create
			create a .
				-- Test
				default_create

			create {ANY} a
			create {ANY} a.default_create
			create {ANY} a
			create {ANY} a.default_create
			create {ANY} a
			create {ANY} a . default_create
			create {-- TITI
			 ANY}
			 --TUTU
			 
			a
			create {ANY}-- TOTO
			 a
			create {ANY} a
			create {ANY} a 
				-- TEst
				.
				default_create

			print (create {ANY})
			print (create {ANY})
			print (create {ANY}.default_create)
			print (create {ANY} . default_create)
			print (create {--TOTO
			ANY}--TITI
			
			--TUTU
			.
			-- TATA
			default_create)

			{ISE_RUNTIME}.generating_type (objet)
			--ttoto
			{ISE_RUNTIME}.generating_type (objet)
			{ISE_RUNTIME}.generating_type (objet)

			t2 := ["hello", 10]
			print ((equal ("hello", t2.s) and equal (10, t2.i)).out)
			io.new_line
			
			t3 := ["a", "b", "c", 1, 2, True]
			print ((equal ("a", t3.x1) and equal ("b", t3.x2) and equal ("c", t3.x3) and
					equal (1, t3.y1) and equal (2, t3.y2) and equal (True, t3.z)).out)
			io.new_line
					
			t7 := [[1, [2], [3]], [4, [5], [6]], [7, 8, "a", "b"]]
			print ((equal ([2], t7.y1.z2) and equal ([6], t7.y2.z3) and equal (8, t7.x1.z5)).out)
			io.new_line
		end

	button_id_mask: INTEGER
			-- Button ID mask
		once
			Result := 0b1111
		end

	character_mask: INTEGER is
		do
			Result := '%/123/'
		end

	test_class_cache: detachable STRING assign set_test_class
			-- Cache for `test_class'
		obsolete
			"Will be removed as soon as we do not need ES_TEST_WIZARD_CLASS_WINDOW"
		attribute
		end

end -- class TUPLE_TEST
