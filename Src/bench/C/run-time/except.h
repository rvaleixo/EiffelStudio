/*

 ######  #    #   ####   ######  #####    #####          #    #
 #        #  #   #    #  #       #    #     #            #    #
 #####     ##    #       #####   #    #     #            ######
 #         ##    #       #       #####      #     ###    #    #
 #        #  #   #    #  #       #          #     ###    #    #
 ######  #    #   ####   ######  #          #     ###    #    #

	Exception handling declarations.
*/

#ifndef _except_h
#define _except_h

#ifdef __cplusplus
extern "C" {
#endif

#include "eif_globals.h"
#include "portable.h"
#include "malloc.h"
#include "garcol.h"
#include <setjmp.h>
#ifdef __VMS
#define cma$tis_errno_get_addr CMA$TIS_ERRNO_GET_ADDR
	/* this routine is in the library in capital letters */
	/* need to redefine this before including errno.h */
#endif
#include <errno.h>    /* needed in error.c, except.c, retrieve.c */

/* Macros for easy access */
#define ex_jbuf		exu.exur.exur_jbuf
#define ex_id		exu.exur.exur_id
#define ex_rout		exu.exur.exur_rout
#define ex_orig		exu.exur.exur_orig
#define ex_sig		exu.exu_sig
#define ex_errno	exu.exu_errno
#define ex_lvl		exu.exu_lvl
#define ex_name		exu.exua.exua_name
#define ex_where	exu.exua.exua_where
#define ex_from		exu.exua.exua_from
#define ex_oid		exu.exua.exua_oid

/* Structure used to record general flags. These are the value to take into
 * account for the last exception that occurred, which might not be in the
 * stack yet if manually or system raised.
 */
struct eif_except {
	unsigned char ex_val;	/* Exception code (raised) */
	unsigned char ex_nomem;	/* An "Out of memory" exception occurred */
	unsigned char ex_nsig;	/* Number of last signal received */
	unsigned int ex_level;	/* Exception level (rescue branches) */
	unsigned char ex_org;	/* Original exception at this level */
 	char *ex_tag;			/* Assertion tag */
	char *ex_otag;			/* Tag associated with original exception */
	char *ex_rt;			/* Routine associated with current exception */
	char *ex_ort;			/* Routine associated with original exception */
	int ex_class;			/* Class associated with current exception */
	int ex_oclass;			/* Class associated with original exception */
};

/* Short names for easier access */
#define echmem		exdata.ex_nomem
#define echtg		exdata.ex_tag
#define echval		exdata.ex_val
#define echsig		exdata.ex_nsig
#define echlvl		exdata.ex_level
#define echorg		exdata.ex_org
#define echotag		exdata.ex_otag
#define echrt		exdata.ex_rt
#define echort		exdata.ex_ort
#define echclass	exdata.ex_class
#define echoclass	exdata.ex_oclass

/* Flags for ex_nomem */
#define MEM_FULL	0x01	/* A simple "Out of memory" condition */
#define MEM_FSTK	0x02	/* The exception trace stack is full */
#define MEM_PANIC	0x04	/* We are in panic mode */
#define MEM_FATAL	0x08	/* Fatal error has occurred */
#define MEM_SPEC	(MEM_PANIC | MEM_FATAL)		/* Disable longjmp flag */

/* Available types for execution vector. They start at EX_START and must NOT
 * conflict with EN_* constants for GC purposes. Also it is wise to keep them
 * below 127 to avoid sign extension--RAM.
 */
#define EX_START	100			/* First value for EX_* constants */
#define EX_CALL		100			/* Function call */
#define EX_PRE		101			/* Precondition checking */
#define EX_POST		102			/* Postcondition checking */
#define EX_CINV		103			/* Invariant checking (routine exit) */
#define EX_RESC		104			/* Rescue clause */
#define EX_RETY		105			/* Retried call */
#define EX_LINV		106			/* In loop invariant */
#define EX_VAR		107			/* In loop variant */
#define EX_CHECK	108			/* In check instruction */
#define EX_HDLR		109			/* In signal handler routine */
#define EX_INVC		110			/* Invariant checking (routine entrance) */
#define EX_OSTK		111			/* Run-time exception catching */

/* Predefined exception numbers. Value cannot start at 0 because this may need
 * a propagation via longjmp and USG implementations turn out a 0 to be 1.
 */
#define EN_VOID		1			/* Feature applied to void reference */
#define EN_MEM		2			/* No more memory */
#define EN_PRE		3			/* Pre-condition violated */
#define EN_POST		4			/* Post-condition violated */
#define EN_FLOAT	5			/* Floating point exception (signal SIGFPE) */
#define EN_CINV		6			/* Class invariant violated */
#define EN_CHECK	7			/* Assertion violated */
#define EN_FAIL		8			/* Routine failure */
#define EN_WHEN		9			/* Unmatched inspect value */
#define EN_VAR		10			/* Non-decreasing loop variant */
#define EN_LINV		11			/* Loop invariant violated */
#define EN_SIG		12			/* Operating system signal */
#define EN_BYE		13			/* Eiffel run-time panic */
#define EN_RESC		14			/* Exception in rescue clause */
#define EN_OMEM		15			/* Out of memory (cannot be ignored) */
#define EN_RES		16			/* Resumption failed (retry did not succeed) */
#define EN_CDEF		17			/* Create on deferred */
#define EN_EXT		18			/* External event */
#define EN_VEXP		19			/* Void assigned to expanded */
#define EN_HDLR		20			/* Exception in signal handler */
#define EN_IO		21			/* I/O error */
#define EN_SYS		22			/* Operating system error */
#define EN_RETR		23			/* Retrieval error */
#define EN_PROG		24			/* Developer exception */
#define EN_FATAL	25			/* Eiffel run-time fatal error */
#define EN_OSTK		97			/* Run-time exception catching */
#define EN_ILVL		98			/* In level: pseudo-type for execution trace */
#define EN_OLVL		99			/* Out level: pseudo-type for execution trace */
#ifndef WORKBENCH
#define EN_NEX		25			/* Number of internal exceptions */
#else
#define EN_DOL		26			/* $ applied to melted feature */
#endif

/* Exported routines (used by the generated C code or run-time) */
extern void expop(register1 struct xstack *stk);	/* Pops an execution vector off */
extern void eraise(EIF_CONTEXT char *tag, long num);			/* Raise an Eiffel exception */
extern void xraise(EIF_CONTEXT int code);			/* Raise an exception with no tag */
extern void eviol(EIF_CONTEXT_NOARG);			/* Eiffel violation of last assertion */
extern void enomem(EIF_CONTEXT_NOARG);			/* Raises an "Out of memory" exception */
extern struct ex_vect *exret(EIF_CONTEXT register1 struct ex_vect *rout_vect);	/* Retries execution of routine */
extern void exhdlr(EIF_CONTEXT Signal_t (*handler)(int), int sig);			/* Call signal handler */
extern void exinv(EIF_CONTEXT register2 char *tag, register3 char *object);			/* Invariant record */
extern void exasrt(EIF_CONTEXT char *tag, int type);			/* Assertion record */
extern void exfail(EIF_CONTEXT_NOARG);			/* Signals: reached end of a rescue clause */
extern void panic(EIF_CONTEXT char *msg);			/* Run-time raised panic */
extern void fatal_error(EIF_CONTEXT char *msg);			/* Run-time raised fatal errors */
extern void exok(EIF_CONTEXT_NOARG);				/* Resumption has been successful */
extern void esfail(EIF_CONTEXT_NOARG);			/* Eiffel system failure */
extern void ereturn(EIF_CONTEXT_NOARG);			/* Return to lastly recorded rescue entry */
extern struct ex_vect *exget(register2 struct xstack *stk);	/* Get a new vector on stack */
extern void excatch(EIF_CONTEXT char *jmp);			/* Set exception catcher from C to interpret */
extern void exresc(EIF_CONTEXT register2 struct ex_vect *rout_vect);			/* Signals entry in rescue clause */
#ifndef WORKBENCH
extern struct ex_vect *exft(void);	/* Set execution stack in final mode */
#endif
extern struct ex_vect *exset(EIF_CONTEXT char *name, int origin, char *object);	/* Set execution stack on routine entrance */
extern struct ex_vect *exnext(EIF_CONTEXT_NOARG);	/* Read next eif_trace item from bottom */

/* Routines for run-time usage only */
extern struct ex_vect *extop(register1 struct xstack *stk);	/* Top of Eiffel stack */
extern void esdie(int code);

/* Eiffel interface with class EXCEPTIONS */
extern long eeocode(EIF_CONTEXT_NOARG);			/* Original exception code */
extern char *eeotag(EIF_CONTEXT_NOARG);			/* Original exception tag */
extern char *eeoclass(EIF_CONTEXT_NOARG);		/* Original class where exception occurred */
extern char *eeorout(EIF_CONTEXT_NOARG);			/* Original routine where exception occurred */
extern long eelcode(EIF_CONTEXT_NOARG);			/* Last exception code */
extern char *eeltag(EIF_CONTEXT_NOARG);			/* Last exception tag */
extern char *eelclass(EIF_CONTEXT_NOARG);		/* Last class where exception occurred */
extern char *eelrout(EIF_CONTEXT_NOARG);			/* Last routine where exception occurred */
extern void eetrace(EIF_CONTEXT char b);			/* Print/No Print of exception history table */
extern void eecatch(EIF_CONTEXT long ex);			/* Catch exception */
extern void eeignore(EIF_CONTEXT long ex);			/* Ignore exception */
extern char *eename(long ex);			/* Exception description */

extern EIF_REFERENCE stack_trace_string(EIF_CONTEXT_NOARG);		/* Exception stack as an Eiffel string */

#ifdef __cplusplus
}
#endif

#endif
