class USED_FEAT_LOG_FILE

inherit
	PLAIN_TEXT_FILE

creation
	make

feature

	add (class_type: CLASS_TYPE; feature_name, encoded_name: STRING) is
		do
			putstring (class_type.associated_class.cluster.cluster_name);
			putchar ('%T');
			class_type.type.dump (Current);
			putchar ('%T');
			putstring (feature_name);
			putchar ('%T');
			putstring (encoded_name);
			putstring (class_type.relative_file_name);
			new_line;
		end

end

