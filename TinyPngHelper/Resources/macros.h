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

// Colors
#define RSColorFromRGBA(rgbValue, alp) [NSColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]
#define RSColorFromRGB(rgbValue) RSColorFromRGBA(rgbValue, 1.0)

#define WEAKSELF __weak typeof (self) weakSelf = self;

// Masonry
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#define RS_INIT_UNAVAILABLE - (instancetype)init NS_UNAVAILABLE; \
+ (instancetype)new NS_UNAVAILABLE;

#endif /* macros_h */
