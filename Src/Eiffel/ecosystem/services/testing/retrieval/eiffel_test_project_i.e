indexing
	description: "[
		Interface managing eiffel tests defined in classes of an eiffel project.
		
		Tests are added, removed or updated depending on the project state. After every compiliation the
		interface will do this automatically by sanning the project. However one can force this action
		not only for the whole project but also for a single class within the project.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EIFFEL_TEST_PROJECT_I

inherit
	EIFFEL_TEST_COLLECTION_I
		rename
			are_tests_available as is_project_initialized
		end

feature -- Access

	project: !E_PROJECT
			-- Project containing actual eiffel classes
		require
			usable: is_interface_usable
			initialized: is_project_initialized
		deferred
		ensure
			project_initialized: Result.initialized and Result.workbench.universe_defined and
			                     Result.system_defined and then Result.universe.target /= Void
		end

	last_created_cluster: ?CONF_TEST_CLUSTER
			-- Cluster last created by calling `add_test_cluster'
		require
			usable: is_interface_usable
		deferred
		end

	last_created_class: ?EIFFEL_CLASS_I
			-- Class last created by calling `add_class'
		require
			usable: is_interface_usable
		deferred
		end

feature -- Status report

	is_project_initialized: BOOLEAN
			-- Has `Current' already received a project for which it should manage tests?
		deferred
		end

	is_updating_tests: BOOLEAN
			-- Is test list currently beeing updated?
		require
			usable: is_interface_usable
		deferred
		ensure
			result_implies_project_initialized: Result implies is_project_initialized
			result_implies_project_compiled: Result implies project.successful
		end

	is_class_in_project (a_class: !EIFFEL_CLASS_I): BOOLEAN is
			-- Does `a_class' belong to `project'?
			--
			-- `a_class': Class for which it should be determined whether it exists in `project'.
			-- `Result': True is class can be found in `project', False otherwise
		require
			usable: is_interface_usable
			project_available: is_project_initialized
		do
			Result := project.universe.class_named (a_class.name, a_class.cluster) /= Void
		end

	is_test_class (a_class: !EIFFEL_CLASS_I): BOOLEAN is
			-- Does `Current' recognize `a_class' as a valid test class?
			--
			-- `a_class': Class for which it should be determined whether it is a test class.
			-- `Result': True if `a_class' is a test class, False otherwise.
		require
			usable: is_interface_usable
			project_available: is_project_initialized
			not_updating: not is_updating_tests
		deferred
		end

	tests_for_class (a_class: !EIFFEL_CLASS_I): !DS_LINEAR [!EIFFEL_TEST_I]
			-- Returns a list containing the tests defined in the given class.
			--
			-- `a_class': Class for which a list of tests defined in the class will be returned.
			-- `Result': List of tests defined in `a_class'.
		require
			usable: is_interface_usable
			project_available: is_project_initialized
			not_updating: not is_updating_tests
			a_class_is_test_class: is_test_class (a_class)
		deferred
		end

	is_locator_registered (a_locator: !EIFFEL_TEST_CLASS_LOCATOR_I): BOOLEAN
			-- Is test class locater registered?
			--
			-- `a_locator': Locator.
			-- `Result': True if locator is registered, False otherwise.
		require
			usable: is_interface_usable
		deferred
		end

feature -- Status setting

	synchronize is
			-- Synchronize `tests' with test classes found in `project'
		require
			usable: is_interface_usable
			project_initialized: is_project_initialized
			not_synchronizing: not is_updating_tests
		deferred
		ensure
			done_synchronizing: not is_updating_tests
		end

	synchronize_with_class (a_class: !EIFFEL_CLASS_I)
			-- Synchronize `tests' with state of class.
			--
			-- `a_class': Class which `tests' will be synchronized against.
		require
			usable: is_interface_usable
			project_initialized: is_project_initialized
			not_updating: not is_updating_tests
			a_class_in_project: is_class_in_project (a_class)
		deferred
		ensure
			done_synchronizing: not is_updating_tests
		end

feature -- Element change

	register_locator (a_locator: !EIFFEL_TEST_CLASS_LOCATOR_I)
			-- Register locator for retrieving test classes.
		require
			usable: is_interface_usable
			not_registered: not is_locator_registered (a_locator)
		deferred
		ensure
			registered: is_locator_registered (a_locator)
		end

	unregister_locator (a_locator: !EIFFEL_TEST_CLASS_LOCATOR_I)
			-- Unregister locator.
		require
			usable: is_interface_usable
			registered: is_locator_registered (a_locator)
		deferred
		ensure
			not_registered: not is_locator_registered (a_locator)
		end

	add_test_cluster (a_name, a_path: !STRING; a_parent: ?CONF_CLUSTER) is
			-- Add a new testing cluster to `project'. Instance of new cluster will be available through
			-- `last_created_cluster'
			--
			-- `a_name': Name for new cluster.
			-- `a_path': Path of new cluster.
			-- `a_parent': Parent cluster, can be Void.
		require
			a_name_not_empty: a_name.is_empty
			usable: is_interface_usable
			project_available: is_project_initialized
			not_updating: not is_updating_tests
		do
		end

	add_class (a_path: !STRING; a_cluster: !CONF_CLUSTER)
			-- Make existing class file appear as class in system. Instance of new class will be available
			-- through `last_created_class'.
			--
			-- `a_path': Path relative to clusters path of class file.
			-- `a_cluster': Cluster in which class is located.
		require
			usable: is_interface_usable
			project_available: is_project_initialized
			not_updating: not is_updating_tests
		do
		end

	remove_class (a_class: !EIFFEL_CLASS_I)
			-- Remove class and file from system.
			--
			-- `a_class': Class to be removed
		require
			usable: is_interface_usable
			project_available: is_project_initialized
			not_updating: not is_updating_tests
			a_class_in_project: is_class_in_project (a_class)
		do
		end

feature {EIFFEL_TEST_CLASS_LOCATOR_I} -- Basic operations

	report_test_class (a_class: !EIFFEL_CLASS_I)
			-- Report class as potential test class
			--
			-- Note: Implementation of `report_test_class' should be protected against multiple reports for
			--       the same class.
			--
			-- `a_class': Class beeing a potential test class
		deferred
		end

end
