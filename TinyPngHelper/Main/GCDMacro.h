//
//  GCDMacro.h
//  TinyPngHelper
//
//  Created by lumeng on 6/12/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <pthread.h>

#ifndef GCDMacro_h
#define GCDMacro_h

#ifdef _cplusplus
#define RS_EXTERN_C_BEGIN extern "C" {
#define RS_EXTERN_C_END }
#else
#define RS_EXTERN_C_BEGIN
#define RS_EXTERN_C_END
#endif

RS_EXTERN_C_BEGIN

static inline void dispatch_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

RS_EXTERN_C_END

#endif /* GCDMacro_h */
