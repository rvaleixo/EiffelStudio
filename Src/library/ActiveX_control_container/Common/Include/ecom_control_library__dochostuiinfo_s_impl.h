/*-----------------------------------------------------------
"Automatically generated by the EiffelCOM Wizard."Added Record _DOCHOSTUIINFO
	cbSize: ULONG
			-- No description available.
	dwFlags: ULONG
			-- No description available.
	dwDoubleClick: ULONG
			-- No description available.
	pchHostCss: Pointed Type
			-- No description available.
	pchHostNS: Pointed Type
			-- No description available.
	
-----------------------------------------------------------*/

#ifndef __ECOM_CONTROL_LIBRARY__DOCHOSTUIINFO_S_IMPL_H__
#define __ECOM_CONTROL_LIBRARY__DOCHOSTUIINFO_S_IMPL_H__

#include "eif_com.h"

#include "eif_eiffel.h"

#include "ecom_control_library__DOCHOSTUIINFO_s.h"

#include "ecom_grt_globals_control_interfaces2.h"

#ifdef __cplusplus
extern "C" {
#endif



#ifdef __cplusplus

#define ccom_x_dochostuiinfo_cb_size(_ptr_) (EIF_INTEGER)(ULONG)(((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->cbSize)

#define ccom_x_dochostuiinfo_set_cb_size(_ptr_, _field_) ((((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->cbSize) = (ULONG)_field_)

#define ccom_x_dochostuiinfo_dw_flags(_ptr_) (EIF_INTEGER)(ULONG)(((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->dwFlags)

#define ccom_x_dochostuiinfo_set_dw_flags(_ptr_, _field_) ((((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->dwFlags) = (ULONG)_field_)

#define ccom_x_dochostuiinfo_dw_double_click(_ptr_) (EIF_INTEGER)(ULONG)(((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->dwDoubleClick)

#define ccom_x_dochostuiinfo_set_dw_double_click(_ptr_, _field_) ((((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->dwDoubleClick) = (ULONG)_field_)

#define ccom_x_dochostuiinfo_pch_host_css(_ptr_) (EIF_REFERENCE)(rt_ce.ccom_ce_pointed_short (((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->pchHostCss, NULL))

#define ccom_x_dochostuiinfo_set_pch_host_css(_ptr_, _field_) (grt_ce_control_interfaces2.ccom_free_memory_pointed_463(((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->pchHostCss), (((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->pchHostCss) = rt_ec.ccom_ec_pointed_short (eif_access (_field_), NULL))

#define ccom_x_dochostuiinfo_pch_host_ns(_ptr_) (EIF_REFERENCE)(rt_ce.ccom_ce_pointed_short (((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->pchHostNS, NULL))

#define ccom_x_dochostuiinfo_set_pch_host_ns(_ptr_, _field_) (grt_ce_control_interfaces2.ccom_free_memory_pointed_464(((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->pchHostNS), (((ecom_control_library::_DOCHOSTUIINFO *)_ptr_)->pchHostNS) = rt_ec.ccom_ec_pointed_short (eif_access (_field_), NULL))

#endif
#ifdef __cplusplus
}
#endif

#endif