note
	description: "Summary description for {ESA_JSON_CONFIGURATION}."
	date: "$Date$"
	revision: "$Revision$"

class
	ESA_JSON_CONFIGURATION

feature

	new_database_configuration (a_path: PATH): detachable ESA_DATABASE_CONFIGURATION
			-- Build a new database configuration
		local
			l_parser: JSON_PARSER
		do
			if attached json_file_from (a_path) as json_file then
			 l_parser := new_json_parser (json_file)
			 if  attached {JSON_OBJECT} l_parser.parse as jv and then l_parser.is_parsed and then
			     attached {JSON_OBJECT}jv.item ("datasource") as l_datasource and then
			     attached {JSON_STRING}l_datasource.item ("driver") as l_driver and then
			     attached {JSON_STRING}l_datasource.item ("environment") as l_envrionment and then
			     attached {JSON_STRING}l_datasource.item ("trusted") as l_trusted and then
			     attached {JSON_OBJECT}jv.item ("environments") as l_environments and then
				 attached {JSON_OBJECT}l_environments.item (l_envrionment.item) as l_environment_selected and then
				 attached {JSON_STRING}l_environment_selected.item ("server") as l_server and then
				 attached {JSON_STRING}l_environment_selected.item ("name") as l_name then
				create Result.make (l_driver.item, l_server.unescaped_string_8, l_name.item)
				if l_trusted.item.is_boolean and then l_trusted.item.to_boolean then
					Result.mark_trusted
				end
			 end
			end
		end

	new_database_configuration_test (a_path: PATH): detachable ESA_DATABASE_CONFIGURATION
			-- Build a new database configuration
		local
			l_parser: JSON_PARSER
		do
			if attached json_file_from (a_path) as json_file then
			 l_parser := new_json_parser (json_file)
			 if  attached {JSON_OBJECT} l_parser.parse as jv and then l_parser.is_parsed and then
			     attached {JSON_OBJECT}jv.item ("datasource") as l_datasource and then
			     attached {JSON_STRING}l_datasource.item ("driver") as l_driver and then
			     attached {JSON_STRING}l_datasource.item ("environment") as l_envrionment and then
			     attached {JSON_STRING}l_datasource.item ("trusted") as l_trusted and then
			     attached {JSON_OBJECT}jv.item ("environments") as l_environments and then
				 attached {JSON_OBJECT}l_environments.item ("test") as l_environment_selected and then
				 attached {JSON_STRING}l_environment_selected.item ("server") as l_server and then
				 attached {JSON_STRING}l_environment_selected.item ("name") as l_name then
				create Result.make (l_driver.item, l_server.unescaped_string_8, l_name.item)
				if l_trusted.item.is_boolean and then l_trusted.item.to_boolean then
					Result.mark_trusted
				end
			 end
			end
		end


feature {NONE} -- JSON

	json_file_from (a_fn: PATH): detachable STRING
		do
			Result := (create {JSON_FILE_READER}).read_json_from (a_fn.name.out)
		end

	new_json_parser (a_string: STRING): JSON_PARSER
		do
			create Result.make_parser (a_string)
		end

end