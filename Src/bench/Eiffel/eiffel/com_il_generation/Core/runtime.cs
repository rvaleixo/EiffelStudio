/*
indexing
	description: "Set of features needed by the Eiffel compiler and Eiffel libraries
		to work properly"
	date: "$Date$"
	revision: "$Revision$"
*/
	
using System;
namespace ISE.Runtime {

	public abstract class ANY {
		public object c_standard_clone () {
			return MemberwiseClone();
		}

		~ANY () {
		}
	}

	public delegate int WEL_DISPATCHER_DELEGATE (IntPtr hwnd, int msg, int wparam, int lparam);
	public delegate void EV_PIXMAP_IMP_DELEGATE (int error_code, int data_type, int pixmap_width,
		int pixmap_height, IntPtr rgb_data, IntPtr alpha_data);

	public class RUN_TIME
	{
		public static bool in_assertion;
				// Flag used during assertion checking to make sure
				// that assertions are not checked within an assertion
				// checking.

		public static string assertion_tag;
				// Tag of last checked assertion


		public static bool is_assertion_checked = true;
				// Are assertions checked?

		public static bool check_assert (bool val) {
				// Enable or disable checking of assertions?
			bool tmp = is_assertion_checked;
			is_assertion_checked = val;
			return tmp;
		}

		public static int generic_parameter_count (object o) {
				// Number of generic Parameter if any.
			_EIFFEL_TYPE_INFO gen;		
			if (o is _EIFFEL_TYPE_INFO) {
				gen = (_EIFFEL_TYPE_INFO) o;
				return gen.____type_id();
			} else {
				return 0;
			}
		}
	}

	public class EXCEPTION_MANAGER
	{
		public EXCEPTION_MANAGER()
		{
		}

		public static Exception last_exception;
				// Last raised exception in `rescue' clause.

		public static void raise (Exception e) {
			throw e;
		}

	}
}

