/*-----------------------------------------------------------
"Automatically generated by the EiffelCOM Wizard."Added Record tagFORMATETC
	cfFormat: typedef
			-- No description available.
	ptd: Pointed Type
			-- No description available.
	dwAspect: ULONG
			-- No description available.
	lindex: LONG
			-- No description available.
	tymed: ULONG
			-- No description available.
	
-----------------------------------------------------------*/

#ifndef __ECOM_CONTROL_LIBRARY_TAGFORMATETC_S_H__
#define __ECOM_CONTROL_LIBRARY_TAGFORMATETC_S_H__
#ifdef __cplusplus
extern "C" {
#endif


namespace ecom_control_library
{
struct tagtagFORMATETC;
typedef struct ecom_control_library::tagtagFORMATETC tagFORMATETC;
}

namespace ecom_control_library
{
struct tagtagDVTARGETDEVICE;
typedef struct ecom_control_library::tagtagDVTARGETDEVICE tagDVTARGETDEVICE;
}

#ifdef __cplusplus
}
#endif

#include "eif_com.h"

#include "eif_eiffel.h"

#include "ecom_aliases.h"

#ifdef __cplusplus
extern "C" {
#endif



namespace ecom_control_library
{
struct tagtagFORMATETC
{	ecom_control_library::wireCLIPFORMAT cfFormat;
	ecom_control_library::tagDVTARGETDEVICE * ptd;
	ULONG dwAspect;
	LONG lindex;
	ULONG tymed;
};
}
#ifdef __cplusplus
}
#endif

#endif