//
//  macros.h
//  TinyPngHelper
//
//  Created by lumeng on 5/20/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#ifndef macros_h
#define macros_h

#define RS_INIT_UNAVAILABLE - (instancetype)init NS_UNAVAILABLE; \
+ (instancetype)new NS_UNAVAILABLE;

#define RS_DOWNWARN_PROTOTYPES _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wstrict-prototypes\"")

#endif /* macros_h */
