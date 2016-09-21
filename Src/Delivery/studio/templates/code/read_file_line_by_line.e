class  TEMPLATE_READ_FILE_GLOBAL

inherit
	
	TEMPLATE 
	
feature

	read_file_line_by_line
			-- Show how to read a file line by line., for binary files you can use {RAW_FILE}. 
		note
			title: "Read a file line by line"
			tags: "Algorithm, Read, Files, Path"
		local
			l_file: FILE
			l_path: PATH
		do
			create l_path.make_current
			create {PLAIN_TEXT_FILE} l_file.make_with_path (L_path)
			if l_file.exists and then l_file.is_readable then
				l_file.open_read
				from
				until
					l_file.end_of_file
				loop
					l_file.read_line
					print (l_file.last_string)
					io.put_new_line
				end
				l_file.close
			else
				io.error.put_string ("Could not read, the file:[" + l_path.name + " ] does not exist")
				io.put_new_line
			end
		end
end
