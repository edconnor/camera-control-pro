/*************************************************************************************************
Copyright Nikon Electronic Imaging Department - All rights reserved
*************************************************************************************************/

#pragma once

// Alignment macro for variable declaration. To declare an array of eight
// unsigned 16-bit values aligned on a 16-byte boundry:
//		DECLARE_ALIGNED( unsigned short val[8], 16 );
#ifdef _MSC_VER
#	define DECLARE_ALIGNED(decl,n) __declspec(align(n)) decl
#elif (__GNUC__)
#	define DECLARE_ALIGNED(decl,n) decl __attribute__ ((aligned(n))
#endif

//	endian and CPU macro definitions
#if !defined( __LITTLE_ENDIAN__ ) && !defined( __BIG_ENDIAN__ )
#	ifdef _MSC_VER
#		if defined( _M_IX86 ) || defined( _M_X64 )	//	x86 processors (32-bit and 64-bit)
#			define __LITTLE_ENDIAN__		1
#			define TARGET_CPU_PPC			0
#			define TARGET_CPU_PPC64			0
#			if defined( _M_X64 )	//	x86 processors (32-bit and 64-bit)
#				define TARGET_CPU_X86			0
#				define TARGET_CPU_X86_64		1
#			else
#				define TARGET_CPU_X86			1
#				define TARGET_CPU_X86_64		0
#			endif
#		else
#			error Unsupported CPU type.
#		endif
#	elif defined( macintosh ) || (__APPLE__)
#		error __LITTLE_ENDIAN__ or __BIG_ENDIAN__ should be defined for all Mac compilers. Talk to Dave.
		//	The TARGET_CPU_PPC & TARGET_CPU_X86 macros should also be defined on the Mac.
		//	If they aren't then we'll need to include either TargetConditionals.h (Mach-o/BSD) or
		//	ConditionalMacros.h (CFM/MSL).
#	else
#		error Unknown and unsupported platform, cannot determine endianness.
#	endif
#endif

enum eEndian
{
	kEndian_Little,
	kEndian_Big
};

#if !defined( TARGET_32_BIT ) || !defined( TARGET_64_BIT )
#	ifdef _WIN32
#		if defined( _M_X64 )		// 64-bit
#			define TARGET_32_BIT	0
#			define TARGET_64_BIT	1
#		elif defined( _M_IX86 )		// 32-bit
#			define TARGET_32_BIT	1
#			define TARGET_64_BIT	0
#		else
#			error Unsupported CPU type.
#		endif
#	elif defined( macintosh ) || (__APPLE__)
#		if defined( __LP64__ )		// 64-bit
#			define TARGET_32_BIT	0
#			define TARGET_64_BIT	1
#		else						// 32-bit
#			define TARGET_32_BIT	1
#			define TARGET_64_BIT	0
#		endif
#	else
#		error Unknown and unsupported platform, cannot determine bitness.
#	endif
#endif

//================================================================================================