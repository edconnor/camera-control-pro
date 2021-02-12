/*************************************************************************************************
Copyright Nikon Electronic Imaging Department - All rights reserved
*************************************************************************************************/
#if defined( _MSC_VER ) && _MSC_VER >= 1600
	#include <stdint.h>
#else

// old difinition

#include <stddef.h>
#include <limits.h>
#include <signal.h>


#if ((defined(__STDC__) && __STDC__ && __STDC_VERSION__ >= 199901L) || (defined (__WATCOMC__) && (defined (_NKSTDINT_H_INCLUDED) || __WATCOMC__ >= 1250)) || (defined(__GNUC__) && (defined(_STDINT_H) || defined(_STDINT_H_)) )) && !defined (_NKSTDINT_H_INCLUDED)
#include <stdint.h>
#define _NKSTDINT_H_INCLUDED

/*
 *  Something really weird is going on with Open Watcom.  Just pull some of
 *  these duplicated definitions from Open Watcom's stdint.h file for now.
 */

#endif

#ifndef _NKSTDINT_H_INCLUDED
#define _NKSTDINT_H_INCLUDED

/*
 *  Deduce the type assignments from limits.h under the assumption that
 *  integer sizes in bits are powers of 2, and follow the ANSI
 *  definitions.
 */

#ifndef INT32_MAX
# define INT32_MAX (0x7fffffffL)
#endif
#ifndef INT32_MIN
# define INT32_MIN INT32_C(0x80000000)
#endif
#ifndef int32_t
#if (LONG_MAX == INT32_MAX) || defined (S_SPLINT_S)
	#ifndef _INT32_T
	#define _INT32_T
	typedef signed long int32_t;
	#endif
# define INT32_C(v) v ## L
# ifndef PRINTF_INT32_MODIFIER
#  define PRINTF_INT32_MODIFIER "l"
# endif
#elif (INT_MAX == INT32_MAX)
  typedef signed int int32_t;
# define INT32_C(v) v
# ifndef PRINTF_INT32_MODIFIER
#  define PRINTF_INT32_MODIFIER ""
# endif
#elif (SHRT_MAX == INT32_MAX)
  typedef signed short int32_t;
# define INT32_C(v) ((short) (v))
# ifndef PRINTF_INT32_MODIFIER
#  define PRINTF_INT32_MODIFIER ""
# endif
#else
#error "Platform not supported"
#endif
#endif

#endif //_NKSTDINT_H_INCLUDED

#endif // defined( _MSC_VER ) && _MSC_VER >= 1600
//================================================================================================